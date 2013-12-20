Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:45502 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751031Ab3LTDH7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Dec 2013 22:07:59 -0500
Message-ID: <52B3B4BC.70204@cn.fujitsu.com>
Date: Fri, 20 Dec 2013 11:08:44 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 00/18] Replace btrfs_workers with kernel workqueue
 based btrfs_workqueue
References: <1387272719-11889-1-git-send-email-quwenruo@cn.fujitsu.com> <52B3105A.5000102@fb.com>
In-Reply-To: <52B3105A.5000102@fb.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm sorry but I failed to reproduce the problem.
Btrfs/012 in xfstests has been run for serveral hours but nothing happened.

Would you please give me some more details about the environment or the 
panic backtrace?

Thanks.

Qu

On Thu, 19 Dec 2013 10:27:22 -0500, Josef Bacik wrote:
> I got a panic with btrfs/012 in the worker stuff.  I'm bisecting it 
> down to figure out which patch introduced it but I'm afraid it may 
> just be one of the "replace blah with btrfs_workqueue" patches and not 
> be super helpful.  You may want to run it in a loop or something and 
> see if you can trigger it in the meantime and I'll respond whenever my 
> bisect finishes.  Thanks,
>
> Josef
>
> On 12/17/2013 04:31 AM, Qu Wenruo wrote:
>> Add a new btrfs_workqueue_struct which use kernel workqueue to implement
>> most of the original btrfs_workers, to replace btrfs_workers.
>>
>> With this patchset, redundant workqueue codes are replaced with kernel
>> workqueue infrastructure, which not only reduces the code size but 
>> also the
>> effort to maintain it.
>>
>> The result from sysbench shows minor improvement on the following 
>> server:
>> CPU: two-way Xeon X5660
>> RAM: 4G
>> HDD: SAS HDD, 150G total, 100G partition for btrfs test
>>
>> Test result on default mount option:
>> https://docs.google.com/spreadsheet/ccc?key=0AhpkL3ehzX3pdENjajJTWFg5d1BWbExnYWFpMTJxeUE&usp=sharing 
>>
>>
>> Test result on "-o compress" mount option:
>> https://docs.google.com/spreadsheet/ccc?key=0AhpkL3ehzX3pdHdTTEJ6OW96SXJFaDR5enB1SzMzc0E&usp=sharing 
>>
>>
>> Changelog:
>> v1->v2:
>>    - Fix some workqueue flags.
>> v2->v3:
>>    - Add the thresholding mechanism to simulate the old behavior
>>    - Convert all the btrfs_workers to btrfs_workrqueue_struct.
>>    - Fix some potential deadlock when executed in IRQ handler.
>> v3->v4:
>>    - Change the ordered workqueue implement to fix the performance 
>> drop in 32K
>>      multi thread random write.
>>    - Change the high priority workqueue implement to get an 
>> independent high
>>      workqueue without starving problem.
>>    - Simplify the btrfs_alloc_workqueue parameters.
>>    - Coding style cleanup.
>>    - Remove the redundant "_struct" suffix.
>>
>> Qu Wenruo (18):
>>    btrfs: Cleanup the unused struct async_sched.
>>    btrfs: Added btrfs_workqueue_struct implemented ordered execution
>>      based on kernel workqueue
>>    btrfs: Add high priority workqueue support for btrfs_workqueue_struct
>>    btrfs: Add threshold workqueue based on kernel workqueue
>>    btrfs: Replace fs_info->workers with btrfs_workqueue.
>>    btrfs: Replace fs_info->delalloc_workers with btrfs_workqueue
>>    btrfs: Replace fs_info->submit_workers with btrfs_workqueue.
>>    btrfs: Replace fs_info->flush_workers with btrfs_workqueue.
>>    btrfs: Replace fs_info->endio_* workqueue with btrfs_workqueue.
>>    btrfs: Replace fs_info->rmw_workers workqueue with btrfs_workqueue.
>>    btrfs: Replace fs_info->cache_workers workqueue with btrfs_workqueue.
>>    btrfs: Replace fs_info->readahead_workers workqueue with
>>      btrfs_workqueue.
>>    btrfs: Replace fs_info->fixup_workers workqueue with btrfs_workqueue.
>>    btrfs: Replace fs_info->delayed_workers workqueue with
>>      btrfs_workqueue.
>>    btrfs: Replace fs_info->qgroup_rescan_worker workqueue with
>>      btrfs_workqueue.
>>    btrfs: Replace fs_info->scrub_* workqueue with btrfs_workqueue.
>>    btrfs: Cleanup the old btrfs_worker.
>>    btrfs: Cleanup the "_struct" suffix in btrfs_workequeue
>>
>>   fs/btrfs/async-thread.c  | 821 
>> ++++++++++++-----------------------------------
>>   fs/btrfs/async-thread.h  | 117 ++-----
>>   fs/btrfs/ctree.h         |  39 ++-
>>   fs/btrfs/delayed-inode.c |   6 +-
>>   fs/btrfs/disk-io.c       | 212 +++++-------
>>   fs/btrfs/extent-tree.c   |   4 +-
>>   fs/btrfs/inode.c         |  38 +--
>>   fs/btrfs/ordered-data.c  |  11 +-
>>   fs/btrfs/qgroup.c        |  15 +-
>>   fs/btrfs/raid56.c        |  21 +-
>>   fs/btrfs/reada.c         |   4 +-
>>   fs/btrfs/scrub.c         |  70 ++--
>>   fs/btrfs/super.c         |  36 +--
>>   fs/btrfs/volumes.c       |  16 +-
>>   14 files changed, 430 insertions(+), 980 deletions(-)
>>
>
>


-- 
-----------------------------------------------------
Qu Wenruo
Development Dept.I
Nanjing Fujitsu Nanda Software Tech. Co., Ltd.(FNST)
No. 6 Wenzhu Road, Nanjing, 210012, China
TEL: +86+25-86630566-8526
COINS: 7998-8526
FAX: +86+25-83317685
MAIL: quwenruo@cn.fujitsu.com
-----------------------------------------------------

