Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50846 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753520AbbBNCkI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Feb 2015 21:40:08 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YMSeL-0002gQ-93
	for linux-btrfs@vger.kernel.org; Sat, 14 Feb 2015 03:40:05 +0100
Received: from rrcs-71-40-157-251.se.biz.rr.com ([71.40.157.251])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 14 Feb 2015 03:40:05 +0100
Received: from wireless by rrcs-71-40-157-251.se.biz.rr.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 14 Feb 2015 03:40:05 +0100
To: linux-btrfs@vger.kernel.org
From: James <wireless@tampabay.rr.com>
Subject: btrfs raid-1 uuid-fstab
Date: Sat, 14 Feb 2015 02:31:44 +0000 (UTC)
Message-ID: <loom.20150214T001556-40@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ok,



I have (2) identical 2T drives btrfs + ext4 formated and . I want to use
uuid in the fstab.  No swap for now (each system had 32G) if I need
swap later, I can just setup a file and use swapon? Usually I set up
"boot root and swap" but it seems that I have confused how to do
that correct with btrfs in a raid 1. What I want is if a drive fails,
I can just replace it, or pull one drive  out, replace it with a second 
blank, 2T new drive. Them move the removed drive into a second (identical)
system to build a cloned workstation. From what I've read, uuid numbers
are suppose to be use with fstab + btrfs Partuuid is still flaky. But the
UUID numbers to not appear uniq (due to raid-1)? Do the only get listed once
in fstab?

So I'm finishing up a new install of btrfs-raid1  on a gentoo system.
The machine is in a chroot right now:

gdisk /dev/sdb

Partition table scan:
  MBR: protective
  BSD: not present
  APM: not present
  GPT: present
Found valid GPT with protective MBR; using GPT.

Number  Start (sector)    End (sector)  Size       Code  Name
   1            2048            8191   3.0 MiB     EF02  grub2biosboot
   2            8192         1024000   496.0 MiB   8300  boot
   3         1026048      3907029134   1.8 TiB     8300  root


gdisk /dev/sda

Partition table scan:
  MBR: protective
  BSD: not present
  APM: not present
  GPT: present
Found valid GPT with protective MBR; using GPT.

Number  Start (sector)    End (sector)  Size       Code  Name
   1            2048            8191   3.0 MiB     EF02  grub2biosboot
   2            8192         1024000   496.0 MiB   8300  boot
   3         1026048      3907029134   1.8 TiB     8300  root



#   blkid
/dev/loop0: TYPE="squashfs" 
/dev/sda1: UUID="85cd9d86-4f4d-4113-b14e-cf5339373e20" TYPE="ext4"
PARTLABEL="grub2biosboot" PARTUUID="f88a8259-a4e4-4db8-86df-e709d135fe47" 
/dev/sda2: LABEL="BOOT" UUID="d67a8d19-64bc-4ee1-bebf-48c935b039fa"
UUID_SUB="3eb62dd8-3f07-440f-8606-0c6d99362f6e" TYPE="btrfs"
PARTLABEL="boot" PARTUUID="8a6f7b5f-28a8-4f87-938f-386a93ebe07f" 
/dev/sda3: LABEL="BTROOT" UUID="b7753366-a9a9-4074-8e0e-3beea50fee56"
UUID_SUB="e546ce31-098f-4897-bffd-6c5628f6b62e" TYPE="btrfs"
PARTLABEL="root" PARTUUID="6a8fa54b-3d58-4ac5-8784-6d540f2e65fc" 
/dev/sdb2: LABEL="BOOT" UUID="d67a8d19-64bc-4ee1-bebf-48c935b039fa"
UUID_SUB="02034edf-c537-4fc6-9375-1599e8af2737" TYPE="btrfs"
PARTLABEL="boot" PARTUUID="b7b88ea7-b59a-4a4d-b857-4f55a1be3830" 
/dev/sdb3: LABEL="BTROOT" UUID="b7753366-a9a9-4074-8e0e-3beea50fee56"
UUID_SUB="8a76be85-6106-47ea-90ae-756fb8c37bf1" TYPE="btrfs"
PARTLABEL="root" PARTUUID="3c2c6f88-a1da-40de-83be-21af71a5ce26" 
/dev/sr0: UUID="2014-08-28-06-08-20-22" LABEL="Gentoo Linux amd64 20140828"
TYPE="iso9660" PTUUID="1047d058" PTTYPE="dos" 
/dev/sdb1: PARTLABEL="grub2biosboot"
PARTUUID="3c7a0935-57d4-4bff-a492-aaa261e62212" 


UUID=d67a8d19-64bc-4ee1-bebf-48c935b039fa  
/boot  btrfs noauto,noatime         1 2
UUID=b7753366-a9a9-4074-8e0e-3beea50fee56  /      
btrfs defaults,noatime,compress=lzo,space_cache  0 0
UUID=3c2c6f88-a1da-40de-83be-21af71a5ce26  /boot   
UUID=d67a8d19-64bc-4ee1-bebf-48c935b039fa  /      
btrfs
UUID=b7753366-a9a9-4074-8e0e-3beea50fee56
UUID=85cd9d86-4f4d-4113-b14e-cf5339373e20 /grub2biosboot   
ext4   1 2
PARTUUID=3c7a0935-57d4-4bff-a492-aaa261e62212"  /grub2biosboot
???   0 0

First I notice the last partition (sdb1) seems to be missing the ext4 file
system  I guess when I exit the chroot I can just fix that to match sda1.
So my fstab should look like this?:

You know, it's obvious to me that I have not idea how to create
the fstab for this installation. Any help or guidance would be keen,
to help salvage the installation and get a few partitions installed
with btrfs. Maybe I can somehow migrate to a raid-1 configuration
under btrfs.

James


