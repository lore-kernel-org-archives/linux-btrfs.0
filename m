Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793180831;
	b=XhLGc7gx6hJlbGSQLhNzzR2JYbou9VkpqnlhvN1sxsJspAEaMSC1+GiqGDhMr5pecM5z
	 qCF78IfYaqIdQjDCaE1rHVJYkC/ntb0ic7XudIYx/yue/eNI7YA4qarYUjVqgTuD6Y0Ay
	 jhOnJzuX5xmZKKy9VPhFkCYMpgBk/wdzS/7JG1XS3QnbSySMLysBM/SAZjEzb4s3tDEQV
	 +w4055/EGFTQCt75vI9HnW2LIw+CFIhAmWAavsVxOOvrJPYQqgj8NqVpUET4ZDTNhSBgZ
	 Sq5mqKUw17dXk5xf+EB5BJE+BmsysTP4BBnOk3//83wokNB9Yy1p50dtySzGVUuLEwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793180831;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:From:To:Cc:References:
	 Content-Language:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=ObsB3jKiA1dfTV0A4Ddm+ILKkKhn0WdS/9g9Axdfzxk=;
	b=jI37FOtzOaZTdXrxk3SY38rkruQAukSDmQd0KTsU54bopvrxTUzp9i/6Pl202qEmegYX
	 IxGPueCxMMVv2G80te/UslrjlU9QL40IApUgftRhVjR9hdZzcCbp10j+eXQNw2y9zGKrc
	 QTuhtfB5Oeg/QXaWdefT0rX2O47c/fDs3A6HHEL7Td6p1OTpX/HSLFmHPjzz42Nok9gXi
	 6DQeVkcN2cio5iM9QhIHek+a2lgcOnA6/yj55/dwAUhQWzBcw/46pfRsn5sPgRp4ucYd+
	 ncLoNAEs0kw5LiWLAr0vy8P+40oiB/AMdU6VhYHaK6EE5HZ9HKwLAjiGtV8tPzIMYoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=Q3Df3SoZ;
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 910A5606A31D
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 09:47:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 910A5606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=Q3Df3SoZ
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a4d7ae1ae9so6349035e9.1
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 02:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793180829; x=1793785629; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:references:cc:to:from:subject:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ObsB3jKiA1dfTV0A4Ddm+ILKkKhn0WdS/9g9Axdfzxk=;
        b=Q3Df3SoZK5woo8kHQuBq/Jg9S1oEy0tgKJ7ACe+UiwXeVyiyMwbaB0LTuYJt44dkh5
         gOXHZykAYjOkCoBxm5ItKBzUWLU02tIz3v2RQ9qbuW32NFFAm/H1PGz+4kCXWPqYfUq1
         aK7/1Vxyou+EV90WRKKlX52Ct9N6mINe8mWbCbF7DZHsD6xRI/bPp6umcUfJ0o+z/ZOL
         35DH0B4bi3Qnm8X2j2OdI1ZwYGKyJowwIoRB0yok0tjcKs9Adbawf5vNVObMMgKh6+hh
         8dSuIRZAnSs7/poNXCDER3OCUmaKyUV9kLle81CLnTYg47dKR8if6CDVQIxZbtdBCaX7
         34bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793180829; x=1793785629;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:references:cc:to:from:subject:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ObsB3jKiA1dfTV0A4Ddm+ILKkKhn0WdS/9g9Axdfzxk=;
        b=Lzvvb79z3+VQZtQKQZPRRlJn877/wIB5m++7BEjsWAvGDH+358FwTObMvxmVOoH2HO
         lAl5I83cLuZTb8b/9bR/A/L+m2XAitNPr1vZ+7bcVaj4WFUbW5w+0s8S11WEQbQ/5Hf5
         feMJMP83qkU7MMaLpgVzOdY69MDQDQ8z9naX2zhog2p/im80CHL2Tue4YjwFOAR2zyQc
         JPLH1IYwmzk73/K59vMwu7lAio44lAuKheLXtdxDWpsQJF28ubCvVUmsUWfv4lGgUF+m
         czPWkRpgQj9i1aduaVrQVpQRMB2jdEN38AUs9RKp3/EMZGwusXGCQwv/v/ZvLa2oPo3I
         g1pA==
X-Forwarded-Encrypted: i=1; AKwUvBycsLkLJZB0bfXojrq5MY4ewhFEih1yRPbKMiGCE3CpI9jaiNa0w8Ci8WfTGZ2Jq1yJ42hahL3AjquJ3g==@vger.kernel.org
X-Gm-Message-State: AFq9FYIvXqXwaiNfhktbSESWfFvCC+vqVWIkAno60PZ2nB7bSsMMzB6h
	ql1fZcBHaQzhGpKhTqvf15oj3GLdhpfkrNu52oJ7da+Cn4Q5X/Yh1Qu0oyN2PjmDRLc=
X-Gm-Gg: AYBFou0VGKymJOBO00PxX12HJGLeh4EQeHzHOe5KaiTExqURL6kufyMGUa39CAgpUdd
	xYlCrM3fJY5qD7vK9cuyaXgJR1hkLeGjW5tVaCSQpXeKuPGX/iO84qp6HGjB1qOAvexyYaavtaD
	U/bIDEK4jm6txP80mT3vEq1U4K6QzsZ3Qz82mjYfXveO8d+8X9pIdnbdgKpS6d3NPfQ1Zuj47oV
	8Sb9WsHd3MzPtDbpqOymsTG9uAkVapWDPASLFk53w0mo3YilsQCdjEc6BaM+tg3ZPTyQjWNgCg2
	HWc6xCRk+YdXj/hkkZTbIqMqlgMD6fqvIxON+T7OrE9VqZOaDK+7gdgEuTg0luTsU5/Nazkwsf5
	vhAL3LZuaKWfisJ3kKnyVJkF32zBQr1yMrEl9uO499s3BWZgfJpG6y+KNfrbr4+o0dOnF8sU3qz
	e5ax2hOY7cbeW0HbbkMzvmbqYbr9fdChTG2TpBLxVdOBrRd8X8Ln05AGENn9LL9dVDfv2tnrvPF
	8xJI/KJbWitzSvjUYQJ97yo2taTK5tdRh88yEbNx5ZRAgQUYZRtMvY7qyuBoDF9i6kS7bQ+uiOU
	e3mqx6KljY/7x685k3jjRA==
X-Received: by 2002:a05:600c:34d3:b0:4a1:e0db:8cf8 with SMTP id 5b1f17b1804b1-4a9643d37f7mr35973865e9.3.1793180828727;
        Wed, 28 Oct 2026 02:47:08 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae5a4fc578sm2341111a91.9.2026.10.28.02.47.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2026 02:47:07 -0700 (PDT)
Message-ID: <84084d31-eb64-4c11-a3f9-dc5ceaced6c2@suse.com>
Date: Wed, 28 Oct 2026 20:17:01 +1030
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
Subject: Re: [PATCH] btrfs: do not leak -ERESTARTSYS from FITRIM to userspace
From: Qu Wenruo <wqu@suse.com>
To: Luca Stefani <luca.stefani.ge1@gmail.com>
Cc: zhiwei.liang@zliang.me, David Sterba <dsterba@suse.com>,
 Chris Mason <mason@kernel.org>, Filipe Manana <fdmanana@suse.com>,
 Robbie Ko <robbieko@synology.com>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261028-btrfs-fitrim-freezer-v1-1-0ad1d58aa94d@zliang.me>
 <CAO0HQ0UE5BtevPHHfV9mQo5HoqzxzDDjAkj9e=pD_0AaXmSYFQ@mail.gmail.com>
 <65fd2260-78e1-4521-9df1-b042788ae7bc@suse.com>
 <CAO0HQ0W3rALzPX59mVONjDtK1otyS8bo6_hGG6og3qwyLepmnA@mail.gmail.com>
 <84d8eb19-4264-49a5-b9b0-733c4e971433@suse.com>
Content-Language: en-US
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
In-Reply-To: <84d8eb19-4264-49a5-b9b0-733c4e971433@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/10/28 20:12, Qu Wenruo 写道:
> 
> 
> 在 2026/10/28 19:50, Luca Stefani 写道:
>> On Wed, 28 Oct 2026 at 09:57, Qu Wenruo <wqu@suse.com> wrote:
> [...]
>>>> I don't know what the intention of btrfs: handle user interrupt
>>>> properly in btrfs_trim_fs()
>>>> was, maybe we should just swallow the ERESTARTSYS case in those 
>>>> scenarios.
>>>
>>> I agree on that btrfs is the exception, we should follow ext4/xfs, not
>>> rely on some tricky signal handling behavior for suspension.
>> When I updated btrfs_trim_interrupted I used the same "checks" as
>> seen in ext4 so at least on that part it's identical.
>>
>> What differs is our error handling: we set/handle -ERESTARTSYS, ext4 
>> does not.
>> ext4_try_to_trim_range only ever succeeds by returning the count of
>> trimmed bytes
>> even if it checks for trim interruptions.
>>
>> I think if we remove ret = -ERESTARTSYS; from the
>> btrfs_trim_interrupted branches
>> we'd align the behavior (plus reverting the previous change as that's
>> now useless)
> 
> I think that's would work for most call sites, but there are some call 
> sites that we may want to know if it's interrupted.
> 
> E.g. btrfs_issue_discard() is very deep inside all trim calls, if we 
> drop the return value without any other extra way to notify the caller, 
> it will incorrectly return 0, which is definitely not a good idea.
> 
> A safer solution would be keep the existing ERESTARTSYS, but change it 
> to return 0 for now.

Sorry, I mean to return 0 at the fstrim entrance, btrfs_trim_fs().

> 
> But if you have a better solution and can completely remove ERESTARTSYS, 
> I can't be more happier.
> 
> Thanks,
> Qu

