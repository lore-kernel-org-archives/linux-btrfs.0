Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6666B3A380F
	for <linux-btrfs@vger.kernel.org>; Tue, 26 May 2026 21:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779831782; cv=none; b=RN7TIC6j6quskVbTTHdK4BvXJRwwPT2JasFIPhPfTRTfY8hW4sTf1tJZhFKeDf1xkoZ7B9uGrbUNrUaaiaF6pUf1KXYpFvKxE2LZBzVO7kSL/aSbpZFeHRcbGRd4pSnxxGkVEavStBZu+YfCyau+aNyG8r4w2DqHd6OFBzcC/Nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779831782; c=relaxed/simple;
	bh=5OigM3VkT4jIdUaI8WZ2bNs5rDIbKdRQXk1Cl6WzPds=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CSUsXIYvkE/lqFz+CGlgiaoXMDO8ohZueWn2kLbFw0N1hjaxmTYshaf8XFvIyCx2SSEePXQtEwsCHdX2Oyki0fzuwbAe80pXuuVZAsle6yNfG8ffJeLRT/OQniOawJe680K7KbEwi8pgcV5pAQ1jr5pcFjjkvd8ELhQCf9Jgw+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=MneCTNEZ; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="MneCTNEZ"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4896c22fcbaso94675995e9.0
        for <linux-btrfs@vger.kernel.org>; Tue, 26 May 2026 14:43:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779831779; x=1780436579; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=yD+8njfhHqex8SazD1eDRurrlAkfN6Vj8mm2i7lIJuw=;
        b=MneCTNEZPXH4jhlzo3Ed0ZOKCopoBz6+B4K04UbS/WV7O+/RtulbqHHqJOzCdhGQTz
         YGRMDfo/OYhjX4S7KcGH+CL/UR9zk/d852NLrZgmvV5QC8WFFxqsDof056UyJIuKWm1X
         JQthBf2msmnXpjkpJeHqS8ra7Fmb+iFr9Q8N+L0vd/9M9cpCjwPNk7gYL8VFEJ5WSoGa
         TPFramN5g5USEjGrendLPXAsKR8wZpN1cF/Lls94OJ9R9IPonXjqHIOMc8qrp5MXQly5
         +KhCuil13EmWMZRUS1IMtYKeVlNvzyxojqaPe/aFJDK7JXYsPG/jATRmz7nF9s9yLR09
         Z0Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779831779; x=1780436579;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yD+8njfhHqex8SazD1eDRurrlAkfN6Vj8mm2i7lIJuw=;
        b=B6Jeuy485vPxp7ZPu5C0ShLEPEgqtvhh1LKhNzymtI0KrWKA/HeXyYnLEukJQ7ebbe
         smUeXySjyxKVs0TTIq+JTSQCstzp1/C+63f+oICodmdUAZtYzpPURUti3p+VERKQj9Du
         bbDc/KHV02l4G0OojarRqcH5mIOsTt9dn16/fbywC/X6mLb79c3QHnXysAjrrRrixq7J
         PT25XDYyxu0C/fWRg1MG0fUgXlgKCLF9FFymi82lh82mAQLvWp0BBVBBNJN8WaYKPjru
         jmcZTo26m9x4y+aQM1RCCUsonintcfW+rDw8nvLNt64Z3zvoqCMZKXmRHKIK7Rje9otS
         iUlg==
X-Gm-Message-State: AOJu0Ywv2YJZJOqa8thxYi6WV3NecRpJ6p7e/+5dtoOKe7n8GnIR89HX
	Ukd8ubeMRVSyGDoRAQeCcMGNY/wi5rgQO8QHyKauCMufoW/bR62LaL6z+vRXZ8licznlnspT5UF
	i2yVW
X-Gm-Gg: Acq92OEfKnTPFV9A2LvvDeebaSWekTksDgOzufFJ7IUVTqGqFRCO039KSone39BQDQv
	oPjVtmKPj01F48nIO2nJyOTREpT0ni7S2vFpHn1C0ChkRs1F6wK5K32W2uy9nrDbiYBLzeto0Ia
	geuAjGleHP1XHecQr44lrvSNIU3Tz/s+16gcuMxbDZ2+oorB7MP/yJcjtZROyDL08AH/dH2xZ0B
	t5q3S4geG0fnkQOZgKCdc4++HRKmvcfE8F3TXvP3U9Nb/tWAXQ+XWpXJLu1p3rlqjN0Ok8r1luC
	TqdjgMQZm93C/UZ2j6gnyxu6U7bnman8zg3Mt5uzxnhJXw57FcZeYnmx5puyC6vbB5KTLkqm2kg
	MFoe6Za6aj0CZJn04RPtlyzeRp5yo5bkHNUgOTJpxyaWFx1q6xrUTEuNdguiWSHwVZQy+EQRmDW
	k4QOpMKN39LRy6/FrXUC1Vn80iIaG9ZAhRmnQ63lwdF5xq59s11VT60u164WAzsdXZ6h3Sucbnc
	spLsfHIYj1OEvvG/X6ThH5S9w/ykOhobeJ862Mcm0t9hnie2U9mQObsCw==
X-Received: by 2002:a05:600c:4ecc:b0:48a:557e:6b4f with SMTP id 5b1f17b1804b1-490426d2805mr305981295e9.23.1779831778568;
        Tue, 26 May 2026 14:42:58 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c85200c3feesm11331186a12.0.2026.05.26.14.42.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2026 14:42:57 -0700 (PDT)
Message-ID: <7f0ab384-c077-4ec2-8f74-049e3963fb5a@suse.com>
Date: Wed, 27 May 2026 07:12:52 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: use IOMAP_DIO_BOUNCE flag instead of falling
 back to buffered IO
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org
References: <e578ff1a2dd9a4f720ea77bc601534734ce87e18.1779685479.git.wqu@suse.com>
 <20260526175955.GA1359754@zen.localdomain>
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
In-Reply-To: <20260526175955.GA1359754@zen.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/5/27 03:29, Boris Burkov 写道:
> On Mon, May 25, 2026 at 02:35:33PM +0930, Qu Wenruo wrote:
>> Previously btrfs forces direct writes to fall back to buffered ones if the
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
>>   fio --name=randwrite --filename $mnt/foobar --ioengine=libaio --size=4G \
>>       --rw=randwrite --iodepth=64 --runtime=60 --time_based --direct=1 \
>>       --bs=$blocksize
>>
>> Unit is MiB/s.
>>
>>   Blocksize | Zero-copy (*) | Buffered |   Bounce
>> -----------+---------------+----------+-----------
>>          4K |          35.1 |     17.1 |      33.8
>>         64K |           522 |      251 |       492
> 
> This is really exciting!
> 
> Dumb question:
> Do you have a sense (or reference to previous discussion?) that would
> explain why bounce buffering so much faster?
> 
> Thinking out loud about possible overhead:
> 
> - copying overhead : bounce vs buffered both need to copy the user data
> - memory allocation overhead: they both need a folio (to copy into or to
>    dirty). It might already be present for buffered.
> - btrfs architecture overhead: They both should be doing all the same
>    cow-ing/extent_map manipulation.
> - synch-ness: The buffered fallback immediately writes back and waits as
>    far as I can tell, so it shouldn't be some kind of "writeback doesn't
>    get triggered when we want"
> - balance_dirty_pages: we do call into it in the buffered fallback so we
>    could be made to wait. But I would sort of not expect that to happen
>    on the test you are running, unless you are doing lots of other
>    dirtying at the same time? Since each fallback pass does trigger
>    writeback so it shouldn't build up too much.
> - libaio/iodepth true async: buffered fallback is synchronous per go
>    while maybe bounce can be more properly async? Haven't thought through
>    this too carefully.
> - generic page cache overhead: we just have to do a lot more work for
>    the same operations. managing folio state, xarray, locks, balance
>    dirty pages, writeback xarray, etc etc
> 
> I would guess that it is the "generic overhead" in the benchmark.
> Curious if you have any clearer thoughts on it.

I guess it's mostly due to the page cache synchronization.


But please do not be too excited for now, this new bounce behavior 
exposes several problems, mostly related to the page fault during write.

It exposed a bug that even without this patch, for nodatasum mount 
option that generic/362 (*) can still fail due to failed page fault-in 
and handling of later buffered fallback.

*: Needs this patch to reliably trigger the failure, or it will only 
fail with newly formatted TEST_DEV: 
https://lore.kernel.org/linux-btrfs/20260526070055.60193-1-wqu@suse.com/T/#u

Thanks,
Qu

> 
> Thanks,
> Boris
> 
>>
>> *: This is done by reverting the commit 968f19c5b1b7 ("btrfs: always
>>     fallback to buffered write if the inode requires checksum")
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
>>   fs/btrfs/direct-io.c | 45 ++++++++++++++++----------------------------
>>   1 file changed, 16 insertions(+), 29 deletions(-)
>>
>> diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
>> index 57167d56dc72..173fe065fc38 100644
>> --- a/fs/btrfs/direct-io.c
>> +++ b/fs/btrfs/direct-io.c
>> @@ -768,10 +768,25 @@ static ssize_t btrfs_dio_read(struct kiocb *iocb, struct iov_iter *iter,
>>   static struct iomap_dio *btrfs_dio_write(struct kiocb *iocb, struct iov_iter *iter,
>>   					 size_t done_before)
>>   {
>> +	struct btrfs_inode *inode = BTRFS_I(file_inode(iocb->ki_filp));
>>   	struct btrfs_dio_data data = { 0 };
>> +	const u64 data_profile = btrfs_data_alloc_profile(inode->root->fs_info) &
>> +				 BTRFS_BLOCK_GROUP_PROFILE_MASK;
>> +	unsigned int dio_flags = IOMAP_DIO_PARTIAL | IOMAP_DIO_FSBLOCK_ALIGNED;
>> +
>> +	/*
>> +	 * Userspace may modify the buffer while DIO is in flight. With
>> +	 * data checksumming this would produce a checksum that doesn't
>> +	 * match the persisted data; with duplicated profiles the mirrors
>> +	 * would diverge. Bounce in those cases so writeback sees stable
>> +	 * content.
>> +	 */
>> +	if (!(inode->flags & BTRFS_INODE_NODATASUM) ||
>> +	    (data_profile != BTRFS_BLOCK_GROUP_RAID0 && data_profile != 0))
>> +		dio_flags |= IOMAP_DIO_BOUNCE;
>>   
>>   	return __iomap_dio_rw(iocb, iter, &btrfs_dio_iomap_ops, &btrfs_dio_ops,
>> -			    IOMAP_DIO_PARTIAL | IOMAP_DIO_FSBLOCK_ALIGNED, &data, done_before);
>> +			      dio_flags, &data, done_before);
>>   }
>>   
>>   static ssize_t check_direct_IO(struct btrfs_fs_info *fs_info,
>> @@ -800,8 +815,6 @@ ssize_t btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
>>   	ssize_t ret;
>>   	unsigned int ilock_flags = 0;
>>   	struct iomap_dio *dio;
>> -	const u64 data_profile = btrfs_data_alloc_profile(fs_info) &
>> -				 BTRFS_BLOCK_GROUP_PROFILE_MASK;
>>   
>>   	if (iocb->ki_flags & IOCB_NOWAIT)
>>   		ilock_flags |= BTRFS_ILOCK_TRY;
>> @@ -815,16 +828,6 @@ ssize_t btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
>>   	if (iocb->ki_pos + iov_iter_count(from) <= i_size_read(inode) && IS_NOSEC(inode))
>>   		ilock_flags |= BTRFS_ILOCK_SHARED;
>>   
>> -	/*
>> -	 * If our data profile has duplication (either extra mirrors or RAID56),
>> -	 * we can not trust the direct IO buffer, the content may change during
>> -	 * writeback and cause different contents written to different mirrors.
>> -	 *
>> -	 * Thus only RAID0 and SINGLE can go true zero-copy direct IO.
>> -	 */
>> -	if (data_profile != BTRFS_BLOCK_GROUP_RAID0 && data_profile != 0)
>> -		goto buffered;
>> -
>>   relock:
>>   	ret = btrfs_inode_lock(BTRFS_I(inode), ilock_flags);
>>   	if (ret < 0)
>> @@ -865,22 +868,6 @@ ssize_t btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
>>   		btrfs_inode_unlock(BTRFS_I(inode), ilock_flags);
>>   		goto buffered;
>>   	}
>> -	/*
>> -	 * We can't control the folios being passed in, applications can write
>> -	 * to them while a direct IO write is in progress.  This means the
>> -	 * content might change after we calculated the data checksum.
>> -	 * Therefore we can end up storing a checksum that doesn't match the
>> -	 * persisted data.
>> -	 *
>> -	 * To be extra safe and avoid false data checksum mismatch, if the
>> -	 * inode requires data checksum, just fallback to buffered IO.
>> -	 * For buffered IO we have full control of page cache and can ensure
>> -	 * no one is modifying the content during writeback.
>> -	 */
>> -	if (!(BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM)) {
>> -		btrfs_inode_unlock(BTRFS_I(inode), ilock_flags);
>> -		goto buffered;
>> -	}
>>   
>>   	/*
>>   	 * The iov_iter can be mapped to the same file range we are writing to.
>> -- 
>> 2.54.0
>>

