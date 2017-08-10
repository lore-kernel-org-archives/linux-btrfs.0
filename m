Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:35860 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752109AbdHJRYf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 Aug 2017 13:24:35 -0400
Date: Thu, 10 Aug 2017 10:24:18 -0700
From: Eric Biggers <ebiggers3@gmail.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Nick Terrell <terrelln@fb.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        kernel-team@fb.com, squashfs-devel@lists.sourceforge.net,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH v5 2/5] lib: Add zstd modules
Message-ID: <20170810172342.GA90916@gmail.com>
References: <20170810023553.3200875-1-terrelln@fb.com>
 <20170810023553.3200875-3-terrelln@fb.com>
 <20170810083017.GA10462@zzz.localdomain>
 <ba64934b-0170-1718-fc1e-0acb462abb20@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <ba64934b-0170-1718-fc1e-0acb462abb20@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 10, 2017 at 07:32:18AM -0400, Austin S. Hemmelgarn wrote:
> On 2017-08-10 04:30, Eric Biggers wrote:
> >On Wed, Aug 09, 2017 at 07:35:53PM -0700, Nick Terrell wrote:
> >>
> >>It can compress at speeds approaching lz4, and quality approaching lzma.
> >
> >Well, for a very loose definition of "approaching", and certainly not at the
> >same time.  I doubt there's a use case for using the highest compression levels
> >in kernel mode --- especially the ones using zstd_opt.h.
> Large data-sets with WORM access patterns and infrequent writes
> immediately come to mind as a use case for the highest compression
> level.
> 
> As a more specific example, the company I work for has a very large
> amount of documentation, and we keep all old versions.  This is all
> stored on a file server which is currently using BTRFS.  Once a
> document is written, it's almost never rewritten, so write
> performance only matters for the first write.  However, they're read
> back pretty frequently, so we need good read performance.  As of
> right now, the system is set to use LZO compression by default, and
> then when a new document is added, the previous version of that
> document gets re-compressed using zlib compression, which actually
> results in pretty significant space savings most of the time.  I
> would absolutely love to use zstd compression with this system with
> the highest compression level, because most people don't care how
> long it takes to write the file out, but they do care how long it
> takes to read a file (even if it's an older version).

This may be a reasonable use case, but note this cannot just be the regular
"zstd" compression setting, since filesystem compression by default must provide
reasonable performance for many different access patterns.  See the patch in
this series which actually adds zstd compression to btrfs; it only uses level 1.
I do not see a patch which adds a higher compression mode.  It would need to be
a special setting like "zstdhc" that users could opt-in to on specific
directories.  It also would need to be compared to simply compressing in
userspace.  In many cases compressing in userspace is probably the better
solution for the use case in question because it works on any filesystem, allows
using any compression algorithm, and if random access is not needed it is
possible to compress each file as a single stream (like a .xz file), which
produces a much better compression ratio than the block-by-block compression
that filesystems have to use.

Note also that LZ4HC is in the kernel source tree currently but no one is using
it vs. the regular LZ4.  I think it is the kind of thing that sounded useful
originally, but at the end of the day no one really wants to use it in kernel
mode.  I'd certainly be interested in actual patches, though.

Eric
