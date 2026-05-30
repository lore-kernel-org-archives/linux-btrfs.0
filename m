Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA92288B8
	for <linux-btrfs@vger.kernel.org>; Sat, 30 May 2026 01:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780103030; cv=none; b=NHb7I/n7RVciUloLD+pRImruzsnWlp/JDC8zlcC9No8UiAf0rGSGcdRzYXNc5zQNdCSFZqmNxv3ksaBa/NIOET2sAHM5zyXFaMOJpFawdP3s5vPHrM9k0ce/PMjbM7ybxhMern855r7MRiDXrlNX2QHDJpkmywQ9eb43ORldU4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780103030; c=relaxed/simple;
	bh=Nb6+PUNGbVrI2sGYHa/aJnEG3oLZWT2+7CUWUy39xzM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ZRVNiXf3WFnQ+NGx41zGvCtdXOKH2A2HwONktUR9d7BY85hRnV6l1ZAxfIswBP7BNLblek6aVdjm8dGhHKtlt25JK4tNibn6l0xXljetoLKOJ6BfKgPAdArO+cRKeUkwMVtl20g5cHHA5ZFnZk/RC87be1M0VGDhh1xf/V3XDq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=B2NoDhTe; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="B2NoDhTe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1780103026; x=1780707826; i=quwenruo.btrfs@gmx.com;
	bh=iZSrwZLoQDChpXpkP8gWDaJR5wtOeXIh6jYhlOH4LbU=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=B2NoDhTehZvGT8b1c8jp2SkRtqL8vI74+E8ysMZ/qkLBXf+YBBNoa2HiNvbNJGgJ
	 uZbPhd3sZVboD/WpILBjVRitjsee0aS1EttYYFtIjh5P8rerA2NxuiQLwsIaANlWh
	 hZzI7AGPkSxo3yopVxK/Aln+fWh93oAPYSaEIOmchgoGk5WhUhIiR1AreNadOnSiF
	 d8JunlBsLzk+cUZNDI/m8iTTL+p4r2We0DN9His+ICBpYFSNMTJ7KhBa2VMGnTHo4
	 iLcb0kjzwnIHRBcKTa5AQxiwtZZOjbTGmCH6B3/DJvzS+fgyFFn0smFNZqDZHb/Es
	 EoPFapEAmqiRrR9rlw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MNbkv-1wduX42jyl-00RcLU; Sat, 30
 May 2026 03:03:46 +0200
Message-ID: <bc9c0c4e-8f13-4e9f-8bd4-6c624d2b0a76@gmx.com>
Date: Sat, 30 May 2026 10:33:43 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: scrub error & discrepancy
To: Michael Zacherl <ubu@bluemole.com>, linux-btrfs@vger.kernel.org
References: <1552EE44-BE29-452D-BCAA-DAF750F4A2C7@bluemole.com>
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
In-Reply-To: <1552EE44-BE29-452D-BCAA-DAF750F4A2C7@bluemole.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:2ZGNqxw5T2zc6PJgn1sbbr+AObcE5wQVHPejlgb1US9mlXo2anu
 5e/njS3NVpxUtF+2aci8+XW2qNXgnvOhDzfpEFhmr7EwnjYrmrPhu9x8c1O+ECMe+sBwCZm
 4FUzuZbsSkOloNPnEzHD2yjGtvbbQJZtJP6aZcGo+xt3pF1Ptcic6xG7UiDewiiqNH5JXeu
 so/Xu6MExyohhreIjSBSA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:it3CeNNNMgY=;eH7TT+XQ5JRDHj98w+mz9NKmaeO
 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



=E5=9C=A8 2026/5/30 09:49, Michael Zacherl =E5=86=99=E9=81=93:
> Hello, I did a routine scrub on the offline root fs of a notebook (Endea=
vourOS, Arch based).
>=20
> This is the output:
>=20
> $ sudo btrfs scrub start -B /mnt
> Starting scrub on devid 1
> scrub done for 44cb181f-faf6-48c2-a462-904cfe493576
> Scrub started:    Fri May 29 23:54:53 2026
> Status:           finished
> Duration:         0:10:23
> Total to scrub:   911.45GiB
> Rate:             1.46GiB/s
> Error summary:    csum=3D18
>    Corrected:      0
>    Uncorrectable:  18
>    Unverified:     0
> ERROR: there are 1 uncorrectable errors
>=20
> Last line vs. "Uncorrectable:  18=E2=80=9D ..

Indeed it's confusing. Will update the message.

In fact the "1" is only accounting for how many device(s) have=20
uncorrectable errors.

So the more correct one should be "there are 1 device(s) with=20
uncorrectable errors".

> How would I deal with that?

Check the dmesg, it should contain the file path of the bad blocks where=
=20
it belongs to.

And if that file is not important, you can just delete it.

If it's important, you can verify how bad the damage is, by going
"ro,rescue=3Didatacsums" and read out the affected file, manually check
how damaged they are.

Thanks,
Qu

>=20
> Thank you, Michael.

