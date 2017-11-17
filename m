Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:58461 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753507AbdKQAM4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Nov 2017 19:12:56 -0500
Date: Thu, 16 Nov 2017 16:12:56 -0800
From: Marc MERLIN <marc@merlins.org>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
        <holger@applied-asynchrony.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: 4.13.12: kernel BUG at fs/btrfs/ctree.h:1802!
Message-ID: <20171117001256.GN10969@merlins.org>
References: <20171116170445.24n57phzltgiehj6@merlins.org> <20171116170742.vyhxckxrgjzwqyvf@merlins.org> <70b25128-d724-4e8e-9835-4a092cf8d5a6@applied-asynchrony.com> <20171116214551.vpp4eevs7b4bszjt@merlins.org> <2b97e49b-74fd-77c1-a340-8254f8999bb1@applied-asynchrony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <2b97e49b-74fd-77c1-a340-8254f8999bb1@applied-asynchrony.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 16, 2017 at 11:32:33PM +0100, Holger Hoffstätte wrote:
> Don't pop the champagne just yet, I just read that apprently 4.14 broke
> bcache for some people [1]. Not sure how much that affects you, but it might
> well make things worse. Yeah, I know, wonderful.

Oh my, that's actually pretty terrible.
I've just reverted both my machines to 3.13, the last thing I need is more
btrfs corruption.

I'm also starting to question if I should just drop bcache. It does help
access to a big and slow-ish array, but corruption and periodic btrfs
full rebuilds is not something I can afford to do timewise :-/

> > As for 4.14, the serial console code seems broken though, I can't get login or bash
> > to work anymore on them:
> > [ 2786.305004] INFO: task login:5636 blocked for more than 120 seconds.
> > [ 2786.324648]       Tainted: G     U  W       4.14.0-amd64-stkreg-sysrq-20171018 #1
> > [ 2786.347692] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > [ 2786.371742] login           D    0  5636      1 0xa0020006
> 
> I'm out. :/

Yeah, I didn't expect you to know, or this list even, just warning that 4.14
is not "that great" yet (although that was before the "bcache will corrupt
your stuff", which now makes it "terrible" :( ).

On the plus side, I'm back to 4.13.12 and it hasn't crashed yet, so maybe
4.14 fixed the issue I had (wishful thinking)

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
