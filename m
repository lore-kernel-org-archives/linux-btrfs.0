Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f182.google.com ([209.85.160.182]:45969 "EHLO
	mail-yk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755474AbaKSSfW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Nov 2014 13:35:22 -0500
Received: by mail-yk0-f182.google.com with SMTP id 131so533560ykp.13
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Nov 2014 10:35:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <546CB531.2060509@ubuntu.com>
References: <CAE8gLhnLUBJmN=3n1SVTc3y0zbBAxSBXtMxe7rhANtwC+3dCow@mail.gmail.com>
	<pan$f02e0$7a5e2052$d1925753$4ad202f9@cox.net>
	<54699CC7.1050909@swiftspirit.co.za>
	<546A46A5.8030603@inwind.it>
	<CAE8gLh=VubBbZdeKTAuWRjOxPF7C+ouUeeVvmGfT2ckYWGhQVA@mail.gmail.com>
	<CAE8gLh=Lf+z2B_9EXQM_ODSOa5HZsFpFMB=kKGmQXJSjYdy5kg@mail.gmail.com>
	<27BDAC3B-789C-4477-B065-E703CE425F54@colorremedies.com>
	<546B68F8.6080008@ubuntu.com>
	<FC0BA13C-21E3-44DD-A87C-4BEAE4FBF9EA@colorremedies.com>
	<546BA96D.4050805@ubuntu.com>
	<2A57F99C-80AA-4FD4-AA41-57F02AD4E1A2@colorremedies.com>
	<546CB531.2060509@ubuntu.com>
Date: Wed, 19 Nov 2014 11:35:21 -0700
Message-ID: <CAJCQCtR6CZq2iz4_cP5Es4HHGsZiOmo55w8iy6MT+cEN0BE0yQ@mail.gmail.com>
Subject: Re: BTRFS messes up snapshot LV with origin
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 19, 2014 at 8:20 AM, Phillip Susi <psusi@ubuntu.com> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 11/18/2014 9:54 PM, Chris Murphy wrote:
>> Why is it silly? Btrfs on a thin volume has practical use case
>> aside from just being thinly provisioned, its snapshots are block
>> device based, not merely that of an fs tree.
>
> Umm... because one of the big selling points of btrfs is that it is in
> a much better position to make snapshots being aware of the fs tree
> rather than doing it in the block layer.

This is why we have fsfreeze before taking block level snapshots. And
I point out that consistent snapshots with Btrfs have posed challenges
too, there's a recent fstest "snapshoting after file write + truncate"
for this reason.

A block layer snapshot will snapshot the entire file system, not just
one tree. We don't have a way in Btrfs to snapshot the entire volume.
Considering how things still aren't exactly stable yet, in particular
with many snapshots, it's not unreasonable to want to freeze then
snapshot the entire volume before doing some possibly risky testing or
usage where even a Btrfs snapshot doesn't protect your entire volume
should things go wrong.

>
>
> So it is kind of silly in the first place to be using lvm snapshots
> under btrfs, but it is is doubly silly to use lvm for snapshots, and
> btrfs for the mirroring rather than lvm.  Pick one layer and use it
> for both functions.  Even if that is lvm, then it should also be
> handling the mirroring.


Thin volumes are more efficient. And the user creating them doesn't
have to mess around with locating physical devices or possibly
partitioning them. Plus in enterprise environments with lots of
storage and many different kinds of use cases, even knowledable users
aren't always granted full access to the physical storage anyway. They
get a VG to play with, or now they can have a thin pool and only
consume on storage what is actually used, and not what they've
reserved. You can mkfs a 4TG virtual size volume, while it only uses
1MB of physical extents on storage. And all of that is orthogonal to
using XFS or Btrfs which again comes down to use case. And whether I'd
have LVM mirror or Btrfs mirror is again a question of use case, maybe
I'm OK with LVM mirroring and I just get the rare corrupt file warning
and that's OK. In another use case, corruption isn't OK, I need higher
availability of known good data therefore I need Btrfs doing the
mirroring.

So I find your argument thus far uncompelling.


Chris Murphy
