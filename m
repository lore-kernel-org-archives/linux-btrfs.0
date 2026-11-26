Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.17.22
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795684842;
	b=kpJnYBteQZ7BJwVjO7MScFUT8rtMfWMLEa8LW9fEIdYGIgOWyZD9iI6+SyYdxwdRQfNV
	 8AF9OCogX5zV1smmjWGhqggUbvpSkf2U2KtIf6Yi2T6x/LT1z3SX/L1kDf12HZIqVbBcg
	 3VvdVWhibSsoL2HRzmzvu7Q5AICkQcreQQe0KkGqL2cl8imxlOQOrNJTvtIGNfl4HuiEq
	 4TCOx94vFasrnES3WY3km0wZxADo1GqW32zOtcWwEmbMc4kUPB9saTfmWtHpQrVo0QkeU
	 qRZeEu2gAovwxmdIjsDHkT+DBd7bWoUgwGQkrOcejN9HJu/fA/T8bNjuzcYN+iPs7kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795684842;
	h=DMARC-Filter:DKIM2-Signature:Message-Instance:DKIM-Signature:
	 X-UI-Sender-Class:Received:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:
	 UI-OutboundReport;
	bh=R0/rtoPjjFFlEoZRM58WYKCGplTMxQ87fyYuE5PSAhI=;
	b=CG2ZDgFvVZGtdMdbaAjRhMl86aIjbPzQJOscAfSa58BH24Dn5oo2JlYga4S9ntDE7u56
	 w4W1LMcNEg59xFLSAdV6vS1vVQVrK92P/VftJ5denRHMz7GUDbfjtNYZMb+V+ARcAhoLB
	 DR5m9ou+YUu0Alf2Y0MnA8cX5mfldoifVSUUUr1OxK++r5ZBBJfMQtCASxxnI5M3WTOsp
	 /Ru2tpuepeWaNy7IFEGYzokYKOqRePLuBs1MyZj+RaiEp0ovfWQJCqfBDNJRhP6O8xk0A
	 OuuAqw7zJ9fPqIBdqBe2EZgM7Sr0efjlnpG43mB6ZaZIU8Gu1UYDuh4plvNgKdGQTLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=UbL3ikV3;
	arc=none smtp.remote-ip=212.227.17.22
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2496C606A31C
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Nov 2026 09:20:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2496C606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=UbL3ikV3
DKIM2-Signature:  i=1; m=1; t=1795684839;
 mf=PHF1d2VucnVvLmJ0cmZzQGdteC5jb20+;
 rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
 d=gmx.com;
 s=s31663417:rsa-sha256:gmpIQrEQZH1dvtrvDPRzXbKUNAFJ
   iNz9Gbw21UHXbP1Z6C9iZQqcjgBrhhHUswPpkPl37jVkAs/7Z6O/e1MMhO4NRAIPPmJylKTQEMT
   iKE7wiviuEmllxNxaYxIOqnx3kbxph7DNXILFSRUJxtspyV8je8lzMelqOrqquuuEYLzB7qRB/N
   YjY/D0KtDfs2zyDzun8n5XN4Ahy3j4l9+YEdYAlrrc9VOZgCitz98wrF626SvuXZXT3Xi32XbXD
   kMy9ypByfuPwVsTzhW+PTJxPrz3vwZ+LqZWP4Wlk3d3dAgU4fZdFLn7/uPsBbrfIw2EeEQCVwjM
   u0JdYinrDHsyeQ==;
Message-Instance:  m=1;
 h=sha256:
   mKfPsZLzPmiCm2AbGjeum6aIsrLWohmOjvZd/gSlNdU=:
   R0/rtoPjjFFlEoZRM58WYKCGplTMxQ87fyYuE5PSAhI=,
  sha512:
   ly+MbCbJ6bnnkhQOSkE0A9UKG5hcS1Gd+qzPnps8zfEzej5+hn5rlnwF8ooqrlOPqujpRDr+sPRcniDLR/nubA==:
   qYAHT2WnJJMYBZJv9r7CLSc6SuRlZegryFoXpv/Q1p3+aBVjqF/qhg54odbb8WzbWR9J0d2dkwrqFxWiJZUzlQ==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1795684815; x=1796289615; i=quwenruo.btrfs@gmx.com;
	bh=R0/rtoPjjFFlEoZRM58WYKCGplTMxQ87fyYuE5PSAhI=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=UbL3ikV32Q8abv52gQTVYMDZ3BMnH0VNMqJqlEo6dBgcuzNlLa79fpp4qgxCHvd8
	 /qbQrVpswCTXnou8ZHFTn4VAnaefUCPy9EZBPATt14Q5Hq22vjRyPIOaeHUQyr76X
	 66Jv6tFu3jr547IWFx8d4c3GjcxGDL5D1hB0OIfJnDS4p8wbyQvVTRJcbXWn/OliQ
	 wSfSI3C8cD2Y3eEN74oDSG50+U/ncTfjdj2Fe55CBq4oXk46L3yp7+iEBuBAX6j6t
	 4qFWx3a1uO7lLYUZMB5MjjeFTnLClOiSXBpX/h7oOMJv2QwhUoXqWAA1P5p2BMWxE
	 zWPb5mVIjRlg20X5BA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1Mlf0U-1yDmpQ3FQo-00ocj8; Thu, 26
 Nov 2026 10:20:15 +0100
Message-ID: <0afada5a-4182-4e1b-8305-9e6f391a9cc7@gmx.com>
Date: Thu, 26 Nov 2026 19:50:10 +1030
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
Subject: Re: [PATCH 5/6] fs: btrfs: Remove the unused dev.c
To: Josef Schlehofer <pepe.schlehofer@gmail.com>, Qu Wenruo <wqu@suse.com>
Cc: u-boot@lists.u-boot-project.org, Tom Rini <trini@konsulko.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 Bradley Morgan <bradley.morgan@linux.dev>, linux-btrfs@vger.kernel.org,
 =?UTF-8?Q?Marek_Beh=C3=BAn?= <kabel@kernel.org>
References: <20261125124259.95636-1-pepe.schlehofer@gmail.com>
 <20261125124259.95636-6-pepe.schlehofer@gmail.com>
 <56a63ebc-1d33-425d-a11f-6d7c73e820be@suse.com>
 <20261126091552.76922-1-pepe.schlehofer@gmail.com>
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
In-Reply-To: <20261126091552.76922-1-pepe.schlehofer@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:g60yEilA6r9Kf8gXBaPkhuGyQjOFF8O1ushHV4NsgqnQV/ZPKvm
 AlmX9Rjd/SqlwaCGCKk8dmglcn1sxrE+k6zv/F8tgacraRAFO5RoVOKfmXktwIT2A+y+LgW
 diOQHNbF56mV53qz5usuFlbC8dB+i2YI4q7sWnQpz6GMVn6rvM5TKIyX9uxGxgTiLTof5K6
 8p2XjKIN3PAIH6r6B7IpQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:cXmqg6KwKP4=;yBD+3UtDZGkWjOSm7MT6cEmzoNZ
 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
 g==



=E5=9C=A8 2026/11/26 19:45, Josef Schlehofer =E5=86=99=E9=81=93:
> Hi Qu,
>=20
> On 25. 11. 26 21:14, Qu Wenruo wrote:
>> The removal looks fine to me, however since there are only
>> __btrfs_devread() callers, it would make more sense to rename
>> __btrfs_devread() to btrfs_devread().
>=20
> Whoa, good catch, I'm not sure at the moment. Happy to leave it as is
> for now and do a follow-up once it's merged, or I can send a v2.
> Whichever you and Tom prefer.

Either looks good to me. If there is no other review, I think you can=20
wait for merge and got for a follow up.

Otherwise you can go a v2 do the rename in the same patch.

Anyway, the removal itself is fine. So:

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

>=20
> Josef

