Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16E0C34D4CE
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Apr 2026 06:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777358472; cv=none; b=QfvOw6yQitgDgXzkZNPq68o6R00Zt565IDT8rVO1kpPti/vn3weNFVN5JB7aw9gFJk5V6pcDhWKT64bsQcAe7UeFYTQh+1GxZE5y0OGtCBnUpi+VKNdzOBZzxA//m4PsGWsLTQ7QxR7v358DZikEuJcJ8KZCak+A4revzzv/3rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777358472; c=relaxed/simple;
	bh=PvhYliFeLoJoidxS35b26DH99837MLoXs/YvZ4vDOsg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=jFtJE8OSI2t7knUza7ALgCQJ2kPuJ6pzfyKUHsV8L0hEVioZiRNrMmL+I562Xq2ENp0vp409ewTwRZOoEJZWblK5BUuUsrBRdyxXfRk2r1Z7rKMwSw4/JbAPa/zlOHTqEkF5XxK6IQuMwqbj5gblffwDwBRXFjmeEPu9R4EkFRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ZPjIxtgC; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ZPjIxtgC"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-488ad135063so99905925e9.0
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2026 23:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777358469; x=1777963269; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=rfxbGYoa/IsgQahgTFmoALFxIJMcuiKWvnwY/fNUbuA=;
        b=ZPjIxtgCR2P/oxPveI5yEcMip6fuYYKho4b4UHXFzwOGGz1ECGUeWI48LJzZeFKK35
         IMkgFlXrGnIuDm2YzdSsstMfV5xgjgWfKHbn8S608w9KLeEmLGR1wF7m21txHtMkDF5c
         Bt8XWk2t4in8yd5+OyCc22Xe0WzBy06fD1zPgODhzlPPoJdl9TNnbgDPsJgcEa/MGAP+
         4pUWj+ulwvZ3lF6ndv4SKpKf/fExc17bqhXCsnXCCiGXGf7768cFL6wQUiiJPHjr2Xfz
         dpeuEomeucSIXqnc+y3DJtNlbrTE79KS6yN+dSugbhji7JlDDdFH7ibXh/VM4CChQ8q6
         Sf2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777358469; x=1777963269;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rfxbGYoa/IsgQahgTFmoALFxIJMcuiKWvnwY/fNUbuA=;
        b=leD7Z43+p6neHjrk9yxZaJ4x+4znx0U28XPX3yzcZaV69nvi+vcWNgVg2vgl0baP+m
         /GFa0kPzIEKmT0nSVmirFd2qQY6O1QilTvEeFgGSTNTHs/49vYs6pg3n94sSN+Tve2DC
         acAZf4BF9VmqwoYs+CGC/bxlK3LlQ23IE0EMqr7NuXR+hhqibto4mAJ9GW6tGAHJq7eW
         dOngM9KcMPOjFJGYE+HomBXEIaWN32rKLZPSDZRXJ3iOZMJDlsihe258+KUpcPTAiOTr
         jKf2Z4HF5AerijYrTukI7t11+UuHTERbm7s5DjeqBhCFLnK9tmlW5CmTwcRYh8/+K9UE
         LU0Q==
X-Forwarded-Encrypted: i=1; AFNElJ8aqbOAhiAFw9sPtqDoyR6TFfoVV2ZATajmRjsZ3nYKr9G1G+0gShEkOuwYSo3JZctNIPCFotiJ0zj8Mw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxKf0AGgxw0n3ZJSxbdKJ/99+pQNiZj8oyQBb0YDciqflzwN5GT
	DvP7Ie8nfe28oWmULFIUnHR4A90ksqEgz3IxPtdNz6dqP4BOQlDCEH/uss6ip4mnaVM=
X-Gm-Gg: AeBDieuzHdrW+RpuQRWLNCV5p81hxSdgeIH0lqXXK39gG7G5HyesnKY/16CG7k2zj9u
	AZxFY6fTx3BTqFE3FZN4MYJX7YuopSI8Pzxpdb8S7iLSaujikQaYfvUN80NIpKBzJSIU6Eyypkg
	KzMbOyWcdDBgDwB+0vqFDjUvqj0oDDpEmkPSrUWvcvrFG0EF70OCnzZaFC38S8hxFpAS/7yYOFU
	Ln2zFLdzXNg6hNKeoNV08AbgE8PiOj55s8F5xWVVnuem9+JxsqSi0XTZK6EQcOKg60dj34yGNKo
	gOU2kFZ+79RBSLYg3LpHMYjDkGAC6B6q7cQThbInzCX/ao65B6IU5KrKfz+lpIVyQ8lh7XifDZ/
	OB1SADdCjg/J3ZY3nl0B2SIVYz7R8ZHoOXjdxv4dYIq9QwLyPMv/+flP0xf6XqWPGV80dswB9Fp
	geQL015cYYQDmhm9lzHdR3b4Vua3oFUBe/na0A+ECwBWnJpiT+zLYC+tp7sGRuWQ==
X-Received: by 2002:a05:600c:8b4c:b0:48a:65ad:1881 with SMTP id 5b1f17b1804b1-48a77af28f1mr27413935e9.13.1777358469428;
        Mon, 27 Apr 2026 23:41:09 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b97ac78242sm15237615ad.47.2026.04.27.23.41.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2026 23:41:08 -0700 (PDT)
Message-ID: <19c6157d-235e-4174-8865-3d029f9a2de7@suse.com>
Date: Tue, 28 Apr 2026 16:11:05 +0930
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
In-Reply-To: <d580bc81-71be-4153-8d4e-58c4f6261085@mailbox.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/4/28 14:59, brainchild@mailbox.org 写道:
> The volume seems to suffer still from at least two problems:
> 
> - If scrub actually completes under any circumstances, it is required that the swap file is unused. Disabling swap is not always feasible during normal operation of the system.

By design it's not easy to support swap file on a COW filesystem, that's 
why btrfs has so many limits when using swap files.

I strongly don't recommend to use swap files on btrfs, as you have 
already experienced the limit on scrub, and I believe a lot of end users 
are not aware of all the limits when using swap file on btrfs, please 
check the long long list of limitations in "SWAPFILE SUPPORT" of btrfs(5).

> 
> - Periodically, the filesystem reverts to a state in which creation of new files is prevented. Naturally, it is impossible to use a system normally if the root filesystem is effectively read only.

Any dmesg of that RO flips? That indicates the fs flipped read-only, 
which is a huge problem by itself.

Especially with your initial info, there should be enough data space, 
metadata space is less ideal but should be enough.

$ sudo btrfs filesystem df /
Data, single: total=813.13GiB, used=662.49GiB
System, DUP: total=32.00MiB, used=144.00KiB
Metadata, DUP: total=9.03GiB, used=6.26GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

Considering how many snapshots you have (triggering qgroup lag), I 
strongly recommended to remove unused snapshots to free up space.

After freeing up enough space, then try to balance data block groups to 
make space for future metadata usages.
