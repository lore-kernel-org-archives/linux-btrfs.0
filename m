Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:47656 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab3BZMzn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Feb 2013 07:55:43 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH V2][BTRFS-PROGS] Enhance btrfs fi df with raid5/6 support
Date: Tue, 26 Feb 2013 13:55:41 +0100
Cc: Goffredo Baroncelli <goffredo.baroncelli@yahoo.com>,
        Hugo Mills <hugo@carfax.org.uk>,
        Michael =?utf-8?q?Kj=C3=B6rling?= <michael@kjorling.se>,
        cwillu <cwillu@cwillu.com>, Chris Murphy <lists@colorremedies.com>,
        David Sterba <dsterba@suse.cz>, Zach Brown <zab@zabbo.net>
References: <1361627171-8246-1-git-send-email-goffredo.baroncelli@yahoo.com> (sfid-20130223_191439_818941_2AE57F72)
In-Reply-To: <1361627171-8246-1-git-send-email-goffredo.baroncelli@yahoo.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201302261355.41925.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Samstag, 23. Februar 2013 schrieb Goffredo Baroncelli:
> Hi all,

Hi Goffredo,
 
> I updates my previous patches [1] to add support for raid5/6.
> These patches update the btrfs fi df command and add two new commands:
> - btrfs filesystem disk-usage <path>
> - btrfs device disk-usage <path>

Tested-By: Martin Steigerwald <martin@lichtvoll.de>


Only for -d single and -m single, I have RAID-1 at workstation at work,
but will take some time till I get to office again.

No RAID-5/6 setup at the moment. So test obviously not complete yet.


merkaba:~> /tmp/btrfs fi sh
failed to read /dev/sr0
Label: 'home'  uuid: […]
        Total devices 1 FS bytes used 196.11GB
        devid    1 size 223.52GB used 204.02GB path /dev/dm-2

Label: 'debian'  uuid: […]
        Total devices 1 FS bytes used 10.69GB
        devid    1 size 18.62GB used 17.02GB path /dev/dm-0

Btrfs v0.19-367-g711b24a




/:

merkaba:~> /tmp/btrfs fi df /
Disk size:                18.62GB
Disk allocated:           17.02GB
Disk unallocated:          1.61GB
Used:                     10.69GB
Free (Estimated):          7.93GB       (Max: 7.93GB, min: 7.13GB)
Data to disk ratio:         100 %

merkaba:~> /tmp/btrfs fi disk-usage /
Data,Single: Size:16.01GB, Used:10.14GB
   /dev/dm-0       16.01GB

Metadata,Single: Size:1.01GB, Used:565.34MB
   /dev/dm-0        1.01GB

System,Single: Size:4.00MB, Used:4.00KB
   /dev/dm-0        4.00MB

Unallocated:
   /dev/dm-0        1.61GB

merkaba:~> /tmp/btrfs fi disk-usage -t /
          Data    Metadata System            
          Single  Single   Single Unallocated
                                             
/dev/dm-0 16.01GB   1.01GB 4.00MB      1.61GB
          ======= ======== ====== ===========
Total     16.01GB   1.01GB 4.00MB      1.61GB
Used      10.14GB 565.34MB 4.00KB            

merkaba:~> /tmp/btrfs dev disk-usage /   
/dev/dm-0          18.62GB
   Data,Single:             16.01GB
   Metadata,Single:          1.01GB
   System,Single:            4.00MB
   Unallocated:              1.61GB




/home (quite fresh fs):

merkaba:~#129> /tmp/btrfs fi df /home       
Disk size:               223.52GB
Disk allocated:          204.02GB
Disk unallocated:         19.50GB
Used:                    196.11GB
Free (Estimated):         27.40GB       (Max: 27.40GB, min: 17.66GB)
Data to disk ratio:         100 %

merkaba:~> /tmp/btrfs fi disk-usage /home
Data,Single: Size:202.01GB, Used:194.67GB
   /dev/dm-2      202.01GB

Metadata,Single: Size:2.01GB, Used:1.44GB
   /dev/dm-2        2.01GB

System,Single: Size:4.00MB, Used:48.00KB
   /dev/dm-2        4.00MB

Unallocated:
   /dev/dm-2       19.50GB

merkaba:~> /tmp/btrfs fi disk-usage -t /home
          Data     Metadata System             
          Single   Single   Single  Unallocated
                                               
/dev/dm-2 202.01GB   2.01GB  4.00MB     19.50GB
          ======== ======== ======= ===========
Total     202.01GB   2.01GB  4.00MB     19.50GB
Used      194.67GB   1.44GB 48.00KB            

merkaba:~> /tmp/btrfs dev disk-usage /home  
/dev/dm-2         223.52GB
   Data,Single:            202.01GB
   Metadata,Single:          2.01GB
   System,Single:            4.00MB
   Unallocated:             19.50GB


Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
