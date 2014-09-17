Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:65110 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212AbaIQLPN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Sep 2014 07:15:13 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Message-id: <54196D5C.6040104@samsung.com>
Date: Wed, 17 Sep 2014 14:15:40 +0300
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, behanw@converseincode.com
Cc: agk@redhat.com, clm@fb.com, davem@davemloft.net, dm-devel@redhat.com,
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
References: <1410766234-1634-1-git-send-email-behanw@converseincode.com>
 <1410766234-1634-2-git-send-email-behanw@converseincode.com>
 <20140917092212.GA1213@gondor.apana.org.au>
In-reply-to: <20140917092212.GA1213@gondor.apana.org.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 17/09/14 12:22, Herbert Xu wrote:
> On Mon, Sep 15, 2014 at 12:30:23AM -0700, behanw@converseincode.com wrote:
>> From: Behan Webster <behanw@converseincode.com>
>>
>> Add a macro which replaces the use of a Variable Length Array In Struct (VLAIS)
>> with a C99 compliant equivalent. This macro instead allocates the appropriate
>> amount of memory using an char array.
>>
>> The new code can be compiled with both gcc and clang.
>>
>> struct shash_desc contains a flexible array member member ctx declared with
>> CRYPTO_MINALIGN_ATTR, so sizeof(struct shash_desc) aligns the beginning
>> of the array declared after struct shash_desc with long long.
>>
>> No trailing padding is required because it is not a struct type that can
>> be used in an array.
>>
>> The CRYPTO_MINALIGN_ATTR is required so that desc is aligned with long long
>> as would be the case for a struct containing a member with
>> CRYPTO_MINALIGN_ATTR.
>>
>> Signed-off-by: Behan Webster <behanw@converseincode.com>
> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
>
> Thanks,

Just in case.
I would still follow advice from "Michał Mirosław" to use shash##__desc[]

- Dmitry


