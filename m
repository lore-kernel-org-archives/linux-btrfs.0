Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50380 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbaLXJro (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Dec 2014 04:47:44 -0500
Received: from kw-mxoi2.gw.nic.fujitsu.com (unknown [10.0.237.143])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 3520E3EE188
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Dec 2014 18:47:43 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.fujitsu.co.jp [10.0.50.91])
	by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 4A907AC02B6
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Dec 2014 18:47:42 +0900 (JST)
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id E73931DB8042
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Dec 2014 18:47:41 +0900 (JST)
Message-ID: <549A8B9B.5000005@jp.fujitsu.com>
Date: Wed, 24 Dec 2014 18:47:07 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: <russell@coker.com.au>, <linux-btrfs@vger.kernel.org>
CC: <janecek@ucw.cz>
Subject: Re: Debian/Jessie 3.16.7-ckt2-1 kernel error
References: <201412241202.59568.russell@coker.com.au>
In-Reply-To: <201412241202.59568.russell@coker.com.au>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Russel and all,

On 2014/12/24 10:02, Russell Coker wrote:
> I've attached the kernel message log that I get after booting kernel 3.16.7
> from Debian/Unstable.  This is the kernel branch that will go into
> Debian/Jessie so it's important to get it fixed.
>
> Below has the start of the errors, the attached file has everything from boot.
> I've got similar issues on another system, would it help if I collect the logs
> from multiple systems?
>
> [    6.618809] Btrfs loaded
> [    6.670878] BTRFS: device fsid a2d7cbbc-23be-4d97-b2bb-de99b0c58c7d devid 1
> t
> ransid 548614 /dev/mapper/root-crypt
> [    6.706907] BTRFS info (device dm-0): disk space caching is enabled
> [    6.798762] BTRFS: detected SSD devices, enabling SSD mode
> [    6.881272] ------------[ cut here ]------------
> [    6.881358] WARNING: CPU: 3 PID: 198 at /build/linux-CMiYW9/linux-3.16.7-
> ckt2
> /fs/btrfs/delayed-inode.c:1410 btrfs_commit_transaction+0x38a/0x9c0 [btrfs]()
>

This problem is once reported by Petr and would not be fixed yet.
In addition, there is no Btrfs related error/warning messages.

Here are my questions.

1. Is your system "btrfs scrub" clean?
2. Is this message shown every boot time?
3. Is this message shown only in boot?
4. When this message is started to be shown?
5. Do you have any trouble, change your operation or configuration
    just before the answer of Q4 ?

*** The result of my brief analysis (a bit long). ***

Your kernel traces are as follows > for developers

====
[    6.881272] ------------[ cut here ]------------
[    6.881358] WARNING: CPU: 3 PID: 198 at /build/linux-CMiYW9/linux-3.16.7-ckt2/fs/btrfs/delayed-inode.c:1410 btrfs_commit_transaction+0x38a/0x9c0 [btrfs]()
[    6.881453] Modules linked in: btrfs xor raid6_pq sha256_ssse3 sha256_generic ecb cbc algif_skcipher af_alg hid_generic usbhid hid dm_crypt dm_mod sd_mod crc_t10dif crct10dif_generic sg sr_mod crct10dif_common cdrom crc32c_intel r8169 mii ehci_pci ata_generic ehci_hcd ata_piix libata e1000e usbcore ptp scsi_mod usb_common pps_core
[    6.883373] CPU: 3 PID: 198 Comm: exe Not tainted 3.16.0-4-amd64 #1 Debian 3.16.7-ckt2-1
[    6.883455] Hardware name:                  /DH55HC, BIOS TCIBX10H.86A.0036.2010.0525.1620 05/25/2010
[    6.884169]  0000000000000009 ffffffff81507263 0000000000000000 ffffffff81065847
[    6.884449]  ffff8802366ba980 ffff8800b67fb000 ffff8802366bbe10 0000000000000000
[    6.884723]  0000000000000000 ffffffffa022727a cc9e8800b750eec8 006c000000000029
[    6.885057] Call Trace:
[    6.885127]  [<ffffffff81507263>] ? dump_stack+0x41/0x51
[    6.885199]  [<ffffffff81065847>] ? warn_slowpath_common+0x77/0x90
[    6.885277]  [<ffffffffa022727a>] ? btrfs_commit_transaction+0x38a/0x9c0 [btrfs]
[    6.885369]  [<ffffffffa026668a>] ? btrfs_recover_log_trees+0x38a/0x440 [btrfs]
[    6.885460]  [<ffffffffa021de50>] ? free_root_pointers+0x60/0x60 [btrfs]
[    6.885538]  [<ffffffffa0263e20>] ? replay_one_extent+0x6c0/0x6c0 [btrfs]
[    6.885613]  [<ffffffffa02249af>] ? open_ctree+0x176f/0x1f20 [btrfs]
[    6.885688]  [<ffffffffa01fb93f>] ? btrfs_mount+0x61f/0x8b0 [btrfs]
[    6.885758]  [<ffffffff81237547>] ? selinux_sb_copy_data+0x157/0x220
[    6.885831]  [<ffffffff811a9534>] ? mount_fs+0x34/0x1a0
[    6.885902]  [<ffffffff811c2d72>] ? vfs_kern_mount+0x62/0x110
[    6.885970]  [<ffffffff811c55ca>] ? do_mount+0x23a/0xac0
[    6.886041]  [<ffffffff811c52b6>] ? copy_mount_options+0xb6/0x150
[    6.886109]  [<ffffffff811c6141>] ? SyS_mount+0x81/0xc0
[    6.886180]  [<ffffffff8150d32d>] ? system_call_fast_compare_end+0x10/0x15
[    6.886252] ---[ end trace 9b7dbfb04527c9ee ]---
====

Your system hits the same following WARN_ON() many times at the boot time.

fs/btrfs/delayed-inode.c:
===============================================================================
void btrfs_assert_delayed_root_empty(struct btrfs_root *root)
{
         struct btrfs_delayed_root *delayed_root;
         delayed_root = btrfs_get_delayed_root(root);
         WARN_ON(btrfs_first_delayed_node(delayed_root));
}
===============================================================================

There is no other Btrfs related error/warning message.

It seems the same/similar problem of what Petr (CC'ed) reported.

http://permalink.gmane.org/gmane.comp.file-systems.btrfs/39721

The WARN_ON() is the same and his system also hit this problem
at the boot time.

Although I briefly look at the fix for this problem by
"git log --grep=btrfs_commit_transaction v3.16... fs/btrfs",
I couldn't find it (Of course, I would be wrong). In addition,
Petr hit this problem with 3.18-rc1. So I suspect this problem
is not fixed yet.

I don't know why it happens now. Any idea? >developers.

Thanks,
Satoru

