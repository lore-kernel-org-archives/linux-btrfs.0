Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793859612;
	b=Pq1GVvcr025hbUQ2Noo2yw0t3ZqSmifA4Wyeto5ztrsV74sQA6BdJUqvZBv7Dd8m7sDC
	 ieG7zMrPHcd199IDxPKLZJW9ylgxSxKigDIdpahqM5krhlb5kQb41EQl5NOKqWHfTONCy
	 /NjKVBl9gMfqh9dQtGBhHjetZxWH1gj+MiWJo87FxXGo6Y7H1JZl02rHDGOqNQRguE7iD
	 PYqetkJIvYjIOw7catbvDmYNRHrYZ/Y2xn22t4LdCV7eao20SzjC7R3KtJMThFiVOl16p
	 uauB4si1CMSmed6Tz9s7bgYOdQw9QmTDW9+MgUlDqiLbBIofqk1HGVUogIjdZ1EihJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793859612;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=WS3SIbAjQ99dz8XPsd+erMN3YcHpcAqp19dH18JDaKw=;
	b=VtDY0Qbmjg19+AwzMdBVc71ALnXwWdWfLaMcUV6q1LT4j2HOgQ0dGLNz7REW5yQJLCQ8
	 9FrOuBkrlIjlwnA+yaL06QAEiy4Plpu3AObJyExi93evp+8fNzYZoV/YVvEQco3HxqIrZ
	 SFxsVMxzNCoEGSgyAYaeY2/cxOAW6JamubcdKQJOKEfOvO/Hfwj9XazAFOWFP4O97EEnS
	 JaGKP/fP2Fods/gtPri73utsK+se9TIB/N+zx6k2Juj84W+rbRK569IfosoFKEYM8q9AS
	 baQIWt+nw1w0DT2mytnpSJTf4gTuPoqFsqPVh4krZpDHt8u8N1qycr6ZfUUpJjz+sdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=CSQx8Wh8;
	arc=none smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3CD7606A32E
	for <linux-btrfs@vger.kernel.org>; Thu,  5 Nov 2026 06:20:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A3CD7606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=CSQx8Wh8
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a20bdaf39cso15103665e9.1
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Nov 2026 22:20:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793859610; x=1794464410; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WS3SIbAjQ99dz8XPsd+erMN3YcHpcAqp19dH18JDaKw=;
        b=CSQx8Wh8TfNl7SGoqVtHcqsq8PsiFxWxfkOnHd+TaEyg28sNrNiVICGMa8MtQz/iiT
         /WK0QhqCA0fKIxqJ/W1D3vGd6GwN+axsQLKJkE2B32X/JZAqeELwO5liY2EfUi0C2/2D
         AkMVg8CUB2154GQx/N98N3L553DNJbfXFcfN9++RfFt4v1wdLvCkF0r+FnNxUnbvRsuG
         Yl7ylOSBt4ulUuDdbOEp9U9hgE9royvbz9XtP8KptjvnSQs8PkjyKqiaGWl5b5CbYUh7
         w3ShAujrBY3SlxPI37vdAgKPmQOuHb6PKpKRulB434LPuGfW5dpI9trKa88ArTh0qLPr
         LqMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793859610; x=1794464410;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WS3SIbAjQ99dz8XPsd+erMN3YcHpcAqp19dH18JDaKw=;
        b=bia6Okf+1Vu2mD1YyfPXedPpky2rf4ulgrRPK5jPWrQj+ZCsX/i6Jf7LH3lfvuzm1H
         IBhgoQfV0avj6ZYrPhCDrX183nXJjX7zZ0wWs5551ptPcQ7dQt21vmhTP6ac1Xf8azrl
         I7DVfHRPOgjYhP3qS/ERd4V2eEpS4XBaePurALXk01wR4UrpOk07YAYp0Si31TKp7Zn3
         L8Pk1HB21sTC5OckzWItsSQ8hyHz+oeXNzmQ9Dm9TUWiqY4b4WMlC5V59qTzqqgFY9On
         CWsJxtck/Ng8GT66+XwWxfJfLmuJNHUWeL8aV9RSbvB7jjBL7Vrp/BOcVNZeoeo/4scp
         C+Pg==
X-Forwarded-Encrypted: i=1; AKwUvBxbdGRlmu8ki21+9VXAGaA0sSkckc8EDPZYSEAEIBOAUYURDp/S46SXd3EngLDbIlwtuUeBDd2Yy1TUWQ==@vger.kernel.org
X-Gm-Message-State: APuU4Z+SkP5+675mDAGVfp4/9MSvbdRjVQI71fF85uBbWj07PvVsWoWJ
	FUFURIhGeGeOY4vdCrVED78un870WXShEebUiV70HE8U3BPh7NXsOzx5glmnHaaYoqM=
X-Gm-Gg: AYBFou1C/qt58GVOaECIo2BJ81Wo6VcnZAN+Tvp9zGSsVmb+57y+1RMh0IqT8rruUYR
	MZTCyA3utZv+gXE6jBZbF1tLSOAYuC9k7lzxiQoUbhAvtdnyxgvTH/IXDY7818How6vBhhpRrCu
	n1E6NMTF4xr48ooWcfGhhh1KgWgb/Bn0FI+rnRTLmRxHpPfMv36exTh8cnAa46jQ6SpufnG/wzA
	yEisU5xnxVG6EPUxE2oQ/+Yf5XLShA3TTihuf4UqdZTMB0beeDjavlpkIGhgxTQtKd1UPhogj6c
	gf8ex56vX42DiSWEzKV6Ea4L3Ahj6bbe7OlE7HsQb3w2gChVRgHCdrXJpXCik12CfaLuO7vdlVD
	aHmLCCYfTNkHehXVRTlNrksej6ErbFJhj5d3GCKr1gnmnAKCsBsp84BwVIsCMFjKKqWgkCDabHs
	G8/w7AWwBp6WMuMdB99Irmk9WknqrGi6/X4cT48Yogx32IwEv/ag44HHUVDpqcEtrCqUf6g03g9
	fiTmO+BvCu11Yl5Ct05hisDaya1RiKWQxKOobAT4hkdVBwRefts5icVbPj9Y+JKKLqAEEIlkD4s
	zz3wAyln+JB23lK8IQTe
X-Received: by 2002:a05:600c:4e13:b0:49c:d019:70c5 with SMTP id 5b1f17b1804b1-4ac1228978cmr375296395e9.0.1793859609978;
        Wed, 04 Nov 2026 22:20:09 -0800 (PST)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b0b323c18fsm2077495a91.4.2026.11.04.22.20.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2026 22:20:09 -0800 (PST)
Message-ID: <0313641d-567c-4615-ba14-7662a533b793@suse.com>
Date: Thu, 5 Nov 2026 16:50:04 +1030
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] btrfs: WARNING in invalidate_and_check_btree_folios, during
 unmount on 7.4-rc1
To: =?UTF-8?B?6ZOu?= <fengaojigui88@gmail.com>, dsterba@suse.com
Cc: mason@kernel.org, linux-btrfs@vger.kernel.org,
 syzkaller@googlegroups.com, linux-kernel@vger.kernel.org
References: <CAO-4RZ0mqFEU8z44B+biaMw5Ee4ogCjs80Uws9YY8LMV7J685w@mail.gmail.com>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJq3ujyBQkUpLw5AAoJEMI9kfOh
 Jf6o8OIH/0mqW+TQM4m2x3hCsnK+oB4yJH1qnGvIhFF/Lhs48wI02sGh6/4aA0hkCDfd9LHQ
 +ci4FUepZ9y4VS01+oIExbg/8ytzGYTzLtb44jK2GBOBVSJkMiha6jp22XFt7WUkT/tvbreu
 WWdGsaJIRQaZChy7xsMI8lqQ2WdmluZJ4LT0wD3l/l6QU1ZseMGySebdY9sVOQEOJNV7Qj92
 /KOAFNmeZshV/qDI8Iw1RTs6TvLqCcqmlZLCmJkYSVhT1RonWRren8xIRcFEgMe004IDnt7V
 qdQhk/nhTS9x9MBAhMRl0TTE1VKDLvVALsud3iZLrmmtYvwPApzGJk052f0m28vOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJq3ukKBQkUzDspAAoJEMI9kfOhJf6o
 SNsH/1ysUWOKmzY0rGS3ZdS61QgqMGhSWD/EJ4UiPw+xO4l4+GtX0fOAqxqsmBKqje3vyhBa
 Z5o/1Y+gNiN+E6RBcSz4b1TAd78sQ2bvT5DWOvBjeeVxHdiuQMIn4S8xk5ZpySBw5ifjoiuL
 0M33UVtJOzM8yfAeL+d/Rp4leJw72SutjkLyZTG/gJIp4pJGD/kFHn24OLL0IxEcO0gOekNZ
 os5e1R6jAJ2ILk7+MDnvU8wXHcCiVzuDhJLI1tih1uUIE50muHQJWbYuVBbdJeu8WlIDDssx
 UOCxLylNG3gDXV5MhLubPTOpp9OiFc/XC37nvkgEcrlmlOFBv4/NJCbECpo=
In-Reply-To: <CAO-4RZ0mqFEU8z44B+biaMw5Ee4ogCjs80Uws9YY8LMV7J685w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/11/5 16:12, 铮 写道:
> Hi Btrfs maintainers,
> 
[...]
> 
> We also reproduced the warning with panic_on_warn=0, allowing the
> kernel to print the extent buffer diagnostics following the WARN.
> 
> Four instances were captured:
> 
>      BTRFS warning (device loop4 state I): unable to release extent
> buffer 6881280 owner 5 gen 9 refs 2 flags 0xd

0xd means UPTODATE | TREE_REF | STALE.

Meaning the eb is already being released, so this means there are some 
races.

>      BTRFS warning (device loop0 state I): unable to release extent
> buffer 6885376 owner 5 gen 9 refs 2 flags 0x1d

This is UPTODATE | TREE_REF | STALE | WRITEBACK, which is also stale but 
also under writeback.

Exactly what the check is supposed to catch.

>      BTRFS warning (device loop8 state I): unable to release extent
> buffer 6885376 owner 5 gen 9 refs 2 flags 0x1d
>      BTRFS warning (device loop1 state I): unable to release extent
> buffer 6885376 owner 5 gen 9 refs 2 flags 0x5

This is UPTODATE | TREE_REF.

Combined with the 0xd one, I guess someone else is holding the eb, not 
yet reached the releasing part.

I guess you have already passed all the info into an LLM, and no obvious 
cause can be pinned down.

So far I'd say finding a minimal reproducer would be the best way to 
continue.

No human will be happy waiting over 1000s just for one single triggering.

> 
> In all four instances, the recorded reference count was 2,
> corresponding to the expected baseline references described in
> invalidate_and_check_btree_folios().
> 
> Two instances had EXTENT_BUFFER_WRITEBACK set (flags 0x1d), indicating
> that the extent buffer was marked as under writeback when its flags
> were printed.
> 
> The other two instances (flags 0xd and 0x5) did not have
> EXTENT_BUFFER_DIRTY or EXTENT_BUFFER_WRITEBACK set at print time.
> 
> Since WARN_ON_ONCE() is executed before the diagnostic message and the
> flags are read later, these observations may reflect changes in the
> extent buffer state between the initial condition check and the
> diagnostic print.

This is definitely something we can improve.
We should ensure the message is before WARNING/ASSERT/BUG_ON to make 
sure syzbot can catch the problem.

I can easily craft a patch re-ordering those call sites.

Thanks,
Qu
