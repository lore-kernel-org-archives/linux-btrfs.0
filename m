Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5423822AE
	for <linux-btrfs@vger.kernel.org>; Sat,  9 May 2026 23:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778370950; cv=none; b=M1OlO7WA/664Ir18YtyVGVkD57zPMH47Fk6A78EQis06N4PzxvFUQLrzBJvlYrYHLdk2vbckVTAFHFFvwqiXhnBjWPBlXTA2LFL42PkKM5a6pWYRLSRQFFg/a4DXF+BMYHhkqsxqcYtAfMnN4QcZvna7+erxdH3Ppnh+RGA1XfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778370950; c=relaxed/simple;
	bh=qkoa8dQYhlEo4HppWWE5JZ7JzLVT47vfxS35mO+wnJw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t9tw5fsh07Owmev4mamJ9ZL/j8MNGLlLpNeSQMiD2Jc1boXOqMSAqF3NUeqDT/gBS4LITzcftefP6SRCCb+2JxCMmbvSA5fygWXkw2sliTTX+iRuSn5DoZlDYSWv6mmg5mGcClEAQDfsZ/7WNKgUHtQT2aU5YSXGg3CTaBtI0ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=O1u5mlZC; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="O1u5mlZC"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-48334ee0aeaso23623765e9.1
        for <linux-btrfs@vger.kernel.org>; Sat, 09 May 2026 16:55:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1778370947; x=1778975747; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=tru9TWquuPzL2lpoqZE1AYaqRXIqfApELq0PH6fPYIA=;
        b=O1u5mlZCYMngesTFIhvErfbr5vIbJzx74z6/CG3Ln73gEUfixkOAWCmSw4mJDxKnAx
         gYa4hj6v3UNJf5Uy+ky332cNOn6q2f1um+RiP4p9bJ9UozyucFGyIXANeqsPnNWZ6aMT
         oPMr3gqsUOEQLR8LyU2HAxjg8ynVmWa6cjPIUFlW91vcXpDSseTBj6QbwmYP7/iZvprh
         /Fh775LlYbL+kYsoOkcGIrJbdC4tvHJKbjrQIx4PRKVavFH+8t8reWKXl73ZR5QMpcdA
         AcvHzDLxPRli09wuzEoU4czPBaF+EGCoDPWd7m5V4aDZBES8Xh8URhq6I7HbUAmT4u2a
         ymGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778370947; x=1778975747;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tru9TWquuPzL2lpoqZE1AYaqRXIqfApELq0PH6fPYIA=;
        b=bl846CiPSH2gng1mEqFvDEO12SZlRx9JI6hbEYFne7MUaMiHC27eAI6GHIVPTUEQ7v
         o8MMTtILahCGLvUpgQsQSUyi7FiMNBqpRdTyOmIw/HQp6Y5uwkoVw7itnT9UNECuVIDm
         nC9JtThkSiSFk4mPGiXo3wBInPhS4icOc/6tytpYtm1XdWRbWhgunWgCS49xYX1GMKL0
         Rs2zHCkeNkkvujP9pLGBrxGBET8VnU4JSWy1AM0p8V52sH8vnru6IKj9wdVFWkZRe1Yy
         YlExoeeWwfx85Z/5e8fFh9pM8A47o7bcGGQq4jmxoEc2/NcY+Kv5TjollwH4P5rD1UtS
         7UAw==
X-Forwarded-Encrypted: i=1; AFNElJ+yhiiARiw+7dOw/zBKPm4lksP1yaAiMaxq0LOeJEAoXeXwuCV1zqRDh9NXC6suqm2ZM+mTTcM0yiDL4w==@vger.kernel.org
X-Gm-Message-State: AOJu0YyviJXXJWNVvPWyUnfx/JLylp9g21oFIRlQUsoS0MOAFMLCXrSn
	Z8HIp9/AzRgOplLwEDfNeURwUsNLLjNjx1uprx9BKG3LqUsYQOFaIfLDXpTUxXVSQJs=
X-Gm-Gg: Acq92OEVm3f9mlo/Y+HTpNJ9Vp3PvzhFH1jkWXV8xpJkihE3e9X3FLKCbclv9amATcl
	vi4fllR7eIcL8tmV06rUz8BCFaPbQ6QJRDSprgRi+GoNGMmbOMsBAQQd3FGLqWuzq0JDrq3dL+a
	a3VLvvPCRxAE5nRdy/Ii3uSoljnL4Vmq1fBLOOKrDhoN9WBvAuZyXox3VxLP/avraRSXB8vzQeX
	kiKMzrTsRFN/pesu8h+ailC9BTuyUdgJAJSV7aiOJAjv3kioBr6i3qSnk+blcLY0M5kGS0AIZYc
	XKDQWWqA4PZpWjtt8JudHA/h2ZK2Eeb6Khktkn7PIUyrnlPkGdhZPh+UzrT0z3/dso5/88KBhJo
	EFZZjvc5OPV3pYIT4FiZgixM/zoHELe1afF4wHbAIx3JNv96MLzfrfHa79c3whCxOwjo8X3S8rQ
	5VDuHlL7OkSFVhQaGNF+wMgWymb09nrsdNU0ipIHbUDs3jH6k71ZTWQu4KZRUDbe7qoG9Qr0CTL
	ct1Vu5pUt2ZNHd2tvPpS+OKAFQHlbDEc+2QbSsRc7nnxFs=
X-Received: by 2002:a05:600c:5304:b0:48e:51f8:eb38 with SMTP id 5b1f17b1804b1-48e51f8eb70mr296748385e9.27.1778370946832;
        Sat, 09 May 2026 16:55:46 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8396563f11csm20323023b3a.3.2026.05.09.16.55.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 May 2026 16:55:45 -0700 (PDT)
Message-ID: <bdcf7b72-c442-4ccb-8c5f-2fe832266f92@suse.com>
Date: Sun, 10 May 2026 09:25:41 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] fstests failures at btrfs/003 and other test cases
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
 linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
References: <af9EHC5b-aBdr1zn@shinmob>
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
In-Reply-To: <af9EHC5b-aBdr1zn@shinmob>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/5/10 00:15, Shin'ichiro Kawasaki 写道:
> Hi David and all,
> 
> I found btrfs/003 and other test cases of fstests fail with the latest btrfs-
> progs at the devel branch tip. The message "mkfs failed" is observed at the
> failures [1]. I bisected and found the btrfs-progs commit below triggers the
> failure.
> 
>      ec8324cc4b8b ("btrfs-progs: help: adjust alignment of text")
> 
> This commit modified the help message of mkfs.btrfs command.
> 
> I found fstests checks the help message and greps with the pattern
> "[[:space:]]-f[[:space:]|,]" in set_mkfs_prog_path_with_opts() [2]. The grep
> succeeds before the commit, since it had spaces before "-f".
> 
> $ mkfs.btrfs --help |& grep -e "--force"
>      -f, --force               force overwrite of existing filesystem
> 
> However, it fails to after the commit, since there is no space before "-f".
> 
> $ mkfs.btrfs --help |& grep -e "--force"
> -f, --force               force overwrite of existing filesystem
> 
> Then, fstests no longer adds -f option to  not add $MKFS_BTRFS_PROGS.
> 
> Is this a known failure? If not, actions for fix will be appreciated.

Sure, fstest's filter needs to be updated to handle both cases.

I'll send out a fix soon.

Thanks a lot for the report,
Qu

> 
> 
> 
> [1]
> 
> $ sudo ./check btrfs/003
> FSTYP         -- btrfs
> PLATFORM      -- Linux/x86_64 redsun115 7.1.0-rc2-kts-btrfs #1 SMP PREEMPT_DYNAMIC Sat May  9 03:03:55 JST 2026
> MKFS_OPTIONS  -- -f /dev/nullb1
> MOUNT_OPTIONS -- -o enospc_debug -o context=system_u:object_r:root_t:s0 /dev/nullb1 /var/kts/scratch
> 
> btrfs/003    55s ... [failed, exit status 1]- output mismatch (see /home/kts/kernel-test-suite/src/xfstests/results//btrfs/003.out.bad)
>      --- tests/btrfs/003.out     2026-05-09 03:07:52.952213772 +0900
>      +++ /home/kts/kernel-test-suite/src/xfstests/results//btrfs/003.out.bad     2026-05-09 23:32:17.595751435 +0900
>      @@ -1,2 +1,3 @@
>       QA output created by 003
>      -Silence is golden
>      +mkfs failed
>      +(see /home/kts/kernel-test-suite/src/xfstests/results//btrfs/003.full for details)
>      ...
>      (Run 'diff -u /home/kts/kernel-test-suite/src/xfstests/tests/btrfs/003.out /home/kts/kernel-test-suite/src/xfstests/results//btrfs/003.out.bad'  to see the entire diff)
> Ran: btrfs/003
> Failures: btrfs/003
> Failed 1 of 1 tests
> 
> 
> [2] https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git/tree/common/config?h=for-next#n106
> 
> 

