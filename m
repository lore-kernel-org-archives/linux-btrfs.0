Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ares.seblu.net ([91.121.71.23]:40737 "EHLO ares.seblu.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755278Ab3EGLoo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 May 2013 07:44:44 -0400
Received: from mail-bk0-x22f.google.com (mail-bk0-x22f.google.com [IPv6:2a00:1450:4008:c01::22f])
	by ares.seblu.net (Postfix) with ESMTPSA id 411D91800001
	for <linux-btrfs@vger.kernel.org>; Tue,  7 May 2013 13:35:05 +0200 (CEST)
Received: by mail-bk0-f47.google.com with SMTP id jg9so225993bkc.6
        for <linux-btrfs@vger.kernel.org>; Tue, 07 May 2013 04:35:06 -0700 (PDT)
MIME-Version: 1.0
From: =?UTF-8?Q?S=C3=A9bastien_Luttringer?= <seblu@seblu.net>
Date: Tue, 7 May 2013 13:34:36 +0200
Message-ID: <CAJSTwE7vbx8eKyVetrXjEXFcpCeFbcCpfKjfutbnt5N6QUpF1g@mail.gmail.com>
Subject: No free space troubleshooting
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I'm testing btrfs on two 2TB drives with RAID1 on linux 3.9. So I have
virtually a space of 2TB.

I use iozone, bonnie++ and a lot of untaring linux kernel on fs to
load it and see what's happen.

After some hours, I got ENOSPC and some daemon start crashing. I read
wiki FAQ[1], and balance fix the issue (for few times). But running it
again issue come back.

The following is the output of untarnig linux kernel.
# while true; do for i in *.tar.xz; do d=${i%.tar.xz}; echo $d; [[ -e
"$d" ]] && rm -r "$d"; tar xf "$i"; done; done
...
tar: linux-3.3/arch/sh: Cannot mkdir: No space left on device
tar: linux-3.3/arch/sh/drivers/pci/fixups-sdk7786.c: Cannot open: No
such file or directory
tar: linux-3.3/arch/sh: Cannot mkdir: No space left on device
tar: linux-3.3/arch/sh/drivers/pci/fixups-se7751.c: Cannot open: No
such file or directory
tar: linux-3.3/arch/sh: Cannot mkdir: No space left on device
tar: linux-3.3/arch/sh/drivers/pci/fixups-sh03.c: Cannot open: No such
file or directory

# df
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda2       3,7T  122G  3,6T   4% /

# btrfs fi sh
Label: 'achille.root'  uuid: 2ab5010c-e8fe-4b8a-a895-3e58552ed791
        Total devices 2 FS bytes used 60.85GB
        devid    1 size 1.82TB used 65.02GB path /dev/sda2
        devid    2 size 1.82TB used 65.01GB path /dev/sdb2
Btrfs v0.20-rc1

The first time ENOSPC happen on my FS, the previous command show each
disk as full. Not like now (after the first run of "btrfs balance
start / -dusage=5").

# btrfs fi df /
Data, RAID1: total=61.00GB, used=59.99GB
System, RAID1: total=8.00MB, used=16.00KB
System: total=4.00MB, used=0.00
Metadata, RAID1: total=4.00GB, used=882.61MB
Metadata: total=8.00MB, used=0.00

The following page[2] suggest me to enable enospc_debug.

# mount -o remout,enospc_debug /
# mount -t btrfs /
/dev/sda2 on / type btrfs (rw,relatime,space_cache,enospc_debug)

But I see nothing in dmesg. Where I can find the debug messages?

So, I'm currently able to easily make the btrfs fs dirty without any
way of seeing if there is a ENOPSC in some directory.

[1] https://btrfs.wiki.kernel.org/index.php/FAQ#Help.21_Btrfs_claims_I.27m_out_of_space.2C_but_it_looks_like_I_should_have_lots_left.21
[2] https://btrfs.wiki.kernel.org/index.php/Mount_options

--
Sébastien "Seblu" Luttringer
https://www.seblu.net
GPG: 0x2072D77A
