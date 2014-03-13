Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f179.google.com ([209.85.216.179]:52304 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755101AbaCMTvX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Mar 2014 15:51:23 -0400
Received: by mail-qc0-f179.google.com with SMTP id m20so1760389qcx.24
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Mar 2014 12:51:23 -0700 (PDT)
Received: from [192.168.37.12] (host-253-94-220-24.midco.net. [24.220.94.253])
        by mx.google.com with ESMTPSA id i14sm9408721qaj.11.2014.03.13.12.51.21
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Thu, 13 Mar 2014 12:51:22 -0700 (PDT)
Message-ID: <53220BA7.1060702@gmail.com>
Date: Thu, 13 Mar 2014 14:48:55 -0500
From: Andrew Skretvedt <andrew.skretvedt@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: Incremental backup for a raid1
References: <1564384.fRV1HUkfCq@fuchsia> <20140313192832.GE6151@carfax.org.uk>
In-Reply-To: <20140313192832.GE6151@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014-Mar-13 14:28, Hugo Mills wrote:
> On Thu, Mar 13, 2014 at 08:12:44PM +0100, Michael Schuerig wrote:
>>
>> My backup use case is different from the what has been recently
>> discussed in another thread. I'm trying to guard against hardware
>> failure and other causes of destruction.
>>
>> I have a btrfs raid1 filesystem spread over two disks. I want to backup
>> this filesystem regularly and efficiently to an external disk (same
>> model as the ones in the raid) in such a way that
>>
>> * when one disk in the raid fails, I can substitute the backup and
>> rebalancing from the surviving disk to the substitute only applies the
>> missing changes.
>>
>> * when the entire raid fails, I can re-build a new one from the backup.
>>
>> The filesystem is mounted at its root and has several nested subvolumes
>> and snapshots (in a .snapshots subdir on each subvol).
>>
>> Is it possible to do what I'm looking for?
>
>     For point 2, yes. (Add new disk, balance -oconvert from single to
> raid1).
>
>     For point 1, not really. It's a different filesystem, so it'll have
> a different UUID. You *might* be able to get away with rsync of one of
> the block devices in the array to the backup block device, but you'd
> have to unmount the FS (or halt all writes to it) for the period of
> the rsync to ensure a consistent image, and the rsync would have to
> read all the data in the device being synced to work out what to send.
> Probably not what you want.
>
>     Hugo.
>
I'm new; btrfs noob; completely unqualified to write intelligently on 
this topic, nevertheless:
I understand your setup to be btrfs RAID1 with /dev/A /dev/B, and a 
backup device someplace /dev/C

Could you, at the time you wanted to backup the filesystem:
1) in the filesystem, break RAID1: /dev/A /dev/B <-- remove /dev/B
2) reestablish RAID1 to the backup device: /dev/A /dev/C <-- added
3) balance to effect the backup (i.e. rebuilding the RAID1 onto /dev/C)
4) break/reconnect the original devices: remove /dev/C; re-add /dev/B to 
the fs

I think this could be done online. Any one device [ABC] surviving is 
sufficient to rebuild a RAID1 of the filesystem, or be accessed alone in 
degraded fashion for disaster recovery purposes.

I think that would address point 1. Is my thinking horrible on this? 
(again, noob to btrfs)
