Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:47162 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753211AbdIICtL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Sep 2017 22:49:11 -0400
From: Nick Terrell <terrelln@fb.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, Chris Mason <clm@fb.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Phillip Lougher <phillip@squashfs.org.uk>, Sean Purcell <me@seanp.xyz>,
        David Sterba <dsterba@suse.cz>
Subject: Re: [GIT PULL] zstd support (lib, btrfs, squashfs)
Date: Sat, 9 Sep 2017 02:48:55 +0000
Message-ID: <24CD81E2-A5AB-43A3-ACB0-9731ED2B8853@fb.com>
References: <de155140-8773-1a78-2dab-1d722ede3dc1@fb.com>
 <20170909013559.GA29188@gondor.apana.org.au>
In-Reply-To: <20170909013559.GA29188@gondor.apana.org.au>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 9/8/17, 6:36 PM, "Herbert Xu" <herbert@gondor.apana.org.au> wrote:
> On Fri, Sep 08, 2017 at 03:33:05PM -0400, Chris Mason wrote:
> >
> >  crypto/Kconfig             |    9 +
> >  crypto/Makefile            |    1 +
> >  crypto/testmgr.c           |   10 +
> >  crypto/testmgr.h           |   71 +
> >  crypto/zstd.c              |  265 ++++
> 
> Is there anyone going to use zstd through the crypto API? If not
> then I don't see the point in adding it at this point.  Especially
> as the compression API is still in a state of flux.

There is a patch [1] floating around adding zstd support to compressed RAM
that uses the crypto API.

[1] https://lkml.kernel.org/r/20170824014936.4738-1-sergey.senozhatsky%40gmail.com


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
