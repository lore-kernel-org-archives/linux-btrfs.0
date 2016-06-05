Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f47.google.com ([209.85.213.47]:34734 "EHLO
	mail-vk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbcFEUjQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Jun 2016 16:39:16 -0400
Received: by mail-vk0-f47.google.com with SMTP id e4so39881365vkb.1
        for <linux-btrfs@vger.kernel.org>; Sun, 05 Jun 2016 13:39:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1465005092.6648.39.camel@scientia.net>
References: <1464819934.6742.71.camel@scientia.net> <d500a743-7a39-8ec5-c6ce-e5a3c70ede91@nv-systems.net>
 <1464975482.6679.11.camel@scientia.net> <6f18c0d1-8ac5-c325-0ba8-ffb949c54554@gmail.com>
 <1465005092.6648.39.camel@scientia.net>
From: Henk Slager <eye1tm@gmail.com>
Date: Sun, 5 Jun 2016 22:39:13 +0200
Message-ID: <CAPmG0jZGY841PNwYi6gaun38gjN83=OMQB0r_UiVrdL9iY2J9Q@mail.gmail.com>
Subject: Re: btrfs
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> > - OTOH, defrag seems to be viable for important use cases (VM
>> > images,
>> >   DBs,... everything where large files are internally re-written
>> >   randomly).
>> >   Sure there is nodatacow, but with that one effectively completely
>> >   looses one of the core features/promises of btrfs (integrity by
>> >   checksumming)... and as I've showed in an earlier large
>> > discussion,
>> >   none of the typical use cases for nodatacow has any high-level
>> >   checksumming, and even if, it's not used per default, or doesn't
>> > give
>> >   the same benefits at it would on the fs level, like using it for
>> > RAID
>> >   recovery).
>> The argument of nodatacow being viable for anything is a pretty
>> significant secondary discussion that is itself entirely orthogonal
>> to
>> the point you appear to be trying to make here.
>
> Well the point here was:
> - many people (including myself) like btrfs, it's
>   (promised/future/current) features
> - it's intended as a general purpose fs
> - this includes the case of having such file/IO patterns as e.g. for VM
>   images or DBs
> - this is currently not really doable without loosing one of the
>   promises (integrity)
>
> So the point I'm trying to make:
> People do probably not care so much whether their VM image/etc. is
> COWed or not, snapshots/etc. still work with that,... but they may
> likely care if the integrity feature is lost.
> So IMHO, nodatacow + checksumming deserves to be amongst the top
> priorities.

Have you tried blockdevice/HDD caching like bcache or dmcache in
combination with VMs on BTRFS?  Or ZVOL for VMs in ZFS with L2ARC?
I assume the primary reason for wanting nodatacow + checksumming is to
avoid long seektimes on HDDs due to growing fragmentation of the VM
images over time. But even if you have nodatacow + checksumming
implemented, it is then still HDD access and a VM imagefile itself is
not guaranteed to be continuous.
It is clear that for VM images the amount of extents will be large
over time (like 50k or so, autodefrag on), but with a modern SSD used
as cache, it doesn't matter. It is still way faster than just HDD(s),
even with freshly copied image with <100 extents.
