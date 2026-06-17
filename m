Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB61D39A7F2
	for <linux-btrfs@vger.kernel.org>; Wed, 17 Jun 2026 22:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781734304; cv=none; b=LpBrFANLpJRnkHSqWWuowyLgH5qvaPiisFnKHsF8vcFL7IekzccOlnVh6dyZdPsXthRYyCOPVpJHWFQmpgbkXiFNsARWC29qJ0AouacxrPaqE30dXF86ipsdGOeYjouykOfU62MaL0MHw1GQuQCujNmbG0PmKtt/WeeQv3ozYec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781734304; c=relaxed/simple;
	bh=9MZKgDLg3M2sGyzB+Xfnggvc6jL1XyLyYimd9bw0LRw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uRupmnOo2lJPGdUmF7kSu9iSG6SAGRU/l/DqjhQtyNzHFSwNOFaIC2SafCMmP5c+LI2BMmXoLzCTz8UrEHNSgwpNkbf5IMxyXTS0wQYYS1qoCDH5OY8aIT1BlwCAqqtdTDY7HNg2GESoO6UwQ6B94rKKM3UICF/cimdPfdI5XYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Oxtjlf8q; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Oxtjlf8q"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-bec405a6ea5so29840566b.0
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Jun 2026 15:11:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781734301; x=1782339101; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=tQRbWFUcRlsgEtBmhHh+tBDT8RBj0Nwoa8GWZVmcAtE=;
        b=Oxtjlf8qBGWWmInFWG0ERkIUA7p9Dlm+rckzbA95XjZH2pJa4WAlHeVlGsf7Jmx9W+
         OkF033UIOMlaZLgbl7Q+ROhDXRhIA3CPVmRYpU9VL9KkgMDOTvAunBSdHMMUBqUkN2EA
         9oWDS/aCSpaIK/Xy1ZG8gEUClcqKgiDDY5cA95xD0Hm4jM5Eju7ALswO+EIzL6PsHPsa
         JFGkxIN35vhIPWqukOUZgTeCeF7mx0nP9QwvuOjrSRGYGm1SlCqLt9Xoasx0t6y/6FBv
         1FH+F5k0dBXUBv5/dj8HtvEsVBZMGdUb3664tHDsR9xmmDgLY+ZvsypcNUaL84PvXOb5
         LBOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781734301; x=1782339101;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tQRbWFUcRlsgEtBmhHh+tBDT8RBj0Nwoa8GWZVmcAtE=;
        b=Vf3qHKD+i90PLsMmeRHbhoaYMG9j+Sngd/PSuGws0r3ml5Bg75Y+NXV9d3um4lBLAn
         /ZkQlfcBsHcQ+Hfg49aG1o1JEYFhwnI0sgYPimuRuTZJ5CnWSG+WdUCtS8jeDHYPN8cd
         IwwJ2OL7I9BTyNTVaaG7Ji6f2c2rgM/bWzUUUlhjjB89xr0l+/8PuZc2ZPBRSAB+yzKq
         Vc+Guq6jdQQZo4TQuslWSZ7FpZJnS4m+8Jf8uw9SuU60CgRikoufnbhk6rQPKBBLLYpv
         YgBhc8o7Ekj0AQFpnGkMofYFRSUKI3LwBf7LL+YL1k7fNP2Vh8TVuXL7Rvz8A6tty67p
         +TOw==
X-Gm-Message-State: AOJu0YwFbFRE0wMPmyen7itXbXHPsIlY7+8wICRpB2EZKo8oNE78HuSz
	hPzr2v01dG2WvLdgSofIJ8X9taQLXL6oR+yQVpfY9JRuSXfIHWSmhZmGn99d5Ka+N9c=
X-Gm-Gg: Acq92OHvtlf6/P06DrM/DnxTGet+Dj2P2hZA6NF5iVX4yZNCYe3qeaeVMoqlcmmb3GQ
	rgdd9wxngyvb5pCbWGL9T/n3+y9kf/8TGniw8GQBS8X9yE+3m1gUkrsfNYnc6di1VzIVZE7uggw
	90JZlvurVXLLc6mOVzNUtT3pAvBPoEcCmpx7PjhLx8bJB2xDg3mB9wbKnzA98IkqBU2dkNN5tnk
	T83uBuDBayshwJhKBuB7lHxeFjqZzY7dxAX7SfBPZ2afLN1xMhTAENfWWxNFtN6gY8+rkXGjwKT
	9NuefLpWiTfqEsR5mdTpto40UaCH9tVcgam1j/70niNScxK51ZvjiUGCzwef5qZ5qhr3Wi/agEL
	JMIvUtBKwCHntNPsyDnGhlT6JclMsa0KAvfvtDKS5aFd6cyuJUvCtqSQ5E9iwbF/VEbOQ5jgkOU
	3BAtxo6peaoRIEhuv8R1oW6OpMrn0FoffR2RNTj4FygZhBmPCLQ//AJkvnnVcojXz4bTRzxZdbx
	pn80zws1sUwpjRMjRlCMW/CTa9dhubXK/0=
X-Received: by 2002:a17:907:983:b0:bec:da1c:c4be with SMTP id a640c23a62f3a-c05d2a8007emr333625566b.34.1781734301065;
        Wed, 17 Jun 2026 15:11:41 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8434ac9df57sm17620804b3a.7.2026.06.17.15.11.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jun 2026 15:11:39 -0700 (PDT)
Message-ID: <bdc49ac1-b979-4dd4-afbf-dfccdc85b2e9@suse.com>
Date: Thu, 18 Jun 2026 07:41:35 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Btrfs mount failure; log tree replay error and transid verify
 failed
To: Amber <edoardomonterosso2010@gmail.com>
Cc: linux-btrfs@vger.kernel.org
References: <CALuM0_aMUsWM0xGOrda7-jizQmmzJ6+cU63FVm-epMwEeifiWA@mail.gmail.com>
 <310be885-8ec9-435b-9a67-26fa14aab611@suse.com>
 <CALuM0_aSy5KW569Zdu9sOtVejc92HvNDXG8f4_2f7y0Uf-TNQA@mail.gmail.com>
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
In-Reply-To: <CALuM0_aSy5KW569Zdu9sOtVejc92HvNDXG8f4_2f7y0Uf-TNQA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/6/17 21:06, Amber 写道:
> I managed to copy the files i care about into an external drive, thanks a lot.
> What do i do now? Is there any way to fix my system or do you advise a
> clean install at this point?

I would recommend to try a different NVME drive and do a clean install.

Thanks,
Qu

> 
> 
> On Tue, Jun 16, 2026 at 11:11 PM Qu Wenruo <wqu@suse.com> wrote:
>>
>>
>>
>> 在 2026/6/17 07:53, Amber 写道:
>>> Hi all,
>>>
>>> I am experiencing a severe Btrfs filesystem failure on an NVMe
>>> partition (/dev/nvme0n1p3) that stops my system from booting. I am
>>> running from a Fedora 40 Live USB to try and find a way to rescue my
>>> data.
>>>
>>> I don't know much about filesystem internals, so I am attaching the
>>> exact outputs of the commands I was told to run below.
>>>
>>> Output of 'uname -r':
>>> 6.8.7-300.fc40.x86_64
>>>
>>> Output of 'btrfs --version':
>>> btrfs-progs v6.8
>>>
>>> Output of 'sudo fdisk -l /dev/nvme0n1':
>>> Disk /dev/nvme0n1: 953.87 GiB, 1024209543168 bytes, 2000409264 sectors
>>> Disk model: TEAM TM8FP7001T
>>> Units: sectors of 1 * 512 = 512 bytes
>>> Sector size (logical/physical): 512 bytes / 512 bytes
>>> I/O size (minimum/optimal): 512 bytes / 512 bytes
>>> Disklabel type: gpt
>>> Disk identifier: D2CC4AA6-D32A-4B69-A117-FA5431D953E2
>>>
>>> Device Start End Sectors Size Type
>>> /dev/nvme0n1p1 2048 1230847 1228800 600M EFI System
>>> /dev/nvme0n1p2 1230848 3327997 2097152 1G Linux filesystem
>>> /dev/nvme0n1p3 3328000 2000408575 1997080576 952.3G Linux filesystem
>>>
>>> Important parts of 'smartctl -a /dev/nvme0n1':
>>> SMART overall-health self-assessment test result: PASSED
>>> Available Spare: 100%
>>> Percentage Used: 1%
>>> Unsafe Shutdowns: 80
>>> Media and Data Integrity Errors: 0
>>>
>>> Initial boot crash log:
>>> [ 4.027710] BTRFS critical (device nvme0n1p3 state EAO): log replay
>>> failed in replay_one_extent:880 for root 256, stage 3, with error -5:
>>> failed to lookup data extent for bytenr 13497643008 disk_num_bytes
>>> 32768 inode 993755 root 256
>>> [ 4.027727] BTRFS: error (device nvme0n1p3 state EAO) in
>>> btrfs_recover_log_trees:7789: errno=-5 IO failure
>>
>> You definitely missed part of the dmesg, thus that's why we always ask
>> for full dmesg.
>>
>> There must be some transid mismatch error message before that.
>>
>>>
>>>
>>> Errors from 'btrfs check':
>>> Important parts of the initial check output:
>>> [2/8] checking root items
>>> parent transid verify failed on 323993370624 wanted 15274 found 14939
>>
>> Again, root tree corruption that caused the log replay bug.
>>
>> And it looks like some bad FUA/FLUSH behavior, some writes are lost thus
>> you got older tree blocks.
>>
>>> [3/8] checking extents
>>> owner ref check failed [323993370624 16384]
>>> ERROR: errors found in extent allocation tree or chunk allocation
>>> [4/8] checking free space tree
>>> there is no free space entry for 13497565184-13500841984
>>> [6/8] checking only csums items (without verifying data)
>>> ERROR: errors found in csum tree
>>>
>>> Final totals from the check:
>>> ERROR: transid errors in file system
>>> found 69424640000 bytes used, error(s) found
>>> total csum bytes: 66219348
>>> total tree bytes: 935608320
>>> total fs tree bytes: 782991360
>>> total extent tree bytes: 71860224
>>>
>>>
>>> I ran 'sudo btrfs check --repair /dev/nvme0n1p3' and hit 'y' when it
>>> asked to clear the log tree.
>>>
>>> It said:
>>> "Clear log tree successfully."
>>>
>>> But right after that, it hit the same error again:
>>> [2/8] checking root items
>>> parent transid verify failed on 323993370624 wanted 15274 found 14939
>>>
>>> Normal mounting still completely fails. Can anyone guide me on how to
>>> save my system?
>>
>> Try "-o rescue=all,ro" mount option, if it works, salvage your data.
>>
>>> Please CC me on replies, as I am not subscribed to the list.
>>>
>>> Thank you,
>>> Amber
>>>
>>

