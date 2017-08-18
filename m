Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46786 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750881AbdHRPik (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Aug 2017 11:38:40 -0400
Date: Fri, 18 Aug 2017 17:37:14 +0200
From: David Sterba <dsterba@suse.cz>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: Nick Terrell <terrelln@fb.com>,
        "Austin S . Hemmelgarn" <ahferroin7@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "kernel-team@fb.com" <kernel-team@fb.com>, Chris Mason <clm@fb.com>,
        Yann Collet <cyan@fb.com>, Adam Borowski <kilobyte@angband.pl>,
        David Sterba <dsterba@suse.cz>,
        "squashfs-devel@lists.sourceforge.net"
        <squashfs-devel@lists.sourceforge.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Weigang Li <weigang.li@intel.com>, Brian Will <brian.will@intel.com>,
        Brian A Keating <brian.a.keating@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@gmail.com>
Subject: Re: [PATCH v3 3/4] btrfs: Add zstd support
Message-ID: <20170818153714.GZ2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170720212743.3351201-1-terrelln@fb.com>
 <20170720212743.3351201-4-terrelln@fb.com>
 <20170725231929.GA28789@silv-upstream1.ir.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170725231929.GA28789@silv-upstream1.ir.intel.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 26, 2017 at 12:19:29AM +0100, Giovanni Cabiddu wrote:
> Hi Nick,
> 
> On Thu, Jul 20, 2017 at 10:27:42PM +0100, Nick Terrell wrote:
> > Add zstd compression and decompression support to BtrFS. zstd at its
> > fastest level compresses almost as well as zlib, while offering much
> > faster compression and decompression, approaching lzo speeds.
> Can we look at integrating the zstd implementation below the acomp API
> available in the crypto subsystem?
> (https://github.com/torvalds/linux/blob/master/crypto/acompress.c)
> Acomp was designed to provide a generic and uniform API for compression
> in the kernel which hides algorithm specific details to frameworks.
> In future it would be nice to see btrfs using exclusively acomp
> for compression. This way when a new compression algorithm is exposed
> through acomp, it will be available immediately in btrfs.

The compression algorithm is considered part of the filesystem format
and must be covered by an incompatibility bit. Regarding the acomp API,
I don't see much point adding the extra abstraction layer for the two
currently supported algorithms. We only call 2 functions, for
compression and decompression, no need to allocate the acomp helper
structures and call the functions indirectly.
