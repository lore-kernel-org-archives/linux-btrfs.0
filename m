Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:36046 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932134AbbCEKRR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Mar 2015 05:17:17 -0500
Received: by labgd6 with SMTP id gd6so3352238lab.3
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Mar 2015 02:17:15 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20150305025628.GA1593@hungrycats.org>
References: <20150305025628.GA1593@hungrycats.org>
Date: Thu, 5 Mar 2015 10:17:14 +0000
Message-ID: <CAL3q7H6VAD1bRfJy6TC1qbN24uFC2xvmrVamWn5OrKVvbHjP8Q@mail.gmail.com>
Subject: Re: rsync vs. extent-same: this time with lock debugging (still v3.18.8)
From: Filipe David Manana <fdmanana@gmail.com>
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Mark Fasheh <mfasheh@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 5, 2015 at 2:56 AM, Zygo Blaxell
<ce3g8jdj@umail.furryterror.org> wrote:
> rsync seems to get stuck just by reading the same file that extent-same is
> acting upon.
>
> Mar  4 21:35:08 sneezy kernel: [89798.758960] INFO: task rsync:7425 blocked for more than 1800 seconds.
> Mar  4 21:35:08 sneezy kernel: [89798.759007]       Tainted: G        W      3.18.8-zb64+ #1
> Mar  4 21:35:08 sneezy kernel: [89798.759048] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Mar  4 21:35:08 sneezy kernel: [89798.759121] rsync           D 0000000000000000     0  7425   7423 0x00000000
> Mar  4 21:35:08 sneezy kernel: [89798.759129]  ffff88005afaf988 0000000000000096 0000000000000286 ffff8800036c1000
> Mar  4 21:35:08 sneezy kernel: [89798.759135]  00000000001e0880 ffffffff81e452d0 ffff88005afaffd8 00000000001e0880
> Mar  4 21:35:08 sneezy kernel: [89798.759141]  ffff88024dac9000 ffff8800036c1000 ffff88005afaf8b8 0000000000000000
> Mar  4 21:35:08 sneezy kernel: [89798.759147] Call Trace:
> Mar  4 21:35:08 sneezy kernel: [89798.759158]  [<ffffffff810211fd>] ? native_sched_clock+0x2d/0xb0
> Mar  4 21:35:08 sneezy kernel: [89798.759164]  [<ffffffff810c61fe>] ? put_lock_stats.isra.18+0xe/0x30
> Mar  4 21:35:08 sneezy kernel: [89798.759170]  [<ffffffff810c638d>] ? lock_release_holdtime.part.19+0x16d/0x220
> Mar  4 21:35:08 sneezy kernel: [89798.759176]  [<ffffffff813bb208>] ? lock_extent_bits+0x1a8/0x200
> Mar  4 21:35:08 sneezy kernel: [89798.759182]  [<ffffffff818b1989>] schedule+0x29/0x70
> Mar  4 21:35:08 sneezy kernel: [89798.759187]  [<ffffffff813bb20d>] lock_extent_bits+0x1ad/0x200
> Mar  4 21:35:08 sneezy kernel: [89798.759192]  [<ffffffff810bd940>] ? __wake_up_sync+0x20/0x20
> Mar  4 21:35:08 sneezy kernel: [89798.759197]  [<ffffffff813bb273>] lock_extent+0x13/0x20
> Mar  4 21:35:08 sneezy kernel: [89798.759202]  [<ffffffff813be1ec>] __extent_readpages.constprop.37+0x21c/0x2c0
> Mar  4 21:35:08 sneezy kernel: [89798.759208]  [<ffffffff813a0fe0>] ? btrfs_direct_IO+0x360/0x360
> Mar  4 21:35:08 sneezy kernel: [89798.759213]  [<ffffffff813bf619>] extent_readpages+0x179/0x1c0
> Mar  4 21:35:08 sneezy kernel: [89798.759217]  [<ffffffff813a0fe0>] ? btrfs_direct_IO+0x360/0x360
> Mar  4 21:35:08 sneezy kernel: [89798.759224]  [<ffffffff8139f57f>] btrfs_readpages+0x1f/0x30
> Mar  4 21:35:08 sneezy kernel: [89798.759229]  [<ffffffff811aa0e7>] __do_page_cache_readahead+0x207/0x2a0
> Mar  4 21:35:08 sneezy kernel: [89798.759233]  [<ffffffff811a9fb0>] ? __do_page_cache_readahead+0xd0/0x2a0
> Mar  4 21:35:08 sneezy kernel: [89798.759239]  [<ffffffff811aa262>] ondemand_readahead+0xe2/0x320
> Mar  4 21:35:08 sneezy kernel: [89798.759243]  [<ffffffff811aa300>] ? ondemand_readahead+0x180/0x320
> Mar  4 21:35:08 sneezy kernel: [89798.759248]  [<ffffffff811aa5d1>] page_cache_sync_readahead+0x31/0x50
> Mar  4 21:35:08 sneezy kernel: [89798.759253]  [<ffffffff8119d3fc>] generic_file_read_iter+0x50c/0x620
> Mar  4 21:35:08 sneezy kernel: [89798.759259]  [<ffffffff818b7d71>] ? _raw_spin_unlock_irq+0x41/0x70
> Mar  4 21:35:08 sneezy kernel: [89798.759264]  [<ffffffff81219c1e>] new_sync_read+0x7e/0xb0
> Mar  4 21:35:08 sneezy kernel: [89798.759270]  [<ffffffff8121a3d7>] vfs_read+0x97/0x180
> Mar  4 21:35:08 sneezy kernel: [89798.759275]  [<ffffffff8121afbd>] SyS_read+0x4d/0xc0
> Mar  4 21:35:08 sneezy kernel: [89798.759280]  [<ffffffff818b8c2d>] system_call_fastpath+0x16/0x1b
> Mar  4 21:35:08 sneezy kernel: [89798.759284] no locks held by rsync/7425.
> Mar  4 21:35:08 sneezy kernel: [89798.759290] INFO: task btrsame:23612 blocked for more than 1800 seconds.
> Mar  4 21:35:08 sneezy kernel: [89798.759329]       Tainted: G        W      3.18.8-zb64+ #1
> Mar  4 21:35:08 sneezy kernel: [89798.759367] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Mar  4 21:35:08 sneezy kernel: [89798.759437] btrsame         D 0000000000000000     0 23612  27339 0x00000000
> Mar  4 21:35:08 sneezy kernel: [89798.759443]  ffff880003c2bc18 0000000000000096 ffffffff82927070 ffff88000a881000
> Mar  4 21:35:08 sneezy kernel: [89798.759449]  00000000001e0880 00000000ffffffff ffff880003c2bfd8 00000000001e0880
> Mar  4 21:35:08 sneezy kernel: [89798.759455]  ffff880014765000 ffff88000a881000 ffff880003c2bb58 ffffffff810a6621
> Mar  4 21:35:08 sneezy kernel: [89798.759461] Call Trace:
> Mar  4 21:35:08 sneezy kernel: [89798.759467]  [<ffffffff810a6621>] ? preempt_count_sub+0x51/0x60
> Mar  4 21:35:08 sneezy kernel: [89798.759471]  [<ffffffff818b2390>] ? bit_wait+0x60/0x60
> Mar  4 21:35:08 sneezy kernel: [89798.759475]  [<ffffffff810c90a9>] ? mark_held_locks+0x79/0xb0
> Mar  4 21:35:08 sneezy kernel: [89798.759481]  [<ffffffff81102c1d>] ? ktime_get+0x10d/0x150
> Mar  4 21:35:08 sneezy kernel: [89798.759486]  [<ffffffff81020bf9>] ? read_tsc+0x9/0x10
> Mar  4 21:35:08 sneezy kernel: [89798.759490]  [<ffffffff81102bbc>] ? ktime_get+0xac/0x150
> Mar  4 21:35:08 sneezy kernel: [89798.759496]  [<ffffffff8114e713>] ? __delayacct_blkio_start+0x23/0x30
> Mar  4 21:35:08 sneezy kernel: [89798.759500]  [<ffffffff818b2390>] ? bit_wait+0x60/0x60
> Mar  4 21:35:08 sneezy kernel: [89798.759504]  [<ffffffff818b1989>] schedule+0x29/0x70
> Mar  4 21:35:08 sneezy kernel: [89798.759508]  [<ffffffff818b1cb8>] io_schedule+0x98/0x100
> Mar  4 21:35:08 sneezy kernel: [89798.759512]  [<ffffffff818b23c4>] bit_wait_io+0x34/0x60
> Mar  4 21:35:08 sneezy kernel: [89798.759517]  [<ffffffff818b224b>] __wait_on_bit_lock+0x4b/0xb0
> Mar  4 21:35:08 sneezy kernel: [89798.759521]  [<ffffffff8119b791>] ? find_get_entry+0x81/0xe0
> Mar  4 21:35:08 sneezy kernel: [89798.759526]  [<ffffffff8119b586>] __lock_page+0xa6/0xb0
> Mar  4 21:35:08 sneezy kernel: [89798.759530]  [<ffffffff810bd980>] ? autoremove_wake_function+0x40/0x40
> Mar  4 21:35:08 sneezy kernel: [89798.759535]  [<ffffffff8119c0e8>] pagecache_get_page+0x168/0x1a0
> Mar  4 21:35:08 sneezy kernel: [89798.759540]  [<ffffffff813d0d4d>] extent_same_get_page+0x2d/0xc0
> Mar  4 21:35:08 sneezy kernel: [89798.759545]  [<ffffffff813d7e79>] btrfs_ioctl+0x2729/0x2930
> Mar  4 21:35:08 sneezy kernel: [89798.759550]  [<ffffffff810c61fe>] ? put_lock_stats.isra.18+0xe/0x30
> Mar  4 21:35:08 sneezy kernel: [89798.759556]  [<ffffffff811c9d2e>] ? might_fault+0x5e/0xc0
> Mar  4 21:35:08 sneezy kernel: [89798.759562]  [<ffffffff8122e940>] do_vfs_ioctl+0x2f0/0x510
> Mar  4 21:35:08 sneezy kernel: [89798.759567]  [<ffffffff818b8c59>] ? sysret_check+0x22/0x5d
> Mar  4 21:35:08 sneezy kernel: [89798.759571]  [<ffffffff8122ebe1>] SyS_ioctl+0x81/0xa0
> Mar  4 21:35:08 sneezy kernel: [89798.759576]  [<ffffffff818b8c2d>] system_call_fastpath+0x16/0x1b
> Mar  4 21:35:08 sneezy kernel: [89798.759580] 3 locks held by btrsame/23612:
> Mar  4 21:35:08 sneezy kernel: [89798.759582]  #0:  (sb_writers#8){.+.+.+}, at: [<ffffffff8123d0a8>] mnt_want_write_file+0x28/0x60
> Mar  4 21:35:08 sneezy kernel: [89798.759593]  #1:  (&sb->s_type->i_mutex_key#12/1){+.+.+.}, at: [<ffffffff813d7aa5>] btrfs_ioctl+0x2355/0x2930
> Mar  4 21:35:08 sneezy kernel: [89798.759604]  #2:  (&sb->s_type->i_mutex_key#12/2){+.+.+.}, at: [<ffffffff813d7bf1>] btrfs_ioctl+0x24a1/0x2930
>

Normal, readpages() is called with the pages locked and then it tries
to lock the extent range in the inode's io tree, while extent-same
does the opposite, it locks the range first and then tries to lock the
pages.

(CC'ing Mark)


-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
