Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.17.22
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055847;
	b=fgmK981xikc79Wh9pES+rK3ikmSVEABivytvFCvw5ObXGsN01M1sOcvOvVWMAUg39fDN
	 8QggsyeMzcOwZ+HdeTJM7TLN6hBjqCg7D2r60qV9j4+dCM11nQbMohH0FFItXdqL6sCuK
	 atoFuz5f6Wyr04i/5eEUEOc8YlRy6zO/zmP+Uvbrtdi+ZaY0FWgXjB19PEik1NYXfr+pP
	 H953oa5ayQLTG2x2r0Khu8poVlwETBMLQD0G6UTSrl59pUXBMCrkWmnfB37TSIQEcNWKO
	 cka9mSXfGtMf+I2gGStRkQSkRVxB/P4mUb7SCg4al08UgbBFC3MYWd/p0GD1Wyq313w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055847;
	h=DMARC-Filter:DKIM2-Signature:Message-Instance:DKIM-Signature:
	 X-UI-Sender-Class:Received:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:
	 UI-OutboundReport;
	bh=ERj9i+e1yIs7e7FRYPcJ3BBmyuedWV0S2pON26KpRgY=;
	b=rgDcz6+/u3CoA0hXzKnomtL1oh6ZQHeI1VXer1BmpiMYdN41npU0pMU2CBdy0U11WQ5G
	 AmZqxYbWo7Mohj2/f2g3TvmFSOnc9hvFm+wbnOfxlFhVVoTF9L2zFoJEW5BZUCwKzGU+P
	 Nlvx0jOC9IjhEwmLH7s+FahlIB+q/t/BE99MbL9BaEDYJVRLamr12IQXKIPhEa0BJ+bze
	 uHN1KmRChjifXpSgf+XrRTYi0ft74q8ErWxWo5E1+f6HLsVDmpfzm34HoaDS8ASzc6jPY
	 3YLT44nxy5juUaLQMAkApBPWvL7lEg992htlROVuwzNq0XcUfWqHnLDGbiNm3S2VMdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=Vm+44Hb0;
	arc=none smtp.remote-ip=212.227.17.22
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0599A606A31C
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2026 02:37:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0599A606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=Vm+44Hb0
DKIM2-Signature:  i=1; m=1; t=1795055843;
 mf=PHF1d2VucnVvLmJ0cmZzQGdteC5jb20+;
 rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
 d=gmx.com;
 s=s31663417:rsa-sha256:ke+7BfwnriWcGqfj2rngyjeBAmWs
   /c1s9Lki/ghxgg1bGsgHFdRF7laHXHX+hCxT/Kl3Z2e5DbQ9bVHR10fp6NI+yeaFLnisb6lMnnm
   jEwqY04hKKcKV8bXVyxEAZ+QLi1XeH8KtmAczog/ubxBA5GIIXnLBHySd/SinmKq3pe3kzQKSdU
   uAGV5RV3udBhYTKvpq4VjKYPmB6T8yO4CuFeQbsAwbgUS7zTlnZLTgl224kFlYL90cYkDj0MMdC
   vf7uNjBMOIqpYtmdCDy3fVNPf6oE436vKgpMfeygYW/RtBi27fsygIKXLCeH8Mmoz6MlNi6eeGQ
   81d5wc1CYp/hbg==;
Message-Instance:  m=1;
 h=sha256:
   zxw8p7qf9F0cEf8mGODVznkJ+7YFvurkBmuXSQuyNfQ=:
   ERj9i+e1yIs7e7FRYPcJ3BBmyuedWV0S2pON26KpRgY=,
  sha512:
   Oofr0jS8IDJmSqFV9yWeoHXr3EmWG4RgTmhfyzmvMetdRhZ8GR0NzNozs2ZeNtBKfmksaeiNRDxAtioGt6OnDg==:
   9U/Tc7/TYFJiJ3mMIqhIl8rQ7XEGRaIaarNyavJp+0+XndaeV/WRNMC8bx+U3PoNVFi8mUyJulmm+Rw9BAJh5g==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1795055832; x=1795660632; i=quwenruo.btrfs@gmx.com;
	bh=ERj9i+e1yIs7e7FRYPcJ3BBmyuedWV0S2pON26KpRgY=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=Vm+44Hb03Nm6719KLZp00iuUDfUtka7CqMcab140ay07zGOcypXtv4PNAUa5/hbv
	 Urr+E4l5eGgjWMGN4GJx+Rpr8BAzX69eWXkVJ8SSFkQ73dnksecm4/WVlkHk16/+P
	 vviXmkxH+hG6gYRaFSJP6toknaSg90kz3dP8qV8h9CFwJCd5WunsBIm+GCyQ2fqbj
	 mDySx+X+UY4dvsZ3wm99UZ2pDEMpVPw7mSmpdohOLRNxz8Hy967vdMNkgxuVCrW4w
	 S9I5G0YspVM6peqTioxsIH/mLH/8Dn4PqXu86GRgM+l8LUhNjPUHsw3EX7EmNwOx7
	 74b6JkBWJut8vbEUQw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1N33Ib-1wRIU10gof-00vNX5; Thu, 19
 Nov 2026 03:37:12 +0100
Message-ID: <f944d77c-4c66-4dec-acb8-985d4288afc6@gmx.com>
Date: Thu, 19 Nov 2026 13:07:04 +1030
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
Subject: Re: [PATCH] btrfs: scrub: don't count zoned repairs as corrected on a
 degraded mount
To: Miroslav Cimerman <mc@raidlab.org>, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>,
 Chris Mason <mason@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>, linux-kernel@vger.kernel.org
References: <20261118175637.60283-1-mc@raidlab.org>
 <ee3cc2d0-6991-4d7a-bbd6-a84972d44b37@suse.com>
 <HLy1GbxoNDmZhdhuxdyatdLIiWG6jabGJiSOxke3u7mRd-njBgBiRytg1IKO1S2E6xNXQw75eH4SPWLLXC6TC0BNXXcz0SV3FsdSOQUQLdg=@raidlab.org>
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
In-Reply-To: <HLy1GbxoNDmZhdhuxdyatdLIiWG6jabGJiSOxke3u7mRd-njBgBiRytg1IKO1S2E6xNXQw75eH4SPWLLXC6TC0BNXXcz0SV3FsdSOQUQLdg=@raidlab.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:gBNOOfcquJldGF/z9fMKvbH6cP9gJNaycVo8u4gZmVvXLQuG38v
 ppfE5qb06rv3rCQGjndcuU44JICp9IsGrRAmcHW6xjIZh20XMX/Ir+RhQZRqsR6N4pwvdC3
 jvlR9JTQftqb/bbBBijYkYc17hUKBk10jG139//IEU1enQTjurT6ihAyXf57uX045XW+DJ4
 yzih6+Mu1hB9RgAuosECg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:dHNGnJwbpg0=;qFB8vU+50Rw9di9SwpVrmPlD1W/
 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
 Q==



=E5=9C=A8 2026/11/19 11:52, Miroslav Cimerman =E5=86=99=E9=81=93:
> Qu Wenruo <wqu@suse.com> wrote:
>=20
>> =E5=9C=A8 2026/11/19 04:26, Miroslav Cimerman =E5=86=99=E9=81=93:
>=20
>>> On a degraded mount btrfs_repair_one_zone() relocates nothing ("Do not
>>> attempt to repair in degraded state"),
>>
>> I think this is a little weird, any special reason for this in the firs=
t
>> place?
>=20
> It was probably meant to check for a missing device (so that a mirror's
> redundancy won't be downgraded by the relocation).

If it's a workaround for the well known new-SINGLE chunks during=20
degraded writes, it may be a little over-killed.

A lot of btrfs-progs commands will do give extra warning when such=20
unexpected profiles are detected, so end users can later balance them=20
out after recovering.
(It's not the best solution, but it is not zoned specific either)

I'm more concerned if it's some extra requirement for zoned RAID=20
profiles, e.g. to keep the writer pointers in sync etc.

> But because it checks
> with the mount flag, a -o degraded mount with no missing devices does
> not get bad copies repaired by scrub.
>=20
> I propose a v2 series, where 1/2 replaces the current mount flag check
> with a missing devices check, and 2/2 is this patch modified to use the
> same missing devices check as 1/2, so they are in sync. 2/2 is still
> needed because for example RAID1C3 can have all: a good copy, bad copy,
> and a missing device.

And I'd prefer if you can get some helper to know if this block group=20
can be repaired, so that no duplicated checks between repair and scrub.

Thanks,
Qu

>=20
> Are you okay with the proposal, Qu?
>=20
>>> Fixes: 54765392a1b9 ("btrfs: scrub: introduce helper to queue a stripe=
 for scrub")
>>
>> I do not think this is the correct fixes tag, that commit is just
>> calling btrfs_repair_one_zone(), and btrfs is already calling that befo=
re.
>=20
> You are right, the Fixes tag should be:
>=20
> Fixes: f7ef5287a63d ("btrfs: zoned: relocate block group to repair IO fa=
ilure in zoned filesystems")
>=20
> Thanks,
> Miroslav

