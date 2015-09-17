Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f53.google.com ([209.85.213.53]:35794 "EHLO
	mail-vk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbbIQP0V (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Sep 2015 11:26:21 -0400
Received: by vkao3 with SMTP id o3so12951724vka.2
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2015 08:26:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPQXdDQzkQsJrRJH3+c0x93ogDPge_hjHyW1CZ-FQRAdoMaGoA@mail.gmail.com>
References: <CAPQXdDQzkQsJrRJH3+c0x93ogDPge_hjHyW1CZ-FQRAdoMaGoA@mail.gmail.com>
Date: Thu, 17 Sep 2015 09:26:20 -0600
Message-ID: <CAJCQCtS1=-9RX0wB58yVzTwW5dMSm577iAZk1+rVq7ssxMHUDA@mail.gmail.com>
Subject: Re: RAID1 storage server won't boot with one disk missing
From: Chris Murphy <lists@colorremedies.com>
To: "erpo41@gmail.com" <erpo41@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 16, 2015 at 5:56 PM, erpo41@gmail.com <erpo41@gmail.com> wrote:

> What I expected to happen:
> I expected that the system would either start as if nothing were
> wrong, or would warn me that one half of the mirror was missing and
> ask if I really wanted to start the system with the root array in a
> degraded state.

It's not this sophisticated yet. Btrfs does not "assemble" degraded by
default like mdadm and LVM based RAID. You need to manually mount it
with -o degraded and then continue the boot process, or use boot
parameter rootflags=degraded. Yet there is still some interaction
between btrfs dev scan and udev (?) that I don't understand precisely,
but what happens is when any device is missing, the Btrfs volume UUID
doesn't appear and therefore it still can't be mounted degraded if
volume UUID is used, e.g. boot parameter
root=UUID=<btrfsrootvolumeuuid>  so that needs to be changed to a
/dev/sdXY type of notation and hope that you guess it correctly.



>
> What actually happened:
> During the boot process, a kernel message appeared indicating that the
> "system array" could not be found for the root filesystem (as
> identified by a UUID). It then dumped me to an initramfs prompt.
> Powering down the system, reattaching the second disk, and powering it
> on allowed me to boot successfully. Running "btrfs fi df /" showed
> that all System data was stored as RAID1.

Just an FYI to be really careful about degraded rw mounts. There is no
automatic resync to catch up the previously missing device with the
device that was degraded,rw mounted. You have to scrub or balance,
there's no optimization yet for Btrfs to effectively just "diff"
between the devices' generations and get them all in sync quickly.

Much worse is if you don't scrub or balance, and then redo the test
reversing the device to make missing. Now you have multiple devices
that were rw,degraded mounted, and putting them back together again
will corrupt the whole file system irreparably. Fixing the first
problem would (almost always) avoid the second problem.

> If I want to have a storage server where one of two drives can fail at
> any time without causing much down time, am I on the right track? If
> so, what should I try next to get the behavior I'm looking for?

It's totally not there yet if you want to obviate manual checks and
intervention for failure cases. Both mdadm and LVM integrated RAID
have monitoring and notification which Btrfs lacks entirely. So that
means you have to check it or create scripts to check it. What often
tends to happen is Btrfs just keeps retrying rather than ignoring a
bad device, so you'll see piles of retries with dmesg But Btrfs
doesn't kick out the bad device like the md drive would do. This could
go on for hours, or days. So if you aren't checking for it, you could
unwittingly have a degraded array already.



-- 
Chris Murphy
