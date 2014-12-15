Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:52854 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbaLOUBl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Dec 2014 15:01:41 -0500
Received: by mail-wi0-f180.google.com with SMTP id n3so10277896wiv.7
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Dec 2014 12:01:39 -0800 (PST)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [RFC][BTRFS-PROGS] Improve output of mkfs.btrfs command
Date: Mon, 15 Dec 2014 21:02:53 +0100
Message-Id: <1418673780-22000-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Hi All,

enclosed a patches set to improve the output of mkfs.btrfs command.

Currently I find the output of mkfs.btrfs command quite confusing:

# mkfs.btrfs -f -M -d raid5 -m raid5 /dev/vd[b-k] 

Btrfs v3.17
See http://btrfs.wiki.kernel.org for more information.

Turning ON incompat feature 'mixed-bg': mixed data and metadata block groups
Turning ON incompat feature 'extref': increased hardlink limit per file to 65536
Turning ON incompat feature 'raid56': raid56 extended format
Created a data/metadata chunk of size 8388608
adding device /dev/vdc id 2
adding device /dev/vdd id 3
adding device /dev/vde id 4
adding device /dev/vdf id 5
adding device /dev/vdg id 6
adding device /dev/vdh id 7
adding device /dev/vdi id 8
adding device /dev/vdj id 9
adding device /dev/vdk id 10
fs created label (null) on /dev/vdb
	nodesize 4096 leafsize 4096 sectorsize 4096 size 356.01GiB

After my patches the output becomes:

# mkfs.btrfs -f -d raid5 -m raid5 /dev/vd[b-k] 
BTRFS filesystem summary:
  Label:		btrfs-test
  UUID:			1073cb19-b675-423d-9aba-caad7f1508a8

  Node size:		16384
  Leaf size:		16384
  Sector size:		4096
  Initial chunks:
    Data:		9.01GiB
    Metadata:		3.61GiB
    System:		18.06MiB
  Metadata profile:	RAID5
  Data profile:		RAID5
  Mixed mode:		NO
  SSD detected:		NO
  Features:		extref, raid56
  Number of devices:	10
    UUID                                  ID    SIZE    PATH
    ------------------------------------  --  --------- -----------
    62121322-5666-4ecf-bc8e-c9b3d9f60db9   1   50.00GiB /dev/vdb
    6158cb13-3ae8-42b6-8603-660f1e5c8a7a   2   50.00GiB /dev/vdc
    b49516db-ddf5-4f54-8831-a4babc79e901   3   50.00GiB /dev/vdd
    00b03d81-7d29-4894-8050-9dd205f97c41   4   50.00GiB /dev/vde
    f119a2ec-5ef0-436c-805e-c1b0612b05ca   5   50.00GiB /dev/vdf
    adee4f58-e094-4bd4-8c56-941527524f8d   6   50.00GiB /dev/vdg
    a8299171-2024-4057-ba56-1f83bf6d7e2e   7   50.00GiB /dev/vdh
    b694e275-e454-4dbd-beb0-e33c388cffa2   8    2.00GiB /dev/vdi
    7cbe04b5-36cd-4ea7-be82-206d5487914e   9    2.00GiB /dev/vdj
    7c320654-675e-456b-ac23-cfb148b8ea57  10    2.00GiB /dev/vdk

  Total disks size:                           356.01GiB


Each information is in its own row. The disks are listed with more
information (disk uuid, id, size of each disk...)
Nodesize, Leafsize, Sectorsize are separated by the filesystem size.

The metadata/data profile are displayed (before this information was missed).
Also the size of the data/metadata/system chunk are displayed.

This is an RFC to collect suggestions.


These changes are also available via github
https://github.com/kreijack/btrfs-progs/commit/44fc80342b9c238f41b803cb0b9b4efe9b66d56f


BR
G.Baroncelli



-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
