Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:36056 "EHLO
	mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233AbcAUQ0F (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jan 2016 11:26:05 -0500
Received: by mail-io0-f182.google.com with SMTP id g73so60842840ioe.3
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Jan 2016 08:26:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <alpine.OSX.2.20.1601190308520.34954@ioko>
References: <alpine.OSX.2.20.1601190308520.34954@ioko>
Date: Thu, 21 Jan 2016 11:26:03 -0500
Message-ID: <CAGfcS_=0Fu96a=SZwYkkV7Ukk7Jc_8c6sn8ZeiacocTcRbMp8w@mail.gmail.com>
Subject: Re: FS corruption when mounting non-degraded after mounting degraded
From: Rich Freeman <r-btrfs@gw.thefreemanclan.net>
To: Rian Hunter <rian@thelig.ht>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 19, 2016 at 6:28 AM, Rian Hunter <rian@thelig.ht> wrote:
> In my raid6 setup, a disk was soft-failing on me. I pulled the disk,
> inserted a new one, mounted degraded, then did btrfs-replace while running
> some RW jobs on the FS.
>
> My jobs were taking too long. It seems like raid6 btrfs-replace without the
> source disk is not very fast. So I unmounted the FS, inserted the
> soft-failing disk again, remounted normally (non-degraded) and restarted the
> (now much faster) btrfs-replace.
>
> I checked on the status sometime later and there were hundreds if not
> thousands of "transid verify failure" messages in my dmesg. Additionally the
> btrfs-replace operation had outright failed.
>

I think the bottom line here is the same thing that everybody runs
into when they have LVM snapshots of btrfs devices.

Btrfs doesn't record any kind of timestamp or generation number of
anything like that when it touches data on a drive, or if it does it
isn't granular enough or it isn't being used when mounting drives to
ensure consistency.

So, btrfs sees a bunch of partitions that at one time were consistent
and assumes that they must still be consistent.  If they aren't
consistent, almost anything can go wrong.

The bottom line is that anytime you mount btrfs in anything other than
read-only mode, any partitions that may have been associated with that
filesystem which aren't mounted should be treated like the plague.
Don't let btrfs ever mount them again, because it will be all too
willing to try and you'll likely lose data if it happens.

There was a long thread on this not long ago and I don't know what the
final outcome of it was.  It would be ideal if btrfs could detect if a
partition is out-of-date and not attempt to mount it, except perhaps
as read-only in some kind of recovery mode.

--
Rich
