Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:44723 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbaLQUM4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Dec 2014 15:12:56 -0500
Received: by mail-wi0-f178.google.com with SMTP id em10so54876wid.5
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Dec 2014 12:12:55 -0800 (PST)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH V2][BTRFS-PROGS] Improve output of mkfs.btrfs command
Date: Wed, 17 Dec 2014 21:14:04 +0100
Message-Id: <1418847252-14184-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi All,

enclosed a patches set to improve the output of mkfs.btrfs command.

Currently I find the output of mkfs.btrfs command quite confusing:

  -- cut -- cut --
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
  -- cut -- cut --

After my patches the output becomes:
  -- cut -- cut --

# mkfs.btrfs -L btrfs-test -f -M -m raid5 -d raid5 /dev/vd[b-k]"
BTRFS filesystem summary:
  Label:		btrfs-test
  UUID:			4409e381-f066-4e7b-af74-b6525fefa08b

  Node size:		4096
  Leaf size:		4096
  Sector size:		4096
  Initial chunks:
    Data+Metadata:	9.01GiB
    System:		18.06MiB
  Metadata profile:	RAID5
  Data profile:		RAID5
  Mixed mode:		YES
  SSD detected:		NO
  Incompat features:	mixed-bg, extref, raid56
  Number of devices:	10
    UUID                                  ID    SIZE    PATH
    ------------------------------------  --  --------- -----------
    907a3722-5d3e-4ee8-9cf1-e0e31c5edea7   1   50.00GiB /dev/vdb
    2517a387-e060-46d1-9be7-9535802333c7   2   50.00GiB /dev/vdc
    763dbe5e-8b16-4330-8730-8b60e245056b   3   50.00GiB /dev/vdd
    180abbc2-4426-4f9c-a711-7735e19536d4   4   50.00GiB /dev/vde
    666799fd-0413-42ce-bac4-a96e3e855ea2   5   50.00GiB /dev/vdf
    a6af3e09-8469-4e57-9fa0-9d82e6c8faf1   6   50.00GiB /dev/vdg
    e2b8a73e-2e37-4eb8-a8cb-71721a96b358   7   50.00GiB /dev/vdh
    3fa65e67-88f6-48cc-9292-9336220e19a8   8    2.00GiB /dev/vdi
    5a238ef4-e143-4b84-b698-347a1ceb7aa7   9    2.00GiB /dev/vdj
    9794c5b4-8a9e-40d0-9774-b672034ef22b  10    2.00GiB /dev/vdk

  Total devices size:                         356.01GiB


  -- cut -- cut --
Each information is in its own row. The devices are listed with more
information (disk uuid, id, size of each devices...)
Nodesize, Leafsize, Sectorsize are separated by the filesystem size.

The metadata/data profile are displayed (before this information was missed).
Also the size of the data/metadata/system chunk are displayed.


These changes are also available via github
	https://github.com/kreijack/btrfs-progs
branch
	mkfs-verbose

Changelog:
v1: first issue (as RFC)
v2: replaced "disks" with "devices" (suggested by Duncan)
    replaced "Feature" with "Incompat features" (suggested by Satoru)
    updated the comment of the documentation patch (suggested by Duncan)
    removed a duplicate "-q" in the documentation patch (suggested by Duncan)
    split the patch #6 in #6 and #7 to simplify the reading and review

BR
G.Baroncelli

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
