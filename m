Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E59E363C60;
	Mon,  3 Aug 2026 09:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785750285; cv=none; b=Ejs3YPbjbiEg5QeEKqjlW3H3XuZ6Vc7iXpLcQ33aq1hIG11qE5zfo6IztiTdUcOZIu5MjUuYmFhty7HHm3UjXLgIDt2Kh/lLD6sGlSw1XxiN1JUW8RUIUF/Cr9NzmhcFdU2qhkbmKIGOV/0pZCbmcHz1p8j88vvnKtYm63EJlsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785750285; c=relaxed/simple;
	bh=V++4j25IMe4tvIIWQ8I2FKkLw+I88TUbeTEChoQHTBs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IDf/gHSl7mLwsEx8mu5YDVvXAk9GFXzbstauRF+1/egvZxnnERbh6OZnwkX4Uw/FpquzrGtFcP99vC1DZxQbGb2yhuPDh3B6fdBOSms9iVRxZko8XgEkTgoSeg8T1uEmL2ws1fR/xbIl6ZeQhOBu4M53lyOI4V2mX+oZ1v2OIVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=tnU58PNt; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="tnU58PNt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1785750274; x=1786355074; i=quwenruo.btrfs@gmx.com;
	bh=gY7FJ7gX7VhwLqR4HrvvwD0GU2qilOPOq9kqhdqzmp0=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=tnU58PNtPxxoEIwsoeln/er66QZPtreuhdYFsd+rIUXFY9ETWR++xBuEU3g4TdSd
	 4vUl3B0OedOnXuzBBsJRSJcyboSnBKDwqueM7Q72VCO3kSGm5y1kQaLwLbbybshEP
	 cP+Ls0QnzWRlMUVDX4GzgPjlhLnBnIG33LPQLdbKtoZNwvet0b5LZPAIlTIZtewd3
	 JT/IygzLS87B/RtcveqDK6hIJiN8WIzcC6nc6W/iW+sCdxApIEaswin4lJOEzXU6q
	 aH9wzy8c1oWXNdoNj953H2DCTL341mvr3B8PvpiA4ZfJqyxom1BZxtup9+UmgxhA+
	 lYfi50jPpcAgXu0pIQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MrhUE-1xE36M0Okm-00h1rC; Mon, 03
 Aug 2026 11:44:34 +0200
Message-ID: <d98fc5c9-c107-4e67-a145-eca566b10e83@gmx.com>
Date: Mon, 3 Aug 2026 19:14:30 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Lockdep circular dependency: btrfs_swap_activate() calls
 sysfs_notify()
To: Christian Borntraeger <borntraeger@linux.ibm.com>,
 Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <782c4d5c-d93b-42b3-b4ca-58deb3d8a894@linux.ibm.com>
 <11be35c2-7ede-4c83-b21f-39e52c3b04a2@gmx.com>
 <6a5c7341-6e88-4eaf-8311-0de81b3d1015@linux.ibm.com>
 <bb5e1ba4-5062-4a92-a9ee-1ca0a0dcc992@linux.ibm.com>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1YAUJEP5a
 sQAKCRDCPZHzoSX+qF+mB/9gXu9C3BV0omDZBDWevJHxpWpOwQ8DxZEbk9b9LcrQlWdhFhyn
 xi+l5lRziV9ZGyYXp7N35a9t7GQJndMCFUWYoEa+1NCuxDs6bslfrCaGEGG/+wd6oIPb85xo
 naxnQ+SQtYLUFbU77WkUPaaIU8hH2BAfn9ZSDX9lIxheQE8ZYGGmo4wYpnN7/hSXALD7+oun
 tZljjGNT1o+/B8WVZtw/YZuCuHgZeaFdhcV2jsz7+iGb+LsqzHuznrXqbyUQgQT9kn8ZYFNW
 7tf+LNxXuwedzRag4fxtR+5GVvJ41Oh/eygp8VqiMAtnFYaSlb9sjia1Mh+m+OBFeuXjgGlG
 VvQFzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYCGwwWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1gQUJEP5a0gAK
 CRDCPZHzoSX+qHGpB/kB8A7M7KGL5qzat+jBRoLwB0Y3Zax0QWuANVdZM3eJDlKJKJ4HKzjo
 B2Pcn4JXL2apSan2uJftaMbNQbwotvabLXkE7cPpnppnBq7iovmBw++/d8zQjLQLWInQ5kNq
 Vmi36kmq8o5c0f97QVjMryHlmSlEZ2Wwc1kURAe4lsRG2dNeAd4CAqmTw0cMIrR6R/Dpt3ma
 +8oGXJOmwWuDFKNV4G2XLKcghqrtcRf2zAGNogg3KulCykHHripG3kPKsb7fYVcSQtlt5R6v
 HZStaZBzw4PcDiaAF3pPDBd+0fIKS6BlpeNRSFG94RYrt84Qw77JWDOAZsyNfEIEE0J6LSR/
In-Reply-To: <bb5e1ba4-5062-4a92-a9ee-1ca0a0dcc992@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:rzHZBOgHc4rthr6Gg+1kxm6jJRYnEYmmFDVr0SLI3wmcLwqTl4H
 4Se5H7+iEvIlcpUgubJw7PBXS3Nkx+bshL1+JDblxirayC/whTDOtVhzBwRhpatjy+TIe8T
 424+s3pMTucmCAqbkxBTbteUwyT3aiFH60aFivsBvn2SHKYClaIBT4LD8J7I70Ux9D1Hxof
 Ub/DoYZAxHG7xBTnttiig==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:l+HkFEzlFfE=;OXNa160cUlTyb0yFmYTIVpn7SJw
 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



=E5=9C=A8 2026/8/3 18:37, Christian Borntraeger =E5=86=99=E9=81=93:
>=20
>=20
> Am 31.07.26 um 13:14 schrieb Christian Borntraeger:
>>
>>
>> Am 31.07.26 um 13:12 schrieb Qu Wenruo:
>>>
>>>
>>> =E5=9C=A8 2026/7/31 20:27, Christian Borntraeger =E5=86=99=E9=81=93:
>>>> One or more of the following files ( btrfs-swapon-kernfs-repro.sh )=
=20
>>>> violates IBM policy and all attachment(s) have been removed from the=
=20
>>>> message.
>>
>> Oh.
>>
>>
>> Lets try this:
>> #!/bin/bash
>> # Reproducer for the lockdep circular dependency
>> #
> Can you reproduce the lockdep message?
>=20

Sorry, I am on vacation since the last reply, until Wednesday.

However the script seems to have several minor problems that got=20
rejected by my VM:

- EOF not matching
   The involved python scripts expects "EOF" without any other prefix,
   but the script is using "\tEOF", which failed to end the file.

   My bash version is 5.3.3, not sure if this is version specific.

- Bad indent rejected by python3
   The python version is 3.13.7, which rejects any weird indent, so
   it fails like:

     File "<stdin>", line 1
       import mmap, os, sys
   IndentationError: unexpected indent

Even with all those minor problems fixed, it still didn't trigger on my VM=
.

I tried 128 runs, the script is triggered for a newly created btrfs in a=
=20
loop, no lockdep warning triggered, all the same successful runs:

[repro] kernel 7.2.0-rc5-custom+, lockdep active
[repro] using existing btrfs at /mnt/btrfs/
[repro] dirtying a btrfs file mapping (mmap_lock -> sb_pagefaults ->=20
i_mmap_lock)
[repro] reading sysfs directories (kernfs_rwsem -> mmap_lock)
[repro] creating swap file /mnt/btrfs//lockdep-swapfile
[repro] swapon -- this is the call that closes the cycle
[repro] swapon succeeded
[repro] no lockdep splat
[repro] PASS: the i_mmap_lock -> kernfs_rwsem edge was not taken
[repro] (expected on a kernel carrying btrfs-swapon-kernfs-fix.patch)
[repro] swapoff /mnt/btrfs//lockdep-swapfile

The kernel has LOCKDEP and DEBUG_ATOMIC_SLEEP set.

Although this is on a newer branch, based on btrfs' for-next.

Thus not sure if there is anything new, or if it's really too timing=20
specific.

You may want to send out your fix for extra reviews, other developers=20
may provide extra review on the fix.

Thanks,
Qu
