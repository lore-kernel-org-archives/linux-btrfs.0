Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:63282 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab3L1TwB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Dec 2013 14:52:01 -0500
Received: by mail-ie0-f176.google.com with SMTP id at1so10722125iec.21
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Dec 2013 11:52:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CABR0jES_40xmVxi21+VUMzT_2ZuFWs9kUPfZAPZODq0rWrB0ug@mail.gmail.com>
References: <20131228171943.GE19863@merlins.org>
	<20131228173730.GA7234@carfax.org.uk>
	<CAELSAVa=oVzrLnSSk+vnKQF46F7U5n6o8Nw9VGXkPQNCR2SVsA@mail.gmail.com>
	<CABR0jES_40xmVxi21+VUMzT_2ZuFWs9kUPfZAPZODq0rWrB0ug@mail.gmail.com>
Date: Sat, 28 Dec 2013 21:52:00 +0200
Message-ID: <CAELSAVY+J1GYuRDHwUZ882OVchqXk9ES9EJp89HQofC8m00uaQ@mail.gmail.com>
Subject: Re: Is anyone using btrfs send/receive for backups instead of rsync?
From: Emil Karlson <jekarlson@gmail.com>
To: Richard Michael <rmichael@edgeofthenet.org>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Emil, your bug report mentions the subvolume journal is different, and
> not anything about silent content differences on file data (images,
> databases, etc.) as you mention above.  How are they related?

systemd-journald is a logging daemon in the userspace that has nothing
to do with filesystem journal.

> Also, how is the journal different on the receive-side?  Is it "just"
> a size/allocation issue, as David commented on the bug report; or is
> the content actually different? For example, can it still be used to
> recover the filesystem post-crash?  What does "fixed in V2" mean:
> BTRFSv2 ?

Send stream format specification V2.

I used sha1sum (stated also in the report) so contents are actually different.
