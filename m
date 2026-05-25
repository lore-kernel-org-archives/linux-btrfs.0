Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E85D34A791
	for <linux-btrfs@vger.kernel.org>; Mon, 25 May 2026 10:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779705605; cv=none; b=AvpgCgoUvrM7me+dWsoqm8Qy/SCe6EsY0WU8+Bb8WWlew+jnvBTB6c9YlrKNF1KV9FAYFa49WZpxvxj3cC6F3JVlfAw488F7R1lQSvamBSlp6vRel1Wb8KlTqmRsk6+d2i83WWbjYvegDBM4Flh9iJJFTQDbuai5I6QXewII30g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779705605; c=relaxed/simple;
	bh=1WQxn63NIXtnCgMXywNRTdDL967YTuGaNIhWaIgrmvk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZN/kr9ZEDxuev9D38Dj2ogpTUDcClozq+xwWx02TC6799lzrIkUdepakH+FwYihnBxUgvhWL8ddNutG/ZeZknmtlJEi3SKBjewXRdmloHd4bBL+9f1kmt5q5nj9W7ncrcWKFc3d4AUXCzmXIqIeSnZxfyuaMxArf8vd+swjIyao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=LTk1mCpV; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="LTk1mCpV"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4891e86fabeso119541085e9.1
        for <linux-btrfs@vger.kernel.org>; Mon, 25 May 2026 03:40:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779705602; x=1780310402; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=wAna2ci1WHhIvRqtMxw+zCNowh//V2ruxkoScYbJVwI=;
        b=LTk1mCpV40QE3SjiXexXB1QcmN9pyD+AnePJcS80eNFEEbCQ0z2qr3H46oHaRES+/J
         vbjidfv5D1QxzqglvbGJXuFoQbJqVP7e+/OH78cjjrtmJ3s5e+3tVUl/HCHJ9Jty041x
         aWRh6+1IOhgAAo5O3EbcSvIH16HGc1e/1/pDEOH39HGO77n4GORfa6iBClqfZZHiVLCm
         vuiUOBScuvhbo8FgW3EXXDT35kPtBh5FnxzRfKuLxD6ng/VUkYExBs/LAd3qDwrzi/vg
         IKVebBbrObu9XUi7dX9PsKv1jpP2tScEfVtziZWzvWiU+S8KvBtGcnJGTUgjvJFEwrEP
         EC9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779705602; x=1780310402;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wAna2ci1WHhIvRqtMxw+zCNowh//V2ruxkoScYbJVwI=;
        b=A3ZNCXDssD9AQK7UyIndjkHAhrtLmnvLJDSCgK/NM3dHs3EcpkNuzB0xwZjSApskLw
         1PGFbpHb/MRiOEfleQeNot17Dhw3BKKgl+Cgn5hoCNMLtz9dUa5faMc0yjKMKd1xA2fW
         5M5Gr6n8w+tTBkL0A2UbmSrcGZRMm1MhrmiXH0+HKdxWOh0OvFtZRy6T3CNBMO6YK+vv
         l8rcF8/1fSngVlWUcXfN3l/5rtrCRrjcD7VvN7hykcWom9MUEdST2QmRKKspqktzOSne
         7GKKbG3aEdwct0H9vSan8vY7z31QxQQLco0/eR5faxh7w9W36wFwOtS97X4z4TuhXq0G
         X2ZQ==
X-Gm-Message-State: AOJu0Yx1SU+V33KUAWH/VbJPs718O7AEu3plUudzeBoMKeuX0vLUgrHG
	7BLr6pHIdPPMY9rzfyuCMJq3cFR4Nl1uwPfJdMuv6/tshdHTDsUevRtnYKIXg9Np/pw=
X-Gm-Gg: Acq92OEo4E3bHSfnNTWeTUvoaw4IgNiqL768fjT9r0pK2Z7Hema3c9hr+mf/mFaIBe2
	O0Zpzgr2S0kcCKUHUaJcg3+mke3Ra9tyzA+FJ3JPlEWOhIlybBrT9FchuYSKQE1iZzP9a/+19iX
	RGpK2OU/h7RL2+OCZMc0vAIR3xdWw6rOAwUrcjXQVFgU6lckiGsvH1KgrOSZCFfztO6mEMBXPqN
	9SQBVd1zgSdbB/TxCx+xLLJq/hkBHnk9m7qCTpuH1W+ngN6O2kfWZVQ9rzL7QdZ8KCAb3HbqoRc
	F1o8/EOLT5lDxGh7BYBtJLRzWWL7uKTHtxYbGfyNzAYlrHb+lU9jPmJePaoxjtOjTOJgRx5WeKZ
	aKe79DlEw4kNhCZdUglbz7+vnADRbvKxPZWlPasYAXgC9WQuy6tOAS+fZNCNcsMgb0QptE5CFkJ
	PCn2ghS4sqXZ711a/MfguWg4t3Uw5wZTnQk+K++s8SxT2mdBxZvMYemKmdjSBDJiFC/DKHyQ7Bq
	h7fQ75ZCfxmAampCR8Ll/nym17+jU6mThuu8ZVZiViE5TfQxcxDpCpoKA==
X-Received: by 2002:a05:600c:4f91:b0:490:6e12:a40f with SMTP id 5b1f17b1804b1-4906e12a673mr7412805e9.12.1779705602494;
        Mon, 25 May 2026 03:40:02 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2beb56b19f3sm121469395ad.18.2026.05.25.03.39.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 May 2026 03:40:01 -0700 (PDT)
Message-ID: <e5eafd64-2704-42de-ad7b-e4f170c451e4@suse.com>
Date: Mon, 25 May 2026 20:09:54 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] btrfs: disguise single-data-RAID56 as RAID1/RAID1C3
To: dsterba@suse.cz, Christoph Hellwig <hch@lst.de>
Cc: linux-btrfs@vger.kernel.org, linux-raid@vger.kernel.org
References: <cover.1779412152.git.wqu@suse.com>
 <ce02ebf8a9a6f5e2357b838df9d7ecce1f0cfd4b.1779412152.git.wqu@suse.com>
 <20260523142344.GC183694@twin.jikos.cz> <20260525060030.GB3370@lst.de>
 <20260525101707.GV12792@suse.cz>
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
In-Reply-To: <20260525101707.GV12792@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/5/25 19:47, David Sterba 写道:
> On Mon, May 25, 2026 at 08:00:30AM +0200, Christoph Hellwig wrote:
>> On Sat, May 23, 2026 at 04:23:44PM +0200, David Sterba wrote:
>>> On Fri, May 22, 2026 at 06:53:53PM +0930, Qu Wenruo wrote:
>>>> Recently kernel RAID56 lib is trying to remove the unexpected
>>>> single-data-RAID56 (2 disks RAID5 or 3 disk RAID5) support, meanwhile
>>>> btrfs still supports such setup, which means in the long run btrfs has
>>>> to handle such corner case by ourselves.
>>>>
>>>> Thankfully single-data-RAID56 is really RAID1/RAID1C3, since data and
>>>> P/Q stripes all match each other, rotation also makes no difference.
>>>>
>>>> This patch will disguise those single-data-RAID56 chunks as
>>>> RAID1/RAID1C3 chunks.
>>>
>>> I don't think this is the right way to fix it. Calculations are an
>>> implementation detail and should be done at the time of the xor_gen or
>>> raid6_call, not touching the upper level structures related to format.
>>
>> It absolutely is.  Adding fast path workarounds for this is completely
>> stupid when it can be trivially handled on the mount side.
> 
> It's a lazy hack at best and fix on absolutely wrong layer. The library
> should provide the support for the edge case. But we disagree on that.

I strongly disagree.

Firstly on the layer to fix, let me be clear, if something writes like 
RAID1, reads like RAID1, repairs like RAID1, then it's RAID1.

With that mindset, changing chunk type at read/add time is exactly the 
correct layer to fix.

Or let me change the title of the patch, ENHANCE single-data-RAID56 
handling to get rid all the corner cases.
Do you still think that's the wrong correct layer to fix?

So the wrong layer argument doesn't stand. If you're so focused on 
fixing the problem in the library layer, then all you can see is to put 
some adhoc fixes to emulate the library fix.


Furthermore, we are already doing all the warning about 2-disk raid5, 
now I'm providing a solution that is as mature as RAID1, now you're 
complaining about the simplicity but wants all the complex striping and 
reduced read performance?

I don't see any point in this.
