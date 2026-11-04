Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793834279;
	b=LVaCwqluPW6olsOmn6SJhkyeKweLvNYJwdKLCYHQDG0Sic4dbDA1/iMgIPYKtTy8Iy3D
	 ZmkJoimsPBuqQic0X1SFMNjvNsA49v3vVhlyLkF5K3E6oZ11/ea3fsBu1wa/vznHm1Ye4
	 UZH8EE2+fdcQyURgb4owhXlqgW1oyr+zhOgKmN0zLQ2xGg4K0kpq550/biYupPS0y+Cm4
	 VTWknsDUfyB+AHWs+5soRJRxMoAD+pS2Kuo7/vlaYmIPlQjsjaZKt4lIwdv/qsOxKtrMc
	 I6CjxVA/PTdPdNadIAgHwaQP7Z794ISdE+yAXEdFfxD+5k8rMMxBpDypBVly3MF5EUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793834279;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=zZNrbK7xCpsX/+SwnMbHs5tGEBVmvI4/q5QJu21ZvLk=;
	b=xDYXylWIEN4uvWfc446gTdGdSNZOKhAxEaxDMOPOHoNLXCf6bJJQHh/AH9/zANL+DkiR
	 bFDFkCML9cBj4DpqPs0J8JNKvuzVCRoDjODW2o9b2/RWY2sHaFBFYclSKZevBV7g2xXzz
	 PrObZUzayYwk0D6uJoubonwVxtZ0SZAxCmKiWVDwWB9EaGp1gzd0LPgDpGIpOyuleJMzQ
	 NLJQTCAN3Y4sBsoQw0EpIiNZkGiMiUXkjh1XocFep9xPfCyrTVJX6SYnsU+uHELSrB0Jr
	 N3u2ZEEiAUO2RXF2xlmw55uKuM5AIXft63/MLWE9Qp4ltNbIQOpVTSng8EBQfFTLYYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=UQhpWG2k;
	arc=none smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98E82606A31B
	for <linux-btrfs@vger.kernel.org>; Wed,  4 Nov 2026 23:17:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 98E82606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=UQhpWG2k
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a2167bd087so10333145e9.3
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Nov 2026 15:17:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793834277; x=1794439077; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zZNrbK7xCpsX/+SwnMbHs5tGEBVmvI4/q5QJu21ZvLk=;
        b=UQhpWG2kUPN2piNKqRd757NuSh9dHcLTPq3T2KiyNmpFj7K2QibCYBs2y/gjI2ei4s
         CyWm2ejNQXb37v75rUhbH3Q2utEiDJahJnyD9FdqtC2ftEilq4Xt956QmBf5spoch8hI
         TX1kYRfDZSHu4FzoKNKw7canlEw741Vb/i8JCg5i3Zy05B7YSQD6pIHborkBLWpjA4jJ
         kGSvefoNKPl0eiT31vln51yRdLeCtxR4KlQL+MjTR4fVYIpY0SnFauCF5NFs4DU8N/uC
         EKVt9EvEvkCtkNgERBMca4asXq632xwimeamoG2uwZLgOYmvwMvoneDuUbrGGqcq2S/d
         /cfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793834277; x=1794439077;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zZNrbK7xCpsX/+SwnMbHs5tGEBVmvI4/q5QJu21ZvLk=;
        b=J1c8I32/oMByU+84XmY6Z6w2Y1fKLrxXLBHjjLPey6atfBL3dT+iaCW1t1Rbyx48D8
         XflJO3cs80Ug9HKGObxlNQb6nXZuxzma70V9uTGKqP56Opf1OA67nM67W2OojnmHQYNy
         tQRtgX4yxWPNHGVO9djFnYkWr1MHKmlSNCDVtqUh/+GyidrdP9xJFVvAEmT97qGNQn+R
         +pXBahWDsVuzPu5pZVhbaZIC9jYPkvV3UT4vDeqYSdjYmr4d9z/XJ5ZQKIWl+dQmcMZY
         WDGRttS0jJJV2QBYZhIZM/Pz/lQh0ZpwWKYZohQlCriMBSQ3kxN1jH4CtffJ3DwJpFxS
         F+xQ==
X-Forwarded-Encrypted: i=1; AKwUvBwp6uON2aH/x19zmqEWcbVbh0JeArNdP5oOBsuCiPUa5hzjKbyZ5ontI9d9PMCVtsyBWtwAfVeW0Sq6bQ==@vger.kernel.org
X-Gm-Message-State: APuU4Z+n7dT0E7Um3qO4EgUXnziRUx9Z2jCLlKnkcm3mR4sskKHzSn3j
	MMrs4ESxziRDqan3LnAtCKqjcLUX+CrrGWZtkqzsCOiYi6KwFMxQPg8l2c2T6+XrbmWu/+LG2G2
	uckERx6s=
X-Gm-Gg: AYBFou3H9LdOStODf/Dxra3YlxG+nyhTRNnGI2w3FP7J0DI75GMHmEFa2DAMdOJY1Lp
	CnmTkdcm4Y5BS29iOPfF5+PM8NkiJuTXHg0pkSU2AHc5xSarpsGmDL7rFX0NqZ3WpdDuMHkBTEU
	XPLsK6Lbhd8fubOjLVkTbniwBvaab7HSazK0knwl5+qzkl+UIFMzRqIAZqVrcMlYZBXoiy0ucxD
	e7lgveMdFNq2Rgpm+dfbvt6EOa9tQYJqB33TKvdtnWGER/gO/ER1BvoImOXrE6EoQGJxtcys5c8
	bhiWIGaHEvRuDA9SMCt7Ern00GPqHYQAL/9NgT6vDj+Xz82xhMAVryXTr/AabATQW1X36kf/ODp
	/8nRBDZ9ZIvYi/n5/pyUnVhPA73peUYgNGOeHA3hU3Rng7XKckQn9U8t/ZJHlPbbcg1FggkVYTu
	nw6UuXba0npEQ5FIX2/gGG77hB7zDupo4MP2C/QBiRwwyUoJB6pfdxQj8jRT4KGYI2n2vmaaw5I
	VlH898VSZLLyrxx2U6nzDpdIPDwA+9VOat6ptYwxVZfxY5wUCBwZbkXTwGJxa/5qPWXUSSX0klw
	746Lj9nXhSe50ne4DhpiiaM4TiSpVrRE24Si3ioUTQ==
X-Received: by 2002:a05:600c:46d1:b0:4a1:825a:56fd with SMTP id 5b1f17b1804b1-4ac18a88fa6mr403102625e9.32.1793834277013;
        Wed, 04 Nov 2026 15:17:57 -0800 (PST)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36ca38fe477sm9676561eec.17.2026.11.04.15.17.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2026 15:17:55 -0800 (PST)
Message-ID: <761c20ac-4d83-4f00-bec2-b934dde5ed47@suse.com>
Date: Thu, 5 Nov 2026 09:47:50 +1030
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
Subject: Re: [PATCH 0/5] btrfs: owner refs and tree blocks
To: Siddharth Mishra <smish149@asu.edu>, Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: dsterba@suse.com, boris@bur.io, josef@toxicpanda.com, fdmanana@suse.com,
 mason@kernel.org, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261104102323.4090290-1-smish149@asu.edu>
 <9de049c9-429b-46f8-90e7-02b30d2e91ee@gmx.com>
 <20261104231622.3492838-1-smish149@asu.edu>
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
In-Reply-To: <20261104231622.3492838-1-smish149@asu.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/11/5 09:46, Siddharth Mishra 写道:
> On Thu, Nov 05, 2026 at 09:20:51AM +1030, Qu Wenruo wrote:
>>> Siddharth Mishra (5):
>>>     btrfs: skip tree blocks in btrfs_get_extent_owner_root()
>>>     btrfs: tree-checker: reject inline refs not matching the extent type
>>>     btrfs: tree-checker: reject keyed refs not matching the extent type
>>>     btrfs-progs: check: count non-skinny tree blocks in simple quotas
>>>     btrfs-progs: tune: do not remove owner refs from tree blocks
>>
>> Please, never mixed progs and kernel patches in one series.
>>
>> Send them out separately.
> 
> Noted, I will send kernel and btrfs-progs patches in separate series
> from next time.
> 
> Should I resend the two btrfs-progs patches as a separate series now?

If there are some changes needed.
