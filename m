Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7892F3890FF
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Apr 2026 06:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775543821; cv=none; b=c1dl+AB170QtnPHZVK06FZ1bcOxrYMRNMexdQQ6tQQ+qreExEsoWrZuyrrxG72/otM0lqgUeY49v+VCZxsrVAjPSktm/pEjUQ37TX1WASfKHGYUvwoHVkwNiR+xaJLJsmk0qi6KZIePM2l+hufvQV3WsFS5u5Z/CZ75dwOBzNQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775543821; c=relaxed/simple;
	bh=pOCWfoF3924D3ERsq3Qtvn+zNuDHfCGykexpGGtZQPc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UOJCU0QiRXRI83F+TryAijtzWVBjEEN8u3y7VoW1dWYsreIH0PcA6pANUHYu40AEvIGr9es1ST+OeF1MsaeiC3+x+aHB5WTrKVjHWf4cGAGsJm2k1R1Dr/HWI2AW5Cy9G06C3/0RC6crYzxXgCwp9SgF5cVgWnP236ZbH3wbtYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MHDgHhtz; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MHDgHhtz"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-82cdb4ab547so2287083b3a.2
        for <linux-btrfs@vger.kernel.org>; Mon, 06 Apr 2026 23:37:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775543820; x=1776148620; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VuThvXuhc8dtcpyzlEy3qPedrQ8VLxO6Y8w2eyd5s04=;
        b=MHDgHhtzPgOTt9UknXNYMg4WA+S8VSRCeeyjJT2cy43NUMgNuN8xuySGdmz7+CCcZY
         bxQNRSqI5c8ptm1TS0PNGuxQlIpUPrg45zAxFehNVJWKeu4hGGnPgcMQ6aoeexy/9Ly3
         yJAC1LXVZ+wZMi7BiKRWQh2x/s99Ha8OK6JsquFP/BABQ3TKIdX7fvBcZrQrUrXTSpQU
         varPIjDwkbJGxzyB+fldrdNuAIkVLL4c2yWGKjRPPiLaHC/p9rV+ias4V1RzRHlHqXnN
         MPBE8H2nu+iZF9np1wDO6C1iaEtstGVHKqyQ08vNU27B1tML+iVjW8tC0mW508HOaapZ
         fqeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775543820; x=1776148620;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VuThvXuhc8dtcpyzlEy3qPedrQ8VLxO6Y8w2eyd5s04=;
        b=d+YV4ufXvHDyrPEOGQUT8ZcqeyazYw2E8qOqjuK5XiYyK/Pl2ktDThApGMEFykvRDV
         70jwLFmYdxLCfL8Zy8Bk80FVf+eLWTayKDbs0AtWDaz6WfSdnk9XwlDmY/TheMDEFtAv
         lJrjoRJmatjrbqHfnbAAM9DDW/eTRvdqwj3tGBR/XigWXAcCsdbU5r/G4QSrBFtBn/cX
         399ZGDS8PCaohwTPVX9kttvO69r3VLCQubLfgOuLx8sZwYe53jd0UbsoebqLjC0fTRlj
         Zl58mDeKHF3PySA/Kudc3A40+ekDy2lB9Sfe9dmzfe3ct9kgnBsPR9Fn2PnWLCA06m/v
         PEtQ==
X-Gm-Message-State: AOJu0YwCzJcAHQXFF6gD9YjQRsyF6UjvCr6xcfzUatLypKNbvAFRiTg5
	j9qCU+tvqNuJPq+rIPLGkj3ADteIwNpUNaCph9Sa3GdTWYxSWfkSX5+w
X-Gm-Gg: AeBDiesoz+gkHuSJwsahcBntYK0JIy6WFOiFsRaKmUxr6ZHGeJF64e3cNgoP+nuT+Ek
	Xok4+BsPnQtMIukv4cb29Q6hoFX3mB49tGSJ8WY4r0DK8el4WiV+WyAdXnriKPh4XFpiT9rtaFq
	ZIRK+ZF67wQWpXCzNs5ClPXLEli8Gc7n4PMEy/qCgEKN6pKukBW8Kyll5Q1tVx5EBf2+0rYStfr
	gToLJwZ4wtsE7Qnt2kvLgnLjusI4Be+PoO+JV6GVCsnsB/g9G/gkx5lAlj1mfp983JP+Aeqqt/U
	H0SxJIC7o1hxXIPC9V5KFMcK5iLb9fS2AYdyknAsCNxutWlwQadjpMgYeqnxruu0GM39QH7GFEF
	aPP2FXAwzGgkbjP2givQZo5/Pns9HXpUD1B/B5Bfk1/7B7d2OvvsJ4uEIY5JzJy82WpP45oRVrg
	IdumH5Zq0fpY+knLg4/IGpVLAyObM=
X-Received: by 2002:a05:6a00:800f:b0:82c:e60c:f36d with SMTP id d2e1a72fcca58-82d0dbf1a4emr13975842b3a.48.1775543819674;
        Mon, 06 Apr 2026 23:36:59 -0700 (PDT)
Received: from [192.168.50.90] ([116.87.14.48])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82cf9b3baffsm16493456b3a.14.2026.04.06.23.36.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Apr 2026 23:36:59 -0700 (PDT)
Message-ID: <d5b43371-6a42-4dac-95b6-a1bc4fa12424@gmail.com>
Date: Tue, 7 Apr 2026 14:36:57 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: btrfs_log_dev_io_error() on all bio errors
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <f91b3827c56947e58b4606f142bef022b54da70e.1775318158.git.boris@bur.io>
 <5790719b-70a6-4d75-813d-5842e77c7b89@gmail.com>
 <20260406161255.GA1743674@zen.localdomain>
Content-Language: en-US
From: Anand Jain <anajain.sg@gmail.com>
In-Reply-To: <20260406161255.GA1743674@zen.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/4/26 00:12, Boris Burkov wrote:
> On Mon, Apr 06, 2026 at 09:56:07PM +0800, Anand Jain wrote:
>>
>>
>> Disagree. We should only track block-device-specific errors;
>> specifically, only the missing MEDIUM ERROR should be added [1].
>>
>> Including all error types would capture transport and fabric-related
>> errors, which do not justify a device replacement or permanent error state.
>>
>> In my experience with storage and transport protocols, transport errors
>> and timeouts are often transient and far more frequent than actual block
>> device media failures. Including them would introduce unnecessary noise
>> into the device statistics.
> 
> This is just my mistake. I messed up with git and resent my v1 instead
> of the updated version after Christoph's review here
> https://lore.kernel.org/linux-btrfs/20260327102253.GA18582@lst.de/
> 
> I intended to only log bdev error on IOERR, TARGET, MEDIUM, and
> PROTECTION as he suggested.
> 
> Sorry for wasting your time with that, Anand.

My bad - I should have checked v1. Thanks.


> Boris
> 
>>
>>
>> #define BLK_STS_NOTSUPP         ((__force blk_status_t)1)
>> #define BLK_STS_TIMEOUT         ((__force blk_status_t)2)
>> #define BLK_STS_NOSPC           ((__force blk_status_t)3)
>> #define BLK_STS_TRANSPORT       ((__force blk_status_t)4)
>> #define BLK_STS_TARGET          ((__force blk_status_t)5)
>> #define BLK_STS_RESV_CONFLICT   ((__force blk_status_t)6)
>> #define BLK_STS_MEDIUM          ((__force blk_status_t)7)
>> #define BLK_STS_PROTECTION      ((__force blk_status_t)8)
>> #define BLK_STS_RESOURCE        ((__force blk_status_t)9)
>> #define BLK_STS_IOERR           ((__force blk_status_t)10)
>> <snap>
>> #define BLK_STS_OFFLINE         ((__force blk_status_t)16)
>> #define BLK_STS_DURATION_LIMIT  ((__force blk_status_t)17)
>> #define BLK_STS_INVAL           ((__force blk_status_t)19)
>>
>>
>>
>> [1]
>>
>>
>> diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
>> index 2a2a21aec817..d7af38e9ce29 100644
>> --- a/fs/btrfs/bio.c
>> +++ b/fs/btrfs/bio.c
>> @@ -352,7 +352,8 @@ static void btrfs_log_dev_io_error(const struct bio
>> *bio, struct btrfs_device *d
>>  {
>>         if (!dev || !dev->bdev)
>>                 return;
>> -       if (bio->bi_status != BLK_STS_IOERR && bio->bi_status !=
>> BLK_STS_TARGET)
>> +       if (bio->bi_status != BLK_STS_IOERR && bio->bi_status !=
>> BLK_STS_TARGET &&
>> +           bio->bi_status != BLK_STS_MEDIUM)
>>                 return;
>>
>>         if (btrfs_op(bio) == BTRFS_MAP_WRITE)
>>
>>
>>
>> Thanks, Anand
>>
>> On 4/4/26 23:57, Boris Burkov wrote:
>>> As far as I can tell, we never intentionally constrained ourselves to
>>> these status codes, and it is misleading and surprising to lack the
>>> bdev error logging when we get a different error code from the block
>>> layer. This can lead to jumping to a wrong conclusion like "this
>>> system didn't see any bio failures but aborted with EIO".
>>>
>>> For example on nvme devices, I observe many failures coming back as
>>> BLK_STS_MEDIUM. It is apparent that the nvme driver returns a variety of
>>> BLK_STS_* status values in nvme_error_status().
>>>
>>> So handle the known expected errors and make some noise on the rest
>>> which we expect won't really happen.
>>>
>>> Signed-off-by: Boris Burkov <boris@bur.io>
>>> ---
>>> Changelog:
>>> v2:
>>> - proper bdev err logging for expected block errors
>>> - btrfs_warn_rl for all other errors
>>> ---
>>>  fs/btrfs/bio.c | 3 +--
>>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>>
>>> diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
>>> index 2a2a21aec817..08b1d62603d0 100644
>>> --- a/fs/btrfs/bio.c
>>> +++ b/fs/btrfs/bio.c
>>> @@ -352,8 +352,7 @@ static void btrfs_log_dev_io_error(const struct bio *bio, struct btrfs_device *d
>>>  {
>>>  	if (!dev || !dev->bdev)
>>>  		return;
>>> -	if (bio->bi_status != BLK_STS_IOERR && bio->bi_status != BLK_STS_TARGET)
>>> -		return;
>>> +	ASSERT(bio->bi_status);
>>>  
>>>  	if (btrfs_op(bio) == BTRFS_MAP_WRITE)
>>>  		btrfs_dev_stat_inc_and_print(dev, BTRFS_DEV_STAT_WRITE_ERRS);
>>

