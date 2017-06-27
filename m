Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:44327 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751312AbdF0F2M (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Jun 2017 01:28:12 -0400
From: Nick Terrell <terrelln@fb.com>
To: Adam Borowski <kilobyte@angband.pl>, "dsterba@suse.cz" <dsterba@suse.cz>,
        Kernel Team <Kernel-team@fb.com>, Chris Mason <clm@fb.com>,
        Yann Collet <cyan@fb.com>,
        "squashfs-devel@lists.sourceforge.net"
        <squashfs-devel@lists.sourceforge.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] lib/zstd: use div_u64() to let it build on 32-bit
Date: Tue, 27 Jun 2017 05:27:51 +0000
Message-ID: <7DDA5748-8FAB-497A-9EA3-9DEA27158C61@fb.com>
References: <20170626121230.GF2866@twin.jikos.cz>
 <20170627041823.1300-1-kilobyte@angband.pl>
In-Reply-To: <20170627041823.1300-1-kilobyte@angband.pl>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Adam, Iâ€™ve applied the same patch in my tree. Iâ€™ll send out the update [1]
once it's reviewed, since I also reduced the stack usage of functions
using over 1 KB of stack space.

Youâ€™re right that div_u64() will work, since the FSE functions are only
called on blocks of at most 128 KB at a time. Perhaps a u32 would be
clearer, but I would prefer to leave the signatures as is, to stay closer
to upstream. Upstream FSE should work with sizes larger than 4 GB, but
since it can't happen in zstd, it isn't a priority.

I have userland tests set up mocking the linux kernel headers, and tested
32-bit mode there, but neglected to test the kernel on a 32-bit VM, which
Iâ€™ve now corrected. Thanks for testing the patch on your ARM machine!

[1] https://github.com/facebook/zstd/pull/738/files

On 6/26/17, 9:18 PM, "Adam Borowski" <kilobyte@angband.pl> wrote:

    David Sterba wrote:
    > > Thus, you want do_div() instead of /; do check widths and signedness of
    > > arguments.
    >
    > No do_div please, div_u64 or div64_u64.
    
    Good to know, the interface of do_div() is indeed weird.
    
    I guess Nick has found and fixed the offending divisions in his tree
    already, but this patch I'm sending is what I'm testing.
    
    One thing to note is that it divides u64 by size_t, so the actual operation
    differs on 32 vs 64-bit.  Yet the code fails to handle compressing pieces
    bigger than 4GB in other places -- so use of size_t is misleading.  Perhaps
    u32 would better convey this limitation?
    
    Anyway, that this code didn't even compile on 32-bit also means it hasn't
    been tested.  I just happen to have such an ARM machine doing Debian archive
    rebuilds; I've rewritten the chroots with compress=zstd; this should be a
    nice non-artificial test.  The load consists of snapshot+dpkg+gcc/etc+
    assorted testsuites, two sbuild instances.  Seems to work fine for a whole
    hour (yay!) already, let's see if there'll be any explosions.
    
    
    -- >8 ---- >8 ---- >8 ---- >8 ---- >8 ---- >8 ---- >8 ---- >8 ---- >8 --
    Note that "total" is limited to 2Â³Â²-1 elsewhere despite being declared
    as size_t, so it's ok to use 64/32 -- it's much faster on eg. x86-32
    than 64/64.
    
    Signed-off-by: Adam Borowski <kilobyte@angband.pl>
    ---
     lib/zstd/fse_compress.c | 5 +++--
     1 file changed, 3 insertions(+), 2 deletions(-)
    
    diff --git a/lib/zstd/fse_compress.c b/lib/zstd/fse_compress.c
    index e016bb177833..f59f9ebfe9c0 100644
    --- a/lib/zstd/fse_compress.c
    +++ b/lib/zstd/fse_compress.c
    @@ -49,6 +49,7 @@
     #include "fse.h"
     #include <linux/compiler.h>
     #include <linux/string.h> /* memcpy, memset */
    +#include <linux/math64.h>
     
     /* **************************************************************
     *  Error Management
    @@ -575,7 +576,7 @@ static size_t FSE_normalizeM2(short *norm, U32 tableLog, const unsigned *count,
     	{
     		U64 const vStepLog = 62 - tableLog;
     		U64 const mid = (1ULL << (vStepLog - 1)) - 1;
    -		U64 const rStep = ((((U64)1 << vStepLog) * ToDistribute) + mid) / total; /* scale on remaining */
    +		U64 const rStep = div_u64((((U64)1 << vStepLog) * ToDistribute) + mid, total); /* scale on remaining */
     		U64 tmpTotal = mid;
     		for (s = 0; s <= maxSymbolValue; s++) {
     			if (norm[s] == NOT_YET_ASSIGNED) {
    @@ -609,7 +610,7 @@ size_t FSE_normalizeCount(short *normalizedCounter, unsigned tableLog, const uns
     	{
     		U32 const rtbTable[] = {0, 473195, 504333, 520860, 550000, 700000, 750000, 830000};
     		U64 const scale = 62 - tableLog;
    -		U64 const step = ((U64)1 << 62) / total; /* <== here, one division ! */
    +		U64 const step = div_u64((U64)1 << 62, total); /* <== here, one division ! */
     		U64 const vStep = 1ULL << (scale - 20);
     		int stillToDistribute = 1 << tableLog;
     		unsigned s;
    -- 
    2.13.1
    
    

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éÝ¶¥Šwÿº{.nÇ+‰·¥Š{±ý»k~ÏâžØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Þ—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨þ)ß£øm
