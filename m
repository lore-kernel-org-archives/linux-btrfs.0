Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793916392;
	b=F3pATTjO++SwIghYLQIST8fcR2Zvsuym1r1wGcgn5TEXNQH/GUS32+TDFj6YZ4erFuF5
	 itK37oBW3zPdCReVGzOLhYP2BzIEeSj6zdlQiNHXOzXtvYQ/w9OsIgF2eaH/rN/QVfxtB
	 kxI/a5LGykLwY4471Mhz5MPEpOY43sEuSUe1gQA2EbIig5H+39QfwKRpRuXy0bKKLdzZW
	 4OJL/Pz9FNqWLVGBgttnmd4MjPjx8JTox5MaXB1Do7OtU0Dqc1TA2oig3t172d8qSr0C9
	 cKJeQ/JvLDLE6lXBeyvZ/Oi0p0ztUKy3ouMxOt0nlykccFexXzxGV2zkhIh+rbTm4Ig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793916392;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=ddrnZmJB37VdL/q6siqf8NrklVhSy4qXZBmdXTHloB8=;
	b=C733VL2fuzhW2X16JdyN8Bvm41iXh9kHxunNVCjJBPInroc6GZc0VlqUCNy3/GXQmxKe
	 YS0zg5Yfyqo6OmOxaiSX7t+x4lVBFL4Yb772luyOro2v3YHHP/nb5yu6Ag4s8bTuKg9ny
	 TC1MPB/pa4GcMSKDeE7f+Ls8ix+9oE/OAy0mEW+JvbR2gVTaIQzwmxHxgboFfw3g6qLx4
	 q4KvQCkZFW1mbWrs5EmJ0Ok6tJN2f4OFXRY0eHjbSm8g11WzgX3QX/FTA6Zo8OkRnExnH
	 p05cHNgxdHJZ0clgmzBXaykk62WKgdYVg6NMuFP7B4xL16+zj5KpEIHzFrZDKeECp0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=WWJn3IZu;
	arc=none smtp.remote-ip=209.85.128.49
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A6C606A329
	for <linux-btrfs@vger.kernel.org>; Thu,  5 Nov 2026 22:06:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 93A6C606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=WWJn3IZu
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4a214c5c4c0so143555e9.3
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Nov 2026 14:06:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793916390; x=1794521190; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ddrnZmJB37VdL/q6siqf8NrklVhSy4qXZBmdXTHloB8=;
        b=WWJn3IZu7/SBCB169KNJ09KjsviN3ME4cBl1ctqAtT1wnxTAHTXBfL0aVNat86L/Ik
         rew7TuRrNSljKrYLdSvxfQeEb3fagl3RHJ3UT7Pz8SyAGHEJq4aXR76oNzpCPUxSjwVL
         wWLZZvPlDb8FzUiviess2qAH/M/ocI4U8Mz7i7dGJjjv8hgan6iegAGL83dMBWrO1Ezd
         hQCZ6CAZ0xp83fsXLn1NdlOp9obV09taUMZR0sj/hUsRhwbQQ/EyT5j3oMhQT1VqdNP0
         drpqwQftx1DUSbakA9BTc/DLUyWQR8gyeelLNYAS753/pQCSh5iJ2UVBR2d69iWgF3cf
         z1uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793916390; x=1794521190;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ddrnZmJB37VdL/q6siqf8NrklVhSy4qXZBmdXTHloB8=;
        b=pZAMF3ueq0OnbMEvqiHcmwKEF5Kkzub47n+mBUc3SEDTjo611F5unHBNP8WsJpiZGn
         BfaeYfLtbyEj9A0lHkWtTPWJW8ooEdc/tq5zU/KeRd1B1Mdvb0TUXYE8KkwsctUx5Y0c
         lXXYDRpnagVnvhbQjKqOm1/JEAjVL2lElVQe35B78ttxyhkQ+V4E4sWYzQUPbvYjD0lr
         HVtIcO87GeNNJFikZ0bfLbA/oz/nylZtWw/dkGlrfONTb+d8h0Nz7OQm7o9mnLs1Zf17
         ogXwLhy/t/LFOpqfvJ00I2RmmBLGqqAu69rLsV1vKxevuKYspnJwbH38zrJ+uCj05GOM
         myfA==
X-Forwarded-Encrypted: i=1; AKwUvBxkn6HT5xqq9xznsQ6+up1StHsb4XnnGlfTselw/jwN2QxtYKPKAMFL79kGlmVWKPiuEEEDElxjmTXTaw==@vger.kernel.org
X-Gm-Message-State: APuU4Z/nw2aFKTUic7vFcIPde9S8kznz++MsyQbw1LobwQD+Fe2kARwv
	Ua9UUBDxhEUtVMvrXQ0Lj+FzXBKIF6EnpakPAxk4dIlWcP2hBYDF5Orqx/q5/OlLOqI=
X-Gm-Gg: AYBFou1dFggFy/E2ai9CyoTPVLhlL5Zrh6bIrGzfE2lzLLJ3Ws+2yVAuu0ShbyAzqnK
	q0Wbvjw4tNDiTMSun/vTv0nolAMKJ2jYvRKEJEqLigt+PwnR6PKeQL5mwe5FMxjh24kybSHcG4t
	ERapbAiTO6Gw5w5F10+3YiZ3hAbHv05sp7N4eLoxf5YoK7rbLs6WuZi3OJMw60SbDs8tiNN0fUC
	z6tJeOW2CiQjS+BN7NvEplbsBiHOJeEXNygAdlj12nZ7LawuXBYR3SdCJOy29GMQsTR069N2IaN
	xeDUbu1jUO0HERjgyoAheqrkylEwjX5cXkGeNVMvE7TdZYjIOJsgMEZYyjX6pKkKBdYjfNPwakW
	Y7pwxGRLoVG/iab0im4sl8jU3vZ3sW0gC41/mENd8EmS5I9AXewXhv/70GQr7+2P42U+1ZVp3Hs
	DhTn6PnhZWjsKzkG63QNSWoLbYDFlym2nmHz2TkEL9Q2cSipG0GPyMZX8JYL+9d2TUwfyo1IBQ+
	PowUdBko/SUreOGrDS6Pjf4LFPbdkCOmOWfLx5bfRBAW9CevHJpETm+ttzB6blLek6OIQHdjXMD
	Z2PUKmmVtjUeBVSU8kN2
X-Received: by 2002:a05:600c:310f:b0:4a1:acaa:9d4c with SMTP id 5b1f17b1804b1-4b6de78934bmr7539875e9.25.1793916389942;
        Thu, 05 Nov 2026 14:06:29 -0800 (PST)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36f736a1da4sm1108191eec.7.2026.11.05.14.06.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 14:06:28 -0800 (PST)
Message-ID: <7595d1e6-b61d-48fc-b616-5562735297d2@suse.com>
Date: Fri, 6 Nov 2026 08:36:23 +1030
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
Subject: Re: [PATCH 2/2] btrfs: tree-checker: add balance item size check
To: Siddharth Mishra <smish149@asu.edu>, dsterba@suse.com
Cc: mason@kernel.org, josef@toxicpanda.com, fdmanana@kernel.org,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261105214738.111967-1-smish149@asu.edu>
 <20261105214738.111967-3-smish149@asu.edu>
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
In-Reply-To: <20261105214738.111967-3-smish149@asu.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/11/6 08:17, Siddharth Mishra 写道:
> [BACKGROUND]
> A paused or interrupted balance leaves a balance item in the root tree,
> with the key (BALANCE_OBJECTID TEMPORARY_ITEM 0) and a struct
> btrfs_balance_item of 448 bytes.  At mount btrfs_recover_balance()
> reads the flags and the data, meta and sys args from this item, and
> the balance is resumed with them.

What's the point? The background provides nothing useful.

You should directly say that a too small balance item can make btrfs to 
read beyond item boundary.

> 
> [CAUSE]
> The tree-checker has no check for TEMPORARY_ITEM keys, and
> btrfs_recover_balance() reads the item without checking its size.
> With a balance item that is too short, the reads go past the end of
> the item into the data of the previous item in the leaf,

Or even beyond the leaf boundary if it's at the last slot, which can be 
more problematic.

> and the
> balance is resumed with whatever those bytes hold.  Nothing is
> reported.  For example this balance item is 48 bytes short:
> 
>    item 11 key (DATA_RELOC_TREE ROOT_ITEM 0) itemoff 12545 itemsize 439
>    item 12 key (BALANCE TEMPORARY_ITEM 0) itemoff 12145 itemsize 400
>                                                         ^^^^^^^^^^^^
> 
> The mount succeeds and the balance is resumed:
> 
>    BTRFS info (device vda): balance: resume
>    BTRFS info (device vda): balance: ended with status: 0

I don't think the succeeded case adds any value.

> 
> [ENHANCEMENT]
> Add check_balance_item() to reject a balance item whose size is not
> the size of struct btrfs_balance_item, so the leaf is refused when it
> is read:
> 
>    BTRFS critical (device vda): corrupt leaf: root=1 block=30654464
>    slot=12, invalid balance item size, have 400 expect 448
>    BTRFS error (device vda): read time tree block corruption detected
>    on logical 30654464 mirror 1
>    BTRFS warning (device vda): couldn't read tree root
>    BTRFS error (device vda): open_ctree failed: -EIO
> 
> Signed-off-by: Siddharth Mishra <smish149@asu.edu>
> ---
> An alternative is to check the size only where the item is read, in
> btrfs_recover_balance(), before bctl is allocated.  That refuses only
> the balance item and fails the mount with -EUCLEAN, instead of refusing
> the whole root tree leaf:
> 
>    BTRFS error (device vda): invalid balance item size, have 400 expect 448
>    BTRFS error (device vda): failed to recover balance: -EUCLEAN
>    BTRFS error (device vda): open_ctree failed: -EUCLEAN
> 
> It was tested the same way as this patch.  The tested diff, indented so
> that it is not applied with this patch, in case it is preferred:
> 
>    diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>    index 3d4ef6725..97154f59f 100644
>    --- a/fs/btrfs/volumes.c
>    +++ b/fs/btrfs/volumes.c
>    @@ -5230,11 +5230,17 @@ int btrfs_recover_balance(struct btrfs_fs_info *fs_info)
>     		return 0;
>     	}
>     
>    +	leaf = path->nodes[0];
>    +	if (unlikely(btrfs_item_size(leaf, path->slots[0]) != sizeof(*item))) {
>    +		btrfs_err(fs_info, "invalid balance item size, have %u expect %zu",
>    +			  btrfs_item_size(leaf, path->slots[0]), sizeof(*item));
>    +		return -EUCLEAN;
>    +	}
>    +

Don't put another diff part, even with extra spaces to break diff format.

I'm almost hitting the key to send out a comment criticize the 
duplicated code.

All you doing is just to make the whole patch hard to read, not only the 
comments after the "---" but also the cursed alternative.


If you are not sure about what is the correct way to validate such item, 
do read old codes/history of tree-checker and similar patches in the 
mailing list that got rejected.

Then you should not come up with such stupid question of using the 
alternative way.


The patch looks good, but the bad comments after "---" are so bad that 
they make me hesitate to even add my reviewed-by tag.

>     	bctl = kzalloc_obj(*bctl, GFP_NOFS);
>     	if (!bctl)
>     		return -ENOMEM;
>     
>    -	leaf = path->nodes[0];
>     	item = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_balance_item);
>     
>     	bctl->flags = btrfs_balance_flags(leaf, item);
> 
>   fs/btrfs/tree-checker.c | 17 +++++++++++++++++
>   1 file changed, 17 insertions(+)
> 
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index f021ac14b..5698845be 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -2117,6 +2117,19 @@ static int check_qgroup_status_item(const struct extent_buffer *leaf, int slot)
>   	return 0;
>   }
>   
> +static int check_balance_item(const struct extent_buffer *leaf, int slot)
> +{
> +	const u32 item_size = btrfs_item_size(leaf, slot);
> +
> +	if (unlikely(item_size != sizeof(struct btrfs_balance_item))) {
> +		generic_err(leaf, slot,
> +			    "invalid balance item size, have %u expect %zu",
> +			    item_size, sizeof(struct btrfs_balance_item));
> +		return -EUCLEAN;
> +	}
> +	return 0;
> +}
> +
>   static int check_remap_key(const struct extent_buffer *leaf,
>   			   const struct btrfs_key *key, int slot)
>   {
> @@ -2512,6 +2525,10 @@ static enum btrfs_tree_block_status check_leaf_item(struct extent_buffer *leaf,
>   	case BTRFS_QGROUP_STATUS_KEY:
>   		ret = check_qgroup_status_item(leaf, slot);
>   		break;
> +	case BTRFS_TEMPORARY_ITEM_KEY:
> +		if (key->objectid == BTRFS_BALANCE_OBJECTID)
> +			ret = check_balance_item(leaf, slot);
> +		break;
>   	case BTRFS_IDENTITY_REMAP_KEY:
>   	case BTRFS_REMAP_KEY:
>   	case BTRFS_REMAP_BACKREF_KEY:

