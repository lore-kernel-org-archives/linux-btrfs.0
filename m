Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:36826 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719AbbK3URl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Nov 2015 15:17:41 -0500
Received: by igcph11 with SMTP id ph11so72586184igc.1
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Nov 2015 12:17:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <565C625C.7060503@gmail.com>
References: <565C01F1.5030108@oracle.com>
	<565C625C.7060503@gmail.com>
Date: Mon, 30 Nov 2015 13:17:41 -0700
Message-ID: <CAJCQCtQPdzQG0She3yjxAmDmXSAphdMriW11Pe=BMrBRXYTh6Q@mail.gmail.com>
Subject: Re: [RFC] Btrfs device and pool management (wip)
From: Chris Murphy <lists@colorremedies.com>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Anand Jain <anand.jain@oracle.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 30, 2015 at 7:51 AM, Austin S Hemmelgarn
<ahferroin7@gmail.com> wrote:

> General thoughts on this:
> 1. If there's a write error, we fail unconditionally right now.  It would be
> nice to have a configurable number of retries before failing.

I'm unconvinced. I pretty much immediately do not trust a block device
that fails even a single write, and I'd expect the file system to
quickly get confused if it can't rely on flushing pending writes to
that device. Unless Btrfs gets into the business of tracking bad
sectors (failed writes), the block device is a gonor upon a single
write failure, although it could still be reliable for reads.

Possibly reasonable, is the user indicting a preference for what
happens after the max number of write failures is exceeded:

- Volume goes degraded: Faulty block device is ignored entirely,
degraded writes permitted.
- Volumes goes ro: Faulty block device is still used for reads,
degraded writes not permitted.

As far as I know, md and lvm only do the former. And md/mdadm did
recently get the ability to support bad block maps so it can continue
using drives lacking reserve sectors (typically that's the reason for
write failures on conventional rotational drives).



> 2. Similar for read errors, possibly with the ability to ignore them below
> some threshold.

Agreed. Maybe it would be an error rate (set by ratio)?




-- 
Chris Murphy
