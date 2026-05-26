Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535628F7D
	for <linux-btrfs@vger.kernel.org>; Tue, 26 May 2026 00:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779755913; cv=none; b=Q2FA/FqrXv5R2Skq/uHCjOxxOwJfLfLjsdw1XQnUX+qw81sulNgeIncrsjd0DPXIEQDb+6LYrqGvjXQbkKq8G1Rm4PBAkgzBu7tCTmQY+GM14L8iBM2paaX9b/Ekfr/g3KX172nfcxY8tPgfzvr0tiXvahx6THSzA3ygjBjEJR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779755913; c=relaxed/simple;
	bh=R7rfFftxcDsZqicAByC/tBskuj1ci0JWcEH3H1UvmoY=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=sFFoUGRQFy9zqp+824CL+mphxMY+mC/WJtP0pWUopjjbS96DHofoSXsUstg3cfRpgDbqaQcnTew7nT87imbVj+XdFj6FZGliu0gi6/p0QcIRk2/7oF0IzxBQCPAQP89aB3t33PDJJv2BSMxF3yy+c38S7p87+ryK1S9DElBkS4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=GJ9GunCO; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="GJ9GunCO"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-48984d29fe3so104846685e9.0
        for <linux-btrfs@vger.kernel.org>; Mon, 25 May 2026 17:38:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779755911; x=1780360711; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:to:from:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Zj4KJs3lWtWMvIKNNgn3TqhcTksnjNJGgMDrdk0tEvE=;
        b=GJ9GunCO6XkxiI8VZEpwXS2ud+FddZbh63TqJ0y0N8uHpK824hA2KWNb5Hm5u5iJxM
         Z7HCXSQAuaT5516XPpODG2rE/9dI2bmbFFJp/FI7/P0Ll32mZ9pGP6HRZ7MgHtuufxY9
         rQg96tdyRqDmYvdHcrdj5dMa1GmCfZpdyxTbn0winKchE7JBeCvBePz4fyieMoEV+ity
         IWU8Ns8GGQC1B0VGQELUzc/P/+evpcDPLzH7IkHFG1ViyseNgWhCZxxQB/3zstMCh3tw
         2l1i0pOq2xzeBnbhE2V2CsqY2k/IjY6TiGmQ6aMaP59DdJpbqKubzXMMaqWmTSrpX/m2
         qbcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779755911; x=1780360711;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Zj4KJs3lWtWMvIKNNgn3TqhcTksnjNJGgMDrdk0tEvE=;
        b=tSx5mU95kwa0srrYBR46/dYhY6M9bAM1iqcMTR7J7ukVHCXCP4+mzB7BgQxXjeBM2F
         RYaGakbw7MpZMJzJWweP65QxchhB0s0djk2YAEOq4e3O/fwL41wtnuYv9I0sLMbTHgW6
         w0wXEsm4y8uSb6fMFy9ee6BaSHFT58x02FnGNGi0f76iJLe6G7jflkaZctTeddIb78n7
         4EHNIth5SV7UAq8xxO+Agpkxt46a7DXoB0nbR44rKd9BiIXKhW5gx6u+a4NQybxBtLgX
         6Qu33S6RFRSd+aBv7qWl9AunQf8KwCckZ7cdVf/d8g6irqtSSISikjd+hpNRGfWd6qRp
         zZhQ==
X-Gm-Message-State: AOJu0YyDXXu8bpMBkGzWF4/bnCQ9T0RrWzPDUz0rAWpEyzJrdoVSPKpM
	n1kTdWoEOIhJqZK+IVNEsQLVD6uKia0FWdDzdV8sTYofXAA2BbQhGo0E6WRN23fb90rDr0D1zMA
	d9GWn
X-Gm-Gg: Acq92OEVM0D/L4fO24Q+v/sLhBhNUnvYLPjO/au0plysfxUHn5Gdu+L2RtStogZv7jT
	3UJJoRf0vWVDk5OuKkcn+LyIJklCdJB3aBCI7RL5E1/cOAzGuUXZw3Aon6qG5OuhjiPq5NCVVsS
	6HSGaB5Z1Zq5cFXTbKqxslIl7AdrdpiNSCkw4RK51vz1FdBMHVRDFi88bwgBDs9N2NJ+O3cD2Jn
	dbcsMtarqBbxVqT0AMwKI9mW/s0dJayUWQwxn0xqwJT3Jx4FKRT5bUavF1XbC7SHDu2c+oSrELa
	dpApADMR9sijoMz+ep6SRz1C9H5nNZcvWcGQNAfWhNYJbdUx7QqQb3g7AwEFTskKjkKudbAyfH6
	E80X8WhPuS47djvajc1+8GxSgNSgATEBNZi9XAQSzzQZbC6R7csJ8u36mVPfZ0J5YxCSsHYF9Et
	eWUOB4xxIOrmiUQ9Im0nRiDnbi2NUPDeLtTUF8Mo+kvGPD4o9Dn/2+NAqbwTKHU2ksnNbQkEQEh
	tBEPguXp/JhTX6RchUmn3VKwRYsxhjgC9hmaFZjLUxoB/o=
X-Received: by 2002:a05:600c:a402:b0:488:9bf8:7f17 with SMTP id 5b1f17b1804b1-490425ad10cmr222089895e9.14.1779755910608;
        Mon, 25 May 2026 17:38:30 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2beb5205f16sm106042945ad.0.2026.05.25.17.38.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 May 2026 17:38:29 -0700 (PDT)
Message-ID: <dd2e62d9-086d-4c55-b521-e7fa101065e7@suse.com>
Date: Tue, 26 May 2026 10:08:24 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: use IOMAP_DIO_BOUNCE flag instead of falling
 back to buffered IO
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
 Filipe Manana <fdmanana@kernel.org>
References: <e578ff1a2dd9a4f720ea77bc601534734ce87e18.1779685479.git.wqu@suse.com>
 <150d5b1f-d1b0-48c1-ae33-56b4c049576f@suse.com>
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
In-Reply-To: <150d5b1f-d1b0-48c1-ae33-56b4c049576f@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/5/25 18:44, Qu Wenruo 写道:
> 
> 
> 在 2026/5/25 14:35, Qu Wenruo 写道:
>> Previously btrfs forces direct writes to fall back to buffered ones if 
>> the
>> inode has data checksum or the profile has duplication.
>>
>> That fallback is to avoid the content being modified that the final
>> content may mismatch with the checksum or the other mirrors.
>>
>> That brings a pretty huge performance cost, which already caused some
>> concern at that time.
>>
>> But later upstream commit c9d114846b38 ("iomap: add a flag to bounce
>> buffer direct I/O") introduced a new method by copying the content into
>> new pages, and do all the operations based on the newly allocated pages.
>>
>> So let btrfs to utilize the new flag for direct writes if we require
>> stable folios.
>>
>> There is a quick benchmark, using the following fio setup:
>>
>>   fio --name=randwrite --filename $mnt/foobar --ioengine=libaio -- 
>> size=4G \
>>       --rw=randwrite --iodepth=64 --runtime=60 --time_based --direct=1 \
>>       --bs=$blocksize
>>
>> Unit is MiB/s.
>>
>>   Blocksize | Zero-copy (*) | Buffered |   Bounce
>> -----------+---------------+----------+-----------
>>          4K |          35.1 |     17.1 |      33.8
>>         64K |           522 |      251 |       492
>>
>> *: This is done by reverting the commit 968f19c5b1b7 ("btrfs: always
>>     fallback to buffered write if the inode requires checksum")
>>
>> Although with page bouncing the performance is only around 95% of
>> true-zero copy, it's still almost double the performance of buffered
>> fallback.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>> Changelog:
>> v2:
>> - Rework the comment in btrfs_dio_write()
>> ---
>>   fs/btrfs/direct-io.c | 45 ++++++++++++++++----------------------------
>>   1 file changed, 16 insertions(+), 29 deletions(-)
>>
>> diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
>> index 57167d56dc72..173fe065fc38 100644
>> --- a/fs/btrfs/direct-io.c
>> +++ b/fs/btrfs/direct-io.c
>> @@ -768,10 +768,25 @@ static ssize_t btrfs_dio_read(struct kiocb 
>> *iocb, struct iov_iter *iter,
>>   static struct iomap_dio *btrfs_dio_write(struct kiocb *iocb, struct 
>> iov_iter *iter,
>>                        size_t done_before)
>>   {
>> +    struct btrfs_inode *inode = BTRFS_I(file_inode(iocb->ki_filp));
>>       struct btrfs_dio_data data = { 0 };
>> +    const u64 data_profile = btrfs_data_alloc_profile(inode->root- 
>> >fs_info) &
>> +                 BTRFS_BLOCK_GROUP_PROFILE_MASK;
>> +    unsigned int dio_flags = IOMAP_DIO_PARTIAL | 
>> IOMAP_DIO_FSBLOCK_ALIGNED;
>> +
>> +    /*
>> +     * Userspace may modify the buffer while DIO is in flight. With
>> +     * data checksumming this would produce a checksum that doesn't
>> +     * match the persisted data; with duplicated profiles the mirrors
>> +     * would diverge. Bounce in those cases so writeback sees stable
>> +     * content.
>> +     */
>> +    if (!(inode->flags & BTRFS_INODE_NODATASUM) ||
>> +        (data_profile != BTRFS_BLOCK_GROUP_RAID0 && data_profile != 0))
>> +        dio_flags |= IOMAP_DIO_BOUNCE;
> 
> Unfortunately this will deadlock at generic/647.
> 
> Currently btrfs avoids the deadlock by disabling page fault for the 
> @from iov_iter.
> 
> But that iov_iter->nofault is not respected during 
> bio_iov_iter_bounce_write() -> copy_from_iter(), thus we will hit a 
> deadlock at exactly the situation described in the comment just before 
> btrfs_dio_write() call.

It turns out that we can simply disable page faulting during 
btrfs_dio_write().

But this will come with new problems.

With page fault disabled, we will not hit the deadlock, but we will hit 
another case where we have already allocated a new OE, then page 
bouncing failed, resulting no real dio bio being submitted.

Then we go into btrfs_dio_iomap_end() which will mark the allocated OE 
as error.

Later even if we fall back to buffered write, we got to 
fdatawait_range(), and since we got an OE marked as error, it returned 
error, failing the buffered write fallback.

So this new BOUNCE flag indeed exposed several btrfs error handling 
problems.
