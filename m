From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH 2/2] btrfs: fix deadlock when doing reservation
Date: Thu, 16 Jun 2011 10:52:14 -0400
Message-ID: <4DFA189E.8020606@redhat.com>
References: <4DF88DCF.2030502@cn.fujitsu.com>	<4DF8B722.2090704@redhat.com> <BANLkTikPyw1tFcXvF9+eKWXjJdSYTxWU5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: miaox@cn.fujitsu.com, Chris Mason <chris.mason@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTikPyw1tFcXvF9+eKWXjJdSYTxWU5A@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 06/16/2011 10:36 AM, Mitch Harder wrote:
> 2011/6/15 Josef Bacik <josef@redhat.com>:
>> On 06/15/2011 06:47 AM, Miao Xie wrote:
>>> The following deadlock may happen when doing reservation for metadata:
>>>
>>> Task0                         Flush thread            Task1
>>> start_transaction()
>>>   shrink_delalloc()
>>>     writeback_inodes_sb_nr()
>>>       wait for flush thread
>>>       end.
>>>                               btrfs_writepages()
>>>                                 cow_file_range()
>>>                                                       btrfs_commit_transaction
>>>                                                         wait num_writer == 1
>>>                                                         (wait Task0 end
>>>                                                          transaction)
>>>                                 start_transaction()
>>>                                   wait trans commit
>>>                                   end
>>>
>>> Task0 -> Flush thread -> Task1 -> Task0
>>>
>>> Fix the above deadlock by doing reservation before the trans handle has
>>> been joined into the transaction.
>>>
>>> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
>>
>> I've already taken care of this in
>>
>> [PATCH 1/2] Btrfs: do transaction space reservation before joining the
>> transaction
>>
>> Thanks,
>>
>> Josef
> 
> I've been trying to run down an issue with btrfs freezing with the
> 3.0_rc btrfs patch set.  I've found a test case that repeatably
> freezes up on my system, and have been surveying the patches on the
> list to see if the issue has already been resolved.
> 
> I've been successful in addressing the deadlock by applying Miao Xie's
> patches (I've tested with both "[1/2] btrfs: fix wrong reservation
> when doing delayed inode operations" and "[2/2] btrfs: fix deadlock
> when doing reservation").
> 
> I've only been partially successful in running my test case with Josef
> Bacik's patches (the deadlock is cleared; however, now I'm running
> into a premature ENOSPC).
> 
> When evaluating Josef's patches, I've applied:
> Btrfs: account for space reservations properly V2
> Btrfs: fix btrfs_update_reserved_bytes usage
> [1/2] Btrfs: do transaction space reservation before joining the transaction
> [2/2] Btrfs: serialize flushers in reserve_metadata_bytes
> 

So drop those first 2, they are wrong and why they are giving you early
enospc.  The last two are what you want and should fix your deadlock.
Thanks,

JOsef
