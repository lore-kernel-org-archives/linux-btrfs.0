Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:34628 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757363AbcAYVMH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jan 2016 16:12:07 -0500
Received: by mail-ig0-f180.google.com with SMTP id ik10so43554599igb.1
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Jan 2016 13:12:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56A650AC.6050901@gmail.com>
References: <525D830B-C5A6-40DC-932C-B283A7FB8932@me.com>
	<56A650AC.6050901@gmail.com>
Date: Mon, 25 Jan 2016 14:12:05 -0700
Message-ID: <CAJCQCtSBNpaMFDpRQOEAVV2d_okrWVv_OgW=J10uMaRiRThe3g@mail.gmail.com>
Subject: Re: suspected BTRFS errors resulting in file system becoming unrecovable
From: Chris Murphy <lists@colorremedies.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: WillIam Thorne <will.thorne@me.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 25, 2016 at 9:43 AM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
> Now, just a general caution: Avoid using USB storage for persistent online
> storage, there's just to many things that can go wrong, and quite a few USB
> storage controllers are absolute crap.

Yes. Lately, USB 3 stuff is better in that the speeds are approaching
rocket science, so if the manufacturer doesn't get it right, things
rapidly implode. But as far as getting useful error messages and such,
it's almost like the state of networking 20 years ago. You just had to
follow the rules and swap stuff out if it wasn't working. Error codes
might mean something to a developer but they're useless for mortal
users.

I really think USB hubs help fix a lot of USB related problems, even
when it's not a power related problem. Currently I'm using internal
SATA in a NUC for the primary storage, but use send/receive to two
separate raid1 volumes that are USB drives. I can balance/scrub, and
read/write to any and all drives with no problems since getting a
dyconn "industrial" (probably a design term, it's aluminum not
plastic) hub. Before that, one drive or another would just
intermittently reset, usually to no ill effect, but once it wigged
out, vanished, and reappeared as a completely different /dev/sdx
device. The enclosures are crap, the manufacturer (ASMedia Technology
Inc.) didn't bother to fully populate all of the USB descriptors and
it doesn't pass through physical sector size properly, or report max
power correctly, etc.

-- 
Chris Murphy
