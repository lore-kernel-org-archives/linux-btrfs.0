Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:56744 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1757228AbdIICTD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Sep 2017 22:19:03 -0400
Date: Fri, 8 Sep 2017 22:19:22 -0400
From: Chris Mason <clm@fb.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Nick Terrell <terrelln@fb.com>,
        Phillip Lougher <phillip@squashfs.org.uk>, Sean Purcell <me@seanp.xyz>,
        David Sterba <dsterba@suse.cz>
Subject: Re: [GIT PULL] zstd support (lib, btrfs, squashfs)
Message-ID: <20170909021921.GA25782@clm-mbp.thefacebook.com>
References: <de155140-8773-1a78-2dab-1d722ede3dc1@fb.com>
 <20170909013559.GA29188@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
In-Reply-To: <20170909013559.GA29188@gondor.apana.org.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Sep 09, 2017 at 09:35:59AM +0800, Herbert Xu wrote:
>On Fri, Sep 08, 2017 at 03:33:05PM -0400, Chris Mason wrote:
>>
>>  crypto/Kconfig             |    9 +
>>  crypto/Makefile            |    1 +
>>  crypto/testmgr.c           |   10 +
>>  crypto/testmgr.h           |   71 +
>>  crypto/zstd.c              |  265 ++++
>
>Is there anyone going to use zstd through the crypto API? If not
>then I don't see the point in adding it at this point.  Especially
>as the compression API is still in a state of flux.

That part was requested by intel, but I'm happy to leave it out for 
another time.  The rest of the patch series doesn't depend on it at all.

-chris
