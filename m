Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7BC63CBE76
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Apr 2026 10:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776853788; cv=none; b=fL1WTqECa2tDTeH/eQJTfGT+sBYghsQGJMdWtV9t0vgZ9YolkTtEAW2ogXbW7R7TTZ04YNpPrDufiFT8+cMjar6fKKph7ynDeyAPz5xGvB3zx0QBlNWAdEUACaMc9W6sdoJRIsAJux6S9RzYctEvT2/RrRGFajDq7Nz0+jcb9cY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776853788; c=relaxed/simple;
	bh=IjFngPwuefsKMhzTlKN6e2G9FW+ktklXtsM+0b2gtUA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TCvx0vLxVdHOFXyONhGTHIz+hgto0+GqNu3kJwaTeS7sgXxqNnTV96shDVRT8A8kb3f4E8kVAcXE+2Nb9gwObnsZM+j4qrH5GTCD5asGmve4CbmTh92eJOUK5xvp19lcV48UT2XEBo2u0Us5pJKql1lCLSnNzne4f6Y4wX9PtaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=K+H10UZn; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="K+H10UZn"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4891d7164ddso20330835e9.3
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Apr 2026 03:29:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776853785; x=1777458585; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=rI2fi6UkqXUWaBao1RLoql+DKOqLkV4uXoIuteADEXA=;
        b=K+H10UZnsfb2CXxXAep8iiRSwt2H8qlW8HY4locp5uHhf8JsiNSSs0WQ3O1xdwiE+B
         xADpho2HPsK/K/sqFW8TcObSieobmxOZODie9homG3ov4y5VRUn1yO52+E5E+TyCvwDf
         X0rqBhYp1RnRhlIHkklGmOiot9Yp1+707/JcOmMctcA/0mOrh7ZFPVHXX+p2fHKb6P/U
         RegqdzrRVUbke8k5sMLrFEVCuND929+JnfAVnalm1F15898A73muhpajWFcCeGCIe5M4
         +ZvEQR1yokzwzlBC39USj0BSOnRr0anF8c1PGyfny52EY5dRROs+BSXDvN6dueRsf8r3
         1HAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776853785; x=1777458585;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rI2fi6UkqXUWaBao1RLoql+DKOqLkV4uXoIuteADEXA=;
        b=KetdnR3eVgeQEoLV3eDmKdU0BxdQfcVxhrZEyhvxu9SCjJ3W00pt48M1ZdLnG8kn2r
         ziru7q8v7wGWHja7L+jQZ/CHJfNmrgo+3sM/d+1ihnFP0LU2ZUqQMV8O97JE/q74s7Dr
         fH0S7MpRrn2+kuq1kR2rXsswwI/h8SylI5BHUFcz0/uvRsAwY/OnUg6m5XgS+HuMeXL5
         9icQrOzUQd1i58KUqo1FBiQxPA+StkQDYZ7U9EVxNZ5cYwnwbDe49cDB2KUHtgj7VdeZ
         hEW3VPQ4fVe7cnLZ1ogpffbRzqXTlX+aZjBsmM2nwWFIgIBlF8J14YKfFi/nfH9ZTtg6
         6+IA==
X-Gm-Message-State: AOJu0YwQnyUJSDSqPfFiapg8K96lmOIdSxXwr8kOkIDr0F/GcS49qPt7
	2+hk0Zw0/+LzvtpGmuN3hz4dF/e2hHTpL7uX4e7eOhjt3d36W1LqBR76VSzt2zoUbIk=
X-Gm-Gg: AeBDietJACdEPGyDxC/WbPfVjKDaa4RgQFFDF47d3JhEdW6nAFvIDVXVnkZ6Oa2jzIb
	i0aUIiRSrjSQE2zhfk8y76Z0wFMgO8h1QJ0A59TvJCLIpr50cuQeoa9DP1H2KAOQRCV2kkXjMw/
	p4OwrSQwSWLnmW7Rx6KIUZDGKxJLQxYXmfGIWbC7ok6pDd1Ae0Xdny1dwRD5DuDdmfEK8SrtFat
	boMWYf7PEhOnJaXCfUEYsP8gOAYEI/3YMQ+Fk7tEBkuBsUdmtPDefaluyR/IzYNsqWMNcu6hI0o
	wGFgq29hSsgiWieXGj80UgQVAzuIMAucFg5pqUVBOLO44aHlEdFlTIcPf4J3tEloOzwhf8irUMp
	deTjsDhp7voKGcYkp6Nv8PKOhYVf3q49Ixn5x+S+Z38Nbne8Gnf5g7i8K3RaETKNDYZLJ/9JPLb
	BCT8ARi7EQ9CnhX24HUKWPmLrGE6Z2mX9TuXoWyoqjhEKLtbNJ8zwBl5nc+AHfVA==
X-Received: by 2002:a05:600c:8909:b0:489:1b10:d896 with SMTP id 5b1f17b1804b1-4891b10dd45mr175018955e9.0.1776853784974;
        Wed, 22 Apr 2026 03:29:44 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c797703059fsm12627422a12.24.2026.04.22.03.29.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Apr 2026 03:29:43 -0700 (PDT)
Message-ID: <2f467264-0f15-4ced-858e-bbfdad4dcefa@suse.com>
Date: Wed, 22 Apr 2026 19:59:38 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: Limit size of bios submitted from writeback
To: Jan Kara <jack@suse.cz>, David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
References: <20260422094255.12672-2-jack@suse.cz>
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
In-Reply-To: <20260422094255.12672-2-jack@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/4/22 19:12, Jan Kara 写道:
[...]
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index ca3e4b99aec2..9c603d59a09b 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -2555,6 +2555,16 @@ static int extent_write_cache_pages(struct address_space *mapping,
>   				break;
>   			}
>   
> +			/*
> +			 * If we have accumulated decent amount of IO, send it
> +			 * to the block layer so that IO can run while we are
> +			 * accumulating more folios to write.
> +			 */
> +			if (bio_ctrl->bbio &&
> +			    bio_ctrl->bbio->bio.bi_iter.bi_size >=
> +			    inode_to_fs_info(inode)->writeback_bio_size)
> +				submit_write_bio(bio_ctrl, 0);

I'd prefer to move the check a little earlier, better inside 
submit_extent_filio() where we already have a similar check for ordered 
extent boundaries.

One reason here is, we're considering huge folio support recently, and 
with huge folios on arm64, we can have a folio as large as 32MiB, thus 
for the worst case we can have a bio as large as 96MiB before submitting it.

[...]
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index a88e68f90564..cb654e990333 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -8179,6 +8179,60 @@ int btrfs_init_dev_stats(struct btrfs_fs_info *fs_info)
>   	return ret;
>   }
>   
> +/*
> + * At maximum we submit writeback bios 64MB in size to avoid too large
> + * submission latencies
> + */
> +#define BTRFS_MAX_WB_BIO_SIZE (64 << 20)
> +
> +int btrfs_init_writeback_bio_size(struct btrfs_fs_info *fs_info)
> +{
> +	struct rb_node *node;
> +	u32 writeback_bio_sectors = 1;
> +
> +	read_lock(&fs_info->mapping_tree_lock);
> +	/*
> +	 * For each data chunk compute the size of bio large enough to submit
> +	 * optimum size request for each of chunk's disk and take maximum
> +	 * over all data chunks.
> +	 */
> +	for (node = rb_first_cached(&fs_info->mapping_tree); node;
> +	     node = rb_next(node)) {

Iterating through all chunk maps may take some time for huge filesystems.

Meanwhile the device list is way smaller than the chunk maps, what about 
iterating through all devices instead?

Not to mention we are going to hit the same devices again and again 
through the chunk maps.

This may not handle all corner cases, e.g. a fs with new disks added, 
but should handle the most common cases pretty well.

> +		struct btrfs_chunk_map *map;
> +		unsigned int data_stripes, opt_rq_size = fs_info->sectorsize;
> +		int i;
> +
> +		map = rb_entry(node, struct btrfs_chunk_map, rb_node);
> +		if (!(map->type & BTRFS_BLOCK_GROUP_DATA))
> +			continue;
> +		data_stripes = calc_data_stripes(map->type, map->num_stripes);
> +		for (i = 0; i < map->num_stripes; i++) {
> +			struct request_queue *queue;
> +			unsigned int io_opt;
> +
> +			if (!map->stripes[i].dev)
> +				continue;
> +			queue = bdev_get_queue(map->stripes[i].dev->bdev);
> +			io_opt = queue_io_opt(queue) ? :
> +				queue_max_sectors(queue) << SECTOR_SHIFT;
> +			opt_rq_size = max(opt_rq_size, io_opt);

I'm wondering if we should use the minimal or maximum size.

If the optimal io sizes are very different, e.g. 512K vs 128M, the final 
result will be truncated to 64M, would a 64M io submission stall the 
pipeline for that 512K device?

Thanks a lot for finding the root cause!
Qu
