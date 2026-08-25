Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1814D4908AB
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2026 22:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787697233; cv=none; b=cYBPnqrzKkfYBMsgx+zCAUScIaqsvUKMaGCblznkiddPUOwl2Qo0j0cqKHA2lc83LljGUsn6g6XyJC6/RicyVgbPm0wGWiOhMY52HJkcM81bUgFBrqrRtXuuh3OnC2BCpXb4sN9vGhkWkveBICotU/A1fv7hnG0Lcdj8A3WVfrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787697233; c=relaxed/simple;
	bh=T8pK87gpR/FudGYTMZpQqgz9Vsiy+adAwiTk3948Yjo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ESXVZsZusbAtB8n3eXO7frwL4E5EYIxodVB/Hy9UQSDO3thtDmjwktpLFb1K0KdnaDlvUbXvbY9TI87sSG2AsGAv9qNXKZ2Vl+5zoVrtRAfAWLexy+CyGSeKfKlY1T8duwpceqed+xE0qZWqOGXaZo9DB6vv9UlKxo/X5XE8pnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=TIK2I3j3; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="TIK2I3j3"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-490cf322ed0so2037815e9.1
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2026 15:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787697229; x=1788302029; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AQ9BECpJKrpP12MABcUEh0lAKrEb0D+i2kVCVQ2/O4k=;
        b=TIK2I3j3Idx421sRhZA0hqKmXZGzFRZ5p4eklGHWHpfNjstX7UQZ7bgDuJxtwBKrXG
         aRjJP7Wh38K9wiOU5GuWDbGmwzWZ8t6kshydID7NSje/aI7snNk9JWNQj8vLGtlHF/qV
         75NHcoSOSGesC9bAkem3RDWYoGCR+/XRFbAGhQTIEWk+FHJepXwoInK+KhEE5R0RU7o5
         5WCHylXfint97Cyi4mkQm1eYeQ5pfnToQHULnphtvw771e5NJQj5fXzEycXx3cGMyLHn
         a1iNbt/uk6cpmj9hUFKIGWTVrtmI1Xqee8OCPokGMQvS/RUn3WAjdbEnHlQKcmlj59Oe
         4qlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787697229; x=1788302029;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AQ9BECpJKrpP12MABcUEh0lAKrEb0D+i2kVCVQ2/O4k=;
        b=MbTWdgawZ7ISFHX52LdF8dLUfcdV+jXynAxl3bmh+Mwsd2AYAxg7ovRWHu+HFlvleA
         RaALKMdLZdjo3bInMMwBAZzIa5O6tgVIndBUG47SsFx7hO+FU/mf/u/CwDXSV6Qd0zPc
         wns7VP4nVmuMB7nbiXaiKMXsf7pM9x1XM1Ksvuu5/KGBZJw6TqWB3bsM3Ejn9fnlgMHV
         48PiyVR39s4dICRiijwEgaLz1Qs46hW/M+hJUyo5vDToPKdaL6/EIQ8NTk0mQslTdecn
         fIMM9YQPfEo1iBomJtAYBqqRu2EtN7dyxpwCfpjqEBcqrbfbiYV2TUhPZL87NFh6S9Cx
         4sLg==
X-Forwarded-Encrypted: i=1; AHgh+RrAD8mVRa49aPlhOGw3ahsHLFzOyqhnvCgn1gbKUYz2wpPfyWXvXM/+RC6lDUORgOmNB7+L6+Wg6N9Ezg==@vger.kernel.org
X-Gm-Message-State: AFuF++nYecbsdFUTcR7jZLhCRWWiBidpL/8qDoYeQ0le0vVZkz+gXpXD
	OxO5bWh1TFWMvO/OkuEVSFQf9ifJEWJ3/LFHgo9lI1l6e1wVZxjOUssQ99daTmi63Cw=
X-Gm-Gg: AR+sD11FDMs6fJSye8GzVyImefWNv7tK0dJlsjBKBIvk6jtQTSDT5woDwQNg/Wg2O1a
	7IWZxKidVqjds1IDMPIuZZyzIbvUoYkQiy5ezWCw3jaOCL3VvHLeBQbLdHg3BMVXh04PK2wSS9B
	eB8YIKEd4tyt6nGb2x1rncKEvxDzLBE2cPvNnOs9GLAAEGCILvod5Hh6BwABeRJVUeNnPexZxGB
	MzlTUtE+6lBOeO8DYUL4T5R63rcB9lhEO/gWDdoYkQu+fEhPL191SMAK7dMKfSJ/x9HsK8pMKcW
	HCvgJdYMHD2bAYKEh4GeOVWdLUyXxEsAC1pA32nb/rRAeAiavtSDUY0rN+7FiXsxkcoD6t8LRWs
	jiv+ncZspGixa61nVSFg87sPltfPSiOYfV/UAb+g8KejX2zOzYnV4WLD6AVs7P9j59KvbhvzF36
	GTJtgXEI3vMFuIHR+WzN2gCLkjCKAnOVTOdkP/va/L1jxWuQ7Rh/Wr
X-Received: by 2002:a05:600c:3155:b0:499:4892:d022 with SMTP id 5b1f17b1804b1-499dc6feffcmr15555245e9.8.1787697228911;
        Tue, 25 Aug 2026 15:33:48 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3965d119724sm3170845a91.2.2026.08.25.15.33.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Aug 2026 15:33:47 -0700 (PDT)
Message-ID: <cf3486b8-a506-4732-8274-b3179fb06a82@suse.com>
Date: Wed, 26 Aug 2026 08:03:38 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Removing ->dirty_folio
To: Matthew Wilcox <willy@infradead.org>, Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Pedro Falcato <pfalcato@suse.de>, Christoph Hellwig <hch@lst.de>,
 Jann Horn <jannh@google.com>, David Howells <dhowells@redhat.com>,
 John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
 Rik van Riel <riel@surriel.com>, "Darrick J. Wong" <djwong@kernel.org>,
 linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-xfs@vger.kernel.org
References: <aoyWln-Gt-yvZQkE@casper.infradead.org>
 <a1f8902b-72a5-40fd-a36b-89b6ea271cdd@gmx.com>
 <ao3sgEET8GuY7Rw2@casper.infradead.org>
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
In-Reply-To: <ao3sgEET8GuY7Rw2@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/8/26 04:56, Matthew Wilcox 写道:
> On Tue, Aug 25, 2026 at 08:08:48AM +0930, Qu Wenruo wrote:
>>> The problem is GUP.  We have no way to force the GUP caller to go
>>> through page_mkwrite again.  So instead we make the GUP caller call
>>> folio_mark_dirty_lock() which many just don't, and generally we get away
>>> with it.  But it's a bug, and a bad interface.
>>>
>>> There's also the problem that GUP users bypass the folio_wait_stable()
>>> mechanism.  If a page is written to while somebody is creating a
>>> checksum over that page, the checksum will be corrupted.  If we want
>>> to fix this, we have to bounce-buffer the page.  There's no way to
>>> prevent or delay a GUP user from writing to the page.  Enjoy your RAID.
>>>
>>> My proposal is this:
>>>
>>>    - Fileystems take note of folio_maybe_dma_pinned() during writeback.
>>>      If it's true, do the writeback, but retain/recreate whatever data
>>>      structures you need in order to write the folio again; behave as if
>>>      ->page_mkdirty() had been called again for each page in the folio is
>>>      marked as dirty.
>>
>> This may make COW more complex.
> 
> It's probably wise to be explicit when talking about COW.  Anyone from
> the MM side of the house is probably thinking "but this is only relevant
> for shared writable mmap and we don't do a COW".  You're talking about
> filesystems doing a COW of the on-disc data, not about the MM COWing the
> pagecache page into an anonymous page.
> 
>> For folio_maybe_dma_pinned() case, we will need to do extra space
>> reservation similar to page_mkdirty() again, so that the folio can be
>> written back again.
> 
> Yes, you will.
> 
>> I'm not sure if we will have a good timing for re-reserving space inside
>> btrfs.
> 
> Why is it hard to do it immediately at writeback time?  I think you're
> in an even less restrictive locking environment than page_mkwrite is
> called in because you're not under any MM locks.  According to
> Documentation/filesystems/locking.rst, ->writepages is called with
> absolutely no locks held.

This space reservation problem is a btrfs specific problem.

The root problem here is, btrfs space reservation can trigger 
writeback/transaction commit.

This is due to the data/metadata COW nature, and that's why we rely 
completely on buffered write to do space reservation, and avoid any 
extra space reservation at writeback time.

This is also why we have the complex fixup mechanism, to avoid writing 
the folio that needs fixup, but queue it for space reservation.

Other than other fses to do the space reservation at writeback time.

I believe since we have some space reservation for no-wait writes, it 
can be slightly simplified using no-wait reservation (aka, reserve 
during writeback), but it has a much higher chance to hit ENOSPC.


Although I think on the long run, as long as we want to migrate to 
iomap, we should find out a proper way to address this problem.

> 
>> Would it be possible for MM/VFS layer to trigger page_mkdirty() instead?
> 
> Actually ... no, because the VFS no longer knows which pages in the
> folio are dirty.  That's information the MM had, and communicated to
> the FS which (if it cares) has stored in its folio->private.  But the
> VFS no longer has access to that information.
> 

