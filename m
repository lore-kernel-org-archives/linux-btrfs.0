Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:37946 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750850AbdEBUPR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 May 2017 16:15:17 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1d5eCU-0001uL-6R
        for linux-btrfs@vger.kernel.org; Tue, 02 May 2017 22:15:10 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: Can I see what device was used to mount btrfs?
Date: Tue, 2 May 2017 22:15:06 +0200
Message-ID: <20170502221506.3dfe125e@jupiter.sol.kaishome.de>
References: <1e2e2e5c-5ee8-85c1-1db4-74293d8c9c1e@gmail.com>
        <20170502135820.2ft7bsoceeqhnbqf@angband.pl>
        <CAA91j0V97dCb+j_thg0oi7B4D29VVKcqtRcpCWbgQyzi+FScKA@mail.gmail.com>
        <20170502184923.jdpfx3pwkl5avdph@angband.pl>
        <c7f3c9fe-2f28-e102-9df7-273dc5a6ca8e@inwind.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Tue, 2 May 2017 21:50:19 +0200
schrieb Goffredo Baroncelli <kreijack@inwind.it>:

> On 2017-05-02 20:49, Adam Borowski wrote:
> >> It could be some daemon that waits for btrfs to become complete.
> >> Do we have something?  
> > Such a daemon would also have to read the chunk tree.  
> 
> I don't think that a daemon is necessary. As proof of concept, in the
> past I developed a mount helper [1] which handled the mount of a
> btrfs filesystem: this handler first checks if the filesystem is a
> multivolume devices, if so it waits that all the devices are
> appeared. Finally mount the filesystem.
> 
> > It's not so simple -- such a btrfs device would have THREE states:
> > 
> > 1. not mountable yet (multi-device with not enough disks present)
> > 2. mountable ro / rw-degraded
> > 3. healthy  
> 
> My mount.btrfs could be "programmed" to wait a timeout, then it
> mounts the filesystem as degraded if not all devices are present.
> This is a very simple strategy, but this could be expanded.
> 
> I am inclined to think that the current approach doesn't fit well the
> btrfs requirements.  The roles and responsibilities are spread to too
> much layer (udev, systemd, mount)... I hoped that my helper could be
> adopted in order to concentrate all the responsibility to only one
> binary; this would reduce the interface number with the other
> subsystem (eg systemd, udev).
> 
> For example, it would be possible to implement a sane check that
> prevent to mount a btrfs filesystem if two devices exposes the same
> UUID... 

Ideally, the btrfs wouldn't even appear in /dev until it was assembled
by udev. But apparently that's not the case, and I think this is where
the problems come from. I wish, btrfs would not show up as device nodes
in /dev that the mount command identified as btrfs. Instead, btrfs
would expose (probably through udev) a device node
in /dev/btrfs/fs_identifier when it is ready.

Apparently, the core problem of how to handle degraded btrfs still
remains. Maybe it could be solved by adding more stages of btrfs nodes,
like /dev/btrfs-incomplete (for unusable btrfs), /dev/btrfs-degraded
(for btrfs still missing devices but at least one stripe of btrfs raid
available) and /dev/btrfs as the final stage. That way, a mount process
could wait for a while, and if the device doesn't appear, it tries the
degraded stage instead. If the fs is opened from the degraded dev node
stage, udev (or other processes) that scan for devices should stop
assembling the fs if they still do so.

bcache has a similar approach by hiding an fs within a protective
superblock. Unless bcache is setup, the fs won't show up in /dev, and
that fs won't be visible by other means. Btrfs should do something
similar and only show a single device node if assembled completely. The
component devices would have superblocks ignored by mount, and only the
final node would expose a virtual superblock and the compound device
after it. Of course, this makes things like compound device resizing
more complicated maybe even impossible.

If I'm not totally wrong, I think this is also how zfs exposes its
pools. You need user space tools to make the fs pools visible in the
tree. If zfs is incomplete, there's nothing to mount, and thus no race
condition. But I never tried zfs seriously, so I do not know.

-- 
Regards,
Kai

Replies to list-only preferred.

