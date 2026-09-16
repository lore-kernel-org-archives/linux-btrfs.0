Received: from mail-ed2-f12.google.com (mail-ed2-f12.google.com [74.125.228.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF064A9D42
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 23:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789602394; cv=none; b=GoHzu5yaatJKdIE6y4+WpblUiRo4iwLKpNXRymgy56sLkRzoTf5h4UbERMc/AjzWyss8A6DtKYRWEdnrdqGNC1N4wkGhd0ls6k8+R0BlAHEp6beFvopAumHm6InW2qSmUA0Tedy7TJ7q3zaLnUjJO0eTLMZCtsg5ejcfT6RS7Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789602394; c=relaxed/simple;
	bh=pJI/ZEo/5yrAqhB9of16xZy2l8tWeSnFoKFzf4X/gN0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pyo6fmVqHYKrPpjsC2zK3zKIAdpBRNOgT4qAXh+bTjlU0PavWZm4yUGvNmbtDdtqDHjXpr1YPeMxQDn1tFlilkmpRPqURXlAP/idoZHvXfHKJiVzBNSz+8I3L+12ut9K3TDtB7dYbojofOamvGJjURzXgrWz4HYrjN1rsVhSTUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=WqCYeo2K; arc=none smtp.client-ip=74.125.228.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="WqCYeo2K"
Received: by mail-ed2-f12.google.com with SMTP id 4fb4d7f45d1cf-6a6063d7dc4so394452a12.3
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 16:46:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1789602391; x=1790207191; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QNW9318VOQ/wFxjWMtki1+FfnIEEUWMGlbgLd/WFIPw=;
        b=WqCYeo2KKBlbjENeFX+dlR1vXzDKul696Wxg7m7cdzg58Y/K2qLGQ+/pyTt0HJ81Da
         OoaFwNcPlUb1p/nkbMZ+0izKFZ+7/el/eN/JkJTqkKhaVxRY7o3eK5Rp8wnU2eKKgtCW
         4NP+eTqK6yWqys3L+A02W6M8eMI0N/XZG6TY4a8OvOZmupN+S5NuyD9ocZgO15NH1/Cd
         LrbscaGYJDEq4suE9zlzGsx23QSKIoJjANxK183E3h8JCLcqJ6r4IQ2mTf7lT6IEUuSs
         CtyNb93kPOZpDSCbTzbmKHeQozgF6jv7cTQqr+SNNBF0pRIZpxa1jwM23UIKuaMxkt/c
         Aplg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789602391; x=1790207191;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QNW9318VOQ/wFxjWMtki1+FfnIEEUWMGlbgLd/WFIPw=;
        b=XvZjSCShVj5/k7ioVYwfW79n5/38CedM+muXAcicAe1Y7fwWYx4qXahUamWPT3l2c1
         o5tl7/IbjSmIDhsbVywM14KZ6EmpsNhIAPfmUJMEato46Qnn8IN59GZBZCxgT3JKeW+1
         Zu989ztVYarGMvyD30sKzaDQtHzBKnuE4k4Gkrx9F+mXf6DKRvMYm9qtTMxtGAOIj3C2
         TyKEDiQqBSeU/AvusUMgJn7oogsv4vGlZO3KwLV3AUupO7ZvZCWr3LxQVd9jeGeB4pxs
         tMw/Sv+mhtCxYNSdVnq8Y0tw6SBQW37bI+RQFlDy1t70qV9ktakY6LdENAq0V6dKiu6t
         gvdg==
X-Gm-Message-State: AFuF++leHdb539JcUnZsAtxiBppVrL+mI1G2GbE48PkL5D2tfhL5GfgB
	AC71hoc65qSwyJqxZSlAgngyXmmqCQ+JPTMeziReZJkaFo/GkOP/tmOwN+mh5pnS9uk=
X-Gm-Gg: AYBFou2dhfpKBqz6fVoPcQ3zX81tUocoOXwGM4oXJwBwqu60xAIQyvACloiz8NP9qZU
	Op+ek8QKwzn9Z7dCdcpLZztM3q9rn0B5fDHJz3hBwE9fN1sMzwoBwdn7Xdpjc3TYYFgMLlUSvbE
	r+LwwknaGPVlnWvsoDQ8I91/IWuKpbcFKEY9+gOhLX72jQUk+0dXk+qHDBw70KTb215AlNyjMWW
	GpXDfNi33HEWnjWzaJvaKB+cOHh4mR1i4Ys62ig4f08qK3Vwc0Lf/BoBOXtB4obWdsjfqfbEVSy
	qgiyb5kcQQnlKz8yz4cK54T40dfBZS3iWyoyZE2V/ucg98NAp1mHG4zC5zkCM0GoGv4M1+DFBrO
	8Luj+GW3teIl9Qqx1LoVFvEsUcflDaV2XoIDBstbVc5XjFShS/uu7Bi9FxC0HSmK/xqQ9HgzFsG
	0yRqrL7TPF/E1FTulcyLz7g6vezaiWi00VIQz4BueiM7x/jw+I9ET6L5fUELv8DC4=
X-Received: by 2002:a05:6402:1e92:b0:6aa:1112:62ce with SMTP id 4fb4d7f45d1cf-6aa2241b34cmr5523581a12.17.1789602391201;
        Wed, 16 Sep 2026 16:46:31 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e35b6a350sm1859564a91.0.2026.09.16.16.46.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Sep 2026 16:46:30 -0700 (PDT)
Message-ID: <742c9d7a-ec2c-496c-9a95-0c70863fb59b@suse.com>
Date: Thu, 17 Sep 2026 09:16:25 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: add "/dev/root" exception for device path update
To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org
References: <3e3164206d23ef991b9bd76dab6706238592cfb0.1789202516.git.wqu@suse.com>
 <20260914171602.GO54722@twin.jikos.cz>
 <f6f95c21-da42-45b0-9fd4-4c855e677b1c@gmx.com>
 <20260916135232.GV54722@twin.jikos.cz>
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
In-Reply-To: <20260916135232.GV54722@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/9/16 23:22, David Sterba 写道:
> On Tue, Sep 15, 2026 at 06:58:48AM +0930, Qu Wenruo wrote:
>>>> [CAUSE]
>>>> Although using btrfs without an initramfs is not recommended (if a new
>>>> device is added to the rootfs, the system can no longer boot, as there
>>>> is no way to register all devices), there is still a minority of users
>>>> doing this.
>>>
>>> To avoid scanning there's the -o device=/path mount option, passed as
>>> "rootflags=" kernel parameter.
>>
>> That won't work. At that time there is no full "/dev/", those
>> bdev_open_file() call will just fail.
> 
> I've researched if it's possible to have multi-device root in this case
> and with some effort it is. The early block device lookup used for the
> root= parameter can be used too, but has some limitations due to the
> __init section and usage from a module. But DM and MD do that lookup or
> auto detection. I'm not going to implement this unless there's user
> demand though.
> 
> One prominent user of initramfs-less systems is virtme-ng, it's not
> affected by this bug because it does various tricks with the host system
> to share and virtualize what is possible.

BTW, just back to the original patch, although you didn't give a 
reviewed-by tag, I think it's time for us to push it to for-next for 
more testing.

If anyone has some objection, we can still remove it from the queue if 
needed.

Thanks,
Qu
