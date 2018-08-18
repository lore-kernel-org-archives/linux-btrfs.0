Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:50503 "EHLO
        mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbeHRLyN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 18 Aug 2018 07:54:13 -0400
From: Martin Steigerwald <martin@lichtvoll.de>
To: Roman Mamedov <rm@romanrm.net>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: Experiences on BTRFS Dual SSD RAID 1 with outage of one SSD
Date: Sat, 18 Aug 2018 10:47:15 +0200
Message-ID: <3878092.uyhAA9QzPZ@merkaba>
In-Reply-To: <20180818121230.7339a49f@natsu>
References: <2331408.nK7QgfhVWv@merkaba> <12085882.kBGyflhNqb@merkaba> <20180818121230.7339a49f@natsu>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Roman Mamedov - 18.08.18, 09:12:
> On Fri, 17 Aug 2018 23:17:33 +0200
> 
> Martin Steigerwald <martin@lichtvoll.de> wrote:
> > > Do not consider SSD "compression" as a factor in any of your
> > > calculations or planning. Modern controllers do not do it anymore,
> > > the last ones that did are SandForce, and that's 2010 era stuff.
> > > You
> > > can check for yourself by comparing write speeds of compressible
> > > vs
> > > incompressible data, it should be the same. At most, the modern
> > > ones
> > > know to recognize a stream of binary zeroes and have a special
> > > case
> > > for that.
> > 
> > Interesting. Do you have any backup for your claim?
> 
> Just "something I read". I follow quote a bit of SSD-related articles
> and reviews which often also include a section to talk about the
> controller utilized, its background and technological
> improvements/changes -- and the compression going out of fashion
> after SandForce seems to be considered a well-known fact.
> 
> Incidentally, your old Intel 320 SSDs actually seem to be based on
> that old SandForce controller (or at least license some of that IP to
> extend on it), and hence those indeed might perform compression.

Interesting. Back then I read the Intel SSD 320 would not compress.
I think its difficult to know for sure with those proprietary controllers.

> > As the data still needs to be transferred to the SSD at least when
> > the SATA connection is maxed out I bet you won´t see any difference
> > in write speed whether the SSD compresses in real time or not.
> 
> Most controllers expose two readings in SMART:
> 
>   - Lifetime writes from host (SMART attribute 241)
>   - Lifetime writes to flash (attribute 233, or 177, or 173...)
>
> It might be difficult to get the second one, as often it needs to be
> decoded from others such as "Average block erase count" or "Wear
> leveling count". (And seems to be impossible on Samsung NVMe ones,
> for example)

I got the impression every manufacturer does their own thing here. And I
would not even be surprised when its different between different generations
of SSDs by one manufacturer.

# Crucial mSATA

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   100   100   000    Pre-fail  Always       -       0
  5 Reallocated_Sector_Ct   0x0033   100   100   000    Pre-fail  Always       -       0
  9 Power_On_Hours          0x0032   100   100   000    Old_age   Always       -       16345
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always       -       4193
171 Program_Fail_Count      0x0032   100   100   000    Old_age   Always       -       0
172 Erase_Fail_Count        0x0032   100   100   000    Old_age   Always       -       0
173 Wear_Leveling_Count     0x0032   078   078   000    Old_age   Always       -       663
174 Unexpect_Power_Loss_Ct  0x0032   100   100   000    Old_age   Always       -       362
180 Unused_Rsvd_Blk_Cnt_Tot 0x0033   000   000   000    Pre-fail  Always       -       8219
183 SATA_Iface_Downshift    0x0032   100   100   000    Old_age   Always       -       1
184 End-to-End_Error        0x0032   100   100   000    Old_age   Always       -       0
187 Reported_Uncorrect      0x0032   100   100   000    Old_age   Always       -       0
194 Temperature_Celsius     0x0022   046   020   000    Old_age   Always       -       54 (Min/Max -10/80)
196 Reallocated_Event_Count 0x0032   100   100   000    Old_age   Always       -       16
197 Current_Pending_Sector  0x0032   100   100   000    Old_age   Always       -       0
198 Offline_Uncorrectable   0x0030   100   100   000    Old_age   Offline      -       0
199 UDMA_CRC_Error_Count    0x0032   100   100   000    Old_age   Always       -       0
202 Percent_Lifetime_Used   0x0031   078   078   000    Pre-fail  Offline      -       22

I expect the raw value of this to raise more slowly now there are almost
100 GiB completely unused and there is lots of free space in the filesystems.
But even if not, the SSD is in use since March 2014. So it has plenty of time
to go.

206 Write_Error_Rate        0x000e   100   100   000    Old_age   Always       -       0
210 Success_RAIN_Recov_Cnt  0x0032   100   100   000    Old_age   Always       -       0
246 Total_Host_Sector_Write 0x0032   100   100   ---    Old_age   Always       -       91288276930

^^ In sectors. 91288276930 * 512 / 1024 / 1024 / 1024 ~= 43529 GiB

Could be 4 KiB… but as its telling about Host_Sector and the value multiplied
by eight does not make any sense, I bet its 512 Bytes.

% smartctl /dev/sdb --all |grep "Sector Size"
Sector Sizes:     512 bytes logical, 4096 bytes physical

247 Host_Program_Page_Count 0x0032   100   100   ---    Old_age   Always       -       2892511571
248 Bckgnd_Program_Page_Cnt 0x0032   100   100   ---    Old_age   Always       -       742817198


# Intel SSD 320, before secure erase

The Intel SSD 320 in April 2017, I lost the smartctl -a directly before the
secure erase output due to writing it to the /home filesystem after the
backup – I do have the more recent attrlog CSV file, but I feel to lazy
to format it in a meaningful way:

SMART Attributes Data Structure revision number: 5
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  3 Spin_Up_Time            0x0020   100   100   000    Old_age   Offline      -       0
  4 Start_Stop_Count        0x0030   100   100   000    Old_age   Offline      -       0
  5 Reallocated_Sector_Ct   0x0032   100   100   000    Old_age   Always       -       0
  9 Power_On_Hours          0x0032   100   100   000    Old_age   Always       -       21035
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always       -       5292
170 Reserve_Block_Count     0x0033   100   100   010    Pre-fail  Always       -       0
171 Program_Fail_Count      0x0032   100   100   000    Old_age   Always       -       0
172 Erase_Fail_Count        0x0032   100   100   000    Old_age   Always       -       169
183 SATA_Downshift_Count    0x0030   100   100   000    Old_age   Offline      -       3
184 End-to-End_Error        0x0032   100   100   090    Old_age   Always       -       0
187 Reported_Uncorrect      0x0032   100   100   000    Old_age   Always       -       0
192 Unsafe_Shutdown_Count   0x0032   100   100   000    Old_age   Always       -       462
199 CRC_Error_Count         0x0030   100   100   000    Old_age   Offline      -       0
225 Host_Writes_32MiB       0x0032   100   100   000    Old_age   Always       -       1370316
226 Workld_Media_Wear_Indic 0x0032   100   100   000    Old_age   Always       -       2206583
227 Workld_Host_Reads_Perc  0x0032   100   100   000    Old_age   Always       -       49
228 Workload_Minutes        0x0032   100   100   000    Old_age   Always       -       13857327
232 Available_Reservd_Space 0x0033   100   100   010    Pre-fail  Always       -       0
233 Media_Wearout_Indicator 0x0032   097   097   000    Old_age   Always       -       0

^^ almost new. I have a PDF from Intel explaining this value somewhere.
Intel SSD 320 had more free space than the Crucial M500 for a good time
of their usage.

241 Host_Writes_32MiB       0x0032   100   100   000    Old_age   Always       -       1370316

^^ 1370316 * 32 / 1024 ~= 42822 GiB

242 Host_Reads_32MiB        0x0032   100   100   000    Old_age   Always       -       2016560

The Intel SSD is in use for a longer time, since May 2011.


# Intel SSD 320 after secure erase:

Interestingly the secure erase nuked the SMART values:

SMART Attributes Data Structure revision number: 5
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  3 Spin_Up_Time            0x0020   100   100   000    Old_age   Offline      -       0
  4 Start_Stop_Count        0x0030   100   100   000    Old_age   Offline      -       0
  5 Reallocated_Sector_Ct   0x0032   100   100   000    Old_age   Always       -       0
  9 Power_On_Hours          0x0032   100   100   000    Old_age   Always       -       3
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always       -       6726
170 Reserve_Block_Count     0x0033   100   100   010    Pre-fail  Always       -       0
171 Program_Fail_Count      0x0032   100   100   000    Old_age   Always       -       0
172 Erase_Fail_Count        0x0032   100   100   000    Old_age   Always       -       0
183 SATA_Downshift_Count    0x0030   100   100   000    Old_age   Offline      -       0
184 End-to-End_Error        0x0032   100   100   090    Old_age   Always       -       0
187 Reported_Uncorrect      0x0032   100   100   000    Old_age   Always       -       0
192 Unsafe_Shutdown_Count   0x0032   100   100   000    Old_age   Always       -       537
199 CRC_Error_Count         0x0030   100   100   000    Old_age   Offline      -       0
225 Host_Writes_32MiB       0x0032   100   100   000    Old_age   Always       -       5768
226 Workld_Media_Wear_Indic 0x0032   100   100   000    Old_age   Always       -       65535
227 Workld_Host_Reads_Perc  0x0032   100   100   000    Old_age   Always       -       65535
228 Workload_Minutes        0x0032   100   100   000    Old_age   Always       -       65535
232 Available_Reservd_Space 0x0033   100   100   010    Pre-fail  Always       -       0
233 Media_Wearout_Indicator 0x0032   100   100   000    Old_age   Always       -       0
241 Host_Writes_32MiB       0x0032   100   100   000    Old_age   Always       -       5768
242 Host_Reads_32MiB        0x0032   100   100   000    Old_age   Always       -

Good for selling it. You could claim it is all fresh and new :)


# Samsung Pro 860

Note this SSD is almost new – smartctl 6.6 2016-05-31 does not know about 
one attribute. I am not sure why the command is so old in Debian Sid:

SMART Attributes Data Structure revision number: 1
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  5 Reallocated_Sector_Ct   0x0033   100   100   010    Pre-fail  Always       -       0
  9 Power_On_Hours          0x0032   099   099   000    Old_age   Always       -       50
 12 Power_Cycle_Count       0x0032   099   099   000    Old_age   Always       -       26
177 Wear_Leveling_Count     0x0013   100   100   000    Pre-fail  Always       -       0

^^ new :)

179 Used_Rsvd_Blk_Cnt_Tot   0x0013   100   100   010    Pre-fail  Always       -       0
181 Program_Fail_Cnt_Total  0x0032   100   100   010    Old_age   Always       -       0
182 Erase_Fail_Count_Total  0x0032   100   100   010    Old_age   Always       -       0
183 Runtime_Bad_Block       0x0013   100   100   010    Pre-fail  Always       -       0
187 Reported_Uncorrect      0x0032   100   100   000    Old_age   Always       -       0
190 Airflow_Temperature_Cel 0x0032   065   052   000    Old_age   Always       -       35
195 Hardware_ECC_Recovered  0x001a   200   200   000    Old_age   Always       -       0
199 UDMA_CRC_Error_Count    0x003e   100   100   000    Old_age   Always       -       0
235 Unknown_Attribute       0x0012   099   099   000    Old_age   Always       -       1
241 Total_LBAs_Written      0x0032   099   099   000    Old_age   Always       -       1133999775

According to reference in internet, sectors are meant here, so:

1133999775 * 512 / 1024 / 1024 / 1024 ~= 541 GiB

% smartctl /dev/sda --all |grep "Sector Size"
Sector Size:      512 bytes logical/physical

> But if you have numbers for both, you know the write amplification of
> the drive (and its past workload).

Sure.

> If there is compression at work, you'd see the 2nd number being
> somewhat, or significantly lower -- and barely increase at all, if
> you write highly compressible data. This is not typically observed on
> modern SSDs, except maybe when writing zeroes. Writes to flash will
> be the same as writes from host, or most often somewhat higher, as
> the hardware can typically erase flash only in chunks of 2MB or so,
> hence there's quite a bit of under the hood reorganizing going on.
> Also as a result depending on workloads the "to flash" number can be
> much higher than "from host".

Okay, I get that, but it would be quite some effort to make reliable
measurements cause you´d need to write quite some amount of data
for the media wearout indicator to change. I do not intend to do that.

> Point is, even when the SATA link is maxed out in both cases, you can
> still check if there's compression at work via using those SMART
> attributes.

Sure. But with quite some effort. And with some aging of the SSDs involved.

I can imagine better uses of my  time :)

> > In any case: It was a experience report, no request for help, so I
> > don´t see why exact error messages are absolutely needed. If I had
> > a support inquiry that would be different, I agree.
> 
> Well, when reading such stories (involving software that I also use) I
> imagine what if I had been in that situation myself, what would I do,
> would I have anything else to try, do I know about any workaround for
> this. And without any technical details to go from, those are all
> questions left unanswered.

Sure, I get that.

My priority was to bring the machine back online. I managed to put the
screen log on a filesystem I destroyed afterwards and I managed to put it
there after the backup of that filesystem was complete… so c’est la vie the
log is gone. But even if I still had it, I probably would not have included
all error messages. But I would have been able to provide the those you
are interested in. Anyway, its gone and that is it.

Thanks,
-- 
Martin
