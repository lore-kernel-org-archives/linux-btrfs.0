Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795386970;
	b=KTfDvNpjvnLF2aqiB6QqhIfAY9TJRr5Iuiommk/Xwwxeu1vvsnPxd6oUAc6oD3HzHBNU
	 Fl8PuA0Js+BwjtQNyk58mk9GE8eBG6ejNAXk8HXF1wZAkoHS9bk3cqqCcvgnChf6HPjQR
	 6r6QjrCm8SERcGaYezy/LUi083SHQf8V6K3od6xSwNqQudlA1xk1Nk5zeQ3erzTItjShh
	 nAaoPMFQUx2p3OJR/T/spLNMjDm2n7o5Y+iNfxmxpLAH+TMiNjuYQ9ijv1iieQYzmOPpj
	 VSrqhD79/XNcB1Mldt9nHDXsT0Kmekj/Vao10vDVvneCR8capTav47On8mwvo7VG3Gg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795386970;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:From:To:References:Content-Language:
	 Autocrypt:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=b0Lb/4RFK0FweH2YwYmHERdqnmipO/3sQPrwaiR8P6Q=;
	b=5MA71aIdsX5/vZVJTDXP9BkMrJhhn6fWh/SYyyblfjY7I2BllwtV698N0QPT35HinPwY
	 FY5/MLBGsMGgVMZNFGq1u9S4SZzywCH3U7MahXnQEVeyxn6qZWeHiwNSOT2BDvErUJ8NT
	 QEeZWs5EMDhVwbW0i2qdOBFeSj6j0RvT1ur75BKG75etDm/qNfBYCXSFlN3hh6IBAl78w
	 LaYGEQq/6Jy6jNniYlMCSswBKN9nTiQaVOtV+tEAKKC/cad2gvB0Z8j0gjNqNuOPIyNID
	 wiCI1AZUFfd0HCiRkHX0h4qmi+lnjxbxioS4+7Fm92RkAUHaEqFOwu4fPq89D0FzRWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=XJh10apk;
	arc=none smtp.remote-ip=209.85.218.44
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5784A606A31A
	for <linux-btrfs@vger.kernel.org>; Sun, 22 Nov 2026 22:36:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5784A606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=XJh10apk
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c50933bdf4bso595442466b.1
        for <linux-btrfs@vger.kernel.org>; Sun, 22 Nov 2026 14:36:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795386969; x=1795991769; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:references:to:from:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=b0Lb/4RFK0FweH2YwYmHERdqnmipO/3sQPrwaiR8P6Q=;
        b=XJh10apkVydvSHnw23Uj1HO5nOSDXD/ZJOc57ixShS8KF68arttJt3ziRO6Y9jeUpa
         XPVEh9fJHYhoJVBl0olNgn2w+I/ELN5a845p63ZbozfvZTQJJBE8ASzndlFOBO/tKGg3
         hS01ymYKCQ5WhslnEbnA3YWsV7ZrmSaY3xkcoGWotfvLX8i09uuXzf741TPNEdAz6+SN
         O5tAiipCRuYLih51Nz8kAQd2ZIIu26PQ1o2gKLNplx6VC/+h3Q+l17pyUbcqF6Tr03ei
         V3AKfd49kaM79X8Mp99oQackSkj/Q7b1AgIACPnLal/HFkPD9ti977sd0Czel8DoDe0J
         Oezg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795386969; x=1795991769;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:references:to:from:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=b0Lb/4RFK0FweH2YwYmHERdqnmipO/3sQPrwaiR8P6Q=;
        b=n+ETO9p8SC4EBgbGMExQUdsl/WNErGRzCM6fQ4g2BCGteBBARaSzIQib20jW78Xepj
         RLkMqn1ZuUidpwdERflvOq70Gd42CusiP8DhPylRfDfJGyNPq7Uovn4sApR5IaMQp0S4
         h1VCLGOuFMITS0CnZbiglvk2sQi+hhVFSDxLcRC9FA7lSSEX+65/o6NFdVOrv94Q1lKY
         9WC2JPO6B9ntS6FMwddZqhUxhfh7fyT5rOUYMwws9w3yFEph+XShvRRhzR1xayZ5t0FE
         9vr5dYKj7WlLTdmsxaEn6JkHQ3U3JJpZUe2CwgruKR43gD7xYq6VVy9PHmhwYu0BtadP
         4hIQ==
X-Gm-Message-State: APuU4Z8MlubpXb57NfrMT2NLC50QROn8pQAaeT0KPDuzQw54JLUVgXu4
	gs8REuaqZApIWVRnHSkNWJPNmCjOdKOB0RN/2XXKNoHEw64feiiUJ85aTNfjGf9xufbLhhby6m8
	LwKU/m59xDw==
X-Gm-Gg: AZFdTZeevQj5jJjfzbj4NOeJd3OuOzDNvGuTc+LTFopPv60SvD8FBC9BeqPY6QcZK0X
	BvIbT+PXV+pzJa3s7jkz2mH7m0wOxKbX5MZ9LR6PM7eNZc5GYc1y/0+9+aVFJbKIuKhbMw+z50B
	FVEGHBGxpwjF3tpiXqyn//eHxuDXfn5TZP5mNN4dAtNFcW8CCrFkRucishWOSuntEihJOIrZm7x
	By59fCH8Rji0MeeMQlqYI0ZaYORynAx7duMlGi2/r0iiAr4S3C4pCkbkDGqBUxV/6rcko4Gn0XR
	fqv9/Unxl8GebUCCMW5ohttIHTHED4KK5TIrtDW1rrX5NI05ZqvW08XE6mQnrgDzcdumfaXpg1J
	80Zb+RzNqwtpxm1EGzIHqW0dHJSuYMUjuSmR/CwSjVR2JVCbqeVUXCv+MKMC5qtDOe8rUGq6eyk
	GoX+XflaKyP83ui/6vnzT/ISXs6Vy6Zsg7mPDgUHylNTfI6uSuXY7Z7Dgt6ZoCnoG1ffEC8asXq
	b9wd3xnyuUPP1fngA98eyb8FeBcLuLlQGyjml393cYy4Bwr/miwlbx6yI+LZGvHECSwGP8Sq09a
	OkD5a1IIX0SmaaygfaLmTw==
X-Received: by 2002:a17:907:8e95:b0:c46:9745:ac13 with SMTP id a640c23a62f3a-c5131a79f69mr917635466b.32.1795386968641;
        Sun, 22 Nov 2026 14:36:08 -0800 (PST)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41adcafe0sm15563228a91.16.2026.11.22.14.36.05
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Nov 2026 14:36:07 -0800 (PST)
Message-ID: <5f24cb48-df8d-413a-82f4-6a50e650e8a2@suse.com>
Date: Mon, 23 Nov 2026 09:06:02 +1030
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
Subject: Re: [PATCH] btrfs: remove btrfs_is_free_space_inode()
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
References: <4d3a1d10aff29e6b65ee681cbd7e82e306e69d6e.1795385532.git.wqu@suse.com>
Content-Language: en-US
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
In-Reply-To: <4d3a1d10aff29e6b65ee681cbd7e82e306e69d6e.1795385532.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/11/23 08:42, Qu Wenruo 写道:
> Since we have disabled v1 space cache, there is no need to maintain that
> function.
> 
> Remove it along with the BTRFS_INODE_FREE_SPACE_INODE flag.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Please drop this one.

Sashiko mentioned that those paths can still be hit for v1 cache clearing.

> ---
>   fs/btrfs/btrfs_inode.h |  7 -------
>   fs/btrfs/inode.c       | 19 +++----------------
>   2 files changed, 3 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
> index fbcf8ca05fb7..5ffe89279f15 100644
> --- a/fs/btrfs/btrfs_inode.h
> +++ b/fs/btrfs/btrfs_inode.h
> @@ -85,8 +85,6 @@ enum {
>   	 * on the same file.
>   	 */
>   	BTRFS_INODE_VERITY_IN_PROGRESS,
> -	/* Set when this inode is a free space inode. */
> -	BTRFS_INODE_FREE_SPACE_INODE,
>   	/* Set when there are no capabilities in XATTs for the inode. */
>   	BTRFS_INODE_NO_CAP_XATTR,
>   	/*
> @@ -394,11 +392,6 @@ static inline void btrfs_i_size_write(struct btrfs_inode *inode, u64 size)
>   	inode->disk_i_size = size;
>   }
>   
> -static inline bool btrfs_is_free_space_inode(const struct btrfs_inode *inode)
> -{
> -	return test_bit(BTRFS_INODE_FREE_SPACE_INODE, &inode->runtime_flags);
> -}
> -
>   static inline bool is_data_inode(const struct btrfs_inode *inode)
>   {
>   	return btrfs_ino(inode) != BTRFS_BTREE_INODE_OBJECTID;
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 40dd87276cc9..47d5da483d11 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -3930,8 +3930,6 @@ static int btrfs_init_file_extent_tree(struct btrfs_inode *inode)
>   		return 0;
>   	if (!S_ISREG(inode->vfs_inode.i_mode))
>   		return 0;
> -	if (btrfs_is_free_space_inode(inode))
> -		return 0;
>   
>   	inode->file_extent_tree = kmalloc_obj(struct extent_io_tree);
>   	if (!inode->file_extent_tree)
> @@ -4287,14 +4285,9 @@ int btrfs_update_inode(struct btrfs_trans_handle *trans,
>   	int ret;
>   
>   	/*
> -	 * If the inode is a free space inode, we can deadlock during commit
> -	 * if we put it into the delayed code.
> -	 *
> -	 * The data relocation inode should also be directly updated
> -	 * without delay
> +	 * The data relocation inode should be directly updated without delay.
>   	 */
> -	if (!btrfs_is_free_space_inode(inode)
> -	    && !btrfs_is_data_reloc_root(root)
> +	if (!btrfs_is_data_reloc_root(root)
>   	    && !test_bit(BTRFS_FS_LOG_RECOVERING, &fs_info->flags)) {
>   		btrfs_update_root_times(trans, root);
>   
> @@ -5602,8 +5595,7 @@ void btrfs_evict_inode(struct inode *inode)
>   
>   	if (inode->i_nlink &&
>   	    ((btrfs_root_refs(&root->root_item) != 0 &&
> -	      btrfs_root_id(root) != BTRFS_ROOT_TREE_OBJECTID) ||
> -	     btrfs_is_free_space_inode(BTRFS_I(inode))))
> +	      btrfs_root_id(root) != BTRFS_ROOT_TREE_OBJECTID)))
>   		goto out;
>   
>   	if (is_bad_inode(inode))
> @@ -5872,11 +5864,6 @@ static int btrfs_init_locked_inode(struct inode *inode, void *p)
>   
>   	btrfs_set_inode_number(BTRFS_I(inode), args->ino);
>   	BTRFS_I(inode)->root = btrfs_grab_root(args->root);
> -
> -	if (args->root && args->root == args->root->fs_info->tree_root &&
> -	    args->ino != BTRFS_BTREE_INODE_OBJECTID)
> -		set_bit(BTRFS_INODE_FREE_SPACE_INODE,
> -			&BTRFS_I(inode)->runtime_flags);
>   	return 0;
>   }
>   

