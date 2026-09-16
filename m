Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A04591E5B9F;
	Wed, 16 Sep 2026 05:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789536879; cv=none; b=QhumWxq5xhqwzY3UWZNm2+JXiu5cLwKxdm0pUuCaJlUWQtls8rslH7TmFOXhlhCq9CXeOrr2R0CD4ce7GQjnulFMlktSs1ckVK7yvXnvnZ6KfC7yjVGKoANUPVJkx4oDqbbpwNeO8Gbi6ED72Swf4u572jPN+FZh2UPig5XMeM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789536879; c=relaxed/simple;
	bh=ywGJwFpymQgpT0i7UGxrU38bWoZCOZ+5keDYJC5llxM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iSTZA2gJIPVPVfoPlGirWs69j0+Oe/Ti05Ntky+UG1u5yqkeSHEyHaF7knvsSwHgQAdMw357dPSVoSCkObqLiZrk5bkPYQ4Byh6wcjw7Nxu1FWr9lxvoP7lBv5h6Kby1X3rrsGdI6+K2znnRr/t/GA/sTKfuUrM5OZ2+ykaB0Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=aGreZOFp; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="aGreZOFp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1789536875; x=1790141675; i=quwenruo.btrfs@gmx.com;
	bh=IsTWDAREN9/wW7tpqAf9Mgr7sL54xETfrdVIyrn36j8=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=aGreZOFpaNEylMYRtkcYOoxI+9feQ65h8NXzQIiqhEablIyJp7YZ+HJKaMYSkPlm
	 2FX0xSVP9BrpWn/v+e/YfzrGrlGieawi0yoPEXLOaXkH/MVR2YMqQOUZ0VG6DSMZV
	 g4+SRoRE1ed7WhNL4Dn4aGzhHEHKr9gkM7VyqSAeY+rbPHoiyd4jo0qwxslJgSdoM
	 vjprBVcQ4BphLjPua7UDJLQlLfVX09voU3sHLn1v9JhrJoQlBluJVGUnVUatNEPnq
	 HOQPEFiO+rTTGapKPsff780oWW3pRixLD+CQf9FcYHVALVfC8r8499wphczRWMZMU
	 NP2+UHtN8djYUm1eUg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MJmGZ-1xMRr13ii9-00HtFg; Wed, 16
 Sep 2026 07:34:35 +0200
Message-ID: <b33b2a2c-dd03-4741-9f3e-1e124bd7ecef@gmx.com>
Date: Wed, 16 Sep 2026 15:04:31 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] btrfs: test qgroup limit handling on fsverity
 rollback
To: Daniel Linjama <daniel@dev.linjama.com>, Qu Wenruo <wqu@suse.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
References: <20260915053815.307674-1-daniel@dev.linjama.com>
 <afd05402-fdc9-47bf-87a0-df37a513b853@suse.com>
 <20260916051240.585268-1-daniel@dev.linjama.com>
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
In-Reply-To: <20260916051240.585268-1-daniel@dev.linjama.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:qskra+FiceXV8HhKBS8+etb5PaXyjd8nnlJtBCzIC4MdoSfxAQ3
 aI6VvlfV8V3ytJXBwUy9obkVYDtM7vLRGurt0bbJxgszPDo91yUhX5keXWeakDcD/p70h+g
 3uBW5z+bQDF3ErRhgiomHppK5OCZQCRDeS84N1AkZpKSZHMDhSe+gcTL+nCb8z8SqWiXh1d
 cJjNeoxUq0yLj56m2EJFA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:M8Qe/ALBemI=;Zc9x18pSwdjRS+TP/9dzQbQFNlO
 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



=E5=9C=A8 2026/9/16 14:42, Daniel Linjama =E5=86=99=E9=81=93:
> On 2026/9/15 15:20, Qu Wenruo wrote:
>>> +_require_btrfs_command quota
>>
>> _require_btrfs_command quota rescan -w
>=20
> Will do in v2.

The better solution is _require_qgroup_rescan(), which has the extra=20
checks for -W and -w options built-in.

>=20
>>> +    _qgroup_rescan $SCRATCH_MNT >> $seqres.full 2>&1
>>
>> Use "-w" option, or the rescan may not finish in time before the worklo=
ad.
>=20
> _qgroup_rescan already runs "btrfs quota rescan -w", so the test waits
> for the rescan. I'll keep the helper.
>=20
>>> +    while dd if=3D/dev/zero of=3D$subv/filler.$i bs=3D1M count=3D4 st=
atus=3Dnone 2>/dev/null; do
>> [...]
>> You can just do a 40MiB write (which should fail halfway), sync, retry
>> the write until the write failed to write any bytes.
>=20
> Will do in v2, with xfs_io instead of dd as the other tests do. A single
> write turned out to be enough: after it fails with -EDQUOT and a sync,
> nothing more fits, so there is no retry loop.
>=20
> Thanks,
> Daniel

