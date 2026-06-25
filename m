Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5970C2BE7CD
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Jun 2026 05:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782364435; cv=none; b=IETuyigh1hItLa3etOIdyMPfTtEtx4ZZs4u7OpUFentNm/xyRQU4d9UJI4knIcTkg9+FGJn11y0/0MZcv6EEJXnwkiZkdnDF2t6vF2kheya9yr/l4QACOydAxDAHDSijUNbKmopxccHy9jCmGeGd5qGvduX5jvVytEviAhKlvUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782364435; c=relaxed/simple;
	bh=Zr4BpQW7wAig4Sd+fohzL2ZlLVVuOgdINLep5Hi3UJg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tkuXrddooVmuFXlwQlvZSn7ML1Tj0rmuZC4/1AidO6kqeervOm4DfZko/MxzgH+g5FgUEN5ni2UwIdE1YGeOKABwTJwbtIRWrxPFOisJ/CqeP4VYt05pNbbvigEJ5KowpvEXLd/EvmkohGcT6PAv2ePhr6M/XV8C0Sj714BLcGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=OqK8T/Tg; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="OqK8T/Tg"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4926046fbc5so5871025e9.0
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Jun 2026 22:13:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1782364433; x=1782969233; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=pQEPZ1WQ9T9cBnwEF9V4DMQ55A72h22/dVrJaBEXJ7o=;
        b=OqK8T/TgWX5eXNbCGcqE/m/gs2HeYMr8w4IKAHVYpAYCgftFURMAYdid0iVm+6GNWM
         wWYtAmZs83sgws28pn6DCO4rMfom8lWdfLLNbmTeQrlsNVDCiTs01uiu2g8UsJdfyrEv
         mQyF86NVHWgUHHy8FJmuh0ALLSb8nxY5Aa0lKtraMStISy7WXyTJPjrrhnCVrPfo/kXJ
         mbBBEx/ONGjXWidbojZp3TRqiqvKBlN6PGL/3lBejXqIs8hGmHsFMBSffuoZpdizdmwA
         38bDvGWsUD0EYSGEV4u5FryUbuwcM8rsXWwClpqKwWZFS6Z+Y59HmuGkRniUy3X1anrF
         F4nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782364433; x=1782969233;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pQEPZ1WQ9T9cBnwEF9V4DMQ55A72h22/dVrJaBEXJ7o=;
        b=HDpy9p6en4KhELrusm63CzBeEkxAM9tC66PkxX6CzZKnwMhK1F8TZUxKHJ8oUW1HdQ
         uyI0SCZCPY7AMFtQZI+WUuVCaipCy20QHKecktJ3dZ/MNirpl5w5R1wEv37jqg3eBrua
         swLaS6EmNLjRnj4wk1ITqPdv1Ivo+2+BJaX9J7IHrEvRINm1kvt+zowD+EAtEOWEWGqS
         pJwJyBE23nqRi9KcX2UsL3qj5q8WUhQzYFwhcdSaCCurut6G71HN9kkqOLWrhBO6+VaP
         aVJvUpjdWwxWhMbkmd1QN4dWmiCOr/QWVd4NiREd5BFWm4iIecgVWZjn0iz4BhqMLGxa
         wUEg==
X-Gm-Message-State: AOJu0Yz0WGKCYJTOPV4voNO2pysveZyNB9cjkZuZarwdzpb9WTMr716i
	8JmJFqf7pwZay87Q0vOQoQUD6CYA0Pzc7zLmGXORtjaAiHA1g4IY4fivnJlEJkFp9fI=
X-Gm-Gg: AfdE7cnlHeZtmbPG1LTGi7UYvbpfRKD1igMYQS0Fd9q//ZrBfLN4I5PL9pn+JrAThE4
	6Yb0V47EsCLVzGriXF91TVfe/d2MtyV4KOYgSuiYJ/wp+acLZV1F+LtytmS7OJRyubrFocoSF47
	pfb+xkg+bpUaBFFSTR4gCTKQYk0Cx4m+IfA1Xg72/r9mMWUP9xmPsg1tNRv5z04tJ81fhULh2Ur
	DhpyLVpcanWlnmSGGsZaqwbcu0WBAFmCcYe9bx3FCMqTpDnOar/OiDJmWcBOavJmJ1jOdoaZeb2
	Q3xMoKFeSf/+aXyRR+0U03YUXu36Qge9sPpJCeFRzmStxpX6/uT27L9WyUkTQsFMCr0ADykqhnn
	FY+1jxFvnvkAJxhj8u6kcu8VkctaBk8F2TXS1s1Q4ts3apW2SkC9/qBPAjTgHh6GarMZH5VvgX7
	s5wJW2e95CTC/hILzPm2DNi1zbZhoKke9bvYuz2mgK
X-Received: by 2002:a05:600c:3b89:b0:492:37a3:acda with SMTP id 5b1f17b1804b1-4925a0444c4mr162713115e9.0.1782364432749;
        Wed, 24 Jun 2026 22:13:52 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c7c58831asm4550316eec.13.2026.06.24.22.13.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jun 2026 22:13:51 -0700 (PDT)
Message-ID: <aa009e0d-a629-44ed-bb68-202ff2dc5063@suse.com>
Date: Thu, 25 Jun 2026 14:43:47 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: wait for ordered extents before buffered write
 fallback in direct IO
To: Yun Zhou <yun.zhou@windriver.com>, clm@fb.com, dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260625021456.724803-1-yun.zhou@windriver.com>
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
In-Reply-To: <20260625021456.724803-1-yun.zhou@windriver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/6/25 11:44, Yun Zhou 写道:
> When btrfs_direct_write() falls back to buffered IO after a failed DIO
> attempt, it may race with the asynchronous completion of DIO ordered
> extents.  This leads to a BUG_ON in insert_ordered_extent() due to
> overlapping ordered extents in the per-inode rb-tree.
> 
> The race sequence is:
>   1. DIO creates an ordered extent via btrfs_dio_iomap_begin()
>   2. Page fault occurs (nofault=true), no bio is submitted (submitted=0)
>   3. btrfs_dio_iomap_end() truncates and finishes the OE asynchronously
>      via btrfs_finish_ordered_extent() which queues work
>   4. iomap returns 0, retry logic faults in pages and retries DIO
>   5. Second DIO attempt also fails, code reaches buffered: label
>   6. btrfs_buffered_write() dirties pages for the same range

btrfs_buffered_write()
|- copy_one_range()
    |- lock_and_cleanup_extent_if_needed()
       |- btrfs_start_ordered_extent()

So your explanation doesn't makes sense. As if there is the direct IO oe 
remaining, we will wait for that OE to complete.

There is still something missing.

>   7. btrfs_fdatawrite_range() triggers writeback
>   8. run_delalloc_nocow() -> fallback_to_cow() -> cow_file_range()
>      tries to insert a new ordered extent for the same file offset
>   9. The DIO ordered extent hasn't been removed from the rb-tree yet
>      (btrfs_finish_ordered_io running async in workqueue) -> BUG_ON
> 
> Fix this by waiting for any pending ordered extents in the target range
> before starting the buffered write.
> 
> Reported-by: syzbot+ba2afde329fc27e3f22e@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=ba2afde329fc27e3f22e
> Fixes: acf9ed3a6c00 ("btrfs: retry faulting in the pages after a zero sized short direct write")
> Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
> ---
>   fs/btrfs/direct-io.c | 24 ++++++++++++++++++++++++
>   1 file changed, 24 insertions(+)
> 
> diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
> index 460326d34143..e8ac9492844c 100644
> --- a/fs/btrfs/direct-io.c
> +++ b/fs/btrfs/direct-io.c
> @@ -844,6 +844,7 @@ ssize_t btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
>   	struct file *file = iocb->ki_filp;
>   	struct inode *inode = file_inode(file);
>   	struct btrfs_fs_info *fs_info = inode_to_fs_info(inode);
> +	struct btrfs_ordered_extent *ordered;
>   	loff_t pos;
>   	ssize_t written = 0;
>   	ssize_t written_buffered;
> @@ -1025,6 +1026,29 @@ ssize_t btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
>   	}
>   
>   	pos = iocb->ki_pos;
> +
> +	/*
> +	 * The DIO path may have created ordered extent(s) that are still being
> +	 * processed asynchronously in a work queue.  We must wait for them to
> +	 * be fully completed and removed from the rb-tree before doing a
> +	 * buffered write to the same or overlapping range; otherwise the
> +	 * buffered writeback path (run_delalloc_nocow -> fallback_to_cow ->
> +	 * cow_file_range) may try to insert a new ordered extent that conflicts
> +	 * with the still-pending DIO one, triggering a BUG_ON in
> +	 * insert_ordered_extent().
> +	 *
> +	 * This happens when DIO creates an ordered extent but has a short write
> +	 * (submitted < length in btrfs_dio_iomap_end()), which truncates and
> +	 * finishes the ordered extent asynchronously while we fall back to
> +	 * buffered IO for the same range.
> +	 */
> +	while ((ordered = btrfs_lookup_ordered_range(BTRFS_I(inode),
> +				(u64)(pos - written),
> +				(u64)written + iov_iter_count(from))) != NULL) {
> +		btrfs_start_ordered_extent(ordered);
> +		btrfs_put_ordered_extent(ordered);
> +	}
> +
>   	written_buffered = btrfs_buffered_write(iocb, from);
>   	if (written_buffered < 0) {
>   		ret = written_buffered;

