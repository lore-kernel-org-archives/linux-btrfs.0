Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17CB413B58A
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Apr 2026 01:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777426030; cv=none; b=udkkrwMMD17IK/GEGFOeOJZ9f89LntH9fjsyDTtArjf8AjLp2EZZ+KXyFojlb7TlL+jwJcMgb649wNkUfsNXElbWTTS5kjpEgmrK/J7X9aAJuoRMvDsWg1vnn+sKrSJWfK7iUsqIXqO1G4f3V+WhTNmxQ7Vv/gY+lgoJG3rLlVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777426030; c=relaxed/simple;
	bh=VsZR8VNfNVd2tGkP7ffId8y/73nApuUrOkS3KTEvroo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=il0LpMyRuRGm3T3uavowah7QVcrgFdm/cBaZOXFZ4UjoGEhHHW050lm3OBiqLVtzAsrcZ4Y73Dn3lzMaPk9cSPOvP/LdHrqnqYJRgWEtxng8FOGNGk6r2dPsB8Fkbpfdw+IQMmSe+3hct8SN12HUcnN+bunGISWPzKPz7JDeB8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=cCyzEwln; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="cCyzEwln"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4891f625344so3509265e9.0
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Apr 2026 18:27:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777426027; x=1778030827; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=b6V2ht6QyM8BSoPxgWUX3IgLL5djAJps87joivHoKtc=;
        b=cCyzEwlnsz4KzCGiv7MPv/a9DPU+0jGt1FzhHvIa+ABG1uo02Y9KeDCGaEPBlMW0E5
         UctwStwQvxhr4GMlHHzC1nXaNoF1gNK1lCbUriTuUXq6xZe8mTO2KIwaji3Bx6BoPQLa
         doypFo0zsMvmRruMjIE+F2+s/Ca3K8kkmbluualIfXDvNWgxtAoTg08bwRLk2wS3IRVV
         MWbUzIOnvkR8Cmvy9FyntoSBZPICNzW+HbTTKyQvN5EajYWqL+cgdW7djrPZxKMmeVaR
         pep0K9UndCHVm75XsQKZKG+luM2rFo2B1t1gvZiDUGMWVQpsZ5iZcH8rA3r1og2lGMgP
         Hf4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777426027; x=1778030827;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b6V2ht6QyM8BSoPxgWUX3IgLL5djAJps87joivHoKtc=;
        b=A7iIy78ZXHV+0Ovc7VTpUVCsouAB2i1rkc1Dmhq9SqUD+5lFtvugRMx19KsXwz2LCa
         Wleteyw5/zR0kZpLSY9l8bCzJHiOcRSovJJgUjEo26ZrOFB4bdz9kah/KqMiQLSBaL6P
         z2Ra+eRaesVbV2/AZ82jCznQVox2j1JYjNVUo8Bxfb6sLCtxU84oXJDIs5+nBAVjHcWR
         rh/foqj+eX/erzn0TsIiQSRZUmRcj+7HKBqI1wRNSslJzeniOkocpaoh4VYjHj811xZz
         3yO5f1nJFNcjBM5wxzJuUovHBRtZ8KeDeOPE0Rdfzagx9M9HITuEQ3/uVSX83upzispf
         TKoA==
X-Forwarded-Encrypted: i=1; AFNElJ9xCBrT3yuxtpXJiAq27P+qPUclHJMDtgz1LksVdnTGqEZYl9OOrkpBg0L/Cz9/PctCJRWBLGLRHw4gLQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+1T9qYaveF04fqLwPJvvlrQLk+/TUGmSplmeQ8GlzgHmcX9nc
	yO6cbiPX5kNqspExGUNDByJ3YhkdR42Tn7EcnO2Oz9MlZvzsoDxmsObu4m1HTJgf9zA=
X-Gm-Gg: AeBDieudkQPrhQVLpfxluPOZ/S/ZRN5bch3kxu6689Fo3wg1I/iT4qFIu+qbc9NnCow
	GTPnF0Y9QDw0VqhiXWWEo5eBXebamZZN2bEYmani8FBw5seerYjwOcyADDOGbMpU2g/Vdo75c7W
	jZyqE1wyh/EDRjFJJG7OAyBS81PmUt//KiF1W9C87NWg8/tdneP2eTlWHlJolvjQo3Bmo6+Vja4
	8Ul9lc5ItObSC008uSA9fZd5S6EBpIuDLl1uJwtMPR4W4Cv96gfd9W9VkOFq5ekUaIUGfDBCwXw
	yT2MnD8nJNOoYQCBTZiCFDEGgE23cvzzGwpULXE1J/7J88ZLrBLvWRcxq1ZNEcSYHoledMjgVvp
	y3hFzZowymV9A3vuxQu+mSu+3IDMiin4bl+9GElIM0sJ3M2mPLTpetLgwYlI8iedRJsuLpwssQw
	pPYV9Q6jtoxuaIf+1qmo+vh2gEK3ZcXnfMjHmrytrV8AyherwOIm0WbbteNPIJ4A==
X-Received: by 2002:a7b:ca42:0:b0:48a:5236:7f38 with SMTP id 5b1f17b1804b1-48a7c827faamr8349545e9.14.1777426027474;
        Tue, 28 Apr 2026 18:27:07 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-364a4392282sm402620a91.10.2026.04.28.18.27.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Apr 2026 18:27:06 -0700 (PDT)
Message-ID: <76cadf51-bc18-4a16-af19-1103e0b7cef5@suse.com>
Date: Wed, 29 Apr 2026 10:57:02 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Strange behavior with scrub, quotas, and snapshots
To: brainchild@mailbox.org, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20260428012128.Horde.f5fqQoIpJ3QCuz9LBZNU3Qz@nextcloud.brainspace.site>
 <20260428023344.Horde.ACdhtTWNQo0yzpeKOd7keUl@nextcloud.brainspace.site>
 <2bf2013f-ecc3-424a-b6b3-deec4f3b74e6@suse.com>
 <KAR6ET.BWL8BEMZPLSV@mailbox.org>
 <0f6f3f32-f0b3-4c61-89c2-6f931592f122@suse.com>
 <d580bc81-71be-4153-8d4e-58c4f6261085@mailbox.org>
 <19c6157d-235e-4174-8865-3d029f9a2de7@suse.com>
 <06Y7ET.5XM6UHU999Y21@mailbox.org>
 <70b6a4ec-8ed9-4f41-adf8-93eb06f24eb7@suse.com>
 <2CD8ET.98SA563QWYJ71@mailbox.org>
 <ac3e8496-26dd-43c4-8ef8-6f7223c1c61a@suse.com>
 <I7E8ET.MZV7K8OOT3YS1@mailbox.org>
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
In-Reply-To: <I7E8ET.MZV7K8OOT3YS1@mailbox.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/4/29 10:46, brainchild@mailbox.org 写道:
> 
> On Wed, Apr 29 2026 at 10:41:51 AM +09:30:00, Qu Wenruo <wqu@suse.com> 
> wrote:
> 
>> Nope, just disable the swap file.
> 
> Is shrinking the volume safe, or even possible, in the current condition?

Shrink is going to relocate some block groups, and if any block group is 
covered by a swap extent, the shrink will fail.

So I'm just asking to disable swap file, with all the explanation 
provided, then balance data.

If you do not want to follow, do whatever you want, you are on your own.


All I can do is to enhance the docs and hope there will be no more end 
users sticking with stupid swapfile idea without really understanding 
all the limitations.
