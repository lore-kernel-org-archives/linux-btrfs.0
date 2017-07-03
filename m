Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45587 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754744AbdGCRKM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 3 Jul 2017 13:10:12 -0400
Date: Mon, 3 Jul 2017 19:09:00 +0200
From: David Sterba <dsterba@suse.cz>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH v4 0/2] Btrfs: add compression heuristic
Message-ID: <20170703170900.GA2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170701165602.31189-1-nefelim4ag@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170701165602.31189-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jul 01, 2017 at 07:56:00PM +0300, Timofey Titovets wrote:
> Today btrfs use simple logic to make decision
> compress data or not:
> Selected compression algorithm try compress
> data and if this save some space
> store that extent as compressed.
> 
> It's Reliable way to detect uncompressible data
> but it's will waste/burn cpu time for
> bad/un-compressible data and add latency.
> 
> This way also add additional pressure on
> memory subsystem as for every compressed write
> btrfs need to allocate pages and
> reuse compression workspace.
> 
> This is quite efficient, but not free.
> 
> So let's implement heuristic.
> Heuristic will analize data on the fly
> before call of compression code,
> detect uncompressible data and advice to skip it.

So let me recap the heuristic flow:

* before compression, map all the pages to be compressed
* grab samples, calculate entropy or look for known patterns
* unmap pages
* decide if it's worth to do compression

>From that it's quite easy to start with extending the code logic where
the heuristic would be a naive and very optimistic 'return true'.

>From that on, we can extend and fine tune the heuristic itself, whatever
we'd decide to do. There are likely some decisions that we'd have make
after we see the effects in the wild on real data. Getting the skeleton
code merged independently would hopefully make things easier to test.

The cost of the heuristic must be low so this could lead to further
optimizations. Allocating extra memory for the sample might be also not
the best choice, but we might preallocate the bytes within the
workspaces so there's not cost at the actual compression time.

The incremental updates to the heuristic should help us determine if
we're not making it worse, comparing to the current code as a baseline.

So, if you agree, let's start with the heuristic skeleton code first.
I'll commend in the patches.
