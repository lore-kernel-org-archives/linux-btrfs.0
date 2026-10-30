Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793393871;
	b=TNWKOl3awwSYZURSq8+JsNhbnvVeFPMftMsOoHCR8pvzKYy3gjtpVCEpV4JSjZaDWr8n
	 0X1x99fkMj4SdWvI1LjagMKvdI7k7AFD9DmrIg7T32prsqyvPxLTvdUii7T5h5FJ0Gj5S
	 OX4gX62rgwJ6O95Z4ZhvL8/fbsaao6opCCNqwh9A+wAsfzqYNXDyNdW1iAlouhdQpWDYu
	 G23PSJwEhgyCDBavDIavicEDbVkLiImL2nhOFajAJzFDjfwOf8guWWJWkMbMc0uu7XmPH
	 BPW7ZMRYEArIVq85uCq2pzD3rlzVRIdiy63MN+i5INf5D90b9AWIGS25Ca8udDQ/vpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793393871;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:Autocrypt:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=h+46bkDry+sIUzzigKe4U0zYwNBSXXeQxCLzrMv+t7M=;
	b=oFjPhfetLrsRsDxsAGysa0NjAGHwY5+Nb91NE7UBCGaTMbJ6/haXX3NcqBI2nc52AWSH
	 BKulV99IbSzMpc9QceKuZeN62cb6E5W/o4xAX+uGi+cNzQF85bU+04wqFA9WDMYy9UE8i
	 XChQk2k0g2QGQjGl1dXjIg/vRbqVWvRXZbyfInt3ToFG2QiKPS2u7LhX/sq8mXZhonYiW
	 oRHIsF+axn/idcbs6s9A+ID3m9E47KmdSJ7F6ELpDi51Y0iEikD5n4MO8xclDwxFrLwal
	 rQ+s/P7FDZnVIjGy79U2xiFMDUJhGSNoEpLFgNa9HpWefluArybjxO6mMVM6TFJRabQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=GVCw6oRk;
	arc=none smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F171606A31C
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 20:57:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4F171606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=GVCw6oRk
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a4dc547987so6352185e9.0
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 13:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793393869; x=1793998669; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=h+46bkDry+sIUzzigKe4U0zYwNBSXXeQxCLzrMv+t7M=;
        b=GVCw6oRkNd5STrpyXjA2GUJdkkqV53Xm4yIswuTyFQ9fa8g/P0T4pFIU0TuN/g3/hv
         mSUhmEc/x0xIQP3fZqo8A5tQo3SJ6RNDfpt/U00ziYsn08LwXzLZ7BoK9v0d9LZ11m7I
         GKzLeOtK7OzqSVS+BZzV0uN5Fg69xgmD8o5nAo7wojTNmk+f0g9SOyLbthFsNLtS8nDS
         eVXPTIK0OnFWYgV6hG2bQp2tXaSF5BmNQyiuKeX+yPH54jF8z8eqPrIM94cBp7LhWltp
         Qp6Fm82J/TCLsToIE8Gipgl3LtqkH5o7wWISZsBzGoMVcYFmevqeqcDdnm8HvnHwFl2+
         XL6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793393869; x=1793998669;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=h+46bkDry+sIUzzigKe4U0zYwNBSXXeQxCLzrMv+t7M=;
        b=phIx5nbB1AvuLdtJPevKPFkqsA4hxyqGUp5l90hn/sSRxy872dpXkkuTcqB9IHXYp3
         aG1Qn+JdHqeYma2C0JX4ATXHuxWAxQn0VZtE3i9ctCEYSmMJZCk9IItiOhx30vtuatbn
         7VUaGaU1RIBFSRTRMI5+CmM0W6kTuviyMji9CST1iR1dOCcCRRMUaSJZUvgVIWjNAmC7
         W6wECU0gQxbznPxqS/khM2asXo+RIrBn6xULfa9aPDZd5aMYYTwaWqg9fLByWiUmQu/y
         JzV09GLwZwrsQxKsam1Gxj6LbIIQK2p1Y9vnxhLbiXad9vQdCg59ZBtpPCFsrc2YhcUY
         C/Hw==
X-Gm-Message-State: AFq9FYL2mA/nBKKlGYQPOtj7Bv0CEG46vui1nGNWKsHfDxsq9LwmgYL5
	/cJLi0PHfrPc69NY4ryQ6Z1bMD/Q70h3TGa2KXiRYZYyucx0fxj+5Eu+sn/9xNLm+rg=
X-Gm-Gg: AYBFou3w/J+/ypXWMT1Wmlo8kPJ+3uYScJoaLRT0J6AvLPSAb17wfK7LiPp+AIm6R6+
	oD0S4VvHbK08HvktRmPANh0mkR1BRl0nkkfuEHMJPbgj6pAIUpPAeGzk+LxCmg90ApQvBIT45uQ
	hLAErmUJBPTd3xoM0T85kYno4dZ2qT+hyxdEKsh6HOBhJKlx90U0hEvequnSU+kfWtJ69zeNWK5
	1n5VYsRRtn5DxeYV1isnXAujnuJ96SlD3HLZUi2MxGST9/7/Q/pmB+JND/APOWTF97zO/hJO2Fk
	k4lQpbakQfC5KKPyc6bu5AsV7Gy8AznGH4Jc+kNiyDCoXFydd0a7vZaIwO42U3Nr51+I1IlFzly
	twoYMoYK54dSZRNs7vxGhIugckC4hW/9oIwGWjqz4qNZBOwVyjgfWWBL+kHV0tYkqlwkVanAFiL
	HifpHvHj980PNpS9iTrnR//EnI0CelLOccxF8F1azJ4lEa7s4cnY+Fxsp6vtiOTZfjmk3N+Twwr
	hfAzwI3QlNWA8q6/8iwOREwAjCn4bcoF4FYM3ZLYxAzxl3rYKqy+6gmcAhd7LTyfVWaG2lMvSrZ
	J2gOd7Ru/AEO6qwZohMivPSkp2snigdLQyVvPsVX5l4=
X-Received: by 2002:a05:600c:840e:b0:4a1:813f:2a60 with SMTP id 5b1f17b1804b1-4ac17d168b1mr84999465e9.11.1793393868759;
        Fri, 30 Oct 2026 13:57:48 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae6e8fb2c5sm9913650a91.3.2026.10.30.13.57.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Oct 2026 13:57:47 -0700 (PDT)
Message-ID: <ff0a86d9-51e3-4001-b375-6bc8392cf139@suse.com>
Date: Sat, 31 Oct 2026 07:27:40 +1030
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
Subject: Re: [PATCH 2/5] btrfs: clear dirty blocks after a delalloc failure
To: Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
 Chris Mason <mason@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>, Boris Burkov
 <boris@bur.io>, Filipe Manana <fdmanana@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20261030-b4-btrfs-data-integrity-v1-0-f4d4196731e6@toxicpanda.com>
 <20261030-b4-btrfs-data-integrity-v1-2-f4d4196731e6@toxicpanda.com>
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
In-Reply-To: <20261030-b4-btrfs-data-integrity-v1-2-f4d4196731e6@toxicpanda.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/10/31 01:08, Josef Bacik 写道:
> If writepage_delalloc() runs the first delalloc ranges of a folio and
> then btrfs_run_delalloc_range() fails, the blocks that already got an
> ordered extent are finished with an error through
> btrfs_mark_ordered_io_finished(), but their dirty bits are left set. The
> next writeback then submits blocks whose ordered extent is gone, or is
> about to be completed a second time.
> 
> Fix by clearing the dirty bits and cycling the writeback state for those
> blocks, as submit_write_sector() does for a block it fails to submit.
> 
> Fixes: 72dad8e377af ("btrfs: fix double accounting race when btrfs_run_delalloc_range() failed")
> CC: stable@vger.kernel.org # 6.14+
> Assisted-by: LLM
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/extent_io.c | 10 ++++++++++
>   1 file changed, 10 insertions(+)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 5ff630630490..3283835ccb5e 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -1746,6 +1746,16 @@ static noinline_for_stack int writepage_delalloc(struct btrfs_inode *inode,
>   			u64 start = page_start + (start_bit << fs_info->sectorsize_bits);
>   			u32 len = (end_bit - start_bit) << fs_info->sectorsize_bits;
>   
> +			/*
> +			 * The blocks are not going to be submitted, so they
> +			 * must not stay dirty. Otherwise they are written back
> +			 * later without an ordered extent, or worse, with this
> +			 * one if it is still around, and invalidating the folio
> +			 * would account for them again.
> +			 */
> +			btrfs_folio_clear_dirty(fs_info, folio, start, len);
> +			btrfs_folio_set_writeback(fs_info, folio, start, len);
> +			btrfs_folio_clear_writeback(fs_info, folio, start, len);
>   			btrfs_mark_ordered_io_finished(inode, start, len, false);
>   		}
>   		return ret;
> 

