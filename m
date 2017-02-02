Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:33318 "EHLO
        mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751157AbdBBMtS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Feb 2017 07:49:18 -0500
Received: by mail-io0-f178.google.com with SMTP id v96so84401849ioi.0
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Feb 2017 04:49:18 -0800 (PST)
Subject: Re: btrfs receive leaves new subvolume modifiable during operation
To: Graham Cobb <g.btrfs@cobb.uk.net>, linux-btrfs@vger.kernel.org
References: <1485905578.6441.20.camel@gmail.com>
 <pan$4ecd$16bc5e8e$14657c4$261368ad@cox.net>
 <4edfd08e-8d7f-d8d7-bdea-0589b46e4d2b@gmail.com>
 <7ead5d42-9c00-b2df-3fbf-5b8f287760f6@cobb.uk.net>
 <pan$16525$cf7fe24b$7c044b9$74b32f27@cox.net>
 <5c503d69-aaed-680f-de30-75a7323bc753@cobb.uk.net>
 <pan$5f1de$80937cf$9c306858$cafb9e40@cox.net>
 <1b69d1a8-c08b-c9f3-c95b-1d7d71c7d642@cobb.uk.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <113c027a-9e09-ca02-d975-b3a415bd119d@gmail.com>
Date: Thu, 2 Feb 2017 07:49:12 -0500
MIME-Version: 1.0
In-Reply-To: <1b69d1a8-c08b-c9f3-c95b-1d7d71c7d642@cobb.uk.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-02-02 05:52, Graham Cobb wrote:
> On 02/02/17 00:02, Duncan wrote:
>> If it's a workaround, then many of the Linux procedures we as admins and
>> users use every day are equally workarounds.  Setting 007 perms on a dir
>> that doesn't have anything immediately security vulnerable in it, simply
>> to keep other users from even potentially seeing or being able to write
>> to something N layers down the subdir tree, is standard practice.
>
> No. There is no need to normally place a read-only snapshot below a
> no-execute directory just to prevent write access to it. That is not
> part of the admin's expectation.
That depends on the admin.  I for example would absolutely expect that 
to be needed _while the snapshot is being created_ if the operation 
isn't being done by the kernel.
>
>> Which is my point.  This is no different than standard security practice,
>> that an admin should be familiar with and using without even having to
>> think about it.  Btrfs is simply making the same assumptions that
>> everyone else does, that an admin knows what they are doing and sets the
>> upstream permissions with that in mind.  If they don't, how is that
>> btrfs' fault?
>
> Because btrfs intends the receive snapshot to be read-only. That is the
> expectation of the sysadmin. It is an important and useful feature which
> makes send/receive very useful for creating
> user-readable-but-not-modifiable backups (without it, send/receive are
> useful for many things but less useful for creating backups). That
> feature has a bug.
If that's your use case, then from a consistency perspective, you should 
be receiving into a location the user can't read and then moving the 
subvolume into a user readable location once receive is done anyway. 
Otherwise, they may see a partial snapshot, and think something has been 
deleted that really hasn't.  This is a pretty basic method of ensuring 
consistency that's used literally all over the place on UNIX systems to 
atomically replace or update data sets.  Doing so also cleanly avoids 
needing to manipulate permissions on the directory the snapshots are in 
to prevent users from modifying the snapshots being received.
>
> Just because you don't personally use the feature, doesn't mean it isn't
> a bug! Many of us do rely on that feature.
>
> Even though it is security-related, I agree it isn't the highest
> priority btrfs bug. It can probably wait until receive is being worked
> on for other reasons. But if it isn't going to be fixed any time soon,
> it should be documented in the Wiki and the man page, with the suggested
> workround for anyone who needs to make sure the receive won't be
> tampered with.
I agree that it should be documented.  I don't agree that a specific 
workaround needs to be stated, as whether or not any particular 
workaround is needed is entirely dependent on the use case.  For 
example, if your users can only access the received snapshots over a 
networked filesystem, there's a much simpler option of just exporting 
the directories the snapshots are received into as read-only.  All that 
needs to be stated is that the way to prevent this is to make sure users 
can't write to the snapshots while they're being received.
