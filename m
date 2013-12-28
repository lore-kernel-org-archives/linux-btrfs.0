Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:63714 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab3L1Tf1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Dec 2013 14:35:27 -0500
Received: by mail-pd0-f179.google.com with SMTP id r10so10087259pdi.38
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Dec 2013 11:35:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAELSAVa=oVzrLnSSk+vnKQF46F7U5n6o8Nw9VGXkPQNCR2SVsA@mail.gmail.com>
References: <20131228171943.GE19863@merlins.org> <20131228173730.GA7234@carfax.org.uk>
 <CAELSAVa=oVzrLnSSk+vnKQF46F7U5n6o8Nw9VGXkPQNCR2SVsA@mail.gmail.com>
From: Richard Michael <rmichael@edgeofthenet.org>
Date: Sat, 28 Dec 2013 14:34:47 -0500
Message-ID: <CABR0jES_40xmVxi21+VUMzT_2ZuFWs9kUPfZAPZODq0rWrB0ug@mail.gmail.com>
Subject: Re: Is anyone using btrfs send/receive for backups instead of rsync?
To: Emil Karlson <jekarlson@gmail.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Dec 28, 2013 at 1:01 PM, Emil Karlson <jekarlson@gmail.com> wrote:
> There are also silent content missmatches on some subset of files that
> are not linearly written (vm images, databases and such).
>
> https://bugzilla.kernel.org/show_bug.cgi?id=66941

Can anyone elaborate on this?

Emil, your bug report mentions the subvolume journal is different, and
not anything about silent content differences on file data (images,
databases, etc.) as you mention above.  How are they related?

Also, how is the journal different on the receive-side?  Is it "just"
a size/allocation issue, as David commented on the bug report; or is
the content actually different? For example, can it still be used to
recover the filesystem post-crash?  What does "fixed in V2" mean:
BTRFSv2 ?

Backup by snapshot+send/receive is my primary BTRFS use-case, so I'm
curious about details/pitfalls.

Regards,
Richard

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
