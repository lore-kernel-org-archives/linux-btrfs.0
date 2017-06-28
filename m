Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:48822 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750934AbdF1F3p (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Jun 2017 01:29:45 -0400
From: Nick Terrell <terrelln@fb.com>
To: "dsterba@suse.cz" <dsterba@suse.cz>
CC: Adam Borowski <kilobyte@angband.pl>, Kernel Team <Kernel-team@fb.com>,
        Chris Mason <clm@fb.com>, Yann Collet <cyan@fb.com>,
        "squashfs-devel@lists.sourceforge.net"
        <squashfs-devel@lists.sourceforge.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] lib/zstd: use div_u64() to let it build on 32-bit
Date: Wed, 28 Jun 2017 05:29:25 +0000
Message-ID: <0237381B-1B0B-4666-BA07-ABCEBDD492AE@fb.com>
References: <20170626121230.GF2866@twin.jikos.cz>
 <20170627041823.1300-1-kilobyte@angband.pl>
 <7DDA5748-8FAB-497A-9EA3-9DEA27158C61@fb.com> <20170627125730.GV2866@suse.cz>
In-Reply-To: <20170627125730.GV2866@suse.cz>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Please don't top post.

Sorry about that.

> Which function needs 1KB of stack space? That's quite a lot.

FSE_buildCTable_wksp(), FSE_compress_wksp(), and HUF_readDTableX4()
required over 1 KB of stack space.

> I can see in [1] that there are some on-stack buffers replaced by
> pointers to the workspace. That's good, but I would like to know if
> there's any hidden gem that grags the precious stack space.

I've been hunting down functions that use up the most stack trace and
replacing buffers with pointers to the workspace. I compiled the code
with -Wframe-larger-than=512 and reduced the stack usage of all offending
functions. In the next version of the patch, no function uses more than
400 B of stack space. We'll be porting the changes back upstream as well.

> Hm, I'd suggest to create a version optimized for kernel, eg. expecting
> that 4+ GB buffer will never be used and you can use the most fittin in
> type. This should affect only the function signatures, not the
> algorithm implementation, so porting future zstd changes should be
> straightforward.

If the functions were exposed, then I would agree 100%. However, since
these are internal functions, and the rest of zstd uses size_t to represent
buffer sizes, I think it would be awkward to change just FSE/HUF functions.
I also prefer size_t because it is friendlier to the optimizer, especially
the loop optimizer, since the compiler doesn't have to worry about unsigned
overflow.

On a related note, zstd performs automatic optimizations to improve
compression speed and reduce memory usage when given small sources, which
is the common case in the kernel.


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
