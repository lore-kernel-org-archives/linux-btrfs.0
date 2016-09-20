Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42456 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752877AbcITOXs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Sep 2016 10:23:48 -0400
Date: Tue, 20 Sep 2016 10:23:20 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: ChaCha20 vs. AES performance
Message-ID: <20160920142320.ubkifckpfvzvuzom@thunk.org>
References: <20160920111519.3n5ijtusvevasjl4@kmo-pixel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160920111519.3n5ijtusvevasjl4@kmo-pixel>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 20, 2016 at 03:15:19AM -0800, Kent Overstreet wrote:
> Not on the list or I would've replied directly, but on Haswell, ChaCha20 (in
> software) is over 2x as fast as AES (in hardware), at realistic (for a
> filesystem) block sizes:

On Skylake and Broadwell processors, AES is faster (the posting is
from a ChaCha20 enthusiast):

     https://blog.cloudflare.com/it-takes-two-to-chacha-poly/

My big worry though is that schemes that require that nonces/IV's must
**never** be reused are fragile.  It's for the same reason that DSA
makes my skin crawl.  If you ever screw up --- maybe after a crash, or
a file system bug, you end up reusing a nonce, it's game over.

So if there are hardware solutions which are faster or fast enough
that the crypto is no longer dominant cost, why not use a cipher
scheme which is more robust?

						- Ted

P.S.  We're also both ignoring the cost of whatever changes are needed in
the file system to guarantee that the nonce is never, ever reused...
