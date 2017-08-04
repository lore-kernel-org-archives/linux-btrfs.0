Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:45878 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752202AbdHDWcu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 4 Aug 2017 18:32:50 -0400
From: Nick Terrell <terrelln@fb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "Austin S . Hemmelgarn" <ahferroin7@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kernel Team <Kernel-team@fb.com>, Chris Mason <clm@fb.com>,
        Yann Collet <cyan@fb.com>, Adam Borowski <kilobyte@angband.pl>,
        David Sterba <dsterba@suse.cz>,
        "squashfs-devel@lists.sourceforge.net"
        <squashfs-devel@lists.sourceforge.net>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Phillip Lougher <phillip@squashfs.org.uk>, Sean Purcell <me@seanp.xyz>
Subject: Re: [PATCH v4 4/5] squashfs: Add zstd support
Date: Fri, 4 Aug 2017 22:32:22 +0000
Message-ID: <F97F85B1-27FC-4ABF-90F4-2F596B003B1E@fb.com>
References: <20170804201921.156890-1-terrelln@fb.com>
 <20170804201921.156890-5-terrelln@fb.com>
 <CA+55aFyqFWbEG+jYyWjbA0=rm+u7Nm++psPfC_e+oMbgBYC33w@mail.gmail.com>
In-Reply-To: <CA+55aFyqFWbEG+jYyWjbA0=rm+u7Nm++psPfC_e+oMbgBYC33w@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 8/4/17, 3:10 PM, "linus971@gmail.com on behalf of Linus Torvalds" <linus971@gmail.com on behalf of torvalds@linux-foundation.org> wrote:
> On Fri, Aug 4, 2017 at 1:19 PM, Nick Terrell <terrelln@fb.com> wrote:
> >
> > This patch was written by Sean Purcell <me@seanp.xyz>, but I will be
> > taking over the submission process.
> 
> Please, if so, get Sean's sign-off, and also make sure that the patch
> gets submitted with
> 
>    From: Sean Purcell <me@seanp.xyz>
> 
> at the top of the body of the email so that authorship gets properly
> attributed by all the usual tools.
> 
>              Linus
> 

Thanks for the help, I'll fix it for the next version.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
