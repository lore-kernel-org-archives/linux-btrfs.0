Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:32974 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941864AbcLVS2l (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Dec 2016 13:28:41 -0500
Received: by mail-it0-f68.google.com with SMTP id c20so21654996itb.0
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Dec 2016 10:28:41 -0800 (PST)
Subject: Re: btrfs_log2phys: cannot lookup extent mapping
To: Adam Borowski <kilobyte@angband.pl>, linux-btrfs@vger.kernel.org
References: <89be6fee-5b18-7a9d-11ea-85abeab28022@ece.wisc.edu>
 <pan$14679$e5d5bc21$812abe03$ef75194d@cox.net>
 <4e2fcf15-5af4-54b0-f7bb-46518b9bb5a4@ece.wisc.edu>
 <pan$67936$e25a272c$77926cea$931807ed@cox.net>
 <20161222151425.ecryyvnz2feaygrr@angband.pl>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <67d0fb6f-a4d9-5a2a-d5b9-ccdfd3fb64f6@gmail.com>
Date: Thu, 22 Dec 2016 13:28:37 -0500
MIME-Version: 1.0
In-Reply-To: <20161222151425.ecryyvnz2feaygrr@angband.pl>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-12-22 10:14, Adam Borowski wrote:
> On Thu, Dec 22, 2016 at 10:11:35AM +0000, Duncan wrote:
>> Given the maturing-but-not-yet-fully-stable-and-mature state of btrfs
>> today, being no further from a usable current backup than the data you're
>> willing to lose, at least worst-case, remains an even stronger
>> recommendation than it is on fully mature and stable filesystem, kernel
>> and hardware.
>
> The usual rant about backups which I snipped is 110%[1] right, however I
> disagree that btrfs is worse than other filesystems for data safety.
>
> On one hand, btrfs:
> * is buggy
> * fails the KISS principle to a ridiculous degree
> * lacks logic people take for granted (especially on RAID)
> On the other, other filesystems:
> * suffer from silent data loss every time the disk doesn't notice an error!
>   Allowing silent data loss fails the most basic requirement for a
>   filesystem.  Btrfs at least makes that loss noisy (single) so you can
>   recover from backups, or handles it (redundant RAID).
No, allowing silent data loss fails the most basic requirement for a 
_storage system_.  A filesystem is generally a key component in a data 
storage system, but people regularly conflate the two as having the same 
meaning, which is absolutely wrong.  Most traditional filesystems are 
designed under the assumption that if someone cares about at-rest data 
integrity, they will purchase hardware to ensure at-rest data integrity. 
  This is a perfectly reasonable stance, especially considering that 
ensuring at-rest data integrity is _hard_ (BTRFS is better at it than 
most filesystems, but it still can't do it to the degree that most of 
the people who actually require it need).  A filesystem's job is 
traditionally to organize things, not verify them or provide redundancy.
> * don't have frequent snapshots to save you from human error (including
>   other software)
> * make backups time-costly.  rsync needs to at least stat everything, on a
>   populated disk that's often half an hour or more, on btrfs a no-op backup
>   takes O(1).
These two points I agree on, despite me not using snapshots or send/receive.
>
> So sorry, but I had enough woe with those "fully mature and stable"
> filesystems.  Thus I use btrfs pretty much everywhere, backing up my crap
> every 24 hours, important bits every 3 hours.
I use BTRFS pretty much everywhere too.  I've also had more catastrophic 
failures from BTRFS than any other filesystem I've used except FAT (NTFS 
is a close third).  I've also recovered sanely without needing a new 
filesystem and a full data restoration on ext4, FAT, and even XFS more 
than I have on BTRFS (ext4 and FAT are well enough documented that I can 
put a broken filesystem back together by hand if needed (and have done 
so on multiple occasions)).

That said, the two of us and most of the other list regulars have a much 
better understanding of the involved risks than a significant majority 
of 'normal' users, partly because we have done our research regarding 
this, and partly because we're watching the list regularly.  For us, the 
risk is a calculated one, for anyone who's just trying it out for 
laughs, or happened to get it because the distro they picked happened to 
use it by default though, it's a very much unknown risk.

Ignoring the checksumming, COW, and multi-device support in BTRFS, 
pretty much everything else wins in terms of reliability by a pretty 
significant margin (and in terms of performance too, even mounted with 
no checksumming and no COW for everything but metadata, ext4 and XFS 
still beat the tar out of BTRFS in terms of performance).  BTRFS crashes 
more, and fails harder than any other first-class (listed on the main 
'Filesystems' menu, not in 'Misc Filesystems') filesystem in the 
mainline Linux kernel right now.  For it to be reliable, the devices 
need to be monitored, the filesystems need to be curated, and you 
absolutely have to understand the risks.  Given this, for a vast 
majority of users, BTRFS _is_ worse on average for data safety than 
almost any other filesystem in the kernel.
