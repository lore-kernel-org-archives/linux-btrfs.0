Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:37792 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755935AbaIQP0Y (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Sep 2014 11:26:24 -0400
Received: by mail-pa0-f45.google.com with SMTP id rd3so2377528pab.18
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Sep 2014 08:26:23 -0700 (PDT)
Message-ID: <5419A81B.2030705@converseincode.com>
Date: Wed, 17 Sep 2014 08:26:19 -0700
From: Behan Webster <behanw@converseincode.com>
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Dmitry Kasatkin <d.kasatkin@samsung.com>
CC: agk@redhat.com, clm@fb.com, davem@davemloft.net, dm-devel@redhat.com,
        fabf@skynet.be, jbacik@fb.com, snitzer@redhat.com,
        tadeusz.struk@intel.com, akpm@linux-foundation.org,
        bruce.w.allan@intel.com, james.l.morris@oracle.com,
        john.griffin@intel.com, linux-btrfs@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-ima-devel@lists.sourceforge.net,
        linux-ima-user@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-security-module@vger.kernel.org,
        neilb@suse.de, qat-linux@intel.com, serge@hallyn.com,
        thomas.lendacky@amd.com, zohar@linux.vnet.ibm.com,
        torvalds@linux-foundation.org
Subject: Re: [PATCH v3 01/12] crypto: LLVMLinux: Add macro to remove use of
 VLAIS in crypto code
References: <1410766234-1634-1-git-send-email-behanw@converseincode.com> <1410766234-1634-2-git-send-email-behanw@converseincode.com> <20140917092212.GA1213@gondor.apana.org.au> <54196D5C.6040104@samsung.com> <20140917113035.GB2129@gondor.apana.org.au>
In-Reply-To: <20140917113035.GB2129@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/17/14 04:30, Herbert Xu wrote:
> On Wed, Sep 17, 2014 at 02:15:40PM +0300, Dmitry Kasatkin wrote:
>> On 17/09/14 12:22, Herbert Xu wrote:
>>> On Mon, Sep 15, 2014 at 12:30:23AM -0700, behanw@converseincode.com wrote:
>>>> From: Behan Webster <behanw@converseincode.com>
>>>>
>>>> Add a macro which replaces the use of a Variable Length Array In Struct (VLAIS)
>>>> with a C99 compliant equivalent. This macro instead allocates the appropriate
>>>> amount of memory using an char array.
>>>>
>>>> The new code can be compiled with both gcc and clang.
>>>>
>>>> struct shash_desc contains a flexible array member member ctx declared with
>>>> CRYPTO_MINALIGN_ATTR, so sizeof(struct shash_desc) aligns the beginning
>>>> of the array declared after struct shash_desc with long long.
>>>>
>>>> No trailing padding is required because it is not a struct type that can
>>>> be used in an array.
>>>>
>>>> The CRYPTO_MINALIGN_ATTR is required so that desc is aligned with long long
>>>> as would be the case for a struct containing a member with
>>>> CRYPTO_MINALIGN_ATTR.
>>>>
>>>> Signed-off-by: Behan Webster <behanw@converseincode.com>
>>> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
>>>
>>> Thanks,
>> Just in case.
>> I would still follow advice from "Michał Mirosław" to use shash##__desc[]
Absolutely. I will be posting a v4 patchset . Just waiting a bit more 
for more comments on v3.

The macro from v4 will look like this which I believe will satisfy the 
concern and indeed be safer than my previous version.

+#define SHASH_DESC_ON_STACK(shash, tfm)                                  \
+       char __##shash##_desc[sizeof(struct shash_desc) +        \
+               crypto_shash_descsize(tfm)] CRYPTO_MINALIGN_ATTR; \
+       struct shash_desc *shash = (struct shash_desc *)__##shash##_desc

Hmm. Is it worth adding a comment with this macro explaining the reason this works? Essentially much of what is in the commit message?
  

> Oh yes of course.  My ack is more about the approach.

Wonderful!

Indeed. I would have asked for you to wait for v4 anyways. :)

Thank you,

Behan

-- 
Behan Webster
behanw@converseincode.com

