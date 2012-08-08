Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:60070 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754972Ab2HHCrS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Aug 2012 22:47:18 -0400
Date: Tue, 7 Aug 2012 19:47:17 -0700
From: Marc MERLIN <marc@merlins.org>
To: =?iso-8859-1?B?Suly9G1l?= Poulin <jeromepoulin@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs panic in 3.5.0
Message-ID: <20120808024717.GA12210@merlins.org>
References: <20120807174047.GE24635@merlins.org> <CALJXSJr95YjaBqM6vtOexqxXLokj-2av6k74AvqiEcO=U2RocQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <CALJXSJr95YjaBqM6vtOexqxXLokj-2av6k74AvqiEcO=U2RocQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 07, 2012 at 10:38:28PM -0400, Jérôme Poulin wrote:
> On Tue, Aug 7, 2012 at 1:40 PM, Marc MERLIN <marc@merlins.org> wrote:
> >
> > System rebooted ok.
> 
> I just want to be sure that you are aware that your hard drive is
> currently killing itself. Those READ FPDMA QUEUED mean that your hard
> disk is relocatting bad sectors and has problem reading those.

Yeah, I saw that, so it's actually an SSD (the wretched samsung one I've
been posting about), and I'm just about to return it.

What's interesting is that smart shows no such error:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  5 Reallocated_Sector_Ct   0x0033   100   100   010    Pre-fail  Always       -       0
  9 Power_On_Hours          0x0032   099   099   000    Old_age   Always       -       132
 12 Power_Cycle_Count       0x0032   099   099   000    Old_age   Always       -       19
177 Wear_Leveling_Count     0x0013   099   099   000    Pre-fail  Always       -       29
179 Used_Rsvd_Blk_Cnt_Tot   0x0013   100   100   010    Pre-fail  Always       -       0
181 Program_Fail_Cnt_Total  0x0032   100   100   010    Old_age   Always       -       0
182 Erase_Fail_Count_Total  0x0032   100   100   010    Old_age   Always       -       0
183 Runtime_Bad_Block       0x0013   100   100   010    Pre-fail  Always       -       0
187 Reported_Uncorrect      0x0032   100   100   000    Old_age   Always       -       0
190 Airflow_Temperature_Cel 0x0032   051   040   000    Old_age   Always       -       49
195 Hardware_ECC_Recovered  0x001a   200   200   000    Old_age   Always       -       0
199 UDMA_CRC_Error_Count    0x003e   253   253   000    Old_age   Always       -       2
235 Unknown_Attribute       0x0012   099   099   000    Old_age   Always       -       6
241 Total_LBAs_Written      0x0032   099   099   000    Old_age   Always       -       627681656

I'm not saying nothing is wrong with the drive, but that it's not a magnetic
bad sector.

Either way, I'm going to get a different SSD soon, although I guess this faliure mode
was useful in finding a bug in the btrfs code in the meantime :)

Thanks for the heads up
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
