Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-eopbgr00044.outbound.protection.outlook.com ([40.107.0.44]:47376
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728312AbeIPSAx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 16 Sep 2018 14:00:53 -0400
Subject: Re: Move data and mount point to subvolume
To: Rory Campbell-Lange <rory@campbell-lange.net>, linux-btrfs@vger.kernel.org
References: <20180916111445.lqwjqvq4aeiwglmm@campbell-lange.net>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <b6d821fb-334f-8145-27e3-28a8cfa99940@mendix.com>
Date: Sun, 16 Sep 2018 14:37:53 +0200
MIME-Version: 1.0
In-Reply-To: <20180916111445.lqwjqvq4aeiwglmm@campbell-lange.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/16/2018 01:14 PM, Rory Campbell-Lange wrote:
> Hi
> 
> We have a backup machine that has been happily running its backup
> partitions on btrfs (on top of a luks encrypted disks) for a few years.
> 
> Our backup partition is on /bkp which is a top level subvolume. 
>     Data, RAID1: total=2.52TiB, used=1.36TiB
> There are no other subvolumes.
> 
> We have /bkp with /bkp/backup in it. We would like to mount /bkp/backup
> at /bkp instead. Note that /bkp/backup has a lot of hardlinked files.
> 
> I guess I could do 
> 
>     cd /bkp/backup
>     mv * ../
>     rmdir backup

Doing it the other way around is easier, since you don't have to think
about hardlinked/reflinked/etc/anything while copying data:

btrfs sub snap /bkp /bkp/backup

Now you have the exact identical thing in /backup, and you can start
throwing away everything outside of /backup.

To reduce chance for accidental errors, you can snapshot with -r to make
the new /backup read-only first. Then after removing everything outside
it, make it rw again with:

btrfs property set -ts /bkp/backup ro false

> But would it also be possible to do something like
> 
>     cd /bkp
>     btrfs subvol create backup-subvol
>     mv /bkp/backup/* /bkp/backup-subvol
>     ... then mount /bkp/backup-subvol at /bkp
> 
> Would this second approach work, and preserve hardlinks?
> 
> The machine is btrfs-progs v4.7.3 Linux 4.9.0-8-amd64 on Debian. The
> coreutils version is 8.26-3.

Another note: since it seems you have about 100% more data space
allocated (set apart for data purpose) than you're actually using, or in
other words, having the 1GiB chunks on average just for 50% filled...

   Data, RAID1: total=2.52TiB, used=1.36TiB

...in combination with using Linux 4.9, I suspect there's also 'ssd' in
your mount options (not in fstab, but enabled by btrfs while mounting,
see /proc/mounts or mount command output)?

If so, this is a nice starting point for more info about what might also
be happening to your filesystem:
https://www.spinics.net/lists/linux-btrfs/msg70622.html

-- 
Hans van Kranenburg
