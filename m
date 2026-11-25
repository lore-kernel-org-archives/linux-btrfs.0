Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795650354;
	b=sg4qsrtDrtZPP/+gwVeYAf7l/KzpN8nXvXLTh5P8hu+ED0noBo2KDEfysohENlot7Zn2
	 8Ntjpx1YoQJKE7LiVAnjrXBng5ZAiGQRFy853HAt4DKqXPRyFjdZn6YSpqDu4AyV89Buw
	 2mEIvb52RbfTjCMWnfltPOyQbhg6GQ4CkYQmL4J708Z+pZzRSZA42mem/B3pCehkaLboi
	 dZav1Dw04cTYyT73/OuwGLdk1JZw9domfx/Sdf2z5DIcKlgS3QJMewtW/BQgeTNxM0Lv4
	 m8DqLafYyHYoPruupv22S+8QqsXUG0HQClWbiNAQXCo4oy/VqvQpOC8A7+vaIInoGgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795650354;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=4BrsELxTNuaCAPlecr5z3s0zjvi8Uq2SwUArQIO9MPQ=;
	b=xiIpmcwg2paH0MZ6fFQwazUC+wax59eCkX5xvgQCSKGB1jHTSvs/cf2URQdXNs4zGcQz
	 excypn2lFry2RCoKMiqn44s7e2QvJd0XVsNfw7QlBuSkDS9Xc1zOjVjJj0NDyv5Cvz7y3
	 uuRJwG78hPi5k+Sxbf01DsJVsEqn5JtrCYASZ+4Q/218fU7ZUdh9XtIRoIfYDM9B7cxvd
	 SPa0PpTqLkvUE7ZGYfiAI0gXW+8bDPDk6NOcgeNbyNo858fz8tpIsq3W+wL/ynrWQoKsU
	 oB/a3vhy19A76+Ws27AQGtwAJY/b9tri2PKksXclbqCNppcYNawEYNyJhQoUb7/zjCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=AwU0o26z;
	arc=none smtp.remote-ip=209.85.218.52
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED830606A31E
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 23:45:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ED830606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=AwU0o26z
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c50e26763a4so99544466b.1
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 15:45:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795650352; x=1796255152; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=4BrsELxTNuaCAPlecr5z3s0zjvi8Uq2SwUArQIO9MPQ=;
        b=AwU0o26z9+2l3WfxSqhdgElXTqVtdM346xAy0NCYtGay5E0WCgI2vkDpgnznNqpDVY
         W9XPANf28xNr9neoikOoMwYZgHEBkCJLaaV9nj5ToyuJUEpC6+qSqKa7dcQ5y+q1ni1Z
         DvxFNolym7E4+hv/NnDgx8ciq07qkCij1vHW2a1ypkqcxjavKSc2jjb8LWwkiNm2QeXC
         z3AtZB+dUTfZB3Aybf7PfqHrIbPIgQ1RoYLN8UOuE4zOObVMgaPM7+gdXF97I7jjMXZ+
         TmnG7h0t4nM16akJx8VuucJz2F6E9MadYeMW8XGobxSwV13HZyYasGxkekR1tri6cXzf
         7QFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795650352; x=1796255152;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4BrsELxTNuaCAPlecr5z3s0zjvi8Uq2SwUArQIO9MPQ=;
        b=CAL5BYmVnG2bPNEhnhHsEbiHFNZGJrybLkvrfjWtof1nha9CL7yH0YewQjkaBVj3/i
         nBy4pcBZgfYhvxAlaReb3uMfYuh6WhXC08fsE/ohBygFfjp/5QfP0rWUfxbBH1DzrxjJ
         Lv90aRwN1vPe0HbtqL0ZvG9uycEGHn2vhArIDG/Bk7CgPG9ANRtVIqRdrEAxxSRaBZV3
         ZW3uAKc0eBwWeUuQg2pcnUYLZAagi84+efOttVKox+Eltk9AgI3Njs6B/YAfwGlHW2vY
         6GFdkG6KCsTUApMwVfF0rHkb4dmMYGJRSSqaaWn2TOCHtaeJKFYXXs2pZbEUH3RllAAk
         wh7A==
X-Forwarded-Encrypted: i=1; AL+hErH7W7feH+o17BcW4tkGEVIHPraDR5OFKyVEMxFb9uITFGPU1NAq13gPOr8Co4DrdbpTRSBc+q3NVELcRA==@vger.kernel.org
X-Gm-Message-State: APuU4Z9MQiz8pKWOLCdjr2F/TFlJ8lLiIcgnW4bQNEZXZ6HPO91DVOi+
	42R/189697Qv39GcvuG/t0DoWpUbiuwAlzjFfkDrzge4Nlz+eCIvSc4oQ4Tfa+SUUDs=
X-Gm-Gg: AZFdTZcQ6J7aDKZBdhjFQ2SGweHyycbySDHsIm+40+NAGLYdK8yisQfrFx4UNpXdnCo
	6TfnRA3K3kccO8DkwUeEK8JBLJxq3sehU60qEDAgXGSxGzzXI/odacAoSkfz04dCFEoWc9NhS7j
	a6iDYQCfcQv8tPg7PIjU0GYfjc0QvKKuHxpVKQ0VGeC+ZwvC8LIWg6FhE6xEZkPwkGf0sU7KRqV
	h7P8wXiUUg3lKJXEPeHzYbjORbr8EWrttbg/SVZ0zVdeAnpBxHMmoAYrMhokKUaVzMpUW7mjs3S
	dQ4fQvIB+0ncAUDYQ5DR/C3gj519heklg4ZvtWX3ugHjJ+7vIXP2xPzTyhLolTjfaUSM3qWNvw3
	qqlCxDKqJPlyNn7wcRzD+jDkW9akvKAJ5GWuvwEI73rVvYu7+h4YLX9IF/wLaCZGBNUEDAe1Jxu
	m11SYVSyGBlJyY3p+4Q9zg3beEhcasrTLGcoftniYeQ3GHrVFXgbDtPNXLKpqi+gu67u/TS/bSy
	shLkAUskRj/UXIKS35Adi7Gk/ImT4yfiVlYPmZyKzl+gY5Nl8Yrx635h2HGTJurDv0JeZFXgeaV
	YyLslixZGJXuCkeR/b8q
X-Received: by 2002:a17:906:f5a5:b0:c46:6a50:40c2 with SMTP id a640c23a62f3a-c513ac7e167mr1708767466b.39.1795650352201;
        Wed, 25 Nov 2026 15:45:52 -0800 (PST)
Received: from [10.86.128.17] ([149.22.87.44])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f099a4d875sm54198875ad.37.2026.11.25.15.45.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Nov 2026 15:45:50 -0800 (PST)
Message-ID: <ebf4531e-584f-4d5f-beac-e81133907863@suse.com>
Date: Thu, 26 Nov 2026 10:15:45 +1030
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
To: Boris Burkov <boris@bur.io>, linux-btrfs@vger.kernel.org,
 kernel-team@fb.com
References: <cover.1795642270.git.boris@bur.io>
 <dae911ee8e0d50741fd4d92b7df57e0ebc2707f4.1795642270.git.boris@bur.io>
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
In-Reply-To: <dae911ee8e0d50741fd4d92b7df57e0ebc2707f4.1795642270.git.boris@bur.io>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/11/26 08:04, Boris Burkov 写道:
> scrub_throttle_dev_io() divides a time slice into up to 64 intervals
> with the computation
>    div = clamp(bwlimit / (16 * 1024 * 1024), 1, 64);
> So at bwlimit below 16MiB/s, the time slice is unitary and above 1GiB/s
> the slice is split into 64 intervals.
> 
> Each interval represents an opportunity to schedule IO and we set a
> throttle deadline to now + time_slice / div. time_slice is 1000ms or 1s.
> 
> At each interval we count bio_size against bwlimit / div, or the portion
> of the per second bwlimit for that interval. If it is under, we send the
> bio with no throttling. Otherwise, we throttle till the end of the
> interval then send the bio.
> 
> This ensures that we have a hard cap of 64 sleeps in a second which
> ensures good throughput for typical unbounded or high limit scrubs.
> 
> But because bio_size is always 512KiB and we send at each interval, the
> practical minimum limit is 512KiB/s, as we will send at least 512KiB
> every second (the longest possible interval when div = 1).
> 
> To support lower limits without ruining throughput at higher limits,
> change to a model which can sleep for an arbitrary duration to properly
> amortize the data sent and acheive an average IO demand below bwlimit
> for bwlimit < 512KiB/s.

For the bandwidth limit, I doubt if it's really practical to set it so low.
One 1GiB bg will take over 30min to scrub, which doesn't sound that sane.

> 
> However, at higher limits, because the unit of sending is still 512KiB,
> sleeping between every IO for a naively calculated limit would be far
> too many sleeps and adds unacceptable sleeping overhead, ruining our
> ability to even submit at those limits. Therefore, we need to allow a
> "burst duration" as a floor for the sleeping duration. 10ms is a
> reasonable value: it is a similar number of sleeps at high limits (100
> vs 64 per second) and is a responsive duration relatively commensurate
> in scale with disk latencies and intuitively seems like it would not
> be "too bursty" at any speed.

I agree the old sleep behavior is not that good for high limits, 
especially considering how fast modern storage can be.

> 
> Now that we might sleep for a rather long time rather than at most 1s,
> although the sleeps are cancellable, also add a wakeup/cancel path from
> changing the limit again. If the user tunes the limit higher, they
> should just start running rather than needing to cancel.
> 
> Signed-off-by: Boris Burkov <boris@bur.io>
> ---
>   fs/btrfs/scrub.c | 71 +++++++++++++++++++-----------------------------
>   fs/btrfs/sysfs.c |  2 ++
>   2 files changed, 30 insertions(+), 43 deletions(-)
> 
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index a976897cea8d..d68e8d2f766f 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -57,6 +57,9 @@ struct scrub_ctx;
>   
>   #define SCRUB_TOTAL_STRIPES		(SCRUB_GROUPS_PER_SCTX * SCRUB_STRIPES_PER_GROUP)
>   
> +/* Length of a burst of throttled scrub IO, see scrub_throttle_dev_io(). */
> +#define SCRUB_THROTTLE_BURST_MS		10
> +
>   /* Represent one sector and its needed info to verify the content. */
>   struct scrub_sector_verification {
>   	union {
> @@ -195,9 +198,8 @@ struct scrub_ctx {
>   	atomic_t		cancel_req;
>   	int			readonly;
>   
> -	/* State of IO submission throttling affecting the associated device */
> -	ktime_t			throttle_deadline;
> -	u64			throttle_sent;
> +	/* Earliest time the next read may be submitted under scrub_speed_max. */
> +	ktime_t			throttle_next;
>   
>   	bool			is_dev_replace;
>   	u64			write_pointer;
> @@ -451,16 +453,19 @@ static void scrub_blocked_if_needed(struct scrub_ctx *sctx)
>   /*
>    * Pause the scrub, and sleep for the throttle duration. Pausing allows the
>    * commit to proceed unblocked.
> - * Scrub cancel interrupts the sleep.
> + * Scrub cancel or a change of the limit the sleep was computed under
> + * interrupts the sleep.
>    */
> -static void scrub_throttle_sleep(struct scrub_ctx *sctx, ktime_t timeout)
> +static void scrub_throttle_sleep(struct scrub_ctx *sctx, struct btrfs_device *device,
> +				 u64 bwlimit, ktime_t timeout)
>   {
>   	struct btrfs_fs_info *fs_info = sctx->fs_info;
>   
>   	scrub_pause_on(sctx);
>   	wait_event_interruptible_hrtimeout(fs_info->scrub_pause_wait,
>   					   atomic_read(&fs_info->scrub_cancel_req) ||
> -					   atomic_read(&sctx->cancel_req),
> +					   atomic_read(&sctx->cancel_req) ||
> +					   READ_ONCE(device->scrub_speed_max) != bwlimit,

One question, do we really need to bother the scrub_speed_max change?

I think this is a little overengineered, and Sashiko is already report 
low priority problem related to this part.

Thanks,
Qu

>   					   timeout);
>   	scrub_pause_off(fs_info);
>   }
> @@ -514,7 +519,7 @@ static noinline_for_stack struct scrub_ctx *scrub_setup_ctx(
>   	atomic_set(&sctx->cancel_req, 0);
>   
>   	spin_lock_init(&sctx->stat_lock);
> -	sctx->throttle_deadline = 0;
> +	sctx->throttle_next = 0;
>   
>   	mutex_init(&sctx->wr_lock);
>   	if (is_dev_replace) {
> @@ -1409,54 +1414,34 @@ static void scrub_write_sectors(struct scrub_ctx *sctx, struct scrub_stripe *str
>   }
>   
>   /*
> - * Throttling of IO submission, bandwidth-limit based, the timeslice is 1
> - * second.  Limit can be set via /sys/fs/UUID/devinfo/devid/scrub_speed_max.
> + * Throttling of IO submission, bandwidth-limit based. Limit can be set via
> + * /sys/fs/UUID/devinfo/devid/scrub_speed_max.
>    */
>   static void scrub_throttle_dev_io(struct scrub_ctx *sctx, struct btrfs_device *device,
>   				  unsigned int bio_size)
>   {
> -	const int time_slice = 1000;
> -	s64 delta;
> +	const u64 bwlimit = READ_ONCE(device->scrub_speed_max);
>   	ktime_t now;
> -	u32 div;
> -	u64 bwlimit;
> +	ktime_t ahead;
>   
> -	bwlimit = READ_ONCE(device->scrub_speed_max);
>   	if (bwlimit == 0)
>   		return;
>   
> -	/*
> -	 * Slice is divided into intervals when the IO is submitted, adjust by
> -	 * bwlimit and maximum of 64 intervals.
> -	 */
> -	div = clamp(bwlimit / (16 * 1024 * 1024), 1, 64);
> -
> -	/* Start new epoch, set deadline */
>   	now = ktime_get();
> -	if (sctx->throttle_deadline == 0) {
> -		sctx->throttle_deadline = ktime_add_ms(now, time_slice / div);
> -		sctx->throttle_sent = 0;
> -	}
> -
> -	/* Still in the time to send? */
> -	if (ktime_before(now, sctx->throttle_deadline)) {
> -		/* If current bio is within the limit, send it */
> -		sctx->throttle_sent += bio_size;
> -		if (sctx->throttle_sent <= div_u64(bwlimit, div))
> +	ahead = ktime_sub(sctx->throttle_next, now);
> +	if (ahead < 0) {
> +		sctx->throttle_next = now;
> +	} else if (ahead > SCRUB_THROTTLE_BURST_MS * NSEC_PER_MSEC) {
> +		scrub_throttle_sleep(sctx, device, bwlimit, ahead);
> +		/* Woken by a limit change: the debt was accrued at the old limit. */
> +		if (READ_ONCE(device->scrub_speed_max) != bwlimit) {
> +			sctx->throttle_next = ktime_get();
>   			return;
> -
> -		/* We're over the limit, sleep until the rest of the slice */
> -		delta = ktime_ms_delta(sctx->throttle_deadline, now);
> -	} else {
> -		/* New request after deadline, start new epoch */
> -		delta = 0;
> +		}
>   	}
> -
> -	if (delta)
> -		scrub_throttle_sleep(sctx, ms_to_ktime(delta));
> -
> -	/* Next call will start the deadline period */
> -	sctx->throttle_deadline = 0;
> +	/* (bytes * (nsec / sec)) / (bytes / sec) ==> nsec */
> +	sctx->throttle_next = ktime_add_ns(sctx->throttle_next,
> +				div64_u64((u64)bio_size * NSEC_PER_SEC, bwlimit));
>   }
>   
>   /*
> diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
> index 89b0a4ef4063..4c7f486c2924 100644
> --- a/fs/btrfs/sysfs.c
> +++ b/fs/btrfs/sysfs.c
> @@ -1928,6 +1928,8 @@ static ssize_t btrfs_devinfo_scrub_speed_max_store(struct kobject *kobj,
>   	if (*endptr != 0)
>   		return -EINVAL;
>   	WRITE_ONCE(device->scrub_speed_max, limit);
> +	/* A throttled scrub sleeps on this under the old limit. */
> +	wake_up(&device->fs_info->scrub_pause_wait);
>   	return len;
>   }
>   BTRFS_ATTR_RW(devid, scrub_speed_max, btrfs_devinfo_scrub_speed_max_show,

