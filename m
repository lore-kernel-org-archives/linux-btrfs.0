Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:34213 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751192AbaBIApt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 8 Feb 2014 19:45:49 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfsck does not fix
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <52F6A955.5020808@friedels.name>
Date: Sat, 8 Feb 2014 17:45:44 -0700
Cc: Martin Steigerwald <Martin@lichtvoll.de>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <A0A6914C-DDA5-4904-83FA-B59AA420C9C6@colorremedies.com>
References: <52C7127F.3060902@friedels.name> <0FFB7595-0A34-424C-BFC5-CCF6098A7801@colorremedies.com> <52D317CF.2070007@friedels.name> <6210673.6TYUkLGl6b@merkaba> <52DED1C2.60103@friedels.name> <52F6A955.5020808@friedels.name>
To: Hendrik Friedel <hendrik@friedels.name>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Feb 8, 2014, at 3:01 PM, Hendrik Friedel <hendrik@friedels.name> wrote:

> Hello,
> 
>> Ok.
>> I think, I do/did have some symptoms, but I cannot exclude other reasons..
>> -High Load without high cpu-usage (io was the bottleneck)
>> -Just now: transfer from one directory to the other on the same
>> subvolume (from /mnt/subvol/A/B to /mnt/subvol/A) I get 1.2MB/s instead
>> of > 60.
>> -For some of the files I even got a "no space left on device" error.
>> 
>> This is without any messages in dmesg or syslog related to btrfs.
> 
> as I don't see that I can fix this, I intend to re-create the file-system. For that, I need to remove one of the two discs from the raid/filesystem, then create a new fs on this and move the data to it (I have no spare)
> Could you please advise me, wheather this will be successful?
> 
> 
> first some Information on the filesystem:
> ----------------
> ./btrfs filesystem show /dev/sdb1
> Label: none  uuid: 989306aa-d291-4752-8477-0baf94f8c42f
>        Total devices 2 FS bytes used 3.47TiB
>        devid    1 size 2.73TiB used 1.74TiB path /dev/sdb1
>        devid    2 size 2.73TiB used 1.74TiB path /dev/sdc1

I don't understand the no spare part. You have 3.47T of data, and yet the single device size is 2.73T. There is no way to migrate 1.74T from sdc1 to sdb1 because there isn't enough space.




> 
> /btrfs subvolume list /mnt/BTRFS/Video
> ID 256 gen 226429 top level 5 path Video
> ID 1495 gen 226141 top level 5 path rsnapshot
> ID 4444 gen 226429 top level 256 path Snapshot
> ID 5845 gen 226375 top level 5 path backups
> 
> btrfs fi df /mnt/BTRFS/Video/
> Data, RAID0: total=3.48TB, used=3.47TB
> System, RAID1: total=32.00MB, used=260.00KB
> Metadata, RAID1: total=4.49GB, used=3.85GB
> --------------------
> 
> What I did already yesterday was:
> 
> btrfs device delete /dev/sdc1 /mnt/BTRFS/rsnapshot/
> btrfs device delete /dev/sdc1 /mnt/BTRFS/backups/
> btrfs device delete /dev/sdc1 /mnt/BTRFS/Video/
> btrfs filesystem balance start /mnt/BTRFS/Video/

I don't understand this sequence because I don't know what you've mounted where, but in any case maybe it's a bug that you're not getting errors for each of these commands because  you can't delete sdc1 from a raid0 volume. You'd first have to convert the data, metadata, and system profiles to single (metadata can be set to dup). And then you'd be able to delete a device so long as there's room on remaining devices, which you don't have.


> next, I'm doing the balance for the subvolume /mnt/BTRFS/backups

You told us above  you deleted that subvolume. So how are you balancing it? And also, balance applies to a mountpoint, and even if you mount a subvolume to that mountpoint, the whole file system is balanced. Not just the mounted subvolume.


> In parallel, I try to delete /mnt/BTRFS/rsnapshot, but it fails:
>  btrfs subvolume delete  /mnt/BTRFS/rsnapshot/
>  Delete subvolume '/mnt/BTRFS/rsnapshot'
>  ERROR: cannot delete '/mnt/BTRFS/rsnapshot' - Inappropriate ioctl
>  for  device
> 
> Why's that?
> But even more: How do I free sdc1 now?!


Well I'm pretty confused because again, I can't tell if your paths refer to subvolumes or if they refer to mount points. The balance and device delete commands all refer to a mount point, which is the path returned by the df command. The subvolume delete command needs a path to subvolume that starts with the mount point.


Chris Murphy