Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034233;
	b=bR4EDGh7hzTrYr3j/FY4ijcyphz0rJXq2Iy0Pm43EjdqswMZcymFB+Uq4P8wYB+hdJUa
	 0s2dThnIo+bTjYMQTYyOkL6fGXgVs4vYQ1i4lYP30fWsmhMYQf2kgqp6Bsv7zi1OUZxSr
	 5xSsnE1go87RVwUbSu2s9SnUakaCHQeXy0SxlAS7jiPOlAyCjLk1fVm4zalGLU0R94O2l
	 kuN5P4WlbjuaZThw+b5nAtUZBsz4vk8F7u14AxXWdDyjTIuQbLsWS7v2Jx4CIWgk3Bg/O
	 RwJz+A0qrbqmQu3xb81bDzP3BEv6Syc9XK5YcQ64FrMqdjJ3FqOsv/y2Q2dc0v9PXSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034233;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=AXj5XAIXyOPZnH0h1yeuXtufzs9FJkS5FqXFYfO/IRM=;
	b=lHi26vl6RVIkF/jN7JNEBa5g2wjf5QB/Zv5MUax1oepz9Jqxh0SBHODx65wunrlV4ntH
	 ZrOty8tuoNIbnq0hkk+1rB/bqBrWJg8O/BHtTHpbyKBXbVwyMgtia1nydZFhTVGO+0pSs
	 g2icT86B3axvHwRt1TuFtY7gdNFq492HuO+1dl1u1EBgfkG6CdrQ4MT5JMlk7tKu4xEv+
	 A5257aCojZyMynlYNHcuF4jzwmxfgqp1XzYGwb4GwhLD4EpIbpcXdOskIJkFt96GT4egZ
	 41CGL0hZASzNoNfZJvapfjCxoZnxLQZXWSMrhL5i0+E2RZJGICu/cMwM27jRm+XHg/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=dsAQiv1E;
	arc=none smtp.remote-ip=209.85.218.53
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C25C3606A331
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Nov 2026 20:37:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C25C3606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=dsAQiv1E
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c505186727fso218630366b.3
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Nov 2026 12:37:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795034231; x=1795639031; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AXj5XAIXyOPZnH0h1yeuXtufzs9FJkS5FqXFYfO/IRM=;
        b=dsAQiv1Eftk7IJH1p/el8h1FglAzkeKj832z7mjHYk7TVaUsh6k9F9zDbW7kDbgpHm
         NhoIMwsEHAtIPBFLrxhC2KeFQRsRihSRB17MEEkxyuUzbiOMZyIFDU8R7AEx9u0Xx2+0
         8/LlxgHDt+2Xbqm53FbJbukv5V0bv1ovDNPKWvTVFJJQGnp4J4WfayEJAVtFhANvyv6N
         KKV9XT0RKxiRux42ZyBRt9c/stQ0CwiJsZWdQ9qyPFD2L8bcwnZuWeIDdVa+kqddBzo+
         92UWyjwhmPb/eAO2Avjz0I5C/go7CFtqIbf8mRDGt/e0/Boboz+YZwXxYgrF2LecnGoD
         Q/Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795034231; x=1795639031;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AXj5XAIXyOPZnH0h1yeuXtufzs9FJkS5FqXFYfO/IRM=;
        b=DR63iYhfF0nEuUs9kClPJYSC81N1irc6QEsbVOWC6w2K/FBasGEwNjiehzDADIXiKn
         8JO7OTju2KCM023TRKf6ET835dXxQOlWIjGDUubnz1yorm9Mye3+Jq123kBz8KvF2ol2
         hGRWOCmHRZTRM5kz/x/uARQE2rw6+BMHNevSax2OIjUiDzktKBCH4JAQnwBOokkXiYKi
         Cs0wVukOqiAyon85nCcRee+dBXar9F6C0Lg8r+14PxXlt+HAZy2pHDZb6IcB2DMyYbnu
         rhOz9trLL/y7jPhuIxIUfCPogrc5esRJUTBZpsVXhRIkR3oSOGDDx7vpYV8PMGXoP9Qg
         PVIg==
X-Forwarded-Encrypted: i=1; AL+hErEExWd/BKteeaJGG0MX8kC1as41vHAUaxrhNQ29xtKHXJIXEvoI0hukFmeMG8uQNJrbYCGw2oCgnm8/cw==@vger.kernel.org
X-Gm-Message-State: APuU4Z/aCDWE8u7YXz1th3IGbyxKL9SuxkckfLpUQWlFVxZq3LB6Hp1g
	ZZAaj94Vzcag27bwxw/Jsi5cETz5he3bm1SYZO+IJdEfVgGvKKlkKvipJXgLn3ID1v0=
X-Gm-Gg: AYBFou3zrXvgAdrptPYOnkMa0i3HxQam7NP18ghtHTUVPlGExbLqP4zWDy3LA0M2c5A
	0zoOWQId8sDBqLvhcUJpor5+vBiaJK0NqqsnfeL+0DZi0wjjdyV2jXqv13eb1gs6iotxdq3++YL
	o1mGNp0qJjXBvIbc2FR9+znEyRqAAYNrDDK/QeAYUjnZ+ed8mB4EKMCMQTKeZUN2ZiaVmJLR83m
	Jz78ez1X+LNI0MAOyrK2l4SjxFIjIwi9q5RxSUpNarifogSSAQto0RJvmZPu97RZ1JTjbGg/fHy
	Dt7KwA1Eev52U9QHhOT+jvm/9b5r1RPU14GGrbAjzJF377Bhc3nDGO8ugtXev6yb8ALFqcV7c5t
	tGS6K7qrZSYWrPT5notoqvIMnrlkeeB/a2mte4byn2KSACM+wHzc5LLYQyaGxR15N/lrpMrpTVM
	RlJgDdwypkX5R5DsAS4XS2Eeoz9yr79RY27+ucAIPC5JqaoD4QRgou2GuMP0jSOql6QFEDrfVmW
	3yJb/FMzPZ0Knot8vqjYj/QDpBLiQGcI9mfwoIM9eSeo1QjMXIIUcKV6zq1EZaHC4baEdRk49QJ
	Lpct0oi8Wi7k5sJXqzlakg==
X-Received: by 2002:a17:907:7b93:b0:c46:a5bb:5740 with SMTP id a640c23a62f3a-c510deb706emr381419266b.5.1795034231032;
        Wed, 18 Nov 2026 12:37:11 -0800 (PST)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3d56ec725sm2566470a91.4.2026.11.18.12.37.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2026 12:37:09 -0800 (PST)
Message-ID: <ee3cc2d0-6991-4d7a-bbd6-a84972d44b37@suse.com>
Date: Thu, 19 Nov 2026 07:07:04 +1030
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
Subject: Re: [PATCH] btrfs: scrub: don't count zoned repairs as corrected on a
 degraded mount
To: Miroslav Cimerman <mc@raidlab.org>, linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
 Naohiro Aota <naohiro.aota@wdc.com>,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>, linux-kernel@vger.kernel.org
References: <20261118175637.60283-1-mc@raidlab.org>
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
In-Reply-To: <20261118175637.60283-1-mc@raidlab.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/11/19 04:26, Miroslav Cimerman 写道:
> On zoned devices scrub can't rewrite a bad copy in place. It calls
> btrfs_repair_one_zone() to relocate the block group instead, and counts
> the repaired blocks as corrected.
> 
> On a degraded mount btrfs_repair_one_zone() relocates nothing ("Do not
> attempt to repair in degraded state"),

I think this is a little weird, any special reason for this in the first 
place?

> but scrub still counts the
> blocks as corrected and logs "fixed up error" for each. The bad copies
> stay, and the next scrub finds and "fixes" the same errors again. With
> zoned RAID1 mounted -o degraded with both devices present and read
> errors in one device's metadata zone, two scrubs in a row both report:
> 
>    Error summary:    read=96
>      Corrected:      36
>      Uncorrectable:  60
> 
> Count such errors as uncorrectable, which the uapi header defines as
> "no intact copy was found or the writeback failed". Dev-replace, which
> writes the repaired blocks to the target device, and read-only scrub
> are not changed.
> 
> Fixes: 54765392a1b9 ("btrfs: scrub: introduce helper to queue a stripe for scrub")

I do not think this is the correct fixes tag, that commit is just 
calling btrfs_repair_one_zone(), and btrfs is already calling that before.

> Signed-off-by: Miroslav Cimerman <mc@raidlab.org>
> ---
> Keeping these errors as corrected and only logging that the repair was
> skipped would leave a false positive: the counters would still report
> the bad copies as fixed, and the next scrub finds them again. A new
> counter for errors with an intact copy that were not written back would
> be another option, but it changes the uapi. A read-only scrub, which
> also counts errors with an intact copy as corrected without writing
> anything, is not changed here.
> 
> Found with FuzzyRAID, a fault-injection tester for RAID that is not
> public at the moment. The analysis, the fix and the commit message
> were prepared with the help of an LLM, which also tested it. I reviewed
> everything.
> 
> It also applies on top of "btrfs: scrub: fix several races which can
> lead to UAF" (v2), with offsets.
> 
>   fs/btrfs/scrub.c | 22 +++++++++++++++++++++-
>   1 file changed, 21 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index 98362c91bce4..9dcb0e7e3d0b 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -323,6 +323,12 @@ struct scrub_error_records {
>   	 */
>   	unsigned long init_error_bitmap;
>   
> +	/*
> +	 * Set if the repaired blocks could not be written back, thus all the
> +	 * initial errors are still on disk.
> +	 */
> +	bool repair_skipped;
> +
>   	unsigned int nr_io_errors;
>   	unsigned int nr_csum_errors;
>   	unsigned int nr_meta_errors;
> @@ -992,7 +998,7 @@ static void scrub_stripe_report_errors(struct scrub_ctx *sctx,
>   	struct btrfs_fs_info *fs_info = sctx->fs_info;
>   	struct btrfs_device *dev = NULL;
>   	const unsigned long extent_bitmap = scrub_bitmap_read_has_extent(stripe);
> -	const unsigned long error_bitmap = scrub_bitmap_read_error(stripe);
> +	unsigned long error_bitmap = scrub_bitmap_read_error(stripe);
>   	u64 physical = 0;
>   	int nr_data_sectors = 0;
>   	int nr_meta_sectors = 0;
> @@ -1003,6 +1009,11 @@ static void scrub_stripe_report_errors(struct scrub_ctx *sctx,
>   	if (test_bit(SCRUB_STRIPE_FLAG_NO_REPORT, &stripe->state))
>   		return;
>   
> +	/* Not written back, the repaired blocks are still bad on disk. */
> +	if (errors->repair_skipped)
> +		bitmap_or(&error_bitmap, &error_bitmap,
> +			  &errors->init_error_bitmap, stripe->nr_sectors);
> +
>   	/*
>   	 * Init needed infos for error reporting.
>   	 *
> @@ -1227,6 +1238,15 @@ static void scrub_stripe_read_repair_worker(struct work_struct *work)
>   	if (!sctx->readonly && !bitmap_empty(&repaired, stripe->nr_sectors)) {
>   		if (btrfs_is_zoned(fs_info)) {
>   			btrfs_repair_one_zone(fs_info, sctx->stripes[0].bg->start);
> +			/*
> +			 * On a degraded mount btrfs_repair_one_zone() does not
> +			 * relocate the block group and the bad copies stay,
> +			 * unless dev-replace writes the repaired blocks to the
> +			 * target device.
> +			 */
> +			if (btrfs_test_opt(fs_info, DEGRADED) &&
> +			    !sctx->is_dev_replace)
> +				errors.repair_skipped = true;
>   		} else {
>   			scrub_write_sectors(sctx, stripe, repaired, false);
>   			wait_scrub_stripe_io(stripe);

