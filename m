Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 048BDDDC5
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Jul 2026 23:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783467048; cv=none; b=nTB1xF9Z+Q0OfvqAiMwnNpihMe604LT/xCmw4Gvv6Nwa4r9JkzdXgEcR6341VRDlu/1HbpTWX3SsKwOgOHlVBjAuGR2h87rJgq4cqyY+IiNkCUTII2OI4pnmViP8j8fsGWsEsZeK8AgE/NC8sS6VSS+q4zAbvW+TIx5ipGnNsW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783467048; c=relaxed/simple;
	bh=LyeDp+2XazcSdPGhbbq4oTKya4ISphqMicytSa/uciw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HIp75gSItTjy+njEQCFvV1Eeye+PArpKG750jG/vbU7NFbuPkT8Vh3J34CnrjoODxWj/dgUobVItyzc7wv3bC7TBDA7u+vy9Ef4HFLUAvbhPHBoYhfw/i9VyqtYTPCbAFtd5S7vZm2+T25C6hn6XnocKAbvGy0dzt1d6Z6tBem4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=K8JmQT8q; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="K8JmQT8q"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-493b1710405so200775e9.2
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Jul 2026 16:30:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1783467045; x=1784071845; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KjZvTa1qcihWQxh/GYKIuWbWTTESVFwW+4Ck81rIB3c=;
        b=K8JmQT8qApv4V2Ysq+BVHZu6F+M2YOZ0lIMRJc92qyNt94UlXR1fx6/QYRBwkh1SDU
         MPXJz0/wf/dE4O85liXKdfC5L0FkYL2+kKbPauZ0tDOVc9U3P+Vt9iLCnASze8G/aijM
         LZ8JGirb+CYyY+nQ9bD3JLVthnhG2QSmgStpB2marBfjqcNDj3hrswyztDIEo1Wb5Utr
         3mY39JMW4hdb7n/pAF4t+9IN+WRiyyXMA9P0kGUv1gFKYaBDVkBxmihcScN1aA7c8tw+
         dKIHNOpn5TEPQqc1vBMXQpQZAEkQ9gTBKT81OankxCzgvXLEPiM5CAOapUaeA+oQfbFe
         j3YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783467045; x=1784071845;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KjZvTa1qcihWQxh/GYKIuWbWTTESVFwW+4Ck81rIB3c=;
        b=bS5auSECn0hsUKouqPeDj92QFlCEEW3EJR8cH0tb+/JG5iR9pn9lO4TRYGQDiM8RDE
         200N0MzkcyzxkrFoHyS2Zovi9dEBXXBIUjmi43h4PbKRNLBwDk7dRCP/9sOJ4JiNRk5X
         aQyWCegzUc12MFFLJYXg8rBPPaLacr8pKUS7992JbttZ+2oGM6X2rFFylxQc9yS8eBTx
         JLN+rYk9VIbzh4rOcVPVXf01ALjBknvUb7sJxMo1rqVzOBinDk3YT59r1lPjdRRB2MDz
         OJ4oLcKr7LJeWvl1byeixxY/u9sau9uiFZKpEkOa+rTZpdNfMtsEw3lO/to5IYtgqUrK
         2DYg==
X-Gm-Message-State: AOJu0Yy0Y3W7OFyhX63wNMjWiZnBM7CYtuvhw+e2mVag36hhWEM4CdEs
	fMXJU/JjVk3ItGdvC6267tVuiLbMj5M0y58RvdIBxK0WdVGm45CVwllkRZeE8CBohHw=
X-Gm-Gg: AfdE7ckW1D0s1NDIC4TyydlWsBI2GCY9TlsC93SSbZEEZZpn/47+0xCoedEifgWXsI2
	OBhFy1U5Ve/sthu2X4OvObgq6t+OnLgyhrzHaqXlXojlc8mHavszKPj2NXBh+2V1mrcA/THHRVf
	+5Sj5pHTKWr52YMWqcLiNJOmteMYgTZVuuJxvNVJRrVI6sKlMEW8XepfOSVIlI/GoF0/C8FL9Tk
	TVJgMoGLloQogYBf7peXSg8UKBepnNDJYXn3PLiWbWQI2UArI6R0Yu2N/IUnRxOH+HaCBiYSJSC
	hN93w+FH0Svd54IbTECCfD1WKrXkTADG3W7yJZsnY9LT/cm8l3/NKra97gSoIRPQWJzCISBpfJw
	/96mqzFBhnIj5UI2VhZqb1sIJ/CAaz/zMhtAseIiDMXWtlp4TDBz+EBh/VHx1kIrCqMgT6KW+Qz
	wAvdJ9YEokML6W2SrF
X-Received: by 2002:a05:600c:3115:b0:492:3e66:6c84 with SMTP id 5b1f17b1804b1-493df095172mr83454255e9.30.1783467045313;
        Tue, 07 Jul 2026 16:30:45 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ca5afcb672fsm1491662a12.11.2026.07.07.16.30.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jul 2026 16:30:44 -0700 (PDT)
Message-ID: <9a5f8318-fb44-4f0c-b8b0-5f8af1fbbfa3@suse.com>
Date: Wed, 8 Jul 2026 09:00:39 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: fix a regression where PAGECACHE_TAG_DIRTY is
 never cleared
To: Boris Burkov <boris@bur.io>, Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org
References: <20260707191208.GA516053@zen.localdomain>
 <58a76be5-12b2-469e-a9a0-146bfeb55773@gmx.com>
 <20260707231632.GA690447@zen.localdomain>
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
In-Reply-To: <20260707231632.GA690447@zen.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/7/8 08:46, Boris Burkov 写道:
> On Wed, Jul 08, 2026 at 08:06:26AM +0930, Qu Wenruo wrote:
>>
>>
>> 在 2026/7/8 04:42, Boris Burkov 写道:
>>> On Tue, Jul 07, 2026 at 03:10:20PM +0930, Qu Wenruo wrote:
>> [...]
>>>>
>>>>>
>>>>> Second, and worse, it results in a deadlock which should show on btrfs/062
>>>>> and btrfs/070, I believe. The problem is that clearing dirty at this point
>>>>> results in a truncate being allowed to clean pages past the end of the
>>>>> new file size without calling btrfs_mark_ordered_io_finished() so we
>>>>> leak that OE unfinished and get stuck.
>>>>
>>>> Mind to explain exactly where the missing btrfs_mark_ordered_io_finished()
>>>> is?
>>>>
>>>> The point here is, we always have the folio locked already, the difference
>>>> is just in the timing where the folio dirty flag is cleared.
>>>>
>>>> I didn't see a problem that the changed timing can cause problem related to
>>>> btrfs_mark_ordered_io_finished().
>>>
>>> Sorry, my explanation last night was rushed and clumsy, let me try to be
>>> much more clear and specific!
>>>
>>> The key change is your recent one, that went together with the removal
>>> of folio_clear_dirty_for_io():
>>>
>>> 334509ce9d07 ("btrfs: use dirty flag to check if an ordered extent needs to be truncated")
>>>
>>> and specifically the lines:
>>>
>>>     /*
>>>     * If the range is not dirty, the range has been submitted and
>>>     * since we have waited for the writeback, endio has been
>>>     * executed, thus we must skip the range to avoid double
>>>     * accounting for the ordered extent.
>>>     */
>>>     if (!btrfs_folio_test_dirty(fs_info, folio, cur, range_len))
>>>       goto next;
>>>
>>>
>>> and quoting from the changelog:
>>>
>>>     If the OE range is dirty, it means we have allocated an ordered extent but
>>>     have not yet submitted the range. And that's exactly the case where we need
>>>     to truncate the ordered extent.
>>>
>>> But with this new fix, which returns folio_clear_dirty_for_io before
>>> submission, the comment, skip, and changelog argument are no longer
>>> true.
>>>
>>> Suppose we dirty folios [F,F+K] at the end of a file and start writeback
>>> on them, creating a single OE for [F, F+K]. extent_writepage will keep
>>> looping through the folios submitting them.
>>>
>>> Now suppose a truncate races in and shrinks i_size (taking i_rwsem but
>>> no folio locks or blocking on OEs) via:
>>> btrfs_setsize
>>>     truncate_setsize
>>>       i_size_write // shrinks i_size to M <= F
>>>         truncate_pagecache
>>>           folio_wait_writeback (not yet marked writeback)
>>>           folio_invalidate
>>>             btrfs_invalidate_folio (folio clean, skipped, this is the bug)
>>
>> Just a small nitpick, the problem is not from the truncate_setsize() call
>> site, as truncate_pagecache() is grabbing the folio with FGP_LOCK, so it can
>> not grab the folio locked by writeback.
>>
> 
> Good point, but I think the issue is as soon as you do i_size_write(),
> so the rest is just my explanation being a little misleading, I think.
> 
>>>
>>> extent_writepage hits the code
>>>
>>>     if (folio->index > end_index ||
>>>       (folio->index == end_index && !pg_offset)) {
>>>         folio_invalidate(folio, 0, folio_size(folio));
>>>         folio_unlock(folio);
>>>         return 0;
>>>     }
>>>
>>> which calls btrfs_folio_invalidate() which needs to mark the OE past
>>> isize finished but skips it because the folio is clean (same issue as in
>>> truncate above)
>>
>> Thanks a lot! Now I understand how things are going wrong now.
>>
>> But I still have a question, I thought we should have some kind of inode
>> lock or something else to prevent i_size_read() from getting stale results.
>>
>> And digging deeper, for the btrfs_setsize(), the inode is already locked.
>> E.g. inside notify_change() there is a WARN_ON_ONCE() if the inode is not
>> locked.
>>
>> Would the root cause of the problem is that we did not lock the inode for
>> writeback?
> 
> yes, I think this path to the hang definitely requires the fact that
> writeback does not hold i_rwsem while reading i_size.
> 
>>
>> And if we do not have proper inode lock for writeback, then I think write
>> back should never bother the isize check, and always do the writeback no
>> matter isize.
>>
> 
> Don't we risk weird truncate vs writeback races where they undo each
> other, then?

Writeback still has the folio locked, so truncation should wait for the 
writeback first then invalidate it.

The other direction would also be true, if the invalidation invalidated 
the page first, then writeback should not got a dirty folio anymore.

But I can be totally wrong considering how complex things are.

I can explore if this idea won't break the existing runs first.
>>
>> Mind to explain why folio_mkclean() is required? Is it for the same OE hang
>> or something else?
>>
> 
> No it's a csum corruption with mmap being allowed to write to folios
> that are under writeback (and thus computing csums)
> 
> Since we got rid of folio_clear_dirty_for_io() (and thus
> folio_mkclean()), then if we mmap a large folio, then start writeback on
> it, we never write protect the folios while they are under writeback so
> the mmap user can trigger write faults and mess up the csums. We have
> observed this in practice in our early testing of btrfs large folios in
> production and we also have a racy reproducer that enables large folios,
> mmaps a file and has a bunch of threads racing between touching each
> sector with some new random data and fsyncing the file. We do that a bunch
> of times, then drop caches and read everything. Do that whole thing in a
> loop a few times and eventually you hit it. I can share the exact LLM
> reproducer slop code if you would like, but that is the rough shape, to
> explain the point.
> 
> I can send my holistic fix proposal with your v2 included in a series?

Sounds great. Feel free to include the v2 fix:
https://lore.kernel.org/linux-btrfs/d47af8cae38e32462d61cb62139c2732e4e8fdbe.1783407237.git.wqu@suse.com/T/

Although considering this is already breaking cachestat() and will cause 
extra overhead for writeback, I'd prefer the v2 as a hot fix first.

Thanks,
Qu


> 
>> Thanks,
>> Qu
>>
>>>
>>> Thanks,
>>> Boris
>>>
>>>>
>>>> Thanks,
>>>> Qu
>>>>

