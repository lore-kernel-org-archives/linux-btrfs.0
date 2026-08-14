Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 833293F12C4
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Aug 2026 22:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786745615; cv=none; b=WNgeXUhFDSuw8cAJd2XVgeWQ6Rz6LnD3Hj0NZk0CaDhb02EtNPFS1RynZ2+YOzlUUMkafVHbtipE10Zskq7aBITpcVMqikYt1a9hthfzhDkd5WKB9543UN12vCuhRq2nj/t44gYN97O2estQ11TVGGfIesLzZEad60r4eqtc9uM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786745615; c=relaxed/simple;
	bh=nTfIczuJLNjjqfRMaJQEDFUJqA626XDX+AUulWYLwGY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T5Ai5uOQZ4Rq7FGXykIeSpvdAM0tdHGTGwupgcFHS/RLhidum7Z3TysFh7TM65MTO7EjcMOCTUJtRI/S7StjaYdMRgcHLMGIqPx/XnEiEmkymupTLwOZ761gAnvkMUG5g7PL9ujOXeV1I+dxPVdFz/gyTj0MkA/c/xr4uMum2dY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=NoKT7Frq; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="NoKT7Frq"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-495590dde14so20225215e9.0
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Aug 2026 15:13:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786745609; x=1787350409; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=X28P8hyo42o2Pv4aRrk5pNmiZRch9v/udZTA4xeoCd8=;
        b=NoKT7FrqR7wLnFW/Ald7fpk5uRm4cyWLWAEujunZL8WyOZPbIZGLR+VO3NqP5Lb2EY
         IYtrSAeJuxDAd4IYTN3F4rtMdwtfesyLw7kxQ1a3qsnLvqKlDswPCq6/mRDcxGg2aWSd
         C7hJJoMaEDjSuOqlWKoxLetLGX03LZzm8CWsuIJD103VkZAiFeSovhuJ5sFmJ987gsjI
         B0fXCPfDLVlRfRDXXOhexzAfjtbynoUGUy8Yp7Lk97+m/zd9Iry3ev2H4kshjrAwnswR
         gRlPYqHCGgN0KWjSQRQVqg1YE3ilj4Aawtd1IjqdRnOqGPiuUIzDbcIHG6rZYnt+sX1/
         ZARQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786745609; x=1787350409;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=X28P8hyo42o2Pv4aRrk5pNmiZRch9v/udZTA4xeoCd8=;
        b=NtdxZRbik+z+q8yMBJS9zJ2dZaXMZpxialUDdZC4Rtfzm+umjEJouLQnsAPv02MxBS
         YaRux2PgG778wE58f8CGOi1u4ch68IS7e73szKOHXLrq5HAVnitwXOMEy97axZw+5BnQ
         yq23Q7VPS5SsL206/X0k1cmLHpIKu/aMdX+2DbXRlcO/9sYxzWp7t+0KkfzoEtVwxoTA
         9Tv1sDA6av3SMw9+bTjMgeqAEXD08HhtdTwuoFIT+t+wcngG1AVK7owFM2QqbPRaEg1R
         +fNw9dXb4KFHys2nA5S7ulAYDLbpajMg/ggJ2ahEtAl6v7aiwRi00tleZdlXHDAUzBBL
         +pOw==
X-Forwarded-Encrypted: i=1; AHgh+RqyrVIHsSLBTCcX2r+Z5fZWY2zfTPO63hpb3+PJdb1TNTK9Je8I+qLMrh8/Gwg1+cKG6ZDU3tQg8hVr8g==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+7H0Vuy7eBL+pHPLqSrYbgoQe0ZGjlQey6kn/lZA52h2pRipW
	lWELgKjpHri3uBtLsw7+qWJVLf/Dy8pHuTaI3b6mI8Ba4zg2PF3hWIBMu8W+FrQLcrc=
X-Gm-Gg: AR+sD13sqfq4I/JHOl7oTnz+jdYewHBZMPu9zHl7PV+KM44n4L4vqH6p9nrHDNxPrO8
	yB2hCZx9PqK/Kue9S80ViM/C9s/lZHeUV2hN2jXgpbh1VLP3ubkqTj415FSl7iuMpZnNPO/Essn
	dAiCm094u+aPyGgAdwYaBX8DOCtUwK9LlV0SPkylLzT0fq3ySXJRkR4Bb2wgidkXAc7VshY1s/I
	fPwOhPCmKoHiOnnGuwYc5/fKEqQE9T2Lcz3bz1DC53+Q8RF7CYlhB7MBYOP485B25VZMoRpt9I2
	WqrbecJWLfkhHaHODQgSrcqfhc8Kt3EA6M5p4hy+rRUpwsKI89xXGcPdO5QSBEzJsct1tVIfPYp
	IEiWYqPNXp/h+VvcNSbMCBLRaahohrheh3R1Lx35wiUfYFMtrCrMGW2F+fmrNRE2pynjsIFpqNl
	VeJuQJDTNLAYYejhHDmfUJhVgptJKqUuxgQvZme/mMoINP1vENF55TLw==
X-Received: by 2002:a05:600c:4e14:b0:499:7e2b:8e5 with SMTP id 5b1f17b1804b1-4998793ffe7mr129283525e9.5.1786745608765;
        Fri, 14 Aug 2026 15:13:28 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-320ea8fe3cdsm8274529eec.28.2026.08.14.15.13.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Aug 2026 15:13:26 -0700 (PDT)
Message-ID: <7845cec2-adf1-408f-b7eb-019a5cd398f7@suse.com>
Date: Sat, 15 Aug 2026 07:43:21 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: free qgroup configuration when quota enable fails
To: Guanjie Chen <jk.chen1095@gmail.com>
Cc: clm@fb.com, dsterba@suse.com, fdmanana@suse.com,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <694e88fd-a165-4518-88d4-cb2f22e8925b@suse.com>
 <20260814123034.19289-1-jk.chen1095@gmail.com>
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
In-Reply-To: <20260814123034.19289-1-jk.chen1095@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/8/14 22:00, Guanjie Chen 写道:
> Hi Qu,
> 
>> We can reach this out branch if btrfs_start_transaction() failed, but
>> the fs_info->quota_root is already setup by another process.
> 
> Do you mean the window where qgroup_ioctl_lock is dropped before
> btrfs_start_transaction()?
> 
> I don't think another task can set fs_info->quota_root in that window.
> The quota ioctl holds fs_info->subvol_sem for writing across the whole
> btrfs_quota_enable() call, including while qgroup_ioctl_lock is dropped.
> 
> As far as I can see, quota_root is only set in two places:
> btrfs_quota_enable(), which is serialized by subvol_sem, and
> btrfs_read_roots(), which runs during mount initialization.

Right, I missed that rwsem.

But still, for error handling one should be in the reverse order.

And for out: label, there are cases we're going out label without 
creating any qgroup. In that case, qgroups removing should be done only 
for cases where a qgroup is created.

> 
> The disable path also calls btrfs_free_qgroup_config() and relies on the
> same subvol_sem and qgroup_ioctl_lock serialization for the qgroup
> configuration. If subvol_sem did not prevent another quota operation
> here, the disable path would have a similar lifetime problem.
> 
> So if quota_root was NULL at the first check, I believe it must still be
> NULL when btrfs_start_transaction() fails. I agree that the changelog
> should have mentioned subvol_sem as part of the protection.
> 
> Did I miss another runtime path that can set quota_root without holding
> subvol_sem?
> 
> Also, just to clarify, this is not my first btrfs contribution, although
> my previous change was only a small one.

The same, LLM disclosure if you're using it.

Nowadays I won't trust anyone who is not a regular contributor.

> 
> Thanks,
> Guanjie

