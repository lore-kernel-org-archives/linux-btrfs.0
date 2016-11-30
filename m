Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([195.154.117.182]:41284 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757251AbcK3OEI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Nov 2016 09:04:08 -0500
Date: Wed, 30 Nov 2016 19:04:04 +0500
From: Roman Mamedov <rm@romanrm.net>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Wilson Meier <wilson.meier@gmail.com>,
        Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Convert from RAID 5 to 10
Message-ID: <20161130190404.4f0e4bd5@natsu>
In-Reply-To: <d9a72702-0507-c085-3bed-7ee5f8063ae3@gmail.com>
References: <10bbbf97-7f43-c972-a832-4a8cf054d5e5@xgm.de>
 <4ef63089-407d-0f18-b182-74c631874a02@gmail.com>
 <0d3d3ecd-44a4-fb7f-8f68-aca342d89d04@googlemail.com>
 <CAJCQCtSnt5yqm6kpA2AOz7p=wZFVxzUz8RH8r2o73ym45mYVFg@mail.gmail.com>
 <fce2df8b-0775-1ecf-c08d-960018822c20@googlemail.com>
 <20161130103808.74e5ae95@natsu>
 <d9a72702-0507-c085-3bed-7ee5f8063ae3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 30 Nov 2016 07:50:17 -0500
"Austin S. Hemmelgarn" <ahferroin7@gmail.com> wrote:

> > *) Read performance is not optimized: all metadata is always read from the
> > first device unless it has failed, data reads are supposedly balanced between
> > devices per PID of the process reading. Better implementations dispatch reads
> > per request to devices that are currently idle.
> Based on what I've seen, the metadata reads get balanced too.

https://github.com/torvalds/linux/blob/v4.8/fs/btrfs/disk-io.c#L451
This starts from the mirror number 0 and tries others in an incrementing
order, until succeeds. It appears that as long as the mirror with copy #0 is up
and not corrupted, all reads will simply get satisfied from it.

> > *) Write performance is not optimized, during long full bandwidth sequential
> > writes it is common to see devices writing not in parallel, but with a long
> > periods of just one device writing, then another. (Admittedly have been some
> > time since I tested that).
> I've never seen this be an issue in practice, especially if you're using 
> transparent compression (which caps extent size, and therefore I/O size 
> to a given device, at 128k).  I'm also sane enough that I'm not doing 
> bulk streaming writes to traditional HDD's or fully saturating the 
> bandwidth on my SSD's (you should be over-provisioning whenever 
> possible).  For a desktop user, unless you're doing real-time video 
> recording at higher than HD resolution with high quality surround sound, 
> this probably isn't going to hit you (and even then you should be 
> recording to a temporary location with much faster write speeds (tmpfs 
> or ext4 without a journal for example) because you'll likely get hit 
> with fragmentation).

I did not use compression while observing this;

Also I don't know what is particularly insane about copying a 4-8 GB file onto
a storage array. I'd expect both disks to write at the same time (like they
do in pretty much any other RAID1 system), not one-after-another, effectively
slowing down the entire operation by as much as 2x in extreme cases.

> As far as not mounting degraded by default, that's a conscious design 
> choice that isn't going to change.  There's a switch (adding 'degraded' 
> to the mount options) to enable this behavior per-mount, so we're still 
> on-par in that respect with LVM and MD, we just picked a different 
> default.  In this case, I actually feel it's a better default for most 
> cases, because most regular users aren't doing exhaustive monitoring, 
> and thus are not likely to notice the filesystem being mounted degraded 
> until it's far too late.  If the filesystem is degraded, then 
> _something_ has happened that the user needs to know about, and until 
> some sane monitoring solution is implemented, the easiest way to ensure 
> this is to refuse to mount.

The easiest is to write to dmesg and syslog, if a user doesn't monitor those
either, it's their own fault; and the more user friendly one would be to still
auto mount degraded, but read-only.

Comparing to Ext4, that one appears to have the "errors=continue" behavior by
default, the user has to explicitly request "errors=remount-ro", and I have
never seen anyone use or recommend the third option of "errors=panic", which
is basically the equivalent of the current Btrfs practce.

> > *) It does not properly handle a device disappearing during operation. (There
> > is a patchset to add that).
> >
> > *) It does not properly handle said device returning (under a
> > different /dev/sdX name, for bonus points).
> These are not an easy problem to fix completely, especially considering 
> that the device is currently guaranteed to reappear under a different 
> name because BTRFS will still have an open reference on the original 
> device name.
> 
> On top of that, if you've got hardware that's doing this without manual 
> intervention, you've got much bigger issues than how BTRFS reacts to it. 
>   No correctly working hardware should be doing this.

Unplugging and replugging a SATA cable of a RAID1 member should never put your
system under the risk of a massive filesystem corruption; you cannot say it
absolutely doesn't with the current implementation.

-- 
With respect,
Roman
