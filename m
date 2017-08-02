Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-36-wd.italiaonline.it ([212.48.13.170]:52460 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751988AbdHBUtm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 2 Aug 2017 16:49:42 -0400
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH 00/14 RFC] Btrfs: Add journal for raid5/6 writes
To: bo.li.liu@oracle.com
Cc: linux-btrfs@vger.kernel.org
References: <20170801161439.13426-1-bo.li.liu@oracle.com>
 <ac334d78-77e1-081d-1cf0-48e36e25268f@libero.it>
 <20170801172411.GE26357@localhost.localdomain>
 <dc65edc8-82bd-ac1b-fa90-6076bea13df9@inwind.it>
 <20170802175738.GA12533@localhost.localdomain>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <91f2f70c-151d-d0ff-1acf-c5eb55e4fc9c@inwind.it>
Date: Wed, 2 Aug 2017 22:41:30 +0200
MIME-Version: 1.0
In-Reply-To: <20170802175738.GA12533@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Liu,

thanks for your reply, below my comments
On 2017-08-02 19:57, Liu Bo wrote:
> On Wed, Aug 02, 2017 at 12:14:27AM +0200, Goffredo Baroncelli wrote:
>> On 2017-08-01 19:24, Liu Bo wrote:
>>> On Tue, Aug 01, 2017 at 07:42:14PM +0200, Goffredo Baroncelli wrote:
>>>> Hi Liu,
>>>>
>>>> On 2017-08-01 18:14, Liu Bo wrote:
>>>>> This aims to fix write hole issue on btrfs raid5/6 setup by adding a
>>>>> separate disk as a journal (aka raid5/6 log), so that after unclean
>>>>> shutdown we can make sure data and parity are consistent on the raid
>>>>> array by replaying the journal.
>>>>>
>>>>
>>>> it would be possible to have more information ?
>>>> - what is logged ? data, parity or data + parity ?
>>>
>>> Patch 5 has more details(sorry for not making it clear that in the
>>> cover letter).
>>>
>>> So both data and parity are logged so that while replaying the journal
>>> everything is written to whichever disk it should be written to.
>>
>> It is correct reading this as: all data is written two times ? Or are logged only the stripes involved by a RMW cycle (i.e. if a stripe is fully written, the log is bypassed )?
> 
> For data, only data in bios from high level will be logged, while for
> parity, the whole parity will be logged.
> 
> Full stripe write still logs all data and parity, as full stripe write
> may not survive from unclean shutdown.

Does this matter ? Due to the COW nature of BTRFS if a transaction is interrupted (by an unclean shutdown) the transaction data are all lost. Am I missing something ?

What I want to understand, is if it is possible to log only the "partial stripe"  RMW cycle.

> 
> Taking a raid5 setup with 3 disks as an example, doing an overwrite
> of 4k will log 4K(data) + 64K(parity).
> 
>>>
>>>> - in the past I thought that it would be sufficient to log only the stripe position involved by a RMW cycle, and then start a scrub on these stripes in case of an unclean shutdown: do you think that it is feasible ?
>>>
>>> An unclean shutdown causes inconsistence between data and parity, so
>>> scrub won't help as it's not able to tell which one (data or parity)
>>> is valid
>> Scrub compares data against its checksum; so it knows if the data is correct. If no disk is lost, a scrub process is sufficient/needed to rebuild the parity/data.
>>
> 
> If no disk is lost, it depends on whether the number of errors caused
> by an unclean shutdown can be tolerated by the raid setup.

see below
> 
>> The problem born when after "an unclean shutdown" a disk failure happens. But these  are *two* distinct failures. These together break the BTRFS raid5 redundancy. But if you run a scrub process between these two failures, the btrfs raid5 redundancy is still effective.
>>
> 
> I wouldn't say that the redundancy is still effective after a scrub
> process, but rather those data which match their checksum can still be
> read out while the mismatched data are lost forever after unclean
> shutdown.


I think that this is the point where we are in disagreement: until now I understood that in BTRFS
a) a transaction is fully completed or fully not-completed. 
b) a transaction is completed after both the data *and* the parity are written.

With these assumption, due to the COW nature of BTRFS an unclean shutdown might invalidate only data of the current transaction. Of course the unclean shutdown prevent the transaction to be completed, and this means that all the data of this transaction is lost in any case.

For the parity this is different, because it is possible a misalignment between the parity and the data (which might be of different transactions).

Let me to explain with the help of your example:

> Taking a raid5 setup with 3 disks as an example, doing an overwrite
> of 4k will log 4K(data) + 64K(parity).

If the transaction is aborted, 128k-4k = 124k are untouched, and these still be valid. The last 4k might be wrong, but in any case this data is not referenced because the transaction was never completed. 
The parity need to be rebuild because we are not able to know if the transaction was aborted before/after the data and/or parity writing


> 
> Thanks,
> 
> -liubo
>>
>>>
>>> With nodatacow, we do overwrite, so RMW during unclean shutdown is not safe.
>>> With datacow, we don't do overwrite, but the following situation may happen,
>>> say we have a raid5 setup with 3 disks, the stripe length is 64k, so
>>>
>>> 1) write 64K  --> now the raid layout is
>>> [64K data + 64K random + 64K parity]
>>> 2) write another 64K --> now the raid layout after RMW is
>>> [64K 1)'s data + 64K 2)'s data + 64K new parity]
>>>
>>> If unclean shutdown occurs before 2) finishes, then parity may be
>>> corrupted and then 1)'s data may be recovered wrongly if the disk
>>> which holds 1)'s data is offline.
>>>
>>>> - does this journal disk also host other btrfs log ?
>>>>
>>>
>>> No, purely data/parity and some associated metadata.
>>>
>>> Thanks,
>>>
>>> -liubo
>>>
>>>>> The idea and the code are similar to the write-through mode of md
>>>>> raid5-cache, so ppl(partial parity log) is also feasible to implement.
>>>>> (If you've been familiar with md, you may find this patch set is
>>>>> boring to read...)
>>>>>
>>>>> Patch 1-3 are about adding a log disk, patch 5-8 are the main part of
>>>>> the implementation, the rest patches are improvements and bugfixes,
>>>>> eg. readahead for recovery, checksum.
>>>>>
>>>>> Two btrfs-progs patches are required to play with this patch set, one
>>>>> is to enhance 'btrfs device add' to add a disk as raid5/6 log with the
>>>>> option '-L', the other is to teach 'btrfs-show-super' to show
>>>>> %journal_tail.
>>>>>
>>>>> This is currently based on 4.12-rc3.
>>>>>
>>>>> The patch set is tagged with RFC, and comments are always welcome,
>>>>> thanks.
>>>>>
>>>>> Known limitations:
>>>>> - Deleting a log device is not implemented yet.
>>>>>
>>>>>
>>>>> Liu Bo (14):
>>>>>   Btrfs: raid56: add raid56 log via add_dev v2 ioctl
>>>>>   Btrfs: raid56: do not allocate chunk on raid56 log
>>>>>   Btrfs: raid56: detect raid56 log on mount
>>>>>   Btrfs: raid56: add verbose debug
>>>>>   Btrfs: raid56: add stripe log for raid5/6
>>>>>   Btrfs: raid56: add reclaim support
>>>>>   Btrfs: raid56: load r5log
>>>>>   Btrfs: raid56: log recovery
>>>>>   Btrfs: raid56: add readahead for recovery
>>>>>   Btrfs: raid56: use the readahead helper to get page
>>>>>   Btrfs: raid56: add csum support
>>>>>   Btrfs: raid56: fix error handling while adding a log device
>>>>>   Btrfs: raid56: initialize raid5/6 log after adding it
>>>>>   Btrfs: raid56: maintain IO order on raid5/6 log
>>>>>
>>>>>  fs/btrfs/ctree.h                |   16 +-
>>>>>  fs/btrfs/disk-io.c              |   16 +
>>>>>  fs/btrfs/ioctl.c                |   48 +-
>>>>>  fs/btrfs/raid56.c               | 1429 ++++++++++++++++++++++++++++++++++-----
>>>>>  fs/btrfs/raid56.h               |   82 +++
>>>>>  fs/btrfs/transaction.c          |    2 +
>>>>>  fs/btrfs/volumes.c              |   56 +-
>>>>>  fs/btrfs/volumes.h              |    7 +-
>>>>>  include/uapi/linux/btrfs.h      |    3 +
>>>>>  include/uapi/linux/btrfs_tree.h |    4 +
>>>>>  10 files changed, 1487 insertions(+), 176 deletions(-)
>>>>>
>>>>
>>>>
>>>> -- 
>>>> gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
>>>> Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>>
>> -- 
>> gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
>> Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
>>
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
