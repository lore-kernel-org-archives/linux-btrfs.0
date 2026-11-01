Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.17.20
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793565504;
	b=q0JkeMOD8hbTTapktTk76Jt1s6HKAeb6dY08600bfu5tbRg1s6DqBp+s5AY/bso5zSX9
	 Bj0UpDOuBuzXlxYNlQYeo1GJl94RjXmgvviW7w0sAdf8sOqIzY7YhBT34Xau18sGbEPN7
	 IhDNtjFgjPO+By2ZQ58J5BsdtvmjNHgsdQyrwYjtmi7pDe1zLsV53IucSi2gurrkZOBIB
	 YsvNkczTwu+DKc8ZVKwup8e/+LEj2zLyTRc6hs6Ko0u2htcSP8bxsaXCP+CCFWxNCC1a0
	 jFrjtPibyaMcX6fKmDlSTccbZlD/NX/mLGKqqAnY3C8kvRmry6zj5cXIgMhaXUgCWHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793565504;
	h=DMARC-Filter:DKIM-Signature:X-UI-Sender-Class:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:UI-OutboundReport;
	bh=r70pO0BkM9XhlbQWoZA1F+WBsNpHNx2sIfdjIEnRg7c=;
	b=IY2N/6luTwYoZsumNd+tlb1N1qBelHmnJ8Qb/Cud2OSMy3UQKzeRa9RrkHNzptrCn230
	 70T5g6xV2mK3RD6tuOkZmUdwZfcWQmOn+bjjX+mc9m6aFjAPCgB1VTHqxyx5SSISnFbpj
	 1nk5Ohh2pZ1mD4MYZjflkv0384wKKp6qLYCHaqBcTqGanGIt/4PBRD3Kg+z4QRNK8Bziz
	 Ln7/cR30GTEjBMFH/qKwJX75NyFKbhsof6R4zxOd6TWhpJZoQCBtoiTdrVDNz9GdF66iy
	 rArfgmLKN96DXaHdQXJoYlHyuK7pV+9tZ0OhDWqjeHEP39EF4bX4Nv3DBIO96YLfDBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=tmeRMPP0;
	arc=none smtp.remote-ip=212.227.17.20
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 118B8606A325;
	Sun,  1 Nov 2026 20:38:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 118B8606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=tmeRMPP0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1793565489; x=1794170289; i=quwenruo.btrfs@gmx.com;
	bh=r70pO0BkM9XhlbQWoZA1F+WBsNpHNx2sIfdjIEnRg7c=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=tmeRMPP01BN3hKnapF7zchI1296Z8GlwoLaoLnl6dJXmy8W2w9XHyDLN+yCKbkPO
	 2tGyfweMTrXy3hnTDHvUcJH8NbLYlrzjzUvKj47G3GJ4BYo9/GuVjOfjctYWfPOIc
	 e1sD1SPTanx7/1i86POZTSYNlbXOPO821vhWlnUZ6fVDsV4IIxY+Wt5XxJWeOvWCk
	 PJifKEAf+BzoFIPAK3DNM96xRZnz8CY50SPKzfL3o97EIL4hVz/lrBR3Pd/HI17Qq
	 yjWdupxF0W9/PTBhZ17tVKTd9XHA+0xbYdhCgGQBWu40LYDOETPKpzCA55bSxhm95
	 TCXsO4Y9IuyGQ+wtKg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MnJhU-1weLvo1sea-00pe4h; Sun, 01
 Nov 2026 21:38:09 +0100
Message-ID: <d9990870-188d-49b5-badf-9e7ae9a273ed@gmx.com>
Date: Mon, 2 Nov 2026 07:08:01 +1030
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
Subject: Re: [PATCH] btrfs: fix bio counter and bioc leak when async
 checksumming fails
To: mt4022@columbia.edu, David Sterba <dsterba@suse.com>,
 Chris Mason <mason@kernel.org>
Cc: Qu Wenruo <wqu@suse.com>, Christoph Hellwig <hch@lst.de>,
 Josef Bacik <josef@toxicpanda.com>,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 tz2294@columbia.edu, stable@vger.kernel.org
References: <20261101-btrfs-async-csum-leak-v1-1-feafe7ae61e9@columbia.edu>
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
In-Reply-To: <20261101-btrfs-async-csum-leak-v1-1-feafe7ae61e9@columbia.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Bkq4pLrxfw92HInb7a5U6Vxl/QcOL4Lz0eTr9pslXBdblcoJsM3
 smXDOgkRVqR1rI63xJiemzcfiJyKSfOtGCxYRZAzQqGnXXEYq6l1W4AzzYWoaJFTER4rDpc
 Ga3S9y6WWXx3BYogb26bRvr8s9qDkHI9ASa4+aMSK6ETyG4Uvw4Iqqnghe+OLzqP8wVxKWa
 Qrp75/C0B4ryC+bFuhmLw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:63PMI0Z8+UM=;9gWxktmSJFlV6U4aORO+8OkkH70
 7lWu29XColHuIq8EUPCx48c06L21noNSyPuJMLkh9JjqSpMEoDU6gsnIuloEtaiOXnr2VkhFH
 y0ERdmfj6SN3f6WJJYfL4eMu/LdfQfF070+QTwxiDoE9I7omOI3wSD44g49jiTjzfuZcGade/
 NIgrp0wpamM3NV9ByY0M7yV0ek11ZracqCf/xT+8VyF7VVNWnCONjLwmSxWRTIOaRWHZa3/qa
 JgveeoCSXYtZC0MKQen/V7eWz/IlkrgMVWvvCKTUAkDBQqzgaFNKk+veUqX8ZSG6ZZXzxGKkM
 y4k4aT3tmqU8bC6dEln/wIi4B4yEiIO6Nj6OsVsbHW1QFgcrGyAoHWA+mScz2Z8K5NdGPHB1K
 90E/DOFO9f1+9bz90VYpSjEu70d+FMENYBOGckf4kxI+88/apOe5BKPp6LX0naG1/trYWc6MM
 mjiY1ULFw90ZjyLCYHHJhoGuwbtanzM81dE/sg1Xp01SAiVonxXZDeGxsBDHhQ2x2JHiUDh7A
 LFL++5S4dqHlDBXAGWJQNI8x0vcchXuFUk3Jid1Pv6gZ59uH7cJf8GLlfIDcb7Eyv0jTKJlx1
 uTGLNTtuznsI4Z8AWmo/d1sbiPqwNgVvPjw/uJUiWs8YYEIX5jF40N0k6CUUJmuH/uxbcur1B
 dva9GzIGUh5v269nUPkze1YK9zinXgx2aYNNLdwLdwDZGOwr2o+0mD6m/O22gH0MkEEeHfBYG
 unwhnPp9rYlCFDDYuKVRtT2N6qsTUh+/wPD7tSMuhNelsCCu54AY72bM0pCWwQbMaaL2Io1bg
 ZWyTPy1yy+9UgkDbOW5BOcwbolLY4D3iDA5e2hXZ4HGEsxkjbtAKWf2Le+YHkJdf1YCWQQ+pj
 CY4rFqjtEAYXR56jnxcqlBHMKP3KpkaG8CuqWCx/lp2Sck+CpD7YZ74OPp41ihgb9sSHqJ5Hp
 i0a8tsVCvtkGAMCYPtcqgHNfP5Z9CbDXx1VWKN5Gamlc4Bg/c9xyENm+2t9duIsmyVDVrvaz7
 N3v8YZo5Y6M6Dsq8nF9KRfc6dCPPoJMM1kKSIhIRNcGHWu9F0j5R86al/1BUsJd4h9UUSe65U
 IWoxBF7VuPlF/PDonUHTBeqko3vkHWDxFP7wqNYaUsryHQ388Y6njvHEeQArwv/xuczVgZgXL
 NGA3gJpmO6EyUgQQjhqmLfNeotJhkLTf3oiw3y8y4/vTQ4q4ZgiDe+rLZYQDPoHKOGjyj9mpf
 9GKGiVGT12X3BGjpyR3fQn5U8xomzQocvKSNqnTLW85osmiEEF9eXuRSmFnQxjxlk+Vy5mZGm
 GeQaboTXc/duOJqkSf26VOf30RNBhRzJt0cKJwn5p0jSdr14wiPbzjhs+j83oabziVSMPCHjv
 HwBFk/v4gyyKUAfdyDRoxpmaMqcQkcrOahuKuCXENMDV/XHreYWaHXPWRG8vI4VvMJ3IhlZdn
 o85DimiiDCupQP+KNqN2eLgLU8XpnpRpbc3xNBuR+oY+6i6N6IOMB1HqHS9ApzrEK7lndirZM
 GtO+p82TUrWjAkG8GJZfR0xgd87Eg+GnHuUhDQEVafCTcXT3J1WDjcUY4394i8KIuqPruN9cP
 GIN9/sGmNHosP+C/KcvIUNSW2Zx7HKB3P3Gp4t/OrvGYO9/hPKah3fpDz3CgnIl7SXw9cz7HU
 fa8Ta1cqcW6LY4y7zcEBzP0oMq0g/zMPwcHyTEg3a2qPF62I7JD6ZvouGzyBfxEamGiOfPqTd
 cdbCzer+UiGGFXwTjrgrFfV4bAD/S8occN5aii06QywwNyaZOdlmdj1Kx5MoirpwdJJqhgn6U
 cW9DjmhhsgcV3+RWgLm6kKmBdAub1XpFcCthNVmRroR4d7Ki6znDXReKtSQPp6Yl27xMi9hTk
 +2VaYENUpGkFV7MZDrVt9KhUjbw0U6K06+7YZOzX62+sSQ3WL0ckgtbJhwP/cMYWnJSNAXxwu
 dNpNAPbJObCZI/oi1Gi3cxa2uulNYm/DAR2BaK3tyY0gUT1cfvWqAz4hwyFUVQUgEI4mmLrUr
 ignMESXMgd/CJumjXaJUm6VXDAe9eQwtKzDxDTXjVGRuqyzo09LYLvOkldjx7oLdGsAKZ5Krm
 bzu2SYZcY7GwWU4ggs75B/6d3pjICiKLFKgEVIafgl73bl4WRnrG18zQOEx625sHzUDKkKoVc
 PPI801sF+Ulrcpjm0WdgRlpr5Wy7wNR/O5oMm8n8y4bT4zixaWNNGRqALsPJdNojOZ58hCnK7
 sBiPq5jucb3sXFtio1r3OWswHvu4RlNq6wknswW83z0ZSnwknvIcKGUMtvUubU3n5F2zKW09d
 d5sSWuP8N6RXHXI1HdGDt7Lnp9igJ3KMriAJq5HV4YWyuOHC1tQ6e2AkcNX5WC+cPdPtZnkOC
 rp0cUG+PErmHdzfJiFdGQnacwDumHlfCAMfjqgrpx5OCQDKwIn1k+g+WZqR+dT6tEactzUvuH
 kDM1NWuWfGrW/cRxSoLPmbqImQ8jNJZ2j2uus1VonWzp1xcNsqYFAF+77QZpGrUCVaNGUTAjG
 ATRJ5MSLV29ATTfepUK2tLhEVVTg8fzdZyWpbvXpAFaycAQRL5KxIiOKoDCaxHWQXCRQkaNWw
 ldRa6vOZewviha0rmtFBxDytifaBMViRPq0mmgJFk3B5/KQ5x0RzxCy7qqJwq4x+Wwgxvf6Q0
 kTeqT8OStubzSCaDaYP2rm6NhK7pMfu/VAjFNEnWeZoC0W0h20LaV1stgz0w5f5L4ZqihZBA4
 y24/dWsbOA8xpow1xDbhqPQDZYrXtVGErA6bdjzcTIQ4lRcJSUXdW6pyervm0Fn8ciAiERGop
 +wvNEjPBIdiTJ9v5ohDkec33aDeiZHym6UrfNWzbc5qK86rRO3iUFCZEvFr+Kg1dZ4BvyeglP
 u72QGNbaNjVG1J8oCiGGmGDaKvzwVuk8WMSiCuIHShiiWUvjy5Q4dyhC494LQDbjBpq/TUNAF
 QayUpnnbsZ1HKDXzHwRqasNJH4TctCDL4HrOdNm21TZxPHoKe90f/CHfgpR0Xm0VNZCNMG71D
 yVw36/LFyUXeIu/Ua8AY5pf7sDss74+ghFIkUznrefi67ipUwoVdMjuOOtheHpUhpPRkVzNlS
 sPZEXmWKpAchdZIisUwFVAI6YLBriCHQ8UsNJyQnDlbU4SEBoUPAyvvYsrOOI7EHu7OVoElh+
 iJ6UwgZPiMSCV930yTnnZbZpGIQwgOX9tDxaIgIZVfaRpMc3YhTyhxIkemTNhhPlkcdlgvtXH
 A/TruauHgXfeGqDBo7zR/JhKDqQtuBU0xoYlZjw0OdG+K+Qh0zuw8S2p9CFrYZKe6iPCdL2e2
 nUtfibI/LF6q8o2xF9Xg4OosbAw9GAt5dv7zTpdf93qF2jzwyonqDUrzda/uRN7FuzidMab9M
 Oz1ynrhjn1UySr2plvv6oGfK1mhKY5DsLm6SowbUFfbsNRypJB7MZFkZTlx4sHgscLx8BmQJ4
 GrZCVlu4AdHXVN49eUIphCHZYQ0BH457+wNn3bA+N2PxWJPEbzNmAdOTi5p3dHlKbWqK7U/Sw
 +r1pyYvVA4jL97FTLi7zTKuZMwa4+h8BR1JwD+vkmC5XXSxXEPJ2seELSXCrm6HR5D/l3w064
 sV4IYFUt2aGTtRlcIFtPdTmmzbcAZJJp2v2BuROQJOQoZv/45KpQwF6lwcT7Wb0YDG/edKwZ6
 lJDDnIwaxNsIClj+pWC+HAOuVK1tde8+7dEeFzm7+8zbG6bzrfS+axULjPk+eUEnE5Va01+BL
 skjODp7OaATyxjP0zfuBvLRj/ac5zyMHmwUXbHpYi4Jo6rJb7/1RFlJ1rYzPi58I6MWOdsO13
 NlJ7K2ENCTnmXjNvSq2QNWBQHD6KsMKsknfFIlLT29HPfjFmbSPY5tx60F6ql2FGH7O2C1OEo
 33flJWophFTQoljNwMjFwa8dwhyU1RRmipWbmVhi4s5zbrScMqEY8TCEramhmnCidFxP5M8oF
 0i9Hq3ZGkGHC1RN4p4ptMT1vXB3GHMC8X+4pk68GvQbQQdfHy+HKOPkwxbRvihr7alLMvLEta
 HaFXAEvHC8h3LcscryIMYt2a0VnqYULFaidUswL+jrH73g1Edg7tven28nCdeFcNF8/zs4P5d
 5Zk1GjRBtMttDY07Vu2n34SQrk9G+C8BHwPx5qUFqA7mkK8+XT8gX8BB5/o3XZniS6lV6nUxq
 IWevd5GSuFORJl3TYdTu0EhuMam09BTl9yYnM/shmJj4qfcMW0D0TR5d4/nkkorYa+hnd1gWY
 TnTxE6Ingy/LM8qC6SAp3fsDAm70bQgmDFRNA8GCI7l0pDkKFgDkLTCwkF3THO6aRsYR1TxHU
 gJfpdjverry1MQm3lcJ5qgxWFDcAmSonHBWHmQY3lAC9nQ+u8LChqwNJbD1LLeJqZUFupt9Nt
 dvhb0jcZma75KrEAz0yHvGXqYhAXDtHvBtRdjfumT2YpMBxc/doN2qqDf+i7vgJt/Z+XkqdPM
 eQLOWf8r9AUoSkM1B/HRrc2leWdzQhpX53w94z/Xfy8fBXjy90WAADjF/weuX86srnC8+ELKX
 ZeM3d5oWHDTTW5kZ4YvJg8qZOR4OLOoywvmWiFMGfPLniSTes4FGw9unI/HYu4YMq20MYicRi
 IXIx5qYIsNRJ8WGwk2ONeQCYNdKz84h9JmqkbnRIyiWQ/fVcn5m+wQxhjXVMImV0MtUjQD01+
 yFRB9pNk1lOuekOCKHGtRFctLI778T0nYJL2YG8PBRXxm/bZN91NGk/mB+nuPBUC1pH61S5Gj
 gVVl1qCkwfpxT1bqVtOJk3+T3Z6jMLp7uYU6x76e9fafe7GEI7r19s2lDv75+Yl8GflXqK+y4
 wnPQoxnFq3NyS1fcU0Q5F9Yv7I8s0LjFUDSQIqTHZWQ1hcCwIeRMubwB6UndyoTKIqIZWZdMI
 4yktz6zUBnluuLD0PaPB6ClwZtrcjJogArTbBoqSCaZJuCDIzD+r1O8Oovaqf36s0w3Vq3Ku1
 bVkNVgzSnyuy5ITmYMNIWDnaklSyZRtpUpyzgILGShrtnZtBM9HfonbZJ2rOx5weAVin82Pqe
 48d19E5qiKrnZ8j3iTp18cGTyd83HXLS7XFFtEkZMT39rrmf96bIGpEO9d597+ZOuOZQj4HPX
 Q1qXBp13SlXVwQSF+B5d5tqyGP4RBmX3YYkdaC1Tu8fgETHehLyYC9z/SIqv5RXQ7Rq/aREd9
 IwTURAJqjjdgS6A94B1jO0xMWFTS+dwNuXQu7WLMs/mMLcFTC95AhuRuH8l1gLfOIAmY9gR0X
 1jTlvaO+Eruy7btqxTPuWJTeAvxZNZdjwKBPOV42k9Avw4E18Cd8fafKuX314ZXknZ/tORiXv
 Zno2MMjbwfQOwOVievnNd/DlbnJiWkVw8pvEDxSGxf0/fwLevIh6nDo2Dp0QVB+X3eX9wim/p
 qKLuWSrnoKv6PDeMkdBxd57/B9tkaE4nf/p3sUUUUWMLsAwC8obz00ATMZgJ7s+7+aitnVDUN
 jBiZiJJBRkWHRGaF/zVdLqXFFdL9C3AxrOwgJiBgBbqD/gjlKni/BTrFGIb4KxXQO97aZfTY9
 OQr7/VMre/84MRnY7Bbjod/q1KOHorXuRMBm3EazgE7EkoCzH+agGb1ABAvCqKzoIYRtVq0yl
 MNDvhdGjy3qmgoMBhBShCgiJB2EI4ku5XGNhV9ImpZ4Cfv0M2AHFpM//VhTbMWuYjMigwf7Js
 jcCeGcYteVHok3U+t55DQ3t7Djcpw2W3JKDSti/ujSVGGM1nmx45ihMsTAmjEGa5IoRbLzqoF
 Gl6522NGde9JkMv7fXesFe+cpNivB+dP0DeLDzzv+pF4st4WkC4lw/0BKpxBpOoVZ5ZtNDoNy
 JlYJD+gPLjL0hXQQBG85RI8nd29EAsyXJ3ep1k5j6Kkm4ZHS8RzCpnjehNmY86DoXQOwVzYAE
 bs9U3ZM6qSz2ZMPMhBkOktngwPEH3+dzhvfIBlzP0YDEaFqiG1+Rp3AuPb6A3gef107fsO5jj
 flavh9g35sfjsA1ndpd6Azk6YgrIVEgzdmjLkIs20DqVz69yFeKOMGnWG+FzZz0VjOPPg2rBA
 NXntma5O5YA63gcVKM56V/v7Gxoovo875V74h9V0G/oB/8aGdGCc5ZR+wpDF4xqsYWOUokJ13
 l1sFcjPC4B/QD2Rp4QMzDN6vc3s1sB45GdfvHzTfTYO3V5PdKntiAODH/2vxng3VTpX/0dLq6
 8y9tHx3Aqj5huuZ+4P3i22Q2CgRZkN5hEar6ZQ1pK8GvaY6TjDnXOit5NthwV5Ugk+bPEUWEJ
 1sk0z799ytzMoBmHOfUiHZVz42eadFvMBkG3olqtTTnWJnmgORp0mIWlAxHW//WQ+RqlkQu4P
 wxbFPBxAK/XxSJpsXrm243PadTWvruiPpJpaFSVDDTeZft15p5fQZ2IeVL+hw1T16KFvgMo5O
 BcTI6IDCjB5hYTXwWgGfxSMRDL5azD8aV8VsaUGbuQtZfEbD2y9J7EdzTh0q9WhqrY0orljlt
 eQIU3fg/Ci7NsbPT461leFuSmHdor+Ssu7HKcmwGiMwLBXTRifRx6aHsO85umBQQdvCuEdaRg
 wZrN/YTQMXiGEFYbc9AQlcmZmNBrOQVCNfyNEpFjglNlMUq+6819wNRu5fVodQVZeh2FZbYOs
 gAmWTHNAynASXCE2lh8ZDR7T07faHpodjLJH6sddb2ZYxXgrhc0NW06WBTbuIUsNJHlcRk7Pj
 n0oKG7vELNIBnRDSr5Jhw/SX6av1XkYPhfw6lUTRBag0hmbmfoprflgP46NeZIBvfKzIv/bf5
 1A0CYJuNTkbiILtIFKuk6JCwng9nQOaBjmyx3nH/z213Tl7dS8bsaGO232sRmBNYfs1M08tU7
 RKW5mq95aSnACWenY6IvnAf1XySP5TdOX6wtBI5832dD67zkHCR1mC1JuDbFTDvsDkqymg+Lx
 DJdy7



=E5=9C=A8 2026/11/2 05:09, Mani Tofigh via B4 Relay =E5=86=99=E9=81=93:
> From: Mani Tofigh <mt4022@columbia.edu>
>=20
> A single failed checksum allocation can make a later device replace
> hang forever.  btrfs_submit_chunk() takes a dev-replace bio counter
> reference and a bioc before it hands a write to the checksum worker.
> If the checksum fails there (eg its allocation fails),
> run_one_async_done() ends the bio but drops neither.  The counter then
> never gets back to zero and the next replace waits for it:
>=20
>    [    8.369171] BTRFS info (device ram0): dev_replace from /dev/ram0 (=
devid 1) to /dev/ram1 finished
>    [   41.534247] INFO: task btrfscsum:80 blocked for more than 20 secon=
ds.
>    [   41.534391]  btrfs_rm_dev_replace_blocked+0x135/0x180
>    [   41.534463]  btrfs_dev_replace_finishing+0xefe/0x13b0
>=20
> Put the bioc and drop the counter in that error branch as the
> synchronous error path does.  Also put the bioc on the synchronous
> path, which only drops the counter.  With the fix, the replace
> finishes.
>=20
> This bug was identified and confirmed with the help of fault-injection
> testing on a deterministic hypervisor currently under development.  The
> C reproducer below however hits it within about 35s.
>=20
> Fixes: f8a53bb58ec7 ("btrfs: handle checksum generation in the storage l=
ayer")
> Cc: stable@vger.kernel.org # 6.6+
> Signed-off-by: Mani Tofigh <mt4022@columbia.edu>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Although it's not that common to hit this path.

On EXPERIMENTAL builds you are already running with async csum=20
generation, other than the offload path.

Otherwise on most x86_64, the default CRC32 is considered fast, so is=20
xxhash on all archs, and they will not go through the offload mode.

So I'm wondering what's your setup? Are you running SHA256 algo for=20
checksum? I can add it to the commit message during merge.

> ---
> Reproducer: https://github.com/manitofigh/files/blob/main/linux-repros/b=
trfscsum.c
> ---
>   fs/btrfs/bio.c | 3 +++
>   1 file changed, 3 insertions(+)
>=20
> diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
> index 2c6234f6182f..a508f4abd3a3 100644
> --- a/fs/btrfs/bio.c
> +++ b/fs/btrfs/bio.c
> @@ -624,6 +624,8 @@ static void run_one_async_done(struct btrfs_work *wo=
rk, bool do_free)
>  =20
>   	/* If an error occurred we just want to clean up the bio and move on.=
 */
>   	if (bio->bi_status) {
> +		btrfs_put_bioc(async->bioc);
> +		btrfs_bio_counter_dec(async->bbio->inode->root->fs_info);
>   		btrfs_bio_end_io(async->bbio, bio->bi_status);
>   		return;
>   	}
> @@ -822,6 +824,7 @@ static bool btrfs_submit_chunk(struct btrfs_bio *bbi=
o, int mirror_num)
>   	return map_length =3D=3D length;
>  =20
>   fail:
> +	btrfs_put_bioc(bioc);
>   	btrfs_bio_counter_dec(fs_info);
>   	/*
>   	 * We have split the original bbio, now we have to end both the curre=
nt
>=20
> ---
> base-commit: 5e6c45aaaf93343c7f8a1cde9797080238af5c1b
> change-id: 20261030-btrfs-async-csum-leak-1772df5f0c32
>=20
> Best regards,
> --
> Mani Tofigh <mt4022@columbia.edu>

