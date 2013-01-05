Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout10.t-online.de ([194.25.134.21]:35098 "EHLO
	mailout10.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755556Ab3AEONO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 5 Jan 2013 09:13:14 -0500
Date: 05 Jan 2013 15:12:00 +0100
From: Hullen@t-online.de (Helmut Hullen)
To: linux-btrfs@vger.kernel.org
Message-ID: <COGozn2PCXB@helmut.hullen.de>
Subject: cleaning old entries
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Reply-To: helmut@hullen.de
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, linux-btrfs,

on my testing USB stick

        btrfs fi show

shows

Label: 'mylabel'  uuid: e9716633-49f1-44a0-a3b4-90ba9736a540
	Total devices 3 FS bytes used 28.00KB
	devid    3 size 1.00GB used 288.00MB path /dev/sdb3
	devid    2 size 1.00GB used 512.00MB path /dev/sdb2
	devid    1 size 1.00GB used 292.00MB path /dev/sdb1

Label: 'USBmm'  uuid: 43ad1782-5d1c-4211-9333-506bcfdbc3a5
	Total devices 1 FS bytes used 28.00KB
	devid    1 size 3.78GB used 423.50MB path /dev/sdb

Btrfs Btrfs v0.19

# ----------------------------------------------------

The problem entry is "Label: 'USBmm'

It is a remainder of an older experiment, with 2 sticks, configured with

   mkfs.btrfs -d raid0 -m raid1 -L USBmm /dev/sdb /dev/sdc

And at least the label "USBmm" resides somewhere on the stick where it  
is hidden from manipulations (except something like "dd if=/dev/zero  
...")
A bit more precisely: the label lies at the beginning of the second 64- 
kByte block on the stick (may be sector 129). Far away from the other  
partition data.

Contents of "/proc/partitions":

major minor  #blocks  name

   8        0   29302560 sda
   8        1    9775521 sda1
   8        2     369495 sda2
   8        3    4891792 sda3
   8        4   14265720 sda4
  11        0    1048575 sr0
   8       16    3968000 sdb
   8       17    1048576 sdb1
   8       18    1048576 sdb2
   8       19    1048576 sdb3
   8       20     821248 sdb4

# ------------------------------------------

Output from "fdisk -l /dev/sdb":

Platte /dev/sdb: 4063 MByte, 4063232000 Byte
125 Köpfe, 62 Sektoren/Spur, 1024 Zylinder, zusammen 7936000 Sektoren
Einheiten = Sektoren von 1 ₧ 512 = 512 Bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x266cff07

    Gerät  boot.     Anfang        Ende     Blöcke   Id  System
/dev/sdb1            2048     2099199     1048576   83  Linux
/dev/sdb2         2099200     4196351     1048576   83  Linux
/dev/sdb3         4196352     6293503     1048576   83  Linux
/dev/sdb4         6293504     7935999      821248   83  Linux

# ------------------------------------------


        findfs LABEL=USBmm

says "unable to resolve 'LABEL=USBmm'" - that's ok.

And

        blkid

tells nothing about "/dev/sdb" - that's also ok.

----------------------------------------------

Has "mkfs.btrfs" to delete the "/dev/sdb" data when it overwrites the  
configuration with data for partitions? Or has the user to run something  
like "dd if=/dev/zero ..."?

Viele Gruesse!
Helmut
