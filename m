Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:47609 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752021AbdIGAo0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 6 Sep 2017 20:44:26 -0400
From: Nick Terrell <terrelln@fb.com>
To: "dsterba@suse.cz" <dsterba@suse.cz>
CC: Kernel Team <Kernel-team@fb.com>, Chris Mason <clm@fb.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: Add zstd support
Date: Thu, 7 Sep 2017 00:44:19 +0000
Message-ID: <7E192AED-9551-4E28-81C5-822B1BCF9101@fb.com>
References: <20170830215322.782399-1-terrelln@fb.com>
 <20170904180207.GF31874@twin.jikos.cz>
In-Reply-To: <20170904180207.GF31874@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 9/4/17, 11:03 AM, "linux-btrfs-owner@vger.kernel.org on behalf of David Sterba" <linux-btrfs-owner@vger.kernel.org on behalf of dsterba@suse.cz> wrote:
> On Wed, Aug 30, 2017 at 02:53:22PM -0700, Nick Terrell wrote:
> > Adds zstd support to the btrfs program, and a dependency on libzstd >=
> > 1.0.0.
> 
> I'm afraid we'll have to make the build optional for now, as the distros
> may not provide it and I'd like to give at least some heads-up first. My
> idea is:
> 
> - check if zstd library is found, use it
> - otherwise warn that's it's going to be on by default in near future

I can see a few options, what do you want to see?

1. Require zstd for building `btrfs' but statically link it so users don't
   need to have zstd installed, unless they install from source.
2. Require zstd to build `btrfs', but dynamically link and use `dlopen' and
   `dlsym' to access the decompression function (and check the library
   version).
3. Make zstd optional in the build process, and completely disable it if
   unavailable. Otherwise dynamically link and do the same as (2).
4. Same as (3) but statically link if it is available.

I'm thinking that (3) is the best option for consistency with the other
libraries, at the expense of making the user install zstd if they want to
use it. We can put a nice warning message in `btrfs restore' that says you
need to install zstd.

> 'btrfs restore' would need to be enhanced to dump what's built in (in a
> similar way convert now prints the supported filesystem), and possibly
> warn that there are data compressed by zstd but there's no
> decrompression support.

Sounds good.

> > The patch is also available in my fork of btrfs-progs [1], which passes
> > Travis-CI. I tested each command that is effected in my test script [2].
> 
> The test requires zstd kernel support, which may be not available for
> some time in the testing environments. But as restore is userspace-only,
> we can create and use various images with zstd compressed data.

I'll modify my tests and add them to the test suite.

> > I haven't updated Android.mk since I have no way to test it, and am not
> > certain if it is used.
> 
> The anodroid build verification will work eventually through travis and
> I'm aware it could be out of sync, you don't need to care about that
> right now.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
