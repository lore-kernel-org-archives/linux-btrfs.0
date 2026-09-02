Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E9DA3E3141;
	Wed,  2 Sep 2026 07:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788334370; cv=none; b=JARkOKvJgtkIBOH9kS81nOaowW4rEQyrB+JMzzou6+2lnYp1bqRPcUKL2lwvS8IqfIeodO/T+ZhQpy4AGVoFBC9iu6AtiCqmXCJqbsilT8kfzLkI1tolrAToNQS3YzmDL4Nh0VkWb/0F57zIK06V/gDvAuMEQAF2dyzb17U7m1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788334370; c=relaxed/simple;
	bh=nXaD95ZBktRaZMPHgbvYXSzXOBl7EbDiNu1CQbJsTIk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=miE4+KeOV5AWqyKylU6Nc0k5aLxDPgQC7wOEef61VKLkfgd6T90bNCuPLfNQnjs0FXm9XiND4CnSuAhoTXwCkjxNAengbfoD+lOwHJMPwwOFwFDd6oMHcahHcZIB0pifrqxELpZWBnSfEqfEusCqjSkIej5JyJaHunCUzhw+6NE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=JDPeJaFt; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="JDPeJaFt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1788334359; x=1788939159; i=quwenruo.btrfs@gmx.com;
	bh=FHLUZrBV3OTszg2GeIHGjiXYbK1WR4ZuTlcruTne7Ps=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=JDPeJaFtrSm2RR1vhu9YL2uuptKpMxJSVevcmJ6as7o4I0/14rEGf31OLh1ayQc5
	 7dsQjF2mL382BDfgjywEsTs8GhHSo7V73Oi687LGRcEPRmIzrol0LpZ8fDcyTpDns
	 ZNwPHJFUQvgmneCfg2eTLbHXWd31lFyxEH8MXY8GWuKc/M0vFbDE93gbqNUyTqDEa
	 LdhpbN1bmzG+oavAIuZak5XRTa6G5TiP4E28iVJnS+IAhurm5demxmrLQ3wVHyWPT
	 xQTVnhuSywn9yhUyGA0ExwophbS84K4jupdZH93DCSh8SMRBD/wQ9C2QNHEReJzfN
	 fAOrIZ0J96oP5OXBkQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MUosT-1xRkvv1SnR-00JxBQ; Wed, 02
 Sep 2026 09:32:38 +0200
Message-ID: <0dd0ff45-5215-4440-8173-3d568665c924@gmx.com>
Date: Wed, 2 Sep 2026 17:02:34 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs/273: add missing _require_scratch check
To: Prabhakar Pujeri <prabhakar.pujeri@dell.com>, fstests@vger.kernel.org
Cc: Zorro Lang <zlang@kernel.org>, Anand Jain <asj@kernel.org>,
 Filipe Manana <fdmanana@suse.com>, linux-btrfs@vger.kernel.org
References: <20260902050145.2439-1-prabhakar.pujeri@dell.com>
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
In-Reply-To: <20260902050145.2439-1-prabhakar.pujeri@dell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:uX/aiAs2Kbc9TiihzKrdOmXjz1mKlrhPEcBZcZ8/q5RLyHPC54h
 PxrmrfgqXJcnFXXDNF0cfDOYoB+0IUlrDv+5AKTc91jGoFAtuTA7k+CVl6dyZeId5T0DwFJ
 Gl6QjG0kkO/Lo034T0WeIoDQ0ndeKXw7UakXvaUVzqeIGCSiV3BKK+Ko3fyOdCmjXaj5E/E
 5gCU8sKmuPwk++NT9PjuA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:/Bbhu/NF8+U=;OVfZEaZigLIXuiiHhnq2mBsDgS7
 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
 =



=E5=9C=A8 2026/9/2 14:31, Prabhakar Pujeri =E5=86=99=E9=81=93:
> The test passes $SCRATCH_DEV to _require_zoned_device() and mkfs/mount w=
ithout first requiring a scratch device, so it fails messily instead of sk=
ipping when no scratch device is configured.

Too long line, IIRC the regular commit message should not exceed 74 chars.

>=20
> Signed-off-by: Prabhakar Pujeri <prabhakar.pujeri@dell.com>

Otherwise looks good to me.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   tests/btrfs/273 | 1 +
>   1 file changed, 1 insertion(+)
>=20
> diff --git a/tests/btrfs/273 b/tests/btrfs/273
> index 60c3967b..197cfb02 100755
> --- a/tests/btrfs/273
> +++ b/tests/btrfs/273
> @@ -28,6 +28,7 @@ _fixed_by_kernel_commit 2ce543f47843 \
>   # which is further fixed by
>   _fixed_by_kernel_commit d5b81ced74af \
>   	"btrfs: zoned: fix API misuse of zone finish waiting"
> +_require_scratch
>   _require_zoned_device "$SCRATCH_DEV"
>   _require_limited_active_zones "$SCRATCH_DEV"
>  =20

