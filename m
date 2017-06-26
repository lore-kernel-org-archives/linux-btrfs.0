Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33297 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751866AbdFZMNo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Jun 2017 08:13:44 -0400
Date: Mon, 26 Jun 2017 14:12:30 +0200
From: David Sterba <dsterba@suse.cz>
To: Adam Borowski <kilobyte@angband.pl>
Cc: Nick Terrell <terrelln@fb.com>, kernel-team@fb.com,
        Chris Mason <clm@fb.com>, Yann Collet <cyan@fb.com>,
        squashfs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] btrfs: Add zstd support
Message-ID: <20170626121230.GF2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170622220139.2328978-3-terrelln@fb.com>
 <201706260238.qmaHlUAv%fengguang.wu@intel.com>
 <20170625213022.7kaa7agzmzdyw3n4@angband.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170625213022.7kaa7agzmzdyw3n4@angband.pl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jun 25, 2017 at 11:30:22PM +0200, Adam Borowski wrote:
> On Mon, Jun 26, 2017 at 03:03:17AM +0800, kbuild test robot wrote:
> > Hi Nick,
> > 
> > url:    https://github.com/0day-ci/linux/commits/Nick-Terrell/lib-Add-xxhash-module/20170625-214344
> > config: i386-allmodconfig (attached as .config)
> > compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
> > reproduce:
> >         # save the attached .config to linux build tree
> >         make ARCH=i386 
> > 
> > All errors (new ones prefixed by >>):
> > 
> > >> ERROR: "__udivdi3" [lib/zstd/zstd_compress.ko] undefined!
> >    ERROR: "__udivdi3" [fs/ufs/ufs.ko] undefined!
> 
> Just to save you time to figure it out:
> for division when one or both arguments are longer than the architecture's
> word, gcc uses helper functions that are included when compiling in a hosted
> environment -- but not in freestanding.
> 
> Thus, you want do_div() instead of /; do check widths and signedness of
> arguments.

No do_div please, div_u64 or div64_u64.
