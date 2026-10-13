Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D41623B83F9
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2026 23:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791935504; cv=none; b=aOfisFNb6fe/XlzXI2tZCGHTPWD/aEg/KEIzK+IxotH3iFcBwh/TOHSc9R1ALnYCjF4EDAoKnsJlsCnDPpEoBuWofuLTLZ2NVnC09yN2xdyU2DrFgPpeSzx5uh9HZcJSTO1bXF6s+sy8qQJ214u+jRaI1+cdmAph8rQ3SoZyv0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791935504; c=relaxed/simple;
	bh=1jqUTw0Jl4tuBcQN2klNOlBFxa/cqG9fsKxsilRnrBM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uUIQypaZtYctRpQvAo8/2rMSHC3zZPI87tnuXrNnb/Kkp9RLGq7/0pgsQrjeSm+VcjGgpEMhZjt1tRlpqe7rgA54gPtwDROFwDlOZAj3roIAQCU7SgJODN2ryGSMp6YkAf6/3x6DfcVEhiRcNTjjKV8d/Y0PP2PuAPPEJ0Am1KQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=V+kbAwle; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="V+kbAwle"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a16aaf2067so4912795e9.0
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2026 16:51:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1791935501; x=1792540301; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8q/Zi8kc9nX8PuumrK7+v3/oz2ScpC7beUe3gMn7HfA=;
        b=V+kbAwleBOk9+gLSPokbuw3PZD+csKpm87Y7QxajhjNrwvI/AqvmdCah2rizN/On6s
         iWp11TzhSUbW6Kp/CNmTrltxjLxX6bfcE1lDpdg6WzLpgw/2ILYYeYwdyxfSqM41qpyO
         dJ/OBe8S6UMqSnbWO23ajAYQN099+ckDn5EH5qjEwmXE13S801/ZZJE44EG8zD5SnNpz
         0x2QLIoYiSvxzJr7F1YvoJdhs8CSTZh/VUPNZmZx1l3mkdmIqGl43fIl9XQCk9fYtyAT
         Xxr/wcEdYJMR6DsQc0vSuHPG4a/1k7Q8wWZZAYXR3BdpNt/XAbGEdr3nk881m7L68ICp
         K2Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791935501; x=1792540301;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8q/Zi8kc9nX8PuumrK7+v3/oz2ScpC7beUe3gMn7HfA=;
        b=pcj6KsqQNY7QRMGoQEduqp4Ft5CM3TnPgp7JADlOPtLhL99nzykxzLcSaOPaN9E7cf
         WX8gEIRXw5tQtqua0Ycuvn/JR96/xUYzbR2RLJSzxTsUyI4TcrA/Z6smFc5ocaCNYN2A
         CCa0YlevlL6/i/oR8YoxaSAjGFQg2x/VTzEUFnvuh9mKNpN61rzZkjdnLabrhUfNCRgi
         6nayWxvQ16KUQRm6uTt7QaonrRazRp/h+YnJb7xcyMXjCJHnN9In1A3QONIsHQrn9FOD
         7B5BhtqZG/eXwsrfyR/+1lzS/l0YCfoDXU29D4ywaJHrcoiX8Ef83waf8eSQGhi/NZ9C
         4ePw==
X-Gm-Message-State: AFq9FYI/VO8LRxGvaL3n1UqpBq1ncaqfx/8wLESiKITZY3DRP15eWyQg
	tl/bF9/i0E+kA8tQ2OQV1CmwKiUHcQwRjBWKcMxJ7Zxn/BN4NyDmWU2PC1erUu8UVzjH8bPe/e2
	3T40cxAI=
X-Gm-Gg: AYBFou35fabQFGQxfpgJrQCUFY5sXtCTJnxog4XrL0gU8KuHXLhMFDyDKdGUdRlj/OY
	FkJzbuRfIYq5cAN5eslgXtR9BHcWX1PvKfASfiSwF56jz3R3I3tW92LKQ+KCUhliH7EwgG/z7h5
	dt8Zc8aspB96CtamuI6pYQhcV6LxFI4KY1LucHETXpDIZ4WiZZCG3SHk8Uu9addpDjI5ipjx4b0
	4uDRbE0wZPmc3PF4U2Lk3ufSdvPhJhlrTOpaKHENPe2zdizILO1Lba1g5vuIjQ+g1Wh3AeIgmfF
	grUuMkzcnBfts2n1gqfVyQiGWYwqQXxm2/cvtai3pWedhl/mxm78XIRQyt3NHnDUnyH2wifOFeW
	iKWXOi4HvX+yxdC6cWezu17A7ZWhNmV2WhAAKyDwO4q9sfMZpB2xdlMDHJZiJT0nbBUmup0lrYT
	/XP7J71LTxcua3P2Fchx1mrgn1xUm0a4CNaI+CHawbZj832i1ubjgWfNnk/U0qizw=
X-Received: by 2002:a05:600c:3e08:b0:4a0:1cfd:314 with SMTP id 5b1f17b1804b1-4a18e4d8087mr271425925e9.26.1791935501033;
        Tue, 13 Oct 2026 16:51:41 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac6006280dsm1648567a91.6.2026.10.13.16.51.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Oct 2026 16:51:39 -0700 (PDT)
Message-ID: <bde7518f-53ac-444c-8b0b-c434d08aef8a@suse.com>
Date: Wed, 14 Oct 2026 10:21:34 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] Stacked fs keyed by lower i_ino: detecting a nested
 subvolume root
To: =?UTF-8?Q?Cl=C3=A1udio_Fernando_Pinto?= <claudio@studiomoob.com>
Cc: linux-btrfs@vger.kernel.org
References: <CACU5Mh9KdABHuGXFTY3=s1DiPSPUSLabhWZnQRrYjnjK5PGPSg@mail.gmail.com>
 <a29f5513-1483-4064-bd8a-aa2399076bb7@suse.com>
 <CACU5Mh85r_7x48Rh4b6kC6_-tm0LJz=PZiJ6NBfOvcWxve0iBA@mail.gmail.com>
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
In-Reply-To: <CACU5Mh85r_7x48Rh4b6kC6_-tm0LJz=PZiJ6NBfOvcWxve0iBA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/10/14 09:56, Cláudio Fernando Pinto 写道:
> On Tue, 13 Oct 2026, Qu Wenruo <wqu@suse.com> wrote:
>> I'd say that's btrfs specific, and should not be considered as a generic
>> solution using that 256 magic number.
> [...]
>> In fact st_dev is the common practice. As that's exactly the way to
>> distinguish different volume/filesystems.
> 
> Thank you, that settles both questions.
> 
> I will drop the inode-256 test and compare the device that getattr
> reports instead: on a directory lookup, vfs_getattr() on the lower
> child and on its lower parent, and EXDEV when stat.dev differs. That
> treats a subvolume as the separate filesystem it is, costs a getattr
> only on directory lookups, and is not btrfs-specific.
> 
> One thing I would like to confirm rather than assume: every inode
> inside one subvolume reports the same st_dev, so checking directories
> alone is enough to know which subvolume a file belongs to. Is that
> right?

Yes.

And in fact the uniqueness of each subvolume's st_dev is already causing 
problem if there are too many subvolumes.

The st_dev of a subvolume is from a limited anonymous device pool, and 
when there is no more available slot, new subvolume can not be read.

But it should be pretty rare for normal usages.

Thanks,
Qu

> 
> Thanks again,
> Claudio

