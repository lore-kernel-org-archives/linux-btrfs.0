Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030E2396B99
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2026 21:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776116806; cv=none; b=g+fhxRVPnklZ+ubhDxZnVGgPDbq5ESBRHBKqMJ/hujeCM9ZEbTPk2rv0vbmo3kNkPzvkmph2XkHr+bF59ZKXde5jecYEzYBvu9UjQNcQGYdrGvqsBJlpwOP6x3Y+bhDf8qeWjNKcqyS/H61nHSHQJ1vgJBTGklj/ote8BLDZBZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776116806; c=relaxed/simple;
	bh=8o2rjkyvL5DIMtlHATtYeWwYQ5B8OAGJmGxg7CfpRVw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=udJKijqRNoBR+dvyshsKbet1L7fpqmJ/hT7qFbMnCarahZ2r75bFDxfBnouZRxVqNde8U2EOys/PPT57sJ1xDJ3o6AcvcgoNz2mzReo1EV5TZxS3PChrH+/X8hrYwZHOSsbk3vrpAS6QfhjV/CJ0CaUTAeL9gT1WPNkqyecljoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=YkimFq+i; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="YkimFq+i"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-488b3f8fa2bso52152815e9.1
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2026 14:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776116803; x=1776721603; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=KRvkZx9gJNxMFYPvzURcRtxTAp51vzFumgPpAEGeJ/E=;
        b=YkimFq+iaeBYIPYb5Eb+ZhjkwuEyt5oYJ3+tvuWG4uuTxcpuwIkEbGW6RK9xEaOlJO
         su31GferVPQrF3BA7P+r8FNqpqyfwEYNC9GxWrxP9R35w+NQ7iaAy0wIvEcZBunZyK1n
         VQtlx6hMUjfZAOM7rc0kfbHk14R0l2BKaEOsMojXCOxAaQQihqPsCCmGos647orzpoui
         sfThzC/V6l6ochfw2h5cZHmDrI6Un537uE1IIf46pev+dbgALLN6yHE59BJ9/Wt9T0Wv
         s75KKXWTbCRL85HhURHE2fy7j4u2E3Y6KKcI63AgX9B38T86AOahBLFQm86YTFfBDe6X
         facQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776116803; x=1776721603;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KRvkZx9gJNxMFYPvzURcRtxTAp51vzFumgPpAEGeJ/E=;
        b=KRN9XP4BNMfld2KyNY7ve5B33g05j21zlp6SL2gyebumZs/imRzBjfGY9Tu9LQB/Nx
         tiJweHCfkBYs7Sfq1w8mDu3FtMk3odpgE4oWUAW98q4N5rez2sfGXoijnntwCLIAliu2
         OMe/pAwiOuP9AlG06DBLFqFFKynrJN7kbE1JOq9U+a+4ddprwI8qthngfo2pUpMfiaMW
         QqqPtYThKNgFBMhgfNR1YXpIrbuwWwxHAUjmy7n1iviPcfrJB1vt4fZ/ZsPNDH4Rzv/w
         uXEK2xUMsenLmq+VqhioONXZwn+UIdLcQP6QpMu5HtJUUUXNw+6MaWk2m7CD88vZsisf
         K9xQ==
X-Gm-Message-State: AOJu0YwqmEb0auJZSfoHQKCNe3d33SyIS71Q22c7wEstQoJPbfCft+y2
	oJpEeD5PhEklqNcus9vzW7NFScFAZ4IZ0e+yFK7W7rGOm+aRg7v8CTU0O9uQmR61JT8=
X-Gm-Gg: AeBDievXjQXCStiGG0KsghrHPpBSiGHAy1PF7XPGFfk66BInOsZdXXgZe4DlqEDQOCh
	VuN68XGw0nZxy+cYEW//rs8Ve1HNPfs6pa8m6t0Ae99AdRf/Jk5Y6T8HEnWbOsZT0CUCHSx7qbO
	nETCfb58D626/3f29A//a1+1jJkQIva4fM996PzbI+Qm+4D+j5nhuWzdwBjZbABbDasySagcG5A
	NX/AT7RSEsUOBCf8crSgxm3g2/TUePDHmTL5L/GzdsExT8YCBPoaCD0VXpyXFCLiGyrzGwBUEcx
	0Ny6tvdy9E8BASstExgI/YxFi+zW5Rd9UioU3Tq0F5KuKyyqY2x9jcobejgMPdO4niwt3NAnOCp
	cRA3o7wwpTjAvQwuvWFomhtt6UQwCS2372pjOwj6FwwHw858YvCdyE6Pw2PXaqn06pRwrP9vypg
	PEmkSFLcLJVnN9K7zjsf0LMGdhi2cCKmti5rTOcpg8JjLUtmCCo/mJ1j/W4sVx5A==
X-Received: by 2002:a7b:ca48:0:b0:485:3038:72c2 with SMTP id 5b1f17b1804b1-488cd6aa4fcmr209317915e9.17.1776116803170;
        Mon, 13 Apr 2026 14:46:43 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35e581537afsm8669435a91.10.2026.04.13.14.46.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Apr 2026 14:46:42 -0700 (PDT)
Message-ID: <5053d185-edf0-4777-b7c3-0516e0893f02@suse.com>
Date: Tue, 14 Apr 2026 07:16:37 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] btrfs: remove COW fixup and checked folio flag
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org
References: <cover.1775621833.git.wqu@suse.com>
 <20260413174912.GA12792@suse.cz>
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
In-Reply-To: <20260413174912.GA12792@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/4/14 03:19, David Sterba 写道:
> On Wed, Apr 08, 2026 at 01:55:30PM +0930, Qu Wenruo wrote:
>> For experimental builds we're already rejecting dirty folios which
>> don't have ordered flags since v6.15.
>>
>> Unfortunately we're not yet removing that COW fixup machanism for
>> non-experimental builds even at v7.0, as there are still some error
>> corner cases that can lead to dirty folios without ordered flags.
>>
>> After those years of testing, we're sure we won't need COW fixup for
>> regular cases. Although I want to remove the COW fixup mechanism after
>> all known reproducible cases are fixed, I run out of ideas.
> 
> I don't know if I understand this correctly, are there known bugs that
> the fixup can catch, but there are not known fixes/root causes?

For example generic/475, which injects errors during writes, with enough 
runs you can hit the cow fixup warning.

But that's all, the write will be properly rejected just like a write error.

So after this is moved out of experimental, the COW fixup warning will 
be the last thing end users bothers, as when that happens there are 
already a lot of other errors before it.

Thanks,
Qu

> 
>> Furthermore for the future of huge folios (order 9, 2M page on 4K page
>> size systems), we can not afford the extra bitmap for a huge folio.
>> In that case, a huge folio will need 64 bytes per bitmap, which is no
>> longer a small amount.
>>
>> I believe it's time to remove the COW fixup mechanism even for
>> non-experimental builds, along with the checked folio flags.
> 
> Yes please, it has served us well and caused some scars but now it's
> dead code.

