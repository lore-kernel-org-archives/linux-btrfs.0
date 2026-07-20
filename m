Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF51642DA36
	for <linux-btrfs@vger.kernel.org>; Mon, 20 Jul 2026 21:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784583193; cv=none; b=kiyxNdjamsk7WSy4zEON4TfBGMUrBnHVIxxD5KljqI0l3lmEA7oKyaor05gqhdUGwpKzIeeZztaCn80jDuyx4aocXFx4BcVw5mlYVTDrFi89AjD7veN1tv5AsNUHurd1Kzy+9Wn6PP5o9CQtkluMIev8bfTp8NgomGgEWZWaj/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784583193; c=relaxed/simple;
	bh=3AO7vgS4AVoAdeVqxMSXn1p/FHZFo2Rb7DvChu3o02M=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=aUNF5Tsi/WwV71mbJHpWrgRlNHrz1mIobnZDMLneys4snjLSPCu4ZdOCjcykpMTV/ag9Yt8PMhWOEW15F6tadNPlhjhXC7xPPKoLk6rJ/LE6uZWdriWtxWsNutvxGjWKPLGQlsD1ZUrf3Xg4XxrAwvdGxcHLbXA45Jr1/q0E6iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=RhjclwoH; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="RhjclwoH"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4955aa106b1so15121145e9.0
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Jul 2026 14:33:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1784583190; x=1785187990; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:references:to:from:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dJHhf7EBAOcId21KnFQ3u0O8RD5jGS+0VySIlmkbgdM=;
        b=RhjclwoHrLXKmm5IjG5/y1T3eZU7wM2QuDZ17YD325HJH9e+8Gscq6acoMNuzi/7dr
         N1bIMrowYus3Bqs/qN8VtVPdexkN7oMudgAQQlIHqKeBrNCWOX8E5mMecm3qn67zxK6b
         Yb5RNQ9gMVNj669hFXeKWLShAfJZl2z2LMCJAImmAlcfRW0XhL2j5UJYP/DwVYKNWqiQ
         SGINyyNS1Erv53i5il0WC1lNwmUzZY3tnrj8ypttHjqriPqVNoal/0dV2gmjmB7lLWro
         qFoNkKWCFGMe3D8kkTpKafG0MNkehUQx4YsxsBwt9vppNl+Q2pWmx8BrH52kzupMqQlR
         KIdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784583190; x=1785187990;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:references:to:from:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dJHhf7EBAOcId21KnFQ3u0O8RD5jGS+0VySIlmkbgdM=;
        b=qdrCwwgK7/hwz0AA6RxYIEZ07WnGXRNL09vW1ql1oKzyoddhE82wRP4Qz14Fr43kdt
         f4AYL7yfomqAjB+5M1+HktHpinnpr4T8PfK71gu6XmKhDntxw38ezO98hRq+/FCAVw5O
         N/YgRJEQYttVnCBlid2LOQTYisj279kUtkcxQcQLKsRTS+GrEucdk6RKrn9j0VTTbu2q
         vc4B1gr9xHciCm7l77w90UqPCdkDpVNkW5pxUZagSuXVtOHE7PhhtkTh8xK/51Yx/Jfe
         sgtZGD3jqoDsOt4coYCXfNG7iOekppE11Ba+Q8aY655H05y+lDqFiaheKDI6ZPKSKPI0
         41mw==
X-Gm-Message-State: AOJu0YzGan69XLhEotjBmkruZvMLO6FF9I6SrqIVZqHp5d4HbNvU7QPs
	je2DWLtAkrNnZH4ybblkSSGTDP5Fwbkck45y4V8eox5uG+UftxcPqeuDstrQh0KiOqUQFXsJtZb
	K++fDfe4=
X-Gm-Gg: AfdE7clgJJM9hF5Pl9SDes/BDOzAo9RFTKj9Zk4Lpwm/dJ7H8xx49IhZoCqDO3zswal
	Val9JoCH/y2Gsudmq3ayxrDC53UAgPCFtzRWfy8yqosAiAte41avKVvaBPZ0wKNi4P1ZMeGVaZ1
	4HL1ECb5D11eRs+x57vU5WHFq7WctCVNUJe5PK78Gk21JINoMU/MdkiKETKi5Q9jc3OZKKyRnJV
	ZcN65kHd4IQavCWVji62cUqbs6+l1oYf/XZJR2ac1kOyZJHixRAg/DjlCPN6o5VPoQZVso7YjlF
	bkM35eOoHPF3UW64hLMflENTp1KKT/q98GaBleYTUZst5LlpJlOamnZkK43oc1645MOTvXY6wS5
	qWrHqp85QXXFlQg4LlyrTXNCr6KjPRkJR1bPO8qAnTibFpWwRZlFB+u6fBher6ufPAQIfqoY=
X-Received: by 2002:a05:600c:4585:b0:492:437a:a653 with SMTP id 5b1f17b1804b1-4954a50b811mr168324305e9.26.1784583189994;
        Mon, 20 Jul 2026 14:33:09 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3142a1dd90fsm38930009eec.22.2026.07.20.14.33.07
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jul 2026 14:33:09 -0700 (PDT)
Message-ID: <f295bae8-29ba-4982-aed8-8b5072367535@suse.com>
Date: Tue, 21 Jul 2026 07:03:05 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: disable large folios for systems with highmem
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
References: <555623ad2f49989444fd60eb2bd11f0371086670.1784540975.git.wqu@suse.com>
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
In-Reply-To: <555623ad2f49989444fd60eb2bd11f0371086670.1784540975.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/7/20 19:19, Qu Wenruo 写道:
> [BUG]
> There is a bug report that on 32bit systems (i686), btrfs crashes when
> trying to do zstd compression:
> 
>   BUG: unable to handle page fault for address: fffbc000
>   #PF: supervisor read access in kernel mode
>   #PF: error_code(0x0000) - not-present page
>   CPU: 0 UID: 0 PID: 61 Comm: kworker/u8:5 Tainted: G                 N  7.2.0-rc3-P3 #2 PREEMPTLAZY
>   Hardware name: LENOVO 2007F2G/2007F2G, BIOS 79ETE7WW (2.27 ) 03/21/2011
>   Workqueue: btrfs-delalloc btrfs_work_helper
>   EIP: ZSTD_compressStream2+0x221/0x5fc
>   Call Trace:
>    ZSTD_compressStream+0xd/0x48
>    zstd_compress_stream+0x8/0x10
>    zstd_compress_bio+0x20a/0x564
>    btrfs_compress_bio+0x94/0xc0
>    compress_file_range+0x20a/0x380
>    btrfs_work_helper+0xc1/0x1b4
>    process_scheduled_works+0x15f/0x204
>    worker_thread+0x10c/0x178
>    kthread+0xe1/0xe8
>    ret_from_fork+0x1d/0x14c
>    ret_from_fork_asm+0x12/0x18
>    entry_INT80_32+0xf0/0xf0
>   CR2: 00000000fffbc000
>   ---[ end trace 0000000000000000 ]---
> 
> [CAUSE]
> Inside zstd_compress_bio(), we assume the whole page cache folio can be
> mapped in one go.
> 
> However that assumption is not true on systems with CONFIG_HIGHMEM, the
> pages of the large folio can be in HIGHMEM, which needs to be mapped
> before access.
> 
> Meanwhile zstd_compress_bio() only map the page of a large folio where
> the start filepos is, the remaining pages are not mapped, and accessing
> the remaining pages will trigger the above crash.
> 
> [FIX]
> Do not enable large folios when the kernel has CONFIG_HIGHMEM enabled.
> 
> This is the same handling for bs > ps support.
> 
> Link: https://github.com/kdave/btrfs-progs/issues/1146

Reported-by: Erhard Furtner <erhard_f@mailbox.org>

> Fixes: 9bce95edb1b4 ("btrfs: move large data folios out of experimental features")
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>   fs/btrfs/disk-io.c | 10 +++++++++-
>   1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 37fc0d6b960d..5de8210070eb 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3477,7 +3477,15 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
>   	fs_info->sectorsize = sectorsize;
>   	fs_info->sectorsize_bits = ilog2(sectorsize);
>   	fs_info->block_min_order = ilog2(round_up(sectorsize, PAGE_SIZE) >> PAGE_SHIFT);
> -	fs_info->block_max_order = calc_block_max_order(fs_info->sectorsize_bits);
> +	/*
> +	 * For HIGHMEM, a large folio cannot be mapped in one go, breaking a lot
> +	 * of basic assumptions for btrfs IOs.
> +	 * Disable large folios for such 32-bit systems.
> +	 */
> +	if (IS_ENABLED(CONFIG_HIGHMEM))
> +		fs_info->block_max_order = fs_info->block_min_order;
> +	else
> +		fs_info->block_max_order = calc_block_max_order(fs_info->sectorsize_bits);
>   	fs_info->csums_per_leaf = BTRFS_MAX_ITEM_SIZE(fs_info) / fs_info->csum_size;
>   	fs_info->fs_devices->fs_info = fs_info;
>   

