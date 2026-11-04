Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.17.22
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793779418;
	b=f4BhYNpZm51DdB7hp03QE+3woc0XLWjLhAffZsT1GQj+zKxjGbSXkh1qP7kIqWl9f5su
	 HZWH1kPdzM+ATy3tw+Twk4jPXS6SIP0KWF34RD6Ik5aZh93z1Dp9qhMYiT3OpRtCh3QAr
	 AinfSlTo+6/oMLIqF2unj5ErZhoVXSc17aPOn5q6rUb77Gvt/Kmp5hiVPAbPPzWF5MJRf
	 Hv83rFjYfnJ2TMi2wj0VbaGwitvuSYc2n/7tOLwVtfx9FNaTx4kxx4o1WbKdtpjXQjJwo
	 mEApF9YOBKh4OO/AI/QMYTLMyrvs6O4a7bYdL2Rxyxx0Nas8DiWEBACJEZZRQDRS3FQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793779418;
	h=DMARC-Filter:DKIM-Signature:X-UI-Sender-Class:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:UI-OutboundReport;
	bh=ieFm1N3CneVNEjsIa2Zi6LALIAbXP0vZQRAXS+POXQo=;
	b=V9Lks30L7qEEgD0X9mjQFMyWkkguc5EFWiEZ3bPkg7rLMoZ+nV2T2Tp8wwPBC+YICy8N
	 b6iQLIQdFOrrDEPn0PQo4/o4OM4q9H+x8K0434pZvsn1cs8SZ+SyfBVW4vrZ4bFKkpW7s
	 +t1kBK7HvL8mzDZA63GEYZmod1dcuH/4Kjr+8AvXrpfJkV4s7Zt1lLwBT+rQJNTTs1z7U
	 LQSyODlQRa0ZPpCdAnIP0f76opMtXw073MmqSiBxmscj9Cqq7t/UViff4LOEQr+5i5kyH
	 Sc29uHADmXo9aoHQJ0bowavH0MsacRvsY9jPBzNSAuVGjiB6NSNAiPF96EJPzuF66Fg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=irRsED3D;
	arc=none smtp.remote-ip=212.227.17.22
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E5FE606A326
	for <linux-btrfs@vger.kernel.org>; Wed,  4 Nov 2026 08:03:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9E5FE606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=irRsED3D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1793779412; x=1794384212; i=quwenruo.btrfs@gmx.com;
	bh=ieFm1N3CneVNEjsIa2Zi6LALIAbXP0vZQRAXS+POXQo=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=irRsED3DV4Z960AwM7i3OZu4znFCO4wGqBmfZu9/fOraIvne9CQeFFZsBTUFWUQN
	 S7qjGY4RAvvpBHKNB8x+4h7Mw7E+pBq+LqSG15HwFXKRBXun5yQSeoKg1SrEV12UW
	 5Y+GSqFodej9MkoR2VI4LqSy7SQCW7h4KmSfyWxxa0+WYqlfEbMcjF2nx2+8xEFAm
	 4hPJ3XklzV27Eky0Wc1PpcMXVM4O3oIZXfaRihHVsUwmqfeXxEyA82W465UKPbWii
	 cCY8PVVf8VALtCLfrcGeIgQ9SuKiuaaFggFstbUIT4JE3jZ/OPpUlSD8mLRjRa1M5
	 wp/+J/NxirQMEdhTVg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MhD2Y-1wt2lF2ZXO-00d0sj; Wed, 04
 Nov 2026 09:03:32 +0100
Message-ID: <ae7552e1-14ee-42be-90fe-b8bdddad1fc1@gmx.com>
Date: Wed, 4 Nov 2026 18:33:26 +1030
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
Subject: Re: bitflip in extent tree questions
To: Daniel Vacek <neelx@suse.com>, Qu Wenruo <wqu@suse.com>
Cc: Chris Murphy <lists@colorremedies.com>,
 Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <fa0ffb25-3c1d-46ce-8cc6-bdc1e2d86c2c@app.fastmail.com>
 <5843fbc8-95e6-4703-92db-5cd1df13ae9d@suse.com>
 <CAPjX3FesndAq7zHfkz8O3_tTkh_ttx_g1SOhhKa9sZ4gOsXZ8Q@mail.gmail.com>
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
In-Reply-To: <CAPjX3FesndAq7zHfkz8O3_tTkh_ttx_g1SOhhKa9sZ4gOsXZ8Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:sPAOg2cyBWRrTC+Z/1FcGe19CPnM/bgZOs9Wh9WsLl1V5dCMyBw
 O1BcttObfF8OKn4wT+TDjziKiXx7qdRBcs+NsaLza+Xy5wA4YVJA1Zqur3XVt+kpoVgC0Hr
 v6yYXb2N9QIP/yPhW3eCiqpUZT8maD4FoI50DIv7JnDa3r7s4/Vhy98TObjBCqMpyuz+1+C
 OsBfqp8EFrNFxT6tEpfMg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:P6IUdkfzHQY=;T0WOlABtX7DrQwqodNvUHgazESr
 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
 ehBqzQ+uI2qs=



=E5=9C=A8 2026/11/4 18:21, Daniel Vacek =E5=86=99=E9=81=93:
> On Tue, 3 Nov 2026 at 21:42, Qu Wenruo <wqu@suse.com> wrote:
>>
>>
>> =E5=9C=A8 2026/11/4 03:38, Chris Murphy =E5=86=99=E9=81=93:
>>> User reports transient Btrfs corruption.
>> [...]
>>>
>>> The questions:
>>>
>>> 1. In 3/8 checking extents, do the 1st and 3rd lines tell us that the =
metadata profile is DUP?
>>
>> Nope, it's just how the extent item cross-check works.
>>   From the backref item in the extent tree, and from the file extent in
>> the fs tree.
>>
>>> 2. Why does the kernel not report a checksum mismatch? What does this =
tell us about the nature of the bitflip?
>>
>> Bitflip happened in the RAM hardware. Btrfs calculate the csum when
>> committing, so it has no way to know if the RAM is reliable or not.
>>
>>> 3. Is this almost certainly logic board memory induced or is it possib=
le it's a drive cache induced? Seems the lack of a checksum error tells us=
 the checksum was computed after the bitflip? Therefore not drive DRAM?
>>
>> I believe it's the system DRAM.
>=20
> I've also seen system crashes where a bitflip happened in CPU
> registers. DRAM may still be reliable but CPU failing.

That's damn cool!

And that also explains a few cases where obvious bitflip is observed but=
=20
memtest returned clean.

BTW, how did you debug such situation? Regular core dump?

Thanks,
Qu

>=20
> --nX
>=20
>> A memtest is always recommended for DDR4.
>> DDR5 has some extra checks, although not as good as full ECC, it should
>> still reduce the chance.
>>
>>   > 4. Is it safe to run --repair?
>>
>> Yes. I believe so.
>>
>>>
>>> What else?
>>>
>>> Thanks!
>>>
>>> --
>>> Chris Murphy
>>
>>
>=20

