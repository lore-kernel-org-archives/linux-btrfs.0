Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD6A37F8A2;
	Thu, 23 Apr 2026 06:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776925763; cv=none; b=bTP1a0DkFUkt5y2uobkHTCJER2b+60c/xpkLzSwdVikm/WxjQcU5TAmwIYL7HkUMxcmTqSxIFJX8aXnqJAtzj1NOEX8Wcex4vzp+Nyp3N4Eo2nVHhgxMHZY1iFwKRrCU8cfXGdx92ez59smupWD6TYtyLp4uEyopNvwwUGZmqq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776925763; c=relaxed/simple;
	bh=TAyzwAwrgM+BsInGsXXjjtMLRHeGXeZVxMmg1mPfmYE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BHKTGLkMkQhenWAMsjmyfUhvZ5FjBPSA7K7IKkC587g9hJKzVzj+epb6oBwHQmGBnQk+H1dqkyvzlNs/AxCL/6OxAOHysErrRKpr8fxyP8ZMcZ0u5y/uzEsmkHifnHKO0FphCqJHKKL6mlAslB0oXAAEEWDsIWorPvK3nJ6wXvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=gTBiEMNP; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="gTBiEMNP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1776925756; x=1777530556; i=quwenruo.btrfs@gmx.com;
	bh=XfD8u9+1mgFkxTMiY+i6b0uEqPR4Gp/4oGvqHuOlwtQ=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=gTBiEMNP5bsYW/eiKZ4fC/HohbpAxt5TZ4jxWVx5xq8Tw1VTwPJBATXsczhdpkjt
	 isbvALzywPNFLNBzc+jusyVGEIuSj0dunTQhY1/F7Oj/LJ2dvIZpOpw+fpO8hFJy7
	 pGip3RmkaqzShNBCdLKfWFegYv5ECOsS5PSG5NZdDw+iK4DtxHfB0XpMQy8BmdFvs
	 ou3LfZTZqNuQmIwf0A9qX8BLhJ0oj/eAYBuqjt5pEvVxdhypgDAwRu37KWzKWHfUs
	 xeQ6Ly+DUWW/JTSCvDKL67rRshovEmuorCrKsQ9Ut1pFJ0MW4MgIxHbAmk+4zeIxt
	 AX/tOk5rvA8dObgH0A==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MQvD5-1w41bI25kl-00RdM1; Thu, 23
 Apr 2026 08:29:16 +0200
Message-ID: <99c9e1c0-5b85-4f9f-89e1-65797758d36b@gmx.com>
Date: Thu, 23 Apr 2026 15:59:12 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] Potential atomicity bug in fs/btrfs/compression.c,
 between btrfs_put_workspace() and free_workspace_manager()
To: Ginger <ginger.jzllee@gmail.com>, clm@fb.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CAGp+u1YSz4vO_zOgY63Y7bw499Wtez++HuNLZVnjUGkwLihQTQ@mail.gmail.com>
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
In-Reply-To: <CAGp+u1YSz4vO_zOgY63Y7bw499Wtez++HuNLZVnjUGkwLihQTQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:K8ar6DkYbY4MdpT4DAoH7Nmfh2Z9+dHIZvjMbvhlzltNRNrFEDt
 5yWf0N01GX937Ztz1SEINX9/MTiy9DbNDZRnfJ+N0sc+CuzkMA0FsCWjoXtW0Qq9Xsh3Q68
 dXEj7QDE4EXliaJIWWKEasfRTsKCpE0KroiKH3GKnPNQ06qlbG7IVOC5eB75C898XeXzRSo
 SI/lUWDkKU+3qE3zJw3ig==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:H4KCqiI0HX4=;902xmqq8NthTkRWcfa9U/6axeKo
 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



=E5=9C=A8 2026/4/23 14:25, Ginger =E5=86=99=E9=81=93:
> Dear Linux kernel maintainers,
>=20
> My research-based static analyzer found a potential atomicity bug
> within the 'fs/btrfs' subsystem, more specifically, in
> 'fs/btrfs/compression.c'.

I guess your "research-based static analyzer" is some pretty bad LLM.

>=20
> Kernel version: long-term kernel v6.18.9
>=20
> Potential concurrent triggering executions:
> T0:
> btrfs_put_workspace
>       --> ws_lock =3D fs_info->compr_wsm[type]->ws_lock;
>       --> spin_lock(ws_lock)
>       --> list_add(ws, gwsm->idl_ws)
>       --> spin_unlock(ws_lock)
>=20
> T1:
> free_workspace_manager
>      --> gwsm =3D fs_info->compr_wsm[type];
>      -->  while(!list_empty(gwsm->idle_ws))

Go check when free_workspace_manager() is called.
At that time there should be no compression workload at all, because=20
that's when the super block of the fs is being removed.

>=20
> In T1, the accesses to the idle_ws are plain memory reads and writes,
> without holding the 'ws_lock' to protect against potential data races.
>=20
> Please kindly check at your convenience. Thank you for your time and
> consideration.

Please kindly switch to a better LLM.

>=20
> Best regards,
> Ginger
>=20

