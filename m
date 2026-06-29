Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3C6614A8B
	for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2026 00:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782693760; cv=none; b=Fgz09PoSwRJmmNNbwc6Db7LngESPxpTW0TRLCISyvUt7ysHCvwsejm6CMxdalkun61zAOvUbbjYb/xGVtJhY3zqQPZekcxqtuKJnS9oLnEc8oAtYGBxgtNC6iJO4KBn6LHZpTmQue6FsJMcmU+hatxewJMbhiHJSJ/YLqycM/dU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782693760; c=relaxed/simple;
	bh=LDqQxlV6GMMoksZAtIl0sgCEED+gX6EZiiPvHZcwimM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=p5mzDR/RjaZWPlIBTi1JfqouRS/00t4XZGq0fvZUB3GpWjtOenK5ed8TpU/KsPbq37bwpUIn2tipjjmjIdxZSHk/Gc1TqV8wWHdfpovWgHJp/pJlkwm7xGckYGYjyFn3m8p8zsFgRTpZhvrtnTLyyubA8DZSiQwq8stjo3wgIMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=nxEbhJrC; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="nxEbhJrC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1782693756; x=1783298556; i=quwenruo.btrfs@gmx.com;
	bh=0tvaAKyt3O2XlGf0oT49DejByZuf5vgSGiSeMnsmkd0=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=nxEbhJrChKaRbUqtOfbljjws9rSmV1U57PMa7X5059P7J/LTxYlJKh+NOcjqSXrf
	 4NHMLEzM0D/q7JgY43tEsruDCWiKgWITterOEJXoHdKS8BXYP5yOYy4ZGiFf2AyAr
	 9n/8kMnkPdCijPV3ir6uFxKvKhPGhVCPBDuGcHuBu5mQBj/JrR46KO4e+ONNszax6
	 ILImSz4CR06oSQvXg4q42KGStOdZ08z4eJQGj9cUYEiZQ11AsMQQqYE6t4Mlir028
	 xkTsZqecNeOGB6Eh/eCCXFC2lzJ6z7F8DPg2SDUPNolDBsE7Q/q0JyIcMkkIlel1y
	 46vmA5aMRKt8GhZkEg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MJmGP-1wONwD0qpV-00IZJp for
 <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2026 02:42:36 +0200
Message-ID: <55561c5e-ba4d-494d-932f-78ecf4a0e2cb@gmx.com>
Date: Mon, 29 Jun 2026 10:12:33 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: shrink btrfs partition - recommended way?
To: linux-btrfs@vger.kernel.org
References: <20260628233658.GA3404176@tik.uni-stuttgart.de>
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
In-Reply-To: <20260628233658.GA3404176@tik.uni-stuttgart.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:+p8tEqifvYBcbciyrQlxNb7WoDJgdXomiAEICTp9k9oT6nuNbt7
 1SE2+4C70IJB+8Rysm3JxAGYCA54C98OOl3Epr8bxztD7HuVo2UNM2SRc6GOOCryf1BPtCz
 5fw/cLppuji+ZZ0rZo3znUuJF5ruv+RqIrrxJ5nxolYMfBCccCF8FfEEwxC2P8xicLcJhQ5
 B01+juNdzg5pppaRYgbbA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:as5Kk38kDBU=;esvsjqHaKWdwaxI9R+/JmQfsBST
 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



=E5=9C=A8 2026/6/29 09:06, Ulli Horlacher =E5=86=99=E9=81=93:
>=20
> Is there a recommended way (or tool) to shrink a btrfs partition?
>=20
> I have:
>=20
> root@zoo:~# lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINTS /dev/sdc
> NAME    SIZE FSTYPE MOUNTPOINTS
> sdc     256G
> `-sdc1  256G btrfs  /LXC
>=20
> root@zoo:~# df -Th /LXC
> Filesystem     Type   Size  Used Avail Use% Mounted on
> /dev/sdc1      btrfs  256G   19G  236G   8% /LXC
>=20
> And want to shrink /dev/sdc1 to 200 GB
>=20
> I know, I can use btrfs filesystem resize and afterwards use fdisk to
> delete /dev/sdc1, create a new smaller /dev/sdc1 and then add a new
> /dev/sdc2
> BUT if make a calculation error with fdisk the btrfs filesystem will be
> damaged.
> gparted can do it all together in one step, but it needs X11, which I do
> not have on host zoo. I have only text console access, no X11.
>                                        =20

You can sshrink the btrfs to a much smaller size, e.g. 32G, then shrink=20
sdc1 to whatever you want.

There should be more than enough headroom, as 32G is way smaller than=20
200G you want.

Then resize btrfs to max to take all the space again.

Thanks,
Qu
