Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:4689 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755577AbdCUC3W (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Mar 2017 22:29:22 -0400
Subject: Re: [PATCH 4/5] btrfs: raid56: Don't keep rbio for later steal
To: <bo.li.liu@oracle.com>
References: <20170203082023.3577-1-quwenruo@cn.fujitsu.com>
 <20170203082023.3577-5-quwenruo@cn.fujitsu.com>
 <20170317044407.GA24387@lim.localdomain>
 <bfaf7a7e-2330-0419-9549-7c37f2b1f93d@cn.fujitsu.com>
 <20170318020304.GB7719@lim.localdomain>
 <c8fcddef-6bb6-57cc-2980-7a5b28018e2e@cn.fujitsu.com>
 <20170320202333.GB5540@lim.localdomain>
 <3d096455-0302-f34d-719d-b3445d2451a1@cn.fujitsu.com>
 <20170321020841.GK5540@lim.localdomain>
CC: <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <041f7b28-2bff-0414-b862-27a2cad4774c@cn.fujitsu.com>
Date: Tue, 21 Mar 2017 10:23:56 +0800
MIME-Version: 1.0
In-Reply-To: <20170321020841.GK5540@lim.localdomain>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 03/21/2017 10:08 AM, Liu Bo wrote:
> On Tue, Mar 21, 2017 at 08:44:18AM +0800, Qu Wenruo wrote:
>>
>>
>> At 03/21/2017 04:23 AM, Liu Bo wrote:
>>> On Mon, Mar 20, 2017 at 02:21:48PM +0800, Qu Wenruo wrote:
>>>>
>>>>
>>>> At 03/18/2017 10:03 AM, Liu Bo wrote:
>>>>> On Fri, Mar 17, 2017 at 01:28:45PM +0800, Qu Wenruo wrote:
>>>>>>
>>>>>>
>>>>>> At 03/17/2017 12:44 PM, Liu Bo wrote:
>>>>>>> On Fri, Feb 03, 2017 at 04:20:22PM +0800, Qu Wenruo wrote:
>>>>>>>> Before this patch, btrfs raid56 will keep raid56 rbio even all its IO is
>>>>>>>> done.
>>>>>>>> This may save some time allocating rbio, but it can cause deadly
>>>>>>>> use-after-free bug, for the following case:
>>>>>>>>
>>>>>>>> Original fs: 4 devices RAID5
>>>>>>>>
>>>>>>>>        Process A                 |          Process B
>>>>>>>> --------------------------------------------------------------------------
>>>>>>>>                                  |  Start device replace
>>>>>>>>                                  |    Now the fs has 5 devices
>>>>>>>>                                  |    devid 0: replace device
>>>>>>>>                                  |    devid 1~4: old devices
>>>>>>>> btrfs_map_bio()                  |
>>>>>>>> |- __btrfs_map_block()           |
>>>>>>>> |    bbio has 5 stripes          |
>>>>>>>> |    including devid 0           |
>>>>>>>> |- raid56_parity_write()         |
>>>>>>>>                                  |
>>>>>>>> raid_write_end_io()              |
>>>>>>>> |- rbio_orig_end_io()            |
>>>>>>>>    |- unlock_stripe()            |
>>>>>>>>        Keeps the old rbio for    |
>>>>>>>>        later steal, which has    |
>>>>>>>>        stripe for devid 0        |
>>>>>>>>                                  |  Cancel device replace
>>>>>>>>                                  |    Now the fs has 4 devices
>>>>>>>>                                  |    devid 0 is freed
>>>>>>>> Some IO happens                  |
>>>>>>>> raid_write_end_io()              |
>>>>>>>> |- rbio_orig_end_io()            |
>>>>>>>>    |- unlock_stripe()            |
>>>>>>>>       |- steal_rbio()            |
>>>>>>>>            Use old rbio, whose   |
>>>>>>>>            bbio has freed devid 0|
>>>>>>>>            stripe                |
>>>>>>>> Any access to rbio->bbio will    |
>>>>>>>> cause general protection or NULL |
>>>>>>>> pointer dereference              |
>>>>>>>>
>>>>>>>> Such bug can already be triggered by fstests btrfs/069 for RAID5/6
>>>>>>>> profiles.
>>>>>>>>
>>>>>>>> Fix it by not keeping old rbio in unlock_stripe(), so we just free the
>>>>>>>> finished rbio and rbio->bbio, so above problem wont' happen.
>>>>>>>>
>>>>>>>
>>>>>>> I don't think this is acceptable, keeping a cache is important for
>>>>>>> raid56 write performance, could you please fix it by checking if the
>>>>>>> device is missing?
>>>>>>
>>>>>> Not possible, as it's keeping the btrfs_device pointer and never release it,
>>>>>> the stolen rbio can be kept forever until umount.
>>>>>>
>>>>>
>>>>> steal_rbio() only takes pages from rbio->stripe_pages, so the cached
>>>>> rbio->bbio is not going to the next IO's rbio because the cached one
>>>>> got freed immediately in steal_rbio(), where could we dereference
>>>>> rbio->bbio?
>>>>
>>>> Did you mean in unlock_stripe(), we still keep the rbio in cache, while
>>>> release its bbio?
>>>>
>>>
>>> I thought it was lock_stripe_add(), OK, so unlock_stripe() just caches
>>> the current rbio and doens't free it.  But the point about
>>> steal_rbio() still stands, steal_rbio() is supposed to take uptodate
>>> pages from the cached old rbio to the current processing rbio, but it
>>> doesn't touch the cached old rbio's bbio, nor uses the cached old rbio
>>> afterwards, instead it is the current processing rbio that would use
>>> its bbio for writing into target devices, but it has increased its own
>>> bio_counter.
>>>
>>>> This sounds quite good but I'm afraid it may cause more problems.
>>>>
>>>> Quite a lot of places are accessing rbio->bbio either for their btrfs
>>>> logical address or stripes or even stripe->dev.
>>>>
>>>
>>> I'm confused, could you please specify the call trace of general
>>> protection you got in the commit log?
>>
>> The 4th and 5th patches are designed to fix the same problem.
>>
>> If one applies 5th patch only and run btrfs/069, it will cause hang when
>> aborting replace, since btrfs_device of dev 0 is hold in bbio->stripes[] and
>> never get released.
>>
>> The 4th patch is used to solve such hang.
>>
>
> OK, I see.
>
> Firstly, the above commit log is misleading people a bit because it
> says that steal_rbio() dereferences the device of the cached rbio and
> that device has got free'd, but steal_rbio() actually doesn't.  Yes,
> the cached rbio holds a reference on the free'd device, but I think
> the below 'NULL pointer dereference' comes from writing back pages
> into target devices when doing RMW with the current rbio instead of
> the old cached one, right?

Yes, steal_bio() is not related to this problem, sorry for the confusion.

>
> Secondly, if it is the current rio that ends up this 'NULL pointer
> dereference', it could hold a bio_counter and let the replace thread
> canceled by scrub wait for this bio_counter to be zero.  Although
> btrfs_dev_replace_finishing() has flushed delalloc IO and committed
> transaction, seems like scrub is an exception because it can continued
> after committing transaction.

If I understand it correctly, did you mean hold bio_counter when rbio 
holds bbio?

That's OK, but we still need the 4th patch, or it will block replace 
cancel forever.

>
> Thirdly, it is possible that this canceled dev-replace could make
> fstrim get a 'general protection' or 'NULL pointer dereference' since
> it could access target devices and is not sychoronized by committing
> transaction.

So I'm using the refcount for btrfs_device to do full protection for it.
As long as btrfs_dev can only be freed when no on holds it, instead of 
no bio pending for it, it should be safer.

>
> Please correct me if I'm wrong since I failed to reproduce it.

The bug is harder to trigger in v4.11-rc2 now.

I modified btrfs/069 to make it easier to trigger, but it's still quite 
hard to reproduce it.

Even with modification, the possibility is still low, at about 10~20%.

Hopes the diff could help you to trigger it.

Thanks,
Qu

diff --git a/tests/btrfs/069 b/tests/btrfs/069
index d939cd8..f9ff945 100755
--- a/tests/btrfs/069
+++ b/tests/btrfs/069
@@ -74,7 +74,7 @@ run_test()
         _scratch_mount >>$seqres.full 2>&1
         SCRATCH_DEV_POOL=$saved_scratch_dev_pool

-       args=`_scale_fsstress_args -p 20 -n 100 $FSSTRESS_AVOID -d 
$SCRATCH_MNT/stressdir`
+       args=`_scale_fsstress_args -p 20 -n 1000 $FSSTRESS_AVOID -d 
$SCRATCH_MNT/stressdir`
         echo "Run fsstress $args" >>$seqres.full
         $FSSTRESS_PROG $args >/dev/null 2>&1 &
         fsstress_pid=$!
@@ -115,9 +115,10 @@ run_test()
  }

  echo "Silence is golden"
-for t in "${_btrfs_profile_configs[@]}"; do
-       run_test "$t"
-done
+#for t in "${_btrfs_profile_configs[@]}"; do
+#      run_test "$t"
+#done
+run_test "-d raid5 -m raid5"

  status=0
  exit

>
> Thanks,
>
> -liubo
>
>> And the kernel NULL pointer access is like this when running modified
>> btrfs/069 (only run on RAID5, and improve the duration of fsstress):
>>
>> [  884.877421] BUG: unable to handle kernel NULL pointer dereference at
>> 00000000000005e0
>> [  884.878206] IP: generic_make_request_checks+0x4d/0x610
>> [  884.878541] PGD 2d45a067
>> [  884.878542] PUD 3ba0e067
>> [  884.878857] PMD 0
>> [  884.879189]
>> [  884.879899] Oops: 0000 [#1] SMP
>> [  884.880207] Modules linked in: btrfs(O) ext4 jbd2 mbcache xor raid6_pq
>> netconsole xfs [last unloaded: btrfs]
>> [  884.880845] CPU: 1 PID: 11676 Comm: kworker/u4:14 Tainted: G  O
>> 4.11.0-rc2 #72
>> [  884.881455] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
>> 1.10.2-20170228_101828-anatol 04/01/2014
>> [  884.882119] Workqueue: btrfs-endio-raid56 btrfs_endio_raid56_helper
>> [btrfs]
>> [  884.883089] task: ffff88002875b4c0 task.stack: ffffc90001334000
>> [  884.883527] RIP: 0010:generic_make_request_checks+0x4d/0x610
>> [  884.883855] RSP: 0018:ffffc90001337bb8 EFLAGS: 00010283
>> [  884.884186] RAX: 0000000000000000 RBX: ffff8800126503e8 RCX:
>> 0000000000218800
>> [  884.884539] RDX: 0000000000000040 RSI: 0000000000000001 RDI:
>> ffff88003d8116c0
>> [  884.884897] RBP: ffffc90001337c18 R08: 0000000000000001 R09:
>> 0000000000000001
>> [  884.885778] R10: 0000000000000000 R11: 00000000000162b9 R12:
>> 0000000000000040
>> [  884.886346] R13: ffff8800126503e8 R14: 00000000ffffffff R15:
>> 0000000000000010
>> [  884.887146] FS:  0000000000000000(0000) GS:ffff88003e400000(0000)
>> knlGS:0000000000000000
>> [  884.888457] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [  884.888792] CR2: 00000000000005e0 CR3: 000000003ad30000 CR4:
>> 00000000000006e0
>> [  884.889212] Call Trace:
>> [  884.889526]  ? generic_make_request+0xc7/0x360
>> [  884.889841]  generic_make_request+0x24/0x360
>> [  884.890163]  ? generic_make_request+0xc7/0x360
>> [  884.890486]  submit_bio+0x64/0x120
>> [  884.890828]  ? page_in_rbio+0x4d/0x80 [btrfs]
>> [  884.891206]  ? rbio_orig_end_io+0x80/0x80 [btrfs]
>> [  884.891543]  finish_rmw+0x3f4/0x540 [btrfs]
>> [  884.891875]  validate_rbio_for_rmw+0x36/0x40 [btrfs]
>> [  884.892213]  raid_rmw_end_io+0x7a/0x90 [btrfs]
>> [  884.892565]  bio_endio+0x56/0x60
>> [  884.892891]  end_workqueue_fn+0x3c/0x40 [btrfs]
>> [  884.893265]  btrfs_scrubparity_helper+0xef/0x620 [btrfs]
>> [  884.893698]  btrfs_endio_raid56_helper+0xe/0x10 [btrfs]
>> [  884.894101]  process_one_work+0x2af/0x720
>> [  884.894837]  ? process_one_work+0x22b/0x720
>> [  884.895278]  worker_thread+0x4b/0x4f0
>> [  884.895760]  kthread+0x10f/0x150
>> [  884.896106]  ? process_one_work+0x720/0x720
>> [  884.896448]  ? kthread_create_on_node+0x40/0x40
>> [  884.896803]  ret_from_fork+0x2e/0x40
>> [  884.897148] Code: 67 28 48 c7 c7 27 7f c9 81 e8 90 6c d4 ff e8 0b bb 54
>> 00 41 c1 ec 09 48 8b 7b 08 45 85 e4 0f 85 be 00 00 00 48 8b 87 00 01 00 00
>> <4c> 8b b0 e0 05 00 00 4d 85 f6 0f 84 86 01 00 00 4c 8b af f0 00
>> [  884.898449] RIP: generic_make_request_checks+0x4d/0x610 RSP:
>> ffffc90001337bb8
>> [  884.899223] CR2: 00000000000005e0
>> [  884.900223] ---[ end trace 307e118b57a9995e ]---
>>
>> Thanks,
>> Qu
>>
>>>
>>> I wonder if patch 4 and 5 are fixing the same use-after-free problem?
>>>
>>> Thanks,
>>>
>>> -liubo
>>>
>>>> Thanks,
>>>> Qu
>>>>
>>>>
>>>>>
>>>>> Thanks,
>>>>>
>>>>> -liubo
>>>>>
>>>>>> And I think the logical is very strange, if RAID5/6 is unstable, there is no
>>>>>> meaning to keep it fast.
>>>>>>
>>>>>> Keep it stable first, and then consider the performance.
>>>>>>
>>>>>> Thanks,
>>>>>> Qu
>>>>>>
>>>>>>>
>>>>>>> Thanks,
>>>>>>>
>>>>>>> -liubo
>>>>>>>
>>>>>>>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>>>>>>>> ---
>>>>>>>>  fs/btrfs/raid56.c | 18 +-----------------
>>>>>>>>  1 file changed, 1 insertion(+), 17 deletions(-)
>>>>>>>>
>>>>>>>> diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
>>>>>>>> index 453eefdcb591..aba82b95ec73 100644
>>>>>>>> --- a/fs/btrfs/raid56.c
>>>>>>>> +++ b/fs/btrfs/raid56.c
>>>>>>>> @@ -776,7 +776,6 @@ static noinline void unlock_stripe(struct btrfs_raid_bio *rbio)
>>>>>>>>  	int bucket;
>>>>>>>>  	struct btrfs_stripe_hash *h;
>>>>>>>>  	unsigned long flags;
>>>>>>>> -	int keep_cache = 0;
>>>>>>>>
>>>>>>>>  	bucket = rbio_bucket(rbio);
>>>>>>>>  	h = rbio->fs_info->stripe_hash_table->table + bucket;
>>>>>>>> @@ -788,19 +787,6 @@ static noinline void unlock_stripe(struct btrfs_raid_bio *rbio)
>>>>>>>>  	spin_lock(&rbio->bio_list_lock);
>>>>>>>>
>>>>>>>>  	if (!list_empty(&rbio->hash_list)) {
>>>>>>>> -		/*
>>>>>>>> -		 * if we're still cached and there is no other IO
>>>>>>>> -		 * to perform, just leave this rbio here for others
>>>>>>>> -		 * to steal from later
>>>>>>>> -		 */
>>>>>>>> -		if (list_empty(&rbio->plug_list) &&
>>>>>>>> -		    test_bit(RBIO_CACHE_BIT, &rbio->flags)) {
>>>>>>>> -			keep_cache = 1;
>>>>>>>> -			clear_bit(RBIO_RMW_LOCKED_BIT, &rbio->flags);
>>>>>>>> -			BUG_ON(!bio_list_empty(&rbio->bio_list));
>>>>>>>> -			goto done;
>>>>>>>> -		}
>>>>>>>> -
>>>>>>>>  		list_del_init(&rbio->hash_list);
>>>>>>>>  		atomic_dec(&rbio->refs);
>>>>>>>>
>>>>>>>> @@ -848,13 +834,11 @@ static noinline void unlock_stripe(struct btrfs_raid_bio *rbio)
>>>>>>>>  			goto done_nolock;
>>>>>>>>  		}
>>>>>>>>  	}
>>>>>>>> -done:
>>>>>>>>  	spin_unlock(&rbio->bio_list_lock);
>>>>>>>>  	spin_unlock_irqrestore(&h->lock, flags);
>>>>>>>>
>>>>>>>>  done_nolock:
>>>>>>>> -	if (!keep_cache)
>>>>>>>> -		remove_rbio_from_cache(rbio);
>>>>>>>> +	remove_rbio_from_cache(rbio);
>>>>>>>>  }
>>>>>>>>
>>>>>>>>  static void __free_raid_bio(struct btrfs_raid_bio *rbio)
>>>>>>>> --
>>>>>>>> 2.11.0
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>> --
>>>>>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>>>
>>>>>>>
>>>>>>
>>>>>>
>>>>>
>>>>>
>>>>
>>>>
>>>
>>>
>>
>>
>
>


