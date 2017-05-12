Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yb0-f169.google.com ([209.85.213.169]:34600 "EHLO
        mail-yb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755463AbdELRHC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 May 2017 13:07:02 -0400
Received: by mail-yb0-f169.google.com with SMTP id 8so15491039ybw.1
        for <linux-btrfs@vger.kernel.org>; Fri, 12 May 2017 10:07:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4b7809e0-7329-62b0-c488-51bd4f0318a6@arcor.de>
References: <CAJCQCtRNzJPNhMwRtha3Wf1WReDQvaXY=7CpZGW4M=mONLrLSQ@mail.gmail.com>
 <4b7809e0-7329-62b0-c488-51bd4f0318a6@arcor.de>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 12 May 2017 11:07:01 -0600
Message-ID: <CAJCQCtRDn8TMiv2sh0SGM=f2ApMa_j=N8=YFF+pu38WdThM7HQ@mail.gmail.com>
Subject: Re: Creating btrfs RAID on LUKS devs makes devices disappear
To: Ochi <ochi@arcor.de>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 11, 2017 at 5:24 PM, Ochi <ochi@arcor.de> wrote:
> Hello,
>
> here is the journal.log (I hope). It's quite interesting. I rebooted the
> machine, performed a mkfs.btrfs on dm-{2,3,4} and dm-3 was missing
> afterwards (around timestamp 66.*). However, I then logged into the machine
> from another terminal (around timestamp 118.*) which triggered something to
> make the device appear again :O Indeed, dm-3 was once again there after
> logging in. Does systemd mix something up?

I don't see any Btrfs complaints. If dm-3 is the device Btrfs is
expecting and it vanishes, then Btrfs would mention it on a read or
write. So either nothing is happening and Btrfs isn't yet aware that
dm-3 is gone, or it's looking at some other instance of that encrypted
volume, maybe it's using /dev/mapper/storage1. You can find out with
btrfs fi show.

Whenever I use Btrfs on LUKS I invariably see fi show, show me one
device using /dev/dm-0 notation and the other device is
/dev/mapper/blah notation. I think this is just an artifact of all the
weird behind the scenes shit with symlinks and such, and that is a
systemd thing as far as I know.

Anyway, more information is needed. First see if the device is really
missing per Btrfs (read or write something and also check with 'btrfs
fi show') You can add systemd.log_level=debug as a boot parameter to
get more information in the journal, although it's rather verbose. You
could combine it with rd.udev.debug but that gets really crazy verbose
so I tend not to use them at the same time.

The other possibility is there's a conflict with dracut which may be
doing some things, and the debug switch for that is rd.debug and is
likewise extremely verbose, producing huge logs, so I would start out
with just the systemd debug and see if that reveals anything
*assuming* Btrfs is complaining. If Btrfs doesn't complain about a
device going away then I wouldn't worry about it.


-- 
Chris Murphy
