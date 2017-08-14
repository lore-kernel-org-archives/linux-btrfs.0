Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39829 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751529AbdHNNcB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Aug 2017 09:32:01 -0400
Date: Mon, 14 Aug 2017 15:30:37 +0200
From: David Sterba <dsterba@suse.cz>
To: Chris Mason <clm@fb.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, Eric Biggers <ebiggers3@gmail.com>,
        Nick Terrell <terrelln@fb.com>,
        Herbert Xu <herbert@gondor.apana.org.au>, kernel-team@fb.com,
        squashfs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v5 2/5] lib: Add zstd modules
Message-ID: <20170814133037.GT2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170810023553.3200875-1-terrelln@fb.com>
 <20170810023553.3200875-3-terrelln@fb.com>
 <20170810083017.GA10462@zzz.localdomain>
 <0ceeccb4-1a0f-cacb-dd2b-2913e1cf73ab@fb.com>
 <20170810192506.GF7140@carfax.org.uk>
 <6cd9c58a-1bcb-02c2-9329-c5acc0e79121@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <6cd9c58a-1bcb-02c2-9329-c5acc0e79121@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 11, 2017 at 09:20:10AM -0400, Chris Mason wrote:
> 
> 
> On 08/10/2017 03:25 PM, Hugo Mills wrote:
> > On Thu, Aug 10, 2017 at 01:41:21PM -0400, Chris Mason wrote:
> >> On 08/10/2017 04:30 AM, Eric Biggers wrote:
> >>>
> >>> Theses benchmarks are misleading because they compress the whole file as a
> >>> single stream without resetting the dictionary, which isn't how data will
> >>> typically be compressed in kernel mode.  With filesystem compression the data
> >>> has to be divided into small chunks that can each be decompressed independently.
> >>> That eliminates one of the primary advantages of Zstandard (support for large
> >>> dictionary sizes).
> >>
> >> I did btrfs benchmarks of kernel trees and other normal data sets as
> >> well.  The numbers were in line with what Nick is posting here.
> >> zstd is a big win over both lzo and zlib from a btrfs point of view.
> >>
> >> It's true Nick's patches only support a single compression level in
> >> btrfs, but that's because btrfs doesn't have a way to pass in the
> >> compression ratio.  It could easily be a mount option, it was just
> >> outside the scope of Nick's initial work.
> > 
> >     Could we please not add more mount options? I get that they're easy
> > to implement, but it's a very blunt instrument. What we tend to see
> > (with both nodatacow and compress) is people using the mount options,
> > then asking for exceptions, discovering that they can't do that, and
> > then falling back to doing it with attributes or btrfs properties.
> > Could we just start with btrfs properties this time round, and cut out
> > the mount option part of this cycle.
> > 
> >     In the long run, it'd be great to see most of the btrfs-specific
> > mount options get deprecated and ultimately removed entirely, in
> > favour of attributes/properties, where feasible.
> > 
> 
> It's a good point, and as was commented later down I'd just do mount -o 
> compress=zstd:3 or something.

We've solved that already, here's a proposed patch that extends current
mount options,

https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg66248.html

and a patch that could be backported to older kernels so the new mount
options do not break mounts on older kernels with the new syntax

https://patchwork.kernel.org/patch/9845697/

