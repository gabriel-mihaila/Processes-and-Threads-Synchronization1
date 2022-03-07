#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#include <pthread.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <semaphore.h>
#include "a2_helper.h"


typedef struct 
{
    int thread_id;
    sem_t *logSemStart; //cu referire la threadul2
    sem_t *logSemEnd; //cu referire la threadul3

}TH_STRUCT_3;

typedef struct 
{
    int thread_id;
    sem_t *logSemMutex; // pe post de lock
    sem_t *logSemBarrier; // permite sa treaca doar 4 threaduri simultan

}TH_STRUCT_4;

typedef struct 
{
   int thread_id;

}TH_STRUCT_5;


int validate, cond;

void* thread_fn_ex3(void* param)
{
    TH_STRUCT_3 *s = (TH_STRUCT_3*)param;
    sem_t *logSemP3;

    if(s->thread_id == 2){
        sem_wait(s->logSemStart);
        info(BEGIN, 3, s->thread_id);
        info(END, 3, s->thread_id);
        sem_post(s->logSemEnd);
    }
    else
    {
        if(s->thread_id == 3) {
            info(BEGIN, 3, s->thread_id);
            sem_post(s->logSemStart);
            sem_wait(s->logSemEnd);
            info(END, 3, s->thread_id);
           
        }
        else
        {
            if(s->thread_id == 1)
            {
                //lucram cu semafoare cu nume ce se pot vedea in procese diferite
                logSemP3 = sem_open("semaforP3", O_CREAT, 0644, 0);
                sem_wait(logSemP3);
                sem_unlink("semaforP3");
                sem_close(logSemP3);
                info(BEGIN, 3, s->thread_id);
                info(END, 3, s->thread_id); 
                logSemP3 = sem_open("semaforP2", O_CREAT, 0644, 0);
                sem_post(logSemP3);
                sem_close(logSemP3);
            }
            else
            {
                info(BEGIN, 3, s->thread_id);
                info(END, 3, s->thread_id); 
            }
            
        }
    }

    return NULL;
}

void* thread_fn_ex4(void* param)
{
    TH_STRUCT_4 *s = (TH_STRUCT_4*)param;
    int nr_perm;

    if(s->thread_id == 10)
    {
        validate = 1; //ma asigur ca T10 intra primul
        sem_wait(s->logSemBarrier);
        info(BEGIN, 7, s->thread_id);
        sem_wait(s->logSemMutex);
        info(END, 7, s->thread_id);
        cond = 1; //le da drumul celorlalte thread-uri pt ca T10 e finalizat
        sem_post(s->logSemBarrier);
    }
    else
    {
        while(!validate);
        sem_getvalue(s->logSemBarrier, &nr_perm);
        if(nr_perm == 0){
            sem_post(s->logSemMutex);
        }
        sem_wait(s->logSemBarrier);
        info(BEGIN, 7, s->thread_id);
        while(!cond);
        info(END, 7, s->thread_id);
        sem_post(s->logSemBarrier);
    }

    return NULL;
}

void* thread_fn_ex5(void* param)
{
    TH_STRUCT_5 *s = (TH_STRUCT_5*)param;
    sem_t *logSemP2;

    if(s->thread_id == 1)
    {
        info(BEGIN, 2, s->thread_id);
        info(END, 2, s->thread_id);
        logSemP2 = sem_open("semaforP3", O_CREAT, 0644, 0);
        sem_post(logSemP2);
        sem_close(logSemP2);
    }
    else
    {
        
        if(s->thread_id == 2){
           logSemP2 = sem_open("semaforP2", O_CREAT, 0644, 0);
           sem_wait(logSemP2);
           sem_unlink("semaforP2");
           sem_close(logSemP2);
        }

        info(BEGIN, 2, s->thread_id);
        info(END, 2, s->thread_id);
    }

    return NULL;
}


int main(){
    init();

    int pid2, pid3, pid4, pid5, pid6, pid7;

    info(BEGIN, 1, 0);

    pid2 = fork();

    if(pid2 == 0)
    {
        info(BEGIN, 2, 0);

        pid3 = fork();
        if(pid3 == 0)
        {
            info(BEGIN, 3, 0);
            int nr_threads = 4;
            sem_t logSem[2];
           
            TH_STRUCT_3 params[nr_threads];
            pthread_t tid[nr_threads];
            
            if(sem_init(&logSem[0], 0, 0) != 0)
            {
                perror("Could not initialize the semaphore!\n");
                exit(-1);
            }
            
            if(sem_init(&logSem[1], 0, 0) != 0)
            {
                perror("Could not initialize the semaphore!\n");
                exit(-1);
            }
            
            for(int i = 0; i < nr_threads; i++)
            {
                params[i].logSemStart = &logSem[0];
                params[i].logSemEnd = &logSem[1];
                params[i].thread_id = i + 1;
                pthread_create(&tid[i], NULL, thread_fn_ex3, &params[i]);
            }

            for(int i = 0; i< nr_threads; i++){
                pthread_join(tid[i], NULL);
            }

            for(int i = 0; i < 2; i++){
                sem_destroy(&logSem[i]);
            }

            info(END, 3, 0);
        }
        else
        {
            pid6 = fork();

            if(pid6 == 0)
            {
                info(BEGIN, 6, 0);

                pid7 = fork();
                if(pid7 == 0)
                {
                    info(BEGIN, 7, 0);
                    int nr_threads = 42;
                    sem_t logSem[2];

                    TH_STRUCT_4 params[nr_threads];
                    pthread_t tid[nr_threads];

                    validate = 0;
                    cond = 0;
                    if(sem_init(&logSem[0], 0, 0) != 0) //logSemMutex
                    {
                        perror("Could not initialize the semaphore!\n");
                        exit(-1);
                    }

                    if(sem_init(&logSem[1], 0, 4) != 0) //logSemBarrier
                    {
                        perror("Could not initialize the semaphore!\n");
                        exit(-1);   
                    } 

                    for(int i = 0; i < nr_threads; i++)
                    {
                        params[i].logSemMutex = &logSem[0];
                        params[i].logSemBarrier = &logSem[1];
                        params[i].thread_id = i + 1;
                        pthread_create(&tid[i], NULL, thread_fn_ex4, &params[i]);
                    }
                    for(int i = 0; i< nr_threads; i++){
                        pthread_join(tid[i], NULL);
                    }

                    for(int i = 0; i < 2; i++){
                        sem_destroy(&logSem[i]);
                    }

                    info(END, 7, 0);
                }
                else
                {
                    waitpid(pid7, NULL, 0);
                    info(END, 6, 0);
                }
                
            }
            else
            {
                int nr_threads_p2 = 4;

                TH_STRUCT_5 params_p2[nr_threads_p2];
                pthread_t tid_p2[nr_threads_p2];

                for(int i = 0; i < nr_threads_p2; i++)
                {
                    params_p2[i].thread_id = i + 1;
                    pthread_create(&tid_p2[i], NULL, thread_fn_ex5, &params_p2[i]);
                }

                for(int i = 0; i< nr_threads_p2; i++){
                    pthread_join(tid_p2[i], NULL);
                }

                //waitpid-urile mereu la final
                waitpid(pid3, NULL, 0);
                waitpid(pid6, NULL, 0);
                info(END, 2, 0);
            }
        }

    }
    else
    {
        pid4 = fork();
        if(pid4 == 0)
        {
            info(BEGIN, 4, 0);

            info(END, 4, 0);
        }
        else
        {
            pid5 = fork();

            if(pid5 == 0)
            {
                info(BEGIN, 5, 0);

                info(END, 5, 0);
            }
            else
            {
                waitpid(pid2, NULL, 0);
                waitpid(pid4, NULL, 0);
                waitpid(pid5, NULL, 0);

                info(END, 1, 0);
            }
        }
    }

    return 0;
}
