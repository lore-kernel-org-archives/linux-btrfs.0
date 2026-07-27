Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E38F32F872
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Jul 2026 08:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785142297; cv=none; b=t7mYooDONnMQ6k2IR8QnAaUicXABGkFEhH1XrutaidjQkCbtV4FdQShM8rBDjXIj78BeHz7aBjoOKm2/urtwZbONduTa9SVSep9j6yGgzHQTJ4xtbl2Ha4Pdfq/biBgg7vtDg57tWCm/moXADJm7qPvnWEQgBUR+0SgnNoOAZQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785142297; c=relaxed/simple;
	bh=GJcXcV67DfqTnkeIckG5trxWHxLuU8kZJykituSCm4E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LRggPYcVDmaA5BPxKoqqgz0rc0nWjr7yg5hzYO1bFUrp71LoX6Uuwo48LJd7yOUGAfuzfvPpX1ocKsRWHyl01273CmviRbkaTB3e/w9T7493pHqGUi+ccNVg4+Q/I70iGg2o2H+Wf6Iq9NduvfYgv8nqtptCukqhvxq4Yr9cEvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=VkuD0b0r; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="VkuD0b0r"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-493b966dd74so15379865e9.3
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Jul 2026 01:51:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1785142294; x=1785747094; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fOJycL83qtHLEyXTBRTNVNI7KUq9mSJ0KTc5GWZtLy0=;
        b=VkuD0b0rHA+BmqhZKKGWuWZthUgKabrsY4ycVMSuidxy6TZPtEvwFLED+5++ZaSxnA
         1UWLhcAxrT8abY9o6dEqvqQMcQimlBtchoelXQO8kRYXOGqg/s9g2UBDtwr8oMcPUaJJ
         1HBu3lLWgr3gr/DlFZvOZrPuuIePGfBb910KH31jjeoS/6LW0DdiW6Yb3AF9sqhjrtUG
         C8tbFTqnaW6hH789/jLVg8h9+wFDe5JcszwyLlxSJVrzX0bhXqJwR9guCc5F+yoyYU3X
         mR2RS1/wSLFVASuA94iksjJNoZj56Au/dQL8q0aBKp57E0E6bv5TT8G8c+4LQIdfgISN
         Easw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785142294; x=1785747094;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fOJycL83qtHLEyXTBRTNVNI7KUq9mSJ0KTc5GWZtLy0=;
        b=tMvrEp4i0s7ZouSsqguZ7xTFUCSQFV1jSUwmgC41Ty99sGMMgQz7TYnjueH3IqZ5Uw
         Btms/1PdLavPXtGYBatdurcRYHYc+o0ZVOV4b85p7f2W9CBAYsv3mnWLClHTaSKGnQeX
         QLW5GVSVGU3YFaHuvPoQ783JWLTrzYTtDtcWDAD5XrTOo7Pqcupq6+UyfOo0UlkPfNjT
         UMS5QHxmc5mO6Q09tGOPa5msqOZGbltPFcf4cWl4BAGlSX+2y//cfGDrpPoIyHM+kyj+
         LmcY6N/JIQe9I2hvpnFkSamNzLQHYdgSrOqVa6n209DpH1xL5M3mHzzuUioV/YYPIpr0
         /Usg==
X-Gm-Message-State: AOJu0YzUA/LDf3b6qwAwYEs2B0MREjULgWl8cG/3sSMIuwNXRWRKuvNw
	stOWH5IjdUIYJvOHmUe+XbS6kkFmiQWDq/51IsRoCZK14qNnWeVLFnRNWYNjqARfwwM=
X-Gm-Gg: AR+sD11mY+sbEYejObPrKxVHeQNJdVyCdwZN5toCuZSICaVNsi4FSNO7yo9lifLlWG/
	nkXjoEEXautypnWQFork06tKK2PRd6vBZu3d9hoExUd8ZL8q+WGiLYnEFU4rBM1/DhQK3BPP3ic
	TdHUbBy4iKnz+wppA8TvFDYbw2WjTlCeKTenL3kxE4wTo2FotbvsnpILkwt9MC5dSP9ZlyOIrGe
	MSxTX4fC2UBwANJ2GgwGYNnBhHiOd3QOqPo4RY/u9rQT8t8q+WJGHRtCQ03gcmN1oxbbJR59/Bh
	tKvvg9jbjVL91dE8oATq05y6xFw0Cl8Wfrv88k2Q6Grl4xr4uEkrj+nZInLnLLN2GzH6/7748/y
	Krh5FzkhXXWIYWA9IKfnH6yllLKWMfqHdGEDa5jdZ5mcUf5KYt78rjDQRjwWM0fj5bpSxyMI=
X-Received: by 2002:a05:600c:4fc6:b0:493:c8a6:b517 with SMTP id 5b1f17b1804b1-496b5735169mr88805595e9.38.1785142294083;
        Mon, 27 Jul 2026 01:51:34 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13d130a8421sm48268018c88.10.2026.07.27.01.51.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jul 2026 01:51:32 -0700 (PDT)
Message-ID: <73420f89-bb52-41d3-9757-3446d4c0c479@suse.com>
Date: Mon, 27 Jul 2026 18:21:21 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: convert reflink.c to use btrfs_inode as parameters
To: Daniel Vacek <neelx@suse.com>
Cc: linux-btrfs@vger.kernel.org
References: <36ca71a749dbd364736747bc23c3ca8c44ef6cbc.1785107778.git.wqu@suse.com>
 <CAPjX3Fdk=XRpOnOr6RnwjGUcoaVk7O=qvst68eH3DE8QnC-fUg@mail.gmail.com>
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
In-Reply-To: <CAPjX3Fdk=XRpOnOr6RnwjGUcoaVk7O=qvst68eH3DE8QnC-fUg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/7/27 18:13, Daniel Vacek 写道:
[...]
>> @@ -789,7 +790,7 @@ static noinline int btrfs_clone_files(struct file *file, struct file *file_src,
>>                   * we found the previous extent covering eof and before we
>>                   * attempted to increment its reference count).
>>                   */
>> -               ret = btrfs_wait_ordered_range(BTRFS_I(inode), wb_start,
>> +               ret = btrfs_wait_ordered_range(inode, wb_start,
>>                                                 destoff - wb_start);
> 
> This could have been a single line.

Thanks, pushed with this fixed.
Qu

> 
> --nX
> 
>>                  if (ret)
>>                          return ret;
>> @@ -802,9 +803,9 @@ static noinline int btrfs_clone_files(struct file *file, struct file *file_src,
>>           * mode.
>>           */
>>          end = destoff + len - 1;
>> -       btrfs_lock_extent(&BTRFS_I(inode)->io_tree, destoff, end, &cached_state);
>> +       btrfs_lock_extent(&inode->io_tree, destoff, end, &cached_state);
>>          ret = btrfs_clone(src, inode, off, olen, len, destoff, false);
>> -       btrfs_unlock_extent(&BTRFS_I(inode)->io_tree, destoff, end, &cached_state);
>> +       btrfs_unlock_extent(&inode->io_tree, destoff, end, &cached_state);
>>          if (ret < 0)
>>                  return ret;
>>
>> @@ -818,7 +819,7 @@ static noinline int btrfs_clone_files(struct file *file, struct file *file_src,
>>           * could come from some range other than the copied inline extent's
>>           * destination range and we have no way to know that.
>>           */
>> -       ret = btrfs_wait_ordered_range(BTRFS_I(inode), destoff, len);
>> +       ret = btrfs_wait_ordered_range(inode, destoff, len);
>>          if (ret < 0)
>>                  return ret;
>>
>> @@ -826,7 +827,7 @@ static noinline int btrfs_clone_files(struct file *file, struct file *file_src,
>>           * Invalidate page cache so that future reads will see the cloned data
>>           * immediately and not the previous data.
>>           */
>> -       ret = filemap_invalidate_inode(inode, false, destoff, end);
>> +       ret = filemap_invalidate_inode(&inode->vfs_inode, false, destoff, end);
>>          if (ret < 0)
>>                  return ret;
>>
>> @@ -934,7 +935,7 @@ loff_t btrfs_remap_file_range(struct file *src_file, loff_t off,
>>          bool same_inode = dst_inode == src_inode;
>>          int ret;
>>
>> -       if (btrfs_is_shutdown(inode_to_fs_info(file_inode(src_file))))
>> +       if (btrfs_is_shutdown(src_inode->root->fs_info))
>>                  return -EIO;
>>
>>          if (remap_flags & ~(REMAP_FILE_DEDUP | REMAP_FILE_ADVISORY))
>> @@ -953,8 +954,7 @@ loff_t btrfs_remap_file_range(struct file *src_file, loff_t off,
>>                  goto out_unlock;
>>
>>          if (remap_flags & REMAP_FILE_DEDUP)
>> -               ret = btrfs_extent_same(&src_inode->vfs_inode, off, len,
>> -                                       &dst_inode->vfs_inode, destoff);
>> +               ret = btrfs_extent_same(src_inode, off, len, dst_inode, destoff);
>>          else
>>                  ret = btrfs_clone_files(dst_file, src_file, off, len, destoff);
>>
>> --
>> 2.54.0
>>
>>

