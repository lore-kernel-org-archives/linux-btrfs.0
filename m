Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D84C0315793
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Jun 2026 22:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782427147; cv=none; b=cwttqaI2npXqYUr0mog5lUu57oLyBCs8JZlaFKqndy1iuOVyaxRLNHWx0DV8/TfvX1HrjQMTihyp8ocuayXqSrWUN0SRuXYvzwAenyEHw3u4F5sbtoFNRqOEYOD47X7X65KFzwyYb4Hnwq40r6854M+rReDpYMQ9xrxB9Bk1LrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782427147; c=relaxed/simple;
	bh=2l1/Mw0G2lzKYbCYXP3fHBo99ZiVkqJQ5vQrblpqbL8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ENRugTmweL8kqmKEFTWmoIDa4z3ZwDZA7GtG1Mg8tHNgad0iR6XGvjKro2S6OZS13QMzGG6vkRRBauBatPM5ee6+o/8jFIAAsWRY+fCP8VI7xeTs3U4MP+CGDjdaP2um2rCr8wvxi2RgRVTciDi5eJPTXxLl9Xx6Ze40jXjmNo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=JmDla6s1; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="JmDla6s1"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-49222fb062bso3748605e9.1
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Jun 2026 15:39:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1782427144; x=1783031944; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=+9JEnnGCHdnIfJ+wgwYY9HVuJiRlA62x5fBvdyUtXvk=;
        b=JmDla6s1IXe1qXg1pnXcbjHg6mPaSnw8ff+4INnQscyEjx0EikJoVlorCS0ngxFLY2
         IMNvBtKj28K370U1YkwJrisN3GWii90JTPRLM1eyIC1gIUqR+vkLRx3x0Ch6SSWy9cH8
         pGH3w4DcMaitnJBUFgHUajwy5xwKFAbQOqHlenm2yePS7n1j78cYlR2JduQ/MsvrTQaj
         OqbCO1ksNSETJSkvDu8Fo6kqJ1TnTQqp5bd1WblnRS7WRpXg9H7nGYetiMo0bZaL8jgx
         k49ccQ0K2+JNaqiH6/txUhAboxJIjjYai6hUhbsbcGnexRjSXN4egwwDAZ2dScaS7+Dy
         ChkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782427144; x=1783031944;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+9JEnnGCHdnIfJ+wgwYY9HVuJiRlA62x5fBvdyUtXvk=;
        b=dJUzr2P6//LievRO3EC/JQ3CpjBQaBL0HXCuqPfcLGrCys4VhHFLY8lkZH1m26kNqa
         FoDKjSB4HytPZxAJUoq504uVj6C0kufoR23kXaegcraTH1lZ8ghizijisGABCXHTRTlC
         abU8r27R1Em4Zu3FT0MNpPssKpiEha95kc+yzPgbjNO/61MLT+0Q53e3j0PaGi/UDF+t
         DXNjT5/3daPmHS7z1gZSqZmJr8uYIZg7SUXXorvRS5M4heX0MbudkEd63H6UYG2miha1
         PlOOcSqJkvXsiVBGHD7AEVDRfgq5bWJIHWgJMRoqJfPHUUj47M22GPAvSbWTorF9ApBJ
         A2+w==
X-Gm-Message-State: AOJu0YzBtIhLdSoIaeYN6bU+MKShM9V0Iyud9eU0UiZ/80nqETLn0Knd
	/GyUxQEmPcjU6sCZxWLGDey4TUaPwy2/4Irja/tnm8Ov9hHrraW4Cvurr8OtX7g6CeeEcFN0q/u
	tSirRclo=
X-Gm-Gg: AfdE7cl19kssFOq6qTorqu4yXvrRBy1H9D6lrlb39ZFvjrDOFzkHIACXNeWi8VB/F6S
	ZBqq0RYuy5glxV9z4Z928bAPcZ055ns2Kb5q/rVZZBmSMoVlgGQ9SPudkw3XWOen7Mjr4ccepfi
	UpAX5KudRjCEFVCJjtQPkyj+xhFRChb/5Py/h2NrhrZLZT1fgk9X1EW8nM4/1B03tBqWF5R9eIt
	LjAoEnyXd7iHhHtsQUxrWOEnjqV3lTXRwDGqNQOz2uE7/wco8pdxlCFJLQhraU6w6wJ1rLg8OHp
	Kw9nxbCZJagWGbjlzw7WfRnKKdktAGVrBs3wR3Dv3j5VRxs83zIx2NI+as0vGewhpDGVAzaYEKl
	2bR7GY/lsgj10rCuvW1onlHf08HO/esFFTbH3za1jANxVyYB+/WTGksZMfaw5s4SDV3Obd7i7A9
	H0A52bMO6l3GCMJfVAz33G+Zea4ZvAI7ML3qqBZqPf
X-Received: by 2002:a05:600d:8443:10b0:490:469c:556b with SMTP id 5b1f17b1804b1-49266864337mr50456675e9.12.1782427144064;
        Thu, 25 Jun 2026 15:39:04 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c7f65082easm27152475ad.76.2026.06.25.15.39.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2026 15:39:02 -0700 (PDT)
Message-ID: <9efd034f-fa6b-485c-aca7-a38f526d4083@suse.com>
Date: Fri, 26 Jun 2026 08:08:58 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: always wait for ordered extents to avoid OE races
To: Filipe Manana <fdmanana@kernel.org>
Cc: linux-btrfs@vger.kernel.org,
 syzbot+ba2afde329fc27e3f22e@syzkaller.appspotmail.com
References: <aaabe0f2bee07800fb0490d24fab5cd162e5241d.1782366056.git.wqu@suse.com>
 <CAL3q7H7+WAQMV76+-AuU=dR_qoe6Gu1_CNmwUFD=zW81d2Hz0g@mail.gmail.com>
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
In-Reply-To: <CAL3q7H7+WAQMV76+-AuU=dR_qoe6Gu1_CNmwUFD=zW81d2Hz0g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/6/25 20:59, Filipe Manana 写道:
[...]
> 
>> @@ -896,42 +896,38 @@ lock_and_cleanup_extent_if_need(struct btrfs_inode *inode, struct folio *folio,
>>          start_pos = round_down(pos, fs_info->sectorsize);
>>          last_pos = round_up(pos + write_bytes, fs_info->sectorsize) - 1;
>>
>> -       if (start_pos < inode->vfs_inode.i_size) {
>> -               struct btrfs_ordered_extent *ordered;
>> -
>> -               if (nowait) {
>> -                       if (!btrfs_try_lock_extent(&inode->io_tree, start_pos,
>> -                                                  last_pos, cached_state)) {
>> -                               folio_unlock(folio);
>> -                               folio_put(folio);
>> -                               return -EAGAIN;
>> -                       }
>> -               } else {
>> -                       btrfs_lock_extent(&inode->io_tree, start_pos, last_pos,
>> -                                         cached_state);
>> -               }
>> -
>> -               ordered = btrfs_lookup_ordered_range(inode, start_pos,
>> -                                                    last_pos - start_pos + 1);
>> -               if (ordered &&
>> -                   ordered->file_offset + ordered->num_bytes > start_pos &&
>> -                   ordered->file_offset <= last_pos) {
>> -                       btrfs_unlock_extent(&inode->io_tree, start_pos, last_pos,
>> -                                           cached_state);
>> +       if (nowait) {
>> +               if (!btrfs_try_lock_extent(&inode->io_tree, start_pos,
>> +                                          last_pos, cached_state)) {
>>                          folio_unlock(folio);
>>                          folio_put(folio);
>> -                       btrfs_start_ordered_extent(ordered);
>> -                       btrfs_put_ordered_extent(ordered);
>>                          return -EAGAIN;
>>                  }
>> -               if (ordered)
>> -                       btrfs_put_ordered_extent(ordered);
>> -
>> -               *lockstart = start_pos;
>> -               *lockend = last_pos;
>> -               ret = 1;
>> +       } else {
>> +               btrfs_lock_extent(&inode->io_tree, start_pos, last_pos,
>> +                                 cached_state);
>>          }
>>
>> +       ordered = btrfs_lookup_ordered_range(inode, start_pos,
>> +                                            last_pos - start_pos + 1);
>> +       if (ordered &&
>> +           ordered->file_offset + ordered->num_bytes > start_pos &&
>> +           ordered->file_offset <= last_pos) {
>> +               btrfs_unlock_extent(&inode->io_tree, start_pos, last_pos,
>> +                                   cached_state);
>> +               folio_unlock(folio);
>> +               folio_put(folio);
>> +               btrfs_start_ordered_extent(ordered);
>> +               btrfs_put_ordered_extent(ordered);
>> +               return -EAGAIN;
>> +       }
>> +       if (ordered)
>> +               btrfs_put_ordered_extent(ordered);
>> +
>> +       *lockstart = start_pos;
>> +       *lockend = last_pos;
>> +       ret = 1;
> 
> And this is pointless, right below we can use "return 1;" and get rid
> of the 'ret' variable.
> 
> Since returning 1 no longer makes sense, just make it return 0 and remove 'ret'.
> 
> Also in the caller, since lock_and_cleanup_extent_if_need() now always
> returns with the extent range locked, we can get rid of it's local
> variable named 'extents_locked' and use 'ret' as it does not make
> sense anymore.
> 
> Finally, with this change we now always look for ordered extents and
> lock the range. Previously, we only did this if writes were within
> i_size - which makes sense because, except for his new direct IO case
> falling back to buffered IO, we could never find ordered extents
> beyond i_size.
> 
> Have you checked whether performance is affected?

Here is the microbenchmark for the runtime of btrfs_buffered_write() and 
lock_and_cleanup_extent_if_need().

The workload is a very basic xfs_io -f -c "pwrite 0 1m", which is always 
appending the isize for every 4K block.

Before patch:
- lock_and_cleanup_extent_if_need():

   runtime avg = 58.16 ns
   runtime stdev = 4.2

- btrfs_buffered_write():

   runtime avg = 2115.6 ns
   runtime stdev = 1822.1


Patched:
- lock_and_cleanup_extent_if_need():

   runtime avg = 183.0 ns
   runtime stdev = 161.6

- btrfs_buffered_write():

   runtime avg = 2973.3 ns
   runtime stdev = 4225.1

So yes, the runtime of lock_and_cleanup_extent_if_need() has greatly 
increased, by more than 3 times, but still less than 1 micro second.

The btrfs_buffered_write() itself is also much slower due to the extra 
extent unlock, the runtime is increased by 40%, but still less than 3 us.

I'm not sure if the cost is acceptable or not. The increased runtime is 
pretty huge for the affected worst case scenario, and that's undeniable.

But the overall runtime of btrfs_buffered_write() itself is still at 
single digit microsecond level.

If acceptable, I'll add the microbenchmark into the commit message in 
the next update.

Thanks,
Qu

> 
> Thanks.
> 
>> +
>>          /*
>>           * We should be called after prepare_one_folio() which should have locked
>>           * all pages in the range.
>> @@ -1288,11 +1284,8 @@ static int copy_one_range(struct btrfs_inode *inode, struct iov_iter *iter,
>>
>>                  /* No copied bytes, unlock, release reserved space and exit. */
>>                  if (copied == 0) {
>> -                       if (extents_locked)
>> -                               btrfs_unlock_extent(&inode->io_tree, lockstart, lockend,
>> -                                                   &cached_state);
>> -                       else
>> -                               btrfs_free_extent_state(cached_state);
>> +                       btrfs_unlock_extent(&inode->io_tree, lockstart, lockend,
>> +                                           &cached_state);
>>                          btrfs_delalloc_release_extents(inode, reserved_len);
>>                          release_space(inode, *data_reserved, reserved_start, reserved_len,
>>                                        only_release_metadata);
>> @@ -1311,17 +1304,7 @@ static int copy_one_range(struct btrfs_inode *inode, struct iov_iter *iter,
>>
>>          ret = btrfs_dirty_folio(inode, folio, start, copied, &cached_state,
>>                                  only_release_metadata);
>> -       /*
>> -        * If we have not locked the extent range, because the range's start
>> -        * offset is >= i_size, we might still have a non-NULL cached extent
>> -        * state, acquired while marking the extent range as delalloc through
>> -        * btrfs_dirty_page(). Therefore free any possible cached extent state
>> -        * to avoid a memory leak.
>> -        */
>> -       if (extents_locked)
>> -               btrfs_unlock_extent(&inode->io_tree, lockstart, lockend, &cached_state);
>> -       else
>> -               btrfs_free_extent_state(cached_state);
>> +       btrfs_unlock_extent(&inode->io_tree, lockstart, lockend, &cached_state);
>>
>>          btrfs_delalloc_release_extents(inode, reserved_len);
>>          if (ret) {
>> --
>> 2.54.0
>>
>>

