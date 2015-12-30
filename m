Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:34019 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171AbbL3XIA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Dec 2015 18:08:00 -0500
Received: by mail-oi0-f41.google.com with SMTP id o124so208829019oia.1
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Dec 2015 15:08:00 -0800 (PST)
Received: from enigma.jons.org (c-76-31-33-28.hsd1.tx.comcast.net. [76.31.33.28])
        by smtp.googlemail.com with ESMTPSA id e202sm24236277oic.23.2015.12.30.15.07.59
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Wed, 30 Dec 2015 15:07:59 -0800 (PST)
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>
From: Jon Christopherson <jon@jons.org>
Subject: BTRFS in 4.4.0-rc7 keeping system from hibernating
Message-ID: <568463CE.3060806@jons.org>
Date: Wed, 30 Dec 2015 17:07:58 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Ever since 4.4.0-rc1 or so, BTRFS and XFS hasn't played well with 
hibernation. It may be deeper down as both filesystems seem to have 
issues with not being able to commit/freeze as can be seen below:

[81167.893207] PM: Syncing filesystems ... done.
[81168.194298] Freezing user space processes ... (elapsed 0.032 seconds) 
done.
[81168.226832] PM: Marking nosave pages: [mem 0x00000000-0x00000fff]
[81168.226839] PM: Marking nosave pages: [mem 0x00058000-0x00058fff]
[81168.226843] PM: Marking nosave pages: [mem 0x00090000-0x00090fff]
[81168.226846] PM: Marking nosave pages: [mem 0x0009e000-0x000fffff]
[81168.226853] PM: Marking nosave pages: [mem 0x8f68f000-0x8f6d9fff]
[81168.226860] PM: Marking nosave pages: [mem 0x8f71e000-0x9022efff]
[81168.226997] PM: Marking nosave pages: [mem 0x95295000-0x97ffefff]
[81168.227549] PM: Marking nosave pages: [mem 0x98000000-0xffffffff]
[81168.229676] PM: Basic memory bitmaps created
[81168.230414] PM: Preallocating image memory... done (allocated 1559693 
pages)
[81169.667742] PM: Allocated 6238772 kbytes in 1.43 seconds (4362.77 MB/s)
[81169.667743] Freezing remaining freezable tasks ...
[81189.679101] Freezing of tasks failed after 20.010 seconds (2 tasks 
refusing to freeze, wq_busy=0):
[81189.679299] btrfs-cleaner   D ffff88008841fad8     0  2141      2 
0x00000000
[81189.679308]  ffff88008841fad8 ffff880453bd4a08 ffffffff81c11500 
ffff880416ab3b00
[81189.679314]  ffff880088420000 ffff880466416b00 7fffffffffffffff 
ffff88008841fc48
[81189.679319]  ffffffff817d4650 ffff88008841faf0 ffffffff817d3ef5 
0000000000000000
[81189.679325] Call Trace:
[81189.679338]  [<ffffffff817d4650>] ? bit_wait+0x60/0x60
[81189.679343]  [<ffffffff817d3ef5>] schedule+0x35/0x80
[81189.679348]  [<ffffffff817d6c19>] schedule_timeout+0x189/0x250
[81189.679391]  [<ffffffffc017aaf0>] ? __set_extent_bit+0x430/0x550 [btrfs]
[81189.679398]  [<ffffffff810e7c57>] ? ktime_get+0x37/0xa0
[81189.679427]  [<ffffffff817d4650>] ? bit_wait+0x60/0x60
[81189.679431]  [<ffffffff817d3494>] io_schedule_timeout+0xa4/0x110
[81189.679436]  [<ffffffff817d466b>] bit_wait_io+0x1b/0x70
[81189.679440]  [<ffffffff817d443e>] __wait_on_bit_lock+0x4e/0xb0
[81189.679474]  [<ffffffffc017b0cc>] ? __clear_extent_bit+0x2ec/0x3b0 
[btrfs]
[81189.679481]  [<ffffffff8117afe0>] __lock_page+0xb0/0xc0
[81189.679488]  [<ffffffff810b8a20>] ? autoremove_wake_function+0x40/0x40
[81189.679494]  [<ffffffff8117c1fd>] pagecache_get_page+0x17d/0x1c0
[81189.679528]  [<ffffffffc0193c3b>] btrfs_defrag_file+0x33b/0xcd0 [btrfs]
[81189.679536]  [<ffffffff810ae283>] ? put_prev_entity+0x33/0x7e0
[81189.679567]  [<ffffffffc01700bf>] btrfs_run_defrag_inodes+0x1ef/0x300 
[btrfs]
[81189.679593]  [<ffffffffc01565a0>] cleaner_kthread+0xd0/0x200 [btrfs]
[81189.679617]  [<ffffffffc01564d0>] ? check_leaf+0x330/0x330 [btrfs]
[81189.679624]  [<ffffffff810960a9>] kthread+0xc9/0xe0
[81189.679631]  [<ffffffff81095fe0>] ? kthread_create_on_node+0x180/0x180
[81189.679636]  [<ffffffff817d7f0f>] ret_from_fork+0x3f/0x70
[81189.679643]  [<ffffffff81095fe0>] ? kthread_create_on_node+0x180/0x180
[81189.679654] xfsaild/dm-4    S ffff88041615fe08     0  2350      2 
0x00000000
[81189.679659]  ffff88041615fe08 0000000000000000 ffff880453f02c40 
ffff880416b4bb00
[81189.679664]  ffff880416160000 ffff880416b4bb00 0000000000000000 
ffff88045252e100
[81189.679669]  ffff880418acb800 ffff88041615fe20 ffffffff817d3ef5 
0000000000000000
[81189.679674] Call Trace:
[81189.679679]  [<ffffffff817d3ef5>] schedule+0x35/0x80
[81189.679734]  [<ffffffffc18550af>] xfsaild+0x53f/0x5d0 [xfs]
[81189.679780]  [<ffffffffc1854b70>] ? 
xfs_trans_ail_cursor_first+0x90/0x90 [xfs]
[81189.679820]  [<ffffffffc1854b70>] ? 
xfs_trans_ail_cursor_first+0x90/0x90 [xfs]
[81189.679827]  [<ffffffff810960a9>] kthread+0xc9/0xe0
[81189.679834]  [<ffffffff81095fe0>] ? kthread_create_on_node+0x180/0x180
[81189.679840]  [<ffffffff817d7f0f>] ret_from_fork+0x3f/0x70
[81189.679845]  [<ffffffff81095fe0>] ? kthread_create_on_node+0x180/0x180
[81189.679930]

4.3.0 would hibernate correctly.


-- 

Regards,

Jon Christopherson
jon@jons.org
