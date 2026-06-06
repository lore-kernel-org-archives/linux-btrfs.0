Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB042224F3
	for <linux-btrfs@vger.kernel.org>; Sat,  6 Jun 2026 22:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780785172; cv=none; b=RZEzxlgMcy85JzU5VRBvTmV2h0i8R7J35pwOmbZcct7VVxyM5BB/zoMyTYku6JeVkYyF/fg98+ih8DMR4tr7d/Giz2mzGYako0BYMz3NANqDDwIF2PHmF8ZDcL8ohjDkEgF+YlIzK8m4hbZ6XDf7kQEdzyIuzu8CIq1kYzBN7cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780785172; c=relaxed/simple;
	bh=0qJdVLzJ+BH1eQRhR0q5N+cGVUhodTDghBP40Ay41gc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oFtasNzAhhFAdMxyJrlFTx2EwA5YdN2j9mjHzFVUg3xeG7tvaLdYAe/RI++QYT8kM/CTjE/c0T80FE8qEqzhiU9yLo5PqtmrsJDYbU1+RrH2JxBaTUez4ytQ4Jygu0tv72hEJyIqdMa+kqdUl22ls1qXY018HkzinWEb+YnVkn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=eiVRP5/s; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="eiVRP5/s"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-bed2195323cso445933166b.1
        for <linux-btrfs@vger.kernel.org>; Sat, 06 Jun 2026 15:32:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1780785169; x=1781389969; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=5DeT9Vhynob7VPN8PlAdZxC5iXIKGfSkaeOqPFWI1bc=;
        b=eiVRP5/sVYI4PGZ4wj8Bwak4lbCfqiLEFDpblHu+UctHSOgoFT8tYFrwXJo7/xfYsv
         swb1nfMbp0lrKct3QgGl6Wrnie2bgEBxiBk2lsqg/d8YnmiRubvgMG7sfkHVBW/IsXL/
         2V3XFnEXPLzMpXeamA86DhSu6H1SufedwCREPdPUyKz9LiKcVlSiQmx3qheW7Lw0K1Jy
         kGmm0KLsGOkzHpQN4DJM3U6FIFqmrUTXON+aaWm3s8aEnFFxGRzifj62RsU5W8PRDYW3
         X/1VFa+Dz+F64Lho/nbj0dzYxgs1G6Rv4B/ydv7Eesbm0b/S5O5ynVYv3Du2d4n43QZD
         5k4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780785169; x=1781389969;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5DeT9Vhynob7VPN8PlAdZxC5iXIKGfSkaeOqPFWI1bc=;
        b=WiO7OeYmDeXEbsyKiH16oNuxgQrwL4tCFu69JqHfBILc/5Qol0J0/JgI/4Zd1tnmA2
         8IMt2VrT+wBUds4o3x84i9xM+tzC3lMkSs7U8GhQEvh8zvhwx6qEnA8VfRhnBnZwbbt5
         Ru79xuJ/6m3rmLcxA2wiLqVSk2j2GtkhX/AEpQ/meLo99vkhvSCI17o0OwGwDyNXlvge
         kEFyWc3ACqplj3E9Vx3CE1/5ChGj1YUjeQAJUq8cFVI0vizgT4WiTBVdnzHMIbs8Nifk
         rQWl6w1s1Pz3OQf7YayszQAaERWg2ZAx0r9RMD8yObVbJPDg9bmCwisan9aHs/IQJU4d
         6rfA==
X-Forwarded-Encrypted: i=1; AFNElJ/7gatbizosZUtXzcL+ehBYZQyViO8VIt555UbpxjJQHoDgZ03AmN/+RhtSKY+Va2Km84bX1sNthR3yzw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxyCYKJ6HyabpTZSWAmy4FKpbR/M/mhbdmJ0oEnaz6ztCeMwUVN
	2YHB2LAq6VUJIuc1ZjAgoKmfS7+LPv2KXLiAIG0mgk7FuueHJDUSM1+ES79tymK6fIM=
X-Gm-Gg: Acq92OG4w5mdW3LnoJvDTrTJfdsbMYnFagx+fSBlzjv6jH9e2Clho4sIYmnpBGpj9Ur
	OPJ+bdvFxASnrnFGil69WHfRu1icroY5CwPqmZMSRVvTYszLmvBMsho5OJWvPxk0J10eIW6i/iu
	4UrfbSZ8Qk8SUQM5ObOR3ikGQqLWkWRiwWJqW3xEoN4+Y4pEKMsZff/clmGlYYQnU1GvJBNm7tc
	7QmSXWzGbEceruAe2iTtEj60tY/bNqDLztmLxLXtD98pJ4LISXymCFSP3sXfcccb69rUqaQkWxF
	qxijrpevoQLbMVTfoJLx+mh5iHrS5P7mO8fd4JcuLDvZ5a70TARgsZxyOqsRjIUPUTbX3y6uiEt
	4LP6xf0Anfoh4t4DDmqZ0M0GuWfup9qOXLZE6eUPXJEHbuC5GnmP6OjCo739P90IsmVPpNH+QVg
	nsh6cfk8/uHt3qUaP60nRu1QF6xan22uEsgCGldW9v34XN/WTqy/lvH4npQpCaDElYcJLctsSCg
	pAuyqkO9qoTD4l176PNjMkBEwkEpf73+KHZmuPxMMQ23xZUFunJTA9Dor9M2fO2yshc
X-Received: by 2002:a17:906:8a5a:b0:bef:a80:daa with SMTP id a640c23a62f3a-bf373403f8cmr340531566b.41.1780785168983;
        Sat, 06 Jun 2026 15:32:48 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84282220d1bsm14475390b3a.12.2026.06.06.15.32.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 Jun 2026 15:32:46 -0700 (PDT)
Message-ID: <f825ee51-a2be-46ac-9038-d094ecdf3212@suse.com>
Date: Sun, 7 Jun 2026 08:02:40 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: lzo: reject compressed segment that overflows the
 compressed input
To: Weiming Shi <bestswngs@gmail.com>, David Sterba <dsterba@suse.com>,
 Chris Mason <clm@fb.com>
Cc: Xiang Mei <xmei5@asu.edu>, linux-btrfs@vger.kernel.org
References: <20260606174816.723525-2-bestswngs@gmail.com>
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
In-Reply-To: <20260606174816.723525-2-bestswngs@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/6/7 03:18, Weiming Shi 写道:
> lzo_decompress_bio() validates each on-disk segment length seg_len only
> against the workspace cbuf size, not against the compressed input size
> (compressed_len, the total folio bytes of the bio).  A crafted extent can
> carry a segment whose seg_len passes the cbuf check but runs past the end
> of the bio, so copy_compressed_segment() walks off the last folio:
> get_current_folio() then returns the NULL folio from bio_next_folio(), and
> with CONFIG_BTRFS_ASSERT disabled (default) folio_size(NULL) faults.
> 
>   BUG: KASAN: null-ptr-deref in lzo_decompress_bio (fs/btrfs/lzo.c:383)
>   Read of size 8 at addr 0000000000000000 by task kworker/u8:1/29
>   Workqueue: btrfs-endio simple_end_io_work
>    kasan_report (mm/kasan/report.c:590)
>    lzo_decompress_bio (fs/btrfs/lzo.c:383)
>    end_bbio_compressed_read (fs/btrfs/compression.c:1065)
>    btrfs_bio_end_io (fs/btrfs/bio.c:135)
>    btrfs_check_read_bio (fs/btrfs/bio.c:180 fs/btrfs/bio.c:285)
>    simple_end_io_work
>    process_one_work
>    worker_thread
> 
> Reject any segment whose payload would extend beyond compressed_len before
> copying it.
> 
> Fixes: a6e66e6f8c1b ("btrfs: rework lzo_decompress_bio() to make it subpage compatible")
> Reported-by: Xiang Mei <xmei5@asu.edu>
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Weiming Shi <bestswngs@gmail.com>
> ---
>   fs/btrfs/lzo.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
> index 2de18c7b563a..887d740b27aa 100644
> --- a/fs/btrfs/lzo.c
> +++ b/fs/btrfs/lzo.c
> @@ -491,6 +491,10 @@ int lzo_decompress_bio(struct list_head *ws, struct compressed_bio *cb)
>   			return -EIO;
>   		}
>   
> +		/* The segment must not extend beyond the compressed input. */
> +		if (unlikely(cur_in + seg_len > compressed_len))
> +			return -EIO;
> +

In lzo_decompress() we return -EUCLEAN, please follow that pattern.

Although it would be better to output a message when such -EUCLEAN is 
returned.

Otherwise looks good to me.

Thanks,
Qu

>   		/* Copy the compressed segment payload into workspace */
>   		copy_compressed_segment(cb, &fi, &cur_folio_index, workspace->cbuf,
>   					seg_len, &cur_in);

