Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E0671DC198
	for <linux-btrfs@vger.kernel.org>; Wed,  5 Aug 2026 21:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785967153; cv=none; b=ZXIVtSiYreqUBiWbHswLDxZhmg0Pg+tlAPXP1JZsJaQZrzP8bUF15+quQTgbtSBNbmWVPAgVEoyHo4Q6UIQiYxTg6PasSBJLN32soHdxoK8LnQhUwuTWgkqJmfLgpHeg1EYEdvIqLKvSD/CVL24V3DJjdmlTmVMrBTt74B/Ubos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785967153; c=relaxed/simple;
	bh=HF2qCPrGrCvcT+joDcKlGdgZHfZGq6tyxELCF3BC6dg=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=VXXlpteGSkiFywSE2+fH7xWZIP/Vm41mBsxNc9bxB5y7jO6A05qBqH669EM1Uh5+ALZyxYIxfgRUYapu4K2W5pnr9ZAkJ968IH+JTML1Jds/xvVWlBwQh/MI65uuAOq0WgRKEqxoBZ93y2wWaY0gTjNWMtCQ16aua0YczHHOwhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=XwGKDsMS; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="XwGKDsMS"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-495590dde14so16302545e9.0
        for <linux-btrfs@vger.kernel.org>; Wed, 05 Aug 2026 14:59:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1785967150; x=1786571950; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:references:to:from:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=85eKNTSlCVhszlEumT9TFX+9bVYLX8LRC/j6plXokP4=;
        b=XwGKDsMSqzBJsRaKodImspJ8n5etleC8O+tkGRFOJFC2zlFke+b0YT1EmMOWaR4wed
         bhgnuj0XRQ/wb56fjvCaRvmB1Dni4tYJijgmNqz3ywURSxnxLwoIGal3rUZnoD1AMU4U
         nvm0G8z16e/bilj6Z/CBFJvQjlC+PArnabr/N5p98Rzd4X5FtAJvn0Zz7Fyvsh4PFCBZ
         TitU/tiOt8nzj/AxeDneHWF1e7TutBzZ48rb5jbxBa6jidIfGuSer193hWefSRfuTt5H
         7iLBOMazPh0wOaFkCd8UK9UWwxLZ7r3JSfUlEVJehrSfQcJhNrIFjEmV9b4Ym1dDrd9m
         HQSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785967150; x=1786571950;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:references:to:from:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=85eKNTSlCVhszlEumT9TFX+9bVYLX8LRC/j6plXokP4=;
        b=S1BvEAU6hkPeuaXh3Nw0NKqV8BLHnkXtxLUpC0oXuXWsM6TZ5F85/KZ3sdlSGGMSuO
         5Qc1+Rn+WghutVMeAsmSI4TT1k9AvBgA66r3klQKcLck1teyE+wVwyIxa3+2Ch0L7CNn
         keBOaDIGD+atA6cYpZ+JM7t/18BdNaIx1Ku4DjVD5gvwvDyyjgy3h2eKANYfZKU9xn+s
         cHomqz6/gEc0tVN8i3K8R2tzQMsZQ/gcZoE6SFbM/cnDUJJZU0/eVawvBH9h0oY0lzHo
         eIFWHyzWOoUgQkQ0TrwF04tTUDHgsMW2FTZ3nHFq5xo9R6wiQhJB3r1q6U8n5rCPFoBt
         +hYQ==
X-Gm-Message-State: AOJu0Yz/YycK2euSg556hmSSR+NVSg96b4q59bKVDpxRRgs8b1g+mmwS
	MIenao9lLJQQ6nKwRHNkwpYauAChNulikgneKjp3+lJfLLI362W4fLCZ2MCbTsdgJqmURrAder8
	jNKYjnmGhhw==
X-Gm-Gg: AR+sD11uK7PnI12Km8CVeYwC4fgwsQjTtZyUBUbiZuv9/NvatC+IxVVBwQ6bUgUZ0oJ
	WcctCh9zhkhnaWQ+AfX9xfTmmWjBpCUNgf4KUIQfhOGZyoXYGWxrVsbtx8KRg7MHVpXHx3G6lGe
	ywS2xA8C0L7NtEG4Q20MzWV4M2+TClWj2pcKqH0HZwBQe1d70OE04zuXwy2kM+qL7Zv3HswWV4o
	/FClfci//Vtuu1aNMG5fv5/aAPQMER2WvYVEI3+dgsAsjsWlyhsk4F4/XEXWVbmBLEU33EYtTRr
	8Gp8C8hRYCICvxf2KvIGJ5e7YP1d4ai/w3AwGprDPf8cc9xYCik22Mv9z5vWxjo8SjT4LzQLrLF
	vI3WJOmqpq9ChyJZjDom3L/TbKewTwbnGVEhqHlP/Ge9Ly9nji+Qkr3BqYeHMYoa2QUchcSwhcl
	m/5wkh3u7Yiv7eOTKDpil6QIck23Sh6IlSKWexH/V42DEIh3jYkwrzuQ==
X-Received: by 2002:a05:600c:4f86:b0:495:4d00:2fda with SMTP id 5b1f17b1804b1-4994e72f7c1mr127777115e9.2.1785967149800;
        Wed, 05 Aug 2026 14:59:09 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13fca8df88csm15515264c88.11.2026.08.05.14.59.07
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Aug 2026 14:59:08 -0700 (PDT)
Message-ID: <205cb7c3-73b7-43e9-8f16-a8eef2e63981@suse.com>
Date: Thu, 6 Aug 2026 07:29:04 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/4] btrfs: removal of on-stack paddrs[], final part
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
References: <cover.1784011485.git.wqu@suse.com>
Content-Language: en-US
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
In-Reply-To: <cover.1784011485.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Gentle ping?

The series still applies without conflicts and reduces the on-stack 
memory usage.

Thanks,
Qu

在 2026/7/14 16:19, Qu Wenruo 写道:
> [CHANGELOG]
> v3:
> - Rebased to the latest for-next
>    There is a fix in RAID56, which can cause conflicts with the last
>    patch
> 
> - Remove all remaining on-stack paddrs[] usage
>    There are two last ones in RAID56, one can be converted to use bio
>    interface, the other is not using on-stack paddrs[] array.
> 
>    So we can finally remove all on-stack paddrs[] usage.
> 
> v2:
> - Fix a missing assignment for metadata repair
>    The logical should be assigned before passing it to
>    btrfs_repair_bbio_failure().
> 
> - Move the commit message of error message change to the correct patch
>    It's changed in the first patch not the last one.
> 
> Since the experimental bs > ps support, several on-stack fixed paddrs[]
> arrays are introduced, for assemble mutli-page sized fs blocks.
> 
> However that on-stack memory usage is always there for 4K page sized
> systems, no matter if the block size of the filesystem.
> 
> This series is part 1 of such on-stack paddrs[] cleanup.
> 
> The idea is to use bio interface for page iterations, the core idea is
> to use a const bvec_iter as the pointer to where the block is.
> 
> Then we save a local bevc_iter, and use the local iter to check the next
> few pages until we fill a full block.
> 
> Furthermore, with the help of bvec_iter, we can remove a lot of
> parameters:
> 
> - file_offset
> - logical
> - bio_offset
>    All can be generated by using the @iter passed in and the
>    bbio->saved_iter to calculate the old @bio_offset.
> 
>    @bio_offset is the (iter.bi_sector - saved_iter.bi_sector) <<
>    SECTOR_SHIFT.
>    As when bvec_iter is advanced, its bi_sector is also increased.
> 
>    @logical is simpler, just iter.bi_sector << SECTOR_SHIFT.
> 
>    @file_offset is the bbio->file_offset + bio_offset.
> 
> This means we no longer need to use on-stack paddrs[] to csum
> generation.
> 
> With bio interfaces, the iteration of an fs block is as simple as the
> following: (I tried to change the page/pg_off/cur_len into a macro just
> like btrfs_bio_for_each_block(), but failed)
> 
> 	u32 cur = 0;
> 
> 	btrfs_csum_init(&cctx, fs_info->csum_type);
> 	while (cur < blocksize) {
> 		struct page *page = bio_iter_page(&bbio->bio, iter);
> 		const u32 pg_off = bio_iter_offset(&bbio->bio, iter);
> 		const u32 cur_len = min(bio_iter_len(&bbio->bio, iter), blocksize - cur);
> 		void *kaddr;
> 
> 		kaddr = kmap_local_page(page) + pg_off;
> 		btrfs_csum_update(&cctx, kaddr, cur_len);
> 		kunmap_local(kaddr);
> 
> 		bio_advance_iter_single(&bbio->bio, &iter, cur_len);
> 		cur += cur_len;
> 	}
> 	btrfs_csum_final(&cctx, csum);
> 
> However there are still some callers left:
> 
> - Scrub
>    That's already addressed in another series accidentially
>    (https://lore.kernel.org/linux-btrfs/cover.1782795330.git.wqu@suse.com/)
> 
>    That will be last user of btrfs_check_block_csum().
> 
> - RAID56
>    That will be only location left without a bio.
>    In that case we can easily craft a local helper to do csum generation
>    without using on-stack paddrs[].
> 
> Qu Wenruo (4):
>    btrfs: replace btrfs_repair_io_failure() to use bio for page iteration
>    btrfs: enhance btrfs_data_csum_ok() to use bio for page iteration
>    btrfs: use a shared helper to calculate data checksum for a bio
>    btrfs: remove on-stack paddrs[] array usage
> 
>   fs/btrfs/bio.c         | 140 +++++++++++++++++++----------------------
>   fs/btrfs/bio.h         |   5 +-
>   fs/btrfs/btrfs_inode.h |  12 ++--
>   fs/btrfs/disk-io.c     |  25 +++++---
>   fs/btrfs/file-item.c   |  20 ++----
>   fs/btrfs/inode.c       | 114 +++++++++++----------------------
>   fs/btrfs/raid56.c      |  47 ++++++++------
>   7 files changed, 159 insertions(+), 204 deletions(-)
> 

