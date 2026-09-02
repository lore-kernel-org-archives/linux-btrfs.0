Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B50FE365A00;
	Wed,  2 Sep 2026 05:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788326137; cv=none; b=uwxncNt0jQAdq2QBvVUXdK+HX6IjEhFH135SV0ZmsCqc2Kj5bjr0ukkSpQPobae9FiP4Lgo02neazh0N2kVT2UhZjAOcb3k4wH9M5rKr2+N3N41TU90nv+xSsdKi/pQWqAjAOksiWD1dLoVl/IKjlK6wzwpghPT062tJZEGb0Tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788326137; c=relaxed/simple;
	bh=vdp1PJkE27GJI0XJ6TWAqD0xx0J/xa8s3fbePAQM0qY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lf+ucq85Z2J9fL81dZjKXtE1fAmeRuxWJEq7BFU6v4WFR/Jaqrr9Mrtm4PG2bHcuKs+iFhwnpEK2mvUcMxCxSrTJMlp0S2zhBOi7rX9yhUFH5E9nV2D4SjlbXZmRButF1cUeEr0fuBtBYmFbHRWVIgv7QW99JYOZqBRUfg/cpxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=FvXlacvM; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="FvXlacvM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1788326133; x=1788930933; i=quwenruo.btrfs@gmx.com;
	bh=wYtd5r6CEHzFVC8sAcNV/7Ahw4VGwjSwF9DVbruNiXY=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=FvXlacvMQnjIgredzyTdJJbFNblZ0VqF0mOgygGN0Hm/8Zn3RstEx1cmgN3PN6BV
	 gk3nhFVVhoIG8qlFH27ROA9SuPBGp1DXfgYbYSLY0a6p5eqX7NWq/ig4Om6rLyjgp
	 ngUJPWpoe1fqy3KAcA3ByqhAD2we/rg0U7ScGbCWbgyg5bLSXE898rQjjiQjuYLeF
	 mPyKsGx7+bIpF5KUo0t230B+8tX+uCcE1kZmESnBDPznW3Cc2We0uCvzxz4S37mMX
	 ItxqGWQB/raNKRcHpWSCfKDP7+1nObdPnlBEHYfp5gAzvy2RNvLSGxXK8IwnUS1xK
	 dkyn/SqNPsvYup1UTg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MJE27-1xKgfu1895-00WOkz; Wed, 02
 Sep 2026 07:15:33 +0200
Message-ID: <5115a152-295f-4744-8080-e0d2ecdeb360@gmx.com>
Date: Wed, 2 Sep 2026 14:45:29 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs/333: require scratch before checking encoded
 reads
To: Prabhakar Pujeri <prabhakar.pujeri@dell.com>, fstests@vger.kernel.org
Cc: Zorro Lang <zlang@kernel.org>, Anand Jain <asj@kernel.org>,
 Filipe Manana <fdmanana@suse.com>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org
References: <20260902033310.1698-1-prabhakar.pujeri@dell.com>
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
In-Reply-To: <20260902033310.1698-1-prabhakar.pujeri@dell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:wj3ZmQFAHcPid/yMlVUAg4xTav4+881ZM2WAf656aQXypAx/kxL
 rxrzXvW6xgzWz8Rh2bmI7DwQ83C2uulPW+LwtqoXrDqdikh1My8DTh4DmD+aq2MOnnCAr4j
 wpO2JNfSqgnZfWOY4xtsS6q7xH1KqkXFiPwIIKgoLRQPVyjsKkvT3yO+JAjesPVkLZ9r033
 CxfXK09+q+4NsNr4SoN/g==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:uvMIDmm9ufA=;MvGCOwW00bKWKcfWq5eimaaqw0a
 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
 G1admy7EY/drXPcPyaKc=



=E5=9C=A8 2026/9/2 13:03, Prabhakar Pujeri =E5=86=99=E9=81=93:
> _require_btrfs_iouring_encoded_read() formats and mounts the scratch
> device while checking for encoded-read support.  Without a configured
> scratch device, callers therefore fail inside the helper before any
> scratch requirement is checked.
>=20
> Add _require_scratch at the top of the helper so that all of its
> callers skip cleanly when no scratch device is present.
>=20
> Changes in v2:
> - Move _require_scratch into _require_btrfs_iouring_encoded_read() so
>    the requirement is enforced for all callers of the helper, per Qu
>    Wenruo's suggestion.  Revert the v1 caller-side change in btrfs/333.
> - Cc Qu Wenruo.
>=20
> v1: https://lore.kernel.org/fstests/20260831104200.2269-1-prabhakar.puje=
ri@dell.com/

Change log should be put after the "---" line.

Otherwise looks good to me.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu
>=20
> Signed-off-by: Prabhakar Pujeri <prabhakar.pujeri@dell.com>
> ---
>   common/btrfs | 1 +
>   1 file changed, 1 insertion(+)
>=20
> diff --git a/common/btrfs b/common/btrfs
> index a75fbf1..ccac862 100644
> --- a/common/btrfs
> +++ b/common/btrfs
> @@ -1055,6 +1055,7 @@ _require_btrfs_iouring_encoded_read()
>   	local tmpfile
>   	local ret
>  =20
> +	_require_scratch
>   	_require_command src/btrfs_encoded_read
>  =20
>   	_scratch_mkfs &> /dev/null

