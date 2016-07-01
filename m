Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:36248 "EHLO
	mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbcGAUjU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Jul 2016 16:39:20 -0400
Received: by mail-wm0-f44.google.com with SMTP id f126so39374182wma.1
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Jul 2016 13:39:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQheg_PqSaf1EZ7_oHkBBwa=CLSifMbW9=sXNLK7asFng@mail.gmail.com>
References: <CADbsYN2RZ9q7pFSawEkWbTXvomAONz60t7b1Hm6f7Mma=veKgQ@mail.gmail.com>
 <CAJCQCtQheg_PqSaf1EZ7_oHkBBwa=CLSifMbW9=sXNLK7asFng@mail.gmail.com>
From: Grey Christoforo <grey@christoforo.net>
Date: Fri, 1 Jul 2016 21:38:59 +0100
Message-ID: <CADbsYN2Y+UaOVZO_kATeomEy6Xho6kMkY-vgAyKMK4w2MV6VCQ@mail.gmail.com>
Subject: Re: btrfs lockup
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 1, 2016 at 7:47 PM, Chris Murphy <lists@colorremedies.com> wrote:
> This is too well trimmed. I'm not seeing the actual oops, can you trim
> this less so it's possible to see what was going on a minute (or 10)
> before this?
I've updated the log[3]. There is no crash per se here, just the
system becomes unresponsive. It looks like some watchdog timer goes
off (NMI watchdog: BUG: soft lockup - CPU#0 stuck for 22s!) and it
becomes usable again for a few seconds before it locks up again and
the process repeats.
>
> About how many subvolumes?
100, maybe more.

The full story here is that my file system was becoming full so I was
using baobab to investigate what was eating my storage. While baobab
was scanning my disk, I happened to be deleting a few things and
running `btrfs balance start...` (as you can see in[3]), but I don't
think the lockups are related to any of that because I saw them
previously with baobab when I was not doing any balance.

I've since removed all of the btrfs subvolumes created by docker and
everything is working fine again with no lockups (so I can't recreate
this anymore).

¬grey

[3]: https://gist.github.com/greyltc/5a9198f402e4e9b9895af0b2a3ead375
