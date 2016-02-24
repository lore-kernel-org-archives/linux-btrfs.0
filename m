Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [59.151.112.132] ([59.151.112.132]:53647 "EHLO
	heian.cn.fujitsu.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751103AbcBXBYo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Feb 2016 20:24:44 -0500
Subject: Re: [bug] unable to handle kernel paging request when running
 btrfs/011
To: <dsterba@suse.cz>, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Anand Jain <anand.jain@oracle.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <56C71B9C.8090700@oracle.com> <56C914AC.6030107@gmx.com>
 <20160223144530.GN4374@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56CD0638.5030607@cn.fujitsu.com>
Date: Wed, 24 Feb 2016 09:24:08 +0800
MIME-Version: 1.0
In-Reply-To: <20160223144530.GN4374@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



David Sterba wrote on 2016/02/23 15:45 +0100:
> On Sun, Feb 21, 2016 at 09:36:44AM +0800, Qu Wenruo wrote:
>>
>>
>> On 02/19/2016 09:41 PM, Anand Jain wrote:
>>>
>>>
>>>    Saw below warn leading to bug when running btrfs/011, not
>>>    reproducible. Any idea ?
>>>
>> Seems like another wq_destroy race.
>>
>> But it's hard to locate which wq is the cause from backtrace only.
>>
>> What's the wq btrfs_stop_all_workers+0xcd is going to free?
>
> You can always try to guess on your locally built sources, provided the
> configs do not enable "too much" debugging. What I get and looks
> reasonable:

Never though even on different system, the binary could be so identical.

This should provide good enough info to investigate further.

Great thanks for the advice.
Qu

>
> (gdb) l *(btrfs_stop_all_workers+0xcd)
> 0x2bc7d is in btrfs_stop_all_workers (fs/btrfs/disk-io.c:2154).
> warning: Source file is more recent than executable.
> 2149            btrfs_destroy_workqueue(fs_info->delayed_workers);
> 2150            btrfs_destroy_workqueue(fs_info->caching_workers);
> 2151            btrfs_destroy_workqueue(fs_info->readahead_workers);
> 2152            btrfs_destroy_workqueue(fs_info->flush_workers);
> 2153            btrfs_destroy_workqueue(fs_info->qgroup_rescan_workers);
> 2154            btrfs_destroy_workqueue(fs_info->extent_workers);
> 2155    }
> 2156
> 2157    static void free_root_extent_buffers(struct btrfs_root *root)
> 2158    {
>
>> And what's the wq end_workqueue_bio+0x85 is going to add?
>
> (gdb) l *(end_workqueue_bio+0x85)
> 0x2ab55 is in end_workqueue_bio (fs/btrfs/disk-io.c:726).
> 721
> 722             if (bio->bi_rw & REQ_WRITE) {
> 723                     if (end_io_wq->metadata == BTRFS_WQ_ENDIO_METADATA) {
> 724                             wq = fs_info->endio_meta_write_workers;
> 725                             func = btrfs_endio_meta_write_helper;
> 726                     } else if (end_io_wq->metadata == BTRFS_WQ_ENDIO_FREE_SPACE) {
> 727                             wq = fs_info->endio_freespace_worker;
> 728                             func = btrfs_freespace_write_helper;
> 729                     } else if (end_io_wq->metadata == BTRFS_WQ_ENDIO_RAID56) {
> 730                             wq = fs_info->endio_raid56_workers;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


