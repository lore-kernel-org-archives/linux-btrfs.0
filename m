Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA56368D4A
	for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 21:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789335650; cv=none; b=I/4haXUSw6Uc1xmPE1ReCU3IX7bujrONzIX8QB6WgkNHFTiCSVvpd55GfNwlwtQBqwxTVoMQg+JMTIvAGuLykUhW8toBhx/e219Lx+aqoUMsbiwYOe+tMRFe7cmGYn41iWuFzmTXQFAxiMU3M81THjlmyX9JOuUYjmB4DmpVXaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789335650; c=relaxed/simple;
	bh=bBmxIEvNwTtfy7/DZI/5dNtaiMiF94tI1cUzNJs0NOA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=F3vX9EsUmwfKZBdTXFi404KGhVI9gX6sWN0e+B9RNYC9yy838HWGXLdLWV8TLUWG5WFetwRQGhGSMKjeCJvJk90/89VDZGFkLMHf3m4nns/fwJlwVfn8PA30cv7i33MJFuoXTeRHCw3+x6BZJvQc6uBVBOkzGpbhz1EffAFs2HE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=uLBPRpcO; arc=none smtp.client-ip=212.227.15.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="uLBPRpcO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1789335646; x=1789940446; i=quwenruo.btrfs@gmx.com;
	bh=bBmxIEvNwTtfy7/DZI/5dNtaiMiF94tI1cUzNJs0NOA=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=uLBPRpcOhyRV3YeK6HwkcqLWHh3ODksRwVyUwH8TEpZzBCb4h9dx1Kxgyi2ovbl/
	 013c3G6vFTo3d2H6yI+hASJXJl6adYPxtLXCXSzbsezO6xuFaWQGuH+bUc0rBAyHA
	 jAohyTobtNHdL6NRzz2T8rxkFM2e2YFtuiMTFnVmDOOQcyb2N/ivmw0W04UDSnORl
	 bCsjpuvZYz2JbHDio94JO3WXybi9ltKMJNOt6Tgd4x51kJBuTxAymdQxJk3gP/9o2
	 YGkelrhLh7t+FdjHWZ+6OOImXRL9EG9QtAH/hNlT6t3cXJRyn90F+O6QRaKQmRl2D
	 ObHoGLFNkPR90wg2qA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MzQkE-1wsrKI01Nw-00xXuH; Sun, 13
 Sep 2026 23:40:46 +0200
Message-ID: <11889985-e0b4-47bd-9fc7-441d9aec00d0@gmx.com>
Date: Mon, 14 Sep 2026 07:10:42 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: add "/dev/root" exception for device path update
To: Hanabishi <i.r.e.c.c.a.k.u.n+kernel.org@gmail.com>,
 Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <3e3164206d23ef991b9bd76dab6706238592cfb0.1789202516.git.wqu@suse.com>
 <9a889cf5-4e47-4f6f-b8ab-4c65b2f82e3c@gmail.com>
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
In-Reply-To: <9a889cf5-4e47-4f6f-b8ab-4c65b2f82e3c@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:KxHwW75+yTdJjeP/f4MbDIFRDQkhtYHVLMxztg8CMSMAqcWGI1S
 q7NoE2u4YCdSyQtn3hJVV+9GqGDkySlyVGIHjgeARseK0WecnfchFgihjbmpHt0AuPs9n9Q
 cXoZ7Mp1UfcfRprsSFFW61JDaQ15w2I2TqGVA0iqEja8cEXPhjC+uU+JPKf5Qyhydm0094v
 fKNic0Z4XBiMpdXJPCwrg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:Fg6tTOroIUY=;+OgxhuWnI+U1vnaRPhwAIZyNucd
 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
 Jl7RJh42pI=



=E5=9C=A8 2026/9/14 00:05, Hanabishi =E5=86=99=E9=81=93:
> I confirm that this patch fixes the '/dev/root' issue for me. Thank you.
>=20
>> To be honest, this is a user space problem: no one should trust the
>> device path shown in mount, only the device number.
> There are too many userspace applications that simply don't know/care=20
> about such edge cases.
> I'll try to report the situation where I can though.

Yes, too many userspace programs are not and should not even bothering=20
checking the mount info.

But for tools that bother, they should know what they are doing, not=20
only try to use the best tool/lib like libblkid, but also have a proper=20
fallback plan.

GRUB itself is already so complex that quite people are getting rid of=20
it, going much simpler solutions like systemd-boot.

