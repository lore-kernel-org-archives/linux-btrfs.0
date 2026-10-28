Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793180578;
	b=Wf/giUWKL2DFfH0NFdbkLOjaZf4Oql0g2SMp87NuJGDvfVNK+9JQ4UM3qE0SN2nqHYZf
	 9BiN8Vxt5P8w1GETfXrGsJiYhlhZy+dKCWu5idciIoRUhU6SdhEvyeN+GH1leLxFljEAS
	 9NkU3831S792xGxM4gtzjXwgP80k5l+VMG1sRzQ5g9guLVFKp/LCF8VQe+kito/Ru+nwR
	 GgAmATxAresd7jMHaAPKCCXDSGJ6Lb98b8bicC33TZZgScI0NeupLr9I+Ts/iN/cK+Joh
	 3r1xmu9YcvQjFliAZwq4iERnxFjKb3EhhO7DQIuIhPkodyYugQfvvb8gsEekuArLSMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793180578;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=ueELwOQ2FDXG5TiDh44KESshsBtDoYUCI0yAAS1GQkM=;
	b=URZFuVQJ8YgNf4d3WV5oKaP6ZAmqoJEvvH6B3BvETvH2tkN9SGm7hTnqwF3um0KILWLA
	 fUcaKUGpWTAtNMQKVqLi4CwmjuWqh3WGEDAS4lbfwrVlBKdzCpRIe7L1TQm7crrJQGrHv
	 lTNadZqPATZnj9Yw1Eu7NlqppXAt0qPfkHrCqc0tgdccHdPH8+OnCYccXMNx5w1nxtPLG
	 gtNweQk3IKXo6NDnhzyh6pJ2XiiDl0syF0187ZkC3JfTIpYNt7DRT2BE8U/47Eg5ig5jd
	 RVfiCUKWd/FBgwkUwbqC75Fbd+qyCG7xQaXv0cnmNOFIm8Da3Io+OFAkbVGxmhYC5ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=PQbo2XTs;
	arc=none smtp.remote-ip=209.85.208.48
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D36606A31C
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 09:42:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 32D36606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=PQbo2XTs
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6b2237b596cso1399230a12.0
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 02:42:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793180576; x=1793785376; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ueELwOQ2FDXG5TiDh44KESshsBtDoYUCI0yAAS1GQkM=;
        b=PQbo2XTs7+JUGRlUTGTxRJcLFYhBLPTAshSkvaFFlLlYksL0EQpA98PaJOvbXAjLC6
         PNot3kPgSWYUxNOFPqraAZDoxNxXQCo2Af/B9Bu700JashLq2YAwe8BCZoCR8NSV8a8J
         5T6i2xwk+1dQ3H6KBVjctA5LDZmzfK/m8MjsFrddK7HxiXOAdyyA7/Vi9KYhfx2+GsaH
         o0WgW0D+FrQGnhHI+cy7kn5eymCH9o3QQR1eDPSQzsXhf+1+WXZzDk15aUIzrsBzvHwK
         uIPJwAGw9L3nZ1eCw4iSDjNASRZUhMNAUyQzonqf+S8EhiDNGmXedfKUtIzq2VlwKjcR
         BK0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793180576; x=1793785376;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ueELwOQ2FDXG5TiDh44KESshsBtDoYUCI0yAAS1GQkM=;
        b=omuQ3NprRA4Wzt4E6TqWUFPWuuq+7lRae6YPFiBtmdiBSIBqRafjkUELeuQi787Mkc
         YunTXfGN5Gr+KsjBNRFkqj1PJ1CmXdp8LV/Atghkxf26a3sPeB8UrELoUhpkykx4udc0
         fweIul/oO25eK8SRQwz2eucnpcgTwhzh/oLWKRWl7W6p1pMTJDxkvDBQ3I7VQJI5MViq
         sxLWrqBgFrSgKdnx35FOidzTadOVzv4xhYJ6V0Bm+5t35CiEwNV2QG4nDxFekXuCiaud
         EUzVpnq1RObZoy0BttajNbYu0zMEy+zvQuKuIOwwO49ynow9xpK0rchueU5Y8z7uenVC
         NVNw==
X-Forwarded-Encrypted: i=1; AKwUvBy+mdVacLsUifGHXwttTn3Sw4mT52A+uqYOZ52OOK2E5bixised72+yZdtFSi8e/uJe+wAI1ZE3LANnQA==@vger.kernel.org
X-Gm-Message-State: AFq9FYK7Kn7uaMb28qzY8Ka6ID0DI0R2qS1UB7yia6PI2MQgiBgQ0k6c
	6xMMNzOs0NU1hVeDaveqoEwnaovlouFk/at4aNEywfG8NAgOmCweZNwnXM33tOdMO/0=
X-Gm-Gg: AYBFou0QIGT4pkOe5WClsZ6ayCbxiW1F/BBy0rrOWxrHSDdG8r30Ocykk3a0z8WHOYP
	Ol1caMbGQ2zgNjjX4HNAegKgwQiAlf6bAiufawkJrHRjZnwpv8HRBeZEZbYgDOlq3z//BjCzgvy
	I1Df1B2SWSAIeANCz88a/F8YJcrX8B9w/Ogem6kXOxqG/2zHqq/xf4cBsvQZ/g/O5Q8Gy6++zE9
	cDS+j5/SON8zzK2/sihQXUPpMt30LLSiM54nP1giRYdES72yYZWNJ/R96jSo2eotZe03lviqutg
	Zxr/bKxiYWJVUTsZpfg4hfXFR7tZVXlaAV7DgS/0g4F7um7L99PUugjYDaTXOy/DnxQ5U1j/23B
	QdKS+YfUJgkpqOhgou6mGpCobMUOQk9TG/ttXcVH3WFqimEGSE9aBWplwTjnase2b9M0TjaxhYj
	UB+cxazOipHpcSQFnH84iTDKQgMKIrQ9ocSYnVfbGhQnrURHNNnWupPXILtH9KFoTDuTRR6WRWX
	fZFfZMaNNcSP67ruVLHiURK9zj40GHU19FNJ3zhtoqPr+iPs/bVk2gPejZ4Y8TsLXh7+7aFkudF
	MweqhVnX5hV6/hiifxbCVA==
X-Received: by 2002:a17:906:9fcf:b0:c46:7ec3:fdfd with SMTP id a640c23a62f3a-c49bdf2b6b9mr156981366b.14.1793180576460;
        Wed, 28 Oct 2026 02:42:56 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a6a67228ffsm926320b3a.32.2026.10.28.02.42.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2026 02:42:55 -0700 (PDT)
Message-ID: <84d8eb19-4264-49a5-b9b0-733c4e971433@suse.com>
Date: Wed, 28 Oct 2026 20:12:49 +1030
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
To: Luca Stefani <luca.stefani.ge1@gmail.com>
Cc: zhiwei.liang@zliang.me, David Sterba <dsterba@suse.com>,
 Chris Mason <mason@kernel.org>, Filipe Manana <fdmanana@suse.com>,
 Robbie Ko <robbieko@synology.com>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261028-btrfs-fitrim-freezer-v1-1-0ad1d58aa94d@zliang.me>
 <CAO0HQ0UE5BtevPHHfV9mQo5HoqzxzDDjAkj9e=pD_0AaXmSYFQ@mail.gmail.com>
 <65fd2260-78e1-4521-9df1-b042788ae7bc@suse.com>
 <CAO0HQ0W3rALzPX59mVONjDtK1otyS8bo6_hGG6og3qwyLepmnA@mail.gmail.com>
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
In-Reply-To: <CAO0HQ0W3rALzPX59mVONjDtK1otyS8bo6_hGG6og3qwyLepmnA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/10/28 19:50, Luca Stefani 写道:
> On Wed, 28 Oct 2026 at 09:57, Qu Wenruo <wqu@suse.com> wrote:
[...]
>>> I don't know what the intention of btrfs: handle user interrupt
>>> properly in btrfs_trim_fs()
>>> was, maybe we should just swallow the ERESTARTSYS case in those scenarios.
>>
>> I agree on that btrfs is the exception, we should follow ext4/xfs, not
>> rely on some tricky signal handling behavior for suspension.
> When I updated btrfs_trim_interrupted I used the same "checks" as
> seen in ext4 so at least on that part it's identical.
> 
> What differs is our error handling: we set/handle -ERESTARTSYS, ext4 does not.
> ext4_try_to_trim_range only ever succeeds by returning the count of
> trimmed bytes
> even if it checks for trim interruptions.
> 
> I think if we remove ret = -ERESTARTSYS; from the
> btrfs_trim_interrupted branches
> we'd align the behavior (plus reverting the previous change as that's
> now useless)

I think that's would work for most call sites, but there are some call 
sites that we may want to know if it's interrupted.

E.g. btrfs_issue_discard() is very deep inside all trim calls, if we 
drop the return value without any other extra way to notify the caller, 
it will incorrectly return 0, which is definitely not a good idea.

A safer solution would be keep the existing ERESTARTSYS, but change it 
to return 0 for now.

But if you have a better solution and can completely remove ERESTARTSYS, 
I can't be more happier.

Thanks,
Qu
