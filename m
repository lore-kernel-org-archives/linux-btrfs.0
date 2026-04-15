Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA2F93093D8
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2026 23:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776294170; cv=none; b=SP6EjUvYSh8FbY3FMOyr/33bdwebhaf+2ID6syBfWm0uQfo/9hA1Nxr6Q0xErTi+KUpJ0njL8mYIKjfIcJ85uYlmW5UoWhJJNeXNxdbgcqajQFLqNa/lA6W8LvA9GlRUjaPoQtymWSBYl5SUkcAvIMT+5fz85Yjr3M+2uPAjz4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776294170; c=relaxed/simple;
	bh=nV8vIiryG4TXQ5KeltcZMCXHQ4PcJMj8WA1heeSjvjw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H89XNicsDiq4x5aOLT+Q2hXtfP+MS95TybuT6eosf8XkYCBIOozOdzpBRx8+ieS3bfcEsU4VfYKfxC7DQHuZOo9uT8qBF0RRnZjZXo9Uz7DkyxW+mV6CqFsiAlXPBt8DuW/CWe4aw1tAVST9m8DzB2DwSDTANzFirVeBfHq9Ou8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=L68oYjCh; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="L68oYjCh"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-488b0e1b870so112507595e9.2
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2026 16:02:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776294167; x=1776898967; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=urZzC8VxEF35OFZGOmaSNf2zj6k51RcMICNHJv4mj3Y=;
        b=L68oYjChgs1056Ry08VUdo55gfbTZ/CMdM6oiPBGNm2JsNK2Nawf1q+jxis2MjNG3O
         FKNxOC93LJX1IZBIUG2uf7BQwA74XhaScc/H7BCTVvPvutsrIVhultvkKyFsVy7UvhLJ
         vSGGXnhtWLiZurMqmY3ZOXj5N+IYRfffjf2T5vsFmaQVjon2U7xhkVDXUMGw5EUEqMlZ
         pC5QozHLAkibBNipEY67Q/x6EuP5kYyJhbIcmZ87ryI7IyNWvGtKDdDGm1j3IhRzX52i
         Ri/2kviRGycVTJSqATBfnk4ZFrJpJgHWXXRTk8VuW8MEDxKqpuUZsy+qQ3CwiCy3eJ+Q
         oWeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776294167; x=1776898967;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=urZzC8VxEF35OFZGOmaSNf2zj6k51RcMICNHJv4mj3Y=;
        b=k5MKs1MpX+2Ax31u3+S8iPwFzoLBzhv7nWkTf/p9cwIVm6yNeKGNGfQ3XgiU5UgVqc
         rrBbXKLKsZR1xecttalQaLeWalvtjOpZQpZpHs3HHrVZ8/D5A86JxXJ7+S14/IQvdISq
         RA6i3faTyCRu/FO1PT1DGCOqARrsGawlqJeDuV3keiDd+6VZlRGwd1Wc4NA9OxWJ3Zy4
         FfxJXjijjjabP7C42F/fIuqoHFzGllWiS0tvSgWSKdLEj+90AQ4G7y1n43qdy6MgR6RK
         M2j1rC3h6Qx2pq5qwLkN6GmI8x7eAaIyZ+y2QRZfPmJdr+ktCGqoZ34JByGuaRcvP2z7
         hX+g==
X-Gm-Message-State: AOJu0Yy0N8aEqLrNFKr2sNvElpP8c+cmNXnz6toUur6QYqtdfyFpEH7c
	LgPOzdZr+A769PqL6y5W1qOQdn2xtshJGA/SzJKLwBETnGsny1lZlxEq2fncYnwNeiY=
X-Gm-Gg: AeBDietu7AVbpHkTTxUIBFVytPxQQLDN1RhA7gL9qNWFJnMylqCcfZa9Ryz6xOQKoN4
	P3HmMgPCCjfu5/oxrLigCb+2grDiV/Y55KqkHILDd4tOwmeXDn97hnZMT0WUd6L+RXfKRr0hwjA
	rnokL/2Pa5D0q6EZqFv54Na7Z8Cz8zETBZ/IB2LuXR71Xr0Hr5Cnpjh2Ik1UEcVMQyhZG8dwgXu
	Y5pZGObTVzdD6xQ0fgfgFKJeM3frJ8vlY1kMSK9YPRrBQpsIUmJg7JsNVBX5N2kUzU1POHgudwg
	HkwNH2pAQnvrLHVxDLdy9HL4dlJsfJMCyhk+wtjwR6xxrUhakzjIwOZSImpA+WV0Wj2fZcQbiu4
	3ksWqKyofbvBjbzZqWV/UUmJMmxrjKALB7YqsT/2gHK6vtMp8xm5DsgqfU8w9SER+XE9T/DT/lc
	TsZalHsYoYIpjjRWhqW3DnfsceWDsuforwLShBx19vL6nez3N0tVc5XNgh5ITvvL3X6HxrDUG1
X-Received: by 2002:a05:600c:1391:b0:487:5c0:671f with SMTP id 5b1f17b1804b1-488d67e6a48mr338860175e9.9.1776294166848;
        Wed, 15 Apr 2026 16:02:46 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b47826e306sm32852415ad.46.2026.04.15.16.02.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Apr 2026 16:02:45 -0700 (PDT)
Message-ID: <ec6a7a95-28d2-41bc-85a7-ef36e58ff9bd@suse.com>
Date: Thu, 16 Apr 2026 08:32:40 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: warn about extent buffer that can not be released
To: Filipe Manana <fdmanana@kernel.org>
Cc: linux-btrfs@vger.kernel.org, AHN SEOK-YOUNG <iamsyahn@gmail.com>,
 Teng Liu <27rabbitlt@gmail.com>
References: <1c3a439e1e21c4ee32575b264ac0bc3935ea4f53.1775364843.git.wqu@suse.com>
 <CAL3q7H45KF=ptRmAEE32J07oeewV3h-Zq8k_-LhO15PnReL+2Q@mail.gmail.com>
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
In-Reply-To: <CAL3q7H45KF=ptRmAEE32J07oeewV3h-Zq8k_-LhO15PnReL+2Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/4/15 20:55, Filipe Manana 写道:
> On Sun, Apr 5, 2026 at 5:56 AM Qu Wenruo <wqu@suse.com> wrote:
>>
>> When we unmount the fs or during mount failures, btrfs will call
>> invalidate_inode_pages() to release all btree inode folios.
>>
>> However that function can return -EBUSY if any folios can not be
>> invalidated.
>> This can be caused by:
>>
>> - Some extent buffers are still held by btrfs
>>    This is a logic error, as we should release all tree root nodes
>>    during unmount and mount failure handling.
>>
>> - Some extent buffers are under readahead and haven't yet finished
>>    This is much rarer but valid cases.
>>    In that case we should wait for those extent buffers.
>>
>> Introduce a new helper invalidate_btree_folios() which will:
>>
>> - Call invalidate_inode_pages2() and catch its return value
>>    If it returned 0 as expected, that's great and we can call it a day.
>>
>> - Otherwise go through each extent buffer in buffer_tree
>>    For eb that still has EXTENT_BUFFER_READING flag, wait for them to
>>    finish first.
>>
>>    Then check if the refs of the eb is greater than 1, if so it means
>>    it's still held by someone, give it a warning.
>>
>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=221270
>> Reported-by: AHN SEOK-YOUNG <iamsyahn@gmail.com>
>> Cc: Teng Liu <27rabbitlt@gmail.com>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>> This new debug feature has exposed some problems, e.g. generic/648,
>> after an injected failure for device barrier, transaction is aborted but
>> we have a lot of dirty tree blocks unreleased and triggered the new
>> warning.
>>
>> We still need to fix these corner cases.
>>
>> Meanwhile if Ahn or Teng can give this patch a try for the existing
>> use-after-free problem, it would be appreciated a lot.
>> ---
>>   fs/btrfs/disk-io.c   | 52 ++++++++++++++++++++++++++++++++++++++++++--
>>   fs/btrfs/extent_io.c |  6 -----
>>   fs/btrfs/extent_io.h |  6 +++++
>>   3 files changed, 56 insertions(+), 8 deletions(-)
>>
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index b8ac3275d8f8..d450bfc6d89b 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -3276,6 +3276,54 @@ static bool fs_is_full_ro(const struct btrfs_fs_info *fs_info)
>>          return false;
>>   }
>>
>> +static void invalidate_btree_folios(struct btrfs_fs_info *fs_info)
>> +{
>> +       XA_STATE(xas, &fs_info->buffer_tree, 0);
>> +       unsigned int checked = 0;
>> +       void *tmp;
>> +       int ret;
>> +
>> +       ret = invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
>> +       if (likely(ret == 0))
>> +               return;
>> +
>> +       /*
>> +        * Some btree pages can not be invalidated, this happens when some
>> +        * tree blocks are still held (either by some pointer or readahead).
>> +        */
>> +       xas_lock_irq(&xas);
>> +       xas_for_each(&xas, tmp, ULONG_MAX) {
>> +               struct extent_buffer *eb = tmp;
> 
> Why use the tmp variable? We can pass 'eb' to xas_for_each().
> 
>> +
>> +               /* Wait for any readahead first. */
>> +               if (test_bit(EXTENT_BUFFER_READING, &eb->bflags)) {
>> +                       xas_pause(&xas);
>> +                       xas_unlock_irq(&xas);
>> +                       wait_on_bit_io(&eb->bflags, EXTENT_BUFFER_READING,
>> +                                      TASK_UNINTERRUPTIBLE);
>> +                       xas_lock_irq(&xas);
>> +               }
>> +
>> +               spin_lock(&eb->refs_lock);
>> +               if (refcount_read(&eb->refs) > 1 || extent_buffer_under_io(eb)) {
>> +                       btrfs_warn(fs_info,
>> +                       "unbale to release extent buffer %llu owner %llu flags 0x%lx",
> 
> unbale -> unable
> 
>> +                                  eb->start, btrfs_header_owner(eb), eb->bflags);
>> +                       if (IS_ENABLED(CONFIG_BTRFS_DEBUG))
>> +                               WARN_ON_ONCE(true);
> 
> Pointless if, just do DEBUG_WARN();

The problem is we do not have DEBUG_WARN_ON_ONCE().

We already have cases triggering this during fstests, and there were a 
lot of ebs that are dirty in that case.

DEBUG_WARN() will flood the dmesg with the same call trace for each 
dirty eb.

I can add a new DEBUG_WARN_ON_ONCE() for this particular call site though.

Thanks,
Qu

