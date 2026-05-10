Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E63042D739B
	for <linux-btrfs@vger.kernel.org>; Sun, 10 May 2026 22:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778451523; cv=none; b=XxMUNP0PWtQmSK03YEBjBdI0x5V82WKAnQUOeb/EV7Wx+hKmS+GVhSk/fo4rslkS5KKrBS1hqwP7T2XO0RwUsoUsL7FqveNavOM2zTrbYR6pVkWA2mkEWo72NX6U590JQpXH4NGilsh0WOK3yaUdIFYqtILj/E2O4txH70S6T6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778451523; c=relaxed/simple;
	bh=+ATBH66DUg2zHZ0+GKTqEbJJPhIgYCNoAjG/RGYg5xI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XuEbuWTVNRznKRNtKFOTOnasIKWKkg+v/zvzPlmt/MpQ9NIyEQbS58dKLfAh2kbkufKRVY6i3HC/l4vznpEs01fqOMJIb1a3guE5zuvqel5Y6IDrf3yeD4Aao9mjdd8q9/PiVhMIyCb07/D+QXd/VHgxGyJ+W6PDGgpd+yjzVVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=O+mg81hN; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="O+mg81hN"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4891c0620bcso25245085e9.1
        for <linux-btrfs@vger.kernel.org>; Sun, 10 May 2026 15:18:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1778451519; x=1779056319; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=2orhtQLkaR2F4Nhw0IkD2mYir2NwtxOcoY2NIC265aY=;
        b=O+mg81hNbTGPYzQczHNffSOg3hhc5zwVQKvZkESTqToVjjU7xHB9KAu8GoNXEpLsXQ
         MBW3poLB5GOtDws8/W2FJ/4YIjdVXKUShOoknk1G9caYSV1okCkCJaQys6uk0kvrfHcM
         CJ70uho7ZrvrAB6x2dUYdDCj9YwXrw0br5aAYsIhA6rlLt3GShWuUvU9kA99YfJbN3Zz
         7/7i+eDVt+XdYl7Frsx2pCEaqCgPDT/08LQZ9JxDA7/IATJKQwAteVcBwkpBcM8Xw3W3
         2aivlS9FMQoq8kCxntLJfU98h/ULMOJrwAa8Lt37cdhSv8kSPVKo7fzcMk+IzsFikNI9
         tAgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778451519; x=1779056319;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2orhtQLkaR2F4Nhw0IkD2mYir2NwtxOcoY2NIC265aY=;
        b=p+9Os3RMRRdcTqt5AiCN5BzIjui5HJEDretwaQYY+9ygaX7aCQOvN/QKEpwvRuoT/E
         CJhcfm8tyhIEZeC4ZG4Clxjy74B1fVU9+tVEBYRsE/gyh2+8KV/6rfzM0LQa6FSW6KJS
         CjT17FqYEtz7pBPIGSTyOjXcStYULcaXU3E8pX4Te2ZFR4j4KZUI2KKCl2g1wrI0j4op
         YsNkSrc3UG+O/SGDD51FksXfLcewqcOBA+OAtf4ospz5cMqmrAfIYYTVYCWVMCPC6XCf
         XlcgOp93SYQ+h0MJ8nzp416qnkir/NGq65Sp+imXe164ZHxzf7bpBywInoneTxACZ0ul
         L91w==
X-Gm-Message-State: AOJu0YzkQ157v+ce2k2Oz/sCAYSAx58rnfOkNjX/Joa9du6Qkr8Ud4e8
	54EoCGjRGJgGsa0s+qfaQTxot5+lLExxNGAHY8lq0X1SSL/EqJGADiTgYqkVqXBYJNU=
X-Gm-Gg: Acq92OG7lm6hiteWOFfw1pm4NuOtl0wKQmKhmpk5tspF6zqdbDlt6jJC/FqHvlf6S/A
	4i4ugxMfJjEfL4oJv/oPo0cn6P2xtoQxU7glncjLj1lOK7yoNhAv9FovPeNRGU4x5Qtn4DHE2mp
	KU6QrANBz07CO5SjYb5ERjCMl81sgz8SozqngWmDSiX9I++EFCjznr+zqcGEEZEvBpnvJTcew4P
	R7oa+JP1h8jKwPpRlyAH+dd886YIu2O1lnPEu9rfIergc+0JxlXRCTfaULacq5SBt5IWMwLVuit
	Yme1VvWrI3SO4RQ/9NapI0y7j1zyMqOTjQWvRZqhTfVGNoJeOeC+rrY4e304VsRX/g9ezlwuY/9
	nRWUYgWO+vUAJ1I1fFzgkiFvKg09i4z7fWs/x7GUWsh+8leGNt36QSnYSh8UMm8iOufprdDurrU
	1umK4H8lbu2qdagFk55bJycUmzh8XCgZazOUMRYyF83Pl31QaZlrlzoy2XUSRA9KP7tqFGtJwlG
	Ql1WNkZrB2AFFHgUT0SUsy3Oyk/u0GPa5CaUPpV+vrRtdyJzwn/zKnrmnUIvZcRcitP
X-Received: by 2002:a05:600d:8:b0:48a:58ae:993b with SMTP id 5b1f17b1804b1-48e676a4e03mr172158145e9.16.1778451519266;
        Sun, 10 May 2026 15:18:39 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83965d34872sm18488520b3a.22.2026.05.10.15.18.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 May 2026 15:18:38 -0700 (PDT)
Message-ID: <b4769807-4175-440d-915a-e2bcd4af06d4@suse.com>
Date: Mon, 11 May 2026 07:48:31 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] btrfs: free-space-tree: reject mismatched extent and
 bitmap items
To: Zhang Cen <rollkingzzc@gmail.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 zerocling0077@gmail.com, 2045gemini@gmail.com
References: <20260510074943.2644334-1-rollkingzzc@gmail.com>
 <ccb16e1f1b9490dc3d76e219cc2d9fe8cdd3afa7.1778403060.git.rollkingzzc@gmail.com>
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
In-Reply-To: <ccb16e1f1b9490dc3d76e219cc2d9fe8cdd3afa7.1778403060.git.rollkingzzc@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/5/11 00:33, Zhang Cen 写道:
> btrfs_load_free_space_tree() reads FREE_SPACE_INFO once and then chooses
> the bitmap or extent loader for all following free-space records until the
> next FREE_SPACE_INFO item. Those loaders currently enforce the selected
> record type only with ASSERT().
> 
> On production builds without CONFIG_BTRFS_ASSERT, a malformed free-space
> tree can therefore be decoded in the wrong mode. An EXTENT item can reach
> btrfs_free_space_test_bit() as bitmap data, while a BITMAP item can be
> added as a full free extent. The latter corrupts the in-memory free-space
> cache and the former can read beyond the item payload.
> 
> Validate every post-info key before decoding it. Reject keys whose type
> does not match the mode selected by FREE_SPACE_INFO, and reject keys
> whose range extends past the block group, returning -EUCLEAN instead of
> feeding the wrong record type to the bitmap or extent decoder.
> 
> Also reject zero-length FREE_SPACE_EXTENT items in tree-checker, matching
> the existing FREE_SPACE_BITMAP zero-length check. This keeps the loader
> range check simple and prevents a zero-length extent item from being a
> valid on-disk free-space record.
> 
> A malformed extent-as-bitmap record was observed as a KASAN fault in
> extent_buffer_test_bit() (fs/btrfs/extent_io.c:4313), reached through
> btrfs_free_space_test_bit() (fs/btrfs/free-space-tree.c:518) from
> load_free_space_bitmaps() (fs/btrfs/free-space-tree.c:1603).
> 
> Signed-off-by: Zhang Cen <rollkingzzc@gmail.com>
> ---
> Changes since v2:
> - Regenerate the mail-ready patch without the nested mbox wrapper.
> - No code changes beyond the v2 fix.

If you want to put a changelog, please include all modification, not 
only the last modification but from the very beginning.

A proper example:

https://lore.kernel.org/linux-btrfs/335133ce1989ac89a6de007d4db05f5f4a6c1be2.1775491985.git.boris@bur.io/

Otherwise looks good to me.

Reviewed-by: Qu Wenruo <wqu@suse.com>

I'll give it a full fstests run before merging.

Thanks,
Qu

