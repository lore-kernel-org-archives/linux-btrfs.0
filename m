Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15686383C84
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2026 21:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790805308; cv=none; b=TphN0MOJaeGdvdQ99y89KB8NnLom+WU+xZYvifLM4949ck0f7gMhqG6Fiuxe8/prhq6yFJ9uBJNuBw8D3eoe/xTIgn5/IucLh/X52+mc71WwbGiMtoUwzfVbUcMgxi8mjbU5SldC+ioPKAylyZl8j66fy+LxT8srrg2eAcen+6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790805308; c=relaxed/simple;
	bh=NB0ffnw3BmmmmdzsdvPkHInvqLZvNiZ3ajW+lVL7V74=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Nu9YhcF8HRcwBk0pNcbgeDnkQIoG0ZcCt62z/pprrYew/zJ4p3TTFBUoUJDq+AHBsL16WOfTHXa/ZhPws2WqQf9TsNq9Ba6DCjT0GgjZQDvPJf6/Z/dNaJ8InSQiMqa8L+LgNtaWqEAyo0G+601gooRVJesE07xqsuLaIPaJlgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=NBYogKFw; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="NBYogKFw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1790805300; x=1791410100; i=quwenruo.btrfs@gmx.com;
	bh=fPNIHYiTv1tqVN3do4teAl7fkx6/dgro+HOSDZ3+YvY=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=NBYogKFwSaDeZm0R816RpoPxJjXcV7JNyTYafkKKYuHvdV6Y2qo1Cq10CA10VDwX
	 66THKMtmi8StwvfBuDUeEo1cI5NSnZ6oxzz3Vn7BJxcyqXzMWn/5Qkf5Kh8nEJDO5
	 EkLux7l6YCnEwQykCgSuSSKJoY+023kNC4LHzPX8SdMzO481OwZI7aR20nau4yDeq
	 AiYgUkZK+nMHeE9e7upGjiXSzU0oUDJs3MYJfhWNeNts2BFcEYd6aw1J6HTDRR8Oy
	 oYCITeC9A6IQdxiexysAQdfO/yivpaePaTr8ebZKfHTl4kxHyvcWsyHKdmiVhJjTC
	 gx/pAj6U1B79Faz00Q==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MeU4y-1wbb3H1jim-00lhE2; Wed, 30
 Sep 2026 23:55:00 +0200
Message-ID: <9b41ae47-11ad-4f80-af96-4d26de5caa71@gmx.com>
Date: Thu, 1 Oct 2026 07:24:56 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/5] btrfs: fixes and cleanups around messages.c
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <cover.1790772326.git.fdmanana@suse.com>
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
In-Reply-To: <cover.1790772326.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:A3AamS+PiSBg+NcP1imexw6JyQbD1YZPqEAQfNWbu8H++pyJSew
 LlkcVzagKBv7NEN9iLui/PiTnACzCU+54O916248wD0UYEX+BQVP4fBNkIfoLZqiGEQHrfN
 58vEBvaURHuAriL29fhTLjBFMBjmbSMF2zctH5O7VDQvtDT5XiZ6e26m2h8Nm61hX8N4Vrb
 eGrrTv6nBMv2/kfMS50IQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:3Jxc2Ayrr0E=;CAn33qePl7GkMgla/CRjs2QIE3d
 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



=E5=9C=A8 2026/9/30 23:55, fdmanana@kernel.org =E5=86=99=E9=81=93:
> From: Filipe Manana <fdmanana@suse.com>
>=20
> Fix a couple bugs when building the fs state string for printing in
> messages and a few related cleanups in this area.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

>=20
> Filipe Manana (5):
>    btrfs: fix incomplete iteration over fs state when logging messages
>    btrfs: fix duplicated code in fs state string in logged messages
>    btrfs: add missing code for no delayed iput fs state in log messages
>    btrfs: remove unncessary pointer increment in btrfs_state_to_string()
>    btrfs: avoid overhead when logging messages if fs state is clean
>=20
>   fs/btrfs/messages.c | 28 +++++++++++++++-------------
>   1 file changed, 15 insertions(+), 13 deletions(-)
>=20

