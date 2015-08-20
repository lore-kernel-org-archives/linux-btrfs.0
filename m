Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:28580 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752023AbbHTBHI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Aug 2015 21:07:08 -0400
Subject: Re: [PATCH v5 04/18] btrfs: Add threshold workqueue based on kernel
 workqueue
To: Alex Lyakas <alex.btrfs@zadarastorage.com>
References: <1393555579-11271-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1393555579-11271-5-git-send-email-quwenruo@cn.fujitsu.com>
 <CAOcd+r0FesMfiKTSW2CrG68yp=ZRgA+6LaBBda5H_PU1JuZbdA@mail.gmail.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <55D52835.5000108@cn.fujitsu.com>
Date: Thu, 20 Aug 2015 09:07:01 +0800
MIME-Version: 1.0
In-Reply-To: <CAOcd+r0FesMfiKTSW2CrG68yp=ZRgA+6LaBBda5H_PU1JuZbdA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Alex.

Thanks for the review.
Comment inlined below.

Alex Lyakas wrote on 2015/08/19 18:46 +0200:
> Hi Qu,
>
>
> On Fri, Feb 28, 2014 at 4:46 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>> The original btrfs_workers has thresholding functions to dynamically
>> create or destroy kthreads.
>>
>> Though there is no such function in kernel workqueue because the worker
>> is not created manually, we can still use the workqueue_set_max_active
>> to simulated the behavior, mainly to achieve a better HDD performance by
>> setting a high threshold on submit_workers.
>> (Sadly, no resource can be saved)
>>
>> So in this patch, extra workqueue pending counters are introduced to
>> dynamically change the max active of each btrfs_workqueue_struct, hoping
>> to restore the behavior of the original thresholding function.
>>
>> Also, workqueue_set_max_active use a mutex to protect workqueue_struct,
>> which is not meant to be called too frequently, so a new interval
>> mechanism is applied, that will only call workqueue_set_max_active after
>> a count of work is queued. Hoping to balance both the random and
>> sequence performance on HDD.
>>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> Tested-by: David Sterba <dsterba@suse.cz>
>> ---
>> Changelog:
>> v2->v3:
>>    - Add thresholding mechanism to simulate the old thresholding mechanism.
>>    - Will not enable thresholding when thresh is set to small value.
>> v3->v4:
>>    None
>> v4->v5:
>>    None
>> ---
>>   fs/btrfs/async-thread.c | 107 ++++++++++++++++++++++++++++++++++++++++++++----
>>   fs/btrfs/async-thread.h |   3 +-
>>   2 files changed, 101 insertions(+), 9 deletions(-)
>>
>> diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
>> index 193c849..977bce2 100644
>> --- a/fs/btrfs/async-thread.c
>> +++ b/fs/btrfs/async-thread.c
>> @@ -30,6 +30,9 @@
>>   #define WORK_ORDER_DONE_BIT 2
>>   #define WORK_HIGH_PRIO_BIT 3
>>
>> +#define NO_THRESHOLD (-1)
>> +#define DFT_THRESHOLD (32)
>> +
>>   /*
>>    * container for the kthread task pointer and the list of pending work
>>    * One of these is allocated per thread.
>> @@ -737,6 +740,14 @@ struct __btrfs_workqueue_struct {
>>
>>          /* Spinlock for ordered_list */
>>          spinlock_t list_lock;
>> +
>> +       /* Thresholding related variants */
>> +       atomic_t pending;
>> +       int max_active;
>> +       int current_max;
>> +       int thresh;
>> +       unsigned int count;
>> +       spinlock_t thres_lock;
>>   };
>>
>>   struct btrfs_workqueue_struct {
>> @@ -745,19 +756,34 @@ struct btrfs_workqueue_struct {
>>   };
>>
>>   static inline struct __btrfs_workqueue_struct
>> -*__btrfs_alloc_workqueue(char *name, int flags, int max_active)
>> +*__btrfs_alloc_workqueue(char *name, int flags, int max_active, int thresh)
>>   {
>>          struct __btrfs_workqueue_struct *ret = kzalloc(sizeof(*ret), GFP_NOFS);
>>
>>          if (unlikely(!ret))
>>                  return NULL;
>>
>> +       ret->max_active = max_active;
>> +       atomic_set(&ret->pending, 0);
>> +       if (thresh == 0)
>> +               thresh = DFT_THRESHOLD;
>> +       /* For low threshold, disabling threshold is a better choice */
>> +       if (thresh < DFT_THRESHOLD) {
>> +               ret->current_max = max_active;
>> +               ret->thresh = NO_THRESHOLD;
>> +       } else {
>> +               ret->current_max = 1;
>> +               ret->thresh = thresh;
>> +       }
>> +
>>          if (flags & WQ_HIGHPRI)
>>                  ret->normal_wq = alloc_workqueue("%s-%s-high", flags,
>> -                                                max_active, "btrfs", name);
>> +                                                ret->max_active,
>> +                                                "btrfs", name);
>>          else
>>                  ret->normal_wq = alloc_workqueue("%s-%s", flags,
>> -                                                max_active, "btrfs", name);
>> +                                                ret->max_active, "btrfs",
>> +                                                name);
> Shouldn't we use ret->current_max instead of ret->max_active (in both calls)?
> According to the rest of the code, "max_active" is the absolute
> maximum beyond which the "normal_wq" cannot go (you use clamp_value to
> ensure that). And "current_max" is the current value of "max_active"
> of the "normal_wq". But here, you set the "normal_wq" to "max_active"
> immediately. Is this intentional?
Yes, as you mentioned max_active is the up limit of the concurrency, and 
current_max is the current value of concurrency.

And, yes, it should be ret->current_max.
It doesn't match with previous 'ret->current_max = 1' line, as the 
policy is set max_active to minimal and let it grow if needed, to save 
some resource.

If rec->current_max is also set to max_active, then I may have an excuse 
to say alloc as many workqueues as possible at beginning to improve 
performance.

Nice catch.

Thanks,
Qu
>
>
>>          if (unlikely(!ret->normal_wq)) {
>>                  kfree(ret);
>>                  return NULL;
>> @@ -765,6 +791,7 @@ static inline struct __btrfs_workqueue_struct
>>
>>          INIT_LIST_HEAD(&ret->ordered_list);
>>          spin_lock_init(&ret->list_lock);
>> +       spin_lock_init(&ret->thres_lock);
>>          return ret;
>>   }
>>
>> @@ -773,7 +800,8 @@ __btrfs_destroy_workqueue(struct __btrfs_workqueue_struct *wq);
>>
>>   struct btrfs_workqueue_struct *btrfs_alloc_workqueue(char *name,
>>                                                       int flags,
>> -                                                    int max_active)
>> +                                                    int max_active,
>> +                                                    int thresh)
>>   {
>>          struct btrfs_workqueue_struct *ret = kzalloc(sizeof(*ret), GFP_NOFS);
>>
>> @@ -781,14 +809,15 @@ struct btrfs_workqueue_struct *btrfs_alloc_workqueue(char *name,
>>                  return NULL;
>>
>>          ret->normal = __btrfs_alloc_workqueue(name, flags & ~WQ_HIGHPRI,
>> -                                             max_active);
>> +                                             max_active, thresh);
>>          if (unlikely(!ret->normal)) {
>>                  kfree(ret);
>>                  return NULL;
>>          }
>>
>>          if (flags & WQ_HIGHPRI) {
>> -               ret->high = __btrfs_alloc_workqueue(name, flags, max_active);
>> +               ret->high = __btrfs_alloc_workqueue(name, flags, max_active,
>> +                                                   thresh);
>>                  if (unlikely(!ret->high)) {
>>                          __btrfs_destroy_workqueue(ret->normal);
>>                          kfree(ret);
>> @@ -798,6 +827,66 @@ struct btrfs_workqueue_struct *btrfs_alloc_workqueue(char *name,
>>          return ret;
>>   }
>>
>> +/*
>> + * Hook for threshold which will be called in btrfs_queue_work.
>> + * This hook WILL be called in IRQ handler context,
>> + * so workqueue_set_max_active MUST NOT be called in this hook
>> + */
>> +static inline void thresh_queue_hook(struct __btrfs_workqueue_struct *wq)
>> +{
>> +       if (wq->thresh == NO_THRESHOLD)
>> +               return;
>> +       atomic_inc(&wq->pending);
>> +}
>> +
>> +/*
>> + * Hook for threshold which will be called before executing the work,
>> + * This hook is called in kthread content.
>> + * So workqueue_set_max_active is called here.
>> + */
>> +static inline void thresh_exec_hook(struct __btrfs_workqueue_struct *wq)
>> +{
>> +       int new_max_active;
>> +       long pending;
>> +       int need_change = 0;
>> +
>> +       if (wq->thresh == NO_THRESHOLD)
>> +               return;
>> +
>> +       atomic_dec(&wq->pending);
>> +       spin_lock(&wq->thres_lock);
>> +       /*
>> +        * Use wq->count to limit the calling frequency of
>> +        * workqueue_set_max_active.
>> +        */
>> +       wq->count++;
>> +       wq->count %= (wq->thresh / 4);
>> +       if (!wq->count)
>> +               goto  out;
>> +       new_max_active = wq->current_max;
>> +
>> +       /*
>> +        * pending may be changed later, but it's OK since we really
>> +        * don't need it so accurate to calculate new_max_active.
>> +        */
>> +       pending = atomic_read(&wq->pending);
>> +       if (pending > wq->thresh)
>> +               new_max_active++;
>> +       if (pending < wq->thresh / 2)
>> +               new_max_active--;
>> +       new_max_active = clamp_val(new_max_active, 1, wq->max_active);
>> +       if (new_max_active != wq->current_max)  {
>> +               need_change = 1;
>> +               wq->current_max = new_max_active;
>> +       }
>> +out:
>> +       spin_unlock(&wq->thres_lock);
>> +
>> +       if (need_change) {
>> +               workqueue_set_max_active(wq->normal_wq, wq->current_max);
> Here you se the "normal_wq" max_active to "current_max", but not when
> the normal workqueue has been created initially.
>> +       }
>> +}
>> +
>>   static void run_ordered_work(struct __btrfs_workqueue_struct *wq)
>>   {
>>          struct list_head *list = &wq->ordered_list;
>> @@ -858,6 +947,7 @@ static void normal_work_helper(struct work_struct *arg)
>>                  need_order = 1;
>>          wq = work->wq;
>>
>> +       thresh_exec_hook(wq);
>>          work->func(work);
>>          if (need_order) {
>>                  set_bit(WORK_DONE_BIT, &work->flags);
>> @@ -884,6 +974,7 @@ static inline void __btrfs_queue_work(struct __btrfs_workqueue_struct *wq,
>>          unsigned long flags;
>>
>>          work->wq = wq;
>> +       thresh_queue_hook(wq);
>>          if (work->ordered_func) {
>>                  spin_lock_irqsave(&wq->list_lock, flags);
>>                  list_add_tail(&work->ordered_list, &wq->ordered_list);
>> @@ -922,9 +1013,9 @@ void btrfs_destroy_workqueue(struct btrfs_workqueue_struct *wq)
>>
>>   void btrfs_workqueue_set_max(struct btrfs_workqueue_struct *wq, int max)
>>   {
>> -       workqueue_set_max_active(wq->normal->normal_wq, max);
>> +       wq->normal->max_active = max;
>>          if (wq->high)
>> -               workqueue_set_max_active(wq->high->normal_wq, max);
>> +               wq->high->max_active = max;
>>   }
>>
>>   void btrfs_set_work_high_priority(struct btrfs_work_struct *work)
>> diff --git a/fs/btrfs/async-thread.h b/fs/btrfs/async-thread.h
>> index fce623c..3129d8a 100644
>> --- a/fs/btrfs/async-thread.h
>> +++ b/fs/btrfs/async-thread.h
>> @@ -138,7 +138,8 @@ struct btrfs_work_struct {
>>
>>   struct btrfs_workqueue_struct *btrfs_alloc_workqueue(char *name,
>>                                                       int flags,
>> -                                                    int max_active);
>> +                                                    int max_active,
>> +                                                    int thresh);
>>   void btrfs_init_work(struct btrfs_work_struct *work,
>>                       void (*func)(struct btrfs_work_struct *),
>>                       void (*ordered_func)(struct btrfs_work_struct *),
>> --
>> 1.9.0
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> Thanks,
> Alex.
>
