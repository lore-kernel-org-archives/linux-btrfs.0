Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f51.google.com ([209.85.213.51]:40639 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755887AbaJXK60 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Oct 2014 06:58:26 -0400
Received: by mail-yh0-f51.google.com with SMTP id t59so121230yho.38
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Oct 2014 03:58:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20141024023529.GD17395@hungrycats.org>
References: <845c0ca8cc78ed97da487bf7f4b7b122@admin.virtall.com>
	<5446BEC0.8070009@siedziba.pl>
	<02A17DFE-290C-4447-99E9-D39480D7A26A@colorremedies.com>
	<5447A5CF.9060405@siedziba.pl>
	<5448C81E.4060701@cn.fujitsu.com>
	<5448E8F0.7070004@gmail.com>
	<pan$d3176$38668d14$9f498698$7cd4113f@cox.net>
	<20141024023529.GD17395@hungrycats.org>
Date: Fri, 24 Oct 2014 06:58:25 -0400
Message-ID: <CAGfcS_mVJ0WH0rootEHnXxgHVvRD+oYuF988ZLtV9OABM7x4JQ@mail.gmail.com>
Subject: Re: device balance times
From: Rich Freeman <r-btrfs@thefreemanclan.net>
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: Duncan <1i5t5.duncan@cox.net>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 23, 2014 at 10:35 PM, Zygo Blaxell
<ce3g8jdj@umail.furryterror.org> wrote:
>
>                 - single profile: we can tolerate zero missing disks,
>                 so we don't allow rw mounts even if degraded.
>

That seems like the wrong logic here.  By all means mount read-only by
default for safety, but there should be a way to force a read-write
mount on any filesystem, precisely because the RAID modes can be mixed
and even if you lose two devices on a RAID1 system not ALL the data is
lost if you have more than two drives.

By all means return an error when reading a file that is completely
missing.  By all means have an extra fsck mode that goes ahead and
deletes all the missing files (assuming it has metadata) or perhaps
moves them all to a new "lost+notfound" subvolume or something.

Indeed, if the lost device just happens to not actually contain any
data you might be lucky and not lose any data at all when losing a
single device in a filesystem that entirely uses the single profile.
That would be a bit of an edge case though, but one that is
automatically handled if you give the admin the ability to force
read-write/etc.

--
Rich
