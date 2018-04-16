Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:35936 "EHLO
        mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755074AbeDPLno (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Apr 2018 07:43:44 -0400
Subject: Re: Add udev-md-raid-safe-timeouts.rules
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>, linux-lvm@redhat.com,
        Linux-RAID <linux-raid@vger.kernel.org>
References: <CAJCQCtQ3r16BYYtrx9rVYauh7JeAp9omWidS4zzwxqvhU1bh+g@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <5425366f-f339-d6f3-26d1-d02c3ba80671@gmail.com>
Date: Mon, 16 Apr 2018 07:43:39 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQ3r16BYYtrx9rVYauh7JeAp9omWidS4zzwxqvhU1bh+g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-04-15 21:04, Chris Murphy wrote:
> I just ran into this:
> https://github.com/neilbrown/mdadm/pull/32/commits/af1ddca7d5311dfc9ed60a5eb6497db1296f1bec
> 
> This solution is inadequate, can it be made more generic? This isn't
> an md specific problem, it affects Btrfs and LVM as well. And in fact
> raid0, and even none raid setups.
> 
> There is no good reason to prevent deep recovery, which is what
> happens with the default command timer of 30 seconds, with this class
> of drive. Basically that value is going to cause data loss for the
> single device and also raid0 case, where the reset happens before deep
> recovery has a chance. And even if deep recovery fails to return user
> data, what we need to see is the proper error message: read error UNC,
> rather than a link reset message which just obfuscates the problem.

This has been discussed at least once here before (probably more times, 
hard to be sure since it usually comes up as a side discussion in an 
only marginally related thread).  Last I knew, the consensus here was 
that it needs to be changed upstream in the kernel, not by adding a udev 
rule because while the value is technically system policy, the default 
policy is brain-dead for anything but the original disks it was 
i9ntended for (30 seconds works perfectly fine for actual SCSI devices 
because they behave sanely in the face of media errors, but it's 
horribly inadequate for ATA devices).

To re-iterate what I've said before on the subject:

For ATA drives it should probably be 150 seconds.  That's 30 seconds 
beyond the typical amount of time most consumer drives will keep 
retrying a sector, so even if it goes the full time to try and recover a 
sector this shouldn't trigger.  The only people this change should 
negatively impact are those who have failing drives which support SCT 
ERC and have it enabled, but aren't already adjusting this timeout.

For physical SCSI devices, it should continue to be 30 seconds.  SCSI 
disks are sensible here and don't waste your time trying to recover a 
sector.  For PV-SCSI devices, it should probably be adjusted too, but I 
don't know what a reasonable value is.

For USB devices it should probably be higher than 30 seconds, but again 
I have no idea what a reasonable value is.
