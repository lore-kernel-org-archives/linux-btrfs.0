Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:36644 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752683AbeF2HWP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Jun 2018 03:22:15 -0400
Date: Fri, 29 Jun 2018 00:22:10 -0700
From: Marc MERLIN <marc@merlins.org>
To: Roman Mamedov <rm@romanrm.net>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <20180629072210.nxvtwbokblol7xcb@merlins.org>
References: <20180629042707.vrjwbytg6bxmrgjg@merlins.org>
 <6658a593-3b4a-f1ef-f550-2fb951b2517d@gmx.com>
 <20180629052825.tifg2aw7oy3qyyvw@merlins.org>
 <3b240898-a96d-77f6-efb9-f0af81ee0cd1@gmx.com>
 <20180629060657.qrtcxfcy22zkstfw@merlins.org>
 <e9264580-7853-fbfc-2c90-e28e8a45daf5@gmx.com>
 <20180629065903.xgwpvaa2vuiys75r@merlins.org>
 <20180629120954.4bbcd174@natsu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180629120954.4bbcd174@natsu>
Subject: Re: So, does btrfs check lowmem take days? weeks?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 29, 2018 at 12:09:54PM +0500, Roman Mamedov wrote:
> On Thu, 28 Jun 2018 23:59:03 -0700
> Marc MERLIN <marc@merlins.org> wrote:
> 
> > I don't waste a week recreating the many btrfs send/receive relationships.
> 
> Consider not using send/receive, and switching to regular rsync instead.
> Send/receive is very limiting and cumbersome, including because of what you
> described. And it doesn't gain you much over an incremental rsync. As for

Err, sorry but I cannot agree with you here, at all :)

btrfs send/receive is pretty much the only reason I use btrfs. 
rsync takes hours on big filesystems scanning every single inode on both
sides and then seeing what changed, and only then sends the differences
It's super inefficient.
btrfs send knows in seconds what needs to be sent, and works on it right
away.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
