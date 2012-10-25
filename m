Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp206.alice.it ([82.57.200.102]:35031 "EHLO smtp206.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932151Ab2JYTVP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Oct 2012 15:21:15 -0400
Received: from [192.168.0.27] (95.242.133.103) by smtp206.alice.it (8.6.023.02) (authenticated as kreijack@alice.it)
        id 50469700077BD4C6 for linux-btrfs@vger.kernel.org; Thu, 25 Oct 2012 21:21:14 +0200
Message-ID: <50899151.1070503@inwind.it>
Date: Thu, 25 Oct 2012 21:21:53 +0200
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: "kreijack@inwind.it" <kreijack@inwind.it>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [RFC] New attempt to a better "btrfs fi df"
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi all,

this is a new attempt to improve the output of the command "btrfs fi df".

The previous attempt received a good reception. However there was no a
general consensus about the wording.

Moreover I still didn't understand how btrfs was using the disks.
A my first attempt was to develop a new command which shows how the
disks are divided in chunks. However it still was no clear. Then I
realised that I need to merge the two output.

Below the results. It shows how the disks is used by the different chunks.

The code is pullable from
        http://cassiopea.homelinux.net/git/btrfs-progs-unstable.git
branch
        info-cmd

I don't publish the patched because aren't in a good shape. However I
really like the output. The example is a filesystem based on three
disks of 3GB.

It is clear that:
- - RAID0 uses all the disks
- - RAID1 uses two different disks

Comments are welcome.

Known bugs:
- - if a filesystem uses a disk but there is any chunk, the disk is not
shown (solvable)
- - this command need root capability (I use the BTRFS_IOC_TREE_SEARCH
to get the chunk info; so that is unavoidable)


ghigo@emulato:~$ sudo ./btrfs fi df /mnt/btrfs1/
[sudo] password for ghigo:
Path: /mnt/btrfs1
Summary:
  Disk_size:		   9.00GB
  Disk_allocated:	   1.83GB
  Disk_unallocated:	   7.17GB
  Used:			 284.00KB
  Free_(Estimated):	   6.76GB	(Max: 8.54GB, min: 4.96GB)
  Data_to_disk_ratio:	     75 %

Allocated_area:
  Data,RAID0: Size:921.75MB, Used:256.00KB
     /dev/vdc	  307.25MB
     /dev/vdb	  307.25MB
     /dev/vdd	  307.25MB

  Data,Single: Size:8.00MB, Used:0.00
     /dev/vdb	    8.00MB

  System,RAID1: Size:8.00MB, Used:4.00KB
     /dev/vdd	    8.00MB
     /dev/vdc	    8.00MB

  System,Single: Size:4.00MB, Used:0.00
     /dev/vdb	    4.00MB

  Metadata,RAID1: Size:460.94MB, Used:24.00KB
     /dev/vdb	  460.94MB
     /dev/vdd	  460.94MB

  Metadata,Single: Size:8.00MB, Used:0.00
     /dev/vdb	    8.00MB

  Unused:
     /dev/vdb	    2.23GB
     /dev/vdc	    2.69GB
     /dev/vdd	    2.24GB



- -- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJQiZFRAAoJEA7amzeLguC1v6QQAIk22PRdfXJJZC3Jq0zugQrg
e+4N2FZXDrLtYaV1+skXpLQXSQg60IMjlv2cCuMKx3LhDEIvLIdyi4YgL9rMc6fF
4cyS8eKYcU4JRrq/SzRhRuqQlu/eUm9MtmniMcu9enI2HM5DjusKcPMWvV3tGMNf
+WPYtuMmLNVbI1JAdLEpmUkhYM6jFOyvrUccl0MC49xZzqGUFNnrzCBUn/2hO1pH
c3CeebLxS1cOxCoOtN/dM86VUA0QyV5t9Na7quSBvTOPnRr2JwZ3YSjyfnXqOqO1
1m9O0xgHP0PG6s0rPZGLAWgAoNcBoFfS8OAl+GtCq+k55ZZz7zNBouFm/LLa0I4X
3nLiID8DoY+Bk5JLVolmN+DFRbHGC2CCkcoS5myLq2pxQXnSA28cMQBk9YhATkkz
QpPgnxwVZ6ooLjbM+DAv1mPE5yrnDBICVgi1oTLUS6uqY/AG4fl+TuTG9Oq2mcDH
krPopOJQRoeXIorEXbzoSg+FAlbp86KU2+v5sA552jxjs1WvB//GGyEdtTgd4fl6
EaztCPZvPdkV/NmnLs3rylfVNzmR4d3tFTaRwmByX7RFw/cPGF7/7IxP7Yjdv9un
CiVun2edm5gwMgjUU3qIYjyiqxFiET/sl+NK6SIEdh3R9XVQ2638dXOlHzE255jM
o7tCMjCmCOHSoAg95ZiD
=TaPn
-----END PGP SIGNATURE-----
