Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([91.121.75.85]:55298 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756746AbdKQFlu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Nov 2017 00:41:50 -0500
Date: Fri, 17 Nov 2017 10:41:48 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Marc MERLIN <marc@merlins.org>
Cc: Holger =?UTF-8?B?SG9mZnN0w6R0dGU=?=
        <holger@applied-asynchrony.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: 4.13.12: kernel BUG at fs/btrfs/ctree.h:1802!
Message-ID: <20171117104148.04986eee@natsu>
In-Reply-To: <20171117001256.GN10969@merlins.org>
References: <20171116170445.24n57phzltgiehj6@merlins.org>
        <20171116170742.vyhxckxrgjzwqyvf@merlins.org>
        <70b25128-d724-4e8e-9835-4a092cf8d5a6@applied-asynchrony.com>
        <20171116214551.vpp4eevs7b4bszjt@merlins.org>
        <2b97e49b-74fd-77c1-a340-8254f8999bb1@applied-asynchrony.com>
        <20171117001256.GN10969@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 16 Nov 2017 16:12:56 -0800
Marc MERLIN <marc@merlins.org> wrote:

> On Thu, Nov 16, 2017 at 11:32:33PM +0100, Holger Hoffstätte wrote:
> > Don't pop the champagne just yet, I just read that apprently 4.14 broke
> > bcache for some people [1]. Not sure how much that affects you, but it might
> > well make things worse. Yeah, I know, wonderful.
> 
> Oh my, that's actually pretty terrible.
> I've just reverted both my machines to 3.13, the last thing I need is more
> btrfs corruption.

Why so far back though, the latest 4.4 and 4.9 are both good series and run
without issues for me since a long time. Or perhaps you meant 4.13 :)

> I'm also starting to question if I should just drop bcache. It does help
> access to a big and slow-ish array, but corruption and periodic btrfs
> full rebuilds is not something I can afford to do timewise :-/

I suggest that you try lvmcache instead. It's much more flexible than bcache,
does pretty much the same job, and has much less of the "hacky" feel to it.

-- 
With respect,
Roman
