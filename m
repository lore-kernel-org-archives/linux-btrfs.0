Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:38552 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932697AbcLQAFY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Dec 2016 19:05:24 -0500
Subject: Re: uncorrectable error, but no file there
To: "John L. Center" <jlcenter15@gmail.com>, linux-btrfs@vger.kernel.org
References: <26f42ead-53d3-a7d3-d7bf-597ed7ad5342@gmail.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <7fed01e8-2e71-e15d-3f93-1428e0b91d5d@mendix.com>
Date: Sat, 17 Dec 2016 01:05:21 +0100
MIME-Version: 1.0
In-Reply-To: <26f42ead-53d3-a7d3-d7bf-597ed7ad5342@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/17/2016 12:48 AM, John L. Center wrote:
> Hi,
> 
> I ran a btrfs scrub & found 3 uncorrectable errors:
> 
> [...]
> When I ran scrub again, I still had
> 1 uncorrectable error, but noticed that btrfs wrote to dmesg that 4 were
> found:
> 
> [61530.256323] BTRFS warning (device md126p2): checksum error at logical
> 193296359424 on dev /dev/md126p2, sector 379645488, root 257, inode
> 1795724, offset 217088: path resolving failed with ret=-2
> [61530.256325] BTRFS error (device md126p2): bdev /dev/md126p2 errs: wr
> 0, rd 0, flush 0, corrupt 4, gen 0
> 
> Btrfs scrub only reported that 1 was found:
> 
> john@mariposa:~$ sudo btrfs scrub status -d /
> scrub status for ac8fcd40-8879-4416-8259-c30980e526d2
> scrub device /dev/md126p2 (id 1) history
> 	scrub started at Fri Dec 16 15:19:03 2016 and finished after 02:25:27
> 	total bytes scrubbed: 1.14TiB with 1 errors
> 	error details: csum=1
> 	corrected errors: 0, uncorrectable errors: 1, unverified errors: 0
> 
> Does btrfs keep a running tally of the errors found between runs?

The lines with the 1234 corrupt errors are not from scrub. The counters
are not managed by scrub, they are in kernel counters which record the
total amount of failed reads etc on a physical device.

You can see all error counters by doing 'btrfs device stats
<path>|<device>' (see man btrfs-device)

>  I
> never noticed this before, but this is also the first uncorrectable
> errors I've had since rebuilding by system.  Also, notice that the one
> error it found represented the space that was occupied by the first
> file, libtracker-data.so.0.0.0.  When I reinstalled the package, it
> didn't overwrite the inode that the file was originally at.  How do I
> clean up this inode so that my btrfs partition is error free again?  :-)
> 
> Also, what would have caused this kind of error?  It's been running well
> since I rebuilt it.  SMART has found no problem with the drives.  I'm
> running Ubuntu 16.04 w/ kernel 4.8.15 & btrfs-progs v4.8.5-dirty.

I don't know about these right now, but could answer the first one. :)

Only some thoughts... Since it's checksum errors I would suspect actual
disk errors. If SMART doesn't record them it's not physical read
failures, but simply the disk returning something else than what was
written before. With some other filesystems you would be working with
silently corrupted data right now.

-- 
Hans van Kranenburg
