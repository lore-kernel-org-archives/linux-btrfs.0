Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36810 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753250AbdF0M6q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Jun 2017 08:58:46 -0400
Date: Tue, 27 Jun 2017 14:57:30 +0200
From: David Sterba <dsterba@suse.cz>
To: Nick Terrell <terrelln@fb.com>
Cc: Adam Borowski <kilobyte@angband.pl>, Kernel Team <Kernel-team@fb.com>,
        Chris Mason <clm@fb.com>, Yann Collet <cyan@fb.com>,
        "squashfs-devel@lists.sourceforge.net"
        <squashfs-devel@lists.sourceforge.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] lib/zstd: use div_u64() to let it build on 32-bit
Message-ID: <20170627125730.GV2866@suse.cz>
Reply-To: dsterba@suse.cz
References: <20170626121230.GF2866@twin.jikos.cz>
 <20170627041823.1300-1-kilobyte@angband.pl>
 <7DDA5748-8FAB-497A-9EA3-9DEA27158C61@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <7DDA5748-8FAB-497A-9EA3-9DEA27158C61@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Please don't top post.

On Tue, Jun 27, 2017 at 05:27:51AM +0000, Nick Terrell wrote:
> Adam, I’ve applied the same patch in my tree. I’ll send out the update [1]
> once it's reviewed, since I also reduced the stack usage of functions
> using over 1 KB of stack space.

Which function needs 1KB of stack space? That's quite a lot.

I can see in [1] that there are some on-stack buffers replaced by
pointers to the workspace. That's good, but I would like to know if
there's any hidden gem that grags the precious stack space.

> You’re right that div_u64() will work, since the FSE functions are only
> called on blocks of at most 128 KB at a time. Perhaps a u32 would be
> clearer, but I would prefer to leave the signatures as is, to stay closer
> to upstream. Upstream FSE should work with sizes larger than 4 GB, but
> since it can't happen in zstd, it isn't a priority.

Hm, I'd suggest to create a version optimized for kernel, eg. expecting
that 4+ GB buffer will never be used and you can use the most fittin in
type. This should affect only the function signatures, not the
algorithm implementation, so porting future zstd changes should be
straightforward.
