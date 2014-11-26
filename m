Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-34-i2.italiaonline.it ([212.48.25.206]:52489 "EHLO
	smtp-34.italiaonline.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750856AbaKZRSR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Nov 2014 12:18:17 -0500
Message-ID: <54760B89.3050604@inwind.it>
Date: Wed, 26 Nov 2014 18:19:05 +0100
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Zygo Blaxell <zblaxell@furryterror.org>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS messes up snapshot LV with origin
References: <FC0BA13C-21E3-44DD-A87C-4BEAE4FBF9EA@colorremedies.com> <546BA96D.4050805@ubuntu.com> <2A57F99C-80AA-4FD4-AA41-57F02AD4E1A2@colorremedies.com> <546CB531.2060509@ubuntu.com> <20141121042814.GR17395@hungrycats.org> <5470C92E.1070607@inwind.it> <20141123001927.GO17380@hungrycats.org> <5474AF87.6090702@inwind.it> <20141125202948.GP17380@hungrycats.org> <5474FBD9.5070709@inwind.it> <20141125222126.GQ17380@hungrycats.org>
In-Reply-To: <20141125222126.GQ17380@hungrycats.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/25/2014 11:21 PM, Zygo Blaxell wrote:
>> > However I still doesn't understood why you want btrfs-w/multiple disk over LVM ?
> I want to split a few disks into partitions, but I want to create,
> move, and resize the partitions from time to time.  Only LVM can do
> that without taking the machine down, reducing RAID integrity levels,
> hotplugging drives, or leaving installed drives idle most of the time.
> 
> I want btrfs-raid1 because of its ability to replace corrupted or lost
> data from one disk using the other.  If I run a single-volume btrfs
> on LVM-RAID1 (or dm-RAID1, or RAID1 at any other layer of the storage
> stack), I can detect lost data, but not replace it automatically from
> the other mirror.
OK, now I have understood.

Anyway as workaround, take in account that you can pass explicitly the
devices as:

mount -o device=/dev/sda,device=/dev/sdb,device=/dev/sdc /dev/sdd /mnt

(supposing that the filesystem is on /dev/sda.../dev/sdd)

I am working to a mount.btrfs helper. The aim of this helper is to manage
the assembling of multiple devices; the main points will be:
- wait until all the devices appeared
- allow (if required) to mount in degraded mode after a timeout
- at this point it could/should also skip the lvm-snapshotted devices (but before 
I have to know how recognize these) 

I hope to issue the patches in the next week

BR
G.Baroncelli

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
