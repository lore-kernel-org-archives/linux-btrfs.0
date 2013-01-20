Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from vapor.arctrix.com ([66.220.1.99]:40639 "HELO vapor.arctrix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751329Ab3ATQBV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Jan 2013 11:01:21 -0500
Date: Sun, 20 Jan 2013 09:54:38 -0600
From: Neil Schemenauer <neil@python.ca>
To: linux-btrfs@vger.kernel.org
Subject: scrub fails, any way to recover?
Message-ID: <20130120155438.GA5111@python.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have a ~350 GB Btrfs filesystem that is corrupted.  I think the
damage was caused by a bad SATA cable.  I can mount the filesystem
and read most of the data (I already have backups of most everything).

The scrub is aborted after a few seconds with the following error in
the kernel log:

    parent transid verify failed on 795639808 wanted 102145 found 101462
    parent transid verify failed on 795639808 wanted 102145 found 101462
    verify_parent_transid: 16273 callbacks suppressed
    ...

Trying to remove the corrupted directory tree results in the following:

    device label DATA devid 1 transid 102169 /dev/sda2
    btrfs: enabling auto recovery
    btrfs: disk space caching is enabled
    verify_parent_transid: 12197 callbacks suppressed
    parent transid verify failed on 795062272 wanted 102145 found 101462
    ...
    ------------[ cut here ]------------
    WARNING: at fs/btrfs/super.c:256 __btrfs_abort_transaction+0x43/0xb6()
    Hardware name: MS-7388
    btrfs: Transaction aborted
    ...
    Pid: 24332, comm: rm Not tainted 3.8.0-rc4 #66
    Call Trace:
    [<ffffffff81162000>] ? __btrfs_abort_transaction+0x39/0xb6
    [<ffffffff8102cf85>] warn_slowpath_common+0x7e/0x97
    [<ffffffff8102d032>] warn_slowpath_fmt+0x41/0x43
    [<ffffffff81198d6e>] ? set_extent_dirty+0x1b/0x1d
    [<ffffffff8116200a>] __btrfs_abort_transaction+0x43/0xb6
    [<ffffffff81170db9>] __btrfs_free_extent+0x612/0x64e
    [<ffffffff811950eb>] ? btrfs_get_token_32+0x79/0xc7
    [<ffffffff811b8fa9>] ? btrfs_merge_delayed_refs+0x24b/0x266
    [<ffffffff81173cfe>] run_clustered_refs+0x7e3/0x8b9
    [<ffffffff81176b20>] btrfs_run_delayed_refs+0xde/0x268
    [<ffffffff811843f8>] __btrfs_end_transaction+0xd8/0x2cf
    [<ffffffff8118461a>] btrfs_end_transaction+0xb/0xd
    [<ffffffff81186b15>] __unlink_end_trans+0x5e/0x63
    [<ffffffff8118baf1>] btrfs_unlink+0x86/0xa0
    [<ffffffff810bc29f>] vfs_unlink+0x6f/0xdc
    [<ffffffff810bc3f9>] do_unlinkat+0xed/0x199
    [<ffffffff810b1d2e>] ? vfs_write+0x100/0x127
    [<ffffffff810b1f32>] ? sys_write+0x44/0x75
    [<ffffffff810bdf8a>] sys_unlinkat+0x1d/0x29
    [<ffffffff8147f9d2>] system_call_fastpath+0x16/0x1b
    ---[ end trace ce4d352b0ec7d230 ]---
    BTRFS error (device sda2) in __btrfs_free_extent:5184: IO failure
    btrfs is forced readonly
    btrfs: run_one_delayed_ref returned -5

I've tried btrfsck but it fails as well.  Is there some way I can
remove the damaged data and save the good or is a re-format the only
solution?

  Neil
