Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E2173BCD17
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Oct 2026 08:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792137913; cv=none; b=Bhz6h3p6xe6ZEkGVU4OVmk2SxU3Xa4VhLjd5TTEAkafQiN1PyHVKbjySQCo3rRLE/jUm3LQEMeuEQPIHxNij5NJQdLVYBIIvz28bAU1rYGRUL8iwVY9AIIYEqz/4VkglZEBchitj/8vHX4FyV3Ohu90gjPE4gLPCL3MuHdX/JWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792137913; c=relaxed/simple;
	bh=vRiz15QiiNc+Hfhn5nt1qqTJLSlpzxCOAUxNEdHoilU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UZvKQMnJKq+ydUzwRYaxTyhavKubnPn5BGJ6dhteowmN8PTjnfO51+l4PqRqMMbVcq0njEa9fWdpPFi0b5zCiX/QDYBxmwhEDAfNDyEOHiL575x6X+VEnvq514mRMdScVHN+feptL7l/vBs7hu7XdONsCHmSrly9n04LxwWKoYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Uh/KlZ2z; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Uh/KlZ2z"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c40e30c26a4so32660466b.0
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Oct 2026 01:05:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1792137910; x=1792742710; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NyxGCncphbxJc1IVeh8/OmShyubRf9dZP7qVl96w1Xc=;
        b=Uh/KlZ2z7LABvlozo+E7mP1aZM2ob0pfYyvQxIQRegw2KGaT5jZqCd2S9+0EOVXOW8
         dzOcp1ckaCWPbuTt/ryQAT9dwFTv8Ay/nZBNfwCRgHQ27YNjVTwn/Y14C7tKoyvi+5gK
         rCaAN6ccOowkN8DZ0NrMRuB+HimFe1W1cIN46trYv6U389Ms/M0OHpGCw8vqt9TMNlcf
         3/1EBV2Qb+1G57bIwleQAoTJGKszDPbbYo4yzIFLTzQcVroJLnp0fIZgrQLxl+yChrRo
         YSZRo8yzGICJSPIQc0/bj6my2tlmwbdMEqVbwD3emdoOiuHp0jcqIlXsdOzL9JoJeYcX
         jxaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792137910; x=1792742710;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NyxGCncphbxJc1IVeh8/OmShyubRf9dZP7qVl96w1Xc=;
        b=RUYCfYsH+4hUYzM/WNwjP5BMLPSqRdf8LdQRNOVS8SJzMqkBNL6sQB053vZJ1IQvzV
         dFAns2Jj6SKpoNsuFhGoz37yStTN2OIok6C9ORDkxIb1sGR6VcW7RlTEX9TQSbPU9Jai
         6qKKbRr+o0KsHZcld6GDLWeOVt6KVOAQ8lamlRZgrYiZJBU81Bb6SaP6o2vejfWUMd/1
         5imStmeaaEsw3Nzw8yOJPZp2OHrVCDMuaRtr1Pq00m8wLCQtA+tZNlrvSUqHbnkhlS9/
         ZGKaW+zxSP+jXqSKqiNLvaVsSzaJMv6foZ/eDpwC+lCm7TBaW4IfL3d9rgjxU7nAF1j9
         fy5Q==
X-Gm-Message-State: AFq9FYKqIzgeKLujGFyD3Izsojx7Ch/vvaMefX72AGwQoPgH8uSRsg2S
	tKuhY4c2BXP1EyfgrywI6e59fNrjGXrrNQsKumgoIvJHMp+uAhr+fOzGIztShxFoF10xW8w0jdo
	ZO0WviU8+YA==
X-Gm-Gg: AYBFou0K7xtI5jqUrkevEtRLjkTa4ZDgZjrbGxIk7BnxLMA/ZTB9655H4pU2YQoD9QK
	nuQYJWg8gfxPPDQ1XFZxEX2HRmkU0GjiV9TrADAHA6sCUVUzE1PsMZgShgLfe7nUN/IckNL6nW9
	aa3UqjQbIGSTlaDTDs7Yfy1zbco3od0UKyP5YUsPsteTHpLOTIz7spBx8vgW/nxYXmdSk9JRhHn
	6vfIW1nSgtpGsHz+/JPBuiv2qipJbdm/YBEAjDcfGIaZmz4o8/l88p437W1tqCZ56uOG57R7ZWx
	mERBuImcg/cQZtSUgDQeZkbYS/qjt9SKBA24IdewYeqVzAO49eKn6ThdlZ+TF6GgYbBHuZJKLau
	ll9m/JrAUcot7Os2wm6fAag1wLgsYCpuvojQ/B0doe2mwma3CBOLa/NgznvCYzr422u+kRYQnEy
	7LL1WBc6O1LLNmz60k8tgrq5sZ6uHI7jL5uZIP6/dcOS2vvVlIE2/ZULCiNN8s8W0=
X-Received: by 2002:a17:907:1c92:b0:c33:ee11:472e with SMTP id a640c23a62f3a-c4021dc2e62mr229814966b.20.1792137910255;
        Fri, 16 Oct 2026 01:05:10 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd654eaf4e3sm667157a12.26.2026.10.16.01.05.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Oct 2026 01:05:09 -0700 (PDT)
Message-ID: <eac493e2-8bd6-4584-bd90-7601a210f802@suse.com>
Date: Fri, 16 Oct 2026 18:35:05 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] fstests: generic: add a test case to check fsverity
 reads
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
References: <20261011222613.10793-1-wqu@suse.com> <20261016074756.GD3049@sol>
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
In-Reply-To: <20261016074756.GD3049@sol>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/10/16 18:17, Eric Biggers 写道:
> On Mon, Oct 12, 2026 at 08:56:13AM +1030, Qu Wenruo wrote:
>> +_fixed_by_fs_commit btrfs xxxxxxxxxxxx \
>> +	"btrfs: fix the fsverity callback where unexpected range is verified"
> 
> Even without that commit, 'kvm-xfstests -c btrfs generic/807' still
> passes.  Under what circumstances will this test fail?

It need as least 7.2 upstream, which enables large data folios for btrfs 
by default.

And I can always reproduce it here, mind to provide more info about the 
passed run?

> 
>> +# Read the file, unpatched btrfs will verify blocks outside the read range and
>> +# trigger fs-verity warnings.
>> +# But the read itself should still be fine, as the failed part will be retried.
>> +cat "$SCRATCH_MNT/foobar" > /dev/null
> 
> How about using md5sum and putting the expected value in the .out file,
> so the contents are validated too?

That won't catch the problem.

The root problem is that, for a large folio, a read bio can only cover 
part of the folio.
And at end io time, unpatched btrfs call fsverity_verify_folio() which 
can have data that is still under read, thus fsverity will report errors.
However after each read, the correct data are already copied into the 
page cache.

So after a fsverity verification failure, MM/VFS will retry the read, 
and since other parts may have already copied the correct data into page 
cache, eventually the incorrect fsverity_verify_folio() will succeed, 
thus no read error is returned to the user space.

So md5sum will always be correct.

> 
>> +# Check for any kernel warnings from fs-verity on file corruption.
>> +if _check_dmesg_for "FILE CORRUPTED!"; then
>> +	echo "fs-verity detected corruption"
>> +fi
> 
> Is there a way to use the fserror support being added by
> https://lore.kernel.org/fsverity/20261002223705.2175542-2-aalbersh@kernel.org/
> instead of relying on the unstable text printed to the kernel log?  If
> the string is changed at all, this test will become ineffective.

That's a better idea, I'll need to check if it's possible grab fserror 
info from btrfs.

Thanks,
Qu

> 
> - Eric

