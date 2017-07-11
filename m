Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:49701 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750821AbdGKE6U (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Jul 2017 00:58:20 -0400
From: Nick Terrell <terrelln@fb.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Adam Borowski <kilobyte@angband.pl>
CC: Kernel Team <Kernel-team@fb.com>, Chris Mason <clm@fb.com>,
        Yann Collet <cyan@fb.com>, David Sterba <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/4] btrfs: Add zstd support
Date: Tue, 11 Jul 2017 04:57:50 +0000
Message-ID: <15FC42E2-5823-4AF4-A945-0F7C60E7751C@fb.com>
References: <20170629194108.1674498-1-terrelln@fb.com>
 <20170629194108.1674498-4-terrelln@fb.com>
 <20170706163225.xbluc2gi2nlaafzo@angband.pl>
 <A077809C-5D3A-4F3C-B859-E6C371A6EA4F@fb.com>
 <20170707234018.syyfaktjxyxvwglc@angband.pl>
 <20170708030706.tle2mpfe376jneft@angband.pl>
 <046c7611-be6d-ec4d-6489-e8f49a4453f6@gmail.com>
In-Reply-To: <046c7611-be6d-ec4d-6489-e8f49a4453f6@gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 7/10/17, 5:36 AM, "Austin S. Hemmelgarn" <ahferroin7@gmail.com> wrote:
> On 2017-07-07 23:07, Adam Borowski wrote:
>> On Sat, Jul 08, 2017 at 01:40:18AM +0200, Adam Borowski wrote:
>>> On Fri, Jul 07, 2017 at 11:17:49PM +0000, Nick Terrell wrote:
>>>> On 7/6/17, 9:32 AM, "Adam Borowski" <kilobyte@angband.pl> wrote:
>>>>> Got a reproducible crash on amd64:
>>>
>>>> Thanks for the bug report Adam! I'm looking into the failure, and haven't
>>>> been able to reproduce it yet. I've built my kernel from your tree, and
>>>> I ran your script with the kernel.tar tarball 100 times, but haven't gotten
>>>> a failure yet.
>>>
>>>> I have a few questions to guide my debugging.
>>>>
>>>> - How many cores are you running with? Iâ€™ve run the script with 1, 2, and 4 cores.
>>>> - Which version of gcc are you using to compile the kernel? Iâ€™m using gcc-6.2.0-5ubuntu12.
>>>> - Are the failures always in exactly the same place, and does it fail 100%
>>>>    of the time or just regularly?
>>>
>>> 6 cores -- all on bare metal.  gcc-7.1.0-9.
>>> Lemme try with gcc-6, a different config or in a VM.
>>
>> I've tried the following:
>> * gcc-6, defconfig (+btrfs obviously)
>> * gcc-7, defconfig
>> * gcc-6, my regular config
>> * gcc-7, my regular config
>> * gcc-7, debug + UBSAN + etc
>> * gcc-7, defconfig, qemu-kvm with only 1 core
>>
>> Every build with gcc-7 reproduces the crash, every with gcc-6 does not.
>>
> Got a GCC7 tool-chain built, and I can confirm this here too, tested 
> with various numbers of cores ranging from 1-32 in a QEMU+KVM VM, with 
> various combinations of debug options and other config switches.

The problem is caused by a gcc-7 bug [1]. It miscompiles
ZSTD_wildcopy(void *dst, void const *src, ptrdiff_t len) when len is 0.
It only happens when it can't analyze ZSTD_copy8(), which is the case in
the kernel, because memcpy() is implemented with inline assembly. The
generated code is slow anyways, so I propose this workaround, which will
be included in the next patch set. I've confirmed that it fixes the bug for
me. This alternative implementation is also 10-20x faster, and compiles to
the same x86 assembly as the original ZSTD_wildcopy() with the userland
memcpy() implementation [2].

[1] https://gcc.gnu.org/bugzilla/show_bug.cgi?id=81388#add_comment
[2] https://godbolt.org/g/q5YpLx

Signed-off-by: Nick Terrell <terrelln@fb.com>
---
 lib/zstd/zstd_internal.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/zstd/zstd_internal.h b/lib/zstd/zstd_internal.h
index 6748719..ade0365 100644
--- a/lib/zstd/zstd_internal.h
+++ b/lib/zstd/zstd_internal.h
@@ -126,7 +126,9 @@ static const U32 OF_defaultNormLog = OF_DEFAULTNORMLOG;
 /*-*******************************************
 *  Shared functions to include for inlining
 *********************************************/
-static void ZSTD_copy8(void *dst, const void *src) { memcpy(dst, src, 8); }
+static void ZSTD_copy8(void *dst, const void *src) {
+       ZSTD_write64(dst, ZSTD_read64(src));
+}
 #define COPY8(d, s)               \
        {                         \
                ZSTD_copy8(d, s); \
--
2.9.3


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
