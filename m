Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:45391 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752371AbdBCJPR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Feb 2017 04:15:17 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cZZxR-0006V6-6Y
        for linux-btrfs@vger.kernel.org; Fri, 03 Feb 2017 10:15:05 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs receive leaves new subvolume modifiable during operation
Date: Fri, 3 Feb 2017 09:14:59 +0000 (UTC)
Message-ID: <pan$e2f8a$ba778439$cd53e97c$382283f9@cox.net>
References: <1485905578.6441.20.camel@gmail.com>
        <pan$4ecd$16bc5e8e$14657c4$261368ad@cox.net>
        <4edfd08e-8d7f-d8d7-bdea-0589b46e4d2b@gmail.com>
        <7ead5d42-9c00-b2df-3fbf-5b8f287760f6@cobb.uk.net>
        <pan$16525$cf7fe24b$7c044b9$74b32f27@cox.net>
        <5c503d69-aaed-680f-de30-75a7323bc753@cobb.uk.net>
        <pan$5f1de$80937cf$9c306858$cafb9e40@cox.net>
        <1b69d1a8-c08b-c9f3-c95b-1d7d71c7d642@cobb.uk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Graham Cobb posted on Thu, 02 Feb 2017 10:52:26 +0000 as excerpted:

> On 02/02/17 00:02, Duncan wrote:
>> If it's a workaround, then many of the Linux procedures we as admins
>> and users use every day are equally workarounds.  Setting 007 perms on
>> a dir that doesn't have anything immediately security vulnerable in it,
>> simply to keep other users from even potentially seeing or being able
>> to write to something N layers down the subdir tree, is standard
>> practice.
> 
> No. There is no need to normally place a read-only snapshot below a
> no-execute directory just to prevent write access to it. That is not
> part of the admin's expectation.
> 
>> Which is my point.  This is no different than standard security
>> practice,
>> that an admin should be familiar with and using without even having to
>> think about it.  Btrfs is simply making the same assumptions that
>> everyone else does, that an admin knows what they are doing and sets
>> the upstream permissions with that in mind.  If they don't, how is that
>> btrfs' fault?
> 
> Because btrfs intends the receive snapshot to be read-only. That is the
> expectation of the sysadmin.

Read-only *after* completion, yes.  But a sysadmin that believes really 
setting something read-only and then trying to write to it from 
userspace, which is what btrfs does until the receive is done, should 
work, doesn't understand the meaning of read-only.

Meanwhile, Austin said most of what I'd say, probably better than I'd say 
it, so I won't repeat it here, but I agree with him.

> Even though it is security-related, I agree it isn't the highest
> priority btrfs bug. It can probably wait until receive is being worked
> on for other reasons. But if it isn't going to be fixed any time soon,
> it should be documented in the Wiki and the man page, with the suggested
> workround for anyone who needs to make sure the receive won't be
> tampered with.

One thing I was going to say in the previous post and forgot, is that not 
withstanding all the technical reasons, I do agree that documenting it in 
the manpage, etc, would be a good idea.  In that I agree with both you 
and Austin. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

