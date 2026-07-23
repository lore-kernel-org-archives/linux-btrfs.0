Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 640FE342146
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Jul 2026 09:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784799950; cv=none; b=lr3J0nM59gR9xpYB44g5qp8hwT+v3CPhAV5O64ThaKlLU5ujJAv+c4q7sVXZnnoNeiBBkw3uPZKlwlLzODPjknXHPp3NZQwWwwFLZZA4WVXrzaqAxaniQgU0FFDB3CHfOkXdwsgDrRAjWiQLfsRcQnxf0SItLARxnuKOJM5ZjTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784799950; c=relaxed/simple;
	bh=oVa7njYZGKLxK673g2O5F7m3PTIy/KzRiZgPlySY1P4=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=GAxqOdFTeN7ZZ8mP/sR1TBWh5nZBpneh82xtUeAikGP4oyxS/bmtb58OvhqefAg99e58xB5FNiVM2QB9+kjCN/+zXUiTvQdw/k6swU+lGiO1JdFEpnRUhjl0KIyIcpRsn8grZ30hkNEAhc7JyrrrNkBz5vttJr/C2mGR3nRHeeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=PVecEZoM; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="PVecEZoM"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-4798bea72f9so280077f8f.1
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Jul 2026 02:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1784799945; x=1785404745; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:references:to:from:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9E0aa1/ah54xEiL5PB/XabSsE+mN8+R2RhZTY/b4HPs=;
        b=PVecEZoMMK1fs/zqUOg0YCaC6WSJ0ekL6DZKMWX5hyVCTxWpnSu28XKmv1tsK9yfIW
         6bFFYAYigUKx2SOx6smr/X3zBnxXxy4K3fLIu80JI6vv8NGCBg6RjCkiO4A9itY9OlBs
         CJs8+q6LVQJaM/yr9IUGXqY3uHI+LyCnqtlnmh5n4vW72m9y4Tp/L4c/5IHmPxYnGjNK
         6i6dhFcG5XAin0AXqicr2Uo/TZPgIwwG+zgkGV5d4ROc64I1aYtpCYG9zmVVytD+xOid
         yPGK9ll7lvQcTXBfA34Ys4Udh88M9qcbZMxPtGlv6OVFQNBs09pMDz5n+9yIJ3GgKvkI
         sU9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784799945; x=1785404745;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:references:to:from:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9E0aa1/ah54xEiL5PB/XabSsE+mN8+R2RhZTY/b4HPs=;
        b=kJUkJekQaEWGkp03oUg5XOcTYOOQZ+d2HR3FoltZoy4LGRq54TI3iVR/QtOOj3I4dv
         NKgfFTti6l0mE8uLiz+NBZKGfV+k4BDXGcXV6ZVqUIn2pe5+q0Ot6isV/sSxAmCy/leb
         dU+lMXHWpOEefm/Ym019+IlYWXqdtCu5btCKDG4wpyOLUEMtzcZydnBm/1k8EabNfWTk
         VJXBLxibK2EPUWzVkM7vYAB1Xm4Do0vFjorXt+6e+AY61Kpv1bdmv3Mf7Kj3WXkCb/Bd
         zLsoCKo7oEWut8NwMwrp08nrB8DCXXQWPA/cf6z1coC4TkcoKroeZK0KpooHfGMgLAma
         bSTg==
X-Forwarded-Encrypted: i=1; AHgh+Rq3g6AFxnaXRdTFqrlKrbEPVtSaDfyp429UTjalfdtv8y40UeZvWAtDazPhSmtcw83NoA2T9wqr6VB5kg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7JgWMXoUt6meWL9YbA+5c8kxnymxWzlG8NmF0wrmyexFLAAhS
	KJWD0hs6RTjeS/caJ4/fkevDqFyEExM4OUPvNfYoGBy6GmRftcUT8Anwu4YesAIa5tvv/isycv2
	ds5x6TQ2bAQ==
X-Gm-Gg: AR+sD13HL7q5vlJSfOcAAJxVJeI+rpTAY6B6z8h6nxikaxz9WFmDJVuWiU6KQzGfeDQ
	1Gq8Mt1OfTyrYu8+UxjGQkUlyr1aReq3EnJOK17L12oFVdWWG26aGos3BOV1t8ERAiZD7I2BAp/
	BQYDZZrnSVVocxn2GePjIBKa4vbPjYdZozvDsv9xDFfphrr+yekY45N+emAveXQyhjNiWCsAfbh
	6GV21PoaWs1mrLejCoYP9XJIR3K6Gm69xNbaZ4YtZ4L+/3Ga7sbWl3ExVFPmTpAuIZ3F1ScrxCa
	AG3+OoOiTy1u0v6Q4EU3CtGmW7H82Agilz61tU3uuU69+UrMK1ZJyYj12cVs8IO1Rwb55DIGiTB
	rwxsOXK5SDgfAFQEhlmsOMMCFAu1mXmjhDxBRqWzo5kVucg9tDP4rZDrWwqk610G9PP7IwBo=
X-Received: by 2002:a05:600c:2101:b0:495:5b4a:53c9 with SMTP id 5b1f17b1804b1-49573cff13bmr18544355e9.39.1784799945210;
        Thu, 23 Jul 2026 02:45:45 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3147d47960dsm17274786eec.0.2026.07.23.02.45.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jul 2026 02:45:44 -0700 (PDT)
Message-ID: <4beadb76-8500-452c-b84e-206c50456b8a@suse.com>
Date: Thu, 23 Jul 2026 19:15:40 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Help needed to address the dirty folio without fs notification
 delimma (Re: [PATCH RFC v2] btrfs: disable direct reads to avoid dirty folios
 without fs knowing)
From: Qu Wenruo <wqu@suse.com>
To: Christian Borntraeger <borntraeger@linux.ibm.com>,
 linux-btrfs@vger.kernel.org,
 Linux Memory Management List <linux-mm@kvack.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
References: <c6dfdac9fc51c94183e51a861eec269185239660.1784787211.git.wqu@suse.com>
 <9b1d42c4-2c3f-410e-aceb-92400b8bc24f@linux.ibm.com>
 <f49478be-70fc-4cd6-a640-fb008c21c092@suse.com>
Content-Language: en-US
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
In-Reply-To: <f49478be-70fc-4cd6-a640-fb008c21c092@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/7/23 16:29, Qu Wenruo 写道:
> 
> 
> 在 2026/7/23 16:18, Christian Borntraeger 写道:
>> Am 23.07.26 um 08:13 schrieb Qu Wenruo:
>>> There is a bug report that a reproducer which doing the following
>>> workloads in two threads:
>>>
>>> - Direct read into memory mapped from page cache
>>> - Sync the above range
>>>
>>> This can lead to dirty folios without fs knowing, this can be a huge
>>> problem for btrfs, as even on the very basic bs == ps cases without
>>> large folios, such reproducer can screw up the ordered extent accounting
>>> already:
>>>
>>>   ------------[ cut here ]------------
>>>   WARNING: fs/btrfs/ordered-data.c:390 at 
>>> can_finish_ordered_extent.isra.0+0x56/0x1f0 [btrfs], CPU#1: kworker/ 
>>> u42:0/68
>>>   CPU: 1 UID: 0 PID: 68 Comm: kworker/u42:0 Tainted: G E       7.2.0- 
>>> rc4-custom+ #415 PREEMPT(full) 74dbeafab12c410178747d5bec9fb200ae56949f
>>>   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS unknown 
>>> 02/02/2022
>>>   Workqueue: btrfs-endio simple_end_io_work [btrfs]
>>>   RIP: 0010:can_finish_ordered_extent.isra.0+0x56/0x1f0 [btrfs]
>>>   Call Trace:
>>>    <TASK>
>>>    btrfs_finish_ordered_extent+0x39/0xd0 [btrfs 
>>> 7d1ffd99bb9696179883f257e5fd838e2d1a0ca3]
>>>    end_bbio_data_write+0x1ff/0x280 [btrfs 
>>> 7d1ffd99bb9696179883f257e5fd838e2d1a0ca3]
>>>    btrfs_bio_end_io+0x76/0xf0 [btrfs 
>>> 7d1ffd99bb9696179883f257e5fd838e2d1a0ca3]
>>>    process_one_work+0x198/0x380
>>>    worker_thread+0x1c8/0x330
>>>    kthread+0xee/0x120
>>>    ret_from_fork+0x28f/0x310
>>>    ret_from_fork_asm+0x11/0x20
>>>    </TASK>
>>>   ---[ end trace 0000000000000000 ]---
>>>   BTRFS critical (device dm-3): bad ordered extent accounting, root=5 
>>> ino=257 OE offset=3465216 OE len=2826240 to_dec=319488 left=135168
>>>
>>> Unfortunately we have removed cow fixup mechanism, which is to work
>>> around such dirty folios by re-dirtying them and reserve space for them,
>>> across several kernel releases, meaning we can not easily revert a
>>> single commit to bring it back.
>>> And without doubt, that old cow fixup mechanism is not support larger
>>> folios.
>>>
>>> As a hot fix, disable btrfs direct reads for non-experimental builds for
>>> now, so this can buy some time before we find out a proper way to 
>>> address
>>> this.
>>>
>>> Reported-by: Christian Borntraeger <borntraeger@linux.ibm.com>
>>> Link: https://lore.kernel.org/linux-btrfs/f12f70e5-d84d-4a9f- 
>>> ac94-693be4c863ac@linux.ibm.com/
>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>
>>
>> Wow that is a big hammer. Doesnt that break typical usecases (like 
>> databases on a file,
>> qemu/kvm aio+direct image files etc)?
> 
> It falls back to buffered read, which has a good side effect that if the 
> reader is also modifying the buffer, it will not cause a csum mismatch 
> warning.
> 
> Although it causes huge performance drop.
> 
>>
>> Even worse, this does not fix the other GUP use cases that still 
>> exist? So its only
>> a partial fix. Have you considered to add my RFC patch on top to close 
>> another
>> problem that I can reproduce easily.

BTW, if you really want to get everything fixed for the very basic bs == 
ps cases, you have to go back to v7.0 with CONFIG_BTRFS_EXPERIMENTAL 
disabled.

In that kernel we have cow fixup, which is unfortunately removed in 
v7.2-rc by commit b2a9f217ad3f ("btrfs: remove the COW fixup mechanism").

With that feature even if the folio is marked dirty without notifying 
the fs, we can detect and later re-dirty them and do the proper space 
reservation in a workqueue.

But again, that COW fixup mechanism is not well tested (I believed we 
shouldn't require it and we never hit any reports about that), and can 
not handle large folios or bs < ps cases either.

Furthermore it's not an easy revert in upstream, at least we have a lot 
of involved patches that are removing the cow fixup code step by step:

9bce95edb1b4d2802de9273b5170bfcff3090d24 btrfs: move large data folios 
out of experimental features
115421e29b845d521e3dc24b67d83e8695f621f6 btrfs: remove folio checked 
subpage bitmap tracking
b2a9f217ad3fa8012940744059956b20a3971135 btrfs: remove the COW fixup 
mechanism
4927b141877c35b1af4e32c7876cd2e0a0f16196 btrfs: remove folio ordered 
flag and subpage bitmap
aea704836e47decbdcac77872385c9a3fb51da42 btrfs: remove 
folio_test_ordered() usage
7d97bdca4bcb0e36b2d1251bffac3ff4e4e09c8c btrfs: use dirty flag to check 
if an ordered extent needs to be truncated
095be159f3eb4670fab75f795ce9539a381ebd3f btrfs: unify folio dirty flag 
clearing
b066155f06eeb4d6d696668cc58b6101adf6c1c2 btrfs: detect dirty blocks 
without an ordered extent more reliably

Not to mention there are also quite some conflicts with other changes.

So the assumption of every dirtied page folio is dirtied by either 
buffered write or ->page_mkwrite(), is really the core idea of recent 
btrfs update and the basis of the subpage support since v5.15.


I do not have any good idea to go forward.

Full revert is hefty and can only handle bs == ps cases, subpage/large 
folios are still affected.
Although I can revert the large folio support, that's a pretty cheap one.

The RFC patch from the reporter is not going to address the very basic 
bs == ps cases either, just check the OE accounting error message in the 
commit message.

Finally I do not have enough mm knowledge to address it from 
mm/block/vfs/gup layer either.

So any help/advice on how to address this situation would be very 
appreciated.

Thanks,
Qu

> 
> Because that doesn't fix the problem at all.
> It's just masking a corner error.
> 
> With or without your RFC, on x86_64 with large folios disable 
> intentionally, it still triggers the OE accounting problem mentioned in 
> the commit message.
> 
> I believe if you switch an older kernel, or disable large folios 
> manually (reverting commit 9bce95edb1b4d2802de9273b5170bfcff3090d24), 
> then you should hit the same warning on s390x, and also fail the 
> reproducer (error out, not hang though).
> 
> 
> Again, dirty folios without fs knowing is the root cause, your RFC is 
> only avoiding one symptom, all the other problems are still not 
> addressed, and those problems are not any less serious than the hang.
> 
> Thanks,
> Qu
> 

