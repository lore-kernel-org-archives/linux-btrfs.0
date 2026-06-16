Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3273C98BF
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Jun 2026 23:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781651480; cv=none; b=YvvnFo6SKxf0zpjxFTCNmTW82C2Aw3zTKpxWiet3bbcwBjZP2//QYrbb9vAte6hLhDLrDTFik3+qE+uQ6gM3Bbz4AeJtXNsXcL/6ZOktwI0702mpZaCONuy7KdnWkLgWyYg+/HtObomklXKXzYJq8gdTAtk9Hd5xhiMoFJNxnfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781651480; c=relaxed/simple;
	bh=dMWhtlyl/soho4k568F+vOIAZcZ0iSaPysnC+B2Rdk4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Z6DREtMMZ+WP0/C/74RYMFCftw7tB+su3LXardE1QEseZJwPG5OCtkuQj23bGdp/zHV7el9vboVhoi8qjbcneMFJYJ0HrrCDpe305Tp3yqUsMQvjWMxXDUerkPbHC6GQfWHe3Bye9d+dAqJyHaBsV9J1vaLO1VJ6/JAysB6ISrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=EgaNaS9/; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="EgaNaS9/"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-bebde89cfd3so653443666b.2
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Jun 2026 16:11:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781651477; x=1782256277; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=p+vUVBQhKZ9DHNA4Br3zglOW7D7k6PnCIEdlpd7Z4LA=;
        b=EgaNaS9/Ufan1NM1tt0nxT5hxhhODgjJ2gGe35Xd+l/wsEYPDu97Y6y2XnIGwyKkBl
         ZEUWEJ4ODu8w3FODWuE2LHncWM/gz8/dCg+3YGAlqP6yRy0d+GgPuUQz6UiiSJlIQqqL
         AmqYm6axdw7u+t5qXymo4dmEDM9nK4IwAWJLXmYF47e8K8g+arIb6Wkc9wSA7bENW3/P
         xnG/1UvsMaGPYAytwRXPq2gI7k8R0DpS0F9vnZF8O9r0D/rq22Oog8occ28FTujd+tK5
         6keCYuGRWgVprkS+vpmlG24YiDjpGc1GKPJTAR+xtBGgDoaERQDZdm/bX1NFlNwrQcfS
         IHgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781651477; x=1782256277;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p+vUVBQhKZ9DHNA4Br3zglOW7D7k6PnCIEdlpd7Z4LA=;
        b=Ka1XWbqslBAxwZiR2/Awk2fDTiQ1QLKTRYkFZw/9o9XT2XPV21ztuJNzoxn/XTVEg7
         K6eDiWpTXguZ3RVwwIQv/61sl3qP6K8Y+Fd6aivtSjMWy/IYWc1xA3LhP9NW26xxWJIz
         LFqzADLW4lmhNQcINfCni3wLNma6zUUFc3oZaHYB6aAtR9fOvSIS428JCPx8TptooWdq
         UfJ+Gz+HfwNkgLAlF2Bb7Fm4VN43DzfnFu50A0EyAtBGxKjrNKvaiviKOzHKsuAbYNR/
         ikqA3uqsXSnKv5lR9hT142j8HdFCzyiRPJPJ3K5DzSXZ6tpRpVMgggS3loAuDMuF1JMP
         RLzw==
X-Forwarded-Encrypted: i=1; AFNElJ8BQUHgUZ+u2D6pVCv9FVaqoURuN5K5rdOGYBi6VANtC4RPHPk0rC6a8thxEUoCoFiPjIOcH0vIJRb+OA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwvoK9XDSz95YwtERiT2YSgscJQSJsgyGJLajmbmF47f8EO0qA9
	NNbVGHxtZtRhnexjtqhm0lc36ZPUlqWy2ogCYoT8DvE6a3wFDZ06HaE3SqZ/mufyJpeQdXo5FMf
	AUrkH
X-Gm-Gg: Acq92OGy8FaJarlbI+y2MmJz+RxoPsXKrf/eJQErnLwywGPzxnyUqrVVdjn2joHEDQC
	et2rDu/NtSlzRb9B4Wyi0zkvG3FX1PZzBRjn2qLzeb0z/dL6/r+PHghKzHwHXODAl/m7FvhA8PC
	gtS7rkHvz7OUabMn1vOrjByjHgxXN26dBX0XCeHEwxVMSW/cFatRPFO5KhTjWgHPPMXKa3/dWd0
	9PaS2hnN2cGAzjP7ERvf1fzOEGTxMI8ykpzig+x6Bup6t91jWvr4U04aePQ5B89qstm5FRrL2Rs
	9C1mm7W6hFAhvv8NSSfmWTkohIU07DdGfjoOKS5hBX5+KMe9j8wvMHyx1CP/PPWvqB1JJv1RVuh
	esxxsjsQPxBNwluehUd7xZaD0zHsP0pWEwOR6t8Khy6Gj9j7DCC7Kw2MEixKQcv6/MjRRo+wEH0
	+s8/Fnu265bprRWGWQ3C61biR/yMejMqZViQEIb0q/4v9hlk/9lZMlnIiLYLkqBXtGK55gSF1O7
	Oq/4sqWVWPOlMfsOxG/UBaRrtppxvfjo/aXoq+nr9KWDA==
X-Received: by 2002:a17:907:c11:b0:bd5:7c2:7622 with SMTP id a640c23a62f3a-c05a541a7e2mr105201166b.49.1781651477560;
        Tue, 16 Jun 2026 16:11:17 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8434acca7ecsm14447596b3a.13.2026.06.16.16.11.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jun 2026 16:11:16 -0700 (PDT)
Message-ID: <310be885-8ec9-435b-9a67-26fa14aab611@suse.com>
Date: Wed, 17 Jun 2026 08:41:11 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Btrfs mount failure; log tree replay error and transid verify
 failed
To: Amber <edoardomonterosso2010@gmail.com>, linux-btrfs@vger.kernel.org
References: <CALuM0_aMUsWM0xGOrda7-jizQmmzJ6+cU63FVm-epMwEeifiWA@mail.gmail.com>
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
In-Reply-To: <CALuM0_aMUsWM0xGOrda7-jizQmmzJ6+cU63FVm-epMwEeifiWA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/6/17 07:53, Amber 写道:
> Hi all,
> 
> I am experiencing a severe Btrfs filesystem failure on an NVMe
> partition (/dev/nvme0n1p3) that stops my system from booting. I am
> running from a Fedora 40 Live USB to try and find a way to rescue my
> data.
> 
> I don't know much about filesystem internals, so I am attaching the
> exact outputs of the commands I was told to run below.
> 
> Output of 'uname -r':
> 6.8.7-300.fc40.x86_64
> 
> Output of 'btrfs --version':
> btrfs-progs v6.8
> 
> Output of 'sudo fdisk -l /dev/nvme0n1':
> Disk /dev/nvme0n1: 953.87 GiB, 1024209543168 bytes, 2000409264 sectors
> Disk model: TEAM TM8FP7001T
> Units: sectors of 1 * 512 = 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disklabel type: gpt
> Disk identifier: D2CC4AA6-D32A-4B69-A117-FA5431D953E2
> 
> Device Start End Sectors Size Type
> /dev/nvme0n1p1 2048 1230847 1228800 600M EFI System
> /dev/nvme0n1p2 1230848 3327997 2097152 1G Linux filesystem
> /dev/nvme0n1p3 3328000 2000408575 1997080576 952.3G Linux filesystem
> 
> Important parts of 'smartctl -a /dev/nvme0n1':
> SMART overall-health self-assessment test result: PASSED
> Available Spare: 100%
> Percentage Used: 1%
> Unsafe Shutdowns: 80
> Media and Data Integrity Errors: 0
> 
> Initial boot crash log:
> [ 4.027710] BTRFS critical (device nvme0n1p3 state EAO): log replay
> failed in replay_one_extent:880 for root 256, stage 3, with error -5:
> failed to lookup data extent for bytenr 13497643008 disk_num_bytes
> 32768 inode 993755 root 256
> [ 4.027727] BTRFS: error (device nvme0n1p3 state EAO) in
> btrfs_recover_log_trees:7789: errno=-5 IO failure

You definitely missed part of the dmesg, thus that's why we always ask 
for full dmesg.

There must be some transid mismatch error message before that.

> 
> 
> Errors from 'btrfs check':
> Important parts of the initial check output:
> [2/8] checking root items
> parent transid verify failed on 323993370624 wanted 15274 found 14939

Again, root tree corruption that caused the log replay bug.

And it looks like some bad FUA/FLUSH behavior, some writes are lost thus 
you got older tree blocks.

> [3/8] checking extents
> owner ref check failed [323993370624 16384]
> ERROR: errors found in extent allocation tree or chunk allocation
> [4/8] checking free space tree
> there is no free space entry for 13497565184-13500841984
> [6/8] checking only csums items (without verifying data)
> ERROR: errors found in csum tree
> 
> Final totals from the check:
> ERROR: transid errors in file system
> found 69424640000 bytes used, error(s) found
> total csum bytes: 66219348
> total tree bytes: 935608320
> total fs tree bytes: 782991360
> total extent tree bytes: 71860224
> 
> 
> I ran 'sudo btrfs check --repair /dev/nvme0n1p3' and hit 'y' when it
> asked to clear the log tree.
> 
> It said:
> "Clear log tree successfully."
> 
> But right after that, it hit the same error again:
> [2/8] checking root items
> parent transid verify failed on 323993370624 wanted 15274 found 14939
> 
> Normal mounting still completely fails. Can anyone guide me on how to
> save my system?

Try "-o rescue=all,ro" mount option, if it works, salvage your data.

> Please CC me on replies, as I am not subscribed to the list.
> 
> Thank you,
> Amber
> 

