Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:61059 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733Ab3AaBDA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jan 2013 20:03:00 -0500
Received: by mail-ee0-f48.google.com with SMTP id t10so1198685eei.35
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Jan 2013 17:02:58 -0800 (PST)
Message-ID: <5109C2A8.7090005@statystyka.net>
Date: Thu, 31 Jan 2013 02:02:32 +0100
From: Adam Ryczkowski <adam.ryczkowski@statystyka.net>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Poor performance of btrfs. Suspected unidentified btrfs housekeeping
 process which writes a lot
References: <510934E6.7080302@statystyka.net> <6F302998-3D6E-4E91-9DDA-C475344B51BF@colorremedies.com>
In-Reply-To: <6F302998-3D6E-4E91-9DDA-C475344B51BF@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Than you, Chris, for your time.


On 2013-01-31 00:58, Chris Murphy wrote:
> On Jan 30, 2013, at 7:57 AM, Adam Ryczkowski<adam.ryczkowski@statystyka.net>  wrote:
>> I suspect it has something to do with snapshots I make for backup. I have 35 of them, and I ask bedup to find duplicates across all subvolumes.
> Assuming most files do have identical duplicates, implies the same file in all 35 subvolumes is actually in the same physical location; it differs only in subvol reference. But it's not btrfs that determines the "duplicate" vs "unique" state of those 35 file instances, but unison. The fs still must send all 35x instances for the state to be determined, as if they were unique files.
I'm sorry if I didn't put my question more clearly. I tried to write, 
that the problem is not specific to the unison; I am able to reproduce 
the problem using other means of reading contents of the file. I tried 
'cat' many small files, and previewing under Midnight Commander some 
large ones. I didn't take precise measurements, but I can tell, that 
reading 500 50-byte files (ca. 25kB of data) took way longer that 
reading one 3MB file, so I suspect the problem is with metadata access 
times rather than with data.

I am aware, that reading 1MB distributed in small files takes longer 
than 1MB of sequential reading. The problem is that _suddenly_ this 
speed  got at least 20 times longer than usual. And from what iotop and 
systat told me, the harddrives were busy _writing_ something, not 
_reading_! The amount of time I wait for scanning the whole harddrive 
with unison is comparable with time that full balance takes.

Anyway, I synchronize only the "working copy" part of my file system. 
All the backup subvolumes sit in a separate path, not seen by the unison.
Moreover, once I wait long enough for the system to finish scanning the 
file system, file access speeds are back to normal, even after I drop 
read cache or even reboot the system. It is only after making another 
snapshot, when the problems recurs.
> Another thing, I'd expect this to scale very poorly if the 35 subvolumes contain any appreciable uniqueness, because searches can't be done in parallel. So the more subvolumes you add, the more disk contention you get, but also enormous amounts of latency as possibly 35 locations on the disk are being searched if they happen to be unique.

*The severity of my problem is proportional to time*. It happens 
immediately after making snaphot, and persists for each file until I try 
to read its contents. Than, even after the reboot, timing is back to 
normal. With my limited knowledge about the internals of btrfs I 
suspect, that the bedup has messed my metadata somehow. Maybe I should 
balance only the metadata part (if that is possible at all)?
> So in either case "duplicate" vs "unique" you have a problem, just different kinds. And as the storage grows, it increasingly encounters both problems at the same time. Small problem. What size are the files?
>
> And that's on a bare drive before you went and did this:
>
>> My filesystem /dev/vg-adama-docs/lv-adama-docs is 372GB in size, and is a quite complex setup:
>> It is based on logical volume (LVM2), which has a single physical volume made by dm-crypt device /dev/dm-1, which subsequently sits on top of /dev/md1 linux raid 6, which is built with 4 identical 186GB GPT partitions on each of my SATA 3TB hard drives.
> Why are you using raid6 for four disks, instead of raid10?
Because I plan to add another 4 in the future. It's way easier to add 
another disk to the array, than to change the RAID layout.
> What's the chunk size for the raid 6? What's the btrfs leaf size? What's the dedup chunk size?
I'll tell you tomorrow, but I hardly think that the misalignment could 
be any problem here. As I said, everything was fine and the problem 
didn't appear in gradual fashion.
> Why are you using LVM at all, while the /dev/dm-1 is the same size as the LV? You say the btrfs volume on LV is on dm-1 which means they're all the same size, obviating the need for LVM in this case entirely.
Yes, I agree, that at the moment I don't need it. But when partition 
sits on logical volume I keep the option to extend the filesystem, when 
I the need comes.
My current needs are more complex, I don't keep all the date in the same 
redundancy and security level. It is also hard to tell in advance the 
relative sizes of each combination of redundancy and security levels. So 
I allocate only as much space on the GPT partitions as I immediately 
need, and in the future, when need comes, I can relatively easily make 
more partitions, arrange them in the appropriate raid/mdcrypt 
combination, and expand the filesystem that ran out space.

I am aware, that this setup is very complex. I can say, that my 
application is not life-critical, and this complexity serves me well on 
another Linux server, which I am using over 5 years (without the btrfs, 
of course).


> Chris Murphy
>


-- 

Adam Ryczkowski
+48505919892 <callto:+48505919892>
Skype:sisteczko <skype:sisteczko>

