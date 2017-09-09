Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:59434 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750899AbdIIEPH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Sep 2017 00:15:07 -0400
Date: Sat, 9 Sep 2017 12:14:41 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Nick Terrell <terrelln@fb.com>
Cc: Chris Mason <clm@fb.com>, Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Phillip Lougher <phillip@squashfs.org.uk>, Sean Purcell <me@seanp.xyz>,
        David Sterba <dsterba@suse.cz>
Subject: Re: [GIT PULL] zstd support (lib, btrfs, squashfs)
Message-ID: <20170909041441.GA30452@gondor.apana.org.au>
References: <de155140-8773-1a78-2dab-1d722ede3dc1@fb.com>
 <20170909013559.GA29188@gondor.apana.org.au>
 <24CD81E2-A5AB-43A3-ACB0-9731ED2B8853@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <24CD81E2-A5AB-43A3-ACB0-9731ED2B8853@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Sep 09, 2017 at 02:48:55AM +0000, Nick Terrell wrote:
>
> There is a patch [1] floating around adding zstd support to compressed RAM
> that uses the crypto API.
> 
> [1] https://lkml.kernel.org/r/20170824014936.4738-1-sergey.senozhatsky%40gmail.com

Yes but I think it would make more sense for the crypto API patches
to be submitted together with its first user.  It wouldn't be the
first time for an algorithm to be added with an intended user which
itself never actually gets merged into the kernel.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
