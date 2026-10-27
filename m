Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.17.20
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793093404;
	b=Tle6+tIP+WgmDZh7hgKztVPt+8f81ru/R5sh/p9JlC3AvguJ1r+vrC6R7/BVTMNecmpV
	 2QyMhrgn+id8nme+Irf3iuWPQLIF6LGOlSyfxJAi/Szv2AeISIs/cZzL8LcibMURG6dxz
	 0L+z+NmI4j8qF9UTkeN6fbd9vDqvhuuiKGV2/4rR/ToMnNGcc7mzf3bJPK7Tf07y5JKlO
	 wIwQSds2RrZ37pQX5SZakwRGt2rymiSfPm0JVo38mbtqoStlykF9ax//+rwcZTjYJxAWs
	 agcul0gT+trt3Cb7ruZOlZQAsfpWp5jnmLAMuKLBzBhpZ0CprSQjWs6oz/WeWkgr7Vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793093404;
	h=DMARC-Filter:DKIM-Signature:X-UI-Sender-Class:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:UI-OutboundReport;
	bh=Sjqakbc7dnjlwOYb+uAk7x/dfsyRmPa2AYQlB077MqE=;
	b=Sr5JzPQpTJAJrVVWtntTXRgxBma7lm/4mqhK5xDLcKxBSLUNIniTKer7zPaujRC7Qzek
	 Aa7a1ertT+kw1p8GEsJoTQcJ4AWoG5FkY4lCR8DmNbruX9vkK1RWT/lk2Iv0BdRkiuH9F
	 N6Agk7HzLRe/tBSNODBEQyZEDOw8hNwHGjEI1d7CIaq+0e981XrELw35lkiZOHQk95w0M
	 ILdL6JwrxbVn58LimGjQe0Z5KM+Gux1e/5u9ckv/2wcPmgp+vHHRY7Hu+ZqgMApwcADSx
	 LHISVn7hGK4c5VjU64pidGd+Nvq+CzxNcWyahQsRBH7I1zKg1nhBEfHpPXDr97elfdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=G8kvmqQr;
	arc=none smtp.remote-ip=212.227.17.20
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EFA3606A31A
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 09:30:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3EFA3606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=G8kvmqQr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1793093401; x=1793698201; i=quwenruo.btrfs@gmx.com;
	bh=Sjqakbc7dnjlwOYb+uAk7x/dfsyRmPa2AYQlB077MqE=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=G8kvmqQrV1SIQVGQO1mc/xA/ga93c2EyrDFvNcrrVTjuZ62WFo0ynus1MVPZx0gi
	 qRQDMcXkQST+wV6SBw9VPpW00AXeFatgJChyil8NQqj6BaoKNhTu3ODY2c//1dZxT
	 VuxGuWJl/NcBRNR042OUf/Vgb1r3MWZv7Ih8YICRTWF68ijjxLeogTYUr6HvYYznP
	 H7CfQoT+zxIyKMYuWJIjDSqziSlLcv96KjWHcHCfU7qIZhsbh6HYQGyWuKc+351P9
	 qHuw3R98mT2PW5D9Uyv9Jf3Z0CsAA0wjAwLE/Gv5Q4wuEFDaK16caZfKFq8brRgoS
	 JgGVBDLlL6wBnLR98g==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MIdeX-1xIaZZ209N-00GVCN; Tue, 27
 Oct 2026 10:30:01 +0100
Message-ID: <9d996744-fdc1-470c-b24c-98628350ecf8@gmx.com>
Date: Tue, 27 Oct 2026 19:59:57 +1030
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] btrfs-progs: gitignore: add GNUmakefile
To: Daniel Vacek <neelx@suse.com>, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
References: <cover.1793090084.git.wqu@suse.com>
 <06c3ff42ede1381ad1fa5168b22dc1995abc78f6.1793090084.git.wqu@suse.com>
 <CAPjX3FfVnjtKBO1LDiYXZpqHybDsE2R6r-8a++S5Z1-VR5Btww@mail.gmail.com>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCat7o8gUJFKS8
 OQAKCRDCPZHzoSX+qAogB/9C5ErH7KGAGpcLPte3Wcfdt3acCkGAuMpCjqOt8BVw30mX0kmF
 SRo2nODjz8YsYhWR1T8L3ylANAS/IGIJ64idBmObaqGHQn845nXLIvG33LqMsAGXmOJdRgTT
 BnBA+QFCEIZpo7L9Qt1dOQdHSpHT31Ta1kKsbDm582KPVBl6KRcJJBnjudIerOA1/L/zEyDa
 YjIfHIcvuM3Xm8AS00iBpsmc151QgCPljqnSRXBiup9C1oMgVlaROhY1iDam4UIQB6glkHQs
 LZhUmFDNimX5LxfOzi2pFJSjJvPclRZVX7Sq6XhK/OFb6IvswN7i0nUYZMQfuGDNqGn70ic3
 AQImzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYCGwwWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCat7pCgUJFMw7KQAK
 CRDCPZHzoSX+qEjbB/9crFFjips2NKxkt2XUutUIKjBoUlg/xCeFIj8PsTuJePhrV9HzgKsa
 rJgSqo3t78oQWmeaP9WPoDYjfhOkQXEs+G9UwHe/LENm70+Q1jrwY3nlcR3YrkDCJ+EvMZOW
 ackgcOYn46Iri9DN91FbSTszPMnwHi/nf0aeJXicO9krrY5C8mUxv4CSKeKSRg/5BR59uDiy
 9CMRHDtIDnpDWaLOXtUeowCdiC5O/jA571PMFx3Aolc7g4SSyNbYodblCBOdJrh0CVm2LlQW
 3SXrvFpSAw7LMVDgsS8pTRt4A11eTIS7mz0zqafTohXP1wt+575IBHK5ZpThQb+PzSQmxAqa
In-Reply-To: <CAPjX3FfVnjtKBO1LDiYXZpqHybDsE2R6r-8a++S5Z1-VR5Btww@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:bzVzonStJF7sf2rYYjaFYxAHQbiKKHCLTgAeVF7QzICfOuL59H5
 r0HZ6k0ZUGxtaNZvkbC2UttTVKgUbp9bByVEcvPOvR25UTabg3L9MWXkKCdLphHwPx+Dwif
 JrqS80W/KRPqyuKGeRv0H9VWSsLBYYEMmojVvpD0b90sxOsbZMnomFVCgjaOFRLuAdostZ1
 3qdFrU3dYXYtAVLrdatcQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:YIMyXUanOBo=;4nff+f8flzi4RNG0VgouSQs7yg5
 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
 =



=E5=9C=A8 2026/10/27 19:46, Daniel Vacek =E5=86=99=E9=81=93:
> On Tue, 27 Oct 2026 at 09:36, Qu Wenruo <wqu@suse.com> wrote:
>> I use GNUmakefile to add extra compiling flags without modifying the
>> existing Makefile:
>>
>>   MAKEFLAGS +=3D -j12
>>   include Makefile
>>
>> So the GNUmakefile is more or less reflecting personal tastes, better t=
o
>> add it to gitignore.
>=20
> So better to add it to gitignore I guess ;-)

Facepalm, I didn't notice what's going wrong until two lines later...
>=20
> --nX
>=20
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>   GNUmakefile | 2 ++
>>   1 file changed, 2 insertions(+)
>>   create mode 100644 GNUmakefile
>>
>> diff --git a/GNUmakefile b/GNUmakefile
>> new file mode 100644
>> index 000000000000..e0eaca65651c
>> --- /dev/null
>> +++ b/GNUmakefile
>> @@ -0,0 +1,2 @@
>> +MAKEFLAGS +=3D -j12
>> +include Makefile
>> --
>> 2.56.0
>>
>>
>=20

