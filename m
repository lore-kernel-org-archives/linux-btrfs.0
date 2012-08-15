Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.servus.at ([193.170.194.20]:57064 "EHLO mail.servus.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751224Ab2HOMCx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Aug 2012 08:02:53 -0400
Message-ID: <502B8FE3.7080501@oberhumer.com>
Date: Wed, 15 Aug 2012 14:02:43 +0200
From: "Markus F.X.J. Oberhumer" <markus@oberhumer.com>
MIME-Version: 1.0
To: Johannes Stezenbach <js@sig21.net>
CC: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        chris.mason@fusionio.com, linux-btrfs@vger.kernel.org,
        Nitin Gupta <ngupta@vflare.org>,
        Richard Purdie <rpurdie@openedhand.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [GIT PULL] Update LZO compression
References: <50299142.2030504@oberhumer.com> <20120814123937.GA14756@sig21.net>
In-Reply-To: <20120814123937.GA14756@sig21.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Johannes,

On 2012-08-14 14:39, Johannes Stezenbach wrote:
> On Tue, Aug 14, 2012 at 01:44:02AM +0200, Markus F.X.J. Oberhumer wrote:
>> On 2012-07-16 20:30, Markus F.X.J. Oberhumer wrote:
>>>
>>> As stated in the README this version is significantly faster (typically more
>>> than 2 times faster!) than the current version, has been thoroughly tested on
>>> x86_64/i386/powerpc platforms and is intended to get included into the
>>> official Linux 3.6 or 3.7 release.
>>>
>>> I encourage all compression users to test and benchmark this new version,
>>> and I also would ask some official LZO maintainer to convert the updated
>>> source files into a GIT commit and possibly push it to Linus or linux-next.
> 
> Sorry for not reporting earlier, but I didn't have time to do real
> benchmarks, just a quick test on ARM926EJ-S using barebox,
> and found in the new version decompression is slower:
> http://lists.infradead.org/pipermail/barebox/2012-July/008268.html

I can only guess, but maybe your ARM cpu does not have an efficient
implementation of {get,put}_unaligned().

Could you please try the following patch and test if you can see
any significant speed difference?

Thanks,
Markus


diff --git a/lib/lzo/lzodefs.h b/lib/lzo/lzodefs.h
index ddc8db5..efc5714 100644
--- a/lib/lzo/lzodefs.h
+++ b/lib/lzo/lzodefs.h
@@ -12,8 +12,15 @@
  */


+#if defined(__arm__)
+#define COPY4(dst, src)        \
+               (dst)[0] = (src)[0]; (dst)[1] = (src)[1]; \
+               (dst)[2] = (src)[2]; (dst)[3] = (src)[3]
+#endif
+#ifndef COPY4
 #define COPY4(dst, src)        \
                put_unaligned(get_unaligned((const u32 *)(src)), (u32 *)(dst))
+#endif
 #if defined(__x86_64__)
 #define COPY8(dst, src)        \
                put_unaligned(get_unaligned((const u64 *)(src)), (u64 *)(dst))


> 
> BTW, do you have userspace code matching the old and new
> lzo versions?  It would be easier to benchmark.
> 
> Unfortunately I cannot claim high confidence in my benchmark results
> due to missing time to do it properly, it would be useful if
> someone else could do some benchmarks on ARM before merging this.
> 
> 
> Johannes 

-- 
Markus Oberhumer, <markus@oberhumer.com>, http://www.oberhumer.com/
