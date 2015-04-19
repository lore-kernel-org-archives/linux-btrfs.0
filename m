Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:38895 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013AbbDSUdF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 Apr 2015 16:33:05 -0400
Received: by igbhj9 with SMTP id hj9so46325361igb.1
        for <linux-btrfs@vger.kernel.org>; Sun, 19 Apr 2015 13:33:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <moda0c-jgd.ln1@hurikhan77.spdns.de>
References: <1429312124.8371.62.camel@scientia.net>
	<u6ca0c-12c.ln1@hurikhan77.spdns.de>
	<CAJCQCtRCvO5hE1Fo6Y=2rk7Amg6KQtm2gcUvFQTu2r=9kErvNQ@mail.gmail.com>
	<moda0c-jgd.ln1@hurikhan77.spdns.de>
Date: Sun, 19 Apr 2015 14:33:04 -0600
Message-ID: <CAJCQCtT758Se4=xRt1D0S0uj7FFA8H1riOebXyCwu5iV-ojXdw@mail.gmail.com>
Subject: Re: how to clone a btrfs filesystem
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Apr 18, 2015 at 10:36 AM, Kai Krakow <hurikhan77@gmail.com> wrote:

> I wonder if one could split mirrors in btrfs... Read:
>
> btrfs device add the new device, set the raid policy for data, meta data,
> and system to raid-1, balance, and then unmount and detach one of the
> devices.
>
> I'm not sure how to get out of the degraded state then. Is it possible to
> simply resort from raid-1 to single raid policy again and remove the missing
> device from the pool?

Not currently. It requires a balance -dconvert=single
-mconvert=single/DUP --force, and it's not efficient, it rewrites the
whole volume. It cannot be paused, canceled or otherwise interrupted
without losing the ability to ever write to the volume again.


> I guess there's one caveat: The signature of both devices will then indicate
> they are belonging to the same pool, making it impossible to ever attach
> those to the same system again without causing trouble for your data. If one
> could change that to make both devices distinct filesystems, it could be
> used to implement a "btrfs filesystem clone" call.

Like ext4 and XFS metadata checksums, the fs UUID is found throughout
the fs metadata. So "breaking" a raid1 back to single ought to include
(and depend on) a feature to change UUIDs in metadata. That code
already exists somewhere because btrfs seed device create, add new
device, delete see device causes the source UUID to be replaced with
the destination UUID in the course of migrating the data. So it can be
done, there just isn't a general purpose method of rewriting only
metadata.

-- 
Chris Murphy
