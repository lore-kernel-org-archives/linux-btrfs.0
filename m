Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F06D3DF59
	for <linux-btrfs@vger.kernel.org>; Sat, 25 Jul 2026 22:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785017995; cv=none; b=LzgLB+ch8JDNfbC5eYOLzvBb5Klduq3FluQ8DHQIa61fj5GYjBvpbVK8qoRdmuMvo6FABX7LhcqFVN+XPgxzwvGsprxX/MUsFK6Uk/ZFbJt0WgprpdaKR90He9wTN/di59y2EGOxDKMAEGxQNq0ptvaayWqig+U/rsIlF1I7iyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785017995; c=relaxed/simple;
	bh=B3o72ZVuGkiPcqTl7xum3mgy6BjLV0oiiSNa8/qilZ0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dHHjkZL9aipl3aDO9YlXZf7smz7FSnDMEeZijGMZ1G2wnLtK1EoZh3oU6RHqW0zDTQrhKL/qsXr8hdILqRnd8k6kkaMNHzducVmpHAn7AmHemIrxefDG2WcSmSDCBaFIUju//xCr+ZSoTc0oKROB+N0yj2EfRk9xV2ikyuia9Bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=OhSRXwNd; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="OhSRXwNd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1785017985; x=1785622785; i=quwenruo.btrfs@gmx.com;
	bh=gxnH7jX4XAou6V37gbmnA3C4wxt4ZzNHQYpJK1lkzAQ=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=OhSRXwNdxa1zB5i/pINVhXSKeCSYFFUKUUJvB5BQe+4En/XcS/n8w2A6d2yHlftP
	 /ATeNVWjCzdGn7IT9WQ6ZaubdFcQLUIisHSbk8GWyec3DpT6ErgZDBBqdjabflI/q
	 zbeuF4N2YjIxabriQem+4ZBJu3BuAtHkyYS9jniL4Ok/quQYk4EyS8jSK1kJFfPjj
	 OELhZDxREMt30RK0ZCbTK7DHneMvjehyluhpfftu5XBQW6Nmk7yfLB31PBlxycZe9
	 KUAYW/vBe9BJAO+9EdHqU2Z4PcrzIbA2bKXLi7RuVnAVjom8NdJy3ZY8obh+uLiWH
	 N9pr+IOCscd9+2HczQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MqJmF-1xIuUF3LMZ-00k7UK; Sun, 26
 Jul 2026 00:19:45 +0200
Message-ID: <3f37b7a7-64bd-46e4-a9d6-21d890e0f638@gmx.com>
Date: Sun, 26 Jul 2026 07:49:39 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] btrfs: trigger cow fixup via dirty_folio()
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <6758d4f27be0bbdb865cee7dd5adc435c969f4a3.1784960646.git.boris@bur.io>
 <dbb0e4ec-cdce-4852-9c1c-21634cc6fa4e@gmx.com>
 <20260725201256.GA3089100@zen.localdomain>
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
In-Reply-To: <20260725201256.GA3089100@zen.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:dLovIMVppYVySQWagbweVL8c39dChykj7vRLiakNzdHldJb4wGw
 4psXsELDAKGu9NBabXKav9NoOyv22q6SZHCcELGbo4YnhoaLtht/IxdqSUSrIgME/aJMOAv
 Dx4Jc0tXRrdS7r+4XQEkzsJgy1usAFt4LtTEBGXlUNbCkhAcKdmasfJueRWZZEydvoPOW4+
 nyjN11u833O+VUkH8xPCQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:QrRVXkTvL14=;t3ggiz43nP0lmnUIMjbNCl4zzCx
 KTJBGC0YZR39NorfEsXHLMjes2rP8gBqdzlCKeeNMXOwrJcn3PFxNXvKiEmVvwvnM6YNfa4l6
 BNd8vG9JkDMGZSOsLXP2jxsTabl0pRUCZrPCJ6EvgBRDfCIlQ7vXDEONdwrCsZbyQesJmCb7F
 s+v3eJifgOCQrbKtNTtD0N0Gp6vfA1Qsk3V2D4/E+fqXYmtds+LW68+/Rdm7OR37vVH95kVT6
 ApEhQuH0LJJoWRKA+8CrXmLs56mPaNfJ55Y9RjNXXP/k8OF+q6cAZYn8q9A7a9NpzypFUWxT7
 NMDm3gF3bl7L4OYA+3vugS9X5LoomFQ978kQMeZbKF4Puce76OI/v/OjZt9i0+oRkgyv8rMzs
 omy41iPzjA/tZlN6pB23WVUzLYfON1tctWLmOF05ntm3oJt0SQbw/sclEhScvgvFt+MZ9ylFG
 4jZqQvcy/mN+sx5oiDhrXGPpL0Wfji5FXt32JwF07TL3zE39NR5mAZVuW0QmHkxxwqybekygO
 qJmsP8xAkiq1NyrH1c9dpe9fjfjHYLw3umVpPutd7UgnPpQkgmEI6krkMZNAqJGPZzyKxsWQU
 fqNx0TTblauMrQgYTpSDPU3BQrgg/ebiusK9uylp7KpmlreX0mI3El93QCXSXUMC32a8TJ6tW
 tH4iBeFvUMfkaEgsr+f51wNcpVs/S86qQ8r/B/ywgHDNyxxmWRFimBnO8jg+L33NRhZGgVeQO
 OA4hxa+oHx1zOmCu1z2wCwB4RA643VD10zsAsqtJVCtuKBYkZ4Ok1outVB3LRDI2wk5c4dX9t
 RiXcgB19z5nNFY2juen29Tem5jtXKVRBPnFVd/Jlh4Kf+hKN8gSPZDh0ga6euJVZKIiYX6XMY
 DGcLHoB56ye3XVFfrtpoMldLmjxxzRfhJN96sorO43elMil6acsjCBFBm8IU6gcVfkiXi0Czi
 rWCfb8zhG+l3k0C3pla704G823pXDfTFEwfS2F2wIxC1TjxDnN7FOzg3h0JIdTFmN2G4BZU+k
 LRT7GpFK5XLTn6GM+8IVcO4RscteLl5r+Mm3g31SgzZzofaL9ketgj8+1dQuEl8bKGMI1Ubcx
 kiKnxcFrdkH3txrPHu9mbAzRaMgeQJd3qiXiaOmgbtdq/kJpTW5ZehZEo+tzsLSnllQ4UtL20
 xcfDPhScFp0G/HJN1uZFnPVdfBrBfmPgfUXDfjfm71MBZ40wnPPCFXHSD/EO+Fvc61uabJ4KR
 UJZfium4bn5Ifd7Y7v/2hSx6GuCVE7WNxTu+1dQLnMVDN+jaf8xWr6qFVIWsCCUJRitaGsrS0
 EC2uwZ8H+X8A10brST/FyR8r1sTkM35Tgzx3RruXpJ7nWUIXB4Hq3rdMBG6Vs3kKCxjtB0XA8
 D1itvEMDkCI2cRu4OVw8HPN1hakSf76kERhuICnCpvyXiiiWZJZIjJYf4G1SntPGtGdoDxPwC
 7TkX/3zTLLkAsBtYOyH2WkrZGJZ/J4Va/1RVUhWAYqndXkMZI9EFTUxgE28udkJY5dOr6kwE0
 QMMbltEC640jeWS1OyIq0ZGWP9f9n9HuMhMGQVpC+opGve8f3sD1RNBZoaUJTyquCM6/MFfnb
 M96M2Phd/qLvEPUbYW+aEipIUjIcTjrvV/16d6FPslTU1+AxylJmuUsEFOn8/ogCxIs39qNb3
 nM/M7n5J9jBo5tUmYL6+5VtRURWcZMDnZuoA2dca4bcP7pYqk6VzZS7dxWFA+gCw2n2pcir97
 EhU9LqQhu44x7Szu9TsCm8DZkUZ0TI8FbMvE3U0wnmV2zJEiHRE6FrDY2F9rLKprurUzvIvVX
 ML4aneU8Wlf4Mnms+LE6Np0GdNRoURVgQg4IQ47BsNELKFLRV38vgxOyycrovxmQ4mMH6z769
 6YVl3G7bhFcv+27mEm/rmu0mcDcx97h2jggEXP163MbPoFv/mFsZZ9/TIILJ5S4b4K37zSbx5
 fAf7xMDvDdAkcJYh+AQ7NHSYjXlXVqBoStlsQ6EbxDpMArjugKvXPG5uWSoRd1/CZYEfwwR6O
 1YpHBIs7JM8MaPRmBBFv0/8SAtfCh9zW9/HRAPf+ZIZw0x2K0pwaH95YsUsYPrsVsPTVDTWWZ
 f0cTJ6jOHPhoPy8qcrU32igVRWpE2w9waTFCXfKZ+yuPP8fWJBRx1muq7gFm4bSbqsZglgd3u
 EhPbP97yEhfMfUkd9QZFzj+F+ohnXsMtvuJuJNyk0TouT5lRA1wzt9rP2C9KZx/qJw20mjt6e
 /ScLuli+C+8wtVtSCUWabBB7MaMoDIn0b9LWeQjRnVYSQh2pzebv3smAaeYxG4f2vMkK9bg6y
 uJT8CjCcd1375h04D5zkMof0dBTspaZKStMBMvmtFbPuQLNKxybp2l4+gNVPg15sCuItMUfZx
 2D0x2P/PSuRgPnTDtVGq0VtkYVrUqUc41bXPe0czs4s1+ziQzBEowpqfWnfyK2oGEpiG0rVAS
 sIoXCzSPrcR2KVMD+8UI0BFQGlMOyx4Fvdd2bX6Yj+TOKFEtQsW474VNw/o8RHUjkFYwUvdsv
 h/7qF2nz38KUmZPpX3VZUmcPBi50GHnVO2z19FRYnyuJMoTzOcbDh203uAZTK3wa4l7wI6R/L
 Dqi3ATjMcQ/kUcB7hR5i7/I6j+dic6LFKzqEmtaEuq+dMq5Vg3oMhj197aedV1gdnO2EhZv33
 qu1xTrupsNCpXv6xh2VUrywVdZWqOsxtfeakW32zX4dic06EnMdHRafzMkb+m+yqxU7FuG8WX
 5PQjJvAwR2ulBFFO1UfwviJRKQpZVEvSsBYgDaxqt7Q2ZpNOgP+q4d+ZS76ZGmrWt4kmFpduh
 EIEFKkM5Dg2qhKyWEZQ4DinisLvxXLHTEjbCKw2m1e47iXn5IUbQ1Q+/IrOi9JyEY3khSlQjQ
 pgu9wYNZuwpm9HJHkL0u2QnqJdmKeh5PwH9XeZYmFVU0eMtl12lu1GLKMw4n1KG6LjdzSxgQ2
 ApWf/WOCVgWSbxoonuwtZabHc1FhyRU7qXPie4qP8AlQin98HkJt/uaUl9ys53+sM8fNh3EFC
 TeN0O7Sag+aWEG46RqRZsxmWddmyQzovhsaBYXmlquc+XMhS9fUOQvdxaKlilMzGk8NNCekSp
 K+Pp1VYD+Gy6X8TBgKcP78iJ8BA+70QB39qM1Q00/XdYpTIqZ1KQg2dx0IQqCmBDa6vdh2fb9
 YGeMeL3CLne6k+jZt1uob4voJFezDn0ArkbK98J9l9QwhS1YtIjky4wwYWltb5GaCN99HP9X9
 6UU+67eHCEoVYBKho4p5y1u/A4s268wVMv7ybB7tOrknZ35EuzG+EqHRNB2vKPJDmZnHURiOx
 dfkuGn6ttwSf7l4k6QofEdazr+C5UgzgQqNOtpeOrkrIvU6lo0h8c4REuhJcQdNkrQOPIrGLo
 1JoUZUUL6xv/8knqeen870KAoslt8mXntTHFPlKCGNS2tl3+7sA/i+U/UapbbDrB89bFwnjxO
 551CdUWyXjeY+RgtO/qwt8kHI4cpaInRdpIyy36XYBKPGSJ95lzPjxKXR5rJ9Mo2pEQlwSZgL
 0tZ/QwL+KBiYS0A9Q0HUevdW/grWZS6l8BubSgcKWDxpCf+0kR3JYoFGYvP9yzFhY5PAvyTR4
 a2Zg0GR9bTpK66/E+iL0y+Y9O4WEEViiYXMF+X2lyCZa9PuutWw2rEoIt+nRKGuGIGWfNlEwW
 WpMQtsMDLWsrXn6W4a5Bv5oxxxgH7UnE+OPpHtUcEsA59SIcgNxtnZz/NZ53ufOr3Moz8Bcl6
 Qg798vIQR0zlXDlW9jYmTxh7XG55fpOwoZX6LeBCxx1GsTAG6csrVrtSoigMufIctDkC8Tbhh
 4P6gz5Nx0ilxq/3dxyiPsesr+XzLE0ylYmX6JUgOfOcPPq3wsg/Q0aIZtCRCf1hW1Ck7KCLdi
 xowwahGkhem7DVkL9PhZ2p0Z37dZFtnTS3nFiGwwClDhWAH2N4Nmezfiz7gPoa+Tekvh5Nk33
 6WWxf6LH76gnlLAK9roydZ7JF8h4O2pZMiNS+h9rWP/yhbm8xoFXGy2Ps95SnIWCdct0b87Fq
 Q33/ILe8DjFM1D7xJl0du3HfU/VskHM/b2GEZEyLreS6QzTRfRbC7oeX+nqG2BRfkdG2zU0+e
 TKONafbKaYKDID0j3TKaSjn2Yr1X4X/QNUgo3gIrk32PImFYirxkboUWTrMuQUUQjtm8AZWIE
 NLVs2vbWmUIv8cBQQCNwWtiNKHV1xo2QhM0F/bjvN327i6imPDZq4Kq11/MdYLjondyBElw00
 9IHgi2m75I1DchebgP+wQmL0RT5on+yWZOR+Rg1pIz+MAGTn/UqHCTg+Kz7bFzmKwrokl0UDD
 7zLT1X+t8RWhQG8MAw6pZT1wHG512pwN8rkNeg0mAUPK5Lo40F6eDzarl7tJWGfMnrVwRKx9Q
 fsUohElQHAtgHYaImgG/weE1vgMKDwvZhgtS9GbH2F1tP3P2AcZhMddprddoip3/u+YCAXags
 T6fkcj9nw7x7YKEZZRLdJANIjm3eBVlSaZBC+mIrN2GpO9JSMi39TGGxwmGS6wf3cjybynHyI
 iO3p9Tti0vwOuRj8oFqInrcENLRBXO/xfyv3BpAv34H3nFqnJr1WjFNFuiqleqGeyJOMiYtcE
 smdbt3VZD6cnUo1UD1srZeyeSv4IdyiG+dss6jtOEdjy63kAWGQxUM27dmBM7mrIBW35D0I1G
 xBKZhSRM4dD8C6cET4CVJLS+/yOmUqRBkSwPEtYRT+eJgQ5ubPHJFQFfF/Ja7TMJlZVNdqsQi
 hYMoFuMMo9aesIVs7oG0rTj0RWg0ndEpcGlCDcnhcAovjAnz8utFHJojKCOrBaizKHYWlJZgs
 KMJxM0O6VFbSagEkFXFSFEm0W06KuKXx5QrbKfKvOb0R/jVZo5wBzh7a/Oppm251YalJuPhkE
 pMINwx40tMEGeghNhHXUYFjkY9ZLmvoACjyUBz4RHYTYW87cF1dMfIQbgI17dOQPG1bS8eQKQ
 rnwe0aoI3Bgu9avTWje7ky9ccffFBGV9km5/OCAgm4D5wWTfvOPU/Uy4SAyuXDfVQSXuQxhVO
 XVRKVPqXYqyFLCP2vlo5Ms7YYBsmDCaaI9IbCweNMcCP7HaMIdFxwHTlwzBXwRFxOU2NS9k+L
 cHmij4MkEb7qQi3qSwxKOovOBXvLHxAV39NMUzcwaSgAxb4W80iSDXjtJDN62OOkhD2Hm+LeG
 pciFsaVCP70UAmCjTaSs6E3xxktLQ3hHorraj/JYxws2aqcWCa9UlqCRYi9cpWyJm2hq/PDtc
 28nczBEST8dSB/hG7Dsaf0+/gWAbcMEMIib8oouH15AWIswpMeHc6r2I9bWgw0xZZ2Ro+f0O0
 WrIU9FgUe1ESp3DN8x18Yn9yHm3if5M0CNt22ey5O5w5kafGQ3PZ+UcXcVSCPzflVwkeTXWSU
 THeDRWwZoS8FN1h35oyjbaZOi3RZYm2zhF8FM9lNoIWJWBUkOnxfWNg32qLIrI6lkYeI6SEss
 MjhPz2rJdZas2KHqu9nTuSscKIEFtj1wWP2+v0Hs6VhwjM1+lH4/vtp30E2qGNxxduFGb0kdZ
 1iAU+IZ6hel5DW3d5yaxUvLYvB9QIncV0fupnDmib7xWwycEtusgUsawlepNuLwYlpJScRAWJ
 g+IP31F+RB9r+VZv7tfWufdLULiUASE84SB6jM9BDp7+MVx9BRgCYi4SzikyZIRDnberN3oFj
 mJf4h87TrmpF9idyWnBm1APf6weGWmbxuQWo+J05tm52lTjny6x/idq0ayx48fsU+u5m8mbGA
 124xUQLmQ4Jb04O9Klbda



=E5=9C=A8 2026/7/26 05:42, Boris Burkov =E5=86=99=E9=81=93:
> On Sat, Jul 25, 2026 at 07:34:46PM +0930, Qu Wenruo wrote:
[...]
>>
>> Can we simplify the check to just check if the fixup bit is not set?
>>
>> To me, without fixup bit it means it went through the regular write
>> preparation, thus should have EXTENT_DELALLOC.
>> And checking a bit is way faster than check an extent range.
>>
>=20
> the delalloc lookup is essential for bs =3D=3D folio_size, to tell apart
> the case where you are submitting a folio that got redirtied behind you
> (don't skip) and the case where it is a true fixup.
>=20
> Thinking about it more, though, that re-dirty shouldn't really be
> possible at least in typical cases, so maybe I can figure out how to
> remove this.

In that case, I'd prefer to use folio->private to have one extra bit, to=
=20
indicate the folio is properly dirtied.

E.g. this commit in my unfinished branch:
https://github.com/adam900710/linux/commit/9a02921d348574573f1a6dbc50e54f9=
93011e311

Which acts like the subpage dirty bit for bs =3D=3D folio size case.
>=20
> I think for subpage it probably doesn't matter, because those should not
> have fixup in their bitmaps.
>=20
>>> +			continue;
>>> +		if (btrfs_is_subpage(fs_info, folio) &&
>>> +		    !btrfs_subpage_test_fixup(fs_info, folio, start, sectorsize)) {
[...]
>>
>> This is the biggest problem that I have no way to fix.
>> As there is no way to ensure the space we reserved is really needed bef=
ore
>> holding the folio lock.
>=20
> I think this approach here seems correct to me, except for maybe a
> really mean case which calls aops->dirty_folio() without locking the fol=
io
> (not the case for dio read at least).
>=20
> Won't any real reservation will cancel the fixup bits under the lock, so
> the way this implementation tries to handle it is to reserve the whole
> range then free the parts that don't end up getting in the "funded"
> bitmap (also a bad LLM name...). This is checking the fixup bitmap under
> the lock, so should see correct cancellations. Do you see an obvious
> problem with that strategy, besides that it is kind of ugly and annoying
> to handle the 'out:' path. Which feels similarly painful to a lot of our
> other delalloc/qgroup_rsv unwinding logic with data_reserveds on OE erro=
r
> or whatnot.

No, I have no better solution at all. So it's not an objection.

>=20
> I think the clearer option of "take the lock, observe the real set,
> release, then reserve, then take the lock and do all the work" sounds
> appealing but almost certainly fails to some simple TOCTOU race.
>=20
>>
>>
[..]
>>> +	 */
>>> +	WRITE_ONCE(bfs->reserving_dirty, true);
>>>    	folio_mark_dirty(folio);
>>
>> My solution in my initial patchset is to not call folio_mark_dirty() as=
 it
>> will call back to the ->dirty_folio() call back.
>>
>> So I implemented an local version which call back to filemap_mark_dirty=
(),
>> other than ->dirty_folio() which sets the fixup bits.
>>
>=20
> You mean to avoid the ugly bfs->reserving_dirty thing?
> That does sound appealing...

Yep. However the ugly part is, we will need a local=20
"btrfs_folio_mark_dirty_prepared()", which copies "folio_mark_dirty()",=20
except call filemap_dirty_folio() instead of using aops->dirty_folio.

Not sure if MM will be happy about that.

Thanks,
Qu
