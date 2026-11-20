Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795206141;
	b=GqsBvtUYUY5svzXg7VMdOaCS6ES6ul6oh/3hNW28evkn7Tyg1kYUeWKo5fxbs2Rraeql
	 /Rxfm7Qnk2Vhe9lbyVjBPAJWXk9Nky6ZAKIgkZe6zJELTc13N2KPA0tJ1tgNgyMVUQ8L9
	 oOIP+LKVCNJqFyjb0i3acPbK43LxnOqJtojcP0dgJqPgNQTNNYn+6JBZe0LtZ2XeeXrcn
	 iQ8fAXck0PSh7+OswhOSo/vzRrasdSvkr56MXNbVf3bt9O8bshwPV50v+akn4I0I5pZp/
	 XMcMs+aFUSGvEfY4HAj/RJM9xJb8ONrbMiCbTFrGcMP1Tsx3mav4gyF+6AZ5jxgP0/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795206141;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=A24LpEufLD+IT5DdnquyRKXTDx9ckNOnBsSiirRxiCU=;
	b=IgGA00RmQofMOFGcgciZmnO04L96FjD5QkKyIZDlTcgCcIRRFO9H3gEPU+nyzIxwtegl
	 cxDOr6/BjtE+XbbJ6kByyxfm4M51UY/CXXdpuzYQ0oQ70ErAqYMSW11g8ZMu5Ecgnw/o0
	 C8k+pdlo1hxuXsqnE6fkBqCqC2OkUgwhELdR5eaAhtSBFsxUrTq7WT3ObM3KhsM+m43tO
	 EEghFQO5zCRrLNfLk9lSHJQJET8VIYxZELm6cTINjAvxw+5WE9KMVVyJsJhwyYAIuC6u9
	 gXohS2DpmPE73Z4aRtmBvXglFjKXHp4y+3alppkVWhbEB17/sFi+5KMeeUUSGaD3V2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=es9wvLjt;
	arc=none smtp.remote-ip=209.85.218.54
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80862606A6EB
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 20:22:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 80862606A6EB
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=es9wvLjt
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c50933bdf4bso306796866b.1
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 12:22:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795206137; x=1795810937; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=A24LpEufLD+IT5DdnquyRKXTDx9ckNOnBsSiirRxiCU=;
        b=es9wvLjtGnX107b8yAjgWcxlscQ94B5SJRO2157ERKo0U9vtknz8J/s5C0TDW3Qgwe
         s1daeW6uwkT4xrmEppjROhvmDyr21T6ayVJDj+XXEhqEJjI6xAMeLow1g4vKhpgSO8UN
         DDDqo8Bbe4eEEsymSnOqr6+fvHV8qmJKWaqHj5rOYR0TgMqD9Rk6Ad3ax/JvyvG9+2hY
         RJNiWrmGwXrTYqUeiURBafSwiHuyk0VBNu3v+n4lE9CoaSq7R0sMYm7Aril+VZnjpATD
         vXUYaxcBKq6lpj3qaNX2HeP3XEJ8Ih/p8yTg9cH4zlFqtfNb5B86KLWdHworg44dGyZC
         009w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795206137; x=1795810937;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=A24LpEufLD+IT5DdnquyRKXTDx9ckNOnBsSiirRxiCU=;
        b=WL4m28zZk+7/uQoqui8KFCe1sjlczeOD5XlZ+cl0Z3rnrsZd6o0I/jTbHtdLKbfeN0
         grgkPfjbYQz0jtD+Kt2s71M4EZRGbRd7EalfpQ3YMM3JiML6n6lxtjG6WGb+yeUiJ41y
         FJY0bTY4lnYzmBKZKv0OUakPe1aqpvmCJWhAYas6XxRYHIgCTnbCAvgxFRmYIJQCqWS5
         VTqw6O9EpSOCbC5OaKxsWV7uhrkRYbwjcAfsV+ucY4Gl6bTCj42UnWzCIURhLQ+IZy27
         BQUyVYpP9S9h8zf/MHIpC1+DuqXhTIPlPBInEbBvUsZGm8XqVcVX0NWQGrFmXzPpaUuD
         o27w==
X-Forwarded-Encrypted: i=1; AL+hErFab+EfA+H0Jgy1Q6VBPbVG2Qm0FIPm4cz6Q5eKAUooJlPiXjPPuyYwGqahYIWCqP4hRNGR20vOcpHFkw==@vger.kernel.org
X-Gm-Message-State: APuU4Z/DSokTyLOgUIpyBNrY0a8sTBWeKBA0tbPO47R8cosUtpeiTYBc
	9QW+8nle4yJ0QndywGFD9TVPegXNRAAs8LKeYM2z24yBmp8qnBWHk+M7yzQGcrqxKXc=
X-Gm-Gg: AZFdTZfWoZo8zofQs53JAKNLSzn/CdC1z5Nsix4AQGS0I+650aCMrzzeX1VzgnfzKan
	qImsFVIvwPXZE1z4B1wKjjgbTCAd+002EBkaDSxyNDw8139b9g4IW6OJGsQ0bFgu6rcrbGU5YO+
	3wv92aV6H+XJ65HHzhRbTEIjbXxHzTC3c4y/bUQRCipz4De8LxlYVn8ManCKVofs0OiBHR/4Yg+
	rhvCC2jOZLf5C5F3ot4oKXw6BRN1ug2vmEVLxT2Xgpzsn55IOVRICvcdSsvBD7WPpM5YAMUpnrp
	1kO5Jdahyw8bHQ1Z5j1P5VaD24HLpEqLmZJIg9nK6qEnbDFgHD3vpeeWAfl/h3MyIbTskEA4AWx
	Y79HsEUblU7lvpaKE2O5Yc0siU1HCxKL4aa8ETfJqlPNPnZvWwBgK6j5v/RD/pIub9kSiFxsZKj
	RG0ArxaWcaHebgPI0qram49bcrPlV5wDJqsr+TiPohwk7G3cWcOk9jyCtEcSh15PhRC9Q107i31
	efrV2snYGIOcvZ0edzndqhJf+O6diegL6bbq0U8AGTiBAf/dlcJoGIwHTnUOMqqzMIJLDRNNBes
	WHdpBwExQf/a9DBiieIEyw==
X-Received: by 2002:a17:906:4fd1:b0:c46:7de7:e41d with SMTP id a640c23a62f3a-c51318a03d9mr592653366b.18.1795206136666;
        Fri, 20 Nov 2026 12:22:16 -0800 (PST)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03f0c1a8asm18569905ad.24.2026.11.20.12.22.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Nov 2026 12:22:15 -0800 (PST)
Message-ID: <1ec06c42-b9e1-4222-ad9e-d3433788b80c@suse.com>
Date: Sat, 21 Nov 2026 06:52:11 +1030
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
Subject: Re: [PATCH] btrfs: fix leak of roots in dropped_roots list after
 transaction abort
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <7daabc94a5577726850f8f1c9dc7785077222111.1795198535.git.fdmanana@suse.com>
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
In-Reply-To: <7daabc94a5577726850f8f1c9dc7785077222111.1795198535.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/11/21 05:03, fdmanana@kernel.org 写道:
> From: Filipe Manana <fdmanana@suse.com>
> 
> If a transaction is aborted and happens to have roots in its dropped_roots
> list, we end up not empyting that list and drop the references for each
> root there, resulting in memory leaks. A root is added to that list after
> we delete a root, with a call to btrfs_add_dropped_root(), where we remove
> the root from the fs_roots_radix radix tree. As a consequence during the
> transaction abort path, we never drop the reference for such a root since
> we don't find it in the fs_roots_radix radix tree and we don't empty the
> dropped_roots list anywhere (like btrfs_cleanup_one_transaction(),
> cleanup_transaction(), btrfs_cleanup_transaction(), etc).
> 
> Fix this by updating btrfs_cleanup_one_transaction() to  iterate over the
> dropped_roots list and drop the log trees for all roots there as well as
> their references.
> 
> Fixes: 2b9dbef272b6 ("Btrfs: keep dropped roots in cache until transaction commit")
> Link: https://sashiko.dev/#/bug/linux-8cb356ea-6a28-4bfa-89d2-e04c9a391607
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/disk-io.c     | 14 ++++++++++++++
>   fs/btrfs/transaction.c |  1 +
>   2 files changed, 15 insertions(+)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 7775fc768f7e..d8d433ac458b 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -4982,6 +4982,20 @@ void btrfs_cleanup_one_transaction(struct btrfs_transaction *cur_trans)
>   		btrfs_qgroup_clean_swapped_blocks(root);
>   	}
>   
> +	spin_lock(&cur_trans->dropped_roots_lock);
> +	while (!list_empty(&cur_trans->dropped_roots)) {
> +		struct btrfs_root *root;
> +
> +		root = list_first_entry(&cur_trans->dropped_roots,
> +					struct btrfs_root, root_list);
> +		list_del_init(&root->root_list);
> +		spin_unlock(&cur_trans->dropped_roots_lock);
> +		btrfs_free_log(NULL, root);
> +		btrfs_drop_and_free_fs_root(fs_info, root);
> +		spin_lock(&cur_trans->dropped_roots_lock);
> +	}
> +	spin_unlock(&cur_trans->dropped_roots_lock);
> +
>   	btrfs_destroy_delayed_refs(cur_trans);
>   
>   	cur_trans->state = TRANS_STATE_COMMIT_START;
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index d2da7de4b905..1ea8dc522d2e 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -201,6 +201,7 @@ void btrfs_put_transaction(struct btrfs_transaction *transaction)
>   			btrfs_put_block_group(cache);
>   		}
>   		WARN_ON(!list_empty(&transaction->dev_update_list));
> +		WARN_ON(!list_empty(&transaction->dropped_roots));
>   		kfree(transaction);
>   	}
>   }

