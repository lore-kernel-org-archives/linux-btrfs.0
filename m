Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795664594;
	b=AveUG0Kd0exEc0MJ4oLJ1Zf9NFBZX62k5fyMLcGsk+B0dW8n7A+Cr1rPek8fQJnSeWUY
	 gc6SXMF7bABUnjrjKJ6YDTiqG67+VIhFgbM0rqlKZiAsb1kZJuNM9mLfZJ4FnSLobIKYN
	 pu3QWGJh82PD/zC2vTAiy9KzsY+TljA+6MHt9Br/uEEXCurXyF0bIWTvTJQcqBSii7P+D
	 t9S20XPEDQP69orYHYiH+FI9B8O/pYc6sHx0ITmYlbzxV9kt7pua17NHEr5/bhj3vi59c
	 O6XH2Dp6R8QHy23yAwUKr7FS1tgEReXoqcc7KSpM3pyhvgQh6ehO1MMX2V3A5ZnbzZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795664594;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:Autocrypt:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=EI4pJdI0WmhxXxJPMi09Gl4S65MeWUxL0RMpo6cW4aE=;
	b=u6d3fzX9psnUHBS6sTFLzxdHqne5rnChoOHNfRJ+WB1fnYFVTTw773zQRj29CkNfzpeG
	 3EjO4lMYo9ymW9ZVV7yn5V3J731+u325m8lD16O4wen7m70u/8YwiP9ZaS7xszwLNS7HS
	 G7RF3b85CFIqj6lXCis00cP06VD/VvP3vAejNkseZkD95Z4O6TFtHcQEqR227AadeEh+G
	 9kaix4vcdFqWxtodDk8pOcBu/g4v+uGzzJUcRWlfusS4pSkSOLUMjyXDBL3fNJHVpkxGN
	 gUkhMNDbWgysrYjmk4r+zFC7AO66URjWKYySMjvGUJjIQB1Ih52KJr8mE9kqhVn0R1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=NqlBFMno;
	arc=none smtp.remote-ip=209.85.208.53
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1323A606A31E
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Nov 2026 03:43:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1323A606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=NqlBFMno
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6b87a240de3so8231122a12.1
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 19:43:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795664592; x=1796269392; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EI4pJdI0WmhxXxJPMi09Gl4S65MeWUxL0RMpo6cW4aE=;
        b=NqlBFMnoOWC4++GSYKUjqcjCXH3qlG6b9MrRzrkbrvzdCe91EXrl+5LTYLXo4bQ2qC
         ib9ZJdHfEaoQJPXsKnDcFJd/3ng7+RVeTHzZYr7S0zCTMjeXziHaJeLJC2noYBaabsy+
         +VNa5B8KbC318UfzKcgSyFM3cOLApL+0Dyo+Xd9xORzh/dUnl5rkXZA+Y4Z6wZyruUuj
         TFweNVHUBBqGE+92INx+TetytZj7tlxG9UkstoBvmAQuTbZ03BprEW6393UQc8hGT8gR
         JdHAzOCezqPezQLdaaGPaUZPPqgdy1zB1Ygge9B7G7CT+Z1VyV0cO3OJcI8vHs4wsNNr
         yR7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795664592; x=1796269392;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EI4pJdI0WmhxXxJPMi09Gl4S65MeWUxL0RMpo6cW4aE=;
        b=kJzHZjO3D3Zpso2+sF+q53Ao6nruyZ40WmgzGNjjpozkt6nd80cDEF7+NWGirwtjE9
         OUxbG3SSTH9xY7us/tznKHqUwDlunxZMuaIZ+8R1k6EFVFLc5Q28vzYgyVsEGYIrOnBd
         628riVEd7J+QonmzG8W8EWJ0z7fXBfcFh/jmHrAZ8MkD1SKLUHcgsDSn+tmlXvxG1IWX
         LRvggRc1YkXULCSm7dtFnElNqTgcVmkPHpTJ8LsCOKetIZGMrG5ntVp+AieHuFzW5QyA
         rPbMifr3zopGYgkl8f3/y44V9S9pCTv2k5rDaT3J7KbIf67K62HX9TM9IgQoH6e+KJ3n
         ifPA==
X-Gm-Message-State: APuU4Z/5LZ8AbHulftqekYCkZdzif7LuYUZrYb605e1WwJ37TTz7bBYX
	I/N/Qf/d/SPTtE6JU8vyh5ywb6s8l38+FpWn/Kb45IbuiELx3CbfVCTve9dNq7q6/EKCtQN7WFa
	wVxxqsH5JCg==
X-Gm-Gg: AZFdTZcs4NXZCHsyy661qe3vJYmQlMsFW8/jdjxWJaIoyDyrmdjKDWQoxcuM8XAYiy6
	KFB9swAcxiHhnoT6piwyECpFoGJ6xqpfi2FdlWoI7IjhPrWxTqVvU2HaFpj7MkWlVhSRWCoLCst
	eRjT4DvPZ47yYflKaPdjTvj5FJc0iUH8kij8GI+LFJf2fWhGjGJjo4H6IsW98CPDHc5fm0Ec1hM
	xECi3S7GackuX0/FTVHPQGgsNhPa9iX+xzIWqWgPKfKRLwrEmTRxyVU68yS9AyFBdROmUqYMMz5
	Ds5ijgXOi0eax7PrOrE4+D/HD9eZgG9a5F1VkCGIQDTh329vBxURoGMbjEUL+5zsSrjTq2Dz0SV
	538gpsrKjucMckJQAGSWPukDFnZdQRpVC27UawutFiGS1+NJRleznzHQSJjaTaS+u3Zbf7nsPl5
	HmQcgshCQIN6uUFcXYZOpu0mRFuICE56pzTFvLnlsaDK25YmgbLWf6m+1ybt3bLz7FgwFug69B+
	SXvU2AUJDYFyfRxiYcQaHuA/AR3rx0fj8FJTWiGf8LCkUefv2xI1PKNnY/lxQa/H1lMTYohRWq1
	qTcDhH4H/zpyGNQrfnqgbGrWqdRjma2m+hAY6eule8Q=
X-Received: by 2002:a05:6402:2812:b0:6bb:2a86:1a42 with SMTP id 4fb4d7f45d1cf-6bb2a861cc1mr3314383a12.42.1795664592223;
        Wed, 25 Nov 2026 19:43:12 -0800 (PST)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde6d028a54sm9307949a12.18.2026.11.25.19.43.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Nov 2026 19:43:11 -0800 (PST)
Message-ID: <d9e8abc6-29d2-4067-a2be-ecb5eb275b12@suse.com>
Date: Thu, 26 Nov 2026 14:13:06 +1030
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] btrfs: scrub: handle bwlimit below 512KiB
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <cover.1795642270.git.boris@bur.io>
 <dae911ee8e0d50741fd4d92b7df57e0ebc2707f4.1795642270.git.boris@bur.io>
 <ebf4531e-584f-4d5f-beac-e81133907863@suse.com>
 <20261126005359.GA1984368@zen.localdomain>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJq3ujyBQkUpLw5AAoJEMI9kfOh
 Jf6o8OIH/0mqW+TQM4m2x3hCsnK+oB4yJH1qnGvIhFF/Lhs48wI02sGh6/4aA0hkCDfd9LHQ
 +ci4FUepZ9y4VS01+oIExbg/8ytzGYTzLtb44jK2GBOBVSJkMiha6jp22XFt7WUkT/tvbreu
 WWdGsaJIRQaZChy7xsMI8lqQ2WdmluZJ4LT0wD3l/l6QU1ZseMGySebdY9sVOQEOJNV7Qj92
 /KOAFNmeZshV/qDI8Iw1RTs6TvLqCcqmlZLCmJkYSVhT1RonWRren8xIRcFEgMe004IDnt7V
 qdQhk/nhTS9x9MBAhMRl0TTE1VKDLvVALsud3iZLrmmtYvwPApzGJk052f0m28vOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJq3ukKBQkUzDspAAoJEMI9kfOhJf6o
 SNsH/1ysUWOKmzY0rGS3ZdS61QgqMGhSWD/EJ4UiPw+xO4l4+GtX0fOAqxqsmBKqje3vyhBa
 Z5o/1Y+gNiN+E6RBcSz4b1TAd78sQ2bvT5DWOvBjeeVxHdiuQMIn4S8xk5ZpySBw5ifjoiuL
 0M33UVtJOzM8yfAeL+d/Rp4leJw72SutjkLyZTG/gJIp4pJGD/kFHn24OLL0IxEcO0gOekNZ
 os5e1R6jAJ2ILk7+MDnvU8wXHcCiVzuDhJLI1tih1uUIE50muHQJWbYuVBbdJeu8WlIDDssx
 UOCxLylNG3gDXV5MhLubPTOpp9OiFc/XC37nvkgEcrlmlOFBv4/NJCbECpo=
In-Reply-To: <20261126005359.GA1984368@zen.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/11/26 11:23, Boris Burkov 写道:
> On Thu, Nov 26, 2026 at 10:15:45AM +1030, Qu Wenruo wrote:
[...]
>> For the bandwidth limit, I doubt if it's really practical to set it so low.
>> One 1GiB bg will take over 30min to scrub, which doesn't sound that sane.
>>
> 
> I agree in general.
> 
> We have a use-case with a remote disk and a bw budget for bg
> checking where we would like to set a low limit. If you have a small
> amount of metadata and scrub the metadata bg it can be feasible to do
> quite slow scrubs and get some good utility.

In that case, I'd argue the read-only metadata bg can be a larger 
problem, as it means the metadata bg can not be utilized for over 30min 
if using that low bwlimit.

But overall I agree for such bw limited storage, a lower and better 
bwlimit behavior can be beneficial, just don't set the limit too low.

> 
> Would it make more sense if I also sent a patch to extend the scrub
> ioctl to have it respect narrower ranges of the disk than the whole
> chunk?

Sorry but I didn't get what you mean by "respect narrower ranges of the 
disk than the whole chunk".

> 
>>>
>>> However, at higher limits, because the unit of sending is still 512KiB,
>>> sleeping between every IO for a naively calculated limit would be far
>>> too many sleeps and adds unacceptable sleeping overhead, ruining our
>>> ability to even submit at those limits. Therefore, we need to allow a
>>> "burst duration" as a floor for the sleeping duration. 10ms is a
>>> reasonable value: it is a similar number of sleeps at high limits (100
>>> vs 64 per second) and is a responsive duration relatively commensurate
>>> in scale with disk latencies and intuitively seems like it would not
>>> be "too bursty" at any speed.
>>
>> I agree the old sleep behavior is not that good for high limits, especially
>> considering how fast modern storage can be.
>>
> 
> Sorry if I was unclear but the old behavior should be fast on high
> limits, at least as I understand it. My motivation here was:
> 
> 1. slow scrub needs to sleep for required (possibly long) duration
> between IOs.
> 2. sleep for required duration between IOs done naively makes fast
> scrub sleep thousands of times for nanoseconds, now we are harassing
> the scheduler for all the sleeping/waking.
> 3. bring back the upper bound on how often we sleep by always allowing
> the burst worth of IO.
> 
> So the point is to enable slow scrubs without regressing fast scrubs, I
> don't think this patch should help fast scrubs at all. Besides making
> the code a little simpler, at least IMO.

Oh, thanks a lot for correcting my misunderstanding.

Despite the changing bwlimit halfway part, now it looks overall good to me.

Thanks,
Qu

> 
>>>
>>> Now that we might sleep for a rather long time rather than at most 1s,
>>> although the sleeps are cancellable, also add a wakeup/cancel path from
>>> changing the limit again. If the user tunes the limit higher, they
>>> should just start running rather than needing to cancel.
>>>
>>> Signed-off-by: Boris Burkov <boris@bur.io>
>>> ---
>>>    fs/btrfs/scrub.c | 71 +++++++++++++++++++-----------------------------
>>>    fs/btrfs/sysfs.c |  2 ++
>>>    2 files changed, 30 insertions(+), 43 deletions(-)
>>>
>>> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
>>> index a976897cea8d..d68e8d2f766f 100644
>>> --- a/fs/btrfs/scrub.c
>>> +++ b/fs/btrfs/scrub.c
>>> @@ -57,6 +57,9 @@ struct scrub_ctx;
>>>    #define SCRUB_TOTAL_STRIPES		(SCRUB_GROUPS_PER_SCTX * SCRUB_STRIPES_PER_GROUP)
>>> +/* Length of a burst of throttled scrub IO, see scrub_throttle_dev_io(). */
>>> +#define SCRUB_THROTTLE_BURST_MS		10
>>> +
>>>    /* Represent one sector and its needed info to verify the content. */
>>>    struct scrub_sector_verification {
>>>    	union {
>>> @@ -195,9 +198,8 @@ struct scrub_ctx {
>>>    	atomic_t		cancel_req;
>>>    	int			readonly;
>>> -	/* State of IO submission throttling affecting the associated device */
>>> -	ktime_t			throttle_deadline;
>>> -	u64			throttle_sent;
>>> +	/* Earliest time the next read may be submitted under scrub_speed_max. */
>>> +	ktime_t			throttle_next;
>>>    	bool			is_dev_replace;
>>>    	u64			write_pointer;
>>> @@ -451,16 +453,19 @@ static void scrub_blocked_if_needed(struct scrub_ctx *sctx)
>>>    /*
>>>     * Pause the scrub, and sleep for the throttle duration. Pausing allows the
>>>     * commit to proceed unblocked.
>>> - * Scrub cancel interrupts the sleep.
>>> + * Scrub cancel or a change of the limit the sleep was computed under
>>> + * interrupts the sleep.
>>>     */
>>> -static void scrub_throttle_sleep(struct scrub_ctx *sctx, ktime_t timeout)
>>> +static void scrub_throttle_sleep(struct scrub_ctx *sctx, struct btrfs_device *device,
>>> +				 u64 bwlimit, ktime_t timeout)
>>>    {
>>>    	struct btrfs_fs_info *fs_info = sctx->fs_info;
>>>    	scrub_pause_on(sctx);
>>>    	wait_event_interruptible_hrtimeout(fs_info->scrub_pause_wait,
>>>    					   atomic_read(&fs_info->scrub_cancel_req) ||
>>> -					   atomic_read(&sctx->cancel_req),
>>> +					   atomic_read(&sctx->cancel_req) ||
>>> +					   READ_ONCE(device->scrub_speed_max) != bwlimit,
>>
>> One question, do we really need to bother the scrub_speed_max change?
>>
>> I think this is a little overengineered, and Sashiko is already report low
>> priority problem related to this part.
> 
> Yeah we can drop it, I think this was a nice-to-have UX addon. The user
> can always cancel if necessary.
> 
>>
>> Thanks,
>> Qu
>>
> 
> Thanks for the review!
>
