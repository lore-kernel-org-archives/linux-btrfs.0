Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE96E2F8EBC
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 09:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785231713; cv=none; b=lOF3akiFAdl3zHVubaep+5s1YFUgAf8W7ILJakZOz47DSPDAIJJAoDQP3BuofQCa2Jtu5HPKA1912mVwh0x3XwQTJMAAlRzJ8g4VGIYWO9IGTf4wJW4kt5d4n+ylmExNc6XkV4uSLA0apojsLsNk76iz6JcQLUqdZHPLAWk4UQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785231713; c=relaxed/simple;
	bh=E1gHsBenYk0SN3y0PtZGk7S0BYZhbiOgLwCumYWytds=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Kax6bjgAccklccBEQdLn4VqkDPxq7+LMq5SNeszdcA2JxZ7bC+fLcrBJyylSXKtAX3zf0wL2cwnQ9bUn7Vj3NlUk6BYnrHzbkkYya56GYtQo/H7dar1iTGLzzxIibCXVL+CbnvZLmPddo7Y5mBtWb7IcdYyAuMaepuUCXW2qM4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gxkScpM/; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gxkScpM/"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-496b7622a83so18457015e9.2
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 02:41:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1785231710; x=1785836510; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=URTlENuNpgSIwexqspsR0iVJ8bemWUl715tCG0Sb49g=;
        b=gxkScpM/olKA+yldQ1lkPqDBTzFDjV1BVTXVjqUKzfpgZieP+4ZWaw4W3/PTLh9Bep
         ySUkr5mlht9U+fTetKqG3lHutqKUzfOCIaIXSgg80Towv+wvIHgiHMg4PWVaS7IP+Cgr
         AY1QWWSebwQRirjZigROcpSJWKsixszzcFXGRoGZor1CuKZaoIYp34G0CTg5n46GNGeP
         VoH6teEF9l+xdRGa9D9RlX3dxStIau1F7cU8zriRQ60o2dYylh2JohcCXNJ2rJJxUcyk
         0rG0/ETQBg369YaPsnmY9L0K/6+b+NQktSxz/q1G27jFjKe2csGR57NreD2xbhpPjlTY
         YRuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785231710; x=1785836510;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=URTlENuNpgSIwexqspsR0iVJ8bemWUl715tCG0Sb49g=;
        b=sh0+YI41lx4NGVJlpuauP0de3WNxuWf9/9A2+I1hZt66eRuEqK+OATMuvxJ1MoHU78
         /FO3U2OsVLUu0YzPQF3r5LoulXBATb8mOEyoSVH/Ksp6v5Fuu20CPZNFg9qjs7HoGPfD
         XxSLHF9YMillm19ZbvuEtPMnb8VBVkX88LbNrtVpKuJt4D2rRCkk4OIDlg6zPMeK+g1E
         shNfMH+qgAx4EspbfdBRXfs2oG1gTtTKCc6ts6U1H4jOW6BL2q0mSRGmuCzyqQ5ZRkrK
         fqNRWsVLqmajxLTpFA2BX6pqnh0KlSX2rOnKSJa4woDen0qRRFBjT0FCK9kU4pBlST/M
         dk6g==
X-Gm-Message-State: AOJu0YxkuAn4lYu5BczEo0kFpa9mzYFF33WRF/Qw+M9wDx7gbraKfiua
	Cn/2BWPiKLZhUU6YG3WE/F6r/trRFN1cgN7QChq8KCFva+nyE5d8JE3mVawHcmvpj48GvqqFGTm
	lNNT7cuM5Zg==
X-Gm-Gg: AR+sD10u8eI/+6FNK4F1WMLBNT3m589RUFpfkFcadmxa68e5WVzRUuWNr4h4W2M8BJY
	KH9+/yzCKFfgDw11IF7sk9usy7ufs61dNvIqQUHa812z3edvYj1l3zg/i+WywzlYRd2E200CoJr
	EvhvDvCs3SuohL5YVGxAIk913D1M+zBsa6W/Elw/Hr8I32IWX95NkodaJ6113U7UXg1/wJp1Bip
	NvYzkpG37uqD0df7m1TnRoXqTlJ0lhyIme5OuSbZsbnd1t/G9itwzCMIqKVTkBsCdZL3EGQr9Mj
	s+eFn0S5lftL0D6zdm6sqRdDa4P7yBVm5PynK6/FFMdVxAg6o/9tFPNrO7tJ3XLkZZ6Tmzo/EKn
	g26S3bP39lpLYh0RocuhY5kp/t5fS+kkkiOohwafD2j8IiylozkTK2lR4s9bqdwBBCsPkVb8=
X-Received: by 2002:a05:600c:3f16:b0:495:607e:5ee7 with SMTP id 5b1f17b1804b1-496c6435aeamr16043475e9.17.1785231709836;
        Tue, 28 Jul 2026 02:41:49 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-314bc5a04b2sm38616476eec.28.2026.07.28.02.41.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jul 2026 02:41:48 -0700 (PDT)
Message-ID: <e222a1c1-0d48-45b1-993c-f7d889ac49fa@suse.com>
Date: Tue, 28 Jul 2026 19:11:45 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] btrfs: use aligned range for locking in
 extent_fiemap()
To: Filipe Manana <fdmanana@kernel.org>
Cc: linux-btrfs@vger.kernel.org
References: <cover.1785229591.git.wqu@suse.com>
 <f5f77acc88e5ca314e4b41733a3c60e691fb6aaf.1785229591.git.wqu@suse.com>
 <CAL3q7H4Tqtt2pDmRWrLbmHeW7oPJfqNoJz28x6aAy4uAHX-FSQ@mail.gmail.com>
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
In-Reply-To: <CAL3q7H4Tqtt2pDmRWrLbmHeW7oPJfqNoJz28x6aAy4uAHX-FSQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/7/28 19:08, Filipe Manana 写道:
> On Tue, Jul 28, 2026 at 10:23 AM Qu Wenruo <wqu@suse.com> wrote:
>>
>> The @end parameter for all extent io tree helpers is inclusive, but
>> the call site in extent_fiemap() is passing an exclusive end into
>> btrfs_lock_extent(), which will step into the next block unexpectedly.
>>
>> Fix @range_end to be inclusive, so that btrfs_lock_extent() and
>> btrfs_unlock_extent() will lock/unlock the correct aligned range.
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
> 
> If the problem is passing an exclusive end to btrfs_lock_extent(),
> then rather than doing all these changes to this variables, which is
> error prone since they are used in several places and generally we use
> exclusive ends everywhere, I'd prefer to simply change the call to
> btrfs_lock_extent() and btrfs_unlock_extent() to receive 'range_end -
> 1'. That also makes the fix much clearer.

Thanks for the advice, indeed that is much safer.

Thanks,
Qu>
> Thanks.
> 
>>          }
>>
>>          if (cache.cached && cache.offset + cache.len >= last_extent_end) {
>> --
>> 2.54.0
>>
>>

