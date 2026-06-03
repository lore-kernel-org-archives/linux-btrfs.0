Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E6FE3CC320
	for <linux-btrfs@vger.kernel.org>; Wed,  3 Jun 2026 11:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780486416; cv=none; b=JYon0jwNYf8w/7z/vQJ6qMf1TCcidjKbk9iQj4Se+BYT1gcRVP8iffSk/iYZLxV0xevNa7EnOWpfLS6jX7WRcRArF4LgmtBxfdOlmYOM+llm95SrAEchsDVQTqsGMSLSncUy4INPO/aDcakYqTKLEiql3LGbfEF7dHjYWquwGIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780486416; c=relaxed/simple;
	bh=1w0cT3BN4kw594xCDLoNxNMvC2Tzn1zpoGu3B/HI7FY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hpHVkyt86DEOQ7Zgez+zCnfQk/M70Xu75JCk2aUDUNePEyfV5VMU66vfmx8VEvKseriCXYVbvp7pHDx9e6auutO16xYLqJQ5P2gkHz4KPdyOM9/sTVMZOC94/QMQ1M6WBilk6GUbLW/d/NpnNqQdgfXmQcKrZzQ+fp1ERjToZCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=WATkWq+l; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="WATkWq+l"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1780486412; x=1781091212; i=quwenruo.btrfs@gmx.com;
	bh=qAaqNASC3a/RiFfhbFq560zI7BQ9wrVnd6t/xQif+vw=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=WATkWq+lcmbF5k94cvQyNwakPv6109xd8g/+iGQ6qIOPSUy1jB3GJwJdFqucicRa
	 TMeZxEWP7gamXyXlSSIL2WMeaAs7RkDfVsnEE9aKCmOYJHG/iGrPcnwW1zvOAvVJy
	 LICigTNrvaG3ktCLc5cH0HqATVqIdSlLM41K2mbZibwzFIyne9LbZhbfrHQ0SK4Nc
	 JH8tIHo6POxun2uOmgxXJLchovNKYp+Ws7FDHCTAso4i9tO91X9AvohoJ9AX4w+L6
	 6IB6i7CYjFU03tohVOdhNXR4M0ReQGor2V0iLTsSAXJjtRzAnc8KkNUVI4d7auSBI
	 6R3e/vzIPHK7GW0U1Q==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MVvL5-1wf1HK2Wzl-00Y5IO; Wed, 03
 Jun 2026 13:33:32 +0200
Message-ID: <ad4ceb68-99e5-432a-8589-de5e917b47d6@gmx.com>
Date: Wed, 3 Jun 2026 21:03:28 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] btrfs: do not enforce qgroup limits when changing
 qgroup limits
To: Dongjiang Zhu <zhudongjiang@fnnas.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com, fdmanana@suse.com
References: <20260603111857.230985-1-zhudongjiang@fnnas.com>
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
In-Reply-To: <20260603111857.230985-1-zhudongjiang@fnnas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:OesqS0C8qrYCOfu+uuIuDnaTz4vQ+CiLLhKvCuRgeDsIgrNUmNF
 HKoEmtsBzR6n183ND2bhUaegiMzZWHRwTGsIqR67sdhQ0dpOrBT7FUcs75mVW38hcFvtCcA
 TkuHjUE41psp/sExUahU/Wj/AM/kWy9y/OvHLxXCXovevLQPjvuosV4nQ/QPaso04ghj8OA
 L6xpmCN0Ndx+U70H/3dLA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:n0KBS4TCM+U=;KBcoUrasAYaa/DDzwWyz1R4ZWHR
 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



=E5=9C=A8 2026/6/3 20:48, Dongjiang Zhu =E5=86=99=E9=81=93:
> Since qgroup ioctls started reserving transaction space, qgroup limit
> changes can fail before reaching btrfs_limit_qgroup().
>=20
> For example, if a subvolume qgroup has reached its max referenced limit,
> issuing BTRFS_IOC_QGROUP_LIMIT on a path inside that subvolume makes
> btrfs_start_transaction(root, 1) reserve qgroup metadata against that
> same qgroup. The reservation can fail with -EDQUOT, so the administrator
> cannot increase or disable the limit that caused the failure.
>=20
> This is also path dependent. The same operation may succeed when the
> ioctl is issued on another path from the same filesystem whose root
> qgroup is not limited, while it fails on the target subvolume path.
>=20
> Keep reserving transaction space for the QGROUP_LIMIT item, but do not
> enforce qgroup limits for that transaction reservation. This preserves
> the metadata and delayed ref reservation semantics added for qgroup
> ioctls, while avoiding a qgroup limit self-deadlock for limit changes.
>=20
> Currently this can be worked around by enabling quota_override or by
> issuing the ioctl on another path from the same filesystem whose root
> qgroup is not limited. However, changing a qgroup limit should not depen=
d
> on either of those.
>=20
> This only changes BTRFS_IOC_QGROUP_LIMIT. A follow-up question is whethe=
r
> the same helper should also be used for other qgroup management ioctls,
> such as qgroup destroy or relation removal, when they are part of
> recovering from an over-limit state.
>=20
> Signed-off-by: Dongjiang Zhu <zhudongjiang@fnnas.com>
> ---
>   fs/btrfs/ioctl.c       | 10 ++++++++--
>   fs/btrfs/transaction.c |  8 ++++++++
>   fs/btrfs/transaction.h |  3 +++
>   3 files changed, 19 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 9d47d16394fc..1e410db06c19 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -3758,8 +3758,14 @@ static long btrfs_ioctl_qgroup_limit(struct file =
*file, void __user *arg)
>   		goto drop_write;
>   	}
>  =20
> -	/* 1 BTRFS_QGROUP_LIMIT_KEY item. */
> -	trans =3D btrfs_start_transaction(root, 1);
> +	/*
> +	 * 1 BTRFS_QGROUP_LIMIT_KEY item.
> +	 *
> +	 * Do not enforce the current qgroup limit while changing that limit,
> +	 * otherwise a qgroup that already reached its limit cannot have the
> +	 * limit increased or disabled.
> +	 */
> +	trans =3D btrfs_start_transaction_no_qgroup_enforce(root, 1);

Nope, you should not work on the subvolume root.

The transaction is working on qgroup tree, so it's just simply passing=20
the wrong root.

