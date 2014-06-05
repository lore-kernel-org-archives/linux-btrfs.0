Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:54647 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbaFEQSJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Jun 2014 12:18:09 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Using BTRFS on SSD now ?
Date: Thu, 05 Jun 2014 18:17:54 +0200
Message-ID: <3972210.UmLM5TcfW1@merkaba>
In-Reply-To: <2215647.hErg5R77lo@zafu>
References: <2215647.hErg5R77lo@zafu>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag, 5. Juni 2014, 15:30:26 schrieb Swâmi Petaramesh:
> Hi,
> 
> I just received a new laptop with a Micron 256GB SSD, and I plan to install 
> Fedora 20 onto it.
> 
> I'm considering either BTRFS or ext4 (over LUKS-encrypted LVM) for this 
> machine, but I'm afraid BTRFS might generate too much writes and shorten
> the  SSD lifespan... Or am I mistaken ?

Relax.

I don´t know why you come to the conclusion BTRFS would create more writes
than other filesystems, but here are facts:

BTRFS on Intel SSD 320, since about month or so as RAID 1 on Intel SSD 320
and Crucial m5 mSATA. BTRFS on Intel SSD 320 since I think a bit more than
three years for now.

SMART Attributes Data Structure revision number: 5
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  3 Spin_Up_Time            0x0020   100   100   000    Old_age   Offline      -       0
  4 Start_Stop_Count        0x0030   100   100   000    Old_age   Offline      -       0
  5 Reallocated_Sector_Ct   0x0032   100   100   000    Old_age   Always       -       0
  9 Power_On_Hours          0x0032   100   100   000    Old_age   Always       -       10289
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always       -       2797
170 Reserve_Block_Count     0x0033   100   100   010    Pre-fail  Always       -       0
171 Program_Fail_Count      0x0032   100   100   000    Old_age   Always       -       0
172 Erase_Fail_Count        0x0032   100   100   000    Old_age   Always       -       169
183 Runtime_Bad_Block       0x0030   100   100   000    Old_age   Offline      -       1
184 End-to-End_Error        0x0032   100   100   090    Old_age   Always       -       0
187 Reported_Uncorrect      0x0032   100   100   000    Old_age   Always       -       0
192 Unsafe_Shutdown_Count   0x0032   100   100   000    Old_age   Always       -       241
199 UDMA_CRC_Error_Count    0x0030   100   100   000    Old_age   Offline      -       0
225 Host_Writes_32MiB       0x0032   100   100   000    Old_age   Always       -       449085
226 Workld_Media_Wear_Indic 0x0032   100   100   000    Old_age   Always       -       2204365
227 Workld_Host_Reads_Perc  0x0032   100   100   000    Old_age   Always       -       49
228 Workload_Minutes        0x0032   100   100   000    Old_age   Always       -       13212562
232 Available_Reservd_Space 0x0033   100   100   010    Pre-fail  Always       -       0
233 Media_Wearout_Indicator 0x0032   099   099   000    Old_age   Always       -       0
241 Host_Writes_32MiB       0x0032   100   100   000    Old_age   Always       -       449085
242 Host_Reads_32MiB        0x0032   100   100   000    Old_age   Always       -       1144183


Media Wearout Indicator was 100 initially, now is 99. Thus the SSDs considers
itself to be basically new. Use search machine to find PDF of Intel about
that value.

And 449085 32 MiB Host Writes with KDE session, desktop search Nepomuk, now
Baloo, Akonadi setups with insanely sized mailbox and what not. Thats:

irb(main):027:0> 449085 * 32 / 1024.0 / 1024.0
=> 13.704986572265625

13,7 TiB. This Intel SSD is specced for a useful life of 5 years with 20 GB
host writes *each day*. Thats about 7 TiB per year, even if you use 1000 as
base here. 3 years * 7 TiB = 21 TiB.


So look at your SSD endurance specification and then just relax :)

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
