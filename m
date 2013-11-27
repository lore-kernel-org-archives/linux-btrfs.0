Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:33449 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750937Ab3K0DGi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Nov 2013 22:06:38 -0500
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: missing /sbin/fsck.btrfs
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20131127005126.GC10988@dastard>
Date: Tue, 26 Nov 2013 20:06:36 -0700
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <CBAC6E46-0E69-477C-A177-E720C3184073@colorremedies.com>
References: <13F547BC-D81C-45FB-9DC8-9C076B8605EF@colorremedies.com> <20131127005126.GC10988@dastard>
To: Dave Chinner <david@fromorbit.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Nov 26, 2013, at 5:51 PM, Dave Chinner <david@fromorbit.com> wrote:

> On Mon, Nov 25, 2013 at 11:40:49PM -0700, Chris Murphy wrote:
>> Hi,
>> 
>> Is there supposed to be an /sbin/fsck.btrfs? I'm seeing a handful
>> of threads indicating some idea of having it just do a no-op like
>> fsck.xfs does, but then also the idea that /etc/fstab should
>> correctly set fs_passno to 0 instead of such trickery.
> 
> You're missing a key thing that fsck.xfs does that fstab expects to
> work - it fails with an error if the device is missing. If the
> device is present, then fsck.xfs returns success.

The description of fs_passno taken literally doesn't account for this explanation. It just says if fs_passno is not present or zero, a value of zero is returned and fsck will assume that the filesystem does not need to be checked.

So the fstab expects (or is it systemd or an fsck instance spawned by systemd?) this device present/missing flag to occur is a convention? Or by design? Seems goofy.

> We did this because people were having problems when devices took a
> long time to instantiate (e.g. SAN, iscsi and other remote devices)
> and the 'device exists' check prevents /etc/fstab trying to mount
> the filesystems before they are present and then throwing a hissy
> fit….

OK so you're saying you'd want rootfs on XFS to have its fstab entry retain an fs_passno of 1? Or you'd rather see the process responsible for making sure that the claimed rootfs device is made available before throwing hissy fits when it can't be found?


Chris Murphy