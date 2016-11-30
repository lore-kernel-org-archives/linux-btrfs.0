Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:36605 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932844AbcK3MuY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Nov 2016 07:50:24 -0500
Received: by mail-io0-f195.google.com with SMTP id k19so2151738iod.3
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Nov 2016 04:50:24 -0800 (PST)
Subject: Re: Convert from RAID 5 to 10
To: Roman Mamedov <rm@romanrm.net>, Wilson Meier <wilson.meier@gmail.com>
References: <10bbbf97-7f43-c972-a832-4a8cf054d5e5@xgm.de>
 <4ef63089-407d-0f18-b182-74c631874a02@gmail.com>
 <0d3d3ecd-44a4-fb7f-8f68-aca342d89d04@googlemail.com>
 <CAJCQCtSnt5yqm6kpA2AOz7p=wZFVxzUz8RH8r2o73ym45mYVFg@mail.gmail.com>
 <fce2df8b-0775-1ecf-c08d-960018822c20@googlemail.com>
 <20161130103808.74e5ae95@natsu>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <d9a72702-0507-c085-3bed-7ee5f8063ae3@gmail.com>
Date: Wed, 30 Nov 2016 07:50:17 -0500
MIME-Version: 1.0
In-Reply-To: <20161130103808.74e5ae95@natsu>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-11-30 00:38, Roman Mamedov wrote:
> On Wed, 30 Nov 2016 00:16:48 +0100
> Wilson Meier <wilson.meier@gmail.com> wrote:
>
>> That said, btrfs shouldn't be used for other then raid1 as every other
>> raid level has serious problems or at least doesn't work as the expected
>> raid level (in terms of failure recovery).
>
> RAID1 shouldn't be used either:
>
> *) Read performance is not optimized: all metadata is always read from the
> first device unless it has failed, data reads are supposedly balanced between
> devices per PID of the process reading. Better implementations dispatch reads
> per request to devices that are currently idle.
Based on what I've seen, the metadata reads get balanced too.

As far as the read balancing in general, while it doesn't work very well 
for single processes, but if you have a large number of processes 
started sequentially (for example, a thread-pool based server), it 
actually works out to being near optimal with a lot less logic than DM 
and MD have.  Aggregated over an entire system it's usually near optimal 
as well.
>
> *) Write performance is not optimized, during long full bandwidth sequential
> writes it is common to see devices writing not in parallel, but with a long
> periods of just one device writing, then another. (Admittedly have been some
> time since I tested that).
I've never seen this be an issue in practice, especially if you're using 
transparent compression (which caps extent size, and therefore I/O size 
to a given device, at 128k).  I'm also sane enough that I'm not doing 
bulk streaming writes to traditional HDD's or fully saturating the 
bandwidth on my SSD's (you should be over-provisioning whenever 
possible).  For a desktop user, unless you're doing real-time video 
recording at higher than HD resolution with high quality surround sound, 
this probably isn't going to hit you (and even then you should be 
recording to a temporary location with much faster write speeds (tmpfs 
or ext4 without a journal for example) because you'll likely get hit 
with fragmentation).

This also has overall pretty low impact compared to a number of other 
things that BTRFS does (BTRFS on a single disk with single profile for 
everything versus 2 of the same disks with raid1 profile for everything 
gets less than a 20% performance difference in all the testing I've done).
>
> *) A degraded RAID1 won't mount by default.
>
> If this was the root filesystem, the machine won't boot.
>
> To mount it, you need to add the "degraded" mount option.
> However you have exactly a single chance at that, you MUST restore the RAID to
> non-degraded state while it's mounted during that session, since it won't ever
> mount again in the r/w+degraded mode, and in r/o mode you can't perform any
> operations on the filesystem, including adding/removing devices.
There is a fix pending for the single chance to mount degraded thing, 
and even then, it only applies to a 2 device raid1 array (with more 
devices, new chunks are still raid1 if you're missing 1 device, so the 
checks don't trigger and refuse the mount).

As far as not mounting degraded by default, that's a conscious design 
choice that isn't going to change.  There's a switch (adding 'degraded' 
to the mount options) to enable this behavior per-mount, so we're still 
on-par in that respect with LVM and MD, we just picked a different 
default.  In this case, I actually feel it's a better default for most 
cases, because most regular users aren't doing exhaustive monitoring, 
and thus are not likely to notice the filesystem being mounted degraded 
until it's far too late.  If the filesystem is degraded, then 
_something_ has happened that the user needs to know about, and until 
some sane monitoring solution is implemented, the easiest way to ensure 
this is to refuse to mount.
>
> *) It does not properly handle a device disappearing during operation. (There
> is a patchset to add that).
>
> *) It does not properly handle said device returning (under a
> different /dev/sdX name, for bonus points).
These are not an easy problem to fix completely, especially considering 
that the device is currently guaranteed to reappear under a different 
name because BTRFS will still have an open reference on the original 
device name.

On top of that, if you've got hardware that's doing this without manual 
intervention, you've got much bigger issues than how BTRFS reacts to it. 
  No correctly working hardware should be doing this.
>
> Most of these also apply to all other RAID levels.
>
