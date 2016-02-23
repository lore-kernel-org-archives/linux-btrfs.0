Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59925 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501AbcBWOpk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Feb 2016 09:45:40 -0500
Date: Tue, 23 Feb 2016 15:45:30 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Anand Jain <anand.jain@oracle.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [bug] unable to handle kernel paging request when running
 btrfs/011
Message-ID: <20160223144530.GN4374@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <56C71B9C.8090700@oracle.com>
 <56C914AC.6030107@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56C914AC.6030107@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Feb 21, 2016 at 09:36:44AM +0800, Qu Wenruo wrote:
> 
> 
> On 02/19/2016 09:41 PM, Anand Jain wrote:
> >
> >
> >   Saw below warn leading to bug when running btrfs/011, not
> >   reproducible. Any idea ?
> >
> Seems like another wq_destroy race.
> 
> But it's hard to locate which wq is the cause from backtrace only.
> 
> What's the wq btrfs_stop_all_workers+0xcd is going to free?

You can always try to guess on your locally built sources, provided the
configs do not enable "too much" debugging. What I get and looks
reasonable:

(gdb) l *(btrfs_stop_all_workers+0xcd)
0x2bc7d is in btrfs_stop_all_workers (fs/btrfs/disk-io.c:2154).
warning: Source file is more recent than executable.
2149            btrfs_destroy_workqueue(fs_info->delayed_workers);
2150            btrfs_destroy_workqueue(fs_info->caching_workers);
2151            btrfs_destroy_workqueue(fs_info->readahead_workers);
2152            btrfs_destroy_workqueue(fs_info->flush_workers);
2153            btrfs_destroy_workqueue(fs_info->qgroup_rescan_workers);
2154            btrfs_destroy_workqueue(fs_info->extent_workers);
2155    }
2156
2157    static void free_root_extent_buffers(struct btrfs_root *root)
2158    {

> And what's the wq end_workqueue_bio+0x85 is going to add?

(gdb) l *(end_workqueue_bio+0x85)
0x2ab55 is in end_workqueue_bio (fs/btrfs/disk-io.c:726).
721
722             if (bio->bi_rw & REQ_WRITE) {
723                     if (end_io_wq->metadata == BTRFS_WQ_ENDIO_METADATA) {
724                             wq = fs_info->endio_meta_write_workers;
725                             func = btrfs_endio_meta_write_helper;
726                     } else if (end_io_wq->metadata == BTRFS_WQ_ENDIO_FREE_SPACE) {
727                             wq = fs_info->endio_freespace_worker;
728                             func = btrfs_freespace_write_helper;
729                     } else if (end_io_wq->metadata == BTRFS_WQ_ENDIO_RAID56) {
730                             wq = fs_info->endio_raid56_workers;
