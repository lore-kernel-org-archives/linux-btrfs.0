Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2775E2DA768
	for <linux-btrfs@vger.kernel.org>; Sun, 26 Apr 2026 22:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777241943; cv=none; b=swVNJOo7nYeDxP4BFUYrAdbykhEe+6666yyGSeDsDI8sfhRhiZ7x0pZgrOydt35L+KvApqa0WLPzJQuaZcmHxNjRubPh6XTTOLamrXMHQfCuPhFk8+cZPDF0qeUtM/+KWa2U4SBG+455GJE+gSQyrVEi60EQLA1BYv72911JmZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777241943; c=relaxed/simple;
	bh=hqgMa+kCGo7QVMNxkjLuCYCuTdvtrbj597vCfqjVFJU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=N16zEej8mDAVuJyx55XcnMTQ+uDQaWnee3ZJywbCePDyxKoGmMFh4/xoMFGdhRAqoMJg3E+g9zMiElwP7s83lJDHb8ia4iMWpXBDumJUvXSzEKQ03gjxSuAU30eSXm/J2QA1Znq7sNQiaWH6l/MWbgFaqgW8Il2QBy4WU/LbiXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=A+Eptl9H; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="A+Eptl9H"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-48984d29fe3so113382325e9.0
        for <linux-btrfs@vger.kernel.org>; Sun, 26 Apr 2026 15:19:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777241940; x=1777846740; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=kUZ/tRe52h2Ik4lXDz1DsQtBDjV79aiW0OFbiqLBE00=;
        b=A+Eptl9H8YuBo8h7MImTJAgsI1wsbM5HIYyR2ue4wZ6f4sqbgf4ucF5brv2LgQeUFQ
         9/bUoBQRFdwQ3vvgSxMyEafDUSl+RD90JKGD0oLsBAVZdqPi6+fPQwF5MU5cQRKaoKd+
         lgparC1ei1OiloOZ7qToZenUrbYhtypeFmysKUd2FldDCGY/yYMW+CXxpTS0QsHOYt0V
         2ohjyHa25uyL9he586+a/Gq6S1uJxEKHwbHfLEEtcB/9goy27a+JyT4Cc+MDObjlBdo9
         KQ8SBOxuBl03+TVdg0MyVPYhPibjK3QpAJcEE8/tYrzyUwYL9kQWlmgG+tMBvlEBA76N
         DfiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777241940; x=1777846740;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kUZ/tRe52h2Ik4lXDz1DsQtBDjV79aiW0OFbiqLBE00=;
        b=aj8Df2hA9JrASMJl/YyiLpbw8AO5oTX71fff1PuwQxmfFr3O3eNO7bu6b+DBz90pc/
         Fsnou5OMtYFag4NPN7OJqer1zvthXZtkHEPHKM/bq28JaFToepaJ2C6FDfavqA3S4Dh3
         c3N6IMizKMIW/tef3unGYUkwroS87DMYndHm1Kc9h3UYoKj0B4Gy2q+0/atOUdqrj71p
         aE465VZ9k5oygfvrZgSGL7XZ3Mb7mRXxOEIbciRom7xVMB5HGDG8U8j7E6WzbDck1nfs
         h5OtN3lRdxnw/5XWhaM21eZIoBp649L+NhuJQutm3KmrW28lYwD9MRA4ggvKjdAhiK69
         2m1w==
X-Forwarded-Encrypted: i=1; AFNElJ/pgboiSOugC0SDISi4l+z2WF2OHcyhXyhHLyK/gv+8dL2pF+9vrKSdMLOHOwpi2K+FaoeA1j0b4uiSwQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzk9bYQYd90aKvQ9cdM/jYOa9xJjshnE9PZF/Mm9y2dYYThx94a
	0QGmcKx38QgKJw1EzVLX0k6kSvnAnFoevsQ98i5dbAZM7k1/5mr7d6r3GoNSsk8EvLnpPlj372d
	zH+QLtmw=
X-Gm-Gg: AeBDievOakQhHa8fIi9Zrin6BYyqNm2ErNjSHpVZuwKBQsQa+RxzF2v+K9OLNCdihlr
	p6JQC3ZKH0HM5Gic52tSBl/E/wX9E6tQDcZU1S+ueoVhemM2nahaWpgYNix9ojA6RB4zWKXh5At
	9gMQG6Pm7wRr6fAkQmBTEs+HQLVcak5+xt9kKqw7TZynIT/UPg2aPen3Hw/3xUjWjXMONdoqSCO
	3p52Bj0CYRXny1t6PdkEDspdl7Q2LNfeulNMFKGdopmHkJah8KpenecMByCNJcufoyb95vi70db
	Pyg4+xWIfzlHkFauF6UTm6h7x4BkivM9wckIPdb/CyMexURbPZeJUb4uHgs64hC+RWnSZNLFNs6
	koLFRJ0qSigX92dEv98dt+fI/KISCNducGXcSH0PC9B7eNzPfHIg476OJ55EZvS8WXPVszJkxrO
	897HP93hFZuNwyGHXs8Q09XzRYQAYoXMT3XjVMnZPIIkpZFarmKbucCIbgUQmt/w==
X-Received: by 2002:a05:600c:c0cf:b0:489:1f3e:5f6f with SMTP id 5b1f17b1804b1-4891f3e62a7mr337824725e9.12.1777241940373;
        Sun, 26 Apr 2026 15:19:00 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fa9ff98csm285341795ad.3.2026.04.26.15.18.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Apr 2026 15:18:58 -0700 (PDT)
Message-ID: <07db83f8-5769-4aaf-9f54-2711ddad9eea@suse.com>
Date: Mon, 27 Apr 2026 07:48:52 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: corruption after block-group-tree conversion, how to recover?
 (data is readable)
To: Thomas Debesse <dev@illwieckz.net>, linux-btrfs@vger.kernel.org
References: <CALpuBKwmZRYX0Mag-gLSoL9NgBBR_D+iOeKX7sdhHtyAposGRg@mail.gmail.com>
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
In-Reply-To: <CALpuBKwmZRYX0Mag-gLSoL9NgBBR_D+iOeKX7sdhHtyAposGRg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/4/27 06:53, Thomas Debesse 写道:
> Hi, I just did a `btrfstune --convert-to-block-group-tree` conversion
> operation on a btrfs filesystem and this corrupted the volume:
> 
> ```
> [  786.278571] BTRFS info (device dm-9): first mount of filesystem <uuid>
> [  786.278595] BTRFS info (device dm-9): using crc32c (crc32c-intel)
> checksum algorithm
> [  786.442781] BTRFS error (device dm-9): parent transid verify failed
> on logical 9820282388480 mirror 2 wanted 5715946 found 5717327
> [  786.448020] BTRFS error (device dm-9): parent transid verify failed
> on logical 9820282388480 mirror 1 wanted 5715946 found 5717327

Unfortunately, transid mismatch is not reliably repairable.

> [  786.449543] BTRFS error (device dm-9): failed to read block groups: -5
> [  786.481199] BTRFS error (device dm-9): open_ctree failed: -5
> ```
> 
> I can mount the btrfs volume with `mount -oro,rescue=all`, I can
> browse the filesystem, and every file data I checked loocked fine.
> 
> Here is the log when mounting with `-oro,rescue=all`:
> 
> ```
> [ 2523.344235] BTRFS info (device dm-9): first mount of filesystem <uuid>
> [ 2523.344260] BTRFS info (device dm-9): using crc32c (crc32c-intel)
> checksum algorithm
> [ 2523.612830] BTRFS error (device dm-9: state C): parent transid
> verify failed on logical 9820282388480 mirror 2 wanted 5715946 found
> 5717327
> [ 2523.613372] BTRFS error (device dm-9: state C): parent transid
> verify failed on logical 9820282388480 mirror 1 wanted 5715946 found
> 5717327
> [ 2523.639263] BTRFS info (device dm-9: state C): enabling ssd optimizations
> [ 2523.639268] BTRFS info (device dm-9: state C): disabling log replay
> at mount time
> [ 2523.639271] BTRFS info (device dm-9: state C): turning on async discard
> [ 2523.639273] BTRFS info (device dm-9: state C): enabling free space tree
> [ 2523.639276] BTRFS info (device dm-9: state C): ignoring bad roots
> [ 2523.639278] BTRFS info (device dm-9: state C): ignoring data csums
> ```
> 
> The log reports SSD optimization to be enabled because those drives
> are bcache backing devices. Bcache was disabled throughout the
> operation.
> 
> I expect that recovering from backup would take 10 days, so I would
> like to avoid that if possible. If there are ways to recompute the
> broken metadata for example or other repair operation, I would prefer
> doing that.

I'm afraid restoring from backup is the only reliable solution.

> 
> The system is running Ubuntu 24.04.4 with Linux 6.8.0-110-generic and
> btrfs-progs 6.6.3-1.1build2.

Unfortunately the btrfs-progs is too old, and possibility the root cause.

There are some fixes in progs v6.15, thus it's strongly recommended to 
use progs newer than v6.15.

Thanks,
Qu

> I can run rescue systems on removable
> drives if newer tools are required to repair.
> 
> Best regards,
> 

