From: Hullen@t-online.de (Helmut Hullen)
Subject: Re: kernel 3.3.4 damages filesystem (?)
Date: 08 May 2012 09:39:00 +0200
Message-ID: <C8TEDWt9CXB@helmut.hullen.de>
References: <201205080007.51704.Martin@lichtvoll.de>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201205080007.51704.Martin@lichtvoll.de>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Martin,

Du meintest am 08.05.12:

>> No - since some years I use a kind of outsourced backup. A copy of
>> all   data is on a bundle of disks somewhere in the neighbourhood.
>> As mentionend: the data isn't business critical, it's just "nice to
>> have". It's not worth something like raid1 or so (with twice the
>> costs of a non raid solution).

> Thats not true when you use BTRFS RAID1 with three disks. BTRFS will
> only store each chunk on two different drives then, not on all three.
> Such it is not twice the cost, but given all three drives have the
> same capacity about one and a half times the cost.

> Consider the time to recover the files from the outsourced backup.
> Maybe it does make up the money you would have to spend for one
> additional harddisk.

I have considered it, many times. And the result is unchanged: no RAID1.  
It doesn't replace a real backup.

> Anyway, I agree with the others responding to your post that this one
> harddisk died and I do not see a kernel version related issue. Any
> striped RAID 0 would have failed in that case.

Yes - I had written yesterday that the disk is dead. One of three disks.  
I'm on the way restoring (from backup) the three disks.

> And you can use three BTRFS filesystems the same way as three Ext4
> filesystems if you prefer such a setup if the time spent for
> restoring the backup does not make up the cost for one additional
> disk for you.

But where's the gain? If a disk fails I have a lot of tools for  
repairing an ext2/3/4 system.

Viele Gruesse!
Helmut
