Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp205.alice.it ([82.57.200.101]:57087 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754851Ab2J1JAx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Oct 2012 05:00:53 -0400
Message-ID: <508CF469.5070407@inwind.it>
Date: Sun, 28 Oct 2012 10:01:29 +0100
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: "kreijack@inwind.it" <kreijack@inwind.it>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>, cwillu <cwillu@cwillu.com>,
        Chris Murphy <lists@colorremedies.com>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        Hugo Mills <hugo@carfax.org.uk>,
        =?ISO-8859-1?Q?Michael_Kj=F6rling?= <michael@kjorling.se>
Subject: Re: [RFC] New attempt to a better "btrfs fi df"
References: <50899151.1070503@inwind.it>
In-Reply-To: <50899151.1070503@inwind.it>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 2012-10-25 21:21, Goffredo Baroncelli wrote:
> Hi all,
> 
> this is a new attempt to improve the output of the command "btrfs
> fi df".

Below you can see another iteration. I tried to address all the cwillu
requests, which to me make sense.

I thought a lot about chunk/disks vs disk/chunks, and I reached the
conclusion that we could need both. In order to avoid a too long and
redundant output, my idea is to have three different commands:

1) btrfs filesystem df <path>         -> which show what it is called
                                          summary
2) btrfs filesystem disk-usage <path> -> which show what is called
                                         "Detail"
3) btrfs device disk-usage <path>     -> which is like 2) but grouped
                                         by disk instead of chunks.


This is an idea about which I want some comments. The example below
show the latest results. I want to point out that I was not able to
show the chunk usage per disk, because I don't have this information.

The patches are not shaped to be showed, however the code is pullable from

        http://cassiopea.homelinux.net/git/btrfs-progs-unstable.git
branch
        info-cmd  (commit f90e55e7)


$ sudo ./btrfs fi df /mnt/btrfs1/
Path: /mnt/btrfs1
Summary:
  Disk_size:		  21.00GB
  Disk_allocated:	   1.83GB
  Disk_unallocated:	  19.17GB
  Used:			 284.00KB
  Free_(Estimated):	  15.76GB	(Max: 20.54GB, min: 10.96GB)
  Data_to_disk_ratio:	     75 %


Allocated_area:
  Data,Single: Size:8.00MB, Used:0.00
     /dev/vdb	    8.00MB

  Data,RAID0: Size:921.75MB, Used:256.00KB
     /dev/vdb	  307.25MB
     /dev/vdc	  307.25MB
     /dev/vdd	  307.25MB

  Metadata,Single: Size:8.00MB, Used:0.00
     /dev/vdb	    8.00MB

  Metadata,RAID1: Size:460.94MB, Used:24.00KB
     /dev/vdb	  460.94MB
     /dev/vdd	  460.94MB

  System,Single: Size:4.00MB, Used:0.00
     /dev/vdb	    4.00MB

  System,RAID1: Size:8.00MB, Used:4.00KB
     /dev/vdc	    8.00MB
     /dev/vdd	    8.00MB

  Unallocated:
     /dev/vdb	    2.23GB
     /dev/vdc	    2.69GB
     /dev/vdd	    2.24GB
     /dev/vdf	   12.00GB

Disks:
  /dev/vdb	    3.00GB
     Data,Single:              8.00MB
     Data,RAID0:             307.25MB
     Metadata,Single:          8.00MB
     Metadata,RAID1:         460.94MB
     System,Single:            4.00MB
     Unallocated:              2.23GB

  /dev/vdc	    3.00GB
     Data,RAID0:             307.25MB
     System,RAID1:             8.00MB
     Unallocated:              2.69GB

  /dev/vdd	    3.00GB
     Data,RAID0:             307.25MB
     Metadata,RAID1:         460.94MB
     System,RAID1:             8.00MB
     Unallocated:              2.24GB

  /dev/vdf	   12.00GB
     Unallocated:             12.00GB

- -- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJQjPRpAAoJEA7amzeLguC1sUoP+gMhv1NWN48Sun/8fNxJxTg6
TCf65+TKDGKByUKjSLjS0hFEb5xcoWG7H1DEf4KzdZYGMkw5iq8IkZcejVlrj/fn
Z+BRS02Zl0zMdYmMg7SH75BQz2oT5rpUsMI499qiE8gd6UJzeFD0DHjBWWBdptaA
irba605QCtW7JRib3yZwmkcBXSl+oLX2bpELbGARxKWLSx7B5WcKLGNtV3f7whVH
EBzZYXQi2LamRbxH7/la75GXvjSTAXHBrGy3p4TTiF2HAEQ3xALr0aVuYvyHDQhF
4EeledgW/Z26F5DUZcatTlvlse7oKl1R4XX0r5MQRJ4aBwwUAIK/qNpTxm3HNAC9
TSbhUsA/LtcMZyl7AEhKt5/B2MQgkqobpkDK2DiA+qZkONSfoTDBdCjMiwg/yMq8
N07MevdI7gzy3ZKb26v5N6W+wLImpA6mVceWrCksIRh5TP3aOjnsvrkH8uopNC2J
rbb0CW+KF1o28iI/doHuh8BRhhpCfl0vd4oJQseUPDtCsRIqXlHqBu+i/CMwKWE0
fne8RZRia2EAa4fSrl3I7Uc8gEuYt1EgbXdoDvejB6vdVZ7DsHGVc2Pe9JwLi9rv
iL9TU4L+Iaw4DHR+h68k0Eg1q+GX0u3LUxXvgLBmsoyb3JQRMrcVbT+gusvU6Mrr
1YgFwwLdi+KMBTWSHoo2
=iKFO
-----END PGP SIGNATURE-----
