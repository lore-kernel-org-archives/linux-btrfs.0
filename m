Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2754D51C060
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2026 21:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790804524; cv=none; b=A+ZlaknBHADcskI5UKGfdfKPK95nOD2A0HSkgJjkAD93kd/2Eeo89141dOI/79NgBGlgSHbe2Km2yfdlJga8B+Fgel3xtkvMe2YlqVJfONaOviT0vnD5sZWpbB976xSVv8t9bQR3R0wkfy0TvlcAiG2pR+tmEsNdXcExfdOq7wY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790804524; c=relaxed/simple;
	bh=aS7+rfT+f4+bmNiGezSyk1P11MZmMKG5VRiHu5sLSK8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TQMH7DGGsnBQIpZnAaV0RkNTI4oe5h7QUig/XrpqwAF7buKdbdGzkqKWM4Rcl0jjwn5s4G4f5ekpxb+JKpPOMMaoJJht7Aiv2SG2ez1d1ox7O9Ak/OgamZvf2e+66oOFRv3DcmNycfjDqfq63PZG9TVBW802CqqfKcOk1VUG1is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=NVQZzHZk; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="NVQZzHZk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1790804517; x=1791409317; i=quwenruo.btrfs@gmx.com;
	bh=c8uI/Cmd5C9DyC3q/kfqzrtH4lIcMbtWkTx7qBdfUTw=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=NVQZzHZk0m29c0PnmDexoP0wTeMPe3ehpa6aQMEx8UouG5hwM5aB3hkpLJq0MKW4
	 u+06Iu0cUvKTwVPyL/27oNNfhWyhayEBKKCuX9esMDjNNpSDbEfZ5ibtbiiwGYMaU
	 lNnVNm+va4UFBovnp2qnTSUU0EohpP/zKFtgTKHSmNaGzQuz5roFClvPcXq8iBhAO
	 N4VwdjnDYsxI3HI0wrX8gHLKPxbRYdFUBf+/rSxZ6WW9HR80EGTEC/JHaktFGJq+5
	 2oN6ahPdnj95V4hggTmC9xIQf/Yz8uRzE9zqMn6xWAkSMYPvIJFSHwgjfa0pAE3z1
	 17yutSS9qdATmDmlNg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1Mv2xU-1wuMia1IlU-00zRn6; Wed, 30
 Sep 2026 23:41:57 +0200
Message-ID: <e523ab38-2a85-4924-b133-1581f7655cbb@gmx.com>
Date: Thu, 1 Oct 2026 07:11:52 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] btrfs: introduce more accurate usebackuproot
 options
To: Boris Burkov <boris@bur.io>, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
References: <cover.1788678078.git.wqu@suse.com>
 <9c907c139ede11a4b3026bd15b310de034690bc6.1788678078.git.wqu@suse.com>
 <20260930182325.GA3186434@zen.localdomain>
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
In-Reply-To: <20260930182325.GA3186434@zen.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:G7zbEDXWFAJ2J5vkdB2Wd6nzek9Wbb6dk9aHqCEzICAuWnNN4Ap
 Z9GUVOETb+IpkPyt0Dlt7FzcQpDKHJrgg/r1+M3ZO/ORK6CrbYuCXk3BNrhg5AC8yLKGvZU
 KhDY1Q4ShecPG1dyFhUPhnWuULywuneOzpm5DSEEAoHkA8ar4/7a2ZnaRJ3L5UI7uUXKMpl
 4KpkICamCevPVB5rX4Qxw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:1aoTOdH3jKI=;eVz25q1BMxSP14lx1kHO0F+4VUe
 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
 KAgH



=E5=9C=A8 2026/10/1 03:53, Boris Burkov =E5=86=99=E9=81=93:
> On Sun, Sep 06, 2026 at 04:33:38PM +0930, Qu Wenruo wrote:
>> Previously we had no way to tell btrfs to use which backup slot, but
>> always use the newest backup, and retry until all backup roots are
>> exhausted.
>>
>> This doesn't give any control to the end user, even if the end user
>> wants to use a specific backup slot.
>>
>> To address this problem, allow more fine-control on usebackuproot rescu=
e
>> option by introducing the following 4 rescue mount options:
>>
>> - rescue=3Dusebackuproot_0
>> - rescue=3Dusebackuproot_1
>> - rescue=3Dusebackuproot_2
>> - rescue=3Dusebackuproot_3
>=20
> What do you think about mirroring the compression levels and having the
> option parse as rescue=3Dusebackuproot[:N] rather than 4 options?

That's the solution I tried before, it turns out it's more complex to=20
get all the parsing and validation done.

Meanwhile we only need 4 slots to handle, thus this 4 options method is=20
surprisingly easier to implement.

Thanks,
Qu

>=20
>>
>> The number 0 means the newest slot, which should be the same as the one
>> recorded in the super block and no need to load any backup root.
>>
>> 1/2/3 means the second/third/fourth(oldest) backup slot to use.
>>
>> The existing "rescue=3Dusebackuproot" is just an alias of
>> "rescue=3Dusebackuproot_1".
>>
>> This will allow users to choose which backup root to use, thus can have
>> a better control than blindly choose any slot that can pass the very
>> basic root node checks.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>  =20

