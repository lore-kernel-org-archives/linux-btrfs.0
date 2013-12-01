Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:14879 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751063Ab3LAXBu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 1 Dec 2013 18:01:50 -0500
Date: Mon, 2 Dec 2013 10:01:30 +1100
From: Dave Chinner <david@fromorbit.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: missing /sbin/fsck.btrfs
Message-ID: <20131201230130.GS8803@dastard>
References: <13F547BC-D81C-45FB-9DC8-9C076B8605EF@colorremedies.com>
 <20131127005126.GC10988@dastard>
 <CBAC6E46-0E69-477C-A177-E720C3184073@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CBAC6E46-0E69-477C-A177-E720C3184073@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 26, 2013 at 08:06:36PM -0700, Chris Murphy wrote:
> 
> On Nov 26, 2013, at 5:51 PM, Dave Chinner <david@fromorbit.com>
> wrote:
> 
> > On Mon, Nov 25, 2013 at 11:40:49PM -0700, Chris Murphy wrote:
> >> Hi,
> >> 
> >> Is there supposed to be an /sbin/fsck.btrfs? I'm seeing a
> >> handful of threads indicating some idea of having it just do a
> >> no-op like fsck.xfs does, but then also the idea that
> >> /etc/fstab should correctly set fs_passno to 0 instead of such
> >> trickery.
> > 
> > You're missing a key thing that fsck.xfs does that fstab expects
> > to work - it fails with an error if the device is missing. If
> > the device is present, then fsck.xfs returns success.
> 
> The description of fs_passno taken literally doesn't account for
> this explanation. It just says if fs_passno is not present or
> zero, a value of zero is returned and fsck will assume that the
> filesystem does not need to be checked.

I'm not commenting on what fstab does or does not do - I commented
on the incorrect assertion that was made about fsck.xfs being a
no-op.

> So the fstab expects (or is it systemd or an fsck instance spawned
> by systemd?) this device present/missing flag to occur is a
> convention? Or by design? Seems goofy.

fstab expects that if it is asked for the filesystem to be checked
and the device is missing, then fsck.<foo> will return an error
because the device is missing and it could not be checked....

> > We did this because people were having problems when devices
> > took a long time to instantiate (e.g. SAN, iscsi and other
> > remote devices) and the 'device exists' check prevents
> > /etc/fstab trying to mount the filesystems before they are
> > present and then throwing a hissy fit….
> 
> OK so you're saying you'd want rootfs on XFS to have its fstab
> entry retain an fs_passno of 1?

No, I didn't say that. I just explained that things can go wrong if
you don't detect certain types of errors in fsck.<foo> when it is
called from fstab processing.

What I am implying here is that we cannot prevent users from setting
passno to 1 or 2 in /etc/fstab. We have no control over that and so
asserting that "we don't need a fsck.btrfs because we can set passno
to 0" is invalid. IOWs, fsck.btrfs needs to be present and it needs
to behave correctly in these cases....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
