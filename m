Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C78D29B799
	for <linux-btrfs@vger.kernel.org>; Mon,  6 Apr 2026 13:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775483773; cv=none; b=ATO2EqemfBRHuS6XpgQNUOgso2OBEfgY9px4kZE495CNilCL3AdGBNi54SHe6N9idhSf16G4mw9h16Qe+RlnVsfPn/vp9+vL1ZO3a28/nOm2U2x4qNDDz5IBd+56ISc6lLREZQ4q7+Zi7ExCo5hqYoAcL78Ncl2UPyoEieccJM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775483773; c=relaxed/simple;
	bh=FpUFBpb8+X/PVQTrwXV2LX04t53Q2wRe+tJStXyfeVM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=aegySctg6bXKi5BQCTG+mFF/UggcEy1j/5wNBriR2XULJW3ZngwKKqyCMMlL64n2VycLEmtuyHfe9i6cChn/g2NyvRdE/z6DelCCNW0CqAxjvIR1qIQ7KFKYp7CilxReHrabxx+rg32Fy7V4QCmOLsw/gPSDN5Y2+lRey8xl+9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OFg9+9ni; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OFg9+9ni"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-35da1af3e10so3564681a91.3
        for <linux-btrfs@vger.kernel.org>; Mon, 06 Apr 2026 06:56:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775483772; x=1776088572; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xLyzAn9QqfQlSITZf0YC+/6euCArn6YS8CZWi+Adyn0=;
        b=OFg9+9niJT1vUZLIWbH1NyPoMIEMw3bzlYlvaayJcP291zn4Pjof8y0D5aUSTVaQKT
         L4My0SXv9Xw2TCjtfk7wXxTV2uxsLgm30tuSh3hE7/H19WFIg7BEhe6hdjahy8BsQqKO
         agm6MX4NrmYtMSYPPwdVBwVWeZZRlCacJnv5286AatRmnP39bVR4VaeqRHvnUckmzdGZ
         NfC0bOTWg8KDZ8K7WovW/nltAq61ww3+1aooxs52U8rbC117+K+2g2/K9YL2ethZw717
         JHRxfGQ+DNNMINAA5uFsXG+UvV37OjxjDH+elccgWIncgexBqrNqoXPyyO+rIDH/mw4s
         q45w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775483772; x=1776088572;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xLyzAn9QqfQlSITZf0YC+/6euCArn6YS8CZWi+Adyn0=;
        b=QaIyjSSCF8NrOwgyxb6LBD2IT9M+/uTfaM6P5w6uVm+7JM9Iblqp5rqa9v7zhLZKng
         sRfAp6ADZtq20SjW0iL5jJOgvsRmIpn9PO6AxESH0wMNqKVPH90uqlOEZ0gnn4oLkn7s
         fiaKy20AO5ol8HKwO9ABwxLAaJLMB6NXeHTeFUCuqN1hLMDfGPe60Cb9mXzPCEzhR5ZU
         EDPZARtI6XKCMcogSnS2pn/QmPeRv6VPcGSMlP7wXt/bn5jIlrheYWjOxUM2rf64M8Xa
         PaFMUNqA8Mt7Y+EZcA6kNwWDOW60UQHLLGhCFVz28gBa7HK4Jpoaec0+S8xMUf/Q65ZL
         7LvQ==
X-Forwarded-Encrypted: i=1; AJvYcCXqEdiCoV6C7dGujGPgdzUFwAiYGb2h0cFqbM7QG9ssTAoC+gIrvySy9uVB7KKHW8emXqKXntuVWejmfg==@vger.kernel.org
X-Gm-Message-State: AOJu0YznCGl5HCg32X7y3peZQshHr92Ybk/wrY3+L9C2uDmAEqF+hd6I
	3K53YecDvYLk8rIyMGPfZZ9g1yJp2dYqzJj5/Mp9HwKGE440xnFr2KcXIwhjrM0k
X-Gm-Gg: AeBDiesdDTUNv+oTvi9ET1Z4TgaIcJJfWzI04VUawB1TPgAzdzr2maL+KZG8aNX1ID8
	7bHe3cOnR6hF93YV3fIBZc84YC47STz9WooRPSJNGC/riRtv+3WCusf1IRwXgbLpVkscqs59Ax4
	nwLCUp7F4A2Xg/hgG+DpwNY91oya4eaUkOzQmMa2h4UeXZYNiaatH+EXt0bj2YhH5/Wm+u6WPPl
	qwmUnnI0W+xy3ZhfYROQwFSS+5LAYxX8U8CxrEGVcYWM7mmecWOsp7A8zm7Sosh/RCtzX9D/Wmo
	wqyGWcpHha3hf1HN0kgsnLu0BoSR012p/LEudW9OkJ17vd2I8/CvidZNhKsBRl4Y1p4ZUAzGPzS
	Y2UY7IoWz4UniaQibKq67v8583U8k+tgOtDwOyqoVRLksDxpJp3EW4q0pVwB0TTMobP0pJNb2fs
	n8Q5QUrtNEIE51bDbN/hSSUt5srz5pCs5WopVf2sE=
X-Received: by 2002:a17:90b:3c4c:b0:35d:95eb:879a with SMTP id 98e67ed59e1d1-35de6871781mr12501401a91.13.1775483771626;
        Mon, 06 Apr 2026 06:56:11 -0700 (PDT)
Received: from [192.168.50.119] ([116.87.14.48])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35dbe959886sm19373895a91.14.2026.04.06.06.56.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Apr 2026 06:56:11 -0700 (PDT)
Message-ID: <5790719b-70a6-4d75-813d-5842e77c7b89@gmail.com>
Date: Mon, 6 Apr 2026 21:56:07 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: btrfs_log_dev_io_error() on all bio errors
To: Boris Burkov <boris@bur.io>, linux-btrfs@vger.kernel.org,
 kernel-team@fb.com
References: <f91b3827c56947e58b4606f142bef022b54da70e.1775318158.git.boris@bur.io>
Content-Language: en-US
From: Anand Jain <anajain.sg@gmail.com>
In-Reply-To: <f91b3827c56947e58b4606f142bef022b54da70e.1775318158.git.boris@bur.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



Disagree. We should only track block-device-specific errors;
specifically, only the missing MEDIUM ERROR should be added [1].

Including all error types would capture transport and fabric-related
errors, which do not justify a device replacement or permanent error state.

In my experience with storage and transport protocols, transport errors
and timeouts are often transient and far more frequent than actual block
device media failures. Including them would introduce unnecessary noise
into the device statistics.


#define BLK_STS_NOTSUPP         ((__force blk_status_t)1)
#define BLK_STS_TIMEOUT         ((__force blk_status_t)2)
#define BLK_STS_NOSPC           ((__force blk_status_t)3)
#define BLK_STS_TRANSPORT       ((__force blk_status_t)4)
#define BLK_STS_TARGET          ((__force blk_status_t)5)
#define BLK_STS_RESV_CONFLICT   ((__force blk_status_t)6)
#define BLK_STS_MEDIUM          ((__force blk_status_t)7)
#define BLK_STS_PROTECTION      ((__force blk_status_t)8)
#define BLK_STS_RESOURCE        ((__force blk_status_t)9)
#define BLK_STS_IOERR           ((__force blk_status_t)10)
<snap>
#define BLK_STS_OFFLINE         ((__force blk_status_t)16)
#define BLK_STS_DURATION_LIMIT  ((__force blk_status_t)17)
#define BLK_STS_INVAL           ((__force blk_status_t)19)



[1]


diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
index 2a2a21aec817..d7af38e9ce29 100644
--- a/fs/btrfs/bio.c
+++ b/fs/btrfs/bio.c
@@ -352,7 +352,8 @@ static void btrfs_log_dev_io_error(const struct bio
*bio, struct btrfs_device *d
 {
        if (!dev || !dev->bdev)
                return;
-       if (bio->bi_status != BLK_STS_IOERR && bio->bi_status !=
BLK_STS_TARGET)
+       if (bio->bi_status != BLK_STS_IOERR && bio->bi_status !=
BLK_STS_TARGET &&
+           bio->bi_status != BLK_STS_MEDIUM)
                return;

        if (btrfs_op(bio) == BTRFS_MAP_WRITE)



Thanks, Anand

On 4/4/26 23:57, Boris Burkov wrote:
> As far as I can tell, we never intentionally constrained ourselves to
> these status codes, and it is misleading and surprising to lack the
> bdev error logging when we get a different error code from the block
> layer. This can lead to jumping to a wrong conclusion like "this
> system didn't see any bio failures but aborted with EIO".
> 
> For example on nvme devices, I observe many failures coming back as
> BLK_STS_MEDIUM. It is apparent that the nvme driver returns a variety of
> BLK_STS_* status values in nvme_error_status().
> 
> So handle the known expected errors and make some noise on the rest
> which we expect won't really happen.
> 
> Signed-off-by: Boris Burkov <boris@bur.io>
> ---
> Changelog:
> v2:
> - proper bdev err logging for expected block errors
> - btrfs_warn_rl for all other errors
> ---
>  fs/btrfs/bio.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
> index 2a2a21aec817..08b1d62603d0 100644
> --- a/fs/btrfs/bio.c
> +++ b/fs/btrfs/bio.c
> @@ -352,8 +352,7 @@ static void btrfs_log_dev_io_error(const struct bio *bio, struct btrfs_device *d
>  {
>  	if (!dev || !dev->bdev)
>  		return;
> -	if (bio->bi_status != BLK_STS_IOERR && bio->bi_status != BLK_STS_TARGET)
> -		return;
> +	ASSERT(bio->bi_status);
>  
>  	if (btrfs_op(bio) == BTRFS_MAP_WRITE)
>  		btrfs_dev_stat_inc_and_print(dev, BTRFS_DEV_STAT_WRITE_ERRS);

