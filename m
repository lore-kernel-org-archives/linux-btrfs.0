Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from SD88.btc-net.bg ([212.39.90.88]:57864 "HELO sd88.btc-net.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1161002AbaDWRhJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Apr 2014 13:37:09 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by petrovi.no-ip.info (Postfix) with ESMTP id B706335D4AD
	for <linux-btrfs@vger.kernel.org>; Wed, 23 Apr 2014 20:30:24 +0300 (EEST)
Received: from petrovi.no-ip.info ([127.0.0.1])
	by localhost (petrovi.no-ip.info [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BdbghFetL+dp for <linux-btrfs@vger.kernel.org>;
	Wed, 23 Apr 2014 20:30:13 +0300 (EEST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by petrovi.no-ip.info (Postfix) with ESMTP id 382D035D4E2
	for <linux-btrfs@vger.kernel.org>; Wed, 23 Apr 2014 20:30:13 +0300 (EEST)
Received: from PEPS (peps.petrovi.no-ip.info [192.168.10.11])
	by petrovi.no-ip.info (Postfix) with ESMTP id 9F73D35D4AD
	for <linux-btrfs@vger.kernel.org>; Wed, 23 Apr 2014 20:30:12 +0300 (EEST)
From: =?koi8-r?B?8MzBzcXOIPDF1NLP1w==?= <plamen@petrovi.no-ip.info>
To: <linux-btrfs@vger.kernel.org>
Subject: Can anyone boot a system using btrfs root with linux 3.14 or newer?
Date: Wed, 23 Apr 2014 20:30:08 +0300
Message-ID: <000001cf5f19$ac92b2b0$05b81810$@petrovi.no-ip.info>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="koi8-r"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Can anyone boot a system using btrfs root with linux 3.14 or newer?

Because I can't.

I'm trying to move some 3.13.x based systems to 3.14.x and the kernel panics
during boot. It says to append a correct root=sdaX partition, but the one
provided is correct, because if use 3.13.x with the same kernel command line
- the system boots fine.

The thing is - there is an ext2 /boot partition and root / is btrfs, like
so:

# cat /etc/fstab
#
# /etc/fstab: static file system information
#
# <file system>        <dir>     <type>    <options>              <dump>
<pass>

#/dev/#REISERFS_ROOT#  /         reiserfs  defaults               0      0
#/dev/#EXT3FS_ROOT#    /         ext3      defaults               0      1
/dev/sda2              /         btrfs     relatime,compress=zlib 0      0
/dev/sda1              /boot     ext4      defaults               0      1
#/dev/#JFS_ROOT#       /         jfs       defaults               1      1

Here is my relevant GRUB config file part:

#menuentry 0
title Linux
    root (hd0,0)
    kernel /vmlinuz rw root=/dev/sda2 vga=6 raid=noautodetect

And for the record - I used the same kernel config as the one from 3.13.x -
I just copied my old .config file over to linux 3.14.x sources and did a
"make olddefconfig" and compiled my kernel, just as I did with all previous
ones...

Ideas?

P.S. Please, CC me - I'm not subscribed.
---------------------------------
Plamen Petrov

