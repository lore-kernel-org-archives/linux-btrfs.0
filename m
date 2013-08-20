Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:59977 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab3HTJoP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Aug 2013 05:44:15 -0400
Message-ID: <52133A6B.9010407@giantdisaster.de>
Date: Tue, 20 Aug 2013 11:44:11 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Stuart Pook <slp644161@pook.it>
CC: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: uncorrectable errors after btrfs replace
References: <S1753593Ab3HRQvp/20130818165145Z+301@vger.kernel.org> <52111C9D.3090704@pook.it> <73B6CA35-5279-44D6-A427-46985C3F554C@colorremedies.com> <52114C4A.6000003@pook.it>
In-Reply-To: <52114C4A.6000003@pook.it>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 19 Aug 2013 00:35:54 +0200, Stuart Pook wrote:
> hi Chris
> 
> thanks for your reply. I was unable to save the filesystem. Even after
> deleting all but 4Gb I still had too many errors so I just reformated
> the device.  I'm glad that it was my backups and not my data.
> 
> On 18/08/13 23:43, Chris Murphy wrote:
>> On Aug 18, 2013, at 1:12 PM, Stuart Pook <slp644161@pook.it> wrote:
>>
>>> 6  btrfs filesystem resize 580g .
>>
>> You first shrank a 2TB btrfs file system on dmcrypt device to 590GB.
>> But then you didn't resize the dm device or the partition?
> 
> no, I had no need to resize the dm device or partition.  I just read
> that when doing a replace the new device must be no smaller than the old
> device.  So I shrunk the old device using "btrfs filesystem resize". 
> Once the resize worked I was able to do the replace but I didn't try to
> replace before resizing.
> 
> This is what btrfs(1) says on Debian: "The targetdev needs to be same
> size or larger than the srcdev."  I may be confused here.
> 
>>> 9  time btrfs balance start -musage=1 -dusage=1 . && time btrfs
>>> filesystem resize 580g .
> 
> I was surprised that the resize to 580Gb didn't work so I tried a
> magical rebalance before doing the resize to 580 again.  It still didn't
> work (not enough space) but a resize to 590 Gb did.
> 
>>> 10  time  btrfs filesystem resize 590g .
> 
> this worked
> 
>> You followed the resize of the fs, but not the underlying devices,
>> with a balance, then resized it two more times?
> 
> The resize to 580 didn't work. So I did a balance.  The resize to 580
> still didn't work so I resized to 590.
> 
>> This is weird, but also makes the sequence difficult to follow.
> 
>>> 13  time btrfs replace start  /dev/dm-11 /dev/dm-12 -B /disks/backups
>>> 14  time btrfs replace start  /dev/dm-11 /dev/dm-12-B /disks/backups
> 
>> Why is this command repeated? What's with the numbering system that
>> skips numbers?
> 
> The command is repeated because I cancelled it my mistake by setting the
> filesystem to readonly.  I'm not sure if I restarted it by rerunning the
> replace or just by remounting the filesystem readwrite in another window.
> 
> I'll put all of the commands at the end of this list.
> 
>>> Aug 18 12:28:17 kooka kernel: [54139.448029] ata10: SATA link up1.5
>>> Gbps (SStatus 113 SControl 310)
>> Bad connection so libata is dropping the link from 3 Gbps to1.5Gbps.
>>> 199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age
>>> Always - 12080
>>
>> This confirms that both ends of the cable are sensing communication
>> problems between drive and controller. The cable needs to be
>> replaced, likely it's the connector not the cable itself.
> 
> I think that I should stop using my SATA dock with the SATA ports on my
> motherboard which are probably not designed to be hot plugged.
> 
>>> I guess that /disks/backup is mostly dead and that I should just
>>> reformat it.  What do you think?
>>
>> Well I think I'd try to simplify this drastically and see if you've
>> got a reproducing bug.
> 
> I ran a badblocks scan on the raw device (not the luks device) and
> didn't get any errors.
> 
>> The steps you've got I find mostly incoherent, so I can't try to do
>> what you did to see if it's reproducible.
> 
> yes, this was the first time I've tried this.  And just to make this
> more difficult some commands were typed in a different window.
>  
>>> Next time I'll watch /var/log/syslog but I would have preferred
>>> that "btrfs replace" stop when getting errors.
>>
>> The errors should be self correcting, but the mere fact they're
>> happening means that some errors could be occurring but aren't
>> detected. If the data is corrupting in-transit, but the drive or
>> controller didn't report a problem, then btrfs has no way of knowing
>> it was written incorrectly.
> 
> The data was written to the WD-Blue (640Gb) disk and then copied off
> it.  The only errors I saw concerned the WB-Blue.  If the errors were
> data corruption on writing or reading the WD-Blue then I would have
> thought that the checksums would have told me that there was something
> wrong.  btrfs didn't give me an IO error until I started to read the
> files when the data was on a final disk.
> 
> Does "btrfs replace" check the ckecksums as it reads the data from the
> disk that is being replaced?
> 
> Just to be clear. This is the series of btrfs replace I did:
> 
> backups : HD204UI -> WD-Blue
> /mnt : WD-Black -> HD204UI
> backups : WD-Blue -> WD-Black
> 
> I guess that my backups were corrupted was they were written to or read
> from the WD-Blue. Wouldn't the checksums have detected this problem
> before the data was written to the WD-Black?
> 
>> There's only so much software can do to overcome blatant hardware
>> problems.
> 
> I was hoping to be informed of them
> 
>> But, it seems unlikely such a high percent of errors would go
>> undetected to result in so many uncorrectable errors, so there may be
>> user error here along with a bug.
> 
> I'm not sure how I could have done it better. Does "btrfs replace" check
> that the data is correctly written to the new disk before it is removed
> from the old disk?  Should I have used the 2 disks to make a RAID-1 and
> then done a scrub before removing the old disk?
> 
> Here is the complete list of commands I made in the main terminal
> 
>     1  cd /disks/backups/
>     2  btrfs filesystem df
>     3  btrfs filesystem df  ,
>     4*
>     5  btrfs filesystem df  .
>     6  btrfs filesystem resize 580g .
>     7  date
>     8  btrfs filesystem df  .
>     9  time btrfs  balance start -musage=1 -dusage=1 . && time  btrfs
> filesystem resize 580g .
>    10  time  btrfs filesystem resize 590g .
>    11  btrfs filesystem show
>    12  cryptsetup luksOpen /dev/sdd2 640Gb
>    13  time btrfs replace start  /dev/dm-11 /dev/dm-12 -B /disks/backups
>    14  time btrfs replace start  /dev/dm-11 /dev/dm-12 -B /disks/backups
>    15  cd /
>    16  btrfs filesystem show
>    17  btrfs filesystem show
>    18  cryptsetup remove _dev_sdc2
>    19  fdisk /dev/sdc
>    20  fdisk /dev/sdc
>    21  fdisk -c /dev/sdc
>    22  fdisk -c=dos /dev/sdc
>    23  fdisk /dev/sdc
>    24  fdisk -c=dos /dev/sdc
>    25  l /mnt
>    26  mount /dev/sdb1 /mnt
>    27  l /mnt
>    28  btrfs subv list /mnt
>    29  btrfs filesystem show
>    30  #time btrfs replace start  /dev/dm-11 /dev/dm-12 -B /disks/backups
>    31  fdisk -l /dev/sdc
>    32  time btrfs replace start  /dev/sdb1  /dev/sdc2 -B /mnt
>    33  btrfs filesystem show
>    34  btrfs filesystem label  /dev/dm-12
>    35   btrfs filesystem label /disks/backups
>    36   btrfs filesystem label /disks/backups backups2Tb
>    37  btrfs filesystem show
>    38   btrfs filesystem label /disks/backups
>    39  cryptsetup luksFormat /dev/sdb2
>    40  cryptsetup luksAddKey /dev/sdb2
>    41  cryptsetup open  /dev/sdb2 newbackups
>    42  l /dev/mapper/newbackups
>    43  time btrfs replace start  /dev/dm-12  /dev/dm-11 -B /disks/backups
>    44  btrfs filesystem show
>    45  cryptsetup status 640Gb
>    46  cryptsetup remove 640Gb
>    47  btrfs filesystem show
>    48  btrfs filesystem df /disks/backups/
>    49  btrfs filesystem resize max /disks/backups/
>    50  btrfs filesystem df /disks/backups/
>    51  btrfs filesystem show
>    52  vi /etc/cron.daily/storebackup
>    53  vi /etc/cron.daily/stuart
>    54  /etc/local/backups
>    55  mount
>    56  mount -o remount,rw /disks/backups/
>    57  time  btrfs  scrub start -Bd /disks/backups
>    58  smartctl -a   /dev/sdb
>    59  smartctl -a   /dev/sdc
>    60  smartctl -a   /dev/sdd
>    61  smartctl -t short   /dev/sdd
>    62  sleep 2m;  smartctl -a   /dev/sdd
>    63  history > /tmp/root.commands
> 
> Which disk is which?
> 
> WD-Black ata-WDC_WD2002FAEX-007BA0_WD-WCAY00589823 -> ../../sdb
> HD204UI ata-ST2000DL004_HD204UI_S2H7J90C549571 -> ../../sdc
> WD-Blue  ata-WDC_WD6400AAKS-00A7B2_WD-WMASY2546840 -> ../../sdd
> 
> please let me know if I can be any clearer, thanks
> Stuart

Do you still have the kernel log files around that had been written
while you ran the replace procedure? /var/log/messages*. Could you share
these files (via personal mail if the files are too huge).

