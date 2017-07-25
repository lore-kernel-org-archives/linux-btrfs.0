Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:52089 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750896AbdGYXTe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Jul 2017 19:19:34 -0400
Date: Wed, 26 Jul 2017 00:19:29 +0100
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: Nick Terrell <terrelln@fb.com>
Cc: "Austin S . Hemmelgarn" <ahferroin7@gmail.com>,
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
Message-ID: <20170725231929.GA28789@silv-upstream1.ir.intel.com>
References: <20170720212743.3351201-1-terrelln@fb.com>
 <20170720212743.3351201-4-terrelln@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170720212743.3351201-4-terrelln@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Nick,

On Thu, Jul 20, 2017 at 10:27:42PM +0100, Nick Terrell wrote:
> Add zstd compression and decompression support to BtrFS. zstd at its
> fastest level compresses almost as well as zlib, while offering much
> faster compression and decompression, approaching lzo speeds.
Can we look at integrating the zstd implementation below the acomp API
available in the crypto subsystem?
(https://github.com/torvalds/linux/blob/master/crypto/acompress.c)
Acomp was designed to provide a generic and uniform API for compression
in the kernel which hides algorithm specific details to frameworks.
In future it would be nice to see btrfs using exclusively acomp
for compression. This way when a new compression algorithm is exposed
through acomp, it will be available immediately in btrfs.
Furthermore, any framework in the kernel that will use acomp will be
automatically enabled to use zstd.
What do you think?

Here is a prototype that shows how btrfs can be integrated with
acomp: https://patchwork.kernel.org/patch/9201741/

Regards,

-- 
Giovanni
