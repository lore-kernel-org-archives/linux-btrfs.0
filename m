Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 818FC3D5C2C
	for <linux-btrfs@vger.kernel.org>; Sat, 10 Oct 2026 09:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791622960; cv=none; b=KMtUXmrZvULyxOocTYxqyBjjIhXnrHXDbxSH/fl4VBVYakEnHwV8YPFnIDLt/+0OvwbK62tyZaZauaZIJ/KqUFE5lH8EU+BISvUqWrPkL8vYYaq33pRrhfWgOEvVXH+SDiezMZz8B6pEtxsIiwQ9hPwAWz234sK6Jdisws7tCU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791622960; c=relaxed/simple;
	bh=QejqMsHiBB/4yRgImpsUrEPeQ9bf0UtT+H+EO6CQpPc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ov+iUQocnQaEnBtfTV26vB65f1sXc/k4vkR/oDehYeBDwzc5otcAC1ww3CIMiMQV5lT7ymeohIewek9LJaDNo/Cki4ibK5Ub2Gf1uH4aXaDz3SksAj0I+EkP6xt8TFdsEtkWsJwHj3CocTqzVitBl+Q/V8I101QbfEwrYip6zGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=g0jFdiWe; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="g0jFdiWe"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c2dc63f8d8aso92991466b.0
        for <linux-btrfs@vger.kernel.org>; Sat, 10 Oct 2026 02:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1791622957; x=1792227757; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4pgI1vKggIJHGNGiqTkdyPpOoGvxt3pFxWjHLXybdRA=;
        b=g0jFdiWeJUEX0S4MOIghzSpwXd0BrDIWsnpH96Fm87LFM9BjjBZBPuGVPDgtV90j77
         UQi3upvNs8iEYzLaAcCAYXTE+Ao8nZZq5H1LPsD4eRHn0NsxpKcP+Hu2h43hgk9rPSTG
         7BBUm2FpuG0Vr7c3iQBlWwaZ9/2MGHrJno8mimZX5yiYua77Q6xZPSp1IT3yeKLZIW2W
         OexYkj8N4JoxoeJ8DKTDfKU996+Q3Op4wXrVmWTjnhuY3wcQYC8SNhmrNyH6cXY4Z+kc
         yI7mGMIAXpGy/CjWphV3kUXIzwNpVx1mYoCpip28hsgDgeHamavi75nTiz4A7jFm3Npf
         ruOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791622957; x=1792227757;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4pgI1vKggIJHGNGiqTkdyPpOoGvxt3pFxWjHLXybdRA=;
        b=fIYebbBC0dC+CLmi5VXeD2/mk3eRpFAnYS3IHq0mHk9Nu1aKheMSP1ixvA416VHeBq
         g4d4I9Y47rHdaEMSWs18Mc1F1zPNqhxCbsc/XJw+TTzSOasGup/210quI2g4c7+DiuGb
         LBFQBchgR1sGdsFglgDjLKCS1zq+o+dG0kBcKC49hJABx3ARca7wSSuTXIbm9JyeQJKk
         M2TykxRpAb5lTjrryOuE7EXrY4oZzA9/VIQFDyvsqLJ0yXhB0EKTE5m6IOjOrERqnmC4
         QlbVjA15KVrBzgyuwIYFOugzqVCKx45kcBke1EAduaP422mqaug7uq6KJduqXNacUP9h
         6udw==
X-Forwarded-Encrypted: i=1; AKwUvBxmB7XhSriaAvs/y9YFw0oyJL36G2kGWaWvbEMTjWUyQp1SVHljkQMef9miXCkCzipAiruVpIAMUCJ2Sw==@vger.kernel.org
X-Gm-Message-State: AFq9FYJwP4NazKMHkhJgXFwhjY6GVVggeUrE/Sg4JLdJIdpYftmZf4i9
	RsTLR3KolZpN4PHl+jj4gdCVb/MOfJNfYqV7jxga6uNXAYEMdc2YvUifvyoKUWPxXJc=
X-Gm-Gg: AYBFou16TQENmTZTVVTqrqX1+qv3SahuhK7W3M7qw1IUmHwoQiUHg8UgGnru1jfX+a+
	HJoxCD/03VIjV014XvhNzhIYkn+s56Pn35LY/Jxkq41pIhX7HubnrsOlVwH8vXS5XO96e+YlCFq
	IC/TZhToxBRjxh8JRO56tPlHF77SkzG8mD7VGSIEkuhCsAQePHk0taTDg4HcplIwW4fsdi2cEn8
	58WQKtkv/TcPNem80cdwAMoDf6RGNV0m+dVC3OuvtBUTAsZh7n78zkRfe4rdLFZPVUrNQwC9+eC
	MHK6ex+6HRs/xmIovrjcKnjj+ayDIop8J6bakIgHdimk1spTRTlBofB59PYBmvzQGIE0zQSqHX2
	7CQ7Dx8rSta7XPW0JRGVxk1xVFXJuAO7Vkz3p+HMg/uEQB32UVPs/UhhwGbEQYi4q9pXw3/CIE9
	9K1BJ4Dn1vdhltsma/K5EIq+et5oSTJIYp8NFwgsALDBLPPs2J1n44MFJYQM6fow==
X-Received: by 2002:a17:907:3d09:b0:c31:8cfe:9a25 with SMTP id a640c23a62f3a-c31a9fd33dcmr446091466b.9.1791622956614;
        Sat, 10 Oct 2026 02:02:36 -0700 (PDT)
Received: from [10.86.128.17] ([149.22.87.44])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-896c31071absm2122417b3a.15.2026.10.10.02.02.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 10 Oct 2026 02:02:34 -0700 (PDT)
Message-ID: <f180671b-ce45-4bd8-b536-b936ade0a79e@suse.com>
Date: Sat, 10 Oct 2026 19:32:29 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: btrfs: spurious fs-verity "FILE CORRUPTED" with large data folios
 (v7.2+)
To: Tito Duarte <duartito@gmail.com>, linux-btrfs@vger.kernel.org
Cc: fsverity@lists.linux.dev
References: <20261010083827.27604-1-duartito@gmail.com>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJqqw0NBQkUl/JeAAoJEMI9kfOh
 Jf6o/xYH/3AaWnGSq58XnY/T3/YYjr6g+TUZxa7MPyiYTELNpNlvmNlbtbAL0nW0LNvkeiqf
 SmYA+xkwY4RbxnZYQK0H5iv2w1eqa9qqFZb4bIBRmTapu26GEEkpad0W0ZhoSPMO8bV2Bwkf
 YdtPZQLaeUKvHZqNqBKnmtRLQj2Cgy3kuXX3bEGvWjzUOxPUSCj/S++JWBewMdMBPT62vZM0
 3156gfn5mHA94s2p+NFJoWkERY+JPTMu9NISkpD7yuGhXN88qd/aqD0RrlhxvKsrQogdPwn9
 vP18FGG3CRlHtOvOLVoY5NKSOWTDc+o+8t2XEETFTGbKYTcqeTzi4SxhvBLtTinOwE0EWdWB
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
In-Reply-To: <20261010083827.27604-1-duartito@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/10/10 19:08, Tito Duarte 写道:
> Hi,
> 
> Since v7.2, reading fs-verity files on btrfs intermittently logs fs-verity
> verification failures although the data is intact:

Next time let your agent to check the mailing list first:

https://lore.kernel.org/linux-btrfs/15f4ef9f50e1f4af375e45cf976717041f1a96d4.1791613764.git.wqu@suse.com/
