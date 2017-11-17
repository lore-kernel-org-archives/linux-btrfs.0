Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:51210 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1161094AbdKQRsd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Nov 2017 12:48:33 -0500
Date: Fri, 17 Nov 2017 09:48:26 -0800
From: Marc MERLIN <marc@merlins.org>
To: Roman Mamedov <rm@romanrm.net>
Cc: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
        <holger@applied-asynchrony.com>,
        linux-btrfs@vger.kernel.org
Message-ID: <20171117174826.fqks43rt4nyjxubj@merlins.org>
References: <20171116170445.24n57phzltgiehj6@merlins.org>
 <20171116170742.vyhxckxrgjzwqyvf@merlins.org>
 <70b25128-d724-4e8e-9835-4a092cf8d5a6@applied-asynchrony.com>
 <20171116214551.vpp4eevs7b4bszjt@merlins.org>
 <2b97e49b-74fd-77c1-a340-8254f8999bb1@applied-asynchrony.com>
 <20171117001256.GN10969@merlins.org>
 <20171117104148.04986eee@natsu>
 <20171117055315.7bmhthyqityiffwl@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171117055315.7bmhthyqityiffwl@merlins.org>
Subject: Re: 4.13.12: kernel BUG at fs/btrfs/ctree.h:1802!
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 16, 2017 at 09:53:15PM -0800, Marc MERLIN wrote:
> > I suggest that you try lvmcache instead. It's much more flexible than bcache,
> > does pretty much the same job, and has much less of the "hacky" feel to it.
> 
> I can read up on it, it's going to be a big pain to convert from one to
> the other, but I can look at it for new filesystems.

I had a quick read. As expected, it's slower since it goes through all
the LVM overhead that I got rid of recently
https://github.com/stec-inc/EnhanceIO/wiki/PERFORMANCE-COMPARISON-AMONG-dm-cache,-bcache-and-EnhanceIO

Given the pain it would be for me to switch, I'm going to stick with
bcache and hope it improves.
But just to be safe, I'm going to stick to this:
echo writearound > /sys/block/bcache0/bcache/cache_mode

Probably my issues were having writes go through bcache, writeback on
one drive even.
I'll go back to the safest setting and hope for the best.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
