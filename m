Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:54648 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172Ab2GSKke convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Jul 2012 06:40:34 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Marc MERLIN <marc@merlins.org>
Subject: Re: brtfs on top of dmcrypt with SSD -> Trim or no Trim
Date: Thu, 19 Jul 2012 12:40:32 +0200
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@fusionio.com>,
        mbroz@redhat.com, Calvin Walton <calvin.walton@kepstin.ca>,
        jeff@deserettechnology.com
References: <20120202124241.GW16796@shiny> <201207182349.36798.Martin@lichtvoll.de> <20120718220446.GB3888@merlins.org> (sfid-20120719_120106_955995_05B295D8)
In-Reply-To: <20120718220446.GB3888@merlins.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201207191240.32411.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag, 19. Juli 2012 schrieb Marc MERLIN:
> On Wed, Jul 18, 2012 at 11:49:36PM +0200, Martin Steigerwald wrote:
> > I am still not convinced that dm-crypt is the best way to go about
> > encryption especially for SSDs. But its more of a gut feeling than
> > anything that I can explain easily.
> 
> I agree that dmcrypt is not great, and it even makes some SSDs slower
> than hard drives as per some reports I just posted in another mail.
> 
> But:
> > I use ecryptfs, formerly encfs, but encfs is much slower. The
> > advantage
> 
> ecryptfs is:
> 1) painfully slow compared to dmcrypt in my tests. As in so slow that I
> don't even need to benchmark it.

Huh! Its an order of magnitude faster than encfs here – well no wonder
considering it uses FUSE – and its definately fast enough for my work
account on this machine.

> 2) unable to encrypt very long filenames, so when I copy my archive on
> an ecryptfs volume, some files won't copy unless I rename them.

Hmmm, okay, thats an issue. I do not seem to have that long names in that
directory tough.

> I would love for ecryptfs to have the performance of dmcrypt, because
> it'd be easier for me to use it, but it didn't even come close.

I never benchmarked it except for the time it needs to build my training
slides. It was about twice as fast as encfs and it was fast enough for
my case. Might be that dm-crypt is even faster, but then I do not see any
visible performance difference between my unencrypted private account
and the encrypted work account. Might still be that there is a difference,
its actually likely, but I did not noticed it so far.

I difference is: My /home is still on Ext4 here. Only / is on BTRFS. So
maybe ecryptfs is only that slow on BTRFS?

> > > Not using TRIM on my Crucial RealSSD C300 256GB is most likely what
> > > caused its garbage collection algorithm to fail (killing the drive
> > > and all its data), and it was also causing BRTFS to hang badly
> > > when I was getting within 10GB of the drive getting full.
> > 
> > How did you know that it was its garbage collection algorithm?
> 
> I don't, hence "most likely". The failure of the drive I got was likely
> garbage collection related from what I got from the techs I talked to.

Ah okay. I wouldn´t now it either. Its almost a black box for me. Like
my car. If it has something I drive it to the dealer´s garage and be
done with it.

As long as the SSD works. I try to treat it somewhat gently.

[…]
> > > Any objections and/or comments?
> > 
> > I still only use fstrim from time to time. About once a week or after
> > lots of drive churning or removing lots of data. I also have a
> > logical volume of about 20 GiB that I keep free for most of the
> > time. And other filesystem are quite full, but there is also some
> > little free space of about 20-30 GiB together. So it should be about
> > 40-50 GiB free most of the time.
> 
> I'm curious. If your filesystem supports trim (i.e. ext4 and btrfs), is
> there every a reason to turn off trim in the FS and use fstrim instead?

Frankly, I do not know exactly. AFAIR It has been reported here and
elsewhere that constant trimming will yield a performance penalty –
maybe thats why your ecryptfs was so slow? some stacking effect combined
with constant trimming – and might even harm some cheaper SSDs.

Thus I do batched trimming. I am not sure whether some filesystem have
been changed to some intermediate with the "discard" mount option as well.
AFAIR XFS has been enhanced to provide performant trimming in batches with
"discard" mount option. Do not know about BTRFS so far.

Regarding SSDs much seems like guess work.

> > The 300 GB Intel SSD 320 in this ThinkPad T520 is still fine after
> > about 1 year and 2-3 months. I do not see any performance
> > degradation whatsover so far. Last time I looked also SMART data
> > looked fine, but I have not much experience with SMART on SSDs so
> > far.
> 
> My experience and what I read online is that SMART on SSDs doesn't seem
> to help much in many cases. I've seen too many reports of SSDs dying
> very suddenly with absolutely no warning.
> Hard drives, if you look at smart data over time, typically give you
> plenty of warning before they die (as long as you don't drop them off
> a table without parking their heads).

Hmmm, so as always its good to have backups. Plan to refresh my backup
in the next days. ;)

> If you're curious, here's the last dump of my SMART data on the SSD
> that died:

Thanks. Interesting. I do not see anything obvious that would tell me
that it might fail. But then there is no guarentee for harddisks either.

I got:

merkaba:~> smartctl -a /dev/sda
smartctl 5.43 2012-06-05 r3561 [x86_64-linux-3.5.0-rc7-tp520-toi-3.3-timekeeping+] (local build)
Copyright (C) 2002-12 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Model Family:     Intel 320 Series SSDs
Device Model:     INTEL SSDSA2CW300G3
Serial Number:    […]
LU WWN Device Id: […]
Firmware Version: 4PC10362
User Capacity:    300.069.052.416 bytes [300 GB]
Sector Size:      512 bytes logical/physical
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 4
Local Time is:    Thu Jul 19 12:28:43 2012 CEST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED
[…]

SMART Attributes Data Structure revision number: 5
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  3 Spin_Up_Time            0x0020   100   100   000    Old_age   Offline      -       0
  4 Start_Stop_Count        0x0030   100   100   000    Old_age   Offline      -       0
  5 Reallocated_Sector_Ct   0x0032   100   100   000    Old_age   Always       -       0
  9 Power_On_Hours          0x0032   100   100   000    Old_age   Always       -       2443
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always       -       1263
170 Reserve_Block_Count     0x0033   100   100   010    Pre-fail  Always       -       0
171 Program_Fail_Count      0x0032   100   100   000    Old_age   Always       -       0
172 Erase_Fail_Count        0x0032   100   100   000    Old_age   Always       -       169
183 Runtime_Bad_Block       0x0030   100   100   000    Old_age   Offline      -       0
184 End-to-End_Error        0x0032   100   100   090    Old_age   Always       -       0
187 Reported_Uncorrect      0x0032   100   100   000    Old_age   Always       -       0
192 Unsafe_Shutdown_Count   0x0032   100   100   000    Old_age   Always       -       120
199 UDMA_CRC_Error_Count    0x0030   100   100   000    Old_age   Offline      -       0
225 Host_Writes_32MiB       0x0032   100   100   000    Old_age   Always       -       127984
226 Workld_Media_Wear_Indic 0x0032   100   100   000    Old_age   Always       -       314
227 Workld_Host_Reads_Perc  0x0032   100   100   000    Old_age   Always       -       61
228 Workload_Minutes        0x0032   100   100   000    Old_age   Always       -       146593
232 Available_Reservd_Space 0x0033   100   100   010    Pre-fail  Always       -       0
233 Media_Wearout_Indicator 0x0032   100   100   000    Old_age   Always       -       0
241 Host_Writes_32MiB       0x0032   100   100   000    Old_age   Always       -       127984
242 Host_Reads_32MiB        0x0032   100   100   000    Old_age   Always       -       201548

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
# 1  Vendor (0xe0)       Completed without error       00%      2443         -
# 2  Vendor (0xd8)       Completed without error       00%       271         -
# 3  Vendor (0xd8)       Completed without error       00%       271         -
# 4  Vendor (0xa8)       Completed without error       00%       324         -

0xd8 is a long test, 0xa8 is a short test. Don´t know about 0xe0. Seems
that smartctl does not know this test numbers yet.

Except for that unsafe shutdown count I do not see anything interesting in
there. Oh, that Erase fail count – so some cells already got broken? Lets
see how that was initially:

martin@merkaba:~/Computer/Merkaba> diff -u smartctl-a-2011-05-19-nach-secure-erase.txt  smartctl-a-2012-07-19.txt
--- smartctl-a-2011-05-19-nach-secure-erase.txt 2011-05-19 16:20:50.000000000 +0200
+++ smartctl-a-2011-07-19.txt   2012-07-19 12:34:22.512228427 +0200
@@ -1,15 +1,18 @@
-smartctl 5.40 2010-07-12 r3124 [x86_64-unknown-linux-gnu] (local build)
-Copyright (C) 2002-10 by Bruce Allen, http://smartmontools.sourceforge.net
+smartctl 5.43 2012-06-05 r3561 [x86_64-linux-3.5.0-rc7-tp520-toi-3.3-timekeeping+] (local build)
+Copyright (C) 2002-12 by Bruce Allen, http://smartmontools.sourceforge.net
 
 === START OF INFORMATION SECTION ===
+Model Family:     Intel 320 Series SSDs
 Device Model:     INTEL SSDSA2CW300G3
 Serial Number:    […]
-Firmware Version: 4PC10302
-User Capacity:    300,069,052,416 bytes
-Device is:        Not in smartctl database [for details use: -P showall]
+LU WWN Device Id: […]
+Firmware Version: 4PC10362
+User Capacity:    300.069.052.416 bytes [300 GB]
+Sector Size:      512 bytes logical/physical
+Device is:        In smartctl database [for details use: -P show]
 ATA Version is:   8
 ATA Standard is:  ATA-8-ACS revision 4
-Local Time is:    Thu May 19 16:20:49 2011 CEST
+Local Time is:    Thu Jul 19 12:34:22 2012 CEST
 SMART support is: Available - device has SMART capability.
 SMART support is: Enabled
 
[…]
@@ -56,29 +59,34 @@
   3 Spin_Up_Time            0x0020   100   100   000    Old_age   Offline      -       0
   4 Start_Stop_Count        0x0030   100   100   000    Old_age   Offline      -       0
   5 Reallocated_Sector_Ct   0x0032   100   100   000    Old_age   Always       -       0
-  9 Power_On_Hours          0x0032   100   100   000    Old_age   Always       -       1
- 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always       -       4
-170 Unknown_Attribute       0x0033   100   100   010    Pre-fail  Always       -       0
-171 Unknown_Attribute       0x0032   100   100   000    Old_age   Always       -       0
-172 Unknown_Attribute       0x0032   100   100   000    Old_age   Always       -       0
-184 End-to-End_Error        0x0033   100   100   090    Pre-fail  Always       -       0
+  9 Power_On_Hours          0x0032   100   100   000    Old_age   Always       -       2443
+ 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always       -       1263
+170 Reserve_Block_Count     0x0033   100   100   010    Pre-fail  Always       -       0
+171 Program_Fail_Count      0x0032   100   100   000    Old_age   Always       -       0
+172 Erase_Fail_Count        0x0032   100   100   000    Old_age   Always       -       169
+183 Runtime_Bad_Block       0x0030   100   100   000    Old_age   Offline      -       0
+184 End-to-End_Error        0x0032   100   100   090    Old_age   Always       -       0
 187 Reported_Uncorrect      0x0032   100   100   000    Old_age   Always       -       0
-192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age   Always       -       1
-225 Load_Cycle_Count        0x0032   100   100   000    Old_age   Always       -       995
-226 Load-in_Time            0x0032   100   100   000    Old_age   Always       -       2203323
-227 Torq-amp_Count          0x0032   100   100   000    Old_age   Always       -       49
-228 Power-off_Retract_Count 0x0032   100   100   000    Old_age   Always       -       12587069
+192 Unsafe_Shutdown_Count   0x0032   100   100   000    Old_age   Always       -       120
+199 UDMA_CRC_Error_Count    0x0030   100   100   000    Old_age   Offline      -       0
+225 Host_Writes_32MiB       0x0032   100   100   000    Old_age   Always       -       127984
+226 Workld_Media_Wear_Indic 0x0032   100   100   000    Old_age   Always       -       314
+227 Workld_Host_Reads_Perc  0x0032   100   100   000    Old_age   Always       -       61
+228 Workload_Minutes        0x0032   100   100   000    Old_age   Always       -       146593
 232 Available_Reservd_Space 0x0033   100   100   010    Pre-fail  Always       -       0
 233 Media_Wearout_Indicator 0x0032   100   100   000    Old_age   Always       -       0
-241 Total_LBAs_Written      0x0032   100   100   000    Old_age   Always       -       995
-242 Total_LBAs_Read         0x0032   100   100   000    Old_age   Always       -       466
+241 Host_Writes_32MiB       0x0032   100   100   000    Old_age   Always       -       127984
+242 Host_Reads_32MiB        0x0032   100   100   000    Old_age   Always       -       201549
 
 SMART Error Log Version: 1
 No Errors Logged
 
 SMART Self-test log structure revision number 1
-No self-tests have been logged.  [To run self-tests, use: smartctl -t]
-
+Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
+# 1  Vendor (0xe0)       Completed without error       00%      2443         -
+# 2  Vendor (0xd8)       Completed without error       00%       271         -
+# 3  Vendor (0xd8)       Completed without error       00%       271         -
+# 4  Vendor (0xa8)       Completed without error       00%       324         -
 
 Note: selective self-test log revision number (0) not 1 implies that no selective self-test has ever been run
 SMART Selective self-test log data structure revision number 0


Jup, erase fail count has raised. Whatever that means. I think I will
keep an eye on it.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
