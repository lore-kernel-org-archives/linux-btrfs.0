Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:63409 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751936AbaKJS3h (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Nov 2014 13:29:37 -0500
Received: from [192.168.178.21] ([85.177.16.33]) by mail.gmx.com (mrgmx003)
 with ESMTPSA (Nemesis) id 0Lfjxq-1YLe7B3ZcI-00pHlk for
 <linux-btrfs@vger.kernel.org>; Mon, 10 Nov 2014 19:29:36 +0100
Message-ID: <5461040E.4020209@gmx.de>
Date: Mon, 10 Nov 2014 19:29:34 +0100
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: fuzz testing gives within a KVM : INFO: trying to register non-static
 key. the code is fine but needs lockdep annotation.
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm unsure if I already reported this particular issue in detail or not :

As soon as I do start a fuzz testing BTRFS at a 32 bit qemu KVM amachine using the follwoing commands:

$ mkdir /mnt/ramdisk/btrfs; truncate -s 97M /mnt/ramdisk/btrfs.fs; /sbin/mkfs.btrfs /mnt/ramdisk/btrfs.fs; sudo su -c "mount -o loop,compress=lzo /mnt/ramdisk/btrfs.fs /mnt/ramdisk/btrfs; chmod 777 /mnt/ramdisk/btrfs"                                             
SMALL VOLUME: forcing mixed metadata/data groups

WARNING! - Btrfs v3.14.2 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

Turning ON incompat feature 'mixed-bg': mixed data and metadata block groups
Turning ON incompat feature 'extref': increased hardlink limit per file to 65536
Created a data/metadata chunk of size 8388608
fs created label (null) on /mnt/ramdisk/btrfs.fs
        nodesize 4096 leafsize 4096 sectorsize 4096 size 97.00MiB
Btrfs v3.14.2


$ D=/mnt/ramdisk/btrfs; while [[ : ]]; do cd ~; sudo rm -rf $D/t3 && mkdir $D/t3 || break; cd $D/t3; mkdir -p v1/v2; for i in $(seq 0 99); do touch v1/v2/f$i; mkdir v1/v2/d$i; done; trinity -C 2 -N 100000 -V $D/t3/v1/v2 -q; echo; echo " done"; echo; sleep 4; done



I do get  this in the syslog of a kernel 3.18-rc4 :


Nov 10 19:23:04 n22kvmclone kernel: INFO: trying to register non-static key.
Nov 10 19:23:04 n22kvmclone kernel: the code is fine but needs lockdep annotation.
Nov 10 19:23:04 n22kvmclone kernel: turning off the locking correctness validator.
Nov 10 19:23:04 n22kvmclone kernel: CPU: 0 PID: 2504 Comm: trinity-c0 Not tainted 3.18.0-rc4 #5
Nov 10 19:23:04 n22kvmclone kernel: Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org 04/01/2014
Nov 10 19:23:04 n22kvmclone kernel:  00000000 00000000 f6397b58 de84b75d def6d858 f6397b64 de848784 de9903e4
Nov 10 19:23:04 n22kvmclone kernel:  f6397bdc de481185 00000000 f49c8e14 f6397ba4 00000286 f49c8df4 f6397bb0
Nov 10 19:23:04 n22kvmclone kernel:  00000286 00000000 00000001 00000286 f88fb916 f49c8e04 00000000 f5a6a694
Nov 10 19:23:04 n22kvmclone kernel: Call Trace:
Nov 10 19:23:04 n22kvmclone kernel:  [<de84b75d>] dump_stack+0x41/0x52
Nov 10 19:23:04 n22kvmclone kernel:  [<de848784>] register_lock_class.part.40+0x32/0x36
Nov 10 19:23:04 n22kvmclone kernel:  [<de481185>] __lock_acquire+0x1465/0x1930
Nov 10 19:23:04 n22kvmclone kernel:  [<f88fb916>] ? set_avail_alloc_bits+0xd6/0xe0 [btrfs]
Nov 10 19:23:04 n22kvmclone kernel:  [<de852f32>] ? _raw_spin_unlock+0x22/0x30
Nov 10 19:23:04 n22kvmclone kernel:  [<f88fb916>] ? set_avail_alloc_bits+0xd6/0xe0 [btrfs]
Nov 10 19:23:04 n22kvmclone kernel:  [<f890b67f>] ? btrfs_make_block_group+0x1bf/0x280 [btrfs]
Nov 10 19:23:04 n22kvmclone kernel:  [<de4388b0>] ? native_restore_fl+0x10/0x10
Nov 10 19:23:04 n22kvmclone kernel:  [<de438890>] ? native_wbinvd+0x10/0x10
Nov 10 19:23:04 n22kvmclone kernel:  [<de481708>] lock_acquire+0xb8/0x150
Nov 10 19:23:04 n22kvmclone kernel:  [<f894d2f6>] ? btrfs_alloc_chunk+0x46/0x50 [btrfs]
Nov 10 19:23:04 n22kvmclone kernel:  [<f8949844>] __btrfs_alloc_chunk+0x624/0xa90 [btrfs]
Nov 10 19:23:04 n22kvmclone kernel:  [<f894d2f6>] ? btrfs_alloc_chunk+0x46/0x50 [btrfs]
Nov 10 19:23:04 n22kvmclone kernel:  [<f894d2f6>] btrfs_alloc_chunk+0x46/0x50 [btrfs]
Nov 10 19:23:04 n22kvmclone kernel:  [<f89025c9>] do_chunk_alloc+0x239/0x420 [btrfs]
Nov 10 19:23:04 n22kvmclone kernel:  [<de852f32>] ? _raw_spin_unlock+0x22/0x30
Nov 10 19:23:04 n22kvmclone kernel:  [<f89036ce>] btrfs_check_data_free_space+0x13e/0x310 [btrfs]
Nov 10 19:23:04 n22kvmclone kernel:  [<f89307f3>] __btrfs_buffered_write+0x103/0x560 [btrfs]
Nov 10 19:23:04 n22kvmclone kernel:  [<de5095df>] ? filemap_write_and_wait_range+0x7f/0x90
Nov 10 19:23:04 n22kvmclone kernel:  [<f893120f>] btrfs_file_write_iter+0x5bf/0x760 [btrfs]
Nov 10 19:23:04 n22kvmclone kernel:  [<de54d694>] ? do_iter_readv_writev+0x64/0x90
Nov 10 19:23:04 n22kvmclone kernel:  [<de4388b0>] ? native_restore_fl+0x10/0x10
Nov 10 19:23:04 n22kvmclone kernel:  [<de54d694>] do_iter_readv_writev+0x64/0x90
Nov 10 19:23:04 n22kvmclone kernel:  [<f8930c50>] ? __btrfs_buffered_write+0x560/0x560 [btrfs]
Nov 10 19:23:04 n22kvmclone kernel:  [<de54e9e1>] do_readv_writev+0xa1/0x270
Nov 10 19:23:04 n22kvmclone kernel:  [<f8930c50>] ? __btrfs_buffered_write+0x560/0x560 [btrfs]
Nov 10 19:23:04 n22kvmclone kernel:  [<de54d140>] ? iov_shorten+0x60/0x60
Nov 10 19:23:04 n22kvmclone kernel:  [<de569dc5>] ? __fdget_pos+0x35/0x40
Nov 10 19:23:04 n22kvmclone kernel:  [<de4c96a4>] ? __audit_syscall_entry+0x94/0xe0
Nov 10 19:23:04 n22kvmclone kernel:  [<de4c96a4>] ? __audit_syscall_entry+0x94/0xe0
Nov 10 19:23:04 n22kvmclone kernel:  [<de54ec44>] vfs_writev+0x34/0x60
Nov 10 19:23:04 n22kvmclone kernel:  [<de54ed90>] SyS_writev+0x50/0xd0
Nov 10 19:23:04 n22kvmclone kernel:  [<de853cfd>] syscall_call+0x7/0x7
Nov 10 19:23:26 n22kvmclone sshd[2549]: Accepted publickey for root from 192.168.1.254 port 45183 ssh2: RSA 30:da:ca:cc:77:9d:43:49:f4:a7:93:e8:3e:9b:c9:b2



-- 
Toralf
pgp key: 0076 E94E

