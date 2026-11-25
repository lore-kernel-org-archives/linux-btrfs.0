Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795637738;
	b=Gykpi8LU2+ljEfnfQQwBL7yveSUDoQG0SxoLE/kuHJqc33EdV4fvQ866YoeZ0gv1j9qp
	 ILhNphRRzbsqIGd36B+SlaGOmxzJ2mdskS1xvceGVelJV+M1VRbhchCQHdiGv2V44SDyr
	 CzhQcG1KgXjEo1/tE5WeGRiHSjMvzdhEhEbCdjp6hOe1Rk77DUgkAedMkFrAZxGv80Py6
	 rFYF5MsV6pZenVDo0S2vfRlWYft9rzLtd4JHH8NMYBIFW5Ruk7R4EBy5U6jsdBwfp7Hqb
	 8m3f56SqVmXZcHqKGLj51NOiDU/ZZw9qT0E5FP6zQbEwl/5gq0Y/pWOP3XaS5hzDjqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795637738;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=VjAawZmK4adGquUvf2bKR5vmv5LsHtKaxCEyqp2mZ8Q=;
	b=XjpwDpTOblsNzvEhC9eD2J3WA1Mib9ZOQfSivzp+Tvrjsh+KgjuRbSavC4qBiRruUrKp
	 hTTXUiIKZQ7X/ncGAirwUzMWL18Ak8OJjP9LIu5EqMsFCw2ScYQOPVkEbXq6suWCClPaE
	 25IavyOM3GprJxMOAWOfFloeCuBWcy4Unb1rNefLv62g6S6xL3QDHs9uQZ2HMXSi1unpW
	 oWBawknczcL0o8zNdA4MknAXfwXZUwbPofljWVW5xVE6mGSxpGr9/6WwbURLifES2GlgO
	 cRfqWEs+yzLNBI8AhImVI397C5+VByOfYdRsa5VEBUYp0cPaakAA1uj+b5gwsW+BwLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=AWaysXHt;
	arc=none smtp.remote-ip=209.85.218.49
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A015E606A330
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 20:15:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A015E606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=AWaysXHt
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c5133831027so885754766b.2
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 12:15:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795637736; x=1796242536; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VjAawZmK4adGquUvf2bKR5vmv5LsHtKaxCEyqp2mZ8Q=;
        b=AWaysXHtUkX9+stQx/HYwvBOzdjFGw9PA6dMFKC7PGKtByZl2xw0FcF7FhCvg1bw8P
         1aCu8O6+w4O2Nh2YsloNBYlj22lSYIwY2pGRAcbz8H8M7E4x/atWp6mgp3w7F60BIzBu
         A7bfBXMvFtVbYlUQ3jDhGDif218wDUFCkC26ESFm6RXRX5qgzKv4+QoFJh7OzCCywSC7
         FOlrgW3UDZvcPtO4ysuIF8Y/0E0In0+gwVAa4ADvdKW/VS8wsTxPyqduGBKvFL4ZZmJa
         DWAUHcJO9CdUtskWmXFeI8o++leBA1R17a15J+5YWUEPsqUYprdEfzjjka0WQwEI095Q
         OXaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795637736; x=1796242536;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VjAawZmK4adGquUvf2bKR5vmv5LsHtKaxCEyqp2mZ8Q=;
        b=VxdruQIj2GHfxYFohe9NMR8QIPjnrWwAJcP08WYp9bcYrp5JtONjWATjgcKtSVW3jP
         qk4dkVvyOE9YACkRJPbetLkU2gWldc/rqCSCjAcipoP17hA0l9HmOVk4EqB5Y5hF0w8A
         C9EcQPoAYr/itWiGDzBbCd1VTolK27o4gtZE9z12BYmLmw/9tKVHpFNq1GA0Z9Q44Fe5
         WA6wuN+P8D1R6ywcdL0+mqzbiV/kHaGenaFxZLL6oRADulA3obUhBl8pQLRLG3D3lyZH
         /iMAD0zJoHWk1DTxSEfAVb/CB8nId41sFLDKCm9dqpnQNKvzRRVnFFJ+RTc9AF9D5lst
         wP7Q==
X-Forwarded-Encrypted: i=1; AL+hErEqS3griEwMsdRoKsLDWFyGPsFlpd76Ge3Vw3VDcDqJ3tqvsezbzH5jDkriU0XBauR56362b7fBAWu8cw==@vger.kernel.org
X-Gm-Message-State: APuU4Z+UGksVlTETqYppBDDtQ19AmCIv7U+27VYcKOPma5KyVfxbJ0Ls
	pbJr9WPjozyOWKFDCO2bO5ivhIjBx2iM+1Dq+uw3UUIJ/AcyOaGkzHy07ieebMI30Xg=
X-Gm-Gg: AZFdTZd3Rjxnns4Lrfk1fd803ZIrY/WSflRsLVuPkMHURMMfiWGvfoB+7vajDpV20BG
	EIorL3ZBsjVccEAxEafVweQEmCYr26Pxw7kleQSQnXZ8xN9G/pDQVB+xGz6llrqEw1IvQ9aoeyW
	+xMOpmiz5YPKxvigo5PO3TkiQO4dq6AUImpOKtpIlIt78hAxqE2FevILgx2I0cyo5gpuLkvBG+t
	aHe3m4n3ZVzwNTZWRo9s9TqYQ0OrqWQ53Y+mjVUyW1JTV2Stj1uHqUhTEi5+a3oqWTbOBjUng/g
	usCY6pDxHFoX3iHPEv1v/B/vIlKpi9sJ7+K7LeCXe5xGSeynKPh8T6Tf0XDwOkpmt2ZsI1Xx6ZP
	QADoJoOuJcZnc9zyvtWugGgQGJ5Yint1kp27hclte4x09Kz9sNVvV1ibjku5XVQ1Bj7uHFjYvS1
	npgDPB2HyC1lZVNS3ZOrPZm72kkMt1Rp+CuE7aH4BJS+cTMbLcGXGg/CfBCKRjudtSiYZQlVDls
	hl2VamuwR73K06h5T8QDBmNibARZCdYVvX90Gt4rXimB/AhLIej00GqtH13UKbzVc6w80ky+3kj
	0Uj3LPoEI16NWz6k+UF64Uw=
X-Received: by 2002:a17:907:9692:b0:c48:ddac:7eb1 with SMTP id a640c23a62f3a-c513aad95cbmr1548985466b.45.1795637735895;
        Wed, 25 Nov 2026 12:15:35 -0800 (PST)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f04ed9620esm85182655ad.26.2026.11.25.12.15.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Nov 2026 12:15:34 -0800 (PST)
Message-ID: <ff0e9c8e-051b-424c-a07c-67f99cad1702@suse.com>
Date: Thu, 26 Nov 2026 06:45:29 +1030
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/6] fs: btrfs: Avoid the remaining 64-bit divisions
To: Josef Schlehofer <pepe.schlehofer@gmail.com>,
 u-boot@lists.u-boot-project.org
Cc: Tom Rini <trini@konsulko.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 Bradley Morgan <bradley.morgan@linux.dev>, linux-btrfs@vger.kernel.org,
 =?UTF-8?Q?Marek_Beh=C3=BAn?= <kabel@kernel.org>
References: <20261125124259.95636-1-pepe.schlehofer@gmail.com>
 <20261125124259.95636-7-pepe.schlehofer@gmail.com>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJq3ujyBQkUpLw5AAoJEMI9kfOh
 Jf6o8OIH/0mqW+TQM4m2x3hCsnK+oB4yJH1qnGvIhFF/Lhs48wI02sGh6/4aA0hkCDfd9LHQ
 +ci4FUepZ9y4VS01+oIExbg/8ytzGYTzLtb44jK2GBOBVSJkMiha6jp22XFt7WUkT/tvbreu
 WWdGsaJIRQaZChy7xsMI8lqQ2WdmluZJ4LT0wD3l/l6QU1ZseMGySebdY9sVOQEOJNV7Qj92
 /KOAFNmeZshV/qDI8Iw1RTs6TvLqCcqmlZLCmJkYSVhT1RonWRren8xIRcFEgMe004IDnt7V
 qdQhk/nhTS9x9MBAhMRl0TTE1VKDLvVALsud3iZLrmmtYvwPApzGJk052f0m28vOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJq3ukKBQkUzDspAAoJEMI9kfOhJf6o
 SNsH/1ysUWOKmzY0rGS3ZdS61QgqMGhSWD/EJ4UiPw+xO4l4+GtX0fOAqxqsmBKqje3vyhBa
 Z5o/1Y+gNiN+E6RBcSz4b1TAd78sQ2bvT5DWOvBjeeVxHdiuQMIn4S8xk5ZpySBw5ifjoiuL
 0M33UVtJOzM8yfAeL+d/Rp4leJw72SutjkLyZTG/gJIp4pJGD/kFHn24OLL0IxEcO0gOekNZ
 os5e1R6jAJ2ILk7+MDnvU8wXHcCiVzuDhJLI1tih1uUIE50muHQJWbYuVBbdJeu8WlIDDssx
 UOCxLylNG3gDXV5MhLubPTOpp9OiFc/XC37nvkgEcrlmlOFBv4/NJCbECpo=
In-Reply-To: <20261125124259.95636-7-pepe.schlehofer@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/11/25 23:12, Josef Schlehofer 写道:
> On 32-bit PowerPC, GCC turns the u64 divisions in btrfs_stripe_length()
> and in the RAID5/6 code of __btrfs_map_block() into calls to
> __udivdi3(), which U-Boot's private libgcc does not provide.
> calc_stripe_length() has the same divisions.
> 
> U-Boot never runs these divisions. btrfs_stripe_length() and
> calc_stripe_length() have no caller, and the RAID5/6 divisions sit in
> the branch that fills a raid map, which needs a raid_map_ret. Both
> callers of btrfs_map_block() set it to NULL. Builds of turris_1x_nor
> and turris_1x_sdcard still link that branch, and with it __udivdi3().
> 
> Use div_u64(). Its divisors fit into 32 bits: num_stripes is a u32 or
> an int and stripe_len is an int. full_stripe_len is the product of two
> ints, so declare it as a u32.
> 
> linux/math64.h pulls in linux/log2.h, whose is_power_of_2() conflicts
> with the copy in compat.h, which returns int instead of bool. Include
> linux/log2.h in compat.h and drop the copy.
> 
> Suggested-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
> Signed-off-by: Josef Schlehofer <pepe.schlehofer@gmail.com>
> Cc: Marek Behún <kabel@kernel.org>
> Cc: Qu Wenruo <wqu@suse.com>
> Cc: Tom Rini <trini@konsulko.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/compat.h  |  6 +-----
>   fs/btrfs/volumes.c | 19 +++++++++++--------
>   fs/btrfs/volumes.h |  9 +++++----
>   3 files changed, 17 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/btrfs/compat.h b/fs/btrfs/compat.h
> index e6784884835..f973f3f1185 100644
> --- a/fs/btrfs/compat.h
> +++ b/fs/btrfs/compat.h
> @@ -4,6 +4,7 @@
>   #define __BTRFS_COMPAT_H__
>   
>   #include <linux/errno.h>
> +#include <linux/log2.h>
>   #include <fs_internal.h>
>   #include <u-boot/uuid.h>
>   
> @@ -74,9 +75,4 @@ static inline void uuid_unparse(const u8 *uuid, char *out)
>   	return uuid_bin_to_str((unsigned char *)uuid, out, 0);
>   }
>   
> -static inline int is_power_of_2(unsigned long n)
> -{
> -	return (n != 0 && ((n & (n - 1)) == 0));
> -}
> -
>   #endif
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 71b0b55b9c6..fcb20a761f5 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -2,6 +2,7 @@
>   #include <stdlib.h>
>   #include <errno.h>
>   #include <fs_internal.h>
> +#include <linux/math64.h>
>   #include "ctree.h"
>   #include "disk-io.h"
>   #include "volumes.h"
> @@ -825,17 +826,17 @@ u64 btrfs_stripe_length(struct btrfs_fs_info *fs_info,
>   		stripe_len = chunk_len;
>   		break;
>   	case BTRFS_BLOCK_GROUP_RAID0:
> -		stripe_len = chunk_len / num_stripes;
> +		stripe_len = div_u64(chunk_len, num_stripes);
>   		break;
>   	case BTRFS_BLOCK_GROUP_RAID5:
> -		stripe_len = chunk_len / (num_stripes - 1);
> +		stripe_len = div_u64(chunk_len, num_stripes - 1);
>   		break;
>   	case BTRFS_BLOCK_GROUP_RAID6:
> -		stripe_len = chunk_len / (num_stripes - 2);
> +		stripe_len = div_u64(chunk_len, num_stripes - 2);
>   		break;
>   	case BTRFS_BLOCK_GROUP_RAID10:
> -		stripe_len = chunk_len / (num_stripes /
> -				btrfs_chunk_sub_stripes(leaf, chunk));
> +		stripe_len = div_u64(chunk_len, num_stripes /
> +				     btrfs_chunk_sub_stripes(leaf, chunk));
>   		break;
>   	default:
>   		/* Invalid chunk profile found */
> @@ -1085,17 +1086,19 @@ again:
>   			int rot;
>   			u64 tmp;
>   			u64 raid56_full_stripe_start;
> -			u64 full_stripe_len = nr_data_stripes(map) * map->stripe_len;
> +			u32 full_stripe_len = nr_data_stripes(map) * map->stripe_len;
>   
>   			/*
>   			 * align the start of our data stripe in the logical
>   			 * address space
>   			 */
> -			raid56_full_stripe_start = offset / full_stripe_len;
> +			raid56_full_stripe_start = div_u64(offset,
> +							   full_stripe_len);
>   			raid56_full_stripe_start *= full_stripe_len;
>   
>   			/* get the data stripe number */
> -			stripe_nr = raid56_full_stripe_start / map->stripe_len;
> +			stripe_nr = div_u64(raid56_full_stripe_start,
> +					    map->stripe_len);
>   			stripe_nr = stripe_nr / nr_data_stripes(map);
>   
>   			/* Work out the disk rotation on this stripe-set */
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index 9d1a07ae789..d66547c6c10 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -4,6 +4,7 @@
>   #define __BTRFS_VOLUMES_H__
>   
>   #include <fs_internal.h>
> +#include <linux/math64.h>
>   #include "ctree.h"
>   
>   #define BTRFS_STRIPE_LEN	SZ_64K
> @@ -138,16 +139,16 @@ static inline u64 calc_stripe_length(u64 type, u64 length, int num_stripes)
>   
>   	if (type & BTRFS_BLOCK_GROUP_RAID0) {
>   		stripe_size = length;
> -		stripe_size /= num_stripes;
> +		stripe_size = div_u64(stripe_size, num_stripes);
>   	} else if (type & BTRFS_BLOCK_GROUP_RAID10) {
>   		stripe_size = length * 2;
> -		stripe_size /= num_stripes;
> +		stripe_size = div_u64(stripe_size, num_stripes);
>   	} else if (type & BTRFS_BLOCK_GROUP_RAID5) {
>   		stripe_size = length;
> -		stripe_size /= (num_stripes - 1);
> +		stripe_size = div_u64(stripe_size, num_stripes - 1);
>   	} else if (type & BTRFS_BLOCK_GROUP_RAID6) {
>   		stripe_size = length;
> -		stripe_size /= (num_stripes - 2);
> +		stripe_size = div_u64(stripe_size, num_stripes - 2);
>   	} else {
>   		stripe_size = length;
>   	}

