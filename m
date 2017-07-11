Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53792 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752170AbdGKGBy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Jul 2017 02:01:54 -0400
From: Nick Terrell <terrelln@fb.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Adam Borowski <kilobyte@angband.pl>
CC: Kernel Team <Kernel-team@fb.com>, Chris Mason <clm@fb.com>,
        Yann Collet <cyan@fb.com>, David Sterba <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/4] btrfs: Add zstd support
Date: Tue, 11 Jul 2017 06:01:38 +0000
Message-ID: <816FA2EC-C072-41D3-A14D-9891BBFEB7DB@fb.com>
References: <20170629194108.1674498-1-terrelln@fb.com>
 <20170629194108.1674498-4-terrelln@fb.com>
 <20170706163225.xbluc2gi2nlaafzo@angband.pl>
 <A077809C-5D3A-4F3C-B859-E6C371A6EA4F@fb.com>
 <20170707234018.syyfaktjxyxvwglc@angband.pl>
 <20170708030706.tle2mpfe376jneft@angband.pl>
 <046c7611-be6d-ec4d-6489-e8f49a4453f6@gmail.com>
 <15FC42E2-5823-4AF4-A945-0F7C60E7751C@fb.com>
In-Reply-To: <15FC42E2-5823-4AF4-A945-0F7C60E7751C@fb.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 7/10/17, 9:57 PM, "Nick Terrell" <terrelln@fb.com> wrote:
> The problem is caused by a gcc-7 bug [1]. It miscompiles
> ZSTD_wildcopy(void *dst, void const *src, ptrdiff_t len) when len is 0.
> It only happens when it can't analyze ZSTD_copy8(), which is the case in
> the kernel, because memcpy() is implemented with inline assembly. The
> generated code is slow anyways, so I propose this workaround, which will
> be included in the next patch set. I've confirmed that it fixes the bug for
> me. This alternative implementation is also 10-20x faster, and compiles to
> the same x86 assembly as the original ZSTD_wildcopy() with the userland
> memcpy() implementation [2].
>
> [1] https://gcc.gnu.org/bugzilla/show_bug.cgi?id=81388#add_comment
> [2] https://godbolt.org/g/q5YpLx
>
> Signed-off-by: Nick Terrell <terrelln@fb.com>
> ---
>  lib/zstd/zstd_internal.h | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/lib/zstd/zstd_internal.h b/lib/zstd/zstd_internal.h
> index 6748719..ade0365 100644
> --- a/lib/zstd/zstd_internal.h
> +++ b/lib/zstd/zstd_internal.h
> @@ -126,7 +126,9 @@ static const U32 OF_defaultNormLog = OF_DEFAULTNORMLOG;
>  /*-*******************************************
>  *  Shared functions to include for inlining
>  *********************************************/
> -static void ZSTD_copy8(void *dst, const void *src) { memcpy(dst, src, 8); }
> +static void ZSTD_copy8(void *dst, const void *src) {
> +       ZSTD_write64(dst, ZSTD_read64(src));
> +}

Sorry, my patch still triggered the gcc bug, I used the wrong compiler.
This patch works, and runs about the same speed as before the patch for
small inputs, and slightly faster for larger inputs (100+ bytes). I'll
look for a faster workaround if benchmarks show it matters.

Signed-off-by: Nick Terrell <terrelln@fb.com>
---
 lib/zstd/zstd_internal.h | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/lib/zstd/zstd_internal.h b/lib/zstd/zstd_internal.h
index 6748719..839014d 100644
--- a/lib/zstd/zstd_internal.h
+++ b/lib/zstd/zstd_internal.h
@@ -139,12 +139,8 @@ static void ZSTD_copy8(void *dst, const void *src) { memcpy(dst, src, 8); }
 #define WILDCOPY_OVERLENGTH 8
 ZSTD_STATIC void ZSTD_wildcopy(void *dst, const void *src, ptrdiff_t length)
 {
-	const BYTE *ip = (const BYTE *)src;
-	BYTE *op = (BYTE *)dst;
-	BYTE *const oend = op + length;
-	do
-		COPY8(op, ip)
-	while (op < oend);
+	if (length > 0)
+		memcpy(dst, src, length);
 }
 
 ZSTD_STATIC void ZSTD_wildcopy_e(void *dst, const void *src, void *dstEnd) /* should be faster for decoding, but strangely, not verified on all platform */
-- 
2.9.3



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
