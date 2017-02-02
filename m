Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zaphod.cobb.me.uk ([213.138.97.131]:60372 "EHLO
        zaphod.cobb.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751039AbdBBKwa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Feb 2017 05:52:30 -0500
Received: from black.home.cobb.me.uk (unknown [192.168.0.205])
        by zaphod.cobb.me.uk (Postfix) with ESMTP id 056AC9B85D
        for <linux-btrfs@vger.kernel.org>; Thu,  2 Feb 2017 10:52:27 +0000 (GMT)
Received: from [192.168.0.211] (novatech.home.cobb.me.uk [192.168.0.211])
        by black.home.cobb.me.uk (Postfix) with ESMTPS id D1EAB5FBB3
        for <linux-btrfs@vger.kernel.org>; Thu,  2 Feb 2017 10:52:26 +0000 (GMT)
Subject: Re: btrfs receive leaves new subvolume modifiable during operation
To: linux-btrfs@vger.kernel.org
References: <1485905578.6441.20.camel@gmail.com>
 <pan$4ecd$16bc5e8e$14657c4$261368ad@cox.net>
 <4edfd08e-8d7f-d8d7-bdea-0589b46e4d2b@gmail.com>
 <7ead5d42-9c00-b2df-3fbf-5b8f287760f6@cobb.uk.net>
 <pan$16525$cf7fe24b$7c044b9$74b32f27@cox.net>
 <5c503d69-aaed-680f-de30-75a7323bc753@cobb.uk.net>
 <pan$5f1de$80937cf$9c306858$cafb9e40@cox.net>
From: Graham Cobb <g.btrfs@cobb.uk.net>
Message-ID: <1b69d1a8-c08b-c9f3-c95b-1d7d71c7d642@cobb.uk.net>
Date: Thu, 2 Feb 2017 10:52:26 +0000
MIME-Version: 1.0
In-Reply-To: <pan$5f1de$80937cf$9c306858$cafb9e40@cox.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/02/17 00:02, Duncan wrote:
> If it's a workaround, then many of the Linux procedures we as admins and 
> users use every day are equally workarounds.  Setting 007 perms on a dir 
> that doesn't have anything immediately security vulnerable in it, simply 
> to keep other users from even potentially seeing or being able to write 
> to something N layers down the subdir tree, is standard practice.

No. There is no need to normally place a read-only snapshot below a
no-execute directory just to prevent write access to it. That is not
part of the admin's expectation.

> Which is my point.  This is no different than standard security practice, 
> that an admin should be familiar with and using without even having to 
> think about it.  Btrfs is simply making the same assumptions that 
> everyone else does, that an admin knows what they are doing and sets the 
> upstream permissions with that in mind.  If they don't, how is that 
> btrfs' fault?

Because btrfs intends the receive snapshot to be read-only. That is the
expectation of the sysadmin. It is an important and useful feature which
makes send/receive very useful for creating
user-readable-but-not-modifiable backups (without it, send/receive are
useful for many things but less useful for creating backups). That
feature has a bug.

Just because you don't personally use the feature, doesn't mean it isn't
a bug! Many of us do rely on that feature.

Even though it is security-related, I agree it isn't the highest
priority btrfs bug. It can probably wait until receive is being worked
on for other reasons. But if it isn't going to be fixed any time soon,
it should be documented in the Wiki and the man page, with the suggested
workround for anyone who needs to make sure the receive won't be
tampered with.
