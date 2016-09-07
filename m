Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f48.google.com ([209.85.214.48]:37392 "EHLO
        mail-it0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757080AbcIGPHN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Sep 2016 11:07:13 -0400
Received: by mail-it0-f48.google.com with SMTP id e124so26308238ith.0
        for <linux-btrfs@vger.kernel.org>; Wed, 07 Sep 2016 08:07:12 -0700 (PDT)
Subject: Re: Security implications of btrfs receive?
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        linux-btrfs@vger.kernel.org
References: <c04c596d-4cb9-ed98-513a-c550b1be18b2@cobb.uk.net>
 <2d59a472-4e74-d64c-27c4-28677d761316@gmail.com>
 <4afee621-0493-1ffc-31fe-fb81643f2374@cobb.uk.net>
 <1473259316.24874.3.camel@scientia.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <12cfbaf0-77ff-a4d2-d9d7-64c5c795ce4b@gmail.com>
Date: Wed, 7 Sep 2016 11:06:46 -0400
MIME-Version: 1.0
In-Reply-To: <1473259316.24874.3.camel@scientia.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-09-07 10:41, Christoph Anton Mitterer wrote:
> On Tue, 2016-09-06 at 18:20 +0100, Graham Cobb wrote:
>> they know the UUID of the subvolume?
>
> Unfortunately, btrfs seems to be pretty problematic when anyone knows
> your UUIDs...
This is an issue with any filesystem, it is just a bigger issue with 
BTRFS.  Take a system using ext4, or XFS, or almost any other Linux 
filesystem, running almost any major distro, create a minimum sized 
partition on the disk for that filesystem type, and create a filesystem 
there with the same UUID as the root filesystem.  Next time that system 
reboots, things will usually blow up (XFS will refuse to mount, ext4 and 
most other filesystems will work sometimes and not others).  Windows and 
OS X actually have nearly as many problems like this too, they just 
happen in different circumstances (I've actually demonstrated to people 
the process of crashing a system by hot-plugging a disk before the boot 
drive at the right moment during startup, and that works on Windows and 
OS X, and under some circumstances on Linux too).
> Look for my thread "attacking btrfs filesystems via UUID collisions?"
> in the list archives.
> From accidental corruptions to intentional attacks, a lot seemed to be
> quite possible... and I do not even talk about general attacks that any
> such systems that may do auto-assembly/auto-rebuilds (e.g. of multi-
> device containers/fs) or similar likely suffer from (I've also
> discussed this in the thread back then at some of the later mails).
>
> Don't think anything has happened in that area yet (or ever?)... at
> least I wouldn't have noticed that these security showstoppers would
> have got fixed.
It hasn't, because there's not any way it can be completely fixed.  This 
particular case is an excellent example of why it's so hard to fix.  To 
close this particular hole, BTRFS itself would have to become aware of 
whether whoever is running an ioctl is running in a chroot or not, which 
is non-trivial to determine to begin with, and even harder when you 
factor in the fact that chroot() is a VFS level thing, not a underlying 
filesystem thing, while ioctls are much lower level.

That said, nobody's really done any work on mitigating the issues 
either, although David Sterba has commented about having interest in 
fixing issues caused by crafted filesystem images, so hopefully things 
will start moving more in the direction of proper security.

