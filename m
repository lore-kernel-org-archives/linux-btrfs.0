Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout06.t-online.de ([194.25.134.19]:35976 "EHLO
	mailout06.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729Ab3ADM44 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Jan 2013 07:56:56 -0500
Date: 04 Jan 2013 13:56:00 +0100
From: Hullen@t-online.de (Helmut Hullen)
To: linux-btrfs@vger.kernel.org
Message-ID: <COClHr99CXB@helmut.hullen.de>
In-Reply-To: <14FFD425-4B7D-4523-AEAF-527A6B72DCB4@colorremedies.com>
Subject: Re: Option LABEL
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: helmut@hullen.de
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Chris,

Du meintest am 03.01.13:

>>> MBR has no mechanism for labeling the disk itself or the
>>> partitions. So /dev/sda cannot have a label or a name.

>> Sure?

> Yes. MBR itself has no place holder to encode a disk name or
> partition name. http://en.wikipedia.org/wiki/Master_boot_record

I've just played a bit ...

   btrfs-show

tells

**
** WARNING: this program is considered deprecated
** Please consider to switch to the btrfs utility
**
Label: USBmm  uuid: 43ad1782-5d1c-4211-9333-506bcfdbc3a5
	Total devices 1 FS bytes used 28.00KB
	devid    1 size 3.78GB used 423.50MB path /dev/sdb

Label: mylabel  uuid: e9716633-49f1-44a0-a3b4-90ba9736a540
	Total devices 3 FS bytes used 28.00KB
	devid    2 size 1.00GB used 110.38MB path /dev/sdb2
	devid    1 size 1.00GB used 275.94MB path /dev/sdb1
	devid    3 size 1.00GB used 263.94MB path /dev/sdb3

Btrfs Btrfs v0.19

# ----------------------------------------

The "USBmm" entry remains from

   mkfs.btrfs -d raid0 -m raid1 -L USBmm /dev/sdb

Then I run "fdisk /dev/sdb" and created 4 partitions on "/dev/sdb"  
without previous overwriting it with zeros.

And then

   mkfs.btrfs -d raid0 -m raid1 -L mylabel /dev/sdb1 /dev/sdb2 /dev/sdb3

Inspecting the first sectors of "/dev/sdb" shows the string "USBmm" at  
the beginning of the second 64-kByte block (0x10120 ... 0x1012f).

The "mylabel" entries are somewhere after the first 128 kByte.

Viele Gruesse!
Helmut
