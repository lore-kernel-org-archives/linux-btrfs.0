Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:50323 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbaBHWCE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 8 Feb 2014 17:02:04 -0500
Message-ID: <52F6A955.5020808@friedels.name>
Date: Sat, 08 Feb 2014 23:01:57 +0100
From: Hendrik Friedel <hendrik@friedels.name>
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>
CC: Chris Murphy <lists@colorremedies.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfsck does not fix
References: <52C7127F.3060902@friedels.name> <0FFB7595-0A34-424C-BFC5-CCF6098A7801@colorremedies.com> <52D317CF.2070007@friedels.name> <6210673.6TYUkLGl6b@merkaba> <52DED1C2.60103@friedels.name>
In-Reply-To: <52DED1C2.60103@friedels.name>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

> Ok.
> I think, I do/did have some symptoms, but I cannot exclude other reasons..
> -High Load without high cpu-usage (io was the bottleneck)
> -Just now: transfer from one directory to the other on the same
> subvolume (from /mnt/subvol/A/B to /mnt/subvol/A) I get 1.2MB/s instead
> of > 60.
> -For some of the files I even got a "no space left on device" error.
>
> This is without any messages in dmesg or syslog related to btrfs.

as I don't see that I can fix this, I intend to re-create the 
file-system. For that, I need to remove one of the two discs from the 
raid/filesystem, then create a new fs on this and move the data to it (I 
have no spare)
Could you please advise me, wheather this will be successful?


first some Information on the filesystem:
----------------
./btrfs filesystem show /dev/sdb1
Label: none  uuid: 989306aa-d291-4752-8477-0baf94f8c42f
         Total devices 2 FS bytes used 3.47TiB
         devid    1 size 2.73TiB used 1.74TiB path /dev/sdb1
         devid    2 size 2.73TiB used 1.74TiB path /dev/sdc1

/btrfs subvolume list /mnt/BTRFS/Video
ID 256 gen 226429 top level 5 path Video
ID 1495 gen 226141 top level 5 path rsnapshot
ID 4444 gen 226429 top level 256 path Snapshot
ID 5845 gen 226375 top level 5 path backups

btrfs fi df /mnt/BTRFS/Video/
Data, RAID0: total=3.48TB, used=3.47TB
System, RAID1: total=32.00MB, used=260.00KB
Metadata, RAID1: total=4.49GB, used=3.85GB
--------------------

What I did already yesterday was:

  btrfs device delete /dev/sdc1 /mnt/BTRFS/rsnapshot/
  btrfs device delete /dev/sdc1 /mnt/BTRFS/backups/
  btrfs device delete /dev/sdc1 /mnt/BTRFS/Video/
  btrfs filesystem balance start /mnt/BTRFS/Video/

next, I'm doing the balance for the subvolume /mnt/BTRFS/backups

In parallel, I try to delete /mnt/BTRFS/rsnapshot, but it fails:
   btrfs subvolume delete  /mnt/BTRFS/rsnapshot/
   Delete subvolume '/mnt/BTRFS/rsnapshot'
   ERROR: cannot delete '/mnt/BTRFS/rsnapshot' - Inappropriate ioctl
   for  device

Why's that?
But even more: How do I free sdc1 now?!

Greetings,
Hendrik
