Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:36155 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752065AbaIKOfF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Sep 2014 10:35:05 -0400
Message-ID: <5411B304.4000203@fb.com>
Date: Thu, 11 Sep 2014 10:34:44 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: <behanw@converseincode.com>, <jbacik@fb.com>
CC: <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?Vmluw61jaXVzIFRpbnRp?= <viniciustinti@gmail.com>,
        =?UTF-8?B?SmFuLVNpbW9uIE3DtmxsZXI=?= <dl9pf@gmx.de>,
        Mark Charlebois <charlebm@gmail.com>
Subject: Re: [PATCH v2] btrfs: LLVMLinux: Remove VLAIS
References: <1409957901-28962-1-git-send-email-behanw@converseincode.com>
In-Reply-To: <1409957901-28962-1-git-send-email-behanw@converseincode.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 09/05/2014 06:58 PM, behanw@converseincode.com wrote:
> From: Vinícius Tinti <viniciustinti@gmail.com>
> 
> Replaced the use of a Variable Length Array In Struct (VLAIS) with a C99
> compliant equivalent. This is the original VLAIS struct.
> 
> struct {
> 	struct shash_desc shash;
> 	char ctx[crypto_shash_descsize(tfm)];
> } desc;
> 
> This patch instead allocates the appropriate amount of memory using an char
> array.
> 
> The new code can be compiled with both gcc and clang.
> 
> struct shash_desc contains a flexible array member member ctx declared with
> CRYPTO_MINALIGN_ATTR, so sizeof(struct shash_desc) aligns the beginning
> of the array declared after struct shash_desc with long long.
> 
> No trailing padding is required because it is not a struct type that can
> be used in an array.
> 
> The CRYPTO_MINALIGN_ATTR is required so that desc is aligned with long long
> as would be the case for a struct containing a member with
> CRYPTO_MINALIGN_ATTR.

We copied this from one of the other crypto api users, and I'm sure
cooking up all these patches was not a great way to your afternoon.

But, can I talk you into making a helper macro of some kind for this and
putting it into the crypto api headers?  Honestly this setup seems
really error prone.

-chris

> 
> Signed-off-by: Jan-Simon Möller <dl9pf@gmx.de>
> Signed-off-by: Behan Webster <behanw@converseincode.com>
> Signed-off-by: Vinícius Tinti <viniciustinti@gmail.com>
> Signed-off-by: Mark Charlebois <charlebm@gmail.com>
> ---
>  fs/btrfs/hash.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/btrfs/hash.c b/fs/btrfs/hash.c
> index 85889aa..a62743f 100644
> --- a/fs/btrfs/hash.c
> +++ b/fs/btrfs/hash.c
> @@ -33,18 +33,18 @@ void btrfs_hash_exit(void)
>  
>  u32 btrfs_crc32c(u32 crc, const void *address, unsigned int length)
>  {
> -	struct {
> -		struct shash_desc shash;
> -		char ctx[crypto_shash_descsize(tfm)];
> -	} desc;
> +	char desc[sizeof(struct shash_desc) +
> +		crypto_shash_descsize(tfm)] CRYPTO_MINALIGN_ATTR;
> +	struct shash_desc *shash = (struct shash_desc *)desc;
> +	u32 *ctx = (u32 *)shash_desc_ctx(shash);
>  	int err;
>  
> -	desc.shash.tfm = tfm;
> -	desc.shash.flags = 0;
> -	*(u32 *)desc.ctx = crc;
> +	shash->tfm = tfm;
> +	shash->flags = 0;
> +	*ctx = crc;
>  
> -	err = crypto_shash_update(&desc.shash, address, length);
> +	err = crypto_shash_update(shash, address, length);
>  	BUG_ON(err);
>  
> -	return *(u32 *)desc.ctx;
> +	return *ctx;
>  }
> 
