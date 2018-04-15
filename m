Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f172.google.com ([74.125.82.172]:44031 "EHLO
        mail-ot0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750960AbeDOWcV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 15 Apr 2018 18:32:21 -0400
Received: by mail-ot0-f172.google.com with SMTP id d9-v6so15384831oth.10
        for <linux-btrfs@vger.kernel.org>; Sun, 15 Apr 2018 15:32:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFd7Xoev1N4yQpM-THMSgu2NNO19eK+Hd14Nx9XOPZC2BcOTWA@mail.gmail.com>
References: <CAFd7Xoev1N4yQpM-THMSgu2NNO19eK+Hd14Nx9XOPZC2BcOTWA@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 15 Apr 2018 16:32:20 -0600
Message-ID: <CAJCQCtRf5UhQiWvriKQvW6aru6OpsYqKgadYyz54x1FDgKg_yg@mail.gmail.com>
Subject: Re: having issue removing a drive with a bad block
To: Alexander Zapatka <alexzapatka@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Apr 15, 2018 at 6:14 AM, Alexander Zapatka
<alexzapatka@gmail.com> wrote:
> i recently set up a drive pool in single mode on my little media
> server.  about a week later SMART started telling me that the drive
> was having issue and there is one bad sector.  since the array is far
> from full i decided to remove the drive from the pool.  but running
>
> btrfs device remove /dev/sdc /mnt/pool
>
> resulted in a deadlock.  everything crashed, and i had to pull the
> plug to reboot.  once up i did a btrfs check of the drive and it
> reported no issues with the file system...  but running the remove
> again results in a dead lock.  i have tried running a scrub and it
> eventually results in a dead lock also.

What do you get for:

$ sudo smartctl -l scterc

And can you post a complete dmesg somewhere? Chances are this deadlock
is not really a deadlock, the system is hanging because Btrfs keeps
trying to read a bad block, and it's taking the drive so long to
recover that the kernel does a SATA link reset, and then Btrfs tries
to read again and then you get another hang while the drive decides
what to do - etc and it just doesn't end. But we need the dmesg even
if it takes 30 minutes for the dmesg command to complete - it's
probably easiest to do this with ssh remotely so that the dmesg result
when it finally appears is already on another machine and you don't
have to additionally mess around with outputing it to a file and then
getting the file off the hanging machine.

And don't hard reset it. 'sudo reboot -f' should be sufficient and
safe, even if not immediate, it might take a couple minutes for it it
to actually reboot.

What I'm betting is that you've got a mismatch between the kernel's
scsi command timer (defaults to 30 seconds) and the SCT ERC setting
for the drives. If they're consumer drives they either don't support
SCT ERC or it's disabled by default, in either case the recovery can
be well in excess of 30 seconds. So what you have to do is flip that
around so the drive gives up before the kernel. So either the command
timer has to be increased, or the drive SCT ERC value must be
decreased. And hence we need more info as requested above.




-- 
Chris Murphy
