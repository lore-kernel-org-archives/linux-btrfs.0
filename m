Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37958 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751176AbdJDOYM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 4 Oct 2017 10:24:12 -0400
Date: Wed, 4 Oct 2017 16:22:28 +0200
From: David Sterba <dsterba@suse.cz>
To: Goffredo Baroncelli <kreijack@libero.it>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>,
        Jean-Denis Girard <jd.girard@sysnux.pf>,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: [PATCH] btrfs: avoid overflow when sector_t is 32 bit
Message-ID: <20171004142228.GB3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171003173110.14789-1-kreijack@libero.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171003173110.14789-1-kreijack@libero.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 03, 2017 at 07:31:10PM +0200, Goffredo Baroncelli wrote:
> From: Goffredo Baroncelli <kreijack@inwind.it>
> 
> Jean-Denis Girard noticed commit c821e7f3 "pass bytes to
> btrfs_bio_alloc" (https://patchwork.kernel.org/patch/9763081/) introduces a
> regression on 32 bit machines.
> When CONFIG_LBDAF is _not_ defined (CONFIG_LBDAF == Support for large
> (2TB+) block devices and files) sector_t is 32 bit on 32bit machines.
> 
> In the function submit_extent_page, 'sector' (which is sector_t type) is
> multiplied by 512 to convert it from sectors to bytes, leading to an
> overflow when the disk is bigger than 4GB (!).

That's not good. There are some known typedefs that hide the 32bit/64bit
differences but the LBDAF and sector_t is new to me. Thanks for the
report and fix, I'll get it to linus/master tree in the next batch so it
can go to stable tree.

I've seen sector_t used in places where it is not necessary so I'll try
to minimize the usage and more surprises from the << 9 shifts.

Reviewed-by: David Sterba <dsterba@suse.com>
Fixes: c821e7f3 ("btrfs: pass bytes to btrfs_bio_alloc")
CC: stable@vger.kernel.org # 4.13+
