Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51A3D48164A
	for <linux-btrfs@vger.kernel.org>; Tue,  8 Sep 2026 21:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788902890; cv=none; b=EFwZ30HL3f7+EfEAjj/fk7W4+KSKGlEZhE3bZYvVhwtOHdyZ4uMMFW0gyss062O80m5djKCmxY/95dnnaGIW6IT+1lt8YhwU6VCjkQ+b4PaWqvpyA1BtRF6NxWbLfi4GzswXWck8BNMb79e5SMcWMWB73nWzUoYgOGeYZM/oGhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788902890; c=relaxed/simple;
	bh=v08jFI8b5cSETLw9KdJQgXBFXjyhE8jAYjPPRnwR6TE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ezFtLiGgGvwHQhnrmcLKRFo97LhCJrvnGemp7XNiEqjpbvYCMZou1MNcJYUaD3iZUhIp33m2BE85ERZPs9a0hIH+mdmixSHWcFNEqRFezoonYdf0lhyGoZKaoh128lhUUCD1BM+L6UTLRaXf8PxpO4W3xkrC57zfbeP79AlO0DQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=RcHITTkE; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="RcHITTkE"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-49cf4f81d86so40365485e9.2
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Sep 2026 14:28:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788902886; x=1789507686; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Jn1KZqYu4zED90VbwL4OFFCzFD1KT6LWPxOcx/FIQSI=;
        b=RcHITTkEMP9RMCE7vAht/MyDPTj0qaQ8GO8uFz1tlnQq7YBjQ7NOyfwSqmFNLa+APf
         EK3d4Zv2rqJYp44HfIv87o00jCqVc5ssID5q6fN/4o403yjqXF5Z287k7yz7eTJppI/u
         R31SU0A7uSbaEE2I4re4n3hc9b9lXhyXDY2OV8gM8Gpyxpt/En0UG+i3Skx7uc21F1Hc
         7ly1Ql5RNi0yZVqygm8QnIlXhya+R157D6OH3Lyvhr2sFTYBtSOUws8g1SiDq29FcL1x
         H43N8D883yHYysHf3woYURVJ/5P79aqZE8TWobJ8kkfutjIorsleprodpzhRMxE5x2zl
         sz6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788902886; x=1789507686;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Jn1KZqYu4zED90VbwL4OFFCzFD1KT6LWPxOcx/FIQSI=;
        b=gKG/xHecykPcD+nxfgE2R22CpuED9IbI45BUtaZonjnQANo+DCYvzk5rpMqX/ysfHQ
         6xbcJe9+ElbmD0a4UVS7ov4E5PmXMq8TOB4yQzx/HAnlucxTP65E6aOQxZgLAfvtBaOl
         D3ub3nZGORs2FIl4XhzdD2TaQ8H7BvDyu4ahnAPa9EAKrAGUabutqPrNo0kS07+Q8rGh
         SxrC9nPHe0ISO6aq26bS7Qz0Ii3W4b2D2VuvIVthGzFR/Pqiat8BQkf79W6bSJrvjAab
         0dRrMKMfI+IyBXaK763HcxO5TcbBasEvO543focvUgT4BztsxbTre+LTeJz//YzzgKnT
         jtfg==
X-Gm-Message-State: AFuF++mk53hV46hi7nPTRKxZAvx7wJ/BjgjqyxkJh+517SylevqBAh/9
	X5Un3cMJSV2U60pGe9/w/zwLhRb/sXZM0SHbUlXh7YreU1Z1T9Q1IwJ9qJphC/gwqQ4=
X-Gm-Gg: AYBFou1elKSVug8XWgEe6gxnd3/Tj76CpwqLfx9LnDYCCkDW8Z4cWeQAX7b+DFxG4CY
	JnlpkM1+t7cUV15DVGP7wY/hevJfc5HAB6fl1ykVSpt7MCmueeaCA/u8H/9KlJomrcayX4sXP9L
	StQfNgIoxcCSzfpBLk99xGgKZ/Q4nwRkl/dZCzI9XNwoHqBQaukFJ29hMWj4ZpUXDoaOyR4jRxF
	B1ftIrrcp1go7TuhFWEZhNyVbzhdt9Dlj2xd9OqThL8AhDxMG+LNfqBDon3WZKIbUazNu3NEy8l
	c1zz/6uA/iucFM4Fz+83Flg0tP5msuNmpFhS0FRyG+8plTZIJpjCKDicBllFt37V7OwuB3JPHQM
	xMdPOb51+W//EEvnxQFWsKXW+BMaNTGyNWsiBL876gaGvqn8hyFikRIfTWCztUun1+X5YzaTMB7
	Y4ke2fQW4Vw7GYoMCpcsHarGYiGiS+TpdFoMNugX0szlVBbpOAcRcH
X-Received: by 2002:a05:600c:c173:b0:49c:fc6c:be18 with SMTP id 5b1f17b1804b1-49cfc6cc0b8mr287757495e9.30.1788902886351;
        Tue, 08 Sep 2026 14:28:06 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339b9f68e4sm41806114eec.24.2026.09.08.14.28.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2026 14:28:05 -0700 (PDT)
Message-ID: <962e0f59-ca17-4467-b762-0b225df0d25f@suse.com>
Date: Wed, 9 Sep 2026 06:57:59 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Fwd: btrfs: OOM in split_item().
To: dsterba@suse.cz
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <nka8fLGwxf2NcMXCcuLi4CkGSIKrKG4Sc9IbvTTBG5L6T63w6tImgOKYEmu-pWaoZZFO4Eqg8zDyMggihfvlFRTd1Vubz6E52PVEhU83gn8=@protonmail.com>
 <250decb0-d940-4fe6-9b54-d06e1b293a1b@suse.com>
 <20260908131439.GC9053@twin.jikos.cz>
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
In-Reply-To: <20260908131439.GC9053@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/9/8 22:44, David Sterba 写道:
> On Tue, Sep 08, 2026 at 07:45:58AM +0930, Qu Wenruo wrote:
>> Forwarded for archive purposes, as patchcheck requires a link: tag
>> following reported-by: tag.
>>
>> Meanwhile the original report is only a private mail to me.
>>
>> -------- 转发的消息 --------
>> 主题: 	btrfs: OOM in split_item().
>> 日期: 	Mon, 07 Sep 2026 20:10:56 +0000
>> 发件人: 	xavierbachmeyer182 <xavierbachmeyer182@protonmail.com>
>> 收件人: 	wqu@suse.com <wqu@suse.com>
>>
>>
>>
>> Hello.
>>
>> Attached is a kernel log entry showing a strange out of memory issue
>> that rarely seems to happen.
>> It's kind of annoying and makes me wish GFP_NOFS would go the way of the
>> dinosaur.
> 
> What is the story behind that? One way or another we will get GPF_NOFS
> semantics, either the flag or the scoped NOFS and this limits the
> allocator.

No extra follow up unfortunately.

> 
> Using 64k nodes is problematic and so I'd rather people not use it on 4k
> systems.

In fact the only problematic part in b-tree operation is exactly the 
vmalloc() I'm fixing.

Other than that I see no obvious problem related to 64K nodesize on 4K 
page systems.

The way we handle metadata is already vmalloc() like, we allocate page 
sized folios for 64K nodes anyway.
