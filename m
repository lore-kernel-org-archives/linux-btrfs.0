Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12BEA13B5AA
	for <linux-btrfs@vger.kernel.org>; Sun,  5 May 2024 22:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714948270; cv=none; b=ANQGMNXbtkRkffdqMVux+VvAZp+8opfj4Qm738IrTVlt4pLyVIiYDMJcRHqLU3Y80nFvhwthY9X7WYm8ufgeblDIVtX0Qhy5L6WF0eHdr4J2NoVtLmOf6FxIifh7WOSa7IrNZCmLLl+z8bfVOg0+6p5uTTriP0pbxIwu5deFOU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714948270; c=relaxed/simple;
	bh=j2TfgJT3CTN2XIf9CQ3/CSyS1pV7lUQoXmRmbQBkoIo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=r1FOD+nnXqc1jw0BpbQEnHk6wlk9Z9oeouihip9zd/3aJ1gWYy+aGEVJqpHZrgd0s4C5Cq1hFiQWaxmolXHU8CaeTX2uvcVbE1kZypnLTe0stJDQyPc6N1rCDY5a1JxOuYDoLYBjfExoq2nU9kJooQSij3d0ratPG3tPSHMszdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=O+FzB7os; arc=none smtp.client-ip=212.227.15.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="O+FzB7os"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1714948265; x=1715553065; i=quwenruo.btrfs@gmx.com;
	bh=j2TfgJT3CTN2XIf9CQ3/CSyS1pV7lUQoXmRmbQBkoIo=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=O+FzB7osy5XVCGvY3iydFT9xZW5XTSdN8DsIB1pzhW6IO8GO3V9ZrTrxymbqbaKp
	 xUze596P0pYPNjd0avJJEMpxSNisxXkQ2fp0jn1iSWg60aGhflsUr8VegQmkcUwX/
	 Pn/tnCcL1fZwTYO4P1AJfTL6c+Wstmskru2QrNRr6R8wID9cxMBJamMMG5x+s6JDG
	 zkS959XByzvAChPWrBxt7+wdeeCXZxH55do96/S20oEt8VcouDSbTq5Jd4G4Yb6rh
	 dk5epRndnIRd5B/todEbXzg0TDcrwIsmyEbzgWK1OXnjvMuo57nZ6FugbUX5bl71E
	 KVtwxgSiSMZfLIlMkA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [172.16.0.219] ([159.196.52.54]) by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MLiCo-1sLPnE394y-00HhVA; Mon, 06
 May 2024 00:31:05 +0200
Message-ID: <ac0c71a9-683c-4d0b-a60f-d6cdf975838d@gmx.com>
Date: Mon, 6 May 2024 08:01:01 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: btrfs-convert on 24Gb image corrupts files.
To: Yordan <y16267966@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAE0VrXL99p1ra6aRyqZgEbHKJ2LBKU0Yn+sPd4WoHxq0pONjGg@mail.gmail.com>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCY00iVQUJDToH
 pgAKCRDCPZHzoSX+qNKACACkjDLzCvcFuDlgqCiS4ajHAo6twGra3uGgY2klo3S4JespWifr
 BLPPak74oOShqNZ8yWzB1Bkz1u93Ifx3c3H0r2vLWrImoP5eQdymVqMWmDAq+sV1Koyt8gXQ
 XPD2jQCrfR9nUuV1F3Z4Lgo+6I5LjuXBVEayFdz/VYK63+YLEAlSowCF72Lkz06TmaI0XMyj
 jgRNGM2MRgfxbprCcsgUypaDfmhY2nrhIzPUICURfp9t/65+/PLlV4nYs+DtSwPyNjkPX72+
 LdyIdY+BqS8cZbPG5spCyJIlZonADojLDYQq4QnufARU51zyVjzTXMg5gAttDZwTH+8LbNI4
 mm2YzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYCGwwWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCY00ibgUJDToHvwAK
 CRDCPZHzoSX+qK6vB/9yyZlsS+ijtsvwYDjGA2WhVhN07Xa5SBBvGCAycyGGzSMkOJcOtUUf
 tD+ADyrLbLuVSfRN1ke738UojphwkSFj4t9scG5A+U8GgOZtrlYOsY2+cG3R5vjoXUgXMP37
 INfWh0KbJodf0G48xouesn08cbfUdlphSMXujCA8y5TcNyRuNv2q5Nizl8sKhUZzh4BascoK
 DChBuznBsucCTAGrwPgG4/ul6HnWE8DipMKvkV9ob1xJS2W4WJRPp6QdVrBWJ9cCdtpR6GbL
 iQi22uZXoSPv/0oUrGU+U5X4IvdnvT+8viPzszL5wXswJZfqfy8tmHM85yjObVdIG6AlnrrD
In-Reply-To: <CAE0VrXL99p1ra6aRyqZgEbHKJ2LBKU0Yn+sPd4WoHxq0pONjGg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:GTie2bHT66zD9sQDkDZv5UXPDLYx7pIqHfbqhhZvEMswbP4tKVd
 3w3MM+if19l9R6cF223IDmYeZAvu/SLQxiDWm7BdgRR6MJFoHgnbfxfbu47CqXFuWq9sgxn
 +qro6PEAtIehm9OLlF0Hte9WItvsECjnY/r93KmWkAFK6/pAf314VBMCHdp+NsQrIAaJUnd
 nZ/RsoRPTscfB/NuvUOOA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:DeVO10DGae0=;hXK2sc61YRwcq/oyr16n9XRre4/
 8OhyTHwS6Ke2eXpH6j6dXiQ3mjRZouXcAn3qRZTrAJOu8E7zDn+XXjQzBIT9FnPMTz7AImlr7
 BVnJNq3OkwZ1534JsBHSuB4TtCWKxvySFlJA9F3xQSl6/uTCyRcxWSlWcmJs1cfWsN9N+8P13
 vRl6YbUae6pIaDF5v67urW7+WFZJU2RgD5b24gr905qjjcXEwkkSoPJON06giy0Shz7n5xz36
 SGOsgaNIxfduGYYc8Kxvm1vQiAzCJTy2n2nuFjMw5yjeCj9B+5KZ5tzvWlCAGrLVhfcNcl3Fx
 /mNcA7PcsUyQKsZjvi2QogD1KwLok7/Xy0bXrRJU5ESLACJrrqAPDqiI6J+jxe0xjHDRv9pEI
 AQpgNlTVvhOVUdNZEwL3Vr2eQRv6gnTOarJVz1vB5K8KYI9LxP001GDAfmtkLdf38VzUbKfI3
 ogsVwosQOS78qy8Zeb/qvCqXYQbNN7J/n7Ku518nLg5ZBO2tKLIiBZ+FZEUdPZtCQnj1pZjiY
 Nq6KYVXcgb62b7Qo7BdGpX4oSmgcSmjEQ9E04x/MKbGdYumZgSnUg+07EjmME/yQaaLasNGXd
 d5KGb7pUD3oHDtV2jAJgWbxtugccaacufwON9enX0EsHFefsfygl1VVR9uCD6wvIp6cpkaksp
 zcPfuFks7S+TDrZ3H8Lc15Y/+1hl+UqAfMljWsymkJttMBnbO0uNVllBZ1EULymLoWTloN7Mw
 mXtXVXyTrJwuQxFVVibRZWYw4eYibA6BcIBteCRAEqv+FjLAgRMVpB3OtW0E2dugvXOS3HJlL
 jd3HMhDVeKPX+k7GV45auoCFicq5OWrKGTccbveJlgWuM=



=E5=9C=A8 2024/5/6 00:35, Yordan =E5=86=99=E9=81=93:
> Hi, it's Jordan - the reporter, I'm switching the email server as the
> first one presumably did dirty things and was rejected by the "mlmmj
> program managing the mailing list".
>
>> Mind to provide the "filefrag -v" output after conversion using Anand's
> fixes?
>
>> Mind to provide the "filefrag -v" output after conversion using Anand's
>
> fixes?
>
> After applying the 4 patches and compiling:
>
[...]
> (chroot) livecd /k # filefrag -v
> ./root/.mozilla/firefox/s554srh9.default-release/storage/permanent/chrom=
e/idb/3561288849sdhlie.sqlite
> Filesystem type is: 9123683e
> File size of ./root/.mozilla/firefox/s554srh9.default-release/storage/pe=
rmanent/chrome/idb/3561288849sdhlie.sqlite
> is 49152 (12 blocks of 4096 bytes)
> ext: logical_offset: physical_offset: length: expected: flags:
> 0: 0.. 1: 2217003.. 2217004: 2: shared
> 1: 2.. 11: 2217019.. 2217028: 10: 2217005: last,shared,eof

OK, that's the problem, compared to the older values from ext4:

 > 0: 0.. 1: 2217003.. 2217004: 2:
 > 1: 2.. 10: 2217019.. 2217027: 9: 2217005:
 > 2: 11.. 11: 2217028.. 2217028: 1: last,unwritten,eof

The last extent of btrfs still doesn't properly have the preallocated
flag, thus we read the garbage instead of filling it with 0.

I'll give more comprehensive review on Anand's fix.
And for the worst case I can change btrfs-convert to create a hole to
properly fix it.

Thanks for the detailed report!
Qu
