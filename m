Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:40911 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933172Ab2J2WUh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Oct 2012 18:20:37 -0400
Received: by mail-ee0-f46.google.com with SMTP id b15so2356433eek.19
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Oct 2012 15:20:36 -0700 (PDT)
Message-ID: <508F015F.5090507@gmail.com>
Date: Mon, 29 Oct 2012 23:21:19 +0100
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: "kreijack@inwind.it" <kreijack@inwind.it>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>, cwillu <cwillu@cwillu.com>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        Chris Murphy <lists@colorremedies.com>,
        =?ISO-8859-1?Q?Michael_Kj=F6rl?= =?ISO-8859-1?Q?ing?=
	<michael@kjorling.se>,
        Hugo Mills <hugo@carfax.org.uk>
Subject: [RFC][V2] New attempt to a better "btrfs fi df"
References: <50899151.1070503@inwind.it>
In-Reply-To: <50899151.1070503@inwind.it>
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
disks are divided in chunks.
Then after some thoughts I made three commands:

$ btrfs filesystem df <path>
# btrfs device disk-usage <path>
# btrfs filesystem disk-usage <path>

The first one shows only the section that before I called "Summary":

$ ./btrfs filesystem df /mnt/btrfs1/
Disk_size:		  21.00GB
Disk_allocated:		   1.83GB
Disk_unallocated:	  19.17GB
Used:			 284.00KB
Free_(Estimated):	  15.76GB	(Max: 20.54GB, min: 10.96GB)
Data_to_disk_ratio:	     75 %

The second one show the chunk list grouped by devices:

$ sudo ./btrfs device disk-usage /mnt/btrfs1/
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


The third one shows the devices grouped by chunk type; it has two kind
of output the first kind of output is a linear one (as before); the
second kind of output is in a tabular form. I don't like it because it
is suitable only when the filesystem uses few profile; otherwise this
output is larger than 80 columns.

$ sudo ./btrfs filesystem disk-usage /mnt/btrfs1/
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



$ sudo ./btrfs filesystem disk-usage -t /mnt/btrfs1/
           Data      Data      Metadata  System    System
           Single    RAID0     Single    Single    RAID1     Unused

vdb          8.00MB  307.25MB    8.00MB    4.00MB         -    2.23GB
vdc               -  307.25MB         -         -    8.00MB    2.69GB
vdd               -  307.25MB         -         -    8.00MB    2.24GB
vdf               -         -         -         -         -   12.00GB
          ========= ========= ========= ========= ========= =========
Total        8.00MB  921.75MB    8.00MB    4.00MB    8.00MB   19.17GB
Used           0.00  256.00KB      0.00      0.00    4.00KB


The latest output is a fake, because the original one requires 78-79
columns, so the email reader would rewrap it. I had to remove a column
(Metadata,RAID1) : this confirm me that this kind of output is
unusable as general case.

The code is pullable from
        http://cassiopea.homelinux.net/git/btrfs-progs-unstable.git
branch
        info-cmd

I don't publish the patches because aren't in a good shape. The
example is a filesystem based on three disks of 3GB and one disk of 12 GB.

Comments are welcome.

Known bugs:
- - the commands btrfs fi disk-usage and btrfs device disk-usage need
root capability (I use the BTRFS_IOC_TREE_SEARCH
to get the chunk info; so that is unavoidable)



- -- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJQjwFeAAoJEA7amzeLguC1jtEP/1tzU9s2mfLhz1AVotYW3oWd
hnVNdBmz/E+uGJYTY99heB/Vmnu2dZUQyKlbUilAM7XtQw7GsEITGa+6peoPIPrI
8v0mYL+e/Bd24caMS7DlRR1cJ9lqWlJg6lxwGryVYCyYcFIkkRhw5PcFAxOyF2xe
Q0aESR8a4CA7NBMXH6QeTLD7oSZAnIFAK/EDYbExweJ1a+OSMzgJ+CMWmlaOf79v
R90c9qg309dUctHO0mB/D5XjJlFwNaGJpNsxEvBJdkZl0VgHxm1unsaxYLFU5ybk
/qJs7yqJIFk9BtV15zREtuC7n+CC5Mwo/gPOP24qyZazfLgMv72NaOTmDdiXuNpV
vjVgAgNSRL5JSI6RTQEgJwy2xgPJA/k0z4R20xpXRn0+E2OHDSKk/+gqmCE3Iieb
3LcJBuEPSQxpx6R5RubNhwauu3h6Dn4qBIUSagH6zYz+AUwkfcUTGdS3vgrXfEUf
UNGn3wEcz8veIr66cOm3t6pTcRInFOIvOf/32Bei1SZyEiiX0pzxmSWAutaOiRNe
m+sjWhFF3QW6wKX25QRXFgqnFJQwpx+9sP90dQvTh5oOio+xbi+eGZJ8WEMVY6b1
L4iiqY8DtnfufQF2XUGGIa8b8Wxdp15gUoeqPKh2Oy8srEsUjV+g4vwXOMrRtYfR
d4o8YssrtjlpSBQCYHpZ
=TUa5
-----END PGP SIGNATURE-----
