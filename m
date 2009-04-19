From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] btrfs: remove crc32c.h and use libcrc32c directly.
Date: Mon, 20 Apr 2009 00:19:31 +0100
Message-ID: <1240183171.3589.421.camel@macbook.infradead.org>
References: <1240142561.3589.143.camel@macbook.infradead.org>
	 <1240182709.8932.2.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1240182709.8932.2.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 2009-04-19 at 19:11 -0400, Chris Mason wrote:
> How does this enable the HW crc32c?  Unless I'm missing something you're
> doing crc32c instead of btrfs_crc32c, but btrfs_crc32c was #defined to
> crc32c?

It doesn't. You're _already_ using the hardware crc32c.

Since commit  69c35efc, all users of crc32c() in libcrc32c are actually
using the cryptoapi and thus any accelerated hardware implementations
that are available:

    libcrc32c: Move implementation to crypto crc32c
    
    This patch swaps the role of libcrc32c and crc32c.  Previously
    the implementation was in libcrc32c and crc32c was a wrapper.
    Now the code is in crc32c and libcrc32c just calls the crypto
    layer.
    
    The reason for the change is to tap into the algorithm selection
    capability of the crypto API so that optimised implementations
    such as the one utilising Intel's CRC32C instruction can be
    used where available.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

