Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:59024 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbaCIKBU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Mar 2014 06:01:20 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
Cc: linux-btrfs@vger.kernel.org, impactoria@googlemail.com
Subject: Re: Massive BTRFS performance degradation
Date: Sun, 09 Mar 2014 11:01:17 +0100
Message-ID: <3438733.p6vCjojJlH@merkaba>
In-Reply-To: <1553599.dDs6U900Vh@tethys>
References: <531C1CC4.701@gmail.com> <1553599.dDs6U900Vh@tethys>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sonntag, 9. März 2014, 09:17:24 schrieb Swâmi Petaramesh:
> Le dimanche 9 mars 2014 08:48:20 KC a écrit :
> > I am experiencing massive performance degradation on my BTRFS root
> > partition on SSD.
> 
> BTW, is BTRFS still a SSD-killer ? It had this reputation a while ago, and
> I'm not sure if this still is the case, but I don't dare (yet) converting
> to BTRFS one of my laptops that has a SSD...

I never heard about this reputation and luckily the Intel SSD 320 didn´t
either. Its almost three years old by now:

SMART Attributes Data Structure revision number: 5
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  3 Spin_Up_Time            0x0020   100   100   000    Old_age   Offline      -       0
  4 Start_Stop_Count        0x0030   100   100   000    Old_age   Offline      -       0
  5 Reallocated_Sector_Ct   0x0032   100   100   000    Old_age   Always       -       0
  9 Power_On_Hours          0x0032   100   100   000    Old_age   Always       -       9171
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always       -       2603
170 Reserve_Block_Count     0x0033   100   100   010    Pre-fail  Always       -       0
171 Program_Fail_Count      0x0032   100   100   000    Old_age   Always       -       0
172 Erase_Fail_Count        0x0032   100   100   000    Old_age   Always       -       169
183 Runtime_Bad_Block       0x0030   100   100   000    Old_age   Offline      -       1
184 End-to-End_Error        0x0032   100   100   090    Old_age   Always       -       0
187 Reported_Uncorrect      0x0032   100   100   000    Old_age   Always       -       0
192 Unsafe_Shutdown_Count   0x0032   100   100   000    Old_age   Always       -       225
199 UDMA_CRC_Error_Count    0x0030   100   100   000    Old_age   Offline      -       0
225 Host_Writes_32MiB       0x0032   100   100   000    Old_age   Always       -       393645
226 Workld_Media_Wear_Indic 0x0032   100   100   000    Old_age   Always       -       2204244
227 Workld_Host_Reads_Perc  0x0032   100   100   000    Old_age   Always       -       49
228 Workload_Minutes        0x0032   100   100   000    Old_age   Always       -       13145477
232 Available_Reservd_Space 0x0033   100   100   010    Pre-fail  Always       -       0
233 Media_Wearout_Indicator 0x0032   100   100   000    Old_age   Always       -       0
241 Host_Writes_32MiB       0x0032   100   100   000    Old_age   Always       -       393645
242 Host_Reads_32MiB        0x0032   100   100   000    Old_age   Always       -       1002465


Media wearout indicator basically says the SSD considers itself to be
"new". Value is the same 100 as it was as it was new. The raw value tough
raised for the first time. On 2013-10-12 is was:

233 Media_Wearout_Indicator 0x0032   100   100   000    Old_age   Always       -       0

For more about this indicator read in Intel PDF about it.


There are some Erase fails that happened I think in the first year of
SSD life, but that 169 raw value so far never raised gain.


There have been 393645 * 32 MiB = 12,01 TiB of writes. The SSD itself is
specified to be usable for at least 5 years with 20 TB of host writes each
day. That is about 7,3 TB or 7,1 TiB. I assumed TB in the Intel
specification document, if its TiB, its then its 7,3 TiB.

Anyway with conversative 7 TiB a year or 21 TiB in three years of which
only 12 TiB are used up, I am quite confident that this SSD could last
longer than 5 years.

This ThinkPad T520 has been with BTRFS since installation of the Debian
sid system on it with Kernel 2.6.39 or even 2.6.38 (where Sandybridge
graphics didn´t work so well as today yet).

So that much to any FUD about BTRFS and SSDs.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
