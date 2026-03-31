Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4456840711B
	for <linux-btrfs@vger.kernel.org>; Tue, 31 Mar 2026 21:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774991646; cv=none; b=bf2iyPldAsj+44ShtohmcF1Mu+HFKkWOPhnFonL7vViy45sUG/ZtjlNYJ6u9XmDWV+lsOaa3fn1lBXHJY5jKBAfJwlw8sJtJEfcE55oyKiYqvS+GJOTIsIB7ItHHbXZW8K66isGXiEYy+jKZqJYLyuo2qr3Bpz4EKJQC9l1am4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774991646; c=relaxed/simple;
	bh=s5qjWfHujPMnE1qUDRBjKhDgdG7F9ztfev2qNKYOmnU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=CqAl9ySMNekmj93ZdrC/obCHfTBbmFa1q0q58v03jRJKx3tUuX6G4x63zd46k6T/+09WOFhKj4pCCh+ZlRWU0fysqj/dMSWpWkIDilf0B5nXBuG64BRLgLhbiACVizv64DcTtEvQOKuW7zj90kaohiDppidw7tTWi7Zu6n4XlH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=XYjDI9a4; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="XYjDI9a4"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-48700b1ba53so56445485e9.1
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Mar 2026 14:14:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774991643; x=1775596443; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=DyOsH1dLFgtA7ud/ms/U7f1EAJi18rnbtRwuPLt/jSM=;
        b=XYjDI9a4Gwf/A5knRMGBxG0p52U+36/uW4/w+kgbWpzOXDtKFw5GsAe7PTNzeNnSJq
         GRCH4p+GitDFspERR6Gc82d1Cfs+5i+kiD/VwXJt/s2ans8nVSNLwqT10RNmvwvm2qJP
         CreEYByzY8vHuC6fWhUsaVJtcX2J4aG5yu5bO9ij0c6HqS8xqcPn0tYeYARLgNVgWrs0
         x6nE41jRsEPjjU7GJ/RGAlIB5DxqRB4dfN5fskc6c/pTXyq9cGTlFBCoCqlGClhAu3za
         F94CxIkf0aPC1VcgHgFtPo/kR2lkdjbOtJyjue9Gj2v5bdI1U72HRqWuelgQpjo49g5j
         I/4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774991643; x=1775596443;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DyOsH1dLFgtA7ud/ms/U7f1EAJi18rnbtRwuPLt/jSM=;
        b=G5iYp4iBiccWOzGMGT/VqUYeKO2KjZPDrzB9NKuPCCX6vKTtETbV1way3q0dwuEv1c
         7BSQggCXSTN3WJ9gFNPVpwZeFfzrjCQO/zWD53Q2iLBYvHABnrA9GBhepNcz8GAmfJTO
         fnfZH8aOTqd74Gk/1g/X8A0A07hf8lqb8NOdr9KE4rSltygGpNmGL4EhDPTkn6GmJcPG
         kt4vu1VPH/gWPkStKMqGebRFMuqdWvWesji9qR+8pDZ4fLNqKXQ6XF0xhy/9VxiSrNfh
         6Fzx+G98GipTPXDs8xA9/nz6IcfZRrBMmyIeVGRqHrLd7ZxuZUojmLe2rgjJbJBMknAR
         GsTA==
X-Forwarded-Encrypted: i=1; AJvYcCUf/psQuXhIjz0y9CHuhiXvT/7AY1QChtgEub7NtjU34d6+4Kirzep8mfBPFNay7s6FuHujo2X8myG5Xg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxkvZQViW3q26QRNVAvrSIoJ5v4CeRzZz+ydWJZfdv23hkmvrx4
	xeS92lYIBxJ3l4wid9Ysm/QlKl4OH6mCDtOnOfMLjyW8Cs3folK/Ztc0p4wIukYBj/Y7jGVh3SM
	9R/+Eevk=
X-Gm-Gg: ATEYQzzV2t1Wc7ALWizxrWC+pRRcdf/5uvaqj2K3AvNxQ68ogI49DeBIxirP1TjtfME
	Jsp1Po82BBFgNvjwuiiCa3XuBri9PJ/PpbzIh4Q00hbGzByTF2WsRcz7sjjNfmRSKWXEJPFK/eA
	FIl0P1mYN086sdjYcoPkDkQ0Q/CKEdii+dC3Kw3FFPLrjXxd52DjRzXKU17TYkBgLkLutyr3L+v
	KQC5YfshQIdhq+AWQmrt5d0+Ev17KEQdqu9uHyiipIwAbvw1w72/NjFKMdBMAagsycUJ/avv7uK
	mgoy+FL7n4MutZ4JRsWcWKSYRiBtp+e8z8OHozUUwc+kBdI8WT0d+ujOHcN/DIpyildn6FZ2Qay
	O/5/jGRiJ3wVJnG9rJthHFFoLwbeAOR4thglk4CyyO82fJ33/4dP7S5Xhrbo+nmqOgR8qMdWGwV
	oPwLH8sVUy/5/lPIHAs+nJSn5KXdsSPjNgnLgcYZ1U5/WK4PzG2PY=
X-Received: by 2002:a05:600c:1388:b0:485:41c4:e2e4 with SMTP id 5b1f17b1804b1-4888359ddaemr13946535e9.23.1774991642173;
        Tue, 31 Mar 2026 14:14:02 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b24276689asm120024465ad.38.2026.03.31.14.13.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Mar 2026 14:14:01 -0700 (PDT)
Message-ID: <2aa4a94b-1f10-4b17-a78a-2a58efb56522@suse.com>
Date: Wed, 1 Apr 2026 07:43:57 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Problem mounting 4-drive RAID1 fs after replace was interrupted
 by kernel crash
To: =?UTF-8?Q?Jaron_Vi=C3=ABtor?= <jaron@vietors.com>,
 linux-btrfs@vger.kernel.org
References: <CAF1bhLVYLZvD=j2XyuxXDKD-NWNJAwDnpVN+UYeQW-HbzNRn1A@mail.gmail.com>
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
In-Reply-To: <CAF1bhLVYLZvD=j2XyuxXDKD-NWNJAwDnpVN+UYeQW-HbzNRn1A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/4/1 07:09, Jaron Viëtor 写道:
> Hello,
> 
> I have a machine with a 4-drive RAID1 btrfs filesystem attached to it
> over a USB3-to-SATA bridge. They are not connected directly over SATA
> because it's an Intel NUC, so USB3 is pretty much the only sensible
> option.
> A few days ago, one of the drives started failing so I connected a
> second USB-TO-SATA bridge (the first one could only hold 4 drives),
> inserted a new drive into the new bridge, and ran:
> 
> btrfs replace start -r 7 /dev/sdk1 /media
> 
> Devid 7 was the failing drive, and sdk1 is the new (larger) replacement.
> This all went fine so far, and the replace was happily chugging along
> for several hours.
> Unfortunately, at around 7.1% done a kernel crash happened (I believe
> it was unrelated to the replace operation, but can't be sure -
> unfortunately I didn't save the errors it printed) and I had to reboot
> the machine.
> 
> After the reboot, attempting to mount the filesystem gives these messages:
> 
> BTRFS info (device sdk1): first mount of filesystem
> d18c93f8-d80a-4aa7-adc5-86d457ddde20
> BTRFS info (device sdk1): using crc32c (crc32c-lib) checksum algorithm
> BTRFS error (device sdk1): devid 0 path /dev/sdk1 is registered but
> not found in chunk tree
> BTRFS error (device sdk1): remove the above devices or use 'btrfs
> device scan --forget <dev>' to unregister them before mount
> BTRFS error (device sdk1): open_ctree failed: -117
> 
> Either running that command and/or unplugging the new replacement
> drive, instead gives me these (either action results in the same
> messages):

Kernel version please.

And with all devices (including the new and failing disks), and "btrfs 
dev scan", the mount still fails with the same message?

If so, mount with "degraded" mount option, and try to cancel the 
replacement, then try again.

Thanks,
Qu

> 
> BTRFS info (device sdg1): first mount of filesystem
> d18c93f8-d80a-4aa7-adc5-86d457ddde20
> BTRFS info (device sdg1): using crc32c (crc32c-lib) checksum algorithm
> BTRFS info (device sdg1): bdev /dev/sdg1 errs: wr 0, rd 16, flush 0,
> corrupt 1054, gen 0
> BTRFS info (device sdg1): bdev /dev/sdh1 errs: wr 0, rd 0, flush 0,
> corrupt 379, gen 0
> BTRFS info (device sdg1): bdev /dev/sdi1 errs: wr 0, rd 0, flush 0,
> corrupt 1652, gen 0
> BTRFS info (device sdg1): bdev /dev/sdj1 errs: wr 0, rd 0, flush 0,
> corrupt 1522, gen 0
> BTRFS warning (device sdg1): cannot mount because device replace
> operation is ongoing and
> BTRFS warning (device sdg1): tgtdev (devid 0) is missing, need to run
> 'btrfs dev scan'?
> BTRFS error (device sdg1): failed to init dev_replace: -5
> BTRFS error (device sdg1): open_ctree failed: -5
> 
> So... it seems to be stuck thinking the new drive both should -and-
> shouldn't be there. Huh.
> 
> I already asked for help with this issue in the IRC channel, but the
> friendly folks there told me after some debugging that this was a
> problem for the mailing list. So... here I am!
> I do have access to other machines I could potentially connect the
> drives directly to... but I'm not inclined to think the USB-to-SATA
> bridge(s) is/are the problem here. (Unless somebody here says
> otherwise, of course.)
> 
> Thanks in advance for any help you may be able to provide!
> 
> Kind regards,
> Jaron Viëtor
> 

