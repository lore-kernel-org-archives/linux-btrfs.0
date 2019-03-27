Return-Path: <SRS0=arzm=R6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EB07C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 20:04:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ACA672075C
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 20:04:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727533AbfC0UEe convert rfc822-to-8bit (ORCPT
        <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Mar 2019 16:04:34 -0400
Received: from james.kirk.hungrycats.org ([174.142.39.145]:34954 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726127AbfC0UEd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Mar 2019 16:04:33 -0400
Received: by james.kirk.hungrycats.org (Postfix, from userid 1002)
        id 29217280F46; Wed, 27 Mar 2019 16:04:32 -0400 (EDT)
Date:   Wed, 27 Mar 2019 16:04:31 -0400
From:   Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To:     linux-btrfs@vger.kernel.org
Subject: Re: A collection of btrfs lockup stack traces (4.14.107, kcompactd
 and two processes running __lock_page)
Message-ID: <20190327200431.GA19858@hungrycats.org>
References: <20190320033957.GA16651@hungrycats.org>
 <20190327023703.GM16651@hungrycats.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20190327023703.GM16651@hungrycats.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Mar 26, 2019 at 10:37:06PM -0400, Zygo Blaxell wrote:
> On Tue, Mar 19, 2019 at 11:39:59PM -0400, Zygo Blaxell wrote:
> > I haven't been able to easily reproduce these in a test environment;
> > however, they have been happening several times a year on servers in
> > production.
> > 
> > Kernel:  most recent observation on 4.14.105 + cherry-picked deadlock
> > and misc hang fixes:
> > 
> > 	btrfs: wakeup cleaner thread when adding delayed iput
> > 	Btrfs: fix deadlock when allocating tree block during leaf/node split
> > 	Btrfs: use nofs context when initializing security xattrs to avoid deadlock
> > 	Btrfs: fix deadlock with memory reclaim during scrub
> > 	Btrfs: fix deadlock between clone/dedupe and rename
> > 
> > Also observed on 4.20.13, and 4.14.0..4.14.105 (4.14.106 is currently
> > running, but hasn't locked up yet).
> > 
> > Filesystem mount flags:  compress=zstd,ssd,flushoncommit,space_cache=v2.
> > Configuration is either -draid1/-mraid1 or -dsingle/-mraid1.  I've
> > also reproduced a lockup without flushoncommit.
> > 
> > The machines that are locking up all run the same workload:
> > 
> > 	rsync receiving data continuously (gigabytes aren't enough,
> > 	I can barely reproduce this once a month with 2TB of rsync
> > 	traffic from 10 simulated clients)
> > 
> > 	bees doing continuous dedupe
> > 
> > 	snapshots daily and after each rsync
> > 
> > 	snapshot deletes as required to maintain free space
> > 
> > 	scrubs twice monthly plus after each crash
> > 
> > 	watchdog does a 'mkdir foo; rmdir foo' every few seconds.
> > 	If this takes longer than 50 minutes, collect a stack trace;
> > 	longer than 60 minutes, reboot the machine.
> > 
> [...]

Here's 4.14.107 with kcompactd and two processes running __lock_page.
This happens in 6 of 16 stack traces--the others don't have kcompactd
nor do they have two threads executing __lock_page.  It looks just
different enough from the others to possibly be a distinct bug.

[Tue Mar 26 16:43:30 2019] sysrq: SysRq : Show Locks Held
[Tue Mar 26 16:43:30 2019] 
                           Showing all locks held in the system:
[Tue Mar 26 16:43:30 2019] 1 lock held by in:imklog/7096:
[Tue Mar 26 16:43:30 2019]  #0:  (&f->f_pos_lock){+.+.}, at: [<ffffffffaa2d2088>] __fdget_pos+0x48/0x60
[Tue Mar 26 16:43:30 2019] 3 locks held by btrfs-transacti/29027:
[Tue Mar 26 16:43:30 2019]  #0:  (&fs_info->transaction_kthread_mutex){+.+.}, at: [<ffffffffaa435584>] transaction_kthread+0x74/0x1d0
[Tue Mar 26 16:43:30 2019]  #1:  (&fs_info->delalloc_root_mutex){+.+.}, at: [<ffffffffaa44f9f8>] btrfs_start_delalloc_roots+0x58/0x380
[Tue Mar 26 16:43:30 2019]  #2:  (&root->delalloc_mutex){+.+.}, at: [<ffffffffaa44f5d2>] __start_delalloc_inodes+0x52/0x320
[Tue Mar 26 16:43:30 2019] 2 locks held by hash_writeback/29369:
[Tue Mar 26 16:43:30 2019]  #0:  (sb_writers#8){.+.+}, at: [<ffffffffaa2ae2f3>] vfs_write+0x163/0x1b0
[Tue Mar 26 16:43:30 2019]  #1:  (&sb->s_type->i_mutex_key#14){+.+.}, at: [<ffffffffaa4558a0>] btrfs_file_write_iter+0x90/0x5b0
[Tue Mar 26 16:43:30 2019] 3 locks held by crawl_writeback/29399:
[Tue Mar 26 16:43:30 2019]  #0:  (sb_writers#8){.+.+}, at: [<ffffffffaa2d4ed0>] mnt_want_write+0x20/0x50
[Tue Mar 26 16:43:30 2019]  #1:  (&type->i_mutex_dir_key#6){++++}, at: [<ffffffffaa2be4ce>] path_openat+0x4ce/0xcc0
[Tue Mar 26 16:43:30 2019]  #2:  (sb_internal){.+.+}, at: [<ffffffffaa43b8a6>] start_transaction+0x2b6/0x4d0
[Tue Mar 26 16:43:30 2019] 3 locks held by crawl_61509/25922:
[Tue Mar 26 16:43:30 2019]  #0:  (sb_writers#8){.+.+}, at: [<ffffffffaa2d4f5b>] mnt_want_write_file+0x3b/0xb0
[Tue Mar 26 16:43:30 2019]  #1:  (&sb->s_type->i_mutex_key#14/1){+.+.}, at: [<ffffffffaa479f0e>] btrfs_dedupe_file_range+0x8e/0x660
[Tue Mar 26 16:43:30 2019]  #2:  (&sb->s_type->i_mutex_key#14/2){+.+.}, at: [<ffffffffaa479f1f>] btrfs_dedupe_file_range+0x9f/0x660
[Tue Mar 26 16:43:30 2019] 4 locks held by crawl_61509/25923:
[Tue Mar 26 16:43:30 2019]  #0:  (sb_writers#8){.+.+}, at: [<ffffffffaa2d4f5b>] mnt_want_write_file+0x3b/0xb0
[Tue Mar 26 16:43:30 2019]  #1:  (&sb->s_type->i_mutex_key#14/1){+.+.}, at: [<ffffffffaa479f0e>] btrfs_dedupe_file_range+0x8e/0x660
[Tue Mar 26 16:43:30 2019]  #2:  (&sb->s_type->i_mutex_key#14/2){+.+.}, at: [<ffffffffaa479f1f>] btrfs_dedupe_file_range+0x9f/0x660
[Tue Mar 26 16:43:30 2019]  #3:  (sb_internal){.+.+}, at: [<ffffffffaa43b8a6>] start_transaction+0x2b6/0x4d0
[Tue Mar 26 16:43:30 2019] 4 locks held by crawl_61509/26256:
[Tue Mar 26 16:43:30 2019]  #0:  (sb_writers#8){.+.+}, at: [<ffffffffaa2d4f5b>] mnt_want_write_file+0x3b/0xb0
[Tue Mar 26 16:43:30 2019]  #1:  (&sb->s_type->i_mutex_key#14/1){+.+.}, at: [<ffffffffaa479f0e>] btrfs_dedupe_file_range+0x8e/0x660
[Tue Mar 26 16:43:30 2019]  #2:  (&sb->s_type->i_mutex_key#14/2){+.+.}, at: [<ffffffffaa479f1f>] btrfs_dedupe_file_range+0x9f/0x660
[Tue Mar 26 16:43:30 2019]  #3:  (sb_internal){.+.+}, at: [<ffffffffaa43b8a6>] start_transaction+0x2b6/0x4d0
[Tue Mar 26 16:43:30 2019] 4 locks held by crawl_61509/26257:
[Tue Mar 26 16:43:30 2019]  #0:  (sb_writers#8){.+.+}, at: [<ffffffffaa2d4f5b>] mnt_want_write_file+0x3b/0xb0
[Tue Mar 26 16:43:30 2019]  #1:  (&sb->s_type->i_mutex_key#14/1){+.+.}, at: [<ffffffffaa479f0e>] btrfs_dedupe_file_range+0x8e/0x660
[Tue Mar 26 16:43:30 2019]  #2:  (&sb->s_type->i_mutex_key#14/2){+.+.}, at: [<ffffffffaa479f1f>] btrfs_dedupe_file_range+0x9f/0x660
[Tue Mar 26 16:43:30 2019]  #3:  (sb_internal){.+.+}, at: [<ffffffffaa43b8a6>] start_transaction+0x2b6/0x4d0
[Tue Mar 26 16:43:30 2019] 4 locks held by crawl_61509/26258:
[Tue Mar 26 16:43:30 2019]  #0:  (sb_writers#8){.+.+}, at: [<ffffffffaa2d4f5b>] mnt_want_write_file+0x3b/0xb0
[Tue Mar 26 16:43:30 2019]  #1:  (&sb->s_type->i_mutex_key#14/1){+.+.}, at: [<ffffffffaa479f0e>] btrfs_dedupe_file_range+0x8e/0x660
[Tue Mar 26 16:43:30 2019]  #2:  (&sb->s_type->i_mutex_key#14/2){+.+.}, at: [<ffffffffaa479f1f>] btrfs_dedupe_file_range+0x9f/0x660
[Tue Mar 26 16:43:30 2019]  #3:  (sb_internal){.+.+}, at: [<ffffffffaa43b8a6>] start_transaction+0x2b6/0x4d0
[Tue Mar 26 16:43:30 2019] 3 locks held by rsync/22902:
[Tue Mar 26 16:43:30 2019]  #0:  (sb_writers#8){.+.+}, at: [<ffffffffaa2aa8ec>] do_sys_ftruncate.constprop.1+0xdc/0x180
[Tue Mar 26 16:43:30 2019]  #1:  (&sb->s_type->i_mutex_key#14){+.+.}, at: [<ffffffffaa2aa51f>] do_truncate+0x4f/0x90
[Tue Mar 26 16:43:30 2019]  #2:  (sb_internal){.+.+}, at: [<ffffffffaa43b8a6>] start_transaction+0x2b6/0x4d0
[Tue Mar 26 16:43:30 2019] 1 lock held by rsync/12425:
[Tue Mar 26 16:43:30 2019]  #0:  (&type->i_mutex_dir_key#6){++++}, at: [<ffffffffaa2b9447>] lookup_slow+0xe7/0x210
[Tue Mar 26 16:43:30 2019] 2 locks held by kworker/u8:14/13297:
[Tue Mar 26 16:43:30 2019]  #0:  ("%s-%s""btrfs", name){+.+.}, at: [<ffffffffaa0ae2ce>] process_one_work+0x17e/0x650
[Tue Mar 26 16:43:30 2019]  #1:  ((&work->normal_work)){+.+.}, at: [<ffffffffaa0ae2ce>] process_one_work+0x17e/0x650
[Tue Mar 26 16:43:30 2019] 3 locks held by rsync/9359:
[Tue Mar 26 16:43:30 2019]  #0:  (sb_writers#8){.+.+}, at: [<ffffffffaa2d4ed0>] mnt_want_write+0x20/0x50
[Tue Mar 26 16:43:30 2019]  #1:  (&type->i_mutex_dir_key#6){++++}, at: [<ffffffffaa2be4ce>] path_openat+0x4ce/0xcc0
[Tue Mar 26 16:43:30 2019]  #2:  (sb_internal){.+.+}, at: [<ffffffffaa43b8a6>] start_transaction+0x2b6/0x4d0
[Tue Mar 26 16:43:30 2019] 4 locks held by rsync/8086:
[Tue Mar 26 16:43:30 2019]  #0:  (sb_writers#8){.+.+}, at: [<ffffffffaa2d4ed0>] mnt_want_write+0x20/0x50
[Tue Mar 26 16:43:30 2019]  #1:  (&type->i_mutex_dir_key#6/1){+.+.}, at: [<ffffffffaa2bf993>] do_unlinkat+0x113/0x300
[Tue Mar 26 16:43:30 2019]  #2:  (&sb->s_type->i_mutex_key#14){+.+.}, at: [<ffffffffaa2b9edc>] vfs_unlink+0x4c/0x190
[Tue Mar 26 16:43:30 2019]  #3:  (sb_internal){.+.+}, at: [<ffffffffaa43b8a6>] start_transaction+0x2b6/0x4d0
[Tue Mar 26 16:43:30 2019] 3 locks held by kworker/u8:10/27109:
[Tue Mar 26 16:43:30 2019]  #0:  ("writeback"){+.+.}, at: [<ffffffffaa0ae2ce>] process_one_work+0x17e/0x650
[Tue Mar 26 16:43:30 2019]  #1:  ((&(&wb->dwork)->work)){+.+.}, at: [<ffffffffaa0ae2ce>] process_one_work+0x17e/0x650
[Tue Mar 26 16:43:30 2019]  #2:  (&type->s_umount_key#24){++++}, at: [<ffffffffaa2b1276>] trylock_super+0x16/0x50
[Tue Mar 26 16:43:30 2019] 3 locks held by rsync/1942:
[Tue Mar 26 16:43:30 2019]  #0:  (sb_writers#8){.+.+}, at: [<ffffffffaa2d4ed0>] mnt_want_write+0x20/0x50
[Tue Mar 26 16:43:30 2019]  #1:  (&type->i_mutex_dir_key#6){++++}, at: [<ffffffffaa2be4ce>] path_openat+0x4ce/0xcc0
[Tue Mar 26 16:43:30 2019]  #2:  (sb_internal){.+.+}, at: [<ffffffffaa43b8a6>] start_transaction+0x2b6/0x4d0
[Tue Mar 26 16:43:30 2019] 3 locks held by rsync/4476:
[Tue Mar 26 16:43:30 2019]  #0:  (sb_writers#8){.+.+}, at: [<ffffffffaa2d4ed0>] mnt_want_write+0x20/0x50
[Tue Mar 26 16:43:30 2019]  #1:  (&type->i_mutex_dir_key#6){++++}, at: [<ffffffffaa2be4ce>] path_openat+0x4ce/0xcc0
[Tue Mar 26 16:43:30 2019]  #2:  (sb_internal){.+.+}, at: [<ffffffffaa43b8a6>] start_transaction+0x2b6/0x4d0
[Tue Mar 26 16:43:30 2019] 3 locks held by mkdir/4816:
[Tue Mar 26 16:43:30 2019]  #0:  (sb_writers#8){.+.+}, at: [<ffffffffaa2d4ed0>] mnt_want_write+0x20/0x50
[Tue Mar 26 16:43:30 2019]  #1:  (&type->i_mutex_dir_key#6/1){+.+.}, at: [<ffffffffaa2bf56f>] filename_create+0x6f/0x140
[Tue Mar 26 16:43:30 2019]  #2:  (sb_internal){.+.+}, at: [<ffffffffaa43b8a6>] start_transaction+0x2b6/0x4d0
[Tue Mar 26 16:43:30 2019] 3 locks held by rsync/6356:
[Tue Mar 26 16:43:30 2019]  #0:  (sb_writers#8){.+.+}, at: [<ffffffffaa2d4ed0>] mnt_want_write+0x20/0x50
[Tue Mar 26 16:43:30 2019]  #1:  (&type->i_mutex_dir_key#6){++++}, at: [<ffffffffaa2be4ce>] path_openat+0x4ce/0xcc0
[Tue Mar 26 16:43:30 2019]  #2:  (sb_internal){.+.+}, at: [<ffffffffaa43b8a6>] start_transaction+0x2b6/0x4d0
[Tue Mar 26 16:43:30 2019] 3 locks held by rsync/6626:
[Tue Mar 26 16:43:30 2019]  #0:  (sb_writers#8){.+.+}, at: [<ffffffffaa2d4ed0>] mnt_want_write+0x20/0x50
[Tue Mar 26 16:43:30 2019]  #1:  (&type->i_mutex_dir_key#6){++++}, at: [<ffffffffaa2be4ce>] path_openat+0x4ce/0xcc0
[Tue Mar 26 16:43:30 2019]  #2:  (sb_internal){.+.+}, at: [<ffffffffaa43b8a6>] start_transaction+0x2b6/0x4d0
[Tue Mar 26 16:43:30 2019] 3 locks held by rsync/17256:
[Tue Mar 26 16:43:30 2019]  #0:  (sb_writers#8){.+.+}, at: [<ffffffffaa2d4ed0>] mnt_want_write+0x20/0x50
[Tue Mar 26 16:43:30 2019]  #1:  (&type->i_mutex_dir_key#6){++++}, at: [<ffffffffaa2be4ce>] path_openat+0x4ce/0xcc0
[Tue Mar 26 16:43:30 2019]  #2:  (sb_internal){.+.+}, at: [<ffffffffaa43b8a6>] start_transaction+0x2b6/0x4d0
[Tue Mar 26 16:43:30 2019] 1 lock held by rsync/22060:
[Tue Mar 26 16:43:30 2019]  #0:  (&type->i_mutex_dir_key#6){++++}, at: [<ffffffffaa2b9447>] lookup_slow+0xe7/0x210
[Tue Mar 26 16:43:30 2019] 3 locks held by rsync/29615:
[Tue Mar 26 16:43:30 2019]  #0:  (sb_writers#8){.+.+}, at: [<ffffffffaa2d4ed0>] mnt_want_write+0x20/0x50
[Tue Mar 26 16:43:30 2019]  #1:  (&type->i_mutex_dir_key#6){++++}, at: [<ffffffffaa2be4ce>] path_openat+0x4ce/0xcc0
[Tue Mar 26 16:43:30 2019]  #2:  (sb_internal){.+.+}, at: [<ffffffffaa43b8a6>] start_transaction+0x2b6/0x4d0
[Tue Mar 26 16:43:30 2019] 3 locks held by rsync/7453:
[Tue Mar 26 16:43:30 2019]  #0:  (sb_writers#8){.+.+}, at: [<ffffffffaa2d4ed0>] mnt_want_write+0x20/0x50
[Tue Mar 26 16:43:30 2019]  #1:  (&type->i_mutex_dir_key#6){++++}, at: [<ffffffffaa2be4ce>] path_openat+0x4ce/0xcc0
[Tue Mar 26 16:43:30 2019]  #2:  (sb_internal){.+.+}, at: [<ffffffffaa43b8a6>] start_transaction+0x2b6/0x4d0
[Tue Mar 26 16:43:30 2019] 3 locks held by rsync/29610:
[Tue Mar 26 16:43:30 2019]  #0:  (sb_writers#8){.+.+}, at: [<ffffffffaa2d4ed0>] mnt_want_write+0x20/0x50
[Tue Mar 26 16:43:30 2019]  #1:  (&type->i_mutex_dir_key#6/1){+.+.}, at: [<ffffffffaa2bf56f>] filename_create+0x6f/0x140
[Tue Mar 26 16:43:30 2019]  #2:  (sb_internal){.+.+}, at: [<ffffffffaa43b8a6>] start_transaction+0x2b6/0x4d0
[Tue Mar 26 16:43:30 2019] 3 locks held by rsync/29638:
[Tue Mar 26 16:43:30 2019]  #0:  (sb_writers#8){.+.+}, at: [<ffffffffaa2d4ed0>] mnt_want_write+0x20/0x50
[Tue Mar 26 16:43:30 2019]  #1:  (&type->i_mutex_dir_key#6){++++}, at: [<ffffffffaa2be4ce>] path_openat+0x4ce/0xcc0
[Tue Mar 26 16:43:30 2019]  #2:  (sb_internal){.+.+}, at: [<ffffffffaa43b8a6>] start_transaction+0x2b6/0x4d0
[Tue Mar 26 16:43:30 2019] 3 locks held by rsync/10214:
[Tue Mar 26 16:43:30 2019]  #0:  (sb_writers#8){.+.+}, at: [<ffffffffaa2d4ed0>] mnt_want_write+0x20/0x50
[Tue Mar 26 16:43:30 2019]  #1:  (&type->i_mutex_dir_key#6){++++}, at: [<ffffffffaa2be4ce>] path_openat+0x4ce/0xcc0
[Tue Mar 26 16:43:30 2019]  #2:  (sb_internal){.+.+}, at: [<ffffffffaa43b8a6>] start_transaction+0x2b6/0x4d0
[Tue Mar 26 16:43:30 2019] 3 locks held by rsync/29837:
[Tue Mar 26 16:43:30 2019]  #0:  (sb_writers#8){.+.+}, at: [<ffffffffaa2d4ed0>] mnt_want_write+0x20/0x50
[Tue Mar 26 16:43:30 2019]  #1:  (&type->i_mutex_dir_key#6){++++}, at: [<ffffffffaa2be4ce>] path_openat+0x4ce/0xcc0
[Tue Mar 26 16:43:30 2019]  #2:  (sb_internal){.+.+}, at: [<ffffffffaa43b8a6>] start_transaction+0x2b6/0x4d0
[Tue Mar 26 16:43:30 2019] 3 locks held by rsync/31885:
[Tue Mar 26 16:43:30 2019]  #0:  (sb_writers#8){.+.+}, at: [<ffffffffaa2d4ed0>] mnt_want_write+0x20/0x50
[Tue Mar 26 16:43:30 2019]  #1:  (&type->i_mutex_dir_key#6){++++}, at: [<ffffffffaa2be4ce>] path_openat+0x4ce/0xcc0
[Tue Mar 26 16:43:30 2019]  #2:  (sb_internal){.+.+}, at: [<ffffffffaa43b8a6>] start_transaction+0x2b6/0x4d0
[Tue Mar 26 16:43:30 2019] 3 locks held by rsync/7092:
[Tue Mar 26 16:43:30 2019]  #0:  (sb_writers#8){.+.+}, at: [<ffffffffaa2d4ed0>] mnt_want_write+0x20/0x50
[Tue Mar 26 16:43:30 2019]  #1:  (&type->i_mutex_dir_key#6){++++}, at: [<ffffffffaa2be4ce>] path_openat+0x4ce/0xcc0
[Tue Mar 26 16:43:30 2019]  #2:  (sb_internal){.+.+}, at: [<ffffffffaa43b8a6>] start_transaction+0x2b6/0x4d0
[Tue Mar 26 16:43:30 2019] 3 locks held by rsync/10725:
[Tue Mar 26 16:43:30 2019]  #0:  (sb_writers#8){.+.+}, at: [<ffffffffaa2d4ed0>] mnt_want_write+0x20/0x50
[Tue Mar 26 16:43:30 2019]  #1:  (&type->i_mutex_dir_key#6){++++}, at: [<ffffffffaa2be4ce>] path_openat+0x4ce/0xcc0
[Tue Mar 26 16:43:30 2019]  #2:  (sb_internal){.+.+}, at: [<ffffffffaa43b8a6>] start_transaction+0x2b6/0x4d0
[Tue Mar 26 16:43:30 2019] 3 locks held by rsync/27579:
[Tue Mar 26 16:43:30 2019]  #0:  (sb_writers#8){.+.+}, at: [<ffffffffaa2d4ed0>] mnt_want_write+0x20/0x50
[Tue Mar 26 16:43:30 2019]  #1:  (&type->i_mutex_dir_key#6){++++}, at: [<ffffffffaa2be4ce>] path_openat+0x4ce/0xcc0
[Tue Mar 26 16:43:30 2019]  #2:  (sb_internal){.+.+}, at: [<ffffffffaa43b8a6>] start_transaction+0x2b6/0x4d0
[Tue Mar 26 16:43:30 2019] 3 locks held by rsync/27949:
[Tue Mar 26 16:43:30 2019]  #0:  (sb_writers#8){.+.+}, at: [<ffffffffaa2d4ed0>] mnt_want_write+0x20/0x50
[Tue Mar 26 16:43:30 2019]  #1:  (&type->i_mutex_dir_key#6){++++}, at: [<ffffffffaa2be4ce>] path_openat+0x4ce/0xcc0
[Tue Mar 26 16:43:30 2019]  #2:  (sb_internal){.+.+}, at: [<ffffffffaa43b8a6>] start_transaction+0x2b6/0x4d0
[Tue Mar 26 16:43:30 2019] 3 locks held by rsync/7504:
[Tue Mar 26 16:43:30 2019]  #0:  (sb_writers#8){.+.+}, at: [<ffffffffaa2d4ed0>] mnt_want_write+0x20/0x50
[Tue Mar 26 16:43:30 2019]  #1:  (&type->i_mutex_dir_key#6/1){+.+.}, at: [<ffffffffaa2bf56f>] filename_create+0x6f/0x140
[Tue Mar 26 16:43:30 2019]  #2:  (sb_internal){.+.+}, at: [<ffffffffaa43b8a6>] start_transaction+0x2b6/0x4d0
[Tue Mar 26 16:43:30 2019] 3 locks held by watchdog-mdtest/10434:
[Tue Mar 26 16:43:30 2019]  #0:  (sb_writers#6){.+.+}, at: [<ffffffffaa2ae2f3>] vfs_write+0x163/0x1b0
[Tue Mar 26 16:43:30 2019]  #1:  (rcu_read_lock){....}, at: [<ffffffffaa7442d5>] __handle_sysrq+0x5/0x210
[Tue Mar 26 16:43:30 2019]  #2:  (tasklist_lock){.+.+}, at: [<ffffffffaa0f0377>] debug_show_all_locks+0x37/0x190

[Tue Mar 26 16:43:30 2019] =============================================

[Tue Mar 26 16:43:30 2019] sysrq: SysRq : Show Blocked State
[Tue Mar 26 16:43:30 2019]   task                        PC stack   pid father
[Tue Mar 26 16:43:30 2019] kcompactd0      D    0   469      2 0x80000000
[Tue Mar 26 16:43:30 2019] Call Trace:
[Tue Mar 26 16:43:30 2019]  ? __schedule+0x429/0xbb0
[Tue Mar 26 16:43:30 2019]  schedule+0x39/0x90
[Tue Mar 26 16:43:30 2019]  io_schedule+0x12/0x40
[Tue Mar 26 16:43:30 2019]  __lock_page+0x110/0x140
[Tue Mar 26 16:43:30 2019]  ? add_to_page_cache_lru+0xc0/0xc0
[Tue Mar 26 16:43:30 2019]  migrate_pages+0xc12/0xea0
[Tue Mar 26 16:43:30 2019]  ? __compaction_suitable.part.14+0x80/0x80
[Tue Mar 26 16:43:30 2019]  ? update_pageblock_skip+0xb0/0xb0
[Tue Mar 26 16:43:30 2019]  compact_zone+0x238/0xc40
[Tue Mar 26 16:43:30 2019]  ? rcu_read_lock_sched_held+0x68/0x70
[Tue Mar 26 16:43:30 2019]  kcompactd_do_work+0x140/0x300
[Tue Mar 26 16:43:30 2019]  ? kcompactd+0x8e/0x290
[Tue Mar 26 16:43:30 2019]  kcompactd+0x8e/0x290
[Tue Mar 26 16:43:30 2019]  ? wait_woken+0xa0/0xa0
[Tue Mar 26 16:43:30 2019]  kthread+0x10d/0x140
[Tue Mar 26 16:43:30 2019]  ? kcompactd_do_work+0x300/0x300
[Tue Mar 26 16:43:30 2019]  ? kthread_create_on_node+0x40/0x40
[Tue Mar 26 16:43:30 2019]  ret_from_fork+0x27/0x50
[Tue Mar 26 16:43:30 2019] btrfs-transacti D    0 29027      2 0x80000000
[Tue Mar 26 16:43:30 2019] Call Trace:
[Tue Mar 26 16:43:30 2019]  ? __schedule+0x429/0xbb0
[Tue Mar 26 16:43:30 2019]  schedule+0x39/0x90
[Tue Mar 26 16:43:30 2019]  schedule_timeout+0x20f/0x590
[Tue Mar 26 16:43:30 2019]  ? lock_acquire+0xbc/0x200
[Tue Mar 26 16:43:30 2019]  ? mark_held_locks+0x6a/0x90
[Tue Mar 26 16:43:30 2019]  ? _raw_spin_unlock_irq+0x29/0x40
[Tue Mar 26 16:43:30 2019]  ? wait_for_common+0x131/0x1f0
[Tue Mar 26 16:43:30 2019]  wait_for_common+0x131/0x1f0
[Tue Mar 26 16:43:30 2019]  ? wake_up_q+0x70/0x70
[Tue Mar 26 16:43:30 2019]  __start_delalloc_inodes+0x22f/0x320
[Tue Mar 26 16:43:30 2019]  btrfs_start_delalloc_roots+0x1cd/0x380
[Tue Mar 26 16:43:30 2019]  btrfs_commit_transaction+0x807/0xa20
[Tue Mar 26 16:43:30 2019]  ? start_transaction+0x89/0x4d0
[Tue Mar 26 16:43:30 2019]  transaction_kthread+0x194/0x1d0
[Tue Mar 26 16:43:30 2019]  kthread+0x10d/0x140
[Tue Mar 26 16:43:30 2019]  ? btrfs_cleanup_transaction+0x650/0x650
[Tue Mar 26 16:43:30 2019]  ? kthread_create_on_node+0x40/0x40
[Tue Mar 26 16:43:30 2019]  ret_from_fork+0x27/0x50
[Tue Mar 26 16:43:30 2019] hash_writeback  D    0 29369  29318 0x00000000
[Tue Mar 26 16:43:30 2019] Call Trace:
[Tue Mar 26 16:43:30 2019]  ? __schedule+0x429/0xbb0
[Tue Mar 26 16:43:30 2019]  ? _raw_spin_unlock_irqrestore+0x32/0x60
[Tue Mar 26 16:43:30 2019]  schedule+0x39/0x90
[Tue Mar 26 16:43:30 2019]  schedule_timeout+0x1d0/0x590
[Tue Mar 26 16:43:30 2019]  ? run_timer_softirq+0x130/0x130
[Tue Mar 26 16:43:30 2019]  ? io_schedule_timeout+0x19/0x40
[Tue Mar 26 16:43:30 2019]  io_schedule_timeout+0x19/0x40
[Tue Mar 26 16:43:30 2019]  balance_dirty_pages.isra.12+0x345/0xf80
[Tue Mar 26 16:43:30 2019]  balance_dirty_pages_ratelimited+0x648/0xab0
[Tue Mar 26 16:43:30 2019]  __btrfs_buffered_write.isra.4+0x425/0x730
[Tue Mar 26 16:43:30 2019]  btrfs_file_write_iter+0x1ff/0x5b0
[Tue Mar 26 16:43:30 2019]  __vfs_write+0xd7/0x160
[Tue Mar 26 16:43:30 2019]  vfs_write+0xc5/0x1b0
[Tue Mar 26 16:43:30 2019]  SyS_pwrite64+0x74/0x90
[Tue Mar 26 16:43:30 2019]  do_syscall_64+0x76/0x180
[Tue Mar 26 16:43:30 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Tue Mar 26 16:43:30 2019] RIP: 0033:0x7f30fb140963
[Tue Mar 26 16:43:30 2019] RSP: 002b:00007f30f1ffa380 EFLAGS: 00000293 ORIG_RAX: 0000000000000012
[Tue Mar 26 16:43:30 2019] RAX: ffffffffffffffda RBX: 0000000000020000 RCX: 00007f30fb140963
[Tue Mar 26 16:43:30 2019] RDX: 0000000000020000 RSI: 00007f2fe4000d80 RDI: 0000000000000005
[Tue Mar 26 16:43:30 2019] RBP: 0000000089e80000 R08: 00007f2fe4000d80 R09: 0000000000000000
[Tue Mar 26 16:43:30 2019] R10: 0000000089e80000 R11: 0000000000000293 R12: 00007f30f1ffa5b0
[Tue Mar 26 16:43:30 2019] R13: 0000000000020000 R14: 00007f3075e80000 R15: 00007f2fe4020d80
[Tue Mar 26 16:43:30 2019] crawl_writeback D    0 29399  29318 0x00000000
[Tue Mar 26 16:43:30 2019] Call Trace:
[Tue Mar 26 16:43:30 2019]  ? __schedule+0x429/0xbb0
[Tue Mar 26 16:43:30 2019]  ? prepare_to_wait_event+0x97/0x190
[Tue Mar 26 16:43:30 2019]  schedule+0x39/0x90
[Tue Mar 26 16:43:30 2019]  wait_current_trans+0xa3/0xf0
[Tue Mar 26 16:43:30 2019]  ? wait_woken+0xa0/0xa0
[Tue Mar 26 16:43:30 2019]  start_transaction+0x29b/0x4d0
[Tue Mar 26 16:43:30 2019]  btrfs_create+0x47/0x1d0
[Tue Mar 26 16:43:30 2019]  lookup_open+0x404/0x760
[Tue Mar 26 16:43:30 2019]  path_openat+0x4e9/0xcc0
[Tue Mar 26 16:43:30 2019]  do_filp_open+0x8a/0xf0
[Tue Mar 26 16:43:30 2019]  ? __alloc_fd+0xee/0x200
[Tue Mar 26 16:43:30 2019]  ? do_sys_open+0x130/0x200
[Tue Mar 26 16:43:30 2019]  do_sys_open+0x130/0x200
[Tue Mar 26 16:43:30 2019]  do_syscall_64+0x76/0x180
[Tue Mar 26 16:43:30 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Tue Mar 26 16:43:30 2019] RIP: 0033:0x7f30fa5c3607
[Tue Mar 26 16:43:30 2019] RSP: 002b:00007f2fdfffdcc0 EFLAGS: 00000293 ORIG_RAX: 0000000000000101
[Tue Mar 26 16:43:30 2019] RAX: ffffffffffffffda RBX: 00000000000e09c1 RCX: 00007f30fa5c3607
[Tue Mar 26 16:43:30 2019] RDX: 00000000000e09c1 RSI: 00007f2fd80008f0 RDI: 0000000000000003
[Tue Mar 26 16:43:30 2019] RBP: 0000000000000003 R08: 0000000000000000 R09: 00007f2fdfffe080
[Tue Mar 26 16:43:30 2019] R10: 0000000000000180 R11: 0000000000000293 R12: 00007f2fd80008f0
[Tue Mar 26 16:43:30 2019] R13: 0000000000000003 R14: 00007f2fdfffe3d0 R15: 00007f2fdfffe350
[Tue Mar 26 16:43:30 2019] crawl_61509     D    0 25922  29318 0x00000000
[Tue Mar 26 16:43:30 2019] Call Trace:
[Tue Mar 26 16:43:30 2019]  ? __schedule+0x429/0xbb0
[Tue Mar 26 16:43:30 2019]  ? rwsem_down_write_failed+0x134/0x2b0
[Tue Mar 26 16:43:30 2019]  schedule+0x39/0x90
[Tue Mar 26 16:43:30 2019]  rwsem_down_write_failed+0x139/0x2b0
[Tue Mar 26 16:43:30 2019]  ? call_rwsem_down_write_failed+0x13/0x20
[Tue Mar 26 16:43:30 2019]  call_rwsem_down_write_failed+0x13/0x20
[Tue Mar 26 16:43:30 2019]  down_write_nested+0x87/0xb0
[Tue Mar 26 16:43:30 2019]  btrfs_dedupe_file_range+0x9f/0x660
[Tue Mar 26 16:43:30 2019]  ? rcu_read_lock_sched_held+0x68/0x70
[Tue Mar 26 16:43:30 2019]  ? rcu_sync_lockdep_assert+0x30/0x60
[Tue Mar 26 16:43:30 2019]  ? __sb_start_write+0xcc/0x1b0
[Tue Mar 26 16:43:30 2019]  ? mnt_want_write_file+0x3b/0xb0
[Tue Mar 26 16:43:30 2019]  vfs_dedupe_file_range+0x22e/0x280
[Tue Mar 26 16:43:30 2019]  do_vfs_ioctl+0x24d/0x6b0
[Tue Mar 26 16:43:30 2019]  ? __fget+0x11f/0x210
[Tue Mar 26 16:43:30 2019]  SyS_ioctl+0x74/0x80
[Tue Mar 26 16:43:30 2019]  do_syscall_64+0x76/0x180
[Tue Mar 26 16:43:30 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Tue Mar 26 16:43:30 2019] RIP: 0033:0x7f30fa5c8dd7
[Tue Mar 26 16:43:30 2019] RSP: 002b:00007f30f8ce10a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[Tue Mar 26 16:43:30 2019] RAX: ffffffffffffffda RBX: 00007f2fc449b570 RCX: 00007f30fa5c8dd7
[Tue Mar 26 16:43:30 2019] RDX: 00007f2fc449b570 RSI: 00000000c0189436 RDI: 0000000000000c70
[Tue Mar 26 16:43:30 2019] RBP: 00007f30f8ce1420 R08: 00007f2fc50482b0 R09: 0000000000000000
[Tue Mar 26 16:43:30 2019] R10: 00007f2fc554b720 R11: 0000000000000246 R12: 0000000000000020
[Tue Mar 26 16:43:30 2019] R13: 0000000000000018 R14: 00007f2fc50482c8 R15: 00007f30f8ce1428
[Tue Mar 26 16:43:30 2019] crawl_61509     D    0 25923  29318 0x00000000
[Tue Mar 26 16:43:30 2019] Call Trace:
[Tue Mar 26 16:43:30 2019]  ? __schedule+0x429/0xbb0
[Tue Mar 26 16:43:30 2019]  ? prepare_to_wait_event+0x97/0x190
[Tue Mar 26 16:43:30 2019]  schedule+0x39/0x90
[Tue Mar 26 16:43:30 2019]  wait_current_trans+0xa3/0xf0
[Tue Mar 26 16:43:30 2019]  ? wait_woken+0xa0/0xa0
[Tue Mar 26 16:43:30 2019]  start_transaction+0x29b/0x4d0
[Tue Mar 26 16:43:30 2019]  btrfs_clone+0x5a3/0xcc0
[Tue Mar 26 16:43:30 2019]  btrfs_dedupe_file_range+0x5e3/0x660
[Tue Mar 26 16:43:30 2019]  vfs_dedupe_file_range+0x22e/0x280
[Tue Mar 26 16:43:30 2019]  do_vfs_ioctl+0x24d/0x6b0
[Tue Mar 26 16:43:30 2019]  ? __fget+0x11f/0x210
[Tue Mar 26 16:43:30 2019]  SyS_ioctl+0x74/0x80
[Tue Mar 26 16:43:30 2019]  do_syscall_64+0x76/0x180
[Tue Mar 26 16:43:30 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Tue Mar 26 16:43:30 2019] RIP: 0033:0x7f30fa5c8dd7
[Tue Mar 26 16:43:30 2019] RSP: 002b:00007f30f27f8ac8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[Tue Mar 26 16:43:30 2019] RAX: ffffffffffffffda RBX: 00007f2fc9cb4290 RCX: 00007f30fa5c8dd7
[Tue Mar 26 16:43:30 2019] RDX: 00007f2fc9cb4290 RSI: 00000000c0189436 RDI: 0000000000000bf6
[Tue Mar 26 16:43:30 2019] RBP: 00007f30f27f8e40 R08: 00007f2fc9dbae10 R09: 0000000000000000
[Tue Mar 26 16:43:30 2019] R10: 00007f2fc861c100 R11: 0000000000000246 R12: 0000000000000020
[Tue Mar 26 16:43:30 2019] R13: 0000000000000018 R14: 00007f2fc9dbae28 R15: 00007f30f27f8e48
[Tue Mar 26 16:43:30 2019] crawl_61509     D    0 26256  29318 0x00000000
[Tue Mar 26 16:43:30 2019] Call Trace:
[Tue Mar 26 16:43:30 2019]  ? __schedule+0x429/0xbb0
[Tue Mar 26 16:43:30 2019]  ? prepare_to_wait_event+0x97/0x190
[Tue Mar 26 16:43:30 2019]  schedule+0x39/0x90
[Tue Mar 26 16:43:30 2019]  wait_current_trans+0xa3/0xf0
[Tue Mar 26 16:43:30 2019]  ? wait_woken+0xa0/0xa0
[Tue Mar 26 16:43:30 2019]  start_transaction+0x29b/0x4d0
[Tue Mar 26 16:43:30 2019]  btrfs_clone+0x5a3/0xcc0
[Tue Mar 26 16:43:30 2019]  btrfs_dedupe_file_range+0x5e3/0x660
[Tue Mar 26 16:43:30 2019]  vfs_dedupe_file_range+0x22e/0x280
[Tue Mar 26 16:43:30 2019]  do_vfs_ioctl+0x24d/0x6b0
[Tue Mar 26 16:43:30 2019]  ? __fget+0x11f/0x210
[Tue Mar 26 16:43:30 2019]  SyS_ioctl+0x74/0x80
[Tue Mar 26 16:43:30 2019]  do_syscall_64+0x76/0x180
[Tue Mar 26 16:43:30 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Tue Mar 26 16:43:30 2019] RIP: 0033:0x7f30fa5c8dd7
[Tue Mar 26 16:43:30 2019] RSP: 002b:00007f30f94e20a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[Tue Mar 26 16:43:30 2019] RAX: ffffffffffffffda RBX: 00007f2fd5da86f0 RCX: 00007f30fa5c8dd7
[Tue Mar 26 16:43:30 2019] RDX: 00007f2fd5da86f0 RSI: 00000000c0189436 RDI: 0000000000000c6e
[Tue Mar 26 16:43:30 2019] RBP: 00007f30f94e2420 R08: 00007f2fd65725e0 R09: 0000000000000000
[Tue Mar 26 16:43:30 2019] R10: 00007f2fd41c3800 R11: 0000000000000246 R12: 0000000000000020
[Tue Mar 26 16:43:30 2019] R13: 0000000000000018 R14: 00007f2fd65725f8 R15: 00007f30f94e2428
[Tue Mar 26 16:43:30 2019] crawl_61509     D    0 26257  29318 0x00000000
[Tue Mar 26 16:43:30 2019] Call Trace:
[Tue Mar 26 16:43:30 2019]  ? __schedule+0x429/0xbb0
[Tue Mar 26 16:43:30 2019]  ? prepare_to_wait_event+0x97/0x190
[Tue Mar 26 16:43:30 2019]  schedule+0x39/0x90
[Tue Mar 26 16:43:30 2019]  wait_current_trans+0xa3/0xf0
[Tue Mar 26 16:43:30 2019]  ? wait_woken+0xa0/0xa0
[Tue Mar 26 16:43:30 2019]  start_transaction+0x29b/0x4d0
[Tue Mar 26 16:43:30 2019]  btrfs_clone+0x5a3/0xcc0
[Tue Mar 26 16:43:30 2019]  btrfs_dedupe_file_range+0x5e3/0x660
[Tue Mar 26 16:43:30 2019]  vfs_dedupe_file_range+0x22e/0x280
[Tue Mar 26 16:43:30 2019]  do_vfs_ioctl+0x24d/0x6b0
[Tue Mar 26 16:43:30 2019]  ? __fget+0x11f/0x210
[Tue Mar 26 16:43:30 2019]  SyS_ioctl+0x74/0x80
[Tue Mar 26 16:43:30 2019]  do_syscall_64+0x76/0x180
[Tue Mar 26 16:43:30 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Tue Mar 26 16:43:30 2019] RIP: 0033:0x7f30fa5c8dd7
[Tue Mar 26 16:43:30 2019] RSP: 002b:00007f30f2ffa0a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[Tue Mar 26 16:43:30 2019] RAX: ffffffffffffffda RBX: 00007f2fcc8cdc00 RCX: 00007f30fa5c8dd7
[Tue Mar 26 16:43:30 2019] RDX: 00007f2fcc8cdc00 RSI: 00000000c0189436 RDI: 0000000000000c6f
[Tue Mar 26 16:43:30 2019] RBP: 00007f30f2ffa420 R08: 00007f2fcc79f1c0 R09: 0000000000000000
[Tue Mar 26 16:43:30 2019] R10: 00007f2fcc496010 R11: 0000000000000246 R12: 0000000000000020
[Tue Mar 26 16:43:30 2019] R13: 0000000000000018 R14: 00007f2fcc79f1d8 R15: 00007f30f2ffa428
[Tue Mar 26 16:43:30 2019] crawl_61509     D    0 26258  29318 0x00000000
[Tue Mar 26 16:43:30 2019] Call Trace:
[Tue Mar 26 16:43:30 2019]  ? __schedule+0x429/0xbb0
[Tue Mar 26 16:43:30 2019]  ? prepare_to_wait_event+0x97/0x190
[Tue Mar 26 16:43:30 2019]  schedule+0x39/0x90
[Tue Mar 26 16:43:30 2019]  wait_current_trans+0xa3/0xf0
[Tue Mar 26 16:43:30 2019]  ? wait_woken+0xa0/0xa0
[Tue Mar 26 16:43:30 2019]  start_transaction+0x29b/0x4d0
[Tue Mar 26 16:43:30 2019]  btrfs_clone+0x5a3/0xcc0
[Tue Mar 26 16:43:30 2019]  btrfs_dedupe_file_range+0x5e3/0x660
[Tue Mar 26 16:43:30 2019]  vfs_dedupe_file_range+0x22e/0x280
[Tue Mar 26 16:43:30 2019]  do_vfs_ioctl+0x24d/0x6b0
[Tue Mar 26 16:43:30 2019]  ? __fget+0x11f/0x210
[Tue Mar 26 16:43:30 2019]  SyS_ioctl+0x74/0x80
[Tue Mar 26 16:43:30 2019]  do_syscall_64+0x76/0x180
[Tue Mar 26 16:43:30 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Tue Mar 26 16:43:30 2019] RIP: 0033:0x7f30fa5c8dd7
[Tue Mar 26 16:43:30 2019] RSP: 002b:00007f30f37faac8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[Tue Mar 26 16:43:30 2019] RAX: ffffffffffffffda RBX: 00007f2fc1cd04a0 RCX: 00007f30fa5c8dd7
[Tue Mar 26 16:43:30 2019] RDX: 00007f2fc1cd04a0 RSI: 00000000c0189436 RDI: 0000000000000a3b
[Tue Mar 26 16:43:30 2019] RBP: 00007f30f37fae40 R08: 00007f2fc04365e0 R09: 0000000000000000
[Tue Mar 26 16:43:30 2019] R10: 00007f2fc00751a0 R11: 0000000000000246 R12: 0000000000000020
[Tue Mar 26 16:43:30 2019] R13: 0000000000000018 R14: 00007f2fc04365f8 R15: 00007f30f37fae48
[Tue Mar 26 16:43:30 2019] rsync           D    0 22902   9371 0x00000000
[Tue Mar 26 16:43:30 2019] Call Trace:
[Tue Mar 26 16:43:30 2019]  ? __schedule+0x429/0xbb0
[Tue Mar 26 16:43:30 2019]  ? prepare_to_wait_event+0x97/0x190
[Tue Mar 26 16:43:30 2019]  schedule+0x39/0x90
[Tue Mar 26 16:43:30 2019]  wait_current_trans+0xa3/0xf0
[Tue Mar 26 16:43:30 2019]  ? wait_woken+0xa0/0xa0
[Tue Mar 26 16:43:30 2019]  start_transaction+0x29b/0x4d0
[Tue Mar 26 16:43:30 2019]  btrfs_setattr+0x1e6/0x3b0
[Tue Mar 26 16:43:30 2019]  notify_change+0x2ed/0x450
[Tue Mar 26 16:43:30 2019]  do_truncate+0x5e/0x90
[Tue Mar 26 16:43:30 2019]  ? rcu_read_lock_sched_held+0x68/0x70
[Tue Mar 26 16:43:30 2019]  do_sys_ftruncate.constprop.1+0x120/0x180
[Tue Mar 26 16:43:30 2019]  ? trace_hardirqs_off_thunk+0x1a/0x1c
[Tue Mar 26 16:43:30 2019]  do_syscall_64+0x76/0x180
[Tue Mar 26 16:43:30 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Tue Mar 26 16:43:30 2019] RIP: 0033:0x7f9a8fd2ac87
[Tue Mar 26 16:43:30 2019] RSP: 002b:00007fff7df0a3c8 EFLAGS: 00000246 ORIG_RAX: 000000000000004d
[Tue Mar 26 16:43:30 2019] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f9a8fd2ac87
[Tue Mar 26 16:43:30 2019] RDX: 0000000000000000 RSI: 00000000009f80ef RDI: 0000000000000004
[Tue Mar 26 16:43:30 2019] RBP: 0000000000000004 R08: 0000000000000000 R09: 00007f9a8fd757b8
[Tue Mar 26 16:43:30 2019] R10: 0000000000000000 R11: 0000000000000246 R12: 00000000009f80ef
[Tue Mar 26 16:43:30 2019] R13: 0000000000006dc3 R14: 0000000000000b28 R15: 0000000000000005
[Tue Mar 26 16:43:30 2019] rsync           D    0 12425  12309 0x00000000
[Tue Mar 26 16:43:30 2019] Call Trace:
[Tue Mar 26 16:43:30 2019]  ? __schedule+0x429/0xbb0
[Tue Mar 26 16:43:30 2019]  schedule+0x39/0x90
[Tue Mar 26 16:43:30 2019]  io_schedule+0x12/0x40
[Tue Mar 26 16:43:30 2019]  wait_on_page_bit+0x10d/0x140
[Tue Mar 26 16:43:30 2019]  ? add_to_page_cache_lru+0xc0/0xc0
[Tue Mar 26 16:43:30 2019]  read_extent_buffer_pages+0x215/0x2d0
[Tue Mar 26 16:43:30 2019]  ? free_root_pointers+0x60/0x60
[Tue Mar 26 16:43:30 2019]  btree_read_extent_buffer_pages+0x86/0x100
[Tue Mar 26 16:43:30 2019]  read_tree_block+0x2d/0x50
[Tue Mar 26 16:43:30 2019]  read_block_for_search.isra.11+0x117/0x310
[Tue Mar 26 16:43:30 2019]  btrfs_search_slot+0x3e7/0x9c0
[Tue Mar 26 16:43:30 2019]  btrfs_lookup_inode+0x2a/0x90
[Tue Mar 26 16:43:30 2019]  btrfs_iget+0xea/0x6e0
[Tue Mar 26 16:43:30 2019]  btrfs_lookup_dentry+0x3ed/0x530
[Tue Mar 26 16:43:30 2019]  btrfs_lookup+0xe/0x30
[Tue Mar 26 16:43:30 2019]  lookup_slow+0x131/0x210
[Tue Mar 26 16:43:30 2019]  walk_component+0x1b2/0x2d0
[Tue Mar 26 16:43:30 2019]  path_lookupat+0x64/0x1f0
[Tue Mar 26 16:43:30 2019]  filename_lookup+0xa9/0x170
[Tue Mar 26 16:43:30 2019]  ? getname_flags+0x4a/0x1e0
[Tue Mar 26 16:43:30 2019]  ? __check_object_size+0xa7/0x190
[Tue Mar 26 16:43:30 2019]  ? strncpy_from_user+0x48/0x160
[Tue Mar 26 16:43:30 2019]  ? lockref_put_or_lock+0x9/0x30
[Tue Mar 26 16:43:30 2019]  ? vfs_statx+0x63/0xb0
[Tue Mar 26 16:43:30 2019]  vfs_statx+0x63/0xb0
[Tue Mar 26 16:43:30 2019]  ? mntput_no_expire+0x5/0x410
[Tue Mar 26 16:43:30 2019]  SyS_newlstat+0x2b/0x50
[Tue Mar 26 16:43:30 2019]  ? trace_hardirqs_off_thunk+0x1a/0x1c
[Tue Mar 26 16:43:30 2019]  do_syscall_64+0x76/0x180
[Tue Mar 26 16:43:30 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Tue Mar 26 16:43:30 2019] RIP: 0033:0x7ffaaf50b0f5
[Tue Mar 26 16:43:30 2019] RSP: 002b:00007ffc8acb9fb8 EFLAGS: 00000246 ORIG_RAX: 0000000000000006
[Tue Mar 26 16:43:30 2019] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007ffaaf50b0f5
[Tue Mar 26 16:43:30 2019] RDX: 00007ffc8acba0f0 RSI: 00007ffc8acba0f0 RDI: 00007ffc8acba180
[Tue Mar 26 16:43:30 2019] RBP: 0000000000000000 R08: 00007ffc8acba1e3 R09: 0000000000000000
[Tue Mar 26 16:43:30 2019] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffc8acba180
[Tue Mar 26 16:43:30 2019] R13: 00007ffc8acba0f0 R14: 0000000000000004 R15: 0000000000000002
[Tue Mar 26 16:43:30 2019] kworker/u8:14   D    0 13297      2 0x80000000
[Tue Mar 26 16:43:30 2019] Workqueue: btrfs-flush_delalloc btrfs_flush_delalloc_helper
[Tue Mar 26 16:43:30 2019] Call Trace:
[Tue Mar 26 16:43:30 2019]  ? __schedule+0x429/0xbb0
[Tue Mar 26 16:43:30 2019]  schedule+0x39/0x90
[Tue Mar 26 16:43:30 2019]  io_schedule+0x12/0x40
[Tue Mar 26 16:43:30 2019]  __lock_page+0x110/0x140
[Tue Mar 26 16:43:30 2019]  ? add_to_page_cache_lru+0xc0/0xc0
[Tue Mar 26 16:43:30 2019]  extent_write_cache_pages.constprop.27+0x2d9/0x3b0
[Tue Mar 26 16:43:30 2019]  ? lock_acquire+0xbc/0x200
[Tue Mar 26 16:43:30 2019]  extent_writepages+0x4e/0x70
[Tue Mar 26 16:43:30 2019]  ? btrfs_direct_IO+0x3e0/0x3e0
[Tue Mar 26 16:43:30 2019]  do_writepages+0x23/0x80
[Tue Mar 26 16:43:30 2019]  __filemap_fdatawrite_range+0xaa/0xe0
[Tue Mar 26 16:43:30 2019]  btrfs_run_delalloc_work+0x17/0x60
[Tue Mar 26 16:43:30 2019]  normal_work_helper+0x89/0x640
[Tue Mar 26 16:43:30 2019]  process_one_work+0x204/0x650
[Tue Mar 26 16:43:30 2019]  worker_thread+0x4d/0x3b0
[Tue Mar 26 16:43:30 2019]  kthread+0x10d/0x140
[Tue Mar 26 16:43:30 2019]  ? process_one_work+0x650/0x650
[Tue Mar 26 16:43:30 2019]  ? kthread_create_on_node+0x40/0x40
[Tue Mar 26 16:43:30 2019]  ret_from_fork+0x27/0x50
[Tue Mar 26 16:43:30 2019] rsync           D    0  9359   9358 0x00000000
[Tue Mar 26 16:43:30 2019] Call Trace:
[Tue Mar 26 16:43:30 2019]  ? __schedule+0x429/0xbb0
[Tue Mar 26 16:43:30 2019]  ? prepare_to_wait_event+0x97/0x190
[Tue Mar 26 16:43:30 2019]  schedule+0x39/0x90
[Tue Mar 26 16:43:30 2019]  wait_current_trans+0xa3/0xf0
[Tue Mar 26 16:43:30 2019]  ? wait_woken+0xa0/0xa0
[Tue Mar 26 16:43:30 2019]  start_transaction+0x29b/0x4d0
[Tue Mar 26 16:43:30 2019]  btrfs_create+0x47/0x1d0
[Tue Mar 26 16:43:30 2019]  lookup_open+0x404/0x760
[Tue Mar 26 16:43:30 2019]  ? __wake_up_common_lock+0x53/0x90
[Tue Mar 26 16:43:30 2019]  path_openat+0x4e9/0xcc0
[Tue Mar 26 16:43:30 2019]  do_filp_open+0x8a/0xf0
[Tue Mar 26 16:43:30 2019]  ? __alloc_fd+0xee/0x200
[Tue Mar 26 16:43:30 2019]  ? do_sys_open+0x130/0x200
[Tue Mar 26 16:43:30 2019]  do_sys_open+0x130/0x200
[Tue Mar 26 16:43:30 2019]  do_syscall_64+0x76/0x180
[Tue Mar 26 16:43:30 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Tue Mar 26 16:43:30 2019] RIP: 0033:0x7f544c09b4b0
[Tue Mar 26 16:43:30 2019] RSP: 002b:00007ffe6af72748 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
[Tue Mar 26 16:43:30 2019] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f544c09b4b0
[Tue Mar 26 16:43:30 2019] RDX: 0000000000000180 RSI: 00000000000000c2 RDI: 00007ffe6af749b0
[Tue Mar 26 16:43:30 2019] RBP: 000000000003a2f8 R08: 000000000000c0ff R09: 00007f544c0ee520
[Tue Mar 26 16:43:30 2019] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffe6af749ca
[Tue Mar 26 16:43:30 2019] R13: 8421084210842109 R14: 00000000000000c2 R15: 00007f544c129320
[Tue Mar 26 16:43:30 2019] rsync           D    0  8086   7962 0x00000000
[Tue Mar 26 16:43:30 2019] Call Trace:
[Tue Mar 26 16:43:30 2019]  ? __schedule+0x429/0xbb0
[Tue Mar 26 16:43:30 2019]  ? prepare_to_wait_event+0x97/0x190
[Tue Mar 26 16:43:30 2019]  schedule+0x39/0x90
[Tue Mar 26 16:43:30 2019]  wait_current_trans+0xa3/0xf0
[Tue Mar 26 16:43:30 2019]  ? wait_woken+0xa0/0xa0
[Tue Mar 26 16:43:30 2019]  start_transaction+0x29b/0x4d0
[Tue Mar 26 16:43:30 2019]  btrfs_start_transaction_fallback_global_rsv+0x34/0x200
[Tue Mar 26 16:43:30 2019]  btrfs_unlink+0x30/0xd0
[Tue Mar 26 16:43:30 2019]  vfs_unlink+0xf8/0x190
[Tue Mar 26 16:43:30 2019]  do_unlinkat+0x287/0x300
[Tue Mar 26 16:43:30 2019]  do_syscall_64+0x76/0x180
[Tue Mar 26 16:43:30 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Tue Mar 26 16:43:30 2019] RIP: 0033:0x7f9fa27c4ea7
[Tue Mar 26 16:43:30 2019] RSP: 002b:00007ffd1cf9a008 EFLAGS: 00000246 ORIG_RAX: 0000000000000057
[Tue Mar 26 16:43:30 2019] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007f9fa27c4ea7
[Tue Mar 26 16:43:30 2019] RDX: 0000000000000000 RSI: 00000000000081a4 RDI: 00007ffd1cf9b0c0
[Tue Mar 26 16:43:30 2019] RBP: 00000000000081a4 R08: 000000000000fcff R09: 00007f9fa2816100
[Tue Mar 26 16:43:30 2019] R10: 2f6d762f746f6f72 R11: 0000000000000246 R12: 00007ffd1cf9b0c0
[Tue Mar 26 16:43:30 2019] R13: 0000000000008000 R14: 0000000000000000 R15: 00000000000081a4
[Tue Mar 26 16:43:30 2019] kworker/u8:10   D    0 27109      2 0x80000000
[Tue Mar 26 16:43:30 2019] Workqueue: writeback wb_workfn (flush-btrfs-2)
[Tue Mar 26 16:43:30 2019] Call Trace:
[Tue Mar 26 16:43:30 2019]  ? __schedule+0x429/0xbb0
[Tue Mar 26 16:43:30 2019]  schedule+0x39/0x90
[Tue Mar 26 16:43:30 2019]  io_schedule+0x12/0x40
[Tue Mar 26 16:43:30 2019]  __lock_page+0x110/0x140
[Tue Mar 26 16:43:30 2019]  ? add_to_page_cache_lru+0xc0/0xc0
[Tue Mar 26 16:43:30 2019]  extent_write_cache_pages.constprop.27+0x2d9/0x3b0
[Tue Mar 26 16:43:30 2019]  ? writeback_sb_inodes+0x123/0x550
[Tue Mar 26 16:43:30 2019]  extent_writepages+0x4e/0x70
[Tue Mar 26 16:43:30 2019]  ? btrfs_direct_IO+0x3e0/0x3e0
[Tue Mar 26 16:43:30 2019]  do_writepages+0x23/0x80
[Tue Mar 26 16:43:30 2019]  __writeback_single_inode+0x54/0x740
[Tue Mar 26 16:43:30 2019]  writeback_sb_inodes+0x26e/0x550
[Tue Mar 26 16:43:30 2019]  __writeback_inodes_wb+0x87/0xb0
[Tue Mar 26 16:43:30 2019]  wb_writeback+0x3e9/0x550
[Tue Mar 26 16:43:30 2019]  ? wb_workfn+0x93/0x5c0
[Tue Mar 26 16:43:30 2019]  wb_workfn+0x93/0x5c0
[Tue Mar 26 16:43:30 2019]  ? lock_acquire+0xbc/0x200
[Tue Mar 26 16:43:30 2019]  process_one_work+0x204/0x650
[Tue Mar 26 16:43:30 2019]  worker_thread+0x4d/0x3b0
[Tue Mar 26 16:43:30 2019]  kthread+0x10d/0x140
[Tue Mar 26 16:43:30 2019]  ? process_one_work+0x650/0x650
[Tue Mar 26 16:43:30 2019]  ? kthread_create_on_node+0x40/0x40
[Tue Mar 26 16:43:30 2019]  ret_from_fork+0x27/0x50
[Tue Mar 26 16:43:30 2019] rsync           D    0  1942   1935 0x00000000
[Tue Mar 26 16:43:30 2019] Call Trace:
[Tue Mar 26 16:43:30 2019]  ? __schedule+0x429/0xbb0
[Tue Mar 26 16:43:30 2019]  ? prepare_to_wait_event+0x97/0x190
[Tue Mar 26 16:43:30 2019]  schedule+0x39/0x90
[Tue Mar 26 16:43:30 2019]  wait_current_trans+0xa3/0xf0
[Tue Mar 26 16:43:30 2019]  ? wait_woken+0xa0/0xa0
[Tue Mar 26 16:43:30 2019]  start_transaction+0x29b/0x4d0
[Tue Mar 26 16:43:30 2019]  btrfs_create+0x47/0x1d0
[Tue Mar 26 16:43:30 2019]  lookup_open+0x404/0x760
[Tue Mar 26 16:43:30 2019]  ? __wake_up_common_lock+0x53/0x90
[Tue Mar 26 16:43:30 2019]  path_openat+0x4e9/0xcc0
[Tue Mar 26 16:43:30 2019]  ? filemap_map_pages+0x312/0x520
[Tue Mar 26 16:43:30 2019]  do_filp_open+0x8a/0xf0
[Tue Mar 26 16:43:30 2019]  ? __alloc_fd+0xee/0x200
[Tue Mar 26 16:43:30 2019]  ? do_sys_open+0x130/0x200
[Tue Mar 26 16:43:30 2019]  do_sys_open+0x130/0x200
[Tue Mar 26 16:43:30 2019]  do_syscall_64+0x76/0x180
[Tue Mar 26 16:43:30 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Tue Mar 26 16:43:30 2019] RIP: 0033:0x7f71546634b0
[Tue Mar 26 16:43:30 2019] RSP: 002b:00007ffc31490108 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
[Tue Mar 26 16:43:30 2019] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f71546634b0
[Tue Mar 26 16:43:30 2019] RDX: 0000000000000180 RSI: 00000000000000c2 RDI: 00007ffc31492370
[Tue Mar 26 16:43:30 2019] RBP: 000000000003a2f8 R08: 000000000000c0ff R09: 00007f71546b5d30
[Tue Mar 26 16:43:30 2019] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffc31492382
[Tue Mar 26 16:43:30 2019] R13: 8421084210842109 R14: 00000000000000c2 R15: 00007f71546f1320
[Tue Mar 26 16:43:30 2019] rsync           D    0  4476   4465 0x00000000
[Tue Mar 26 16:43:30 2019] Call Trace:
[Tue Mar 26 16:43:30 2019]  ? __schedule+0x429/0xbb0
[Tue Mar 26 16:43:30 2019]  ? prepare_to_wait_event+0x97/0x190
[Tue Mar 26 16:43:30 2019]  schedule+0x39/0x90
[Tue Mar 26 16:43:30 2019]  wait_current_trans+0xa3/0xf0
[Tue Mar 26 16:43:30 2019]  ? wait_woken+0xa0/0xa0
[Tue Mar 26 16:43:30 2019]  start_transaction+0x29b/0x4d0
[Tue Mar 26 16:43:30 2019]  btrfs_create+0x47/0x1d0
[Tue Mar 26 16:43:30 2019]  lookup_open+0x404/0x760
[Tue Mar 26 16:43:30 2019]  ? __wake_up_common_lock+0x53/0x90
[Tue Mar 26 16:43:30 2019]  path_openat+0x4e9/0xcc0
[Tue Mar 26 16:43:30 2019]  ? filemap_map_pages+0x312/0x520
[Tue Mar 26 16:43:30 2019]  do_filp_open+0x8a/0xf0
[Tue Mar 26 16:43:30 2019]  ? __alloc_fd+0xee/0x200
[Tue Mar 26 16:43:30 2019]  ? do_sys_open+0x130/0x200
[Tue Mar 26 16:43:30 2019]  do_sys_open+0x130/0x200
[Tue Mar 26 16:43:30 2019]  do_syscall_64+0x76/0x180
[Tue Mar 26 16:43:30 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Tue Mar 26 16:43:30 2019] RIP: 0033:0x7f91a26c34b0
[Tue Mar 26 16:43:30 2019] RSP: 002b:00007ffe9c29d2d8 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
[Tue Mar 26 16:43:30 2019] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f91a26c34b0
[Tue Mar 26 16:43:30 2019] RDX: 0000000000000180 RSI: 00000000000000c2 RDI: 00007ffe9c29f540
[Tue Mar 26 16:43:30 2019] RBP: 000000000003a2f8 R08: 000000000000c0ff R09: 00007f91a2715950
[Tue Mar 26 16:43:30 2019] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffe9c29f557
[Tue Mar 26 16:43:30 2019] R13: 8421084210842109 R14: 00000000000000c2 R15: 00007f91a2751320
[Tue Mar 26 16:43:30 2019] mkdir           D    0  4816   4813 0x00000000
[Tue Mar 26 16:43:30 2019] Call Trace:
[Tue Mar 26 16:43:30 2019]  ? __schedule+0x429/0xbb0
[Tue Mar 26 16:43:30 2019]  ? prepare_to_wait_event+0x97/0x190
[Tue Mar 26 16:43:30 2019]  schedule+0x39/0x90
[Tue Mar 26 16:43:30 2019]  wait_current_trans+0xa3/0xf0
[Tue Mar 26 16:43:30 2019]  ? wait_woken+0xa0/0xa0
[Tue Mar 26 16:43:30 2019]  start_transaction+0x29b/0x4d0
[Tue Mar 26 16:43:30 2019]  btrfs_mkdir+0x50/0x1d0
[Tue Mar 26 16:43:30 2019]  vfs_mkdir+0x134/0x1c0
[Tue Mar 26 16:43:30 2019]  SyS_mkdirat+0xb3/0xf0
[Tue Mar 26 16:43:30 2019]  do_syscall_64+0x76/0x180
[Tue Mar 26 16:43:30 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Tue Mar 26 16:43:30 2019] RIP: 0033:0x7f36b3ccb447
[Tue Mar 26 16:43:30 2019] RSP: 002b:00007ffef220ed58 EFLAGS: 00000206 ORIG_RAX: 0000000000000053
[Tue Mar 26 16:43:30 2019] RAX: ffffffffffffffda RBX: 00007ffef2210b28 RCX: 00007f36b3ccb447
[Tue Mar 26 16:43:30 2019] RDX: 0000000000000000 RSI: 00000000000001ff RDI: 00007ffef2210b4d
[Tue Mar 26 16:43:30 2019] RBP: 00007ffef220eed0 R08: 00000000000001ff R09: 0000559b36eafe10
[Tue Mar 26 16:43:30 2019] R10: 0000000000000376 R11: 0000000000000206 R12: 0000559b36eafe50
[Tue Mar 26 16:43:30 2019] R13: 00000000000001ff R14: 00007ffef220f070 R15: 0000000000000001
[Tue Mar 26 16:43:30 2019] rsync           D    0  6356   6343 0x00000000
[Tue Mar 26 16:43:30 2019] Call Trace:
[Tue Mar 26 16:43:30 2019]  ? __schedule+0x429/0xbb0
[Tue Mar 26 16:43:30 2019]  ? prepare_to_wait_event+0x97/0x190
[Tue Mar 26 16:43:30 2019]  schedule+0x39/0x90
[Tue Mar 26 16:43:30 2019]  wait_current_trans+0xa3/0xf0
[Tue Mar 26 16:43:30 2019]  ? wait_woken+0xa0/0xa0
[Tue Mar 26 16:43:30 2019]  start_transaction+0x29b/0x4d0
[Tue Mar 26 16:43:30 2019]  btrfs_create+0x47/0x1d0
[Tue Mar 26 16:43:30 2019]  lookup_open+0x404/0x760
[Tue Mar 26 16:43:30 2019]  ? __wake_up_common_lock+0x53/0x90
[Tue Mar 26 16:43:30 2019]  path_openat+0x4e9/0xcc0
[Tue Mar 26 16:43:30 2019]  ? filemap_map_pages+0x312/0x520
[Tue Mar 26 16:43:30 2019]  do_filp_open+0x8a/0xf0
[Tue Mar 26 16:43:30 2019]  ? __alloc_fd+0xee/0x200
[Tue Mar 26 16:43:30 2019]  ? do_sys_open+0x130/0x200
[Tue Mar 26 16:43:30 2019]  do_sys_open+0x130/0x200
[Tue Mar 26 16:43:30 2019]  do_syscall_64+0x76/0x180
[Tue Mar 26 16:43:30 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Tue Mar 26 16:43:30 2019] RIP: 0033:0x7fd4586134b0
[Tue Mar 26 16:43:30 2019] RSP: 002b:00007ffd1348b1a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
[Tue Mar 26 16:43:30 2019] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fd4586134b0
[Tue Mar 26 16:43:30 2019] RDX: 0000000000000180 RSI: 00000000000000c2 RDI: 00007ffd1348d410
[Tue Mar 26 16:43:30 2019] RBP: 000000000003a2f8 R08: 000000000000c0ff R09: 00007fd458665950
[Tue Mar 26 16:43:30 2019] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffd1348d427
[Tue Mar 26 16:43:30 2019] R13: 8421084210842109 R14: 00000000000000c2 R15: 00007fd4586a1320
[Tue Mar 26 16:43:30 2019] rsync           D    0  6626   6625 0x00000000
[Tue Mar 26 16:43:30 2019] Call Trace:
[Tue Mar 26 16:43:30 2019]  ? __schedule+0x429/0xbb0
[Tue Mar 26 16:43:30 2019]  ? prepare_to_wait_event+0x97/0x190
[Tue Mar 26 16:43:30 2019]  schedule+0x39/0x90
[Tue Mar 26 16:43:30 2019]  wait_current_trans+0xa3/0xf0
[Tue Mar 26 16:43:30 2019]  ? wait_woken+0xa0/0xa0
[Tue Mar 26 16:43:30 2019]  start_transaction+0x29b/0x4d0
[Tue Mar 26 16:43:30 2019]  btrfs_create+0x47/0x1d0
[Tue Mar 26 16:43:30 2019]  lookup_open+0x404/0x760
[Tue Mar 26 16:43:30 2019]  ? __wake_up_common_lock+0x53/0x90
[Tue Mar 26 16:43:30 2019]  path_openat+0x4e9/0xcc0
[Tue Mar 26 16:43:30 2019]  ? filemap_map_pages+0x312/0x520
[Tue Mar 26 16:43:30 2019]  do_filp_open+0x8a/0xf0
[Tue Mar 26 16:43:30 2019]  ? __alloc_fd+0xee/0x200
[Tue Mar 26 16:43:30 2019]  ? do_sys_open+0x130/0x200
[Tue Mar 26 16:43:30 2019]  do_sys_open+0x130/0x200
[Tue Mar 26 16:43:30 2019]  do_syscall_64+0x76/0x180
[Tue Mar 26 16:43:30 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Tue Mar 26 16:43:30 2019] RIP: 0033:0x7fb8e7f0b4b0
[Tue Mar 26 16:43:30 2019] RSP: 002b:00007ffd490ae4b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
[Tue Mar 26 16:43:30 2019] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fb8e7f0b4b0
[Tue Mar 26 16:43:30 2019] RDX: 0000000000000180 RSI: 00000000000000c2 RDI: 00007ffd490b0720
[Tue Mar 26 16:43:30 2019] RBP: 000000000003a2f8 R08: 000000000000c0ff R09: 00007fb8e7f5d950
[Tue Mar 26 16:43:30 2019] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffd490b0737
[Tue Mar 26 16:43:30 2019] R13: 8421084210842109 R14: 00000000000000c2 R15: 00007fb8e7f99320
[Tue Mar 26 16:43:30 2019] rsync           D    0 17256  17192 0x00000000
[Tue Mar 26 16:43:30 2019] Call Trace:
[Tue Mar 26 16:43:30 2019]  ? __schedule+0x429/0xbb0
[Tue Mar 26 16:43:30 2019]  ? prepare_to_wait_event+0x97/0x190
[Tue Mar 26 16:43:30 2019]  schedule+0x39/0x90
[Tue Mar 26 16:43:30 2019]  wait_current_trans+0xa3/0xf0
[Tue Mar 26 16:43:30 2019]  ? wait_woken+0xa0/0xa0
[Tue Mar 26 16:43:30 2019]  start_transaction+0x29b/0x4d0
[Tue Mar 26 16:43:30 2019]  btrfs_create+0x47/0x1d0
[Tue Mar 26 16:43:30 2019]  lookup_open+0x404/0x760
[Tue Mar 26 16:43:30 2019]  ? __wake_up_common_lock+0x53/0x90
[Tue Mar 26 16:43:30 2019]  path_openat+0x4e9/0xcc0
[Tue Mar 26 16:43:30 2019]  ? filemap_map_pages+0x312/0x520
[Tue Mar 26 16:43:30 2019]  do_filp_open+0x8a/0xf0
[Tue Mar 26 16:43:30 2019]  ? __alloc_fd+0xee/0x200
[Tue Mar 26 16:43:30 2019]  ? do_sys_open+0x130/0x200
[Tue Mar 26 16:43:30 2019]  do_sys_open+0x130/0x200
[Tue Mar 26 16:43:30 2019]  do_syscall_64+0x76/0x180
[Tue Mar 26 16:43:30 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Tue Mar 26 16:43:30 2019] RIP: 0033:0x7ff14b15b4b0
[Tue Mar 26 16:43:30 2019] RSP: 002b:00007ffc30512e28 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
[Tue Mar 26 16:43:30 2019] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007ff14b15b4b0
[Tue Mar 26 16:43:30 2019] RDX: 0000000000000180 RSI: 00000000000000c2 RDI: 00007ffc30515090
[Tue Mar 26 16:43:30 2019] RBP: 000000000003a2f8 R08: 000000000000fff8 R09: 00007ff14b1adf10
[Tue Mar 26 16:43:30 2019] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffc305150ad
[Tue Mar 26 16:43:30 2019] R13: 8421084210842109 R14: 00000000000000c2 R15: 00007ff14b1e9320
[Tue Mar 26 16:43:30 2019] rsync           D    0 29615  29614 0x00000000
[Tue Mar 26 16:43:30 2019] Call Trace:
[Tue Mar 26 16:43:30 2019]  ? __schedule+0x429/0xbb0
[Tue Mar 26 16:43:30 2019]  ? prepare_to_wait_event+0x97/0x190
[Tue Mar 26 16:43:30 2019]  schedule+0x39/0x90
[Tue Mar 26 16:43:30 2019]  wait_current_trans+0xa3/0xf0
[Tue Mar 26 16:43:30 2019]  ? wait_woken+0xa0/0xa0
[Tue Mar 26 16:43:30 2019]  start_transaction+0x29b/0x4d0
[Tue Mar 26 16:43:30 2019]  btrfs_create+0x47/0x1d0
[Tue Mar 26 16:43:30 2019]  lookup_open+0x404/0x760
[Tue Mar 26 16:43:30 2019]  ? __wake_up_common_lock+0x53/0x90
[Tue Mar 26 16:43:30 2019]  path_openat+0x4e9/0xcc0
[Tue Mar 26 16:43:30 2019]  ? __switch_to_asm+0x40/0x70
[Tue Mar 26 16:43:30 2019]  ? __switch_to_asm+0x34/0x70
[Tue Mar 26 16:43:30 2019]  ? __switch_to_asm+0x40/0x70
[Tue Mar 26 16:43:30 2019]  do_filp_open+0x8a/0xf0
[Tue Mar 26 16:43:30 2019]  ? __alloc_fd+0xee/0x200
[Tue Mar 26 16:43:30 2019]  ? do_sys_open+0x130/0x200
[Tue Mar 26 16:43:30 2019]  do_sys_open+0x130/0x200
[Tue Mar 26 16:43:30 2019]  do_syscall_64+0x76/0x180
[Tue Mar 26 16:43:30 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Tue Mar 26 16:43:30 2019] RIP: 0033:0x7f8c4eb534b0
[Tue Mar 26 16:43:30 2019] RSP: 002b:00007ffe290f35b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
[Tue Mar 26 16:43:30 2019] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f8c4eb534b0
[Tue Mar 26 16:43:30 2019] RDX: 0000000000000180 RSI: 00000000000000c2 RDI: 00007ffe290f5820
[Tue Mar 26 16:43:30 2019] RBP: 000000000003a2f8 R08: 000000000000ffff R09: 00007f8c4eba6520
[Tue Mar 26 16:43:30 2019] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffe290f5833
[Tue Mar 26 16:43:30 2019] R13: 8421084210842109 R14: 00000000000000c2 R15: 00007f8c4ebe1320
[Tue Mar 26 16:43:30 2019] rsync           D    0  7453   7452 0x00000000
[Tue Mar 26 16:43:30 2019] Call Trace:
[Tue Mar 26 16:43:30 2019]  ? __schedule+0x429/0xbb0
[Tue Mar 26 16:43:30 2019]  ? prepare_to_wait_event+0x97/0x190
[Tue Mar 26 16:43:30 2019]  schedule+0x39/0x90
[Tue Mar 26 16:43:30 2019]  wait_current_trans+0xa3/0xf0
[Tue Mar 26 16:43:30 2019]  ? wait_woken+0xa0/0xa0
[Tue Mar 26 16:43:30 2019]  start_transaction+0x29b/0x4d0
[Tue Mar 26 16:43:30 2019]  btrfs_create+0x47/0x1d0
[Tue Mar 26 16:43:30 2019]  lookup_open+0x404/0x760
[Tue Mar 26 16:43:30 2019]  ? __wake_up_common_lock+0x53/0x90
[Tue Mar 26 16:43:30 2019]  path_openat+0x4e9/0xcc0
[Tue Mar 26 16:43:30 2019]  ? filemap_map_pages+0x312/0x520
[Tue Mar 26 16:43:30 2019]  do_filp_open+0x8a/0xf0
[Tue Mar 26 16:43:30 2019]  ? __alloc_fd+0xee/0x200
[Tue Mar 26 16:43:30 2019]  ? do_sys_open+0x130/0x200
[Tue Mar 26 16:43:30 2019]  do_sys_open+0x130/0x200
[Tue Mar 26 16:43:30 2019]  do_syscall_64+0x76/0x180
[Tue Mar 26 16:43:30 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Tue Mar 26 16:43:30 2019] RIP: 0033:0x7f444631b4b0
[Tue Mar 26 16:43:30 2019] RSP: 002b:00007ffdf129fa38 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
[Tue Mar 26 16:43:30 2019] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f444631b4b0
[Tue Mar 26 16:43:30 2019] RDX: 0000000000000180 RSI: 00000000000000c2 RDI: 00007ffdf12a1ca0
[Tue Mar 26 16:43:30 2019] RBP: 000000000003a2f8 R08: 000000000000c0ff R09: 00007f444636d950
[Tue Mar 26 16:43:30 2019] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffdf12a1cb7
[Tue Mar 26 16:43:30 2019] R13: 8421084210842109 R14: 00000000000000c2 R15: 00007f44463a9320
[Tue Mar 26 16:43:30 2019] rsync           D    0 29610  29604 0x00000000
[Tue Mar 26 16:43:30 2019] Call Trace:
[Tue Mar 26 16:43:30 2019]  ? __schedule+0x429/0xbb0
[Tue Mar 26 16:43:30 2019]  ? prepare_to_wait_event+0x97/0x190
[Tue Mar 26 16:43:30 2019]  schedule+0x39/0x90
[Tue Mar 26 16:43:30 2019]  wait_current_trans+0xa3/0xf0
[Tue Mar 26 16:43:30 2019]  ? wait_woken+0xa0/0xa0
[Tue Mar 26 16:43:30 2019]  start_transaction+0x29b/0x4d0
[Tue Mar 26 16:43:30 2019]  btrfs_mkdir+0x50/0x1d0
[Tue Mar 26 16:43:30 2019]  vfs_mkdir+0x134/0x1c0
[Tue Mar 26 16:43:30 2019]  SyS_mkdirat+0xb3/0xf0
[Tue Mar 26 16:43:30 2019]  do_syscall_64+0x76/0x180
[Tue Mar 26 16:43:30 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Tue Mar 26 16:43:30 2019] RIP: 0033:0x7f0d5147b447
[Tue Mar 26 16:43:30 2019] RSP: 002b:00007fff61e45d08 EFLAGS: 00000202 ORIG_RAX: 0000000000000053
[Tue Mar 26 16:43:30 2019] RAX: ffffffffffffffda RBX: 00000000000001c0 RCX: 00007f0d5147b447
[Tue Mar 26 16:43:30 2019] RDX: fec4ff0000000000 RSI: 00000000000001c0 RDI: 00007fff61e48060
[Tue Mar 26 16:43:30 2019] RBP: 00007f0d51f3d7a0 R08: 000000000000ff00 R09: 00000000ffffffff
[Tue Mar 26 16:43:30 2019] R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000002
[Tue Mar 26 16:43:30 2019] R13: 0000000000000000 R14: 00007fff61e48060 R15: 00000000ffffffff
[Tue Mar 26 16:43:30 2019] rsync           D    0 29638  29610 0x00000000
[Tue Mar 26 16:43:30 2019] Call Trace:
[Tue Mar 26 16:43:30 2019]  ? __schedule+0x429/0xbb0
[Tue Mar 26 16:43:30 2019]  ? prepare_to_wait_event+0x97/0x190
[Tue Mar 26 16:43:30 2019]  schedule+0x39/0x90
[Tue Mar 26 16:43:30 2019]  wait_current_trans+0xa3/0xf0
[Tue Mar 26 16:43:30 2019]  ? wait_woken+0xa0/0xa0
[Tue Mar 26 16:43:30 2019]  start_transaction+0x29b/0x4d0
[Tue Mar 26 16:43:30 2019]  btrfs_create+0x47/0x1d0
[Tue Mar 26 16:43:30 2019]  lookup_open+0x404/0x760
[Tue Mar 26 16:43:30 2019]  ? __wake_up_common_lock+0x53/0x90
[Tue Mar 26 16:43:30 2019]  path_openat+0x4e9/0xcc0
[Tue Mar 26 16:43:30 2019]  ? filemap_map_pages+0x312/0x520
[Tue Mar 26 16:43:30 2019]  do_filp_open+0x8a/0xf0
[Tue Mar 26 16:43:30 2019]  ? __alloc_fd+0xee/0x200
[Tue Mar 26 16:43:30 2019]  ? do_sys_open+0x130/0x200
[Tue Mar 26 16:43:30 2019]  do_sys_open+0x130/0x200
[Tue Mar 26 16:43:30 2019]  do_syscall_64+0x76/0x180
[Tue Mar 26 16:43:30 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Tue Mar 26 16:43:30 2019] RIP: 0033:0x7f0d5147b4b0
[Tue Mar 26 16:43:30 2019] RSP: 002b:00007fff61e44df8 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
[Tue Mar 26 16:43:30 2019] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f0d5147b4b0
[Tue Mar 26 16:43:30 2019] RDX: 0000000000000180 RSI: 00000000000000c2 RDI: 00007fff61e47060
[Tue Mar 26 16:43:30 2019] RBP: 000000000003a2f8 R08: 000000000000ffff R09: 00007f0d514cdd40
[Tue Mar 26 16:43:30 2019] R10: 0000000000000000 R11: 0000000000000246 R12: 00007fff61e47075
[Tue Mar 26 16:43:30 2019] R13: 8421084210842109 R14: 00000000000000c2 R15: 00007f0d51509320
[Tue Mar 26 16:43:30 2019] rsync           D    0 10214  10213 0x00000000
[Tue Mar 26 16:43:30 2019] Call Trace:
[Tue Mar 26 16:43:30 2019]  ? __schedule+0x429/0xbb0
[Tue Mar 26 16:43:30 2019]  ? prepare_to_wait_event+0x97/0x190
[Tue Mar 26 16:43:30 2019]  schedule+0x39/0x90
[Tue Mar 26 16:43:30 2019]  wait_current_trans+0xa3/0xf0
[Tue Mar 26 16:43:30 2019]  ? wait_woken+0xa0/0xa0
[Tue Mar 26 16:43:30 2019]  start_transaction+0x29b/0x4d0
[Tue Mar 26 16:43:30 2019]  btrfs_create+0x47/0x1d0
[Tue Mar 26 16:43:30 2019]  lookup_open+0x404/0x760
[Tue Mar 26 16:43:30 2019]  ? __wake_up_common_lock+0x53/0x90
[Tue Mar 26 16:43:30 2019]  path_openat+0x4e9/0xcc0
[Tue Mar 26 16:43:30 2019]  ? filemap_map_pages+0x312/0x520
[Tue Mar 26 16:43:30 2019]  do_filp_open+0x8a/0xf0
[Tue Mar 26 16:43:30 2019]  ? __alloc_fd+0xee/0x200
[Tue Mar 26 16:43:30 2019]  ? do_sys_open+0x130/0x200
[Tue Mar 26 16:43:30 2019]  do_sys_open+0x130/0x200
[Tue Mar 26 16:43:30 2019]  do_syscall_64+0x76/0x180
[Tue Mar 26 16:43:30 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Tue Mar 26 16:43:30 2019] RIP: 0033:0x7f73b40db4b0
[Tue Mar 26 16:43:30 2019] RSP: 002b:00007ffc80e88938 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
[Tue Mar 26 16:43:30 2019] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f73b40db4b0
[Tue Mar 26 16:43:30 2019] RDX: 0000000000000180 RSI: 00000000000000c2 RDI: 00007ffc80e8aba0
[Tue Mar 26 16:43:30 2019] RBP: 000000000003a2f8 R08: 000000000000c0ff R09: 00007f73b412d950
[Tue Mar 26 16:43:30 2019] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffc80e8abb7
[Tue Mar 26 16:43:30 2019] R13: 8421084210842109 R14: 00000000000000c2 R15: 00007f73b4169320
[Tue Mar 26 16:43:30 2019] rsync           D    0 29837  29758 0x00000000
[Tue Mar 26 16:43:30 2019] Call Trace:
[Tue Mar 26 16:43:30 2019]  ? __schedule+0x429/0xbb0
[Tue Mar 26 16:43:30 2019]  ? prepare_to_wait_event+0x97/0x190
[Tue Mar 26 16:43:30 2019]  schedule+0x39/0x90
[Tue Mar 26 16:43:30 2019]  wait_current_trans+0xa3/0xf0
[Tue Mar 26 16:43:30 2019]  ? wait_woken+0xa0/0xa0
[Tue Mar 26 16:43:30 2019]  start_transaction+0x29b/0x4d0
[Tue Mar 26 16:43:30 2019]  btrfs_create+0x47/0x1d0
[Tue Mar 26 16:43:30 2019]  lookup_open+0x404/0x760
[Tue Mar 26 16:43:30 2019]  ? __wake_up_common_lock+0x53/0x90
[Tue Mar 26 16:43:30 2019]  path_openat+0x4e9/0xcc0
[Tue Mar 26 16:43:30 2019]  ? filemap_map_pages+0x312/0x520
[Tue Mar 26 16:43:30 2019]  do_filp_open+0x8a/0xf0
[Tue Mar 26 16:43:30 2019]  ? __alloc_fd+0xee/0x200
[Tue Mar 26 16:43:30 2019]  ? do_sys_open+0x130/0x200
[Tue Mar 26 16:43:30 2019]  do_sys_open+0x130/0x200
[Tue Mar 26 16:43:30 2019]  do_syscall_64+0x76/0x180
[Tue Mar 26 16:43:30 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Tue Mar 26 16:43:30 2019] RIP: 0033:0x7f3dd5d734b0
[Tue Mar 26 16:43:30 2019] RSP: 002b:00007ffdceac6b38 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
[Tue Mar 26 16:43:30 2019] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f3dd5d734b0
[Tue Mar 26 16:43:30 2019] RDX: 0000000000000180 RSI: 00000000000000c2 RDI: 00007ffdceac8da0
[Tue Mar 26 16:43:30 2019] RBP: 000000000003a2f8 R08: 0000000000000000 R09: 00007f3dd5dc6100
[Tue Mar 26 16:43:30 2019] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffdceac8dcb
[Tue Mar 26 16:43:30 2019] R13: 8421084210842109 R14: 00000000000000c2 R15: 00007f3dd5e01320
[Tue Mar 26 16:43:30 2019] rsync           D    0 31885  31792 0x00000000
[Tue Mar 26 16:43:30 2019] Call Trace:
[Tue Mar 26 16:43:30 2019]  ? __schedule+0x429/0xbb0
[Tue Mar 26 16:43:30 2019]  ? prepare_to_wait_event+0x97/0x190
[Tue Mar 26 16:43:30 2019]  schedule+0x39/0x90
[Tue Mar 26 16:43:30 2019]  wait_current_trans+0xa3/0xf0
[Tue Mar 26 16:43:30 2019]  ? wait_woken+0xa0/0xa0
[Tue Mar 26 16:43:30 2019]  start_transaction+0x29b/0x4d0
[Tue Mar 26 16:43:30 2019]  btrfs_create+0x47/0x1d0
[Tue Mar 26 16:43:30 2019]  lookup_open+0x404/0x760
[Tue Mar 26 16:43:30 2019]  ? __wake_up_common_lock+0x53/0x90
[Tue Mar 26 16:43:30 2019]  path_openat+0x4e9/0xcc0
[Tue Mar 26 16:43:30 2019]  ? filemap_map_pages+0x312/0x520
[Tue Mar 26 16:43:30 2019]  do_filp_open+0x8a/0xf0
[Tue Mar 26 16:43:30 2019]  ? __alloc_fd+0xee/0x200
[Tue Mar 26 16:43:30 2019]  ? do_sys_open+0x130/0x200
[Tue Mar 26 16:43:30 2019]  do_sys_open+0x130/0x200
[Tue Mar 26 16:43:30 2019]  do_syscall_64+0x76/0x180
[Tue Mar 26 16:43:30 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Tue Mar 26 16:43:30 2019] RIP: 0033:0x7f80265f34b0
[Tue Mar 26 16:43:30 2019] RSP: 002b:00007fffeeff2558 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
[Tue Mar 26 16:43:30 2019] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f80265f34b0
[Tue Mar 26 16:43:30 2019] RDX: 0000000000000180 RSI: 00000000000000c2 RDI: 00007fffeeff47c0
[Tue Mar 26 16:43:30 2019] RBP: 000000000003a2f8 R08: 000000000000c000 R09: 00007f8026646100
[Tue Mar 26 16:43:30 2019] R10: 0000000000000000 R11: 0000000000000246 R12: 00007fffeeff47e8
[Tue Mar 26 16:43:30 2019] R13: 8421084210842109 R14: 00000000000000c2 R15: 00007f8026681320
[Tue Mar 26 16:43:30 2019] rsync           D    0  7092   7091 0x00000000
[Tue Mar 26 16:43:30 2019] Call Trace:
[Tue Mar 26 16:43:30 2019]  ? __schedule+0x429/0xbb0
[Tue Mar 26 16:43:30 2019]  ? prepare_to_wait_event+0x97/0x190
[Tue Mar 26 16:43:30 2019]  schedule+0x39/0x90
[Tue Mar 26 16:43:30 2019]  wait_current_trans+0xa3/0xf0
[Tue Mar 26 16:43:30 2019]  ? wait_woken+0xa0/0xa0
[Tue Mar 26 16:43:30 2019]  start_transaction+0x29b/0x4d0
[Tue Mar 26 16:43:30 2019]  btrfs_create+0x47/0x1d0
[Tue Mar 26 16:43:30 2019]  lookup_open+0x404/0x760
[Tue Mar 26 16:43:30 2019]  ? __wake_up_common_lock+0x53/0x90
[Tue Mar 26 16:43:30 2019]  path_openat+0x4e9/0xcc0
[Tue Mar 26 16:43:30 2019]  ? filemap_map_pages+0x312/0x520
[Tue Mar 26 16:43:30 2019]  do_filp_open+0x8a/0xf0
[Tue Mar 26 16:43:30 2019]  ? __alloc_fd+0xee/0x200
[Tue Mar 26 16:43:30 2019]  ? do_sys_open+0x130/0x200
[Tue Mar 26 16:43:30 2019]  do_sys_open+0x130/0x200
[Tue Mar 26 16:43:30 2019]  do_syscall_64+0x76/0x180
[Tue Mar 26 16:43:30 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Tue Mar 26 16:43:30 2019] RIP: 0033:0x7f26f47eb4b0
[Tue Mar 26 16:43:30 2019] RSP: 002b:00007ffd94a0fe08 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
[Tue Mar 26 16:43:30 2019] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f26f47eb4b0
[Tue Mar 26 16:43:30 2019] RDX: 0000000000000180 RSI: 00000000000000c2 RDI: 00007ffd94a12070
[Tue Mar 26 16:43:30 2019] RBP: 000000000003a2f8 R08: 000000000000c0ff R09: 00007f26f483d950
[Tue Mar 26 16:43:30 2019] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffd94a12087
[Tue Mar 26 16:43:30 2019] R13: 8421084210842109 R14: 00000000000000c2 R15: 00007f26f4879320
[Tue Mar 26 16:43:30 2019] rsync           D    0 10725  10712 0x00000000
[Tue Mar 26 16:43:30 2019] Call Trace:
[Tue Mar 26 16:43:30 2019]  ? __schedule+0x429/0xbb0
[Tue Mar 26 16:43:30 2019]  ? prepare_to_wait_event+0x97/0x190
[Tue Mar 26 16:43:30 2019]  schedule+0x39/0x90
[Tue Mar 26 16:43:30 2019]  wait_current_trans+0xa3/0xf0
[Tue Mar 26 16:43:30 2019]  ? wait_woken+0xa0/0xa0
[Tue Mar 26 16:43:30 2019]  start_transaction+0x29b/0x4d0
[Tue Mar 26 16:43:30 2019]  btrfs_create+0x47/0x1d0
[Tue Mar 26 16:43:30 2019]  lookup_open+0x404/0x760
[Tue Mar 26 16:43:30 2019]  ? __wake_up_common_lock+0x53/0x90
[Tue Mar 26 16:43:30 2019]  path_openat+0x4e9/0xcc0
[Tue Mar 26 16:43:30 2019]  ? filemap_map_pages+0x312/0x520
[Tue Mar 26 16:43:30 2019]  do_filp_open+0x8a/0xf0
[Tue Mar 26 16:43:30 2019]  ? __alloc_fd+0xee/0x200
[Tue Mar 26 16:43:30 2019]  ? do_sys_open+0x130/0x200
[Tue Mar 26 16:43:30 2019]  do_sys_open+0x130/0x200
[Tue Mar 26 16:43:30 2019]  do_syscall_64+0x76/0x180
[Tue Mar 26 16:43:30 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Tue Mar 26 16:43:30 2019] RIP: 0033:0x7ff22e1c34b0
[Tue Mar 26 16:43:30 2019] RSP: 002b:00007ffc04b5c158 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
[Tue Mar 26 16:43:30 2019] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007ff22e1c34b0
[Tue Mar 26 16:43:30 2019] RDX: 0000000000000180 RSI: 00000000000000c2 RDI: 00007ffc04b5e3c0
[Tue Mar 26 16:43:30 2019] RBP: 000000000003a2f8 R08: 000000000000c0ff R09: 00007ff22e215950
[Tue Mar 26 16:43:30 2019] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffc04b5e3d7
[Tue Mar 26 16:43:30 2019] R13: 8421084210842109 R14: 00000000000000c2 R15: 00007ff22e251320
[Tue Mar 26 16:43:30 2019] rsync           D    0 27579  27578 0x00000000
[Tue Mar 26 16:43:30 2019] Call Trace:
[Tue Mar 26 16:43:30 2019]  ? __schedule+0x429/0xbb0
[Tue Mar 26 16:43:30 2019]  ? prepare_to_wait_event+0x97/0x190
[Tue Mar 26 16:43:30 2019]  schedule+0x39/0x90
[Tue Mar 26 16:43:30 2019]  wait_current_trans+0xa3/0xf0
[Tue Mar 26 16:43:30 2019]  ? wait_woken+0xa0/0xa0
[Tue Mar 26 16:43:30 2019]  start_transaction+0x29b/0x4d0
[Tue Mar 26 16:43:30 2019]  btrfs_create+0x47/0x1d0
[Tue Mar 26 16:43:30 2019]  lookup_open+0x404/0x760
[Tue Mar 26 16:43:30 2019]  ? __wake_up_common_lock+0x53/0x90
[Tue Mar 26 16:43:30 2019]  path_openat+0x4e9/0xcc0
[Tue Mar 26 16:43:30 2019]  ? filemap_map_pages+0x312/0x520
[Tue Mar 26 16:43:30 2019]  do_filp_open+0x8a/0xf0
[Tue Mar 26 16:43:30 2019]  ? __alloc_fd+0xee/0x200
[Tue Mar 26 16:43:30 2019]  ? do_sys_open+0x130/0x200
[Tue Mar 26 16:43:30 2019]  do_sys_open+0x130/0x200
[Tue Mar 26 16:43:30 2019]  do_syscall_64+0x76/0x180
[Tue Mar 26 16:43:30 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Tue Mar 26 16:43:30 2019] RIP: 0033:0x7f046d3a34b0
[Tue Mar 26 16:43:30 2019] RSP: 002b:00007ffca2430798 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
[Tue Mar 26 16:43:30 2019] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f046d3a34b0
[Tue Mar 26 16:43:30 2019] RDX: 0000000000000180 RSI: 00000000000000c2 RDI: 00007ffca2432a00
[Tue Mar 26 16:43:30 2019] RBP: 000000000003a2f8 R08: 000000000000c0ff R09: 00007f046d3f5950
[Tue Mar 26 16:43:30 2019] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffca2432a17
[Tue Mar 26 16:43:30 2019] R13: 8421084210842109 R14: 00000000000000c2 R15: 00007f046d431320
[Tue Mar 26 16:43:30 2019] rsync           D    0 27949  27856 0x00000000
[Tue Mar 26 16:43:30 2019] Call Trace:
[Tue Mar 26 16:43:30 2019]  ? __schedule+0x429/0xbb0
[Tue Mar 26 16:43:30 2019]  ? prepare_to_wait_event+0x97/0x190
[Tue Mar 26 16:43:30 2019]  schedule+0x39/0x90
[Tue Mar 26 16:43:30 2019]  wait_current_trans+0xa3/0xf0
[Tue Mar 26 16:43:30 2019]  ? wait_woken+0xa0/0xa0
[Tue Mar 26 16:43:30 2019]  start_transaction+0x29b/0x4d0
[Tue Mar 26 16:43:30 2019]  btrfs_create+0x47/0x1d0
[Tue Mar 26 16:43:30 2019]  lookup_open+0x404/0x760
[Tue Mar 26 16:43:30 2019]  ? __wake_up_common_lock+0x53/0x90
[Tue Mar 26 16:43:30 2019]  path_openat+0x4e9/0xcc0
[Tue Mar 26 16:43:30 2019]  ? filemap_map_pages+0x312/0x520
[Tue Mar 26 16:43:30 2019]  do_filp_open+0x8a/0xf0
[Tue Mar 26 16:43:30 2019]  ? __alloc_fd+0xee/0x200
[Tue Mar 26 16:43:30 2019]  ? do_sys_open+0x130/0x200
[Tue Mar 26 16:43:30 2019]  do_sys_open+0x130/0x200
[Tue Mar 26 16:43:30 2019]  do_syscall_64+0x76/0x180
[Tue Mar 26 16:43:30 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Tue Mar 26 16:43:30 2019] RIP: 0033:0x7f7421ff34b0
[Tue Mar 26 16:43:30 2019] RSP: 002b:00007ffe22c079d8 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
[Tue Mar 26 16:43:30 2019] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f7421ff34b0
[Tue Mar 26 16:43:30 2019] RDX: 0000000000000180 RSI: 00000000000000c2 RDI: 00007ffe22c09c40
[Tue Mar 26 16:43:30 2019] RBP: 000000000003a2f8 R08: 000000000000ffff R09: 00007f7422045b30
[Tue Mar 26 16:43:30 2019] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffe22c09c80
[Tue Mar 26 16:43:30 2019] R13: 8421084210842109 R14: 00000000000000c2 R15: 00007f7422081320
[Tue Mar 26 16:43:30 2019] rsync           D    0  7504   7417 0x00000000
[Tue Mar 26 16:43:30 2019] Call Trace:
[Tue Mar 26 16:43:30 2019]  ? __schedule+0x429/0xbb0
[Tue Mar 26 16:43:30 2019]  ? prepare_to_wait_event+0x97/0x190
[Tue Mar 26 16:43:30 2019]  schedule+0x39/0x90
[Tue Mar 26 16:43:30 2019]  wait_current_trans+0xa3/0xf0
[Tue Mar 26 16:43:30 2019]  ? wait_woken+0xa0/0xa0
[Tue Mar 26 16:43:30 2019]  start_transaction+0x29b/0x4d0
[Tue Mar 26 16:43:30 2019]  btrfs_mkdir+0x50/0x1d0
[Tue Mar 26 16:43:30 2019]  vfs_mkdir+0x134/0x1c0
[Tue Mar 26 16:43:30 2019]  SyS_mkdirat+0xb3/0xf0
[Tue Mar 26 16:43:30 2019]  do_syscall_64+0x76/0x180
[Tue Mar 26 16:43:30 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Tue Mar 26 16:43:30 2019] RIP: 0033:0x7f92bc98b447
[Tue Mar 26 16:43:30 2019] RSP: 002b:00007ffde7124dd8 EFLAGS: 00000202 ORIG_RAX: 0000000000000053
[Tue Mar 26 16:43:30 2019] RAX: ffffffffffffffda RBX: 00000000000001c0 RCX: 00007f92bc98b447
[Tue Mar 26 16:43:30 2019] RDX: 0c00000000000000 RSI: 00000000000001c0 RDI: 00007ffde7127130
[Tue Mar 26 16:43:30 2019] RBP: 000055b32c935790 R08: 0000000000000000 R09: 00000000ffffffff
[Tue Mar 26 16:43:30 2019] R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000002
[Tue Mar 26 16:43:30 2019] R13: 0000000000000000 R14: 00007ffde7127130 R15: 00000000ffffffff
