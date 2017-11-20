Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51442 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751846AbdKTRJ3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Nov 2017 12:09:29 -0500
Date: Mon, 20 Nov 2017 18:07:34 +0100
From: David Sterba <dsterba@suse.cz>
To: Nick Terrell <terrelln@fb.com>
Cc: David Sterba <dsterba@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: move some zstd work data from stack to workspace
Message-ID: <20171120170734.GA3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171115172739.25017-1-dsterba@suse.com>
 <8E453D19-A43F-4472-BAAA-0944F6ACB324@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <8E453D19-A43F-4472-BAAA-0944F6ACB324@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 16, 2017 at 01:07:19AM +0000, Nick Terrell wrote:
> On 11/15/17, 9:30 AM, "David Sterba" <dsterba@suse.com> wrote:
> > * ZSTD_inBuffer in_buf
> > * ZSTD_outBuffer out_buf
> >
> > are used in all functions to pass the compression parameters and the
> > local variables consume some space. We can move them to the workspace
> > and reduce the stack consumption:
> >
> > zstd.c:zstd_decompress                        -24 (136 -> 112)
> > zstd.c:zstd_decompress_bio                    -24 (144 -> 120)
> > zstd.c:zstd_compress_pages                    -24 (264 -> 240)
> 
> It looks good to me, and I ran my btrfs zstd compression and
> decompression test and everything worked.
> 
> Is there a case where these 24 bytes matter, or is this just an easy
> optimization?

The stacks in kernel are limited, so it's a good practice to keep them
minimal. The size used to be 4kb, 8kb and now is 16kb. Using several
IO/FS layers (DM targets like crypto/raids/integrity, NFS, ecryptfs,
iscsi, ...) can increase the stack consumption and potentially overflow
under some conditions. The compression can be typically called from a
writeout path so all the layers can be active at that point and the
overflow could happen. Also debugging features can increase the stack
consumption even without the layering fun.

The maximal stack consumption can be measured by
CONFIG_DEBUG_STACK_USAGE, the values that I've seen on my dev boxes were
near the 8kb boundary, so we'd be in a much worse situation without the
16k stacks.
