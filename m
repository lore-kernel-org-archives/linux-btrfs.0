Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.17.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795166047;
	b=uRSCoNDUlPKLikPGWrJTdGR5P7zZdRJAAcBzj1eynHK6SnIeU7JQz+TrGyTHFfyYGXp3
	 yUnGA81MQs87VaLb0BVNFLF7cJV8PA85qYhnaRJWSjsujqN3GqADRMmQ+a6V5oRGvXoGP
	 MD0usx9HULRRhIyyMrVvGoBeCVXLV2xlW+A1n1AnDNS/DqnEyd9IqYyxO87DaeohwhvUe
	 oe3FlPs7aQJ35pW9TQ1yI1H0R77GfHvFwTLuQ9ljtldI6Z9ScQsiDhpsqlaFFr3FTt79X
	 cC2cc155kdCUShzJaIeK5ezxtP415ImCDJiohZPyrtZcSC3hXlMA5gQ/vylDKL7r5KQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795166047;
	h=DMARC-Filter:DKIM2-Signature:Message-Instance:DKIM-Signature:
	 X-UI-Sender-Class:Received:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:References:Content-Language:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:
	 UI-OutboundReport;
	bh=pxqIBpmpYdwd6fPFhJZP/eQ9g//qbHPnjQwu7WBAvow=;
	b=lPGiMlZiXTFAHEmpXkhtblAS3mtmCe8XPyvUIo9eBGZnpmJ3ZDJF0GkcQ775VSUR0kkQ
	 HfqXr/y1SXQ37oHnCLHuyPa/60lOkDnAp8or/1Jbwf4afP4zYBjVqlH1CFi1Lm8C+cKeS
	 p73+mUMaG9HOymLHLDH1Mn6JbZxDPBYj6U1JmXI1rNAlZxfuJ5hH9MEisT0BqUTTAN2Yl
	 XC/s7aQCzSIxR+7Jp+KK+1HHLtFy6a4viuBhIzGQqG+EQaZ5e6hQ41G4KdIdDfaiFNyqK
	 obnFUDYgD0H1d61a7Tu4wW+pM8pM+qswQQ8MNTTtEgIc7Mzb9+G1uQm82Os+08y/9fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=qED7T2bf;
	arc=none smtp.remote-ip=212.227.17.21
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1FCA606A320
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 09:14:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A1FCA606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=qED7T2bf
DKIM2-Signature:  i=1; m=1; t=1795166044;
 mf=PHF1d2VucnVvLmJ0cmZzQGdteC5jb20+;
 rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
 d=gmx.com;
 s=s31663417:rsa-sha256:aNtmhHKr6vsYh6Do0+xA5Dbtf6sZ
   Tl0M7VktzDhk867z3bBldRdsUr+CLvLQjftVFC7Ry8TYJAW+GyZa4PAGjtLbVdcaWSU+lIY2QLX
   nQJXSybzue7lpxI0EPAzCQ6+LhaFJ55bQutQznHh/YJZ4i1QxusKh48OFtBioEiWEhNfVnk6Tlr
   l7VpJuZaskQF2+STUkoThLjQlKx85PrlLczRYihp9YAFwF9mYfmA8wQ7S2StBdt+BbPj+zAYGLY
   rUdsURQRLpYvSe5y/GvYx3pgCtfoRD7RHL+IYUcZPspep8ziKAJ+RMJ9SH/J6GxX6cqgmJ2r1Mv
   g2qzLhYly1XAoQ==;
Message-Instance:  m=1;
 h=sha256:
   ClTrH0QdhCVGK5ALA7IlpMamNEOGuntZhYjPDVn8X8I=:
   pxqIBpmpYdwd6fPFhJZP/eQ9g//qbHPnjQwu7WBAvow=,
  sha512:
   apOiDgYoSTckFKhBeEzkJTe5B7fQhtW7HRHzH8970G67vm26lbN1Sj9tbIkxilRDCew0eQ4nk01eud0oJV5t2g==:
   aU5OpbWfWbo5RwFThfwb90ookuQlj+ENCCT/vZMDUIR+zrTuAWJGpJkTPOEFgAy895gpQ9pHAL/9dXFXyFnv6A==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1795166044; x=1795770844; i=quwenruo.btrfs@gmx.com;
	bh=pxqIBpmpYdwd6fPFhJZP/eQ9g//qbHPnjQwu7WBAvow=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=qED7T2bfYXF5PoZDKqs+/gbUtALDqN1CkxAvKOzFA5r6YVyoESlOt23CZhx3Lo+B
	 OWmYsyIM4VKXVD1w2JgtZezC79sVBI+3zbLOPlPB9OwOcwUWCCC1RgfKk9IcqZcB9
	 iqtCdMvPfMgMt4z5x57gjeISKe8T5ogZvMBOlPVGFwsYLPGGXj5UbvdK2wO6yuf7i
	 DTfdgvol9ISaj7dEuGGRXEAiKYjvnefh2jFVY7xJRlVpnv1bLrIFNMbxh0eTU1Rju
	 XRF8rYAsS6rnSQwFiUmIFTbaJWRRhqZxVGtf6jXKiILa7+GCieTu/ROZskhINsNqq
	 XmiRnZGl2scLSyOK2Q==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1N5VHG-1ybKFy0FVy-018EHu; Fri, 20
 Nov 2026 10:14:04 +0100
Message-ID: <735b0322-69d3-456a-b9dd-787a817ce036@gmx.com>
Date: Fri, 20 Nov 2026 19:44:00 +1030
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
Subject: Re: [PATCH] btrfs: add a per-subsystem agent file
To: Krzysztof Kozlowski <krzk@kernel.org>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org, workflows@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
References: <df1c1fa031ba7e66486348dc37d1a7be53c18e43.1794894953.git.wqu@suse.com>
 <63566373-86cc-4a55-8e09-741f283e6786@kernel.org>
 <eb62aa0a-b027-4fc7-8d84-05fc5329576c@suse.com>
 <fdb2526b-2fbf-46f7-b7ad-c4ec0385464e@kernel.org>
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
In-Reply-To: <fdb2526b-2fbf-46f7-b7ad-c4ec0385464e@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:17mpklyoJKX7mGbyyxr0lLrglZesTTlkp5fjT5xT5uezYw6RKTS
 myG+Pq9DU8BzExuJA0OV/k3533CTJyhCg0ldBy1u4whLqrh589X87NLpb7d1rpkOrUSE0s7
 HE4ZH+PU5KNf6czc/hCLHDfhM1um4yNQR/xXT/ngMUyu5eH99yCB7aYA6NdlvZ//Lbe/LPy
 /SEhB5J5gYyZ8J57h2TbQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:L8pN6rnOpgk=;lYGE/754wSnluLMbn8++9FgD2lo
 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
 R50=



=E5=9C=A8 2026/11/20 19:13, Krzysztof Kozlowski =E5=86=99=E9=81=93:
> On 19/11/2026 22:15, Qu Wenruo wrote:
>>
>>
>> =E5=9C=A8 2026/11/19 20:44, Krzysztof Kozlowski =E5=86=99=E9=81=93:
>>> On 17/11/2026 06:58, Qu Wenruo wrote:
>>>> I believe btrfs is not the most affected sub-system, but a lot of
>>>> newbies without common senses are doing more harm than help.
>>>> E.g. wasting a lot of human review time on very low value fixes, fill=
ed
>>>> with long paragraphs and useless test steps/results.
>>>>
>>>> So it would be better to let those agents to stop being stupid and
>>>> follow the more common practices here, and hopefully those newbies ca=
n
>>>> build some common sense.
>>>>
>>>> I hope the agent file is clear and short enough, that is not only
>>>> readable for LLMs, but also for humans who want to be long term
>>>> contributers.
>>>
>>> Then it should be a maintainer profile. We should write docs for human=
s,
>>> which can be used by agents. Not the other way around.
>>
>> In that case, what's the proper file that can also be applied to LLM?
>>
>=20
> I just wrote... why would the LLM skip the most important document for
> given subsystem - the maintainer profile? It wouldn't...

Ok, didn't even know we have such thing before.

Will move this to maintainer-btrfs.rst instead.

Thanks,
Qu
>=20
> Best regards,
> Krzysztof

