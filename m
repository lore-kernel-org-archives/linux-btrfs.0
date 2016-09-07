Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:35807 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753627AbcIGTea (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Sep 2016 15:34:30 -0400
Received: by mail-oi0-f41.google.com with SMTP id s131so40742866oie.2
        for <linux-btrfs@vger.kernel.org>; Wed, 07 Sep 2016 12:34:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <d6f659e7-25bf-c732-a7db-0cef8450b346@gmail.com>
References: <c04c596d-4cb9-ed98-513a-c550b1be18b2@cobb.uk.net>
 <2d59a472-4e74-d64c-27c4-28677d761316@gmail.com> <4afee621-0493-1ffc-31fe-fb81643f2374@cobb.uk.net>
 <1473259316.24874.3.camel@scientia.net> <12cfbaf0-77ff-a4d2-d9d7-64c5c795ce4b@gmail.com>
 <1473271679.24874.36.camel@scientia.net> <d6f659e7-25bf-c732-a7db-0cef8450b346@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 7 Sep 2016 13:34:06 -0600
Message-ID: <CAJCQCtSmFA2iRDN33u9XF1b4nN_xA5sy44tS3n5mnA4f+go_hg@mail.gmail.com>
Subject: Re: Security implications of btrfs receive?
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 7, 2016 at 1:08 PM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:

> I think I covered it already in the last thread on this, but the best way I
> see to fix the whole auto-assembly issue is:
> 1. Stop the damn auto-scanning of new devices on hot-plug.  The scanning
> should be done on mount or invoking something like btrfs dev scan, not on
> hot-plug.  This is the biggest current issue, and is in theory the easiest
> thing to fix.  The problem here is that it's udev sources we need to change,
> not our own.
> 2. Get rid of the tracking in the kernel.  If a filesystem isn't mounted or
> requested to be mounted, then the kernel has no business worrying about what
> what devices it's on.  If the filesystem is mounted, then the only way to
> associate new devices should be from userspace.
> 3. When mounting, the mount helper should be doing the checking to verify
> that the UUID's and everything else are correct.  Ideally, the mount(2) call
> should require a list of devices to use, and mount should be doing the
> discovery.  This is at odds with how systemd handles BTRFS mounts, but
> they're being stupid with that too (the only way to tell for certain if a FS
> will mount is to try to mount it, if the mount(2) call succeeds, then the
> filesystem was ready, regardless of whether or not userspace thinks the
> device is).
> 4. The kernel should be doing a better job of validating filesystems. It
> should be checking that all the devices agree on how many devices there
> should be, as well as checking that they all have correct UUID's. This is
> technically not necessary if item 3 is implemented, but is still good
> practice from a hardening perspective.

It'd be nice to leverage WWN when available, cross referencing all WWN
with volume UUID and device UUID. There are all sorts of policies that
can make use of this, not least of which is "fail on mount whenever
all three expected IDs are not present" but also this crazy hunt for
the actual physical device to replace when all we know from btrfs fi
show is that a device is missing, and inferring what devid it is from
the devids that are still listed. I'd like to see a WWN for what's
missing. devid is useless, devuuid is useless, a serial number is
better than nothing but WWN fits the use case by design.

But yeah I think we kinda need some other ducks in a row, the
mechanisms of discovery, and the continuum of faultiness (occasionally
flaky, to flat out vanished).

It is also kinda important to see things like udisks and storaged as
user agents, ensuring they have a way to communicate with the helper
so things are mounted and umounted correctly as most DE's now expect
to just automount everything. I still get weird behaviors on GNOME
with udisks2 and multiple device Btrfs volumes with current upstream
GNOME stuff.


-- 
Chris Murphy
