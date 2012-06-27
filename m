Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:44637 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab2F0FUN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jun 2012 01:20:13 -0400
Received: from merlin by mail1.merlins.org with local (Exim 4.77 #2)
	id 1Sjkfk-0001Hh-Cf
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Jun 2012 22:20:12 -0700
Date: Tue, 26 Jun 2012 22:20:12 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: Long btrfs hangs during suspend to RAM / BTRFS warning (device dm-0): Aborting unused transaction
Message-ID: <20120627052012.GA32533@merlins.org>
References: <20120626193637.GA27856@merlins.org> <20120627013818.GA3556@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120627013818.GA3556@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 26, 2012 at 06:38:18PM -0700, Marc MERLIN wrote:
> Now, I'm also seeing these below and I have this again (86% CPU):
>  6076 root      20   0     0    0    0 R   86  0.0  29:40.11 btrfs-delalloc-    
> 
> How bad is it, doctor?  I think I'll be going back to 3.2.16 for now though.

Back to 3.2.16, I'm now seeing this:
[  840.516733] INFO: task VirtualBox:6818 blocked for more than 120 seconds.
[  840.516735] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  840.516736] VirtualBox      D ffff8801fd134080     0  6818   6758 0x00000080
[  840.516740]  ffff8801fd134080 0000000000000086 0000000000000050 ffff880202e7f100
[  840.516744]  0000000000013580 ffff8801c6f0dfd8 ffff8801c6f0dfd8 ffff8801fd134080
[  840.516748]  ffff8801c6f0da68 ffff8801c6f0da68 ffff88020a4e22f0 ffff88023bc13e08
[  840.516752] Call Trace:
[  840.516755]  [<ffffffff810b5c67>] ? __lock_page+0x66/0x66
[  840.516758]  [<ffffffff8134aea4>] ? io_schedule+0x58/0x6f
[  840.516761]  [<ffffffff810b5c6d>] ? sleep_on_page+0x6/0xa
[  840.516764]  [<ffffffff8134b1e5>] ? __wait_on_bit_lock+0x3c/0x85
[  840.516767]  [<ffffffff810b5c62>] ? __lock_page+0x61/0x66
[  840.516770]  [<ffffffff81060051>] ? autoremove_wake_function+0x2a/0x2a
[  840.516785]  [<ffffffffa01838d7>] ? extent_write_cache_pages.isra.13.constprop.22+0xf6/0x278 [btrfs]
[  840.516789]  [<ffffffff810ec9cb>] ? __cache_free.isra.40+0x19/0x1a7
[  840.516792]  [<ffffffff8134ed52>] ? sub_preempt_count+0x83/0x94
[  840.516795]  [<ffffffff8134c2dd>] ? _raw_spin_unlock+0x24/0x30
[  840.516811]  [<ffffffffa0183c4b>] ? extent_writepages+0x40/0x57 [btrfs]
[  840.516826]  [<ffffffffa0177f5f>] ? __btrfs_buffered_write+0x2bb/0x2dc [btrfs]
[  840.516841]  [<ffffffffa016e88a>] ? uncompress_inline.isra.44+0x116/0x116 [btrfs]
[  840.516844]  [<ffffffff810b6aaf>] ? __filemap_fdatawrite_range+0x4b/0x50
[  840.516847]  [<ffffffff810b6ad9>] ? filemap_write_and_wait_range+0x25/0x4d
[  840.516863]  [<ffffffffa01782ce>] ? btrfs_file_aio_write+0x34e/0x490 [btrfs]
[  840.516866]  [<ffffffff8103e092>] ? get_parent_ip+0x9/0x1b
[  840.516882]  [<ffffffffa0177f80>] ? __btrfs_buffered_write+0x2dc/0x2dc [btrfs]
[  840.516886]  [<ffffffff8112f19c>] ? aio_rw_vect_retry+0x70/0x18e
[  840.516888]  [<ffffffff8112f12c>] ? aio_fsync+0x22/0x22
[  840.516891]  [<ffffffff8112fbc7>] ? aio_run_iocb+0x72/0x11c
[  840.516894]  [<ffffffff81130d9a>] ? do_io_submit+0x6a4/0x7f9
[  840.516898]  [<ffffffff813508d2>] ? system_call_fastpath+0x16/0x1b
[ 1187.553635] btrfs: unlinked 8 orphans
[ 3810.200064] e1000e 0000:00:19.0: BAR 0: set to [mem 0xfc000000-0xfc01ffff] (PCI address [0xfc000000-0xfc01ffff])
[ 3810.200071] e1000e 0000:00:19.0: BAR 1: set to [mem 0xfc025000-0xfc025fff] (PCI address [0xfc025000-0xfc025fff])
[ 3810.200076] e1000e 0000:00:19.0: BAR 2: set to [io  0x1840-0x185f] (PCI address [0x1840-0x185f])
[ 3810.200093] e1000e 0000:00:19.0: restoring config space at offset 0xf (was 0x100, writing 0x10b)
[ 3810.200115] e1000e 0000:00:19.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100107)
[ 3810.200147] e1000e 0000:00:19.0: PME# disabled
[ 3810.200224] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
[ 4671.144685] iwlwifi 0000:03:00.0: Tx aggregation enabled on ra = 2c:b0:5d:3c:7d:f1 tid = 1
[ 4799.384107] btrfs: unlinked 8 orphans
[ 8436.512513] btrfs: unlinked 7 orphans
[11350.749850] btrfs no csum found for inode 3909426 start 0
[11350.750697] btrfs csum failed ino 3909426 off 0 csum 1419704114 private 0
[11652.088805] btrfs no csum found for inode 3910848 start 0
[11652.089524] btrfs csum failed ino 3910848 off 0 csum 3145117582 private 0

My firefox and chrome profiles were corrupted, so I had to restore them from an old snapshot.

I can't prove it, but it looks like my corruption happened right at the same
time than I rebooted to 3.4.4.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
