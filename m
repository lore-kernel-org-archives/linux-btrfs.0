Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rin.romanrm.net ([91.121.86.59]:42660 "EHLO rin.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751901AbeF2Heh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Jun 2018 03:34:37 -0400
Date: Fri, 29 Jun 2018 12:34:34 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: So, does btrfs check lowmem take days? weeks?
Message-ID: <20180629123434.551e3841@natsu>
In-Reply-To: <20180629072210.nxvtwbokblol7xcb@merlins.org>
References: <20180629042707.vrjwbytg6bxmrgjg@merlins.org>
        <6658a593-3b4a-f1ef-f550-2fb951b2517d@gmx.com>
        <20180629052825.tifg2aw7oy3qyyvw@merlins.org>
        <3b240898-a96d-77f6-efb9-f0af81ee0cd1@gmx.com>
        <20180629060657.qrtcxfcy22zkstfw@merlins.org>
        <e9264580-7853-fbfc-2c90-e28e8a45daf5@gmx.com>
        <20180629065903.xgwpvaa2vuiys75r@merlins.org>
        <20180629120954.4bbcd174@natsu>
        <20180629072210.nxvtwbokblol7xcb@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 29 Jun 2018 00:22:10 -0700
Marc MERLIN <marc@merlins.org> wrote:

> On Fri, Jun 29, 2018 at 12:09:54PM +0500, Roman Mamedov wrote:
> > On Thu, 28 Jun 2018 23:59:03 -0700
> > Marc MERLIN <marc@merlins.org> wrote:
> > 
> > > I don't waste a week recreating the many btrfs send/receive relationships.
> > 
> > Consider not using send/receive, and switching to regular rsync instead.
> > Send/receive is very limiting and cumbersome, including because of what you
> > described. And it doesn't gain you much over an incremental rsync. As for
> 
> Err, sorry but I cannot agree with you here, at all :)
> 
> btrfs send/receive is pretty much the only reason I use btrfs. 
> rsync takes hours on big filesystems scanning every single inode on both
> sides and then seeing what changed, and only then sends the differences

I use it for backing up root filesystems of about 20 hosts, and for syncing
large multi-terabyte media collections -- it's fast enough in both.
Admittedly neither of those case has millions of subdirs or files where
scanning may take a long time. And in the former case it's also all from and
to SSDs. Maybe your use case is different where it doesn't work as well. But
perhaps then general day-to-day performance is not great either, so I'd suggest
looking into SSD-based LVM caching, it really works wonders with Btrfs.

-- 
With respect,
Roman
