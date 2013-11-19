Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from hera.mpi-sb.mpg.de ([139.19.1.49]:53128 "EHLO
	hera.mpi-klsb.mpg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806Ab3KSKyS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Nov 2013 05:54:18 -0500
Message-ID: <528B44BD.9050502@mpi-sws.org>
Date: Tue, 19 Nov 2013 12:00:13 +0100
From: Pedro Fonseca <pfonseca@mpi-sws.org>
MIME-Version: 1.0
To: undisclosed-recipients:;
Subject: Warning in record_one_backref()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

In another test, I've encountered a few situations that triggered a warning message in "record_one_backref()". I'm not sure if it's serious but it is probably related to 
the concurrent defragment operations executed during the test.

Warning dump:
> [  147.558178] ------------[ cut here ]------------
> [  147.579146] WARNING: CPU: 1 PID: 2795 at [...]/linux-3.11.1-fs-static/fs/btrfs/inode.c:2206 record_one_backref+0x3cb/0x3e4()
> [  147.582925] Modules linked in: loop rtc_cmos pcspkr tpm_tis freq_table mperf i2c_piix4
> [  147.589360] CPU: 1 PID: 2795 Comm: btrfs-endio-wri Not tainted 3.11.1 #2
> [  147.589731] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
> [  147.590523]  0000089e c4059d1c c176917a c1a07b61 c4059d34 c102d1c0 c12b8c4b 00000007
> [  147.591240]  df3c8f18 c5e14800 c4059d44 c102d1e6 00000009 00000000 c4059db4 c12b8c4b
> [  147.595457]  df45f580 00000286 c5e14800 c10a70fe de4c6c00 c4059d97 00000000 00000106
> [  147.596156] Call Trace:
> [  147.597365]  [<c176917a>] dump_stack+0x41/0x57
> [  147.597684]  [<c102d1c0>] warn_slowpath_common+0x5e/0x75
> [  147.597984]  [<c12b8c4b>] ? record_one_backref+0x3cb/0x3e4
> [  147.598275]  [<c102d1e6>] warn_slowpath_null+0xf/0x13
> [  147.602112]  [<c12b8c4b>] record_one_backref+0x3cb/0x3e4
> [  147.602392]  [<c10a70fe>] ? __cache_free+0xa2/0xaa
> [  147.602667]  [<c12fe908>] iterate_extent_inodes+0x132/0x1b2
> [  147.602964]  [<c12feba9>] iterate_inodes_from_logical+0x88/0x97
> [  147.603256]  [<c12b8880>] ? record_extent_backrefs+0x8b/0x8b
> [  147.603547]  [<c12b8845>] record_extent_backrefs+0x50/0x8b
> [  147.603822]  [<c12b8880>] ? record_extent_backrefs+0x8b/0x8b
> [  147.604107]  [<c12c1f8e>] btrfs_finish_ordered_io+0x77e/0x876
> [  147.604409]  [<c12c2091>] finish_ordered_fn+0xb/0xd
> [  147.604665]  [<c12db161>] worker_loop+0x111/0x3ec
> [  147.604929]  [<c104a2c4>] ? default_wake_function+0xb/0xd
> [  147.608784]  [<c1040c43>] kthread+0x90/0x95
> [  147.609021]  [<c12db050>] ? btrfs_queue_worker+0x1c8/0x1c8
> [  147.609311]  [<c176c277>] ret_from_kernel_thread+0x1b/0x28
> [  147.609589]  [<c1040bb3>] ? kthread_freezable_should_stop+0x4f/0x4f
> [  147.610452] ---[ end trace 626899e11111abbe ]---


The warning occurred at the end of the execution of the following file system operations:
>    CPU: 1 Op: mknod
>    CPU: 1 Op: readlink
> CPU: 0 Op: mknod
> CPU: 0 Op: readlink
> CPU: 0 Op: creat
> CPU: 0 Op: symlink
> CPU: 0 Op: dwrite
> CPU: 0 Op: creat
> CPU: 0 Op: write
> CPU: 0 Op: dwrite
>    CPU: 1 Op: creat
>    CPU: 1 Op: symlink
>    CPU: 1 Op: dwrite
>    CPU: 1 Op: creat
>    CPU: 1 Op: write
>    CPU: 1 Op: dwrite
> CPU: 0 Op: write
> CPU: 0 Op: btrfs_ioctl_filesystem_defragment
>    CPU: 1 Op: write
>    CPU: 1 Op: btrfs_ioctl_filesystem_defragment

Pedro

