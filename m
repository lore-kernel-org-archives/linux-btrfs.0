Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:42084 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337AbaIWIy4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Sep 2014 04:54:56 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Message-id: <5421356E.10401@samsung.com>
Date: Tue, 23 Sep 2014 11:55:10 +0300
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: behanw@converseincode.com, agk@redhat.com, clm@fb.com, davem@davemloft.net,
        dm-devel@redhat.com, fabf@skynet.be, herbert@gondor.apana.org.au,
        jbacik@fb.com, snitzer@redhat.com, tadeusz.struk@intel.com
Cc: akpm@linux-foundation.org, bruce.w.allan@intel.com,
        james.l.morris@oracle.com, john.griffin@intel.com,
        linux-btrfs@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-ima-devel@lists.sourceforge.net,
        linux-ima-user@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-security-module@vger.kernel.org,
        neilb@suse.de, qat-linux@intel.com, serge@hallyn.com,
        thomas.lendacky@amd.com, zohar@linux.vnet.ibm.com,
        torvalds@linux-foundation.org, tglx@linutronix.de
Subject: Re: [PATCH v4 11/12] security,
 crypto: LLVMLinux: Remove VLAIS from ima_crypto.c
References: <1411447337-22362-1-git-send-email-behanw@converseincode.com>
 <1411447337-22362-12-git-send-email-behanw@converseincode.com>
In-reply-to: <1411447337-22362-12-git-send-email-behanw@converseincode.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 23/09/14 07:42, behanw@converseincode.com wrote:
> From: Behan Webster <behanw@converseincode.com>
>
> Replaced the use of a Variable Length Array In Struct (VLAIS) with a C99
> compliant equivalent. This patch allocates the appropriate amount of memory
> using a char array using the SHASH_DESC_ON_STACK macro.
>
> The new code can be compiled with both gcc and clang.
>
> Signed-off-by: Behan Webster <behanw@converseincode.com>
> Reviewed-by: Mark Charlebois <charlebm@gmail.com>
> Reviewed-by: Jan-Simon Möller <dl9pf@gmx.de>
> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: tglx@linutronix.de

Looks good. Thanks.

Acked-by: Dmitry Kasatkin <d.kasatkin@samsung.com>


> ---
>  security/integrity/ima/ima_crypto.c | 47 +++++++++++++++----------------------
>  1 file changed, 19 insertions(+), 28 deletions(-)
>
> diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
> index 0bd7328..e35f5d9 100644
> --- a/security/integrity/ima/ima_crypto.c
> +++ b/security/integrity/ima/ima_crypto.c
> @@ -380,17 +380,14 @@ static int ima_calc_file_hash_tfm(struct file *file,
>  	loff_t i_size, offset = 0;
>  	char *rbuf;
>  	int rc, read = 0;
> -	struct {
> -		struct shash_desc shash;
> -		char ctx[crypto_shash_descsize(tfm)];
> -	} desc;
> +	SHASH_DESC_ON_STACK(shash, tfm);
>  
> -	desc.shash.tfm = tfm;
> -	desc.shash.flags = 0;
> +	shash->tfm = tfm;
> +	shash->flags = 0;
>  
>  	hash->length = crypto_shash_digestsize(tfm);
>  
> -	rc = crypto_shash_init(&desc.shash);
> +	rc = crypto_shash_init(shash);
>  	if (rc != 0)
>  		return rc;
>  
> @@ -420,7 +417,7 @@ static int ima_calc_file_hash_tfm(struct file *file,
>  			break;
>  		offset += rbuf_len;
>  
> -		rc = crypto_shash_update(&desc.shash, rbuf, rbuf_len);
> +		rc = crypto_shash_update(shash, rbuf, rbuf_len);
>  		if (rc)
>  			break;
>  	}
> @@ -429,7 +426,7 @@ static int ima_calc_file_hash_tfm(struct file *file,
>  	kfree(rbuf);
>  out:
>  	if (!rc)
> -		rc = crypto_shash_final(&desc.shash, hash->digest);
> +		rc = crypto_shash_final(shash, hash->digest);
>  	return rc;
>  }
>  
> @@ -487,18 +484,15 @@ static int ima_calc_field_array_hash_tfm(struct ima_field_data *field_data,
>  					 struct ima_digest_data *hash,
>  					 struct crypto_shash *tfm)
>  {
> -	struct {
> -		struct shash_desc shash;
> -		char ctx[crypto_shash_descsize(tfm)];
> -	} desc;
> +	SHASH_DESC_ON_STACK(shash, tfm);
>  	int rc, i;
>  
> -	desc.shash.tfm = tfm;
> -	desc.shash.flags = 0;
> +	shash->tfm = tfm;
> +	shash->flags = 0;
>  
>  	hash->length = crypto_shash_digestsize(tfm);
>  
> -	rc = crypto_shash_init(&desc.shash);
> +	rc = crypto_shash_init(shash);
>  	if (rc != 0)
>  		return rc;
>  
> @@ -508,7 +502,7 @@ static int ima_calc_field_array_hash_tfm(struct ima_field_data *field_data,
>  		u32 datalen = field_data[i].len;
>  
>  		if (strcmp(td->name, IMA_TEMPLATE_IMA_NAME) != 0) {
> -			rc = crypto_shash_update(&desc.shash,
> +			rc = crypto_shash_update(shash,
>  						(const u8 *) &field_data[i].len,
>  						sizeof(field_data[i].len));
>  			if (rc)
> @@ -518,13 +512,13 @@ static int ima_calc_field_array_hash_tfm(struct ima_field_data *field_data,
>  			data_to_hash = buffer;
>  			datalen = IMA_EVENT_NAME_LEN_MAX + 1;
>  		}
> -		rc = crypto_shash_update(&desc.shash, data_to_hash, datalen);
> +		rc = crypto_shash_update(shash, data_to_hash, datalen);
>  		if (rc)
>  			break;
>  	}
>  
>  	if (!rc)
> -		rc = crypto_shash_final(&desc.shash, hash->digest);
> +		rc = crypto_shash_final(shash, hash->digest);
>  
>  	return rc;
>  }
> @@ -565,15 +559,12 @@ static int __init ima_calc_boot_aggregate_tfm(char *digest,
>  {
>  	u8 pcr_i[TPM_DIGEST_SIZE];
>  	int rc, i;
> -	struct {
> -		struct shash_desc shash;
> -		char ctx[crypto_shash_descsize(tfm)];
> -	} desc;
> +	SHASH_DESC_ON_STACK(shash, tfm);
>  
> -	desc.shash.tfm = tfm;
> -	desc.shash.flags = 0;
> +	shash->tfm = tfm;
> +	shash->flags = 0;
>  
> -	rc = crypto_shash_init(&desc.shash);
> +	rc = crypto_shash_init(shash);
>  	if (rc != 0)
>  		return rc;
>  
> @@ -581,10 +572,10 @@ static int __init ima_calc_boot_aggregate_tfm(char *digest,
>  	for (i = TPM_PCR0; i < TPM_PCR8; i++) {
>  		ima_pcrread(i, pcr_i);
>  		/* now accumulate with current aggregate */
> -		rc = crypto_shash_update(&desc.shash, pcr_i, TPM_DIGEST_SIZE);
> +		rc = crypto_shash_update(shash, pcr_i, TPM_DIGEST_SIZE);
>  	}
>  	if (!rc)
> -		crypto_shash_final(&desc.shash, digest);
> +		crypto_shash_final(shash, digest);
>  	return rc;
>  }
>  

