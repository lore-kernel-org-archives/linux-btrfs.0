Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95D7A49BB62
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Oct 2026 22:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792189135; cv=none; b=dh+EMhwSPgxpKd7oC8pJeh32plihFApGPz1K1bfFHjblY6dyY0AY/yScKUYFUoWEdcsQKwqHmOfyh1Y8zbb+pDKf3KWKQGV+8vWAC+VPosCqdk+8nH8lhkDb2KGJMvRMstXH2YQd6HlV0O4nq/0scJyh9z1Mo5jIWhmmjdZmrq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792189135; c=relaxed/simple;
	bh=FXuUFPCxs0GS5d/QJ1kUDJjIUFtbcyra0UbwS5Jz4nM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=IGWSEYzawAfbcMz3yQ+k9bqKGoHDbHvIJmmpnwChVdB90q87G5kL+3ASG+hrkmRxYKde+ecYJN3fkxOzSW0x0o2mRaM77QlASeYt4ZUNpBEFxvaZATt5y66IrWaAlEkSYCl1lQ/vUQ5lfAhYHVWrgikKE5dF4MmfQGdKu9U6cyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=irnai+lB; arc=none smtp.client-ip=212.227.15.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="irnai+lB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1792189127; x=1792793927; i=quwenruo.btrfs@gmx.com;
	bh=cmlAdRiNEwnnL22HBeat3fyXMzpNAG4+rbyHZpWOCxg=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=irnai+lB/ZgHx/oMgH0VZ/i+Aus67EHOT4Pad5L+hWcIIuoF5zRsqqIZlfE8SQtG
	 vRH7/6jNZggMVDSwI8KYrpSCU9Iu3jYvoux4yLmYLz6itVrTPVPYHzBJJAJvbNM/6
	 preYySMejPa8pZI2xTWYeyacRWluD2IgoquPglYiphjMhgOz6E5pO4X07FUuckJGR
	 7oOjL901Jo/GeiGMXt/CRYWQz9FcieRZzsW1MUoP6fonozMx0+vgVemZjOZcAfKXN
	 eYfDouQK6CoEIGf/DXUI3RQq/8g5UvdzfRfV4Pf+hNp0jXpSbtyQ27PDVS4Miao0Y
	 t5UFELCAdQk9yNlUNA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MKbkM-1x3clO0dJM-00SgOD; Sat, 17
 Oct 2026 00:18:46 +0200
Message-ID: <b3fad824-1538-40dd-8e3d-dcb06b993e8c@gmx.com>
Date: Sat, 17 Oct 2026 08:48:42 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] btrfs: fix a couple races between scrub and the
 scrub progress ioctl
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <cover.1792170434.git.fdmanana@suse.com>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCaqsNDQUJFJfy
 XgAKCRDCPZHzoSX+qPcICACxEFp2nh6g7JQyRkN855kqXeAYiWGZRWbCo+QQcGU0vjlm6s5K
 4CRT8U6RtY0Ou1Ss/MYrpf3z0joYh0hoWDgiVqhUXLG5jM2FeBY6bHl8WHKsMOiVpcB6yJqu
 Umqira0lLmg0V+9zHkijuH9cqxIYURsDNNkUueMy3ZBBxLq14w5JFcqOU7tdHxa2NZoO/pck
 qEZSL9lrsmRFe2dzFnxw4nOhikr9tkAqQN2wpW2OG8D1oLNARDx3hnhMYj9pKZ0ICZDtl6J3
 ACi9ZIWLNGqwb8ayizmyKmCGouN0gLAuwGFq2qRpXGCxe2lTYknUk71CvBcCzFgCX8qlobxF
 NCYXzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
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
In-Reply-To: <cover.1792170434.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:kj2z40RG6hYcWJlhXXKxUtR9krOJwZk84D0PoOXN/D+lVck7zdp
 MfTAZElrXq1IsUH9LbkgG0bNkU1iJc8TCfqeZS9q8nM7cSrfHqrjjf//xbp+GMOvPzwYoUp
 aT0dXHwT/mmnyQxNiWNHeMokF03+TnBLtZl2ST9IzmeAroLWL7+qeGwkGwE+ZjpEDdQRaem
 DFpBiI+4WYFzYU0CK0mxA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:NS4wppq2gZk=;UyDyR1xK1Bd6UMSsbcaRwVjxM1S
 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
 e/eDyImvNtcOYylTxdabtmEKZjBEA=



=E5=9C=A8 2026/10/17 03:39, fdmanana@kernel.org =E5=86=99=E9=81=93:
> From: Filipe Manana <fdmanana@suse.com>
>=20
> Details in the change logs.
>=20
> V2: Added a another patch to fix another race (patch 1/2).

Sorry that I reviewed the v1 version of the second patch.

Still the whole series looks good to me.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

>=20
> Filipe Manana (2):
>    btrfs: scrub: fix race leading to use-after-free in the scrub progres=
s ioctl
>    btrfs: scrub: fix race between scrub and scrub progress ioctl
>=20
>   fs/btrfs/scrub.c | 12 +++++++++---
>   1 file changed, 9 insertions(+), 3 deletions(-)
>=20

