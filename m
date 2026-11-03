Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793681405;
	b=2pAAbp21jR5wjeB5snxRqNiyQa0Y4j7lvopCvt4qA+Pl/UM2qVf/9DpfAxXH5AHti9r6
	 x4FHWegmvX6MdPVBd3W8wg2xPYh98bQgSVLpPvJ0Bjf7KkkehNM5OXV8hSubnQfd4jytk
	 PvoV2e0HCNlM9Za065bcpGaYzqg9I49Ee28NnwRKSdERvc1YPxfXKTznqtj+ngKXBuUW2
	 rdTZxhGFXsMy6JlARpvjX9SXdOi7xxy26mLzj9Y4nbNNyAl2KMn7J5HYPHYKvSdxaSb+p
	 CCnkrXlzZU9UjTgAZeHqXFf1evr5HtY3IBS/AwZgPFYwATId8j3azFxFijAAuFhiFlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793681405;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=wUXebkTiYhnjPsjVCSLxjXkiJ+lfTztqlgsZwwE/3TE=;
	b=LeUcwUPK8KkhKeRWlbMkNRv8sVtNQtHupdbVjHqZQNa7HviASjEfQYyU09Gy2TcUjYP/
	 ghQLS580Du0xo1/0XRXDImCMJl0kaTDSgeHAY1RfdE79mZT/EYSlwHX04rvotNN5l3tyt
	 ag6OwunqYgaGlmho0TyVOm+lcgA80CdZbiIyAr8WfmqzxIYUA8a95Zgt1cr1P62NpNiWS
	 HcybRDDInPadC5IfkBPaJmnFcXxTmCbe0CYHgf3BPpWgha6QzQAARCpXMng2wadKeR52x
	 oejvb/guQNv+kZsXnbKOtfQKQAJBV24buKO2Xm8li4gA3JO5IkYkZlS7wKo94m+Y8lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=DeAcZ9yP;
	arc=none smtp.remote-ip=209.85.128.44
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A378606A324
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Nov 2026 04:50:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6A378606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=DeAcZ9yP
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4a2069b9710so31201895e9.2
        for <linux-btrfs@vger.kernel.org>; Mon, 02 Nov 2026 20:50:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793681404; x=1794286204; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=wUXebkTiYhnjPsjVCSLxjXkiJ+lfTztqlgsZwwE/3TE=;
        b=DeAcZ9yPJNzs+Dh6Gq/D9XmFNx3Rpa0xQ5+ExNzIXA0DGfdXyOWPmD+hqe9cs+h62n
         qIHAkGZmtBmUX7vFW6W8pQ7NUIWySIc4sQlmxWJkQf7UccbD7b5truIhFGxXb92RuUUn
         YHmzglkN/ReQ6f+dckuhtgORGXgx6sUCn0IVScM4WJyuSbyy+AFgr4dMizBOzrGHFPhh
         ytIEVwTrrnk8YmLqeQN4g9I5jRlnsHRVqjFUYv7KtBCIQuaPgR/c3tiqNRxBfWDYdB9z
         p5idQIjJyKhnx9AJfuBXwpLs/sq7RetlR/k7W5igRk3Dlsgg4sZ+ox76hK+OKgndfCO+
         ABzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793681404; x=1794286204;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wUXebkTiYhnjPsjVCSLxjXkiJ+lfTztqlgsZwwE/3TE=;
        b=OQkEdjxi45MmUC7LPralu4ScRes0X4By3fQA9b5KdjMLKhEpfHwN3bHBx0frB1RwvQ
         09ybj6jxk9TuhHLw2nxoL5t0vGwLRYN9Wp6YDymir8wfExly1yF0eKW1BwQISix9slyt
         t5C4i67toYO+thacedbY2MkWs2Y8jk2mQOR70hP/FI4LvTaiUiO47D1cZEiMWB554EJa
         jeKnOv5TOIXAGBoao3QJFkarVaLbyM72V0vCz0B7zyGhhcB8qwSEvdkr+zvuyAH6eJUs
         ctXfCpkJQP8um+j5Txrw/0l3j/xINnM9KsfdO7/rwtdiFf+r+a8I0LOxbzWiRbreG+NW
         12MA==
X-Forwarded-Encrypted: i=1; AKwUvBxUJppeqt61ukIeqd5QNj/l5M/+UQnosCbUfAv+ADF5fh5MkrySDX4e2unFu5hEUawgEhz2SJwYzVgnMw==@vger.kernel.org
X-Gm-Message-State: AFq9FYJjnUl4ra9GLbPDlN9yMqQTpRnJiE6MsD2L4FmVg6+LE/ZY1pNo
	zF+z/0gHRVOPlPveLzwPrUdVAbM6of7VmWrSTL7GWj98wP0Z8ybGUURgq7o/DIVVzqY=
X-Gm-Gg: AYBFou0qoDoLW/CyMJhveFx/e2br2lQMpUigW6SHV6lNfQx6lekTIIuw8dTCqOQj+x2
	Z/fQ52iEf/k0hxHO7+8n/i8+Yl+Vaa7D6+qlXLXXTFns7CDaV6J5jFDcVMYxg7Ss4WcfU9rjYMR
	wE/WsHJL3enTdiTbgno0X3e/N8yQD5byEeFHF45EBuykbkz+3LGLx1yBENj2oAO1ty6Gnta7aI/
	BEOJG9ilLrxEWhocVv0cFrQu8UlmiACUyY7DU7CLtV3Um2fGzDV91cQ7iUY0Q2AiB6JGDn2bkJ6
	C9OuMhXk130xYlJeZi+0XXZ+kVNCQhSIIpHIBjf2OUBJu11CZylNQlvi+dkdsUbynL9iH4uV5am
	ag9BvWZoFh6DTZ+mH9QD3QHhVhqv6Wpzr9KhhGN2jeNKS8LhViuMfJfnrfM8epNliq62JRXsMRG
	Tub9oaQF2oG8MXGXcPuLOsc7zf4v8mjfBHoQ7QMMqH6y1nCA8Q7qJj1GDp/Stxrkgusb+Hev/SH
	9hH4f/y/odJ90xlZsuZHckIA9+qmjkESBSUc2yKVXZU0cMsSkYHQ6Iy0zBkjXJUMmCqks+9BIYl
	lvoL2XosHpL4Qpu3tP3OCnufGqvcvDlgM9ZtxNJ61Ek=
X-Received: by 2002:a05:600c:46d2:b0:4a1:7ec7:a479 with SMTP id 5b1f17b1804b1-4ac1980118cmr258105685e9.33.1793681403170;
        Mon, 02 Nov 2026 20:50:03 -0800 (PST)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac1a136537sm38688111c88.18.2026.11.02.20.50.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2026 20:50:02 -0800 (PST)
Message-ID: <5f5436c7-02e8-4aaa-933e-ac50b75c180d@suse.com>
Date: Tue, 3 Nov 2026 15:19:58 +1030
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
Subject: Re: [SECURITY] btrfs-progs: stack buffer overflow printing a crafted
 ROOT_ITEM (print_root_item), reachable from the tree checker (v7.3)
To: Thai Duong <thai@calif.io>, linux-btrfs@vger.kernel.org
References: <CADdoe42S7PceeJtXg1zm6Zn0g5GK90JnS0PoCtY2YUF5wp6+sw@mail.gmail.com>
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
In-Reply-To: <CADdoe42S7PceeJtXg1zm6Zn0g5GK90JnS0PoCtY2YUF5wp6+sw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/11/3 14:08, Thai Duong 写道:
> Hello,
> 
> Calif.io, working with Anthropic, is reporting a vulnerability in
> btrfs-progs. print_root_item() in kernel-shared/print-tree.c reads the
> on-disk item size (a raw, unbounded u32 from btrfs_item_size) and
> passes it as the length to read_extent_buffer() into a fixed 439-byte
> stack struct btrfs_root_item; read_extent_buffer() is a bare memcpy
> with no length check, so a crafted ROOT_ITEM larger than the struct
> overflows the stack

So far so good, a regular memcpy() bug. Thanks for reporting if your 
report just stop there.

> with attacker-controlled bytes and can overwrite
> the saved return address. The overflow is reached from the tree
> checker's own error path: check_root_item() rejects the oversized item
> and calls generic_err(), which calls btrfs_print_tree(), which
> re-dumps the leaf through print_root_item() with the same oversized
> size. So the tools that parse an untrusted filesystem image (for
> example btrfs check, btrfs restore, btrfs-image)

With the help of LLM, one can always convert a memory bug into whatever 
CVE they want.

A lot of tool like "btrfs-image" and "btrfs ins dump-tree" are only for 
debug purposes.
I do not even think someone sane would be happy to just run "btrfs 
check" on some random image downloaded from the Internet without any 
extra protection.

I hate the trend of treating every bug as a security bug.

Sure, go ahead and treat it as security bug if you really want.
But we will only treat it as a regular memory bug.

Furthermore, even doing the extra protection, it may even introduce 
regressions for "btrfs check --repair", as at least for some cases, 
"btrfs check --repair" should be able to repair bad item sizes.

So the whole situation will not be that simple to address.

> hit it while
> validating the field. It is present at v7.3 (the newest release) and
> on devel and master, and no CVE covers it.
> 
> The full write-up and a source-level reproduction are in the attached
> report, and the proof of concept is attached as ANT-2026-6KYXTNHY.zip
> and also mirrored at
> https://drive.google.com/file/d/12trI_zvHCLo_XvUTlD4LcAx27XBBwyRq/view.
> 
> This issue was found by Claude and verified by Calif.io engineers. Our
> reference: ANT-2026-6KYXTNHY.
> 
> Thanks,
> Calif.io

