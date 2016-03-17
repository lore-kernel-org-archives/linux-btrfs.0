Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from know-smtprelay-omc-6.server.virginmedia.net ([80.0.253.70]:60435
	"EHLO know-smtprelay-omc-6.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031050AbcCQVI1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Mar 2016 17:08:27 -0400
Subject: Re: Snapshots slowing system
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, linux-btrfs@vger.kernel.org
References: <201603142303.u2EN3qo3011695@phoenix.vfire>
 <pan$a0d0a$9f23433a$f19e4b84$b275dc3f@cox.net>
 <56E88CB2.6020300@petezilla.co.uk> <56E945E9.1050005@gmail.com>
From: Pete <pete@petezilla.co.uk>
Message-ID: <56EB1CC7.2000602@petezilla.co.uk>
Date: Thu, 17 Mar 2016 21:08:23 +0000
MIME-Version: 1.0
In-Reply-To: <56E945E9.1050005@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/16/2016 11:39 AM, Austin S. Hemmelgarn wrote:

>> I thought though that btrfs fi defrag <name> would only defrag the one
>> file or directory?
> It does, it's just not recursive unless you tell it to be.

Hmm.  That shows when I last used it.  Last time I used it the '-r'
option did not exist.  So I set and forgot 'autodefrag'.


>>
>> btrfs fi defrag /srv/photos/
>> Is considerably slower, it is still running.  Disk light is on solid.
>> Processes kworker and btrfs-transacti are pretty busy according to iotop.
> If you have a lot of items in /srv/photos/ (be it either lots of
> individual files, or lots of directories at the top level), then this is
> normal, if not, then you may have found a bug.

20 files.  15 directories.  A lot of files under this directory but
recursive NOT set.

Hmm.  Comments on ssd s set me googling.  Don't normally touch smartctl

root@phoenix:~# smartctl --attributes /dev/sdc

<snip>

184 End-to-End_Error        0x0032   098   098   099    Old_age   Always
  FAILING_NOW 2

<snip>

also:
  1 Raw_Read_Error_Rate     0x000f   120   099   006    Pre-fail  Always
      -       241052216

That figure seems to be on the move.  On /dev/sdb (the other half of my
hdd raid1 btrfs it is zero).  I presume zero means either 'no errors,
happy days' or 'not supported'.

Hmm.  Is this bad and/or possibly the smoking gun for slowness?  I will
keep an eye on the number to see if it changes.

OK, full output:
root@phoenix:~# smartctl --attributes /dev/sdc
smartctl 5.43 2012-06-30 r3573 [x86_64-linux-4.0.4] (local build)
Copyright (C) 2002-12 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF READ SMART DATA SECTION ===
SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   120   099   006    Pre-fail  Always
      -       241159856
  3 Spin_Up_Time            0x0003   093   093   000    Pre-fail  Always
      -       0
  4 Start_Stop_Count        0x0032   100   100   020    Old_age   Always
      -       83
  5 Reallocated_Sector_Ct   0x0033   100   100   010    Pre-fail  Always
      -       0
  7 Seek_Error_Rate         0x000f   073   060   030    Pre-fail  Always
      -       56166570022
  9 Power_On_Hours          0x0032   075   075   000    Old_age   Always
      -       22098
 10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail  Always
      -       0
 12 Power_Cycle_Count       0x0032   100   100   020    Old_age   Always
      -       83
183 Runtime_Bad_Block       0x0032   100   100   000    Old_age   Always
      -       0
184 End-to-End_Error        0x0032   098   098   099    Old_age   Always
  FAILING_NOW 2
187 Reported_Uncorrect      0x0032   100   100   000    Old_age   Always
      -       0
188 Command_Timeout         0x0032   100   099   000    Old_age   Always
      -       8590065669
189 High_Fly_Writes         0x003a   095   095   000    Old_age   Always
      -       5
190 Airflow_Temperature_Cel 0x0022   066   063   045    Old_age   Always
      -       34 (Min/Max 30/34)
191 G-Sense_Error_Rate      0x0032   100   100   000    Old_age   Always
      -       0
192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age   Always
      -       27
193 Load_Cycle_Count        0x0032   001   001   000    Old_age   Always
      -       287836
194 Temperature_Celsius     0x0022   034   040   000    Old_age   Always
      -       34 (0 14 0 0 0)
197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always
      -       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Always
      -       0
240 Head_Flying_Hours       0x0000   100   253   000    Old_age
Offline      -       281032595099550
241 Total_LBAs_Written      0x0000   100   253   000    Old_age
Offline      -       75393744072
242 Total_LBAs_Read         0x0000   100   253   000    Old_age
Offline      -       115340399121

OK, head flying hours explains it, drive is over 32 billion years old...

As I am slowly producing this post raw_read_error_rate is now at
241507192.  But I did set  smartctl -t long /dev/sdc in motion if that
is at all relevent.


>>
>> Slackware uses lilo so I need a separate /boot with something that is
>> supported by lilo.
> I would like to point out that just because the distribution prefers one
> package doesn't mean you can't use another, it's just not quite as easy.
>  It's worth noting that I do similarly to Duncan in this respect though,
> although I provisioned 512MiB when I set things up (and stuck the BIOS
> boot partition (because I use GPT on everything these days) in the
> unaligned slack space between the partition table and /boot).  It also
> has the advantage that I can fall back to old versions of the kernel and
> initrd if need be when an upgrade fails to boot for some reason.

Thanks.  I know that.  Have dallied with Grub and Grub2 but when it
works well lilo is nice and simple.  My 'maintenance' partition plan is
to give me something more powerful than a rescue disk if things go
south.  Bit frustrating the time I found that btrfs-tools was well
behind on the maintenance partition.  At least I could go online and
fix.  Rescue CDs are not helpful there.


>>
>> <snip>
>>
>>> If I had 500 GiB SSDs like the one you're getting, I could put the media
>>> partition on SSDs and be rid of the spinning rust entirely.  But I seem
>>> to keep finding higher priorities for the money I'd spend on a pair of
>>> them...
>>
>>
>> I'm getting one, not two, so the system is raid0.  Data is more
>> important (and backed up).
> If you don't need the full terabyte of space, I would seriously suggest
> using raid1 instead of raid0.  If you're using SSD's, then you won't get
> much performance gain from BTRFS raid0 (because the I/O dispatching is
> not particularly smart), and it also makes it more likely that you will
> need to rebuild from scratch.

Confused.  I'm getting one SSD which I intend to use raid0.  Seems to me
to make no sense to split it in two and put both sides of raid1 on one
disk and I reasonably think that you are not suggesting that.  Or are
you assuming that I'm getting two disks?  Or are you saying that buying
a second SSD disk is strongly advised?  (bearing in mind that it looks
like I might need another hdd if the smart field above is worth worrying
about).

Pete


