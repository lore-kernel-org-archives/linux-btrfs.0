Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:54805 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755310AbaIBXQq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Sep 2014 19:16:46 -0400
Message-ID: <54064FD1.6060900@canonical.com>
Date: Tue, 02 Sep 2014 16:16:33 -0700
From: John Johansen <john.johansen@canonical.com>
MIME-Version: 1.0
To: behanw@converseincode.com, agk@redhat.com, clm@fb.com, davem@davemloft.net,
        dm-devel@redhat.com, fabf@skynet.be, herbert@gondor.apana.org.au,
        jbacik@fb.com, snitzer@redhat.com
CC: akpm@linux-foundation.org, james.l.morris@oracle.com,
        linux-btrfs@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-security-module@vger.kernel.org, neilb@suse.de, serge@hallyn.com,
        torvalds@linux-foundation.org,
        =?UTF-8?B?Vmluw61jaXVzIFRpbnRp?= <viniciustinti@gmail.com>,
        =?UTF-8?B?SmFuLVNpbW9uIE3DtmxsZXI=?= <dl9pf@gmx.de>,
        Mark Charlebois <charlebm@gmail.com>
Subject: Re: [PATCH RFC 5/6] apparmor: LLVMLinux: Remove VLAIS
References: <1409697153-7006-1-git-send-email-behanw@converseincode.com> <1409697153-7006-6-git-send-email-behanw@converseincode.com>
In-Reply-To: <1409697153-7006-6-git-send-email-behanw@converseincode.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/02/2014 03:32 PM, behanw@converseincode.com wrote:
> From: Vinícius Tinti <viniciustinti@gmail.com>
> 
> Replaced the use of a Variable Length Array In Struct (VLAIS) with a C99
> compliant equivalent. This is the original VLAIS struct.
> 
> struct {
> 	struct shash_desc shash;
> 	char ctx[crypto_shash_descsize(apparmor_tfm)];
> } desc;
> 
> This patch instead allocates the appropriate amount of memory using an
> char array.
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
> 
> Signed-off-by: Jan-Simon Möller <dl9pf@gmx.de>
> Signed-off-by: Behan Webster <behanw@converseincode.com>
> Signed-off-by: Vinícius Tinti <viniciustinti@gmail.com>
> Signed-off-by: Mark Charlebois <charlebm@gmail.com>

I'm fine with this, do you want me to pull it into my tree for our next push
or do you want this all to go together as a set?

Acked-by: John Johansen <john.johansen@canonical.com>

> ---
>  security/apparmor/crypto.c | 19 +++++++++----------
>  1 file changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/security/apparmor/crypto.c b/security/apparmor/crypto.c
> index 532471d..62b32e7 100644
> --- a/security/apparmor/crypto.c
> +++ b/security/apparmor/crypto.c
> @@ -32,10 +32,9 @@ unsigned int aa_hash_size(void)
>  int aa_calc_profile_hash(struct aa_profile *profile, u32 version, void *start,
>  			 size_t len)
>  {
> -	struct {
> -		struct shash_desc shash;
> -		char ctx[crypto_shash_descsize(apparmor_tfm)];
> -	} desc;
> +	char desc[sizeof(struct shash_desc)
> +		+ crypto_shash_descsize(apparmor_tfm)] CRYPTO_MINALIGN_ATTR;
> +	struct shash_desc *shash = (struct shash_desc *)desc;
>  	int error = -ENOMEM;
>  	u32 le32_version = cpu_to_le32(version);
>  
> @@ -46,19 +45,19 @@ int aa_calc_profile_hash(struct aa_profile *profile, u32 version, void *start,
>  	if (!profile->hash)
>  		goto fail;
>  
> -	desc.shash.tfm = apparmor_tfm;
> -	desc.shash.flags = 0;
> +	shash->tfm = apparmor_tfm;
> +	shash->flags = 0;
>  
> -	error = crypto_shash_init(&desc.shash);
> +	error = crypto_shash_init(shash);
>  	if (error)
>  		goto fail;
> -	error = crypto_shash_update(&desc.shash, (u8 *) &le32_version, 4);
> +	error = crypto_shash_update(shash, (u8 *) &le32_version, 4);
>  	if (error)
>  		goto fail;
> -	error = crypto_shash_update(&desc.shash, (u8 *) start, len);
> +	error = crypto_shash_update(shash, (u8 *) start, len);
>  	if (error)
>  		goto fail;
> -	error = crypto_shash_final(&desc.shash, profile->hash);
> +	error = crypto_shash_final(shash, profile->hash);
>  	if (error)
>  		goto fail;
>  
> 

