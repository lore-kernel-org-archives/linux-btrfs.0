Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f42.google.com ([209.85.213.42]:57131 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932237AbaJWOsA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Oct 2014 10:48:00 -0400
Received: by mail-yh0-f42.google.com with SMTP id t59so1267497yho.1
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Oct 2014 07:47:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$19856$ee791297$ceeef1ce$27ae8dc@cox.net>
References: <20141016113337.GC22943@twin.jikos.cz> <20141020163403.GW22943@twin.jikos.cz>
 <pan$32992$bbc3a80d$ad912ad2$31fcc5ce@cox.net> <CAGfcS_nTbXQQTOC+QcBX8dbwk18Qbf-+JonQSw4WP6MOFg2z7A@mail.gmail.com>
 <pan$19856$ee791297$ceeef1ce$27ae8dc@cox.net>
From: Tobias Geerinckx-Rice <tobias.geerinckx.rice@gmail.com>
Date: Thu, 23 Oct 2014 16:47:19 +0200
Message-ID: <CAKFHe2RxEZo25+3ye6fLmfadSbVZ5rri8h_FPt5iAy3-AiSqPQ@mail.gmail.com>
Subject: Re: Poll: time to switch skinny-metadata on by default?
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 22 October 2014 04:08, Duncan <1i5t5.duncan@cox.net> wrote:

> Since the kernel has code for both "fat" metadata and skinny-metadata,
> they can exist side-by-side and the kernel will use whichever code is
> appropriate.

I understand that the fat extent code will probably never be removed
for compatibility reasons, but do wonder why it's still the default.
Caution?

Petr Janecek's balancing problem [1] and similar bugs aside: is there
a functional reason to prefer "fat" over skinny metadata for future
file systems?

Regards,

T G-R

[1] http://www.spinics.net/lists/linux-btrfs/msg38443.html
