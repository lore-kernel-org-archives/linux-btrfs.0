Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:59198 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757209AbdIIBgW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Sep 2017 21:36:22 -0400
Date: Sat, 9 Sep 2017 09:35:59 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Chris Mason <clm@fb.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Nick Terrell <terrelln@fb.com>,
        Phillip Lougher <phillip@squashfs.org.uk>, Sean Purcell <me@seanp.xyz>,
        David Sterba <dsterba@suse.cz>
Subject: Re: [GIT PULL] zstd support (lib, btrfs, squashfs)
Message-ID: <20170909013559.GA29188@gondor.apana.org.au>
References: <de155140-8773-1a78-2dab-1d722ede3dc1@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <de155140-8773-1a78-2dab-1d722ede3dc1@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 08, 2017 at 03:33:05PM -0400, Chris Mason wrote:
>                                                                           
>  crypto/Kconfig             |    9 +                                            
>  crypto/Makefile            |    1 +                                            
>  crypto/testmgr.c           |   10 +                                            
>  crypto/testmgr.h           |   71 +                                            
>  crypto/zstd.c              |  265 ++++                                         

Is there anyone going to use zstd through the crypto API? If not
then I don't see the point in adding it at this point.  Especially
as the compression API is still in a state of flux.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
