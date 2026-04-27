Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A34C526C3B0
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2026 02:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777255545; cv=none; b=HIsrnSO6/1HosZy3bqscjvSzNGgYKsbjMUxvcy64u14UTck0GU6KlPW11f57eIjdUlx4L+bJfwveyvXgVhW8TU2eEs5eSy06f6meEGf1FXpoo2H/WfzzCZnDDt8tIX76688luiiy25YgrrqMHgA9+NgyEB0TBikUY65RDxf1gbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777255545; c=relaxed/simple;
	bh=JsWTgvlqoWmHPfnedPO0JTG4XwakohQWtxCOoyp4aYo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=tUKIPM8ghf0wJ3kpThks1pLba57Rb8sZTebUw3BIXmB90Q8bIwRpQ/ByLhDD0uWosjoUDtja3CKl5HpZg+Ik1wyN8OGV8vZw9q6Tzuu6MWJA8qntRpMQAsmndO79eS0J0yC2nqmRvgh/Ois+9ViBklBURNQ4XclF6lDTEhHLFMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=P1ZoBPz2; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="P1ZoBPz2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1777255532; x=1777860332; i=quwenruo.btrfs@gmx.com;
	bh=JsWTgvlqoWmHPfnedPO0JTG4XwakohQWtxCOoyp4aYo=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=P1ZoBPz2bw8dVpM8OpRG8xTEe5CElw6349JBSpGrXNue0ilmrGxb+WDVYKwwemIp
	 XhrPN7xMIV0nL4VoXQU8UekcACR8uuaFpx3bmXLIplLzQ+jiYgDteYKCxrZNvKwux
	 Pr7cYMEJipPIv0sT1ICO46kO7ZGLANGYw3j9fohUZP6swC/zvgHHIOfF408H5Kh6G
	 zDL1kuNs0O/Ozk/ZyugPrVOgc+dPvCyQtdQYbix8v5+Gp1IES5pKAjWA2gzLUDrIc
	 E5rBIAKgR/ifqKCKipf0iLL4uHS7Dmb5utYGNcsBZddYk9ny+NYMs4rdyANrb/T+S
	 XS2uUhty6LkvvBOKsw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1Mlw3X-1vYoJ61c0J-00fulK; Mon, 27
 Apr 2026 04:05:31 +0200
Message-ID: <b53641af-f231-45b9-9d4f-21e1ee8132c7@gmx.com>
Date: Mon, 27 Apr 2026 11:35:28 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Strange behavior with scrub, quotas, and snapshots
To: brainchild@mailbox.org, linux-btrfs@vger.kernel.org
References: <SYK4ET.WNV9390MEC881@mailbox.org>
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
In-Reply-To: <SYK4ET.WNV9390MEC881@mailbox.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:4quhMTlQBlU2sEhMb0cJ/OOj/s9bXe3+joRAfoyOMNjWUUm87/9
 6VPiQL7zYmSl16h3k48itlEeViYSRBSE1ihNMOX0uVHWXQkqhMPKSkdTYWOkKm8VLXqyZfE
 qQ7XF6epQY00tx14O+jCtYstvbv9lu3E8r7mFod2P3hzT1frf+c66wIx0jfsdgDG4jBsjo5
 0/xU/2BRCOvqgu7XqApPQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:Xkfw5/fa5mQ=;HFW3SBu/2vRi2TajfWGa9JsEpCG
 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



=E5=9C=A8 2026/4/27 09:22, brainchild@mailbox.org =E5=86=99=E9=81=93:
> Hello.
>=20
> I am struggling with a poorly behaved BTRFS volume.
>=20
[...]
> ---
>=20
> No errors are reported in the kernel log, only warnings about skipping=
=20
> the swap file during scrub.

If you assume the fs has some corruption, none of the above is really=20
useful.
A full "btrfs check" is strongly recommended.

>=20
> Second, within the logs generated for Timeshift, a concerning pattern=20
> recurs, as in the attached example. Further, during the periods in which=
=20
> are generated logs such as the one attached, the entire system lags=20
> considerably. It is clear that the volume is not healthy.

The lag is mostly caused by qgroup.
You have a lot of snapshots (shown by the super large snapshot id),=20
every time a large snapshot/subvolume is deleted, btrfs will try to=20
disable qgroup to avoid such lag, but if whatever script/tool decides to=
=20
rescan qgroup when the snapshot/subvolume deleting is still under going,=
=20
the lag will be re-introduced.

>=20
> I was using a recent 6.x kernel, I believe one of 6.18.x, when the=20
> problem emerged. I upgraded by to 7.0, finding no improvement in the=20
> operation of the volume.
>=20
> Also, I tried initiating the scrub through the most recent static build=
=20
> of the user-space utility (i.e. btrfs-progs), with no improvement.
>=20
> I would like some suggestions for restoring the volume to health, to=20
> avoid the need to provision a new volume from scratch.

"btrfs check" first, if no error, disable qgroup if you have frequent=20
snapshot creation/deletion.

Thanks,
Qu

>=20
> Thank you.
>=20

