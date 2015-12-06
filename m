Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:34360 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754458AbbLFUzj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Dec 2015 15:55:39 -0500
Received: by igvg19 with SMTP id g19so67146841igv.1
        for <linux-btrfs@vger.kernel.org>; Sun, 06 Dec 2015 12:55:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56644785.4090702@gmx.com>
References: <20151204120529.37E47D5A28@emkei.cz>
	<20151204130758.GR8775@carfax.org.uk>
	<1449286104.18841.14.camel@scientia.net>
	<pan$7e229$ce87d3b$b8d75c44$337e15c7@cox.net>
	<1449366680.3183.37.camel@scientia.net>
	<56644785.4090702@gmx.com>
Date: Sun, 6 Dec 2015 13:55:38 -0700
Message-ID: <CAJCQCtQ7LWN6m-HDL96KOLh2vfhPKCZjemqCz3QWTOo7wF3Ddw@mail.gmail.com>
Subject: Re: attacking btrfs filesystems via UUID collisions?
From: Chris Murphy <lists@colorremedies.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Christoph Anton Mitterer <calestyo@scientia.net>,
        Duncan <1i5t5.duncan@cox.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Dec 6, 2015 at 7:34 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:

> But just as you mentioned, it *IS* a real problem, and we should need to
> enhance it.

LVM sorta avoids the problem, because its snapshots aren't active by
default so the underlying fs (and its UUID and superblock) don't
appear to the kernel.

In no order:

1. better practices, we really need to tell users, and documentation
writers, that using dd (or variant) to copy Btrfs volumes has a
consequence and should not be used to make copies.

2. Btrfs needs a better way to make a copy of a volume when there are
snapshots (including even rw snapshots); e.g. permit send/receive to
work on rw snapshots if the fs is ro mounted; e.g. a way to do
"recursive" send/receive.

3. Some way to fail gracefully, when there's ambiguity that cannot be
resolved. Once there are duplicate devs (dd or lvm snapshots, etc)
then there's simply no way to resolve the ambiguity automatically, and
the volume should just refuse to rw mount until the user resolves the
ambiguity. I think it's OK to fallback to ro mount (maybe) by default
in such a case rather than totally fail to mount.



> I'd like to see how LVM/DM behaves first, at least as a reference if they
> are really so safe.
> For example, I have a whole disk as the following configuration:
>
> 0         10G         20G
> | test_lv |           |
> ----------------
> |  test_vg     |
> -----------------------
> |       test_pv       |
> -----------------------
> |    /dev/sdb         |
> -----------------------
>
> If I did a dd copy of /dev/sdb to /dev/sdc,
> what will pv/vg/lv rescan show if test_pv/vg/lv is already active?
> And what will rescan show if they are not active? Or after a reboot?

I haven't tested it recently but my recollection is that it flat
refused to activate the VG/LV whenever two PV's with identical UUIDs
were visible, that is, it would not use either PV until I resolved the
ambiguity by physical PV removal, or using pvremove, or using wipefs.



-- 
Chris Murphy
