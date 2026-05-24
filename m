Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B270C3B4EB7
	for <linux-btrfs@vger.kernel.org>; Sun, 24 May 2026 23:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779664597; cv=none; b=Xq3YnsKBJ+1TL04IY4agWeqUGvSwuyW3K1HNQsOSvGU3FVfo2vufj1iur/WZjqHrQShFYkVzyzIs2dPoh9vuSmBjvQ4Fy0/OGypw9q+o+jieW4lsg20FuTvqqfFA3EyUoXyauV9JQ70wgasGdi15B6MhN+GW0/cLBQZjHbTBrNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779664597; c=relaxed/simple;
	bh=OCyh8Bh5cZ9qiD8GrYP0zOPzdJuy2aS/lqZqBNJrZWg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OqtEyFY9CrhHCL1RecF3g6zpwfAmjGcT/8fbZSbcHkE0DBWnSQCFxiHyX/Qa8kPbCrtGmwE5NFQIUIYk7HIa9SVKEtIAOk9ONjSFJiSlly9eIYWgYIzIHOnjyNrS5PyIM8lZQfeJbOMOLhzImddpim8nDtLjRp25ooRp/85Liuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=PSL03n2K; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="PSL03n2K"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-49041e84237so20846045e9.1
        for <linux-btrfs@vger.kernel.org>; Sun, 24 May 2026 16:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779664591; x=1780269391; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=esYMMcDFyPyyaihTO3sfquJeNfjjLwC7k6xiBUI4F4c=;
        b=PSL03n2KwHsbO4FJ6/Owamj/zQDUFhqyiJQduIYKPRaQ4zSl++j9YknvRJEg1Y1T+L
         ZKvfiGdBVlnnG2hWuEXpLLsqwT1PMVmRojX2KWHJDL6XROaexyyMai8GWKkVHT7aA6Iv
         M4yUKeRZ1O+Nz3JzFVEkaxosWmL25odPpEdBHBuikeiDRXLeSiW2npTM79mIOuMS7QTv
         t58YRXJnaXKbvJx985wSG/bpv3O4UnxhCcDVxLL1j6vWutTKgEjmFQaRv+JpE8psjzWV
         eqn7hIvISPOOweF8SYIwIEbI9IoCSGXPId7LgToypTXbzyrox6PcVEAHh4a0knfA4Fs6
         ljCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779664591; x=1780269391;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=esYMMcDFyPyyaihTO3sfquJeNfjjLwC7k6xiBUI4F4c=;
        b=XHcaqkvFxaekd4sxlNtyhIwXCBvqa5zoMAq2PNqu32g1+NVU6tWpRBA9NkIgYTjvTP
         g9UcBJyZnwE4I1xm24fFwhwcHrtg/eDDVDvPfwo5/0G6do4QdVrSqUTauCJd0TQHBTHS
         Dd6iM+AFM0ZfWQimdH/Xuyu3ZFsjGo5bTAqYoEhef8p2j9FPwFhsEqOXTxeYZWx3EGGe
         FGLnf7TP470x+67JghHX1haz386EKLitPmOO/x7LAljU1fKJTByfNZdeIEK02nGsy6KE
         6MGtOhN4O5LCdsMmhIg4oWuCplJuJ73tPQkSOOCfmU6gICLVWNKpx5S3998mgRz0rLnC
         FtYw==
X-Forwarded-Encrypted: i=1; AFNElJ9Bjv5HDV/VMdNCDLWewPObcCjy/bUe+mO41NtMuFnwXPx7+5EKp8oZr084ns8fSignkYwZG5i2lw+dDw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxkzJDrymHjalhQvAaQsJs709eTjNMY+iQ1ufqPE1iRblVTYUHE
	edfy8Ij1gely/VLGmr4DgNirGYwul+VbHG8PP+Vy7MosfSHvVK0/7RBnh55JAoqql3U=
X-Gm-Gg: Acq92OGEyWwQSUndzUb/+S6v7C9DW4IWkbHW7+LjBqUmXWih0PbY0usJWYv6g7KosHj
	O9WBKFqIVXEXyHcUS2JqPyTpS5mwvgShcbu6pWPtgeRwT/PieTu3QaGOzfpKzA5hJkv6ztqRx4M
	P4VWAVlNSFdC71YESaA4nPdBor7WsKHy0CNGqtY6cTuAsMmTnxz7DIfArwtno7IPM2wCf18tQZl
	7DKGfnLxVE2DJ+TxizzIUT6U/Ifj9qub6Mak5wRHzlbHF6fUYqhNG/rcW4tSrVZo8eBRKUCZY31
	ZF8/Ce2XIDXSOIpIwF9d0m0w3RbhOkZeWx4pBkRCwHtDKyhmn0durUm/zRGxlSXn2zSRiFp8yej
	TCgFKzfjveL0LgLl51ZYVL/47CPhbLApdWNzTsjU1r+9u+lF59RdPWzkhGs0In6i9NWNx43gzEX
	dOEHsO1imaA44Lc+uUkenQiq4M4K0JBudJ/Z2D3m4Zu1jX9fPaJLTtzJBIxmQ6ZQil1dLiUNquj
	2Lc4BE2XIwlPD1CuoSf8WAAJyBouPn8whc3SA2qFX/YRF8=
X-Received: by 2002:a05:600c:3b08:b0:490:50ff:d394 with SMTP id 5b1f17b1804b1-49050ffd4f7mr128124975e9.16.1779664590868;
        Sun, 24 May 2026 16:16:30 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84164aee7f5sm7552651b3a.14.2026.05.24.16.16.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 May 2026 16:16:29 -0700 (PDT)
Message-ID: <fdb053b8-afef-40c9-99cb-e0a6310d4b8e@suse.com>
Date: Mon, 25 May 2026 08:46:23 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] Three folio-related btrfs fixes
To: Matthew Wilcox <willy@infradead.org>, David Sterba <dsterba@suse.cz>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 linux-btrfs@vger.kernel.org, Boris Burkov <boris@bur.io>,
 Filipe Manana <fdmanana@suse.com>,
 Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
References: <20260522181411.2487732-1-willy@infradead.org>
 <20260522223855.GA29010@twin.jikos.cz>
 <ahDtLYinnFX5CBcE@casper.infradead.org> <20260523140601.GA183694@suse.cz>
 <ahNaEb4XOBPJIZDk@casper.infradead.org>
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
In-Reply-To: <ahNaEb4XOBPJIZDk@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/5/25 05:35, Matthew Wilcox 写道:
> On Sat, May 23, 2026 at 04:06:01PM +0200, David Sterba wrote:
>> On Sat, May 23, 2026 at 12:56:29AM +0100, Matthew Wilcox wrote:
>>> On Sat, May 23, 2026 at 12:38:55AM +0200, David Sterba wrote:
>>>> On Fri, May 22, 2026 at 07:14:06PM +0100, Matthew Wilcox (Oracle) wrote:
>>>>> All of these were discovered through auditing the (mis)uses of the folio
>>>>> API throughout the kernel; I haven't been specifically reviewing btrfs,
>>>>> nor testing.
>>>>>
>>>>> Matthew Wilcox (Oracle) (3):
>>>>>    Revert "btrfs: fix the file offset calculation inside
>>>>>      btrfs_decompress_buf2page()"
>>>>
>>>> Why do you do the revert? It does not seem suitable for this case, we
>>>> use reverts if we want to get back to the original behaviour, or when
>>>> removing a patch from a long series to avoid a rebase. Merging the first
>>>> and second patch makes more sense to me.
>>>
>>> The revert is for a patch which was merged into v6.16.  Since the fix
>>> for page_offset() was merged into v6.15, af566bdaff54 should never have
>>> been merged, and it can safely be reverted.
>>
>> That it can be safely/cleanly reverted does not matter, you could say
>> that about many other patches. If the code was wrong then fix it in a
>> "forward" manner, no need for revert, namely for code from a year ago.
> 
> The patch should never have been merged.  It didn't make sense at
> the time.

You're completely right, and it's all my fault.

The background is more complex, and making the patch more unnecessary.

Firstly that patch is sent and merged just before v6.15-rc1 came out, at 
that time our development branch is based on the late v6.14-rc tags.
Thus the proper mm fix would not show up until v6.15-rc1 was out.

At that time I was testing btrfs large folios support, shaking out bugs 
and sent out fixes as preparation patches.

Without that upstream fix showing in our development branch, the patch 
made sense and got reviewed and queued, finally got upstreamed in the 
next cycle (v6.16-rc1).

However just days before -rc1 came out, I got the reply from you 
answering the question I submitted to the MM list 
(https://lore.kernel.org/linux-btrfs/Z-7I9hOcGzQMV3hq@casper.infradead.org/), 
which already shows the upstream commit.

At that time I should have removed the patch from our development 
branch, but due to other reasons (I guess it was again the 
update/testing of btrfs large folio support), I didn't notice that, and 
lost the final chance to remove the patch from queue.


Finally what makes things worse is, btrfs large folio support came way 
later than all those hassles.

v6.15 fixed the page_offset() bug for non-head page of a large folio.
v6.16 came with the btrfs' local fix, which is unnecessary.
v6.17 came with btrfs' experimental large folio support.

This means, there is no way to hit a large btrfs folio anyway before 
v6.17, thus the local fix is not helping but only introducing an 
overflow bug for 32bit systems.

> Reverting it is the right approach.

Yes, reverting is correct, it fixes a bug (overflow) that is introduced 
by that patch, and there is no better way other than revert.

Sure you can do a minimal fix by just fixing the type before left 
shifting, but that won't resolve the fact that page_offset() is already 
fixed.

And the revert is also safe for backport.
The only affected branch is v6.18, and at that branch there is already 
the upstream proper fix.

> There is no "forward"
> to move it to, other than converting the code to use folios instead of
> pages, which I'm not signing up for right now as that's more involved.
> 
> The fact that it's been in for a year with nobody reporting the bug just
> shows the lack of 32-bit testing (and users).
