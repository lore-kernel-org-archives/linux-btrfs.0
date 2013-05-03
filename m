Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54272 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763479Ab3ECUmv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 May 2013 16:42:51 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UYMoc-00072f-Bo
	for linux-btrfs@vger.kernel.org; Fri, 03 May 2013 22:42:50 +0200
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 03 May 2013 22:42:50 +0200
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 03 May 2013 22:42:50 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: grub/grub2 boot into btrfs raid root and with no initrd
Date: Fri, 03 May 2013 21:42:38 +0100
Message-ID: <km17fq$4k0$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've made a few attempts to boot into a root filesystem created using:

mkfs.btrfs -d raid1 -m raid1 -L btrfs_root_3 /dev/sda3 /dev/sdb3

Both grub and grub2 pick up a kernel image fine from an ext4 /boot on
/dev/sda1 for exaample, but then fail to find or assemble the btrfs root.

Setting up an initrd and grub operates fine for the btrfs raid.


What is the special magic to do this without the need for an initrd?

Is the comment/patch below from last year languishing unknown? Or is
there some problem with that kernel approach?


Thanks,
Martin


See:

http://forums.gentoo.org/viewtopic-t-923554-start-0.html


Below is my patch, which is working fine for me with 3.8.2.
Code:

$ cat /etc/portage/patches/sys-kernel/gentoo-sources/earlydevtmpfs.patch
--- init/do_mounts.c.orig   2013-03-24 20:49:53.446971127 +0100
+++ init/do_mounts.c   2013-03-24 20:51:46.408237541 +0100
@@ -529,6 +529,7 @@
    create_dev("/dev/root", ROOT_DEV);
    if (saved_root_name[0]) {
       create_dev(saved_root_name, ROOT_DEV);
+      devtmpfs_mount("dev");
       mount_block_root(saved_root_name, root_mountflags);
    } else {
       create_dev("/dev/root", ROOT_DEV);


