Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f51.google.com ([209.85.213.51]:34458 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbaLWWJI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Dec 2014 17:09:08 -0500
Received: by mail-yh0-f51.google.com with SMTP id a41so3540624yho.38
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Dec 2014 14:09:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141223211605.GC436@hungrycats.org>
References: <CANcfdL39NWs=go4LVY8vuqp7bqkKuoop2arzpJoEX7TY4wSGYw@mail.gmail.com>
	<CAJCQCtQ-DkJh5tg1gWuv6EW=enm66jx16jrtXhXiPvhauRnJ9w@mail.gmail.com>
	<20141223211605.GC436@hungrycats.org>
Date: Tue, 23 Dec 2014 15:09:07 -0700
Message-ID: <CAJCQCtTK2OinQZakArtX4BD=JAz6UJr=dhc2xUbcqJJL1v6Kkw@mail.gmail.com>
Subject: Re: Uncorrectable errors on RAID-1?
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 23, 2014 at 2:16 PM, Zygo Blaxell <zblaxell@furryterror.org> wrote:
> On Sun, Dec 21, 2014 at 05:25:47PM -0700, Chris Murphy wrote:
>> For the kernel to automatically fix
>> bad sectors by overwriting them, the drive needs to explicitly report
>> read errors. If the SCSI command timer value is shorter than the
>> drive's error recovery, the SATA link might get reset before the drive
>> reports the read error and then uncorrected errors will persist
>> instead of being automatically fixed.
>
> Is there a way to tell the kernel to go ahead and assume that all timeouts
> are effectively read errors?

The timer in /sys is a kernel command timer, it's not a device timer
even though it's pointed at a block device. You need to change that
from 30 to something higher to get the behavior you want. It doesn't
really make sense to say, timeout in 30 seconds, but instead of
reporting a timeout, report it as a read error. They're completely
different things.

There are all sorts of errors listed in libata so for all of them to
get dumped into a read error doesn't make sense. A lot of those errors
don't report back a sector, and the key part of the read error is what
sector(s) have the problem so that they can be fixed. Without that
information, the ability to fix it is lost. And it's the drive that
needs to report this.


> For a simple non-removable hard disk (i.e.
> not removable and not optical), that seems like a reasonable workaround
> for an assortment of firmware brokenness.

Oven doesn't work, so lets spray gasoline on it and light it and the
kitchen on fire so that we can cook this damn pizza! That's what I
just read. Sorry. It doesn't seem like a good idea to me to map all
errors as read errors.


> I just did a quick survey of random drives here and found less than 10%
> support "smartctl -l scterc".  A lot of server drives (or at least the
> drives that shipped in servers) don't have it, but laptop drives do.
> Drives with firmware that has horrifying known bugs do also have this
> feature.  :-P

Any decent server SATA drive should support SCT ERC. The inexpensive
WDC Red drives for NAS's all have it and by default are a reasonable
70 deciseconds last time I checked.

It might be that you're using SAS drives? In that case they may have
something different than SCT ERC that serves the same purpose, but I
don't have any SAS drives here to check this. I'd expect any SAS drive
already has short error recoveries by default, but that expectation
might be flawed.

Chris Murphy
