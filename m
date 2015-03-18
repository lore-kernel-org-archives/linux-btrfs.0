Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f51.google.com ([209.85.213.51]:35141 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362AbbCRXvA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Mar 2015 19:51:00 -0400
Received: by yhle43 with SMTP id e43so8216772yhl.2
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Mar 2015 16:51:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <550A08AC.7070506@graphitesystems.com>
References: <5509E34F.6010504@graphitesystems.com>
	<CAJCQCtSmV63H4OnEgv2ZXSFq4s8npEGmDxUBDO5dHb7pmoC0zw@mail.gmail.com>
	<5509F08E.6070702@graphitesystems.com>
	<CAJCQCtQU=KzNqY=MTdqET5-J2JpDrS+O9EE50o9aXbRCJHU+xQ@mail.gmail.com>
	<550A08AC.7070506@graphitesystems.com>
Date: Wed, 18 Mar 2015 17:50:59 -0600
Message-ID: <CAJCQCtTua1a0dUZkGrkJgVvNe894d22VT-xY-Kq8s3TDFgr0xw@mail.gmail.com>
Subject: Re: syntax for deleting subvolumes?
From: Chris Murphy <lists@colorremedies.com>
To: K Richard Pixley <rpixley@graphitesystems.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 18, 2015 at 5:22 PM, K Richard Pixley
<rpixley@graphitesystems.com> wrote:
> Most of the uses I have for btrfs involve fairly dynamic use of snapshots,
> typically by non-root users. That's what brought me to btrfs in the first
> place and continues to be the biggest driver for me.

By default, none privileged users can create subvolumes and snapshots,
but they can't delete them. User deletion of subvolumes requires a
mount option to enable. I'm not sure if this mount option exposes all
subvolumes to none privileged users' ability to delete. Eventually, I
think the idea is to make subvolumes behave even more like
directories. Right now that's largely the case but the line needs to
be blurred a bit more.


> Because of this, the top level file system would need to be mounted pretty
> much constantly, which essentially removes any benefit from the redundant
> top level subvol.  It's just a nuisance for my applications.  And most of my
> applications try very hard to avoid mounting the snapshots.  That takes too
> much time and isn't reentrant.

User subvolumes/snapshots nested under the home subvolume aren't being
proscribed. It's just that doing this out of the gate with an
installation could lead to unexpected results.

Realize that snapshots are non-recursive for any nested
subvol/snapshots. So by virtue of your users creating subvols or
snapshots in their own home directory, if you snapshot home, *none* of
their subvolumes (including their snapshots) will be snapshot. And
that means they're excluded from btrfs send/receive as well. So long
as you and users know this, it's fine to nest them.


>
> It seems to me that it depends on whether you think of snapshots as a system
> admin sort of facility or as a user facility.  As a system admin facility,
> you're probably right.  But as a user level facility, I want to be able to
> snapshot before making a change to a tree full of source code and
> (re)building it all over again.  I may want to keep my new build, but I may
> want to flush it and return to known good state.  It's pretty easy to open
> that facility up to non-root users but the easiest way to do that that I've
> found is to use a single file system on root mounted directly.  For an
> individual user, this can easily save hours and hundreds of gigabytes.  For
> automated build systems, it can mean a few orders of magnitude difference in
> typical build times.

Sure. The near equivalent to a btrfs subvolume is a new file system,
and creating new file systems is not typically a user facility. A
btrfs subvolume is a separate fs tree, not a completely separate file
system, so it's sorta something in between that of a directory and a
new separate file system. For example inode counts start over. So two
different files in two subvolumes can have the same inode number.

So I'm not disputing the use case you've come up with, just that it's
going to take some consideration of all the myriad consequences of the
current state.

And for that matter, definitely don't depend on EL kernels for serious
Btrfs use. Btrfs is a tech preview. The latest features and bug fixes
will be in much newer stable kernels, and there's been a metric
shitton of changes since 3.10.


> It's not clear to me yet how to set machines up this way from kickstart,
> which makes this scheme look like an impediment, rather than a feature.  But
> maybe all I need is an easy way to shut it off and get the more familiar
> arrangement.

I'm fairly certain Anaconda considers any defined mount point to be
cause to create a subvolume. Just like for on LVM, a specific mount
point causes an LV to be created; and for Standard Partitions each
mount point is a separate partition.



-- 
Chris Murphy
