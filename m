Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23E2937C0F6
	for <linux-btrfs@vger.kernel.org>; Fri, 10 Jul 2026 05:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783661683; cv=none; b=VDWJXODvaZxmGV8h1bS26e1r1dlrQUXOufkeAR4BoE//YznnHt8/PSH0LMe7i4WdnEebaDDmUmb7JMm9BD1ddih+uMRFLnba6BZdNyAYsJjYA4aPLDlPrz3ElbYc87AyGJnin71XXBtQ5LkLZ8U2eluR4UoXslPTY+7wLKxlRzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783661683; c=relaxed/simple;
	bh=JxbpD1E4tT1RyqVe6tmL1wB0+hqLJgwLDCumbCOxXx4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nNODYPHPdCoIk2YyK8zGuvjEW981NhVeqgxAs54JkKsJ+py8QJdWDXspvPhKzV5Ya8jVBWgKQ4yH7IDd85V2P5+6ulX5EAL+94qvok5cKa4MCYshAKjz6mhLoc77G98jNd1jToA/727a/HcIA7kwYN2G3l8L/rPQtr+q4czByzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=QfC1evPK; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="QfC1evPK"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-493f431e317so1232895e9.0
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Jul 2026 22:34:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1783661679; x=1784266479; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DV3Epcurh9NLBk43BDCGlPF6Bjs7dhb7D+oA24locrg=;
        b=QfC1evPKpYLlRpJ0oFJ3+lKELa9ek0Npd6RUruZINdTo1EIKtJ9b0KMSemsJjOtuwt
         y5T8z9SPkh+cPYVTtqX3I/+VZisTsvRWvE3DrHIZRBzf7Kw/+E2TAHAj3r90HDVpPYxH
         5pZM2aqpDA15uu0wjVv44zwbgi2mEb5i6DgZfahzX0zW+ouW6v0SVb/Gdhu3C/PJSPQN
         iq3Zy5GZJdIiQQtAnGFOBQf1wB+5Ffd2O99tmzd4mKoUStBRr8bnWqIs5PgADdVTCku5
         Lia8W6nMPk7pX4MESJ3tNiD+/RZs6vfMxT//BCGw2H13KKY04k8ffNxPO6/yFGGKytYv
         3+Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783661679; x=1784266479;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DV3Epcurh9NLBk43BDCGlPF6Bjs7dhb7D+oA24locrg=;
        b=HzCm1xZubwha2S+QnGZL3SuoLnHNk3Z3nzwebW76IF+Y5WJ82EJp7IIPwXYMs15KCC
         D5v7Za3QOSw69YAvtqvX5RSlA3uoA+61NWoplbX+AXCCIE8S2Ql49P8TfYbCVPSczj7l
         AIceHd6Qp1BRDJm0k3YKVtJ1QQYr8aO0nNrfWxKm/wytsKWwKYMQhuSgiZJ9H81a/mUM
         LihUI4/wqwrTuV4q0yr1zgtS3zhMFuXZ1Qlp9HQ3j1sSueNnvzrwBfdXxOn7iCkHKMBc
         SgvsZW1DduhHKvjlb16dW72TnIaCAuvYCi3QujcT+l2kPQH4ZzkcA97U+FeMS2R+zpVG
         W0cA==
X-Forwarded-Encrypted: i=1; AHgh+RobCmcSxj3K3ZIjk4MAtTygGL/S1YvpTY1p/xvLuRgk9NvpXMv3++qxyieZBXMLZwcSQSBF8A8Y8MuLDQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyTX4JpN79qAkguNPfVuQJB7Cyp6qC8ULLRPy9qP6KyLVVYIqvw
	9un/DPAmjtW5gYeR16fxbnfAqVarw+XRfMRgCTEN9s64gchDFdJkGzJVWGQ5dSyB6Go=
X-Gm-Gg: AfdE7clACoan5DtANq2j3LeYsCBS6prZxMkx26nRpI8mg+F2m7v2zjz3B/o+ae8YHQ0
	Sm9E21RUaW7WCAMI3la07+WImphSrre8kvRp9uepqco7ah3NyC7nvFNjslVkpCyYu67tUZrzqUj
	eR3v3qDoZbt+QNhzUOMPqJBjMwkwvayZ3uHh+HefZfuidBUiQ4KJr2es4FYuQpyZkEilLocs6ja
	62a1KMqs3PxIjnULkz59de/DW1TRLZsBkBBtKaTJ43AM2O9djinowWyasS4QwF3+E9LPi5HldAx
	xNsewD6te2p39rsrf0xVPCeHV5jGS8lbJ8nR1UHOZ4HJKAHHbtoJnZaTlUSK4gbHzRjTbOBEPJw
	urzxQRfKW7lAy60R80yPHscP9/c7hZZm54FDEQE15xypJzKBTpaWxyBoPJNv0Q6jfcTnbTLtgo/
	n0qsaHVA==
X-Received: by 2002:a05:600c:8b2b:b0:493:e79e:da6b with SMTP id 5b1f17b1804b1-493e79edb81mr91995685e9.21.1783661679319;
        Thu, 09 Jul 2026 22:34:39 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31198cb2b99sm17770964eec.26.2026.07.09.22.34.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jul 2026 22:34:38 -0700 (PDT)
Message-ID: <6a027681-7ad1-4dc9-b713-07f79eb0c0c9@suse.com>
Date: Fri, 10 Jul 2026 15:04:33 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: write-protect folios during data writeback
To: Christoph Hellwig <hch@infradead.org>
Cc: Boris Burkov <boris@bur.io>, linux-btrfs@vger.kernel.org,
 kernel-team@fb.com, willy@infradead.org
References: <856f2a691977072386085d768b7929520e1022af.1783570200.git.boris@bur.io>
 <27264cb6-3172-4cb5-819a-705a3d607cb9@suse.com>
 <alBw1EEcqAVuD8zo@infradead.org>
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
In-Reply-To: <alBw1EEcqAVuD8zo@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/7/10 13:41, Christoph Hellwig 写道:
> On Thu, Jul 09, 2026 at 03:08:49PM +0930, Qu Wenruo wrote:
>> Just to mention, we can workaround the problem, by extracting the real work
>> of btrfs_invalidate_folio() into a helper, with a bool parameter to indicate
>> if we're called from the writeback path.
>>
>> Then we would have a better chance to rever to folio_clear_dirty_for_io(),
>> but there could be other things involved.
>> So I'm totally fine with the current hot fix, but eventually we will still
>> revert back to folio_clear_dirty_for_io(), to align the code to iomap.
> 
> This has nothing to do with iomap.  Normally the dirty clearing is done
> by the generic code in mm/page-writeback.c.  Gettind btrfs to use that
> instead of the horribly outdated forked version would be a really good
> thing.
> 

This involves a lot of technical debts, the main reason is that we have 
two paths that can writeback part of a folio:

- Compression
   AKA, the async submission.

   I had a series converting it to regular submission, but still under
   review, and the current version is still a little complex on the
   OE handling part.

- Zoned write
   I have no idea why we have to do it in the first place.
   I believe WDC people hit some problems with the regular writeback
   path.

The above two paths all lock a delalloc range that can cover part of the 
tailing folio.

If we call folio_clear_dirty_for_io() for all folios inside the range, 
then the tailing folio will not got its remaining part written back, 
because the folio is no longer dirty.

That's why we have to do all the complex per-block dirty tracking, and 
only call folio_clear_dirty_for_io() when there is no dirty block left 
in a folio.

But as Boris pointed out, the delayed timing is already problematic. And 
the current solution is the manual folio_mkclean() calls.

So I'm afraid there are a lot of work to do before we can get rid of the 
existing technical debts.

Thanks,
Qu
