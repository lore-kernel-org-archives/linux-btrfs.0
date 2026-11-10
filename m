Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794347008;
	b=tAvyeEksKph8Y/g5vPIXumwLbfY6SnzVQ8ouXmPwYNENBaKjuyWoQ+9dYlqsutnwZRRp
	 7ec5bov2UxRTxxAD64EzsOM5vfgA385X+pPzy4sr4Jwb/SOMmmKhHWOdYFYMrggFoyBpj
	 pLJ3EMjWr0YRQNVlBQ9ey2I4Vg5uYjysUIxwPGdGWYUpP2VVph0LwYbq+9lD+6GjEMmLS
	 xf0oBMAKNwWxT22tVThgQ0xIzRWmbravsjQtwNNZQrvMzm7oqtr9KL3SbUzedeMR4U+Fk
	 Zv8PY6M/az9SUlQ9nZio5wvEn/pxiUjKylbBbCJNh44LoiCS5ryiJOD57CvQSaK9V3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794347008;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=U9kz3+3ihojogRxIoDRP/PIcvbN9QjsF3NIXqjWq3As=;
	b=0Q2ZnoZo0PjOGfuefPegFNzJCPZ4hNJrfp1ruRpKHcCBY+yKK17I4hCeFAGuhW0mkB90
	 BKeuadu7cddQXUKbl68rnILpVC80QuISg2XpFP74xmdpWVU2bDu2mdS8wen13WAQCORyf
	 UydwZ9NeNdxEN9tdoNAQCG+G3a1uby2avvEENeZyLg5cgLIjrPqecTnSWKK45KmhZUqqr
	 NNw0swarFmMK59dtHlsvFe/roFaYKMq65swm5Qgm84OUlo5yD5JeqQnmAonVQcyaY6ysd
	 Eqg007g2W1E8jhEXVhNMrix9KZ9HiP6zlNVYX8TcPISP9qHY91H97g9d9YsYtlnsvzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=aQ7CeEAK;
	arc=none smtp.remote-ip=209.85.128.45
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9CFC606A321
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 21:43:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E9CFC606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=aQ7CeEAK
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4b7252a32c8so27761865e9.0
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 13:43:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1794347006; x=1794951806; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=U9kz3+3ihojogRxIoDRP/PIcvbN9QjsF3NIXqjWq3As=;
        b=aQ7CeEAKXo4E5ktESEaqoDO/KNxaS3AFoEZC+Jh61dQzdpUSwkU4fhf7xFlzGXfuzI
         OFYKIO0Yg0CewXiAb0NJ4741tbPraPU5Jz+nd36C3rgc9i0JGoJZ8p1a4Zysf+qNStNR
         va7XswEtPjBl9+Oog7zVk3KTvpHZ4gKAOYo/6aYkZFO5i9ULbc/kzjQakeLoEFESwR6w
         GIh4Zu9g4JDVZ0+oqFv2wLhM9HrwBddNiJMncGfxI/HRTLW7T6RgAWMKC3e+JaH+Qh8y
         w+Q0MNeDGF9q8r6nRPann90/9yPjffGPnwRBWklDue/JUqPjAvciRxMbRl7Uyj8KnGqC
         Rp1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794347006; x=1794951806;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=U9kz3+3ihojogRxIoDRP/PIcvbN9QjsF3NIXqjWq3As=;
        b=USiERhB87FfR7GFYUPD8QkYT4v7/wBjX/wphLY1BNcs7EoFzIVYGYdWf/TLnojblz4
         WDPhbq/fr5PiwdHsZpu83gKqIiimFei/iXlO0pGsXhvy/gPSHd4xdECUaDy9bYHA5Sf3
         f2KiNenA/Q/5qi93ojGeVYDNp9CAkBel0mBhXToZ6Tp7v0KLp99NWwKggNkTu/vWiDFP
         CP6P0qVzAEiGX0rbyDwliesC+hpv0YxmLUHiV8V0SOnnlk9b+Efhh+qrBaEA/SL84RoY
         MJ9IzPCsbvqcJpdOiLKpnlFbTABV7a2CZb50OoLk4wFfTbpTdoaoPKYJLQjPIC0BMETu
         tG8g==
X-Forwarded-Encrypted: i=1; AL+hErFOQIRM0H5jHsxDLdt4Mfm3/iQiFpQwy4L1DVdjJo2J/C7aW29rboo3aBhSJpJnk2E0UO8dknJeoboJcQ==@vger.kernel.org
X-Gm-Message-State: APuU4Z8Zyg9CFA0HE3Ka6cX5zyqfp67I3YEOMEBA5BBA3rR8oh9LKR3q
	Up+v+XOLukMzPWCtFUTmpT2lDugsxLPbUB9JYUjUu2brNfVD7KYABR1N2AMNfdxU2oauEmxt2ae
	6B1xGJrGrlA==
X-Gm-Gg: AYBFou3Bt+gQl9WzJcmipv8rST8+dpAMpmFycxT5mxuppyRgSFGLrOErvU38jsKTeld
	pS2wTwL0zgKmdCgdvi3QaYVqjwlA3biv0fwGGrLDbC82jIVBkWJVrYx1ApFdEfa0oj+aEf13jyx
	ifcVaBcjhhcdAIqJ/NW1EobE+6KyvLQK42z0HB+5iTp1y0fd3+AZArM33TqH6/Au0onMQQgAm7U
	pwY9xWoK6x+N1nn/cnRNXG15gNvVN7/39IXEF6641uGoZ9zC1KokcTgEwyk6d61t+6w3EXpyQiB
	TbdZYkLpqooXLE5y8/98cn9olnjih1vvpZyXLlAR17mIuFyKGPowsJPCa8f+nst476/g4NleoBV
	IGjxwa5MYuioQ6nmGscxMtfi8eMjRTs0YRT4u2kQBdzKTN4B+yxVYGllJyvEBIRsQw24KPdrO1L
	wS3PaJeQB1JZlA25r3NS971Y5F/yVFhVZYaEQEq/5jTupHluQsSWZlqldFnf95QTXeodpiZCG1z
	/WDTQweXcT599zjg2rH7tl3BLOSYb5Nc9BQ/aBqzAPKNpoJ8eCjg6zpKHIFqBJYpzH5KP9fF7uB
	sret9Q8n1KhmCGYPpyMxqA==
X-Received: by 2002:a05:600c:64c6:b0:4b7:6aac:7406 with SMTP id 5b1f17b1804b1-4ba0931e0cemr6598965e9.3.1794347006294;
        Tue, 10 Nov 2026 13:43:26 -0800 (PST)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8baaa86ce5fsm1430725b3a.21.2026.11.10.13.43.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2026 13:43:25 -0800 (PST)
Message-ID: <faccb3c6-88a8-4803-b675-5a77733421f3@suse.com>
Date: Wed, 11 Nov 2026 08:13:21 +1030
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
Subject: Re: Static review: QGROUP item validation and read-only subvolume
 behavior questions
To: Noah Weinberger <NoahWeinberger2003@proton.me>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <B_lvw-WNI1mnHnK011Sfk_ZNaL0eg5uOfD2T3q-vOfWv8426VwPA4NPpWaAcHxRZf3OrzGzwZjckHqKEKUS7UQJk6TEN_7xD1SkwM5q8hsw=@proton.me>
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
In-Reply-To: <B_lvw-WNI1mnHnK011Sfk_ZNaL0eg5uOfD2T3q-vOfWv8426VwPA4NPpWaAcHxRZf3OrzGzwZjckHqKEKUS7UQJk6TEN_7xD1SkwM5q8hsw=@proton.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/11/11 04:21, Noah Weinberger 写道:
> Hello btrfs developers,
> 
> These findings were identified by GLM 5.3 during AI-assisted static review. No dynamic reproduction was performed.
> 
> I am sending two hardening/behavior questions from a review of fs/btrfs at commit b3dfbde62cf1981c4638939c159dfd087b7a72e9. The source anchors below refer to that reviewed snapshot, not a claim that current main or released kernels have been independently reproduced as affected.
> 
> 1. QGROUP item-size validation
> 
> In tree-checker.c:2400-2470, check_leaf_item() has validation cases for several fixed-layout item types, but the review found no cases for BTRFS_QGROUP_STATUS_KEY,

That is already added in the development tree.

> BTRFS_QGROUP_INFO_KEY or BTRFS_QGROUP_LIMIT_KEY. The corresponding reads in btrfs_read_qgroup_config() use fixed offsets at qgroup.c:463-485, 531-541 and 543-554 without an item-size check. The assertion at qgroup.c:411-413 depends on CONFIG_BTRFS_ASSERT.

I'll add them soon.

> 
> The hypothesis is that a short QGROUP item could pass generic leaf checks and cause accounting values to be read from adjacent item bytes. Accessor bounds checks at accessors.c:63-66 appear to contain reads within the extent buffer; this report does not establish a kernel out-of-bounds read or a security impact beyond the mounted image's accounting state.
> 
> Would exact-size validation for these items in check_leaf_item(), following the existing fixed-layout validators, be appropriate? A useful regression property would be rejection of undersized QGROUP items during leaf validation.
> 
> 2. Existing writable descriptors after a subvolume becomes read-only
> 
> The review suggests that an O_RDWR descriptor opened before SUBVOL_SETFLAGS marks a subvolume read-only may retain write access through some mutation paths. btrfs_do_write_iter() at file.c:1403-1443 checks shutdown and filesystem-error state, while the reviewed btrfs_write_check() at file.c:1027-1072 did not show a read-only-root check. The read-only check in reflink.c:857-864 appears confined to the clone branch. SUBVOL_SETFLAGS at ioctl.c:1327-1413 did not appear to invalidate existing descriptors.
> 
> The proposed scope is buffered/direct writes and potentially encoded writes through pre-existing descriptors. The review also raised dedupe, but did not inspect the full VFS dedupe path; dedupe should not be described as changing logical file contents without that analysis. mmap has a separate apparent guard through file_update_time() and btrfs_update_time(), so it is not included in this hypothesis.
> 
> Is open-time enforcement the intended contract for read-only subvolumes, or would mutation-time checks be useful? This is an unvalidated behavior question, not a claim that the flag is a security boundary or a request for a CVE.
> 
> Best regards,
> Noah Weinberger

