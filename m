Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:35787 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045AbcDJPeH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Apr 2016 11:34:07 -0400
Received: by mail-oi0-f54.google.com with SMTP id p188so182755321oih.2
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Apr 2016 08:34:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPmG0jaxZY1d365KGy=HL+e7WNyZ7w6jtT2VJod00KD=JBC=ng@mail.gmail.com>
References: <CALJXSJrdkqau4xWax72xQGBcaONDxWBeDLOn4KD7vP8NKJikDw@mail.gmail.com>
	<CAPmG0jaxZY1d365KGy=HL+e7WNyZ7w6jtT2VJod00KD=JBC=ng@mail.gmail.com>
Date: Sun, 10 Apr 2016 11:34:05 -0400
Message-ID: <CALJXSJpSsxES=SvtscJYCy7J1V37=rhXfWg1DjqU3XpkzJ-M6A@mail.gmail.com>
Subject: Re: csum failed on innexistent inode
From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
To: Henk Slager <eye1tm@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 4, 2016 at 5:42 AM, Henk Slager <eye1tm@gmail.com> wrote:
>
> You might want this patch:
> http://www.spinics.net/lists/linux-btrfs/msg53552.html
>
> As workaround, you can reset the counters on new/healty device with:
>
> btrfs device stats [-z] <path>|<device>
>

I did reset the stats and launched another scrub, and still, since the
logical blocks are the same on both devices and checksum is different,
is really seems like my problem was originally created when I booted
this computer with bad memory (maybe?), could it have been that the
checksum was saved on disk as bad in the first place and BTRFS doesn't
want to read it back?

Is it possible to reset the checksum on those? I couldn't find what
file or metadata the blocks were pointing too.


> >
> > btrfs check:
> > ./btrfs check /dev/mapper/luksbtrfsdata2
> > Checking filesystem on /dev/mapper/luksbtrfsdata2
> > UUID: 805f6ad7-1188-448d-aee4-8ddeeb70c8a7
> > checking extents
> > bad metadata [1453741768704, 1453741785088) crossing stripe boundary
> > bad metadata [1454487764992, 1454487781376) crossing stripe boundary
> > bad metadata [1454828552192, 1454828568576) crossing stripe boundary
> > bad metadata [1454879735808, 1454879752192) crossing stripe boundary
> > bad metadata [1455087222784, 1455087239168) crossing stripe boundary
> > bad metadata [1456269426688, 1456269443072) crossing stripe boundary
> > bad metadata [1456273227776, 1456273244160) crossing stripe boundary
> > bad metadata [1456404234240, 1456404250624) crossing stripe boundary
> > bad metadata [1456418914304, 1456418930688) crossing stripe boundary
>
> Those are false alerts; This patch handles that:
> https://patchwork.kernel.org/patch/8706891/
>

Since those are fakes, I'll just ignore them for now.
