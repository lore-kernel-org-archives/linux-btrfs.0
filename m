Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:36460 "EHLO
        mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S945260AbdDTM14 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Apr 2017 08:27:56 -0400
Received: by mail-io0-f174.google.com with SMTP id o22so73852284iod.3
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Apr 2017 05:27:55 -0700 (PDT)
Subject: Re: Reporting and monitoring storage events (blog)
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtTbp2qkSHNyRNYm41civm+V_gsGkRBNHe+_7sgW+1fgjg@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <e0d7852c-4e55-f04b-02dd-6376873a0b34@gmail.com>
Date: Thu, 20 Apr 2017 08:27:46 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTbp2qkSHNyRNYm41civm+V_gsGkRBNHe+_7sgW+1fgjg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-04-19 13:39, Chris Murphy wrote:
> http://www-rhstorage.rhcloud.com/blog/vpodzime/reporting-and-monitoring-storage-events
>
> I think the most useful part of this would be standardized messaging.
> For the exact same defect state on disk (data corruption), I get two
> different formatted messages depending on whether it's found passively
> by reading the file, or with a scrub.
In addition to that, adding an event channel back to userspace like 
dmeventd and mdadm use for their monitoring would be extremely useful. 
Logging is useful for postmortem analysis, but monitoring logs to get 
event notifications is error-prone, potentially racy, and introduces 
unnecessary delays in handling.

>
> (this is 2x disk raid 1)
>
> read file:
> [256914.773712] BTRFS warning (device dm-6): csum failed ino 257 off 0
> csum 3734069121 expected csum 1334657141
> [256914.774594] BTRFS warning (device dm-6): csum failed ino 257 off 0
> csum 3734069121 expected csum 1334657141
> [256914.775892] BTRFS info (device dm-6): read error corrected: ino
> 257 off 0 (dev /dev/mapper/VG-b1 sector 2155520)
>
> scrub volume:
>
>
> [257313.636610] BTRFS warning (device dm-6): checksum error at logical
> 1103626240 on dev /dev/mapper/VG-b1, sector 2155520, root 5, inode
> 257, offset 0, length 4096, links 1 (path:
> openSUSE-Tumbleweed-NET-x86_64-Current.iso)
> [257313.636865] BTRFS error (device dm-6): bdev /dev/mapper/VG-b1
> errs: wr 0, rd 0, flush 0, corrupt 1, gen 0
> [257313.637737] BTRFS error (device dm-6): fixed up error at logical
> 1103626240 on dev /dev/mapper/VG-b1
>
>
> Reading means there's a warning, scrubbing means there's an error? So
> even the log level is different for the same problem?
What's more confusing is that:
* Checksum failure on read is a warning, but correction of that error is 
an info message (These should be the same log level so that they either 
both show up, or neither shows up.  Having just the checksum failure or 
the error correction display is potentially confusing).
* The message from a scrub that provides most of the useful info is a 
warning (and it's a checksum error), but the info about correcting it 
and incrementing the error counters are errors.

So, not only are things inconsistent across the type of correction, but 
they're internally inconsistent.
>
> And then the ambiguous "read error corrected" vs "fixed up error" -
> the second one is more clear that the fix is pushed to a device "fixed
> error on device" rather than just an in memory correction. But still,
> they're different messages for the same problem and the auto healing.
Of the two, I personally prefer the scrub messages by a pretty 
significant margin.  They give you info about the inode, the location of 
the error, the path in the FS, and even the location on-disk itself 
while additionally logging the values of the cumulative error counters 
and telling you that the error was corrected.  If we were to update that 
to include what triggered detecting the error, that would cover pretty 
much everything needed for a reasonable e-mail notification.

