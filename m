Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.servus.at ([193.170.194.20]:45710 "EHLO mail.servus.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758817Ab2JKQ3i (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Oct 2012 12:29:38 -0400
Message-ID: <5076F3AC.8020304@oberhumer.com>
Date: Thu, 11 Oct 2012 18:28:28 +0200
From: "Markus F.X.J. Oberhumer" <markus@oberhumer.com>
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Johannes Stezenbach <js@sig21.net>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        linux-btrfs@vger.kernel.org, linux-crypto@vger.kernel.org,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Phillip Lougher <phillip@squashfs.org.uk>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 0/3] Update LZO compression
References: <cover.1349621096.git.markus@oberhumer.com> <20121009122614.569b9535.akpm@linux-foundation.org> <50748113.80408@oberhumer.com> <201210111141.27270.arnd@arndb.de>
In-Reply-To: <201210111141.27270.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks Arnd,

On 2012-10-11 13:41, Arnd Bergmann wrote:
> On Tuesday 09 October 2012, Markus F.X.J. Oberhumer wrote:
>>>
>>> : This commit updates the kernel LZO code to the current upsteam version
>>> : which features a significant speed improvement - benchmarking the Calgary
>>> : and Silesia test corpora typically shows a doubled performance in
>>> : both compression and decompression on modern i386/x86_64/powerpc machines.
>>>
>>> There are significant clients of the LZO library - crypto, btrfs,
>>> jffs2, ubifs, squashfs and zcache.  So let's give all those people a cc
>>> and ask that they test the LZO changes once they land in linux-next. 
>>> For correctness and performance, please.
>>
>> The core compression and decompression code has been thoroughly tested, so I
>> do not expect major problems.
>>
>> Good testing after the merge and feedback about build or performance issues
>> (and improvements!) is highly appreciated.
> 
> The addition of the lzo tree to linux-next caused this problem for ARM
> imx_v6_v7_defconfig:
> 
> In file included from /home/arnd/linux-arm/arch/arm/boot/compressed/decompress.c:40:0:
> /home/arnd/linux-arm/arch/arm/boot/compressed/../../../../lib/decompress_unlzo.c:34:34: fatal error: lzo/lzo1x_decompress.c: No such file or directory
> 
> Since the file was renamed, anything including it needs to be updated to the
> new file name.

I will add that patch to my tree.

Cheers,
Markus

> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> diff --git a/lib/decompress_unlzo.c b/lib/decompress_unlzo.c
> index 4531294..960183d 100644
> --- a/lib/decompress_unlzo.c
> +++ b/lib/decompress_unlzo.c
> @@ -31,7 +31,7 @@
>   */
>  
>  #ifdef STATIC
> -#include "lzo/lzo1x_decompress.c"
> +#include "lzo/lzo1x_decompress_safe.c"
>  #else
>  #include <linux/decompress/unlzo.h>
>  #endif

-- 
Markus Oberhumer, <markus@oberhumer.com>, http://www.oberhumer.com/
