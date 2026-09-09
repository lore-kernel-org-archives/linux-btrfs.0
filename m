Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA3A3B7B64
	for <linux-btrfs@vger.kernel.org>; Wed,  9 Sep 2026 21:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788991132; cv=none; b=MgSq7lMRw/ewE1TI03FufeQdDEu3yXpE0B/88LfCcYNXRWaSJFyDl0aymVFCXkyhR1RPpL4QNnPCtQIsr7z2PfPFvcykVeKZ7qnf2QJyL+mSNOI6k3mrwgcmVXCW1lPAoHxuCGwaLaMhxVFmAiI+wF4Pn9Z4JLMlr+7h2UJSz5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788991132; c=relaxed/simple;
	bh=bN5H/bnfN/hXfaCvIn8laJn2SNDu6bOFgegh1/4kNpQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Zfinxg9o0U2WdBXWN/CdV6rnRl4NgWjEKKFMpEMny5OmiTW/MrwlWiNdWuJMRarW1YOOJVouRMmq+YDWZUKMoR4G9grngEHjJElSq76wlQELNfI+ovLNAQnXfovrb2PEb/4gTWd7rGMsFZfjDkSywm9jv4xh75+jtc5y1ww6+Ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gtozWCOE; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gtozWCOE"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-49954b88fffso46766955e9.0
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Sep 2026 14:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788991126; x=1789595926; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xUcn5RpTdBwh932Fa2jQNlkfcd+2UozJ4+WuHdj3JMk=;
        b=gtozWCOE+y0ZEuU8qMf/QT6aonIFg+hxH0f2eXEHRhszgiJUZbFyhzHEghvg0panDZ
         sDLXOttdrXIpG66uAaL62meahzxJ7OdpzT6is5Ge3Fk4ZbaZaYs+VN9EdDR4cJ2rgHIA
         1WFillWUz9aYaFkDSQVoV6vUjOp96urIDTYEfzpBDsM+OhG3a5aYjLST3cc9XrMSze8T
         /477i4OHb8gqji3semwdrcSB0602HcSJrKnDvd1eDt6P5MqNSe4cFtyFNTaQxzka0DbY
         iOxfswiKHR4ZzzGC/E4T/j+VzR7NxPtCc/ILXe7xK2/Y1RCKhFcun3bpmq+lMLhgIOhN
         oenQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788991126; x=1789595926;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xUcn5RpTdBwh932Fa2jQNlkfcd+2UozJ4+WuHdj3JMk=;
        b=aXE0HffVPF4Lwsj+O/XRDuEUzg4MsUqWyN+PlYL2ikg4zMqqherHPOvbyPkuqIuhJP
         X9GJHvRJCAjjIWxywhSdNpUA/AHOiMs+WyV3h+R+d5lGMMB/lCuNI/38yeyNjMEB3VZR
         AIc+ecO5el+d9wM8T8F7hL4zamsvAAFMNzPl/HY1JSrg0A9GnHfCNL7+DR29OOHNVZrq
         c6wwJgHPvJmLBRtN5q4vGjQsTv/64+1Q3H0CpdC16iciD3mWdYbk3L5d91pgn5Pyb3jW
         qkmpa+67K16RLLxi93N4jrhZ0rhptA/a8O6oD3HliZKmN6wub3VHkUAW5vC1NEhmj5HV
         Wx5g==
X-Forwarded-Encrypted: i=1; AKwUvBzDHwz2gP6Cg4jXRh60j5gih1Ie5vzrta0Pqay2Fq754cy4IOUythIAYM/9kKPcFyITbpboc9r6o33Psg==@vger.kernel.org
X-Gm-Message-State: AFuF++m2YdQC4x0iPoRp8aZpnwshUihi1+4aJ3+l3jkI4j8soTg34edT
	ku65P64LgLuOC6JTTh/cvbDGsWgE45bnqm1a0KVo/bNAj+4s1H5TD+lDGNzQa/TB+k4=
X-Gm-Gg: AYBFou2Csvcw7y0tFGfgGYMbKmsdFvkCWQRhnYwfhcD7S+asODzNCrgG2BYyEwEnwhX
	/AIffZFRxdYYiPGGfop6Y/5L6ZSSA7BHh4+rXxeZ9vOKQDlCI7x8P5Rj+SxWCmZRxI4lI6PgsPw
	/b5bUMPh8Cs8Qh6h6qPSSA2a+ptzaO4ghqGClH5buBhIUJwwjVGH3rXsErPyLOchlIpi5i+NfUT
	3SHGJzni1VeR25/XVAY6tmeW+o9oGY1Dj/HK5th9BV3OPG5gXxaL367E4APzUBDHdgacTYQYttz
	g99U1ZTEftGzR2K4lOS7Dv32VAqsVlLytJRejMncoxS5O/O4YPCoqWE0+rAn9bDmQI+Sam3xjoB
	lxWdEOD4GJ0tS3NhclG5GJDT28FQ0m2xvVFwhBuS906Fv5X2DVCRsA+Nf7SzV0RQilu7lRfk7DD
	BLgflw6DKNYJGuhRsOxWgSneV2TUrD3xEF41qdlTyI1KMJ9fkgt9s6cXpeu35eqmc=
X-Received: by 2002:a05:600c:a087:b0:49c:d26a:cf70 with SMTP id 5b1f17b1804b1-49cf825a75dmr389840825e9.15.1788991126279;
        Wed, 09 Sep 2026 14:58:46 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339aa37dbdsm40402118eec.11.2026.09.09.14.58.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Sep 2026 14:58:45 -0700 (PDT)
Message-ID: <9ca6e653-f89e-4ed2-8f97-783a5663f97c@suse.com>
Date: Thu, 10 Sep 2026 07:28:39 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: commit 108cc873398932af589c295f78c348513b8d70d9 breaks
 update-grub on btrfs root filesystem
To: Hanabishi <i.r.e.c.c.a.k.u.n+kernel.org@gmail.com>, dsterba@suse.cz,
 quwenruo.btrfs@gmx.com
Cc: linux-kernel@vger.kernel.org, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <CAKLYgeL7nrA4nXcewdv9Fqg_s=3GS=vmoypnEiZBKQ7rySZFuQ@mail.gmail.com>
 <20260909002506.GF9053@twin.jikos.cz>
 <7c331e23-d0ea-4611-9bed-d7099dcb41ab@gmail.com>
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
In-Reply-To: <7c331e23-d0ea-4611-9bed-d7099dcb41ab@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/9/9 23:48, Hanabishi 写道:
> Hello.
> 
> May I ask why you guys keep ignoring me completely?

If you think we have time to reply every report, then just check how 
many syzbot reports are not addressed.

> This is clearly a regression for userspace (see my previous reports).

Unfortunately it's not.

The problem is there no matter if you have that patch.

There are a lot of ways to make btrfs to report a weird device path even 
before that commit.
> If your answer is "won't fix", state it explicitly please.

Won't fix.
