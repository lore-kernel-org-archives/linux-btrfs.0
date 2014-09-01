Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27122 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbaIANlh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Sep 2014 09:41:37 -0400
Date: Mon, 1 Sep 2014 21:41:24 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BUG_ON spams /var/log/messages with the same msg full
Message-ID: <20140901134124.GA18252@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <5400ECBC.5090301@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <5400ECBC.5090301@gmx.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 29, 2014 at 11:12:28PM +0200, Toralf Förster wrote:
> At as 32 bit KVM I run these 2 commands:
> 
> tfoerste@n22kvm ~ $ mkdir /mnt/ramdisk/btrfs; truncate -s 97M /mnt/ramdisk/btrfs.fs; /sbin/mkfs.btrfs /mnt/ramdisk/btrfs.fs; sudo su -c "mount -o loop,compress=lzo /mnt/ramdisk/btrfs.fs /mnt/ramdisk/btrfs; chmod 777 /mnt/ramdisk/btrfs"
> 
> tfoerste@n22kvm ~ $ D=/mnt/ramdisk/btrfs; while [[ : ]]; do cd ~; sudo rm -rf $D/t3; mkdir $D/t3 || break; cd $D/t3; mkdir -p v1/v2; for i in $(seq 0 99); do touch v1/v2/f$i; mkdir v1/v2/d$i; done; trinity -C 4 -N 100000 -V $D/t3/v1/v2; echo; echo " done"; echo; sleep 4; done
> 
> 
> 
> After a short while the syslog was flooded with :

I believe that this warning of btrfs_evict_inode also comes from a result of
lseek, and Chris said that he's prepared a fix for that, so it's queued in the
next version.

thanks,
-liubo

> 
> 
> Aug 29 23:08:29 n22kvm kernel: [ 1806.183425] ---[ end trace 8ef9caa1ec878927 ]---
> Aug 29 23:08:29 n22kvm kernel: [ 1806.183427] ------------[ cut here ]------------
> Aug 29 23:08:29 n22kvm kernel: [ 1806.183429] WARNING: CPU: 1 PID: 24838 at fs/btrfs/extent_io.c:430 insert_state+0x66/0x190()
> Aug 29 23:08:29 n22kvm kernel: [ 1806.183430] BTRFS: end < start 4094 18446744073709551615
> Aug 29 23:08:29 n22kvm kernel: [ 1806.183431] Modules linked in:
> Aug 29 23:08:29 n22kvm kernel: [ 1806.183432] CPU: 1 PID: 24838 Comm: rm Tainted: G        W      3.17.0-rc2 #4
> Aug 29 23:08:29 n22kvm kernel: [ 1806.183433] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org 04/01/2014
> Aug 29 23:08:29 n22kvm kernel: [ 1806.183436]  00000000 00000000 e72c3d24 c16ee73d e72c3d64 e72c3d54 c10468ef c18e5650
> Aug 29 23:08:29 n22kvm kernel: [ 1806.183439]  e72c3d80 00006106 c18f4d52 000001ae c1326756 c1326756 00000000 e72c3e18
> Aug 29 23:08:29 n22kvm kernel: [ 1806.183443]  cc223dc0 e72c3d6c c104698e 00000009 e72c3d64 c18e5650 e72c3d80 e72c3db8
> Aug 29 23:08:29 n22kvm kernel: [ 1806.183443] Call Trace:
> Aug 29 23:08:29 n22kvm kernel: [ 1806.183445]  [<c16ee73d>] dump_stack+0x41/0x52
> Aug 29 23:08:29 n22kvm kernel: [ 1806.183447]  [<c10468ef>] warn_slowpath_common+0x7f/0xa0
> Aug 29 23:08:29 n22kvm kernel: [ 1806.183449]  [<c1326756>] ? insert_state+0x66/0x190
> Aug 29 23:08:29 n22kvm kernel: [ 1806.183451]  [<c1326756>] ? insert_state+0x66/0x190
> Aug 29 23:08:29 n22kvm kernel: [ 1806.183453]  [<c104698e>] warn_slowpath_fmt+0x2e/0x30
> Aug 29 23:08:29 n22kvm kernel: [ 1806.183454]  [<c1326756>] insert_state+0x66/0x190
> Aug 29 23:08:29 n22kvm kernel: [ 1806.183457]  [<c1326dc9>] __set_extent_bit+0x549/0x5f0
> Aug 29 23:08:29 n22kvm kernel: [ 1806.183459]  [<c1327e3c>] lock_extent_bits+0x6c/0x200
> Aug 29 23:08:29 n22kvm kernel: [ 1806.183461]  [<c1313d8e>] ? btrfs_evict_inode+0xee/0x540
> Aug 29 23:08:29 n22kvm kernel: [ 1806.183464]  [<c1313db8>] btrfs_evict_inode+0x118/0x540
> Aug 29 23:08:29 n22kvm kernel: [ 1806.183466]  [<c1161877>] evict+0x97/0x150
> Aug 29 23:08:29 n22kvm kernel: [ 1806.183467]  [<c1161e9a>] iput+0xda/0x170
> Aug 29 23:08:29 n22kvm kernel: [ 1806.183469]  [<c1154708>] do_unlinkat+0xf8/0x230
> Aug 29 23:08:29 n22kvm kernel: [ 1806.183471]  [<c10cc62c>] ? __audit_syscall_entry+0x9c/0xf0
> Aug 29 23:08:29 n22kvm kernel: [ 1806.183473]  [<c11578ce>] SyS_unlinkat+0x1e/0x40
> Aug 29 23:08:29 n22kvm kernel: [ 1806.183476]  [<c16f656b>] sysenter_do_call+0x12/0x12
> Aug 29 23:08:29 n22kvm kernel: [ 1806.183477] ---[ end trace 8ef9caa1ec878928 ]---
> Aug 29 23:08:29 n22kvm kernel: [ 1806.183479] ------------[ cut here ]------------
> 
> -- 
> Toralf
> pgp key: 0076 E94E
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
