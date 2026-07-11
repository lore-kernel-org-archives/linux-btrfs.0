Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B3821B905
	for <linux-btrfs@vger.kernel.org>; Sat, 11 Jul 2026 22:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783809950; cv=none; b=Q/JDArSk1tpoHvTVnzAWz0gIRNMAAsLCiC0j+HBfLrZfID0wj6/7dMDqsd+1rUkJ+hOAWm9uCpVa72nus8f55LcWROb40C3ns+5T77TBegdnCgiVVJIg+e0+vJI97rlNZ8UTKhD8JYwH8HN9FWHQ1a1pilauheYe9AJpqaRjSBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783809950; c=relaxed/simple;
	bh=4CQdKFoQlLz1juoPgLWZH/Qe2GtlOUwe6pBmAi57Vz8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rIbvXu1YfY4Ox40QPgwqSsgn0Myq4ABpgVrnsJJYPKwjRTFsL5MA0XlFI2P03eC7CDw7z1aHBgrxVFl4jIdMdqHyKzbiQVfAgsNjgu/7WSLd9WNipeDaSR3TQWF5bau6RZO5zTanIUUhoo/vt2PUTiwxzs6+KHIGHYAZaNc8M4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=FJCkHCB4; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="FJCkHCB4"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-493bf73ec2aso13882095e9.2
        for <linux-btrfs@vger.kernel.org>; Sat, 11 Jul 2026 15:45:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1783809947; x=1784414747; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TbHFAwbeJKDJK0vsusjVHYsKb/LRqI4cM06SE7LoHSg=;
        b=FJCkHCB4s0sGVIw/E5X2bfF4IwEGfLMDg2EdF6SzzsbSgbFxZWw6WuNG3XJ2ZWdRmT
         LZ+ibI717zDCcslIyfAjY60HnI5h3bxnBuCoCFe64J3TCby11ZhcrjvLbe0VJSquY4FN
         TnyI4AyIB5toZlMGjVO1fX9KCXabTF2DhgiZUocWpX8vVgC5Nn7V/UAOVLRXWGUEfh68
         tnBydoaGMkjJrC+t/aeydTbRnoXTmsda3rfl9+a3at4L56iQdDx/a+BtXe3j2Nma0tv0
         suEg+ajhx2+g9E0ofRf3+WBcL/jf6uuFJZphWC6DxYFkK4Fv21cS1IHJ3vzn+HP59SLc
         PFNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783809947; x=1784414747;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TbHFAwbeJKDJK0vsusjVHYsKb/LRqI4cM06SE7LoHSg=;
        b=hpKXOnh48x1WxvLSski0UI0qqKnu8MekPLQlaMOWDrnar2pmlk2DLVKaGo/z+A0tj9
         6vNwqEB0cOb3aTZ2aDb9m5lSuCPFgrlkeXM3aSsu9habNvjL+LC3Dt0Wpg7t0zxU5nBY
         tBQ0tb1p9rZ2EYae/hL+Px1qz3np5XScAn/C0q5PzeQcaB7HhwLSFj9PdMJ6Lw3UH3mS
         wTbGQLabZ0gno7ElZkb8B0VRVF2UCZQdH1MBNpA+teH3lAIuBSi01hV6vH23cOzmjNTa
         PY063CwbVP3h2+Jo0kESJq/7SV33BEK0mDzwGqEfSJi31SZmwt1jxtS2311+/Jo7K467
         tP4A==
X-Gm-Message-State: AOJu0YwGoXl0hXFflHtzrAYif5APYPG27XBYwqsyaN4p+c+BoHJ4XoGP
	dJ0HqUFs7U/booIIGIbmTfhcKaE7wb4jERdME8Hk2TnZw5IF4OnjfqiXmNAZfZ5Ggd2VuJ7okz5
	4o53AdFz+VQ==
X-Gm-Gg: AfdE7ckczNlVhRpF3cAq6E3MX9fLrX6cikrDPAbaBV9AxofMq8DtL7Pc1Wsh2B6twgf
	N8mVvGP5rS8YZAkvAkAkrMCYsCk+1sthg+gkxuf+iI1kHEcbkz2hVr3FQxS+KZsc17byplTVrsR
	EPs2YO8krHl3FGY9vz/k7Z4Re4+ltwFCxYiyVhj3uuqSQk+P06OC+owJnl17kHtG+gOZb59ArvU
	mXJjGuckgudRgJD6df52XNS37WAhrU/9qw2cYNzzTsK89ySnySYoUy2nlVLLbkFr0cMlOZhxBBn
	Ct3lvrne4ZK4quuOORT3BgdvmXuYarU+abWxB3bb70EBs8buVRBjGFe5WhnESkGqFk28JEIfDnb
	N/mncJqTUtBpti5Rt7dKXI9o1kpp4qY18rmoKgiLO3WArhURKwVTSuzl4i20A3Qw33vx7C/wxYB
	tHCBJ5Mw5lq/GIypMm
X-Received: by 2002:a05:600c:8285:b0:492:41c9:886b with SMTP id 5b1f17b1804b1-493f87e5a53mr38829965e9.14.1783809947401;
        Sat, 11 Jul 2026 15:45:47 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6db0eaasm12003342b3a.52.2026.07.11.15.45.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Jul 2026 15:45:45 -0700 (PDT)
Message-ID: <07f63ae8-bdf2-4e6b-98d1-32dc3e083463@suse.com>
Date: Sun, 12 Jul 2026 08:15:40 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: free mapping node on duplicate reloc root insert
To: Guanghui Yang <3497809730@qq.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <tencent_39D68A519E8921206E77105E313354703C08@qq.com>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXVgBQkQ/lqxAAoJEMI9kfOh
 Jf6o+jIH/2KhFmyOw4XWAYbnnijuYqb/obGae8HhcJO2KIGcxbsinK+KQFTSZnkFxnbsQ+VY
 fvtWBHGt8WfHcNmfjdejmy9si2jyy8smQV2jiB60a8iqQXGmsrkuR+AM2V360oEbMF3gVvim
 2VSX2IiW9KERuhifjseNV1HLk0SHw5NnXiWh1THTqtvFFY+CwnLN2GqiMaSLF6gATW05/sEd
 V17MdI1z4+WSk7D57FlLjp50F3ow2WJtXwG8yG8d6S40dytZpH9iFuk12Sbg7lrtQxPPOIEU
 rpmZLfCNJJoZj603613w/M8EiZw6MohzikTWcFc55RLYJPBWQ+9puZtx1DopW2jOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXWBBQkQ/lrSAAoJEMI9kfOhJf6o
 cakH+QHwDszsoYvmrNq36MFGgvAHRjdlrHRBa4A1V1kzd4kOUokongcrOOgHY9yfglcvZqlJ
 qfa4l+1oxs1BvCi29psteQTtw+memmcGruKi+YHD7793zNCMtAtYidDmQ2pWaLfqSaryjlzR
 /3tBWMyvIeWZKURnZbBzWRREB7iWxEbZ014B3gICqZPDRwwitHpH8Om3eZr7ygZck6bBa4MU
 o1XgbZcspyCGqu1xF/bMAY2iCDcq6ULKQceuKkbeQ8qxvt9hVxJC2W3lHq8dlK1pkHPDg9wO
 JoAXek8MF37R8gpLoGWl41FIUb3hFiu3zhDDvslYM4BmzI18QgQTQnotJH8=
In-Reply-To: <tencent_39D68A519E8921206E77105E313354703C08@qq.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/7/12 01:11, Guanghui Yang 写道:
> __add_reloc_root() allocates a mapping_node before inserting it into
> rc->reloc_root_tree.  If rb_simple_insert() finds an existing entry, it
> returns the existing rb_node and leaves the newly allocated node unlinked.
> 
> The error path then returns -EEXIST without freeing the new node.  Since
> the node was never inserted into reloc_root_tree, the later cleanup in
> put_reloc_control() cannot find it either.
> 
> Free the newly allocated node before returning -EEXIST.
> 
> The callers currently assert that -EEXIST should not happen, so this is a
> defensive cleanup for an unexpected duplicate insert path.  If the path is
> ever reached, the local allocation should still be released.
> 
> Signed-off-by: Guanghui Yang <3497809730@qq.com>

Missing fixes tag.

In commit ffd7b33944f4 ("btrfs: __add_reloc_root error push-up") there 
is still the proper kfree(), but now it's not there.

There must be a commit removing that kfree().

> ---
>   fs/btrfs/relocation.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index fb85bc8b345c..7e451e587726 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -588,6 +588,7 @@ static int __add_reloc_root(struct btrfs_root *root, struct reloc_control *rc)
>   		btrfs_err(fs_info,
>   			    "Duplicate root found for start=%llu while inserting into relocation tree",
>   			    node->bytenr);
> +		kfree(node);
>   		return -EEXIST;
>   	}
>   

