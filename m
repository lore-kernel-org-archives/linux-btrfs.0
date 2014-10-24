Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f171.google.com ([209.85.220.171]:34523 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782AbaJXT6r (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Oct 2014 15:58:47 -0400
Received: by mail-vc0-f171.google.com with SMTP id im17so51688vcb.2
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Oct 2014 12:58:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20141024160703.GG17395@hungrycats.org>
References: <845c0ca8cc78ed97da487bf7f4b7b122@admin.virtall.com>
	<5446BEC0.8070009@siedziba.pl>
	<02A17DFE-290C-4447-99E9-D39480D7A26A@colorremedies.com>
	<5447A5CF.9060405@siedziba.pl>
	<5448C81E.4060701@cn.fujitsu.com>
	<5448E8F0.7070004@gmail.com>
	<pan$d3176$38668d14$9f498698$7cd4113f@cox.net>
	<20141024023529.GD17395@hungrycats.org>
	<CAGfcS_mVJ0WH0rootEHnXxgHVvRD+oYuF988ZLtV9OABM7x4JQ@mail.gmail.com>
	<20141024160703.GG17395@hungrycats.org>
Date: Fri, 24 Oct 2014 15:58:46 -0400
Message-ID: <CAGfcS_mpi1m8TN1dyk6qu2oPqTfeLS=gP_UckM0s8MQ5TV39ng@mail.gmail.com>
Subject: Re: device balance times
From: Rich Freeman <r-btrfs@thefreemanclan.net>
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: Duncan <1i5t5.duncan@cox.net>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 24, 2014 at 12:07 PM, Zygo Blaxell
<ce3g8jdj@umail.furryterror.org> wrote:
>
>         We could also leave this as an option to the user "mount -o
>         degraded-and-I-want-to-lose-my-data", but in my opinion the use
>         case is very, very exceptional.

Well, it is only exceptional if you never shut down during a
conversion to raid1 as far as I understand it.  :)

>
> IMHO the use case is common any time restoring the entire filesystem
> from backups is inconvenient.  That covers a *lot* of users.  I never
> have a machine with more than 50% of its raw disk space devoted to btrfs
> because I need raw space on the disk to do mkfs+rsync from the broken
> read-only btrfs filesystems.

The problem is that if you want btrfs raid1 and you ALSO want to have
an extra set of spares for copying your entire RAID1 to something
else, you're talking about a lot of extra disk space.  I really don't
want to maintain a SAN just in case I have a btrfs problem.  :)

I realize things are still somewhat experimental now, but we need to
at least think about how things will work long-term.  Copying all your
data to another filesystem and re-creating the btrfs filesystem isn't
really a good recovery mode.

Restoring from backups is also becoming increasingly difficult.  IO
bandwidth just has not kept pace with disk capacity.  It can take the
better part of a day to copy a multi-TB array, and if you need to copy
it two ways you have to double the time, not to mention having
multiple TB of disks lying around.

--
Rich
