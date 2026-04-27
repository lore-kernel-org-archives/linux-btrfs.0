Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99665175A81
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2026 01:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777252776; cv=none; b=V/dNDzerWNmOdqCODMvH+vZWcEKjD8IeGUQd9dIP6WhLFq5IxtBbsEeaXPXuxq4vcHQXlRZkCzYTTSFj59mVX6D0QweM2L5YQnFATP3CXFVmjnJ6+6vTz4gRPegNE4DIVCTgclc9G5ljkt//7ttFN8XbBzAxOadyC/YP9vJL0cY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777252776; c=relaxed/simple;
	bh=cE//m7gl/rU3Jh08tiv/QyI0mIek1ltAtnVJkj4Mb08=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Om6bU1V6cx0qMllDe+ehCxJTsDB/H5j/kuyfAheRK8jYRHyoEVSv9ynjb4t96iQpec1aHB2b9kNTh3E0z3KbhXC5gn1NvFf8qwbrXoaVx0FWlOOU9/H/xY8HNZUYhLMh1FAHfyGcEMEfddA6cuUlO2OT7zd1f0JzrwVEef1qOdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=BAc/sq+V; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="BAc/sq+V"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4896c22fcbaso69301505e9.0
        for <linux-btrfs@vger.kernel.org>; Sun, 26 Apr 2026 18:19:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777252773; x=1777857573; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=K3cNFQrS1vwtFEat7/IijKZfmevSFz1q6QiJ5x0gPgg=;
        b=BAc/sq+VdoG8Y2503l/dKw9Fg0pjdlfPoPnu+8LuLLofBy/t++L4ndhJ5eZ1agwxl5
         3DajS/gGmXil1EYYA7wARGqce0yPAUCW+hYZPlulkqzeifqD9slBJLkRAnVL0JFM6QWA
         oFa3Eo9COlIl3bUDXzEFzCoLpZgmfG+3atFXy3oyxBs6MJqMtZFU7T6JhkzzOBY3xuoN
         ThTBTuuO5P3biNYZjhANCsQ1bSL2oU4BAP0s6k9yZ7sAtBIXCTWhNT64yhp3JdHZ/fN6
         /5xjTVDLcboX9g34BgDYELAJoHInLqjnPQBZPN8g+YNrnsqrMrZPu2z7MFTT4JHXBhXE
         Gk6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777252773; x=1777857573;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K3cNFQrS1vwtFEat7/IijKZfmevSFz1q6QiJ5x0gPgg=;
        b=jP8/qRznDNtyaA5kqSRrArj+ZgJtbnqLC+Iv3VFC2EG3BQN0IfriStqrgmF+YN1Y48
         CIURVqLGtvDBwZwvdfT6DpP39ogQYNIPCY/zA2SUW+gsTvC7Yq6GH4lyab10bLjXmZBC
         48iippb5xhJobjARW3h5cvjP9SX9SEoxzxZuK3jEjqmP9y+HAhJM38+b+YoJjvcZeOzi
         jVw+kVaGpLrxMQdNaaeuI6atLSuvfb/OFrLetmgaQfTOygJYVwUawR8TtOARqeT3sgpM
         YyDYYT4F4vUnMfBUJdgJaIAT4cXFoHDUv5sCLG0K4ItJpmaQ+/R2LzQ5opeicygfGwCl
         PnLg==
X-Forwarded-Encrypted: i=1; AFNElJ/fjoVVKLMeXsMjEk8n+2if7ESVcIfoc5xd8Au77s1RtF7n7aIBP4p07l8w4aQ14zWnEqtgZhdyGrA2Lg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzEjGDnIaHTNBEbT3lKfPHegxdpVXWW11Y08bEtUnO21/p7Ri+z
	J6Y6ZFQCUwJjEACKGpgx+tsmwAyVQSR5+a1WTtsb1F9slDDlitL6Z1JvE/4pu3C4q04=
X-Gm-Gg: AeBDiesNxGrnH6IH4nlHpozLH9QTPXwgFQf8l4VL0FB5xa19XjTVvHrE3Hn/n9NQJVu
	PVX5irXm+IxPcnxg565Vm4MswAOZkbNQNQTKNsztNIP3S7Ic/xQRj1F3K4ekOiRX56R18PRGZux
	t8qfVB66iVwDkFabHUl8/PP15cf1z5rf6I1iMfji9A9RchXI6/ENKsN69y30wai7UdVICUUalrx
	Mtj6VOaZd82tp3plijetTFy4gc+/ma7aJLREW7v28EVuS+xrcnezlYG5wskvwVzvYFoH4BPvVer
	Wdex1CKUds58i8m3QOmRXgWz3bWWpwXQb9BN0jO6KObp8ac0f4YCW/BuF3R1oaRgUa35gQ+puFk
	+EH0WgR7+aeKr0YUppfXPFEcllmWexLkF+dIWLImlNv5ea+SsSbMmJpjnxLgLfn4rpEP6GkpWBr
	fnSRkcaX5RMiuez6bQusn3rr8gqNwZeAbZ9wEIQZJNrKov2Xy8sFZFd0mZ+oC3Tg==
X-Received: by 2002:a05:600c:a404:b0:48a:5342:36b5 with SMTP id 5b1f17b1804b1-48a6ea5903cmr53828885e9.21.1777252772893;
        Sun, 26 Apr 2026 18:19:32 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f8e982fd3sm38118168b3a.10.2026.04.26.18.19.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Apr 2026 18:19:31 -0700 (PDT)
Message-ID: <54f27c1a-eb99-43d0-bf57-9e99caf07cb5@suse.com>
Date: Mon, 27 Apr 2026 10:49:26 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: replace BUG_ON() with error return in
 get_new_location()
To: Teng Liu <27rabbitlt@gmail.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com, clm@fb.com, wqu@suse.co, linux-kernel@vger.kernel.org,
 syzbot+3e20d8f3d41bac5dc9a2@syzkaller.appspotmail.co,
 syzbot+3e20d8f3d41bac5dc9a2@syzkaller.appspotmail.com
References: <20260425061214.235982-1-27rabbitlt@gmail.com>
 <20260426201605.36626-1-27rabbitlt@gmail.com>
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
In-Reply-To: <20260426201605.36626-1-27rabbitlt@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/4/27 05:46, Teng Liu 写道:
> In get_new_location(), BUG_ON() crashes the kernel if the looked up
> file extent item has any of offset, compression, encryption, or other
> encoding set. The data reloc inode this lookup targets is populated
> solely by relocation's own prealloc and writeback paths:
> 
>    - insert_prealloc_file_extent() memsets the stack item to 0 and only
>      sets type/disk_bytenr/disk_num_bytes/num_bytes, so the four checked
>      fields stay 0.
>    - insert_ordered_extent_file_extent() copies oe->compress_type into
>      file_extent compression, but the data reloc inode is created with
>      BTRFS_INODE_NOCOMPRESS, so compress_type is always 0; encryption
>      and other_encoding are reserved-and-zero per the comment in that
>      function.
> 
> So observing non-zero compression, encryption or other_encoding here
> should on-disk corruption. A malformed image can reach this code
> through a balance operation and panic the kernel.
> 
> Replace the BUG_ON() with a return of -EUCLEAN, the established error
> code in fs/btrfs/relocation.c for filesystem corruption, and pair it
> with btrfs_print_leaf() and btrfs_err() as suggested by Qu allowing dmesg
> to log the necessary information. The caller in replace_file_extents()
> already handles errors from get_new_location() by breaking out of the loop
> without aborting the transaction, so no caller changes are needed.
> 
> Reported-by: syzbot+3e20d8f3d41bac5dc9a2@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3e20d8f3d41bac5dc9a2
> Signed-off-by: Teng Liu <27rabbitlt@gmail.com>
> ---
> Changes in v2:
>   - Pair the -EUCLEAN return with btrfs_print_leaf() and btrfs_err() so
>     the offending leaf is dumped to dmesg, per Qu's review:
>     https://lore.kernel.org/linux-btrfs/6c54901d-5e07-4c46-9553-997b28c93b86@suse.com/
>   - Expand the changelog to argue why non-zero compression/encryption/
>     other_encoding in the data reloc inode imply on-disk corruption
>     rather than a kernel bug.
> 
>   fs/btrfs/relocation.c | 15 +++++++++++----
>   1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index 1c42c5180bdd..bba28866df1c 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -814,6 +814,7 @@ static int get_new_location(struct inode *reloc_inode, u64 *new_bytenr,
>   			    u64 bytenr, u64 num_bytes)
>   {
>   	struct btrfs_root *root = BTRFS_I(reloc_inode)->root;
> +	struct btrfs_fs_info *fs_info = root->fs_info;
>   	BTRFS_PATH_AUTO_FREE(path);
>   	struct btrfs_file_extent_item *fi;
>   	struct extent_buffer *leaf;
> @@ -835,10 +836,16 @@ static int get_new_location(struct inode *reloc_inode, u64 *new_bytenr,
>   	fi = btrfs_item_ptr(leaf, path->slots[0],
>   			    struct btrfs_file_extent_item);
>   
> -	BUG_ON(btrfs_file_extent_offset(leaf, fi) ||
> -	       btrfs_file_extent_compression(leaf, fi) ||
> -	       btrfs_file_extent_encryption(leaf, fi) ||
> -	       btrfs_file_extent_other_encoding(leaf, fi));
> +	if (unlikely(btrfs_file_extent_offset(leaf, fi) ||
> +		     btrfs_file_extent_compression(leaf, fi) ||
> +		     btrfs_file_extent_encryption(leaf, fi) ||
> +		     btrfs_file_extent_other_encoding(leaf, fi))) {
> +		btrfs_print_leaf(leaf);
> +		btrfs_err(fs_info,
> +"unexpected non-zero fields in file extent item for data reloc inode %llu offset %llu (offset/compression/encryption/other_encoding must all be 0)",
> +			  btrfs_ino(BTRFS_I(reloc_inode)), bytenr);
> +		return -EUCLEAN;

This looks like exactly what we did in tree-checker.

And we have enough info to do this in tree-checker, the data reloc tree 
has a fixed id and owner in extent buffer header.

What about moving this to tree-checker where we already have 
check_extent_data_item().

Furthermore, if you move this check into tree-checker, it's better to 
print the offset/compress/encryption/other_encoding values.
And remove the "must all be 0", just something like:

file_extent_err(leaf, slot,
		"invalid members for data reloc tree, offset=%llu compress=%llu 
encryption=%llu other_encoding=%llu",
		...);


> +	}
>   
>   	if (num_bytes != btrfs_file_extent_disk_num_bytes(leaf, fi))
>   		return -EINVAL;

