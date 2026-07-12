Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38CF5377560
	for <linux-btrfs@vger.kernel.org>; Sun, 12 Jul 2026 22:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783894743; cv=none; b=brg7HTyaSf8/Zt335YEUjpEftQBqMBky2fzKGGElyqiiUNG3gPEq08o1nXr3JQzn41GCH0e4vxoPLL4s1HgKcDhdCwpmbqmJ3j6t+c5j6vFqISUlcJokRMiMJeneOZvuT2DezeLMMML4KaQ8eI8Sy4qsoKYfXhHKEkEBxyh8L64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783894743; c=relaxed/simple;
	bh=mbOUz78VaQz9qJemlNdHTyqvQ6vqcbcdTH23yH5Fk9w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qp8xbhiygkJXla/o1IG1SPkFTrSjxbq6Ri2ujeWT1+pme7m7fxKDB97XgD98hu/wyHkygUlWyLUG4xvZT9PDWXpz7YmHRUL51/yed6FSwhFmdu/IM4Jcc75RlgXxChKeh6ZtnCQSFJcOEmhwL5qnXsQ/QunVERPE5RHrHyvxwK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=KgJNaiJN; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="KgJNaiJN"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c15ba5b151dso333068566b.3
        for <linux-btrfs@vger.kernel.org>; Sun, 12 Jul 2026 15:19:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1783894739; x=1784499539; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6kYja02EzdT0qpx3q/1wcCKMYwfT7TZWXBTar/+e4mw=;
        b=KgJNaiJNamTFkU1y4ZYIhgS5kWKxNjbpKKox5UuBINJ4/0fyM1sFwxOQZPL4/IDhJW
         2INqWS23/jy0UZVfqSXKsF2ImGb7AlO+rv4gslZsfTlNsArwVR8jRWCQNk1HfDJ4/Vj4
         swgkfUmAQ1kh2JMRjZisWbT13zJa2WH9Hqn3uzO8IiwsqlotWKa9OXi0ohW44bfwg/Vn
         5R2vgtwqjL5MDUKSE74PYSGz6uF0nv6OE5USJJlIp2WtoQ4969Eec6WDWn3lIXQ7mw3B
         vqiAXGSg6KBvqt++b5fhuzyvlcn7GXoaIZ0y/v95nWwK6xYd4+MvyZ1pQ9dNWdI6/hgY
         Q6TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783894739; x=1784499539;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6kYja02EzdT0qpx3q/1wcCKMYwfT7TZWXBTar/+e4mw=;
        b=mBCrd5A0opcxH+zKX+8RvudF62oM4+0pAi4GC+peKz5vJWpM/sLzoHnTwqD5kB7mEq
         JiepKDFuaDfbx9Z8x7ktX8XOpTZ9ziVizVs8aEW2W9ksGBnsDn5jk+bHtOLsgzuEJUwq
         wh3LN888L02hoMELYFicQM0q14jCs9G6oddfzZusju3eqVHms/p2EwRuGuij8lePDe4q
         8AQRod/0hAoZxN642OFg4wM8v2yBW+74wRaky4tPwM3oWGKngmnfB3UJKpeIRhKf/B2x
         MpTUg3GwgeP506lDu2k6rAJe1Q7VG0G1s28aQJ2W0WrAUMMNhTVoXHXeq/QcR7wbo+Z4
         ttug==
X-Forwarded-Encrypted: i=1; AHgh+RoAntcjhJ7UsPVYO+3Ub4N/N48UmdCK21PuKn60FLpwQnNk1eWcn4FVQSAoL+5i6rwWVzY02mSS4GfeKA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzOxOs7yBWQHnc8S6mlEsXQSJLyyQf5rt6uxsanEtKwNKqaLmZZ
	w2NskjsMicUnQQ8vvvBI0dXZTflEnsAn0bLCuMnYCrfm/0O20Sm2qioFMraSFdTs/aQ=
X-Gm-Gg: AfdE7cmVugFsUKwRHq7ndZBNC55S1BbzCB4C2G8cGIrZgbY+30rsGhBibrDgs/amecV
	YbZM/dgd3wcMhhDp54kjAQJwyMRah1HzvR/52yl7b1mwRQ9YLpKrq5or2lbw3Gmu7qCq+GXWY1g
	G8ZL9B/wxhXX45Bn936eGTeoLc4WSMD8+sbovmLxRdZ7rUEIQZbvXl01VKbOvKqO7K1AzN61ylg
	csbOLwDADQHmOSfX7Vr5JIDNo/Yw+PjUKEata2mnwm2nR5JgWM2hLQZoOhwnD2D0ILz7xC1DxBL
	rcjWdXVSNk39ZZAf0tYi4SxUT/XbXUcGZUThj2b7o1X0T0pb/UxoqC/20CSSkTAAwtJgQN1BGH3
	8KAmo9u6mZCw7oeQSlpHaE3dqjg7nHw8oiTfQucIhk6w8oyv/aRKyH/ezL3L1XR0cURUhyVLQIQ
	J1b+mI4w==
X-Received: by 2002:a17:906:1389:b0:c12:81bd:c1fc with SMTP id a640c23a62f3a-c161f39d885mr225638366b.31.1783894739599;
        Sun, 12 Jul 2026 15:18:59 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8484123ce87sm7244873b3a.58.2026.07.12.15.18.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Jul 2026 15:18:58 -0700 (PDT)
Message-ID: <2490a56e-ad0b-43b7-8ef0-02dacbc10ecc@suse.com>
Date: Mon, 13 Jul 2026 07:48:53 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] btrfs: allow reflinks into NODATASUM files
To: Neal Gompa <neal@gompa.dev>, daan@amutable.com
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260712-reflink-into-nodatasum-v1-0-9f27ef836073@amutable.com>
 <CAEg-Je86cbtNvESfK5MeVXVezZfMFE8qVdX900F3ayQsC+yQNg@mail.gmail.com>
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
In-Reply-To: <CAEg-Je86cbtNvESfK5MeVXVezZfMFE8qVdX900F3ayQsC+yQNg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/7/13 00:36, Neal Gompa 写道:
> On Sun, Jul 12, 2026 at 10:25 AM Daan De Meyer via B4 Relay
> <devnull+daan.amutable.com@kernel.org> wrote:
>>
>> The primary use case for this series is building a NOCOW VM image from
>> individual partition images that are COW and checksummed. Today those
>> partitions cannot be cloned into the NODATACOW and NODATASUM destination,
>> so tools fall back to a full copy. This makes provisioning slower and
>> duplicates all of the image data up front.
>>
>> Allow cloning and deduplication from a checksummed file into a NODATASUM
>> file. The VM image can then share extents with the partition images.
>> Existing checksummed extents are COWed once when modified, protecting the
>> source checksums, while newly allocated extents use the destination's
>> normal NOCOW behavior.
>>
>> The reverse direction remains rejected because the destination would
>> expect checksums that do not exist.
>>
>> Patch 1 prevents swap activation from bypassing the COW protection when a
>> NODATASUM file references checksummed extents. Patch 2 relaxes the reflink
>> restriction in the safe direction.
>>
>> The xfstests branch is available at:
>> https://github.com/kdave/xfstests/pull/6
>>
>> Signed-off-by: Daan De Meyer <daan@amutable.com>
>> ---
>> Daan De Meyer (2):
>>        btrfs: reject swapfile activation if any extent has checksums
>>        btrfs: allow reflinking from checksummed files into nodatasum files
>>
>>   fs/btrfs/inode.c   | 29 +++++++++++++++++++++++++++++
>>   fs/btrfs/reflink.c | 18 ++++++++++++++----
>>   2 files changed, 43 insertions(+), 4 deletions(-)
>> ---
>> base-commit: cab9e339cfbc1a4e075e53e281dfb00391e1a6bb
>> change-id: 20260712-reflink-into-nodatasum-aff962f3794e
>>
> 
> The patch series looks good to me.
> 
> Reviewed-by: Neal Gompa <neal@gompa.dev>

I appreciate your feedback as an end user/sys admin, but I doubt if you 
really understand the requirement or tried the patch by yourself.

I'd appreciate if you put more weight behind your reviewed-by tags.

> 
> That said, I have a question: Is there no reason we couldn't reflink
> into a checksummed area and generate *new* checksums for that purpose?
> That would be useful for staging for regular backup.

Because btrfs' NODATASUM/NODATACOW flag is per-inode, as that's the only 
way we can store that flag.

If you really want proper per-extent NODATASUM/NODATACOW, there will 
need a huge change in the on-disk format, e.g. introducing new flags 
into btrfs_file_extent_item, and do the extra work handling corner cases 
like preallocation.

It's definitely not as simple two small patches.

> 
> I can foresee that being useful for archiving OS trees or VM images as
> snapshots by creating checksums for the newly created snapshots...

Nope, one should not combine VM images with snapshots on btrfs.

Even if we have fixed all the direct IO problems, the extent bookend 
will waste a lot of space.

> 
> 
> 
> --
> 真実はいつも一つ！/ Always, there's only one truth!
> 

