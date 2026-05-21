Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED16A95E
	for <linux-btrfs@vger.kernel.org>; Thu, 21 May 2026 07:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779348204; cv=none; b=reoyebOvk0iSLBl8HoAYxlY8wNdPSlNCC3eU8y+jXHFtoGlmxTRu3YdgRoL/HT0dOe8pt0rZv392Yal3Nqp4p+AJyGiU8AqGBnuvx+ozf1wybFTc2r1fYjhYLEdb/MBajigb6NueCyL6v2VBLxPkMU0Pc3HgPg0/IRuL6P5GfDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779348204; c=relaxed/simple;
	bh=t0bL//eR84uv8wkC/M2nMHGd+0BiKHu/W1wN3iFlgKk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=aa4VQe6Vj2DAREvxplzoW4284RZidKJvPiaU2tZEytzCSikszZHpmH9y3o9g1+HDB3kuG7lszyeT+6lec4njtf79NgdOdh1r5fKG3li5M1Ow5s6zD+sXNfYY8fbvWMGpU98yMCIUkO5pU2fo6mvd5VjFWb4z0EKZ1DDgO8ds9IA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=bJos5yUu; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="bJos5yUu"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-48a7fe4f40bso67837185e9.0
        for <linux-btrfs@vger.kernel.org>; Thu, 21 May 2026 00:23:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779348201; x=1779953001; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=jt7YuukN3MCZYkHKNAXhJFJiREXq9vqG14E6VSCNX6Y=;
        b=bJos5yUu9xQ0H9lS207gBhZn7z/2+UcnQRqJDLq2A9JdJlsQlIJv+kqutwukf5pD5n
         zCovm/03hhPHBkCKJwhAwylx0YgouLXyCJmw4vc2cIBvbdpHIpajY61oVtI/U9J4i7zS
         xBVbTrAIZepB01c3b7a8iri8wF9fuOeOpBaNmxMjsSBsnrPUhfaTOGbDkN7IUUsar44X
         Noj3hN08I82i/3AN7fZ3ZOXY3Crgz38nP2ym8tzvw0YzH5psnWVv8tdF4HzoYEjm2knG
         LgH4YoUAgkUOSc44kxJhxG5M9x8V0YiLNUemsR/0RLJ6RNG1QihBUp5KxRMMQ4a8p5ce
         eejg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779348201; x=1779953001;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jt7YuukN3MCZYkHKNAXhJFJiREXq9vqG14E6VSCNX6Y=;
        b=LX0QtaMn+koxyIA4nwC6wcNDHPxbnK+FJckIWLYPjSlvfie+I3bDxQoMUBhEbEW92Q
         e6+1VIKYoBStEYxhS6I6eQem/BpojBaDbTShy04X8rZWmErENBANJFcYBb2l2BZgBOT0
         ddMlFmPaD/pA+8SWRDSFHZnkZBxCx59Zf2J4+nmrHQ2hLD9/1ZtEaUCUMd/dTEpGaIHq
         cQ1esNbnHf6tNObnijF62G7w6GDmlv1pvpBHr8kC6dLOuP9mo1qKIfpmxyYfYvoe5WDC
         nbg9cSLOnk9v8DfVuVxAZoAE+sBYziRbE1zrl4qAPELJe9xxDJomux1MG8v0bUhpRWMz
         WwNQ==
X-Forwarded-Encrypted: i=1; AFNElJ/xYtGr9wTndUaZXPAE13ryjfOs2M79O5h36h6kjrdFZWDJDWpsIQh5Voup/57vh/cLV0TbF30vZ2J0DA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwAczEqJ0fNlSYJTySvlJwqa2qgk/07uu6Gopij8ltQzjrgtAbe
	25XIh2r7903zQzLeVSo9DqXFE8R+e9FVmDoVRgO3H/MFwnXEHGlX/3VEJlCllwPEkXk=
X-Gm-Gg: Acq92OETg+hEASbLa24bmSu6JCPsMOoJynKcUZrfCzGVPlBQm1dmcD7IVO8puYy4Y3L
	0smmAnKXbbaiEW9qKp0fw3LKHXZ0oml8B9tqBTlSAKoeo9er1JxGnLSiE0ZOYI08CdvvjwSCzoi
	+oX8pa1IbpUDuPLZGPJ5XelEINulRyf7/wu+08twCk2Jt1PsDwt+57uFSbvwqMGjBl/aiqaTkrP
	nrlLsG5MBTG0iKU18gJk4ka1lu+jn9xDrsBB1PEeML8UDgDAL03tSHx++HUpYKkN1Zv51aIiUIE
	awuMRyvZjWsgBvGUh2m43KpaBl82zLsYbWu46yXxARJuPf4iDna+5VBfbENfIEbt4AzYw4U/zrn
	3YGrNrMN9ESiJfu80djL/2fY+8AfQanTvMuLOHMPzztAN8Wy/re8s7Jb9/wwLUonWh5cqOlf5y7
	mRaUlZqdiJPm7BnrrYmT4Ud8uXEx6JVfmTFoBYFSGbnBTnEnRsfnSXVnEMBRUrZdaC8KYFS7ySo
	Y6NDzMSsyTOGhEXQ9+Q7RS4bzEnz8inQXJS/z1Gci4snHK2A15sK39B7A==
X-Received: by 2002:a05:600c:8508:b0:48f:d5b2:7c1a with SMTP id 5b1f17b1804b1-490360677c2mr22693115e9.13.1779348200809;
        Thu, 21 May 2026 00:23:20 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84154b1acf2sm394242b3a.22.2026.05.21.00.23.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 May 2026 00:23:19 -0700 (PDT)
Message-ID: <3a32a311-8299-4023-9dfb-40cb5d5cd739@suse.com>
Date: Thu, 21 May 2026 16:53:15 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Linux won't boot, drive is btrfs
To: Brad Brown <drundel@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAKWORBBVbZBKqxNsmMkWnx-MjLf2uCPFJCU2LJBUMsciu+XfPA@mail.gmail.com>
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
In-Reply-To: <CAKWORBBVbZBKqxNsmMkWnx-MjLf2uCPFJCU2LJBUMsciu+XfPA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/5/21 01:22, Brad Brown 写道:
> Hello,
> 
> I hope this email will send with the attachment, but please see below
> about an issue with a Linux computer.
> 
> I needed to verify a card in a Dell Precision 7730 so I took off the
> case, I disconnected the battery and I guess the CMOS battery is dead
> because when I tried to boot it back up it gave me a generic Windows
> error (there is no Windows on the drive) and then a wrong time BIOS. I
> got into the BIOS and sure enough, the UEFI boot sequence was back to
> factory with no listing for Linux and many of my other settings were
> wrong, keyboard light, charging, etc.
> 
> Ok so boot to Mint Live USB, run the Boot Repair, it says successful
> repair but a message about Locked-NVram and to add in the boot details
> manually. Below is the link for the repair log.
> 
> https://paste.ubuntu.com/p/Xf3JJHbwft/
> 
> Ok back into BIOS, I added it, but the File System List looked very
> weird, but I was able to start booting and see the normal screen, but
> then it went into a bunch of error scrolling and hung. I power cycled
> it and now it just goes into GRUB.
> 
> That's when I started googling and one thing that might be helpful is
> when running ls from GRUB when booting to grubx64.efi it doesn't
> really see the partitions. I mean it sees them, but not what they are.
> If I change the boot to shimx64.efi (it again boots into grub) but ls
> sees the partitions and what they are.
> 
> If booting into Live USB from shimx64.efi file and running gparted it
> tells me there are issues on the btrfs partition but it can't fix
> them.
> 
> I took a bunch of pictures to help let me know what pictures would be
> helpful and I will just link to google drive.
> 
> mint@mint:~$ efibootmgr
> BootCurrent: 0007
> Timeout: 0 seconds
> BootOrder: 0002,0001,0003,0006,0004,0007,0008
> Boot0000* Windows Boot Manager
> HD(1,GPT,137a5fe7-5c51-415f-aede-fe406ab629db,0x800,0x100000)/File(\EFI\Microsoft\Boot\bootmgfw.efi)57494e444f5753000100000088000000780000004200430044004f0042004a004500430054003d007b00390064006500610038003600320063002d0035006300640064002d0034006500370030002d0061006300630031002d006600330032006200330034003400640034003700390035007d000000a1620100000010000000040000007fff0400
> Boot0001 Linux HD(1,GPT,238692d6-7da0-493e-8329-08bd94eaa0bc,0x800,0x100000)/File(\EFI\ubuntu\grubx64.efi)
> Boot0002* Old boot
> HD(1,GPT,238692d6-7da0-493e-8329-08bd94eaa0bc,0x800,0x100000)/File(\EFI\ubuntu\shimx64.efi)
> Boot0003* Onboard NIC(IPV4)
> PciRoot(0x0)/Pci(0x1f,0x6)/MAC(8c04ba01b112,0)/IPv4(0.0.0.00.0.0.0,0,0)0000424f
> Boot0004* Onboard NIC(IPV6)
> PciRoot(0x0)/Pci(0x1f,0x6)/MAC(8c04ba01b112,0)/IPv6([::]:<->[::]:,0,0)0000424f
> Boot0006 UEFI: PM981 NVMe Samsung 256GB, Partition 1
> HD(1,GPT,238692d6-7da0-493e-8329-08bd94eaa0bc,0x800,0x100000)/File(\EFI\Microsoft\Boot\bootmgfw.efi)0000424f
> Boot0007* UEFI: USB
> PciRoot(0x0)/Pci(0x14,0x0)/USB(18,0)/CDROM(1,0x1234,0xa000)0000424f
> Boot0008* UEFI: USB, Partition 2
> PciRoot(0x0)/Pci(0x14,0x0)/USB(18,0)/HD(2,MBR,0xe904b4b7,0x1234,0x2800)0000424f
> 
> Thanks all
> 
> ------
> 
> 
> mint@mint:~$ uname -a
> Linux mint 6.12.48+deb13-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.12.48-1
> (2025-09-20) x86_64 GNU/Linux
> 
> mint@mint:~$ btrfs --version
> btrfs-progs v6.14
> -EXPERIMENTAL -INJECT -STATIC +LZO +ZSTD +UDEV +FSVERITY +ZONED CRYPTO=builtin
> 
> mint@mint:~$ sudo btrfs fi show
> Label: none  uuid: 64e55b77-65ef-43d7-b84f-458aa9c35d38
>          Total devices 1 FS bytes used 122.02GiB
>          devid    1 size 213.27GiB used 152.02GiB path /dev/nvme0n1p2
> 
> btrfs fi df /home
> Can't run as am booted to a live USB
> 
> dmesg.log attached

Your fs is corrupted, and it looks like some write-from-future corruption.
Normally this means the FUA/flush behavior is unreliable.

If you're not using nobarrier mount option, it's possible your nvme 
drive has some bad firmware, not respecting FUA/flush command.

Since your fs is corrupted, and it's affecting the very important fs 
tree, I do not think the fs can be repaired to a RW state.

You can try mount the fs with "rescue=all,ro" mount option, but I guess 
it will still fail anyway. If you know some subvolume id, you may try 
with "rescue=all,ro,subvold=<id>" mount option and may have a chance to 
salvage data from that specific subvolume.
