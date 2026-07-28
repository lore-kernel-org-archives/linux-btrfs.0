Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE48641F35D
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 09:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785230410; cv=none; b=A7mKCVHsHBSc5rqwKOxvUlZooVmXF5HscbFtbRk6nvOPJlZ1JAAggd8pduM/68Ld7G3q/9Z4Sv4sKEtCIeNXSNFlUWSa0sganjfv3x0UsH8dHqUaLKzv/J2rFaRtBB+jl+gRNLZIz466coNRQsHaQZkzIV2//GfEUj3TOz7kGNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785230410; c=relaxed/simple;
	bh=/skars76S/4PNdBawKN7KUZlVTQxFjBhor6301hxaeY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XuxQGIOUsvgEG8FM9cI4AZHim6shkwfFNqdi63RUOdLn+xmc+uXck+JAoPh7dxAHVHSylqldxBJq5eqQ8TMF0kUJEDenO1YweJV58+k5nAibPCOrGM+eTkW3XGB24ozrP2V7sdiwHgyCOzPh5PzbN2PQk4qh+MyfVbJRyQ3EhgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=H7UhwzQ2; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="H7UhwzQ2"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4955158f26aso23148445e9.3
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 02:20:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1785230407; x=1785835207; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ysum7WT4jQiE5UnnOJe7DgmKfAAjLTYmbrrDRNx1QvY=;
        b=H7UhwzQ2mXtZpLn9w1saYUBGL/8siRj5YMVsK6bNCJ7x7X5uETdfIdRBcJfWqk3cq0
         Cj8aIWZkXGW7ztIB2T3A8tDaiu9d1I8xFI7PkiqI1D62gy0pKOxHtflTdVVgEmZduwq3
         ABxdFhgVtdZweEyyhyg8L+A0ub9Ktn3DgJViOyKatj38T+Pi2jNK6T3x7vHw6XAw28EL
         6bzCBHawMphC6K8ynKynPiGxZDsGqrAISkHjxgLn6MllyD7ycxBPxUXX8S7hUWOwnI+r
         pJImOHJkIvsJ1w1IOHb3CndspHszftWx5Jef7WP8A9e2zwp3ZW00tMR9owfA0HtwiszH
         VcmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785230407; x=1785835207;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ysum7WT4jQiE5UnnOJe7DgmKfAAjLTYmbrrDRNx1QvY=;
        b=MV7N/g9GseHoSBcgyjiHJCXATRB53e1+6FlUmtjLpqQ5Yg6lgs/+Uy6XstZhfc8Obq
         eSrXX0A8IHYEwvX1NGIRJaU3cXJq0EK9uRuaTxjVmlEskWn285Y/h8AlrwgKLQxjuNKa
         p2Eo7t6TaulxCEk3Zgjlrf7RrC4gBKQRoQcF3yjem74W1bMb+URmT2eB+LXr1CXAeH3j
         vsXBfkElX9qFePn4RwBLvsHkXbmQEgEN/sg4l/IKZ1Qoqo5RC74E525r9kldyL+eMEFu
         xvZ0RYEML+2SdyP60jYDIhMBe4WLcInDCapVyB+OwOcbxUbw6XRB4WZvF0KQVPGfnYP3
         Pl4A==
X-Gm-Message-State: AOJu0YwG/5Jd+u8+pdaVKTt27nPX9lL8Ka7x/F7NBGVYHp9ND+KBTVyb
	wBBYg/ycPyhtc7arAk0T0IBTVyfI3/CHjsrfPKgd/dgtsh4xq2wUrHjtYRb5Jku8p1I=
X-Gm-Gg: AR+sD10x5CmnxRSLL9RjqUd1m12PcWujUvogH0weTzdOqx2ugyAS0FSZPSZm5TyXEQt
	xjRITrSVQoDJb6KxEayE5XaIwrWItNWvzaD/exWBtAzDXUNHcdB/NbEXBINjDceOIP5BQiSs2Cn
	loOIK3Phu1PLH/dnuvdynTnq3yW+Fcuu0xVb2ypBjzGcDe/8wn7XkAanhuZssGhl8sEHYiUbfbQ
	Xj2r40BJ6BsRNBX6I8Zrb+6b9qGjOkeUcG5vvl0pFJm6BfO9Cw0nibgOoD1k/TxtUGptcV6HJlK
	q5DeYUsenLZpgg2vFEAyio5Loxu6qfU20CxZRxBaBFZeg/emy+SYN0U6Qnuu6hLJE4url4CfjoX
	aQkcmwTJMr5qEsGPMieITDhomRbBsMtbQhO910Uue6HFOYFEsXnJIsEbJxCHLQz8/73yn9swLtO
	6Yi6KUOA==
X-Received: by 2002:a7b:c00b:0:b0:493:d741:5d72 with SMTP id 5b1f17b1804b1-496c65a5ab0mr11176455e9.38.1785230407084;
        Tue, 28 Jul 2026 02:20:07 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13e52f0c6f2sm35116038c88.11.2026.07.28.02.20.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jul 2026 02:20:06 -0700 (PDT)
Message-ID: <982bfba1-d2e6-45ee-9204-0029bd9daa8d@suse.com>
Date: Tue, 28 Jul 2026 18:50:01 +0930
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
 <9b591ffd-808f-45ac-8109-85de8ba2b798@suse.com>
 <CAPjX3FenCVAukra4Djz8r4ShRi4M6DxpHH5-Lm1XyrsahFn=nQ@mail.gmail.com>
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
In-Reply-To: <CAPjX3FenCVAukra4Djz8r4ShRi4M6DxpHH5-Lm1XyrsahFn=nQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/7/28 18:47, Daniel Vacek 写道:
> On Tue, 28 Jul 2026 at 10:40, Qu Wenruo <wqu@suse.com> wrote:
>> 在 2026/7/28 17:35, Daniel Vacek 写道:
>>> On Tue, 28 Jul 2026 at 08:46, Qu Wenruo <wqu@suse.com> wrote:
>>>> The @end parameter for all extent io tree helpers is inclusive, but
>>>> the call site in extent_fiemap() is passing exclusive end.
>>>>
>>>> Fix it to follow the common pattern.
>>>>
>>>> Fixes: ac3c0d36a2a2 ("btrfs: make fiemap more efficient and accurate reporting extent sharedness")
>>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>>> ---
>>>>    fs/btrfs/fiemap.c | 8 ++++----
>>>>    1 file changed, 4 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/fs/btrfs/fiemap.c b/fs/btrfs/fiemap.c
>>>> index ba6a360074c0..2f2ae0b76799 100644
>>>> --- a/fs/btrfs/fiemap.c
>>>> +++ b/fs/btrfs/fiemap.c
>>>> @@ -657,7 +657,7 @@ static int extent_fiemap(struct btrfs_inode *inode,
>>>>
>>>>    restart:
>>>>           range_start = round_down(start, sectorsize);
>>>> -       range_end = round_up(start + len, sectorsize);
>>>> +       range_end = round_up(start + len, sectorsize) - 1;
>>>>           prev_extent_end = range_start;
>>>>
>>>>           btrfs_lock_extent(&inode->io_tree, range_start, range_end, &cached_state);
>>>> @@ -710,7 +710,7 @@ static int extent_fiemap(struct btrfs_inode *inode,
>>>>
>>>>                   /* We have in implicit hole (NO_HOLES feature enabled). */
>>>>                   if (prev_extent_end < key.offset) {
>>>> -                       const u64 hole_end = min(key.offset, range_end) - 1;
>>>> +                       const u64 hole_end = min(key.offset - 1, range_end);
>>>>
>>>>                           ret = fiemap_process_hole(inode, fieinfo, &cache,
>>>>                                                     &delalloc_cached_state,
>>>> @@ -812,10 +812,10 @@ static int extent_fiemap(struct btrfs_inode *inode,
>>>>           if (!stopped && prev_extent_end < range_end) {
>>>>                   ret = fiemap_process_hole(inode, fieinfo, &cache,
>>>>                                             &delalloc_cached_state, backref_ctx,
>>>> -                                         0, 0, 0, prev_extent_end, range_end - 1);
>>>> +                                         0, 0, 0, prev_extent_end, range_end);
>>>>                   if (ret < 0)
>>>>                           goto out_unlock;
>>>> -               prev_extent_end = range_end;
>>>> +               prev_extent_end = range_end + 1;
>>>>           }
>>>>
>>>>           if (cache.cached && cache.offset + cache.len >= last_extent_end) {
>>>> --
>>>> 2.54.0
>>>
>>> I don't really get why you left out these:
>>>
>>> @@ -680,7 +680,7 @@ static int extent_fiemap(struct btrfs_inode *inode,
>>>                   goto check_eof_delalloc;
>>>           }
>>>
>>> -       while (prev_extent_end < range_end) {
>>> +       while (prev_extent_end <= range_end) {
>>>                   struct extent_buffer *leaf = path->nodes[0];
>>>                   struct btrfs_file_extent_item *ei;
>>>                   struct btrfs_key key;
>>> @@ -809,13 +809,13 @@ static int extent_fiemap(struct btrfs_inode *inode,
>>>           }
>>>
>>>    check_eof_delalloc:
>>> -       if (!stopped && prev_extent_end < range_end) {
>>> +       if (!stopped && prev_extent_end <= range_end) {
>>>                   ret = fiemap_process_hole(inode, fieinfo, &cache,
>>>                                             &delalloc_cached_state, backref_ctx,
>>>
>>> Am I missing something?
>>
>> Because we won't reach the == case at all.
>>
>> The start is always increased by a value aligned to sectorsize.
> 
> I understand round_down() possibly decreases not increases. So if
> start and start + len - 1 fall into the same block you get the ==
> case. Am I wrong?

The only case when that happen is when @len is 0, which is already 
rejected by fiemap_prep()

> 
>> For inclusive range_end, we either completely pass it by 1, or smaller
>> than it.
>>
>> So that "==" will never be hit.>
>>> --nX
>>

