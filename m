Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2929B36BCE8
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Apr 2026 09:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776938051; cv=none; b=u/dQ6fMelquz/KqnXqh0sUDscLmH1dwnJ4I2GgxCJNSISf7Fs+VcHYse/7ZMX1AvWN3nLWFx6PwW7+fux05/+iPxqRLFp++ol2CqolIpH5n9hJMkBj8axB7eijubKwaeqkQ6wij38y80qp85alxjRHHLu0Z3UN1Ahmod7V/NOxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776938051; c=relaxed/simple;
	bh=hkfotqZetcJgssegARbYJ86E9as4FtGdSZd3rZZ9tmg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mc6oT351muySkDNufiew+3GrV00GAVlqgNoeh7reoLCpczkJKXOcEkcr9THzMaAJSXfyBFgLt2vZDVVk+3bIWKdAaTCKZlQBw/PppWOXZBrB7sc14dF8w/oIlxqIfAC9bLNCa4Wxl3XpKHtcoJ0w78wvaxKmfTWWh/Si4gLBlcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=OYCN59lm; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="OYCN59lm"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-48374014a77so84213485e9.3
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Apr 2026 02:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776938048; x=1777542848; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=dBcNu+0Ohwo2vdMnJDleeINM98/Xh8aJHDLHos5QDQU=;
        b=OYCN59lmzjF4MByM9BCwLbZ+ag+hwBRQyeYkNg0uydiQpVLqU98+PAvsAeBWIeEfyi
         uyOKwwoJqxrdXWBMYKSV9u9VHJqCDkhedzTwqDzZD6LMlfasYp8rFvuoh2wyPgbQaYkp
         JcIqKqX5aVogOaM3Esx7O0hxqQTiamxNMLPULKVLut+Aw6Z5BGseh9EkXbt9HROqfkX2
         hxonNFLb7P+VpwXiXAqQUwKC5eyFcVazA6wIKxZZblMhqxLWFKG3HMLuhmna5rFF4chH
         tFwKzVx+xmobeZXpjk/FWgFDsxSFrp0NSwywlpDvqOdghmpwhqpOMkWIICJjwIHzbigi
         kjrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776938048; x=1777542848;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dBcNu+0Ohwo2vdMnJDleeINM98/Xh8aJHDLHos5QDQU=;
        b=CpPX1CheJX1pgV9hXOvYS3uWOB8X/BveAI8Nvu5p49FxrP20fBApl+IhKRZcrzIvZf
         jt3ciAGQzwFmKAAIguIpt+puQIGFEy1PCg5NoMqWW7u0E1Evtq9I/WwaKzHTSrD1KaWI
         Zc0CB6aAMirHgg7205t3+Usm4HsMpDH9/DMdzRLyWc/419QFh99Wj4cByzFq+s+UnUzb
         GI3DK2OvtFfL+zPw57AK8P3A2MeRsPw1DBhi+KNtO7BaO9N2lWPOAV1yQOb6PnS90HAh
         Pru30lwZUC56hkG18rzW8FKJe2cWKsJx49ZC/PTZIt0536aeF6IkKHTtpllOPAtvH40m
         Gx2A==
X-Gm-Message-State: AOJu0Ywh3pNAOrKDQm2EItrGN5nshPNm3wCC8huTVIjUtP7Ik9az/LTn
	Bc/jbDwI8SeaSY88XEQBIAsJSUohJJUYv/wBhWpMzjVX5yRwfeE1jzLvGsytws7B/p8=
X-Gm-Gg: AeBDievQnCzBCcmuPBvYSVwgGgKtQQoNAJkrWz1LsnjphOKiYWMCtyTZZMCdrEKzDzI
	ZKqOo7Fg6T/5Ci/tOzEzwZuKPg5W/FSt078HCpU95cjT3WHzXGly4fkFngHpoYzc7IgYQo1RwtV
	ptwZKSNkiQ6bi/wpdpWcRYsfdjD59Yc3UlQFUlAu1bCPTcmAMwzxl9bWKGlhlattCn3qp8jbZYh
	OAIJ5d06Rn7Dbbq2xpAkyGUTMstGntCRHzlCkgGs8Cf/WAaLvellzJl05Za4TX185xRAz9DukaG
	xWSgn4R2D1lXmJHcSNDAPJ3neM8w7FG2XeUfI3DXRFFU5kKlgIBNiT+jdMKJtHuHBIyTp2wZHGj
	p57gueMITzfzuZFqq6FWZ3nUoWDtmZrSz4eGuB403yayPayT6bdikufGBeFPhSrdzA2gUpHe/xF
	Cj4taGZjXjSIlZr3ARASDk5SNi8CT9w0vjs1qIRTWV50esB22dKM2ZtU5OV9eUmQ==
X-Received: by 2002:a05:600c:4714:b0:48a:5574:3a5b with SMTP id 5b1f17b1804b1-48a55743d05mr155997315e9.27.1776938048347;
        Thu, 23 Apr 2026 02:54:08 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f8e9fbb85sm23252669b3a.22.2026.04.23.02.54.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2026 02:54:07 -0700 (PDT)
Message-ID: <5e19c224-b007-43f9-aa73-3016b5e8ce2c@suse.com>
Date: Thu, 23 Apr 2026 19:24:02 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: Limit size of bios submitted from writeback
To: Jan Kara <jack@suse.cz>, David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
References: <20260423093052.13219-2-jack@suse.cz>
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
In-Reply-To: <20260423093052.13219-2-jack@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/4/23 19:00, Jan Kara 写道:
> Currently btrfs_writepages() just accumulates as large bio as possible
> (within writeback_control constraints) and then submits it. This can
> however lead to significant latency in writeback IO submission (I have
> observed tens of miliseconds) because the submitted bio easily has over
> hundred of megabytes. Consequently this leads to IO pipeline stalls and
> reduced throughput.
> 
> At the same time beyond certain size submitting so large bio provides
> diminishing returns because the bio is split by the block layer
> immediately anyway. So compute (estimate of) bio size beyond which we
> are unlikely to improve performance and just submit the bio for
> writeback once we accumulate that much to keep the IO pipeline busy.
> This improves writeback throughput for sequential writes by about 15% on
> the test machine I was using.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Looks great!

Reviewed-by: Qu Wenruo <wqu@suse.com>

Just one minor question inlined below.

[...]

> +int btrfs_init_writeback_bio_size(struct btrfs_fs_info *fs_info)
> +{
> +	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
> +	struct btrfs_device *device;
> +	u32 writeback_bio_size = fs_info->sectorsize;
> +
> +	mutex_lock(&fs_devices->device_list_mutex);
> +	/*
> +	 * Let's take maximum over optimal request sizes for all devices. For
> +	 * RAID profiles writeback will submit stripe (64k) sized bios anyway
> +	 * so our value doesn't matter and for simple profiles this is a good
> +	 * approximation of sensible IO chunking.
> +	 */
> +	list_for_each_entry(device, &fs_devices->devices, dev_list) {
> +		struct request_queue *queue;
> +		unsigned int io_opt;
> +
> +		queue = bdev_get_queue(device->bdev);
> +		io_opt = queue_io_opt(queue) ? :
> +				queue_max_sectors(queue) << SECTOR_SHIFT;
> +		writeback_bio_size = max(writeback_bio_size, io_opt);
> +	}
> +	mutex_unlock(&fs_devices->device_list_mutex);
> +
> +	fs_info->writeback_bio_size = writeback_bio_size;

With this simplified version of optimal io size detection, do we want to 
hook dev add/removal/replace to update the calculation?

I guess in the real world, the added/removed/replaced disks should have 
all the same performance parameter for server usages, so no difference 
there.

And for personal/pro users, I doubt if the original performance problem 
is even noticeable for most end users.

So overall I'm fine either way.

Thanks,
Qu
