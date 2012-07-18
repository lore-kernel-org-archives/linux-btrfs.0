Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:53287 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab2GRWEs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jul 2012 18:04:48 -0400
Date: Wed, 18 Jul 2012 15:04:46 -0700
From: Marc MERLIN <marc@merlins.org>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@fusionio.com>,
        mbroz@redhat.com, Calvin Walton <calvin.walton@kepstin.ca>,
        jeff@deserettechnology.com
Subject: Re: brtfs on top of dmcrypt with SSD -> Trim or no Trim
Message-ID: <20120718220446.GB3888@merlins.org>
References: <20120202124241.GW16796@shiny> <20120130003754.GD4380@merlins.org> <20120718181316.GD16899@merlins.org> <201207182349.36798.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201207182349.36798.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 18, 2012 at 11:49:36PM +0200, Martin Steigerwald wrote:
> I am still not convinced that dm-crypt is the best way to go about 
> encryption especially for SSDs. But its more of a gut feeling than 
> anything that I can explain easily.
 
I agree that dmcrypt is not great, and it even makes some SSDs slower than
hard drives as per some reports I just posted in another mail.
But:

> I use ecryptfs, formerly encfs, but encfs is much slower. The advantage 

ecryptfs is:
1) painfully slow compared to dmcrypt in my tests. As in so slow that I
don't even need to benchmark it.
2) unable to encrypt very long filenames, so when I copy my archive on an
ecryptfs volume, some files won't copy unless I rename them.

I would love for ecryptfs to have the performance of dmcrypt, because it'd
be easier for me to use it, but it didn't even come close.
 
> > Not using TRIM on my Crucial RealSSD C300 256GB is most likely what
> > caused its garbage collection algorithm to fail (killing the drive and
> > all its data), and it was also causing BRTFS to hang badly when I was
> > getting within 10GB of the drive getting full.
> 
> How did you know that it was its garbage collection algorithm?
 
I don't, hence "most likely". The failure of the drive I got was likely
garbage collection related from what I got from the techs I talked to.

> > From talking to their techs and other folks, it seems clear that TRIM
> > is greatly encouraged, and I'm pretty sure that had I used TRIM, I
> > would not have hit the problems that caused my drive to fail and suck
> > so much when it was getting full.
> 
> I still think that telling the SSD about free space is helping it to 
> balance its wear leveling process.
 
Yes.

> > Any objections and/or comments?
> 
> I still only use fstrim from time to time. About once a week or after lots 
> of drive churning or removing lots of data. I also have a logical volume 
> of about 20 GiB that I keep free for most of the time. And other filesystem 
> are quite full, but there is also some little free space of about 20-30 
> GiB together. So it should be about 40-50 GiB free most of the time.
 
I'm curious. If your filesystem supports trim (i.e. ext4 and btrfs), is
there every a reason to turn off trim in the FS and use fstrim instead?

> The 300 GB Intel SSD 320 in this ThinkPad T520 is still fine after about 1 
> year and 2-3 months. I do not see any performance degradation whatsover so 
> far. Last time I looked also SMART data looked fine, but I have not much 
> experience with SMART on SSDs so far.

My experience and what I read online is that SMART on SSDs doesn't seem to
help much in many cases. I've seen too many reports of SSDs dying very
suddenly with absolutely no warning.
Hard drives, if you look at smart data over time, typically give you plenty
of warning before they die (as long as you don't drop them off a table
without parking their heads).

If you're curious, here's the last dump of my SMART data on the SSD that
died:
=== START OF INFORMATION SECTION ===
Model Family:     Crucial RealSSD C300
Device Model:     C300-CTFDDAC256MAG
Serial Number:    00000000111003044A9C
LU WWN Device Id: 5 00a075 103044a9c
Firmware Version: 0007
User Capacity:    256,060,514,304 bytes [256 GB]

  1 Raw_Read_Error_Rate     0x002f   100   100   000    Pre-fail  Always       -       0
  5 Reallocated_Sector_Ct   0x0033   100   100   000    Pre-fail  Always       -       0
  9 Power_On_Hours          0x0032   100   100   000    Old_age   Always       -       2977
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always       -       472
170 Grown_Failing_Block_Ct  0x0033   100   100   000    Pre-fail  Always       -       0
171 Program_Fail_Count      0x0032   100   100   000    Old_age   Always       -       0
172 Erase_Fail_Count        0x0032   100   100   000    Old_age   Always       -       0
173 Wear_Levelling_Count    0x0033   100   100   000    Pre-fail  Always       -       35
174 Unexpect_Power_Loss_Ct  0x0032   100   100   000    Old_age   Always       -       1
181 Non4k_Aligned_Access    0x0022   100   100   000    Old_age   Always       -       2757376737803
183 SATA_Iface_Downshift    0x0032   100   100   000    Old_age   Always       -       0
184 End-to-End_Error        0x0033   100   100   000    Pre-fail  Always       -       0
187 Reported_Uncorrect      0x0032   100   100   000    Old_age   Always       -       0
188 Command_Timeout         0x0032   100   100   000    Old_age   Always       -       0
189 Factory_Bad_Block_Ct    0x000e   100   100   000    Old_age   Always       -       422
195 Hardware_ECC_Recovered  0x003a   100   100   000    Old_age   Always       -       0
196 Reallocated_Event_Count 0x0032   100   100   000    Old_age   Always       -       0
197 Current_Pending_Sector  0x0032   100   100   000    Old_age   Always       -       0
198 Offline_Uncorrectable   0x0030   100   100   000    Old_age   Offline      -       0
199 UDMA_CRC_Error_Count    0x0036   100   100   000    Old_age   Always       -       0
202 Perc_Rated_Life_Used    0x0018   100   100   000    Old_age   Offline      -       0
206 Write_Error_Rate        0x000e   100   100   000    Old_age   Always       -       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Completed without error       00%      2958         -
# 2  Extended offline    Completed without error       00%      2937         -
# 3  Short offline       Completed without error       00%      2936         -
# 4  Short offline       Completed without error       00%      2915         -
# 5  Short offline       Completed without error       00%      2892         -
# 6  Short offline       Completed without error       00%      2881         -
# 7  Short offline       Completed without error       00%      2859         -
# 8  Vendor (0xff)       Completed without error       00%      2852         -

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
