Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F17C3FF883
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 08:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785228053; cv=none; b=tgZEKtdnhOuPEICZAZKjeK96t4Xwqho9msZHDeI6gkB4Pc4SMUaQL2O8F9nOHkKji0Z4iLtObxRkt2WhxPe/26zpZY/oOHKy4SX5oqcdc3oLClILE/Xng+5TLpCrS+ZX20f4pvQO6IhEuj9Xarv5wtu0PCtQwEF86CpP0murWws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785228053; c=relaxed/simple;
	bh=DZo3t/w3u8HCdUZWTHhEJBDDbzM3+1lw3BS9jKjQXS4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u/EWsYkm/5lAQjgRGQBwEdwVyuv/lNUdaqoBzZuTSFLF4k/m4U5k9M1cFS0aevEsg3gf5/HhcPElaDG4izKPct2N4b+wMRxu1wdnz5c9Q1RVlOnU6JCMCX/+jJwkQcOaDviZynYGEA5H39rk0GuA99avZ7dpaDv3W/B6XThC6U0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ahp1E/1h; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ahp1E/1h"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c15ba3a2b4bso430261166b.1
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 01:40:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1785228049; x=1785832849; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GsKiS8Jtp3dg3HkB10N/jZxFWzwlDIMIBD4i7IWQtds=;
        b=ahp1E/1hy13eKbQ1bIZPxZNn5vwzvFwhhvxuyIChFCNDrEVo6GYtCkKytgcs4rnFdf
         UQ5VkFftXQuvs2WqJ4LJAH4LQI+oQqAXWHgmSTsk2fGEVCNOi/V8Pf0kAudQJ0MVSUDO
         cxZ3Y5LUIlwl0VwOQUqP53gArl/YWP8iqd4ukQQ5pF7z+qKp2avevudlJCR8zIPONacW
         2+kN2qvkuZ7+4fFPLWl5J1VHg0vwRPKdjXwYLjp33oPXBUVgkt7Ks6/LTTZJHWf/fOev
         Xg15R6ziyAfYNrapzvrrQ/jH/lc5NOGen6UstoQ3NoyGeTSx3muYDF6NHq+XeU/o7z4I
         W7wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785228049; x=1785832849;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GsKiS8Jtp3dg3HkB10N/jZxFWzwlDIMIBD4i7IWQtds=;
        b=T/Sh8/LDw4torh2m/DSEdrWPTdReWmDV6kDdckzCzCVooAFr8yq0LxXK9t27UtVEBG
         unFoCTE+GFXq9x9zg8UNYpA5aLccQI071rWU9DheenZ721+WhB5pb7NQZGlyzNrooMjs
         WT1A/nx3aR7peU1t4y6JF0urAdCMCkoIa+1jmaq866k78hf/chnjRiACfwiuv8xjlmfo
         FSQ1zKQ2jruYMr/B+Tw7er2LP5WAt1CwCyONBorqgWO2YaWTL6ULMBBkyDwggmvx55R9
         xiNZH8Nn3TgB0kE5LmLE+9GR4vgD2h4gAXu6HnaeQwp+ooNqFeTXJCY9Yv7oBqWcAD0b
         XLjg==
X-Gm-Message-State: AOJu0YwQvxfXiRlIPx2greE0pgpmaStyjPoktBzpZEZSyV2IzooeyiFP
	hUZ1zTVfygODwZ0wYVGWPbz/AFtFCgQAlm2npDD/ClioQgggk5vLl4mIx9NnguybeI4=
X-Gm-Gg: AR+sD13Zk/UOsco0LxR9YP+LHxvnCA/5s8/Cudq0DUKK5eSlLB3g9TrAJxV9UMVHMH0
	stbbN2fCfLbRNcWuYTE7PwKYJVZGM2xC9Tkd56Wg0gmIzrsRymrlL4Wpdi+NnbeluWel8zpb2p6
	GOe41MfcEysv+YdNFEtkSx2qODIbJhBdLjtptTu+eS2f0fUAm62UW62jd/B4M2zPRXxtn/rUFPb
	YGGkDnylzy3ihphQ02DaBYgrhsTG2vbK+OTbmu6VXHZ1CsjBpPZ4NhyE8P3rOPKv/RM5N0c0L+W
	flWz+qTUgDtPYZA6m2QSd/dOXg2ef2FSda1IRIowO6RsexQtlorbIlaHd/BunzUl1Sq0eb2E/cy
	Q31p4498rPQmGpauLTK3D5wHnTL37N0TBpKpYrbzqsKqrIq8NRwkmRQDLFhYFeSv00u06wB3fk1
	TPEBb4rA==
X-Received: by 2002:a17:907:3e95:b0:c15:9350:dfa6 with SMTP id a640c23a62f3a-c1f72195c9fmr81105466b.60.1785228048605;
        Tue, 28 Jul 2026 01:40:48 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cfde7bc4f4sm48154485ad.39.2026.07.28.01.40.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jul 2026 01:40:47 -0700 (PDT)
Message-ID: <9b591ffd-808f-45ac-8109-85de8ba2b798@suse.com>
Date: Tue, 28 Jul 2026 18:10:41 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] btrfs: use proper inclusive end in extent_fiemap()
To: Daniel Vacek <neelx@suse.com>
Cc: linux-btrfs@vger.kernel.org
References: <cover.1785220613.git.wqu@suse.com>
 <44822c23fc6764aa93a855648a1533a5faf4925c.1785220613.git.wqu@suse.com>
 <CAPjX3Fez2At9ZX1ga3YJt-rs+TGcXsV8WfJLXcmr64-4gjVQnQ@mail.gmail.com>
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
In-Reply-To: <CAPjX3Fez2At9ZX1ga3YJt-rs+TGcXsV8WfJLXcmr64-4gjVQnQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/7/28 17:35, Daniel Vacek 写道:
> On Tue, 28 Jul 2026 at 08:46, Qu Wenruo <wqu@suse.com> wrote:
>> The @end parameter for all extent io tree helpers is inclusive, but
>> the call site in extent_fiemap() is passing exclusive end.
>>
>> Fix it to follow the common pattern.
>>
>> Fixes: ac3c0d36a2a2 ("btrfs: make fiemap more efficient and accurate reporting extent sharedness")
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>   fs/btrfs/fiemap.c | 8 ++++----
>>   1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/btrfs/fiemap.c b/fs/btrfs/fiemap.c
>> index ba6a360074c0..2f2ae0b76799 100644
>> --- a/fs/btrfs/fiemap.c
>> +++ b/fs/btrfs/fiemap.c
>> @@ -657,7 +657,7 @@ static int extent_fiemap(struct btrfs_inode *inode,
>>
>>   restart:
>>          range_start = round_down(start, sectorsize);
>> -       range_end = round_up(start + len, sectorsize);
>> +       range_end = round_up(start + len, sectorsize) - 1;
>>          prev_extent_end = range_start;
>>
>>          btrfs_lock_extent(&inode->io_tree, range_start, range_end, &cached_state);
>> @@ -710,7 +710,7 @@ static int extent_fiemap(struct btrfs_inode *inode,
>>
>>                  /* We have in implicit hole (NO_HOLES feature enabled). */
>>                  if (prev_extent_end < key.offset) {
>> -                       const u64 hole_end = min(key.offset, range_end) - 1;
>> +                       const u64 hole_end = min(key.offset - 1, range_end);
>>
>>                          ret = fiemap_process_hole(inode, fieinfo, &cache,
>>                                                    &delalloc_cached_state,
>> @@ -812,10 +812,10 @@ static int extent_fiemap(struct btrfs_inode *inode,
>>          if (!stopped && prev_extent_end < range_end) {
>>                  ret = fiemap_process_hole(inode, fieinfo, &cache,
>>                                            &delalloc_cached_state, backref_ctx,
>> -                                         0, 0, 0, prev_extent_end, range_end - 1);
>> +                                         0, 0, 0, prev_extent_end, range_end);
>>                  if (ret < 0)
>>                          goto out_unlock;
>> -               prev_extent_end = range_end;
>> +               prev_extent_end = range_end + 1;
>>          }
>>
>>          if (cache.cached && cache.offset + cache.len >= last_extent_end) {
>> --
>> 2.54.0
> 
> I don't really get why you left out these:
> 
> @@ -680,7 +680,7 @@ static int extent_fiemap(struct btrfs_inode *inode,
>                  goto check_eof_delalloc;
>          }
> 
> -       while (prev_extent_end < range_end) {
> +       while (prev_extent_end <= range_end) {
>                  struct extent_buffer *leaf = path->nodes[0];
>                  struct btrfs_file_extent_item *ei;
>                  struct btrfs_key key;
> @@ -809,13 +809,13 @@ static int extent_fiemap(struct btrfs_inode *inode,
>          }
> 
>   check_eof_delalloc:
> -       if (!stopped && prev_extent_end < range_end) {
> +       if (!stopped && prev_extent_end <= range_end) {
>                  ret = fiemap_process_hole(inode, fieinfo, &cache,
>                                            &delalloc_cached_state, backref_ctx,
> 
> Am I missing something?

Because we won't reach the == case at all.

The start is always increased by a value aligned to sectorsize.

For inclusive range_end, we either completely pass it by 1, or smaller 
than it.

So that "==" will never be hit.>
> --nX

