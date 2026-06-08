Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB1873B0AC8
	for <linux-btrfs@vger.kernel.org>; Mon,  8 Jun 2026 22:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780959245; cv=none; b=fi2RV5AgkECFhrnFw3+gcxJCYfR/WUpkoMc5Ww/pyArgcwCBs1j30yMKnwlvlVED9sMHbTTV38c8QYJ5Ku6a6ZllzmM08agpBtqgnwiv1BlOWKc/Hio4B+AaaHHiqHC0VP44yiuwpA/0ALgwdmJ1FW1G2GKaR7FuMutvjWikDlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780959245; c=relaxed/simple;
	bh=LLJTl+KVVlz4uVsBM66efSMi4HznfzULjVOpmC6wdBM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=D0xI+MjKy+KV+7g5u269pjevn0vEkESzjQxsElxek4mHyFiHEf4W0GVmU1XhprOOihycbjLJ2JMUDIfPW/irsfOj15Jje/B8IQtsGm3XRpjxa4kqr63EwjXJlMxLdoqKhNKBHW4Jr4Xv3IH0dRDT8db/ucC2Q9kfEd/B35uOrxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=cDrdghoF; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="cDrdghoF"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-490a76757e5so31538875e9.2
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Jun 2026 15:54:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1780959242; x=1781564042; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=f6wcsPlR0yfj1CCdr8J04STSkl7+0Q6QhZ7jQGcBAvg=;
        b=cDrdghoFg/jII6J2wkVkx4GV4XDgTOyHStWGMn+C6hwaOYaTvFvG/IRd922mrfGvql
         LM7PC4Uv0+OwV9AgBH1H1V0JZO/t0d5VGrDSxmqX2Ye0bn3FnIHJN46P6WmOc2iDXqsN
         3abMoMsT4jnrEk0D8tjq4voauQiy1QBDt5PwL5Dh0jua7fNNoMLJdIHrpsMNXthPMlLb
         qFjW1wwDp6hK0EwwR6p2wW03+Gf4wl1h1iq0BLpW/dmXjOabsqQJqWYkiZOT/TzdRyIz
         7H70aqTMdyRO9TIl8/eEQZUYFJvA1BZ0rj3eRkd3juEEe0zokJNsnMQ76kdyd2LsTx7+
         +mJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780959242; x=1781564042;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f6wcsPlR0yfj1CCdr8J04STSkl7+0Q6QhZ7jQGcBAvg=;
        b=RNuJ7Ck1MlEren6ywh/To0pJozBfHQxcwVB1R7Fl7if8Megb1f7q9Zaejd8mg78rx4
         eJ3dMnDoGH/TFXkWelUDm79NfYncUjoWRHs6NsbDwylPVWKGpu36TiIvZFY0J09dJHBN
         swE4Wz1xMoY/DsRsl+kZD6/n7K40dyCiJQDBPy9+qZtfYbkcJbCvTHW7mXTRdIbXeBBl
         ALsMXh6HvDCXTNlmPhfsvlBrc3wRRwiTdBM17lBep3UNgKGgdZ2HB8eeOzpYOmAz/bGz
         1nmg/OuFqPSaOM669rpcnSq2JX8i8k1QbNMtsyK/ZfqBLbGtb/dWrfHOAefCjZCldOBe
         JoQQ==
X-Forwarded-Encrypted: i=1; AFNElJ/Av4j+gVO6feup3r7JwUCM/n4hoSyGu5st4YFbC/NUg2s9gTgjnCVuhx5mcwt6WpRtRByQTdJjjQZeaA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxymTSF3xravYCPdgF6lnim8f5PlkJjBag3mTY7coIfpb872eZc
	CyBDFguITtMG3ioJv868wWoCC+vOSWZt3bE/wBGQNfZaH1NhI8C/I9iLR5W5F4KARQMpamcvhDx
	RuYl+
X-Gm-Gg: Acq92OFNeaMORag3SY4Rhy2rJJmBvD0e0w5tVhWi55ce+OmHVyv55irjlUufQJPfqB4
	jbRbpNkutCNf8vtQBS5bz1fbrY6MYp28Jl6Qk3+B7qQxwQugo3JVWv2Bp0iDgOqlIx/VCSPa715
	KjnHNQqxuWJr9yjqKn3yn0eGI39DMOVVYmhIXndFOv9cQv0UEzHcwhMPbPFAutJ1Yem091fSEs9
	amdUyDBVsTf+XcoTam6gxSwF3d/0FG0FRmh8vIxUeFzh7vw0NriCM9bMumZzn4yNNgIZgDZk6qu
	4Pt+vcXErSy+oPT8AhnsfLoowUAj42csu+9oKJktQpZuJ+FqGnHp7gOl2h5E4QSswILTtquP7Bs
	FolZdY6+xGnxgz3dvvtjhzpmRWtWh7yQrPFhmIqLOaATxvlXE9zpRoaY+rCNxbZS5Y1QDceWLg1
	SgSgPi/x/TIfbCZ82ngfDszkKYthVUvNIiY3kvZOCCQrnNRjl7yoguNnHsdgCbPYm9WWPtEoRhO
	8MVr+SWRPlTzLWJmDij6KNWwnZBTqJjtkPSCSIDJYs/ykJvhU88cx1R
X-Received: by 2002:a05:600c:441a:b0:48e:7854:1608 with SMTP id 5b1f17b1804b1-490c26e1b8amr190422095e9.25.1780959241895;
        Mon, 08 Jun 2026 15:54:01 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36f6bf830b2sm15731755a91.4.2026.06.08.15.53.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jun 2026 15:54:00 -0700 (PDT)
Message-ID: <6cc7b38d-4133-46a8-8793-ae972e2358fc@suse.com>
Date: Tue, 9 Jun 2026 08:23:55 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] btrfs: fixes and cleanups setting/clearing properties
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <cover.1780916663.git.fdmanana@suse.com>
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
In-Reply-To: <cover.1780916663.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/6/8 20:49, fdmanana@kernel.org 写道:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Some fixes and cleanups to setting and clearing the compression xattr,
> either directly through the xattr API (first patch) or through the
> fileattr API (all 3 patches). Details in the change logs.
> 
> Filipe Manana (3):
>    btrfs: validate properties before setting them
>    btrfs: don't over reserve metadata space for property in btrfs_fileattr_set()
>    btrfs: fix transaction abort logic in btrfs_fileattr_set()

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> 
>   fs/btrfs/ioctl.c | 22 ++++++++++++++--------
>   fs/btrfs/props.c | 16 +++++++++++++---
>   2 files changed, 27 insertions(+), 11 deletions(-)
> 

