Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.17.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795553941;
	b=Qr/tvwG+7oxtkudRcSApkVfhwcbPygqg1KEOrHrUqoDLzl3P8q4OzpmPWBzetexjysWc
	 Tm34VBsRS5OcyPdu1UhDgrzpsQCKpPTvQwVa/vqBvvmlXDgD8K9PO4T79+K4NPCH/xz2r
	 mbyHxuzeqvoq84j+aqu7uFsF0oW8ITQvnmOjskzjeQsbztt5LBpH/IMEv7nJBi/NcO/Jh
	 5BDMN2U1Xg9I3HTnoY2R+pgr5aZLdQS5pVNrKZqt9dZLbx9TY6bEe4vUTWXnQ1V8JhscN
	 jCHw+saYdZvYhqXb9fKqtoMLsVk26Px/ShodN9Nu7oX2wIi9s1tcT5cBEOPX0awMvbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795553941;
	h=DMARC-Filter:DKIM2-Signature:Message-Instance:DKIM-Signature:
	 X-UI-Sender-Class:Received:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:
	 UI-OutboundReport;
	bh=kx7JuV4M/7yg3dBkY042bY8BmV3Wgtt39dxb5d8+6d8=;
	b=J20YwkOaC3cfc1GomNKS8pF4vr2HRwOs/6o3+tg1uZ9nZHeWBwwqVck/XutDgLf5MCtL
	 Q/k13xkZl1EIqYq4Imv2sedJK35M+5NuCsbvw8h2nxkoBmAeQxd9oOQSZr7UJOwnEOmr6
	 PeKOIE4s8cHESupXH12MVvUoeMwHX8gOXcYNkwVNhir1MtILAxdsSRqyClBaaPgBnOseX
	 4bi1TIkMgNf18wSFmT3i/27shsOlXCF5u9kq/B1ISoqkWm1G27cSKSEzb8TdhyuPYJDVM
	 Vcs2JrDaJ8/96TePUge5FpmpL1hRqydJ6VbFgc9mD0b44Nq7bRKWHR4b0AzketOigSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=iiIlOmeJ;
	arc=none smtp.remote-ip=212.227.17.21
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBC66606A31E
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Nov 2026 20:59:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CBC66606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=iiIlOmeJ
DKIM2-Signature:  i=1; m=1; t=1795553938;
 mf=PHF1d2VucnVvLmJ0cmZzQGdteC5jb20+;
 rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
 d=gmx.com;
 s=s31663417:rsa-sha256:Nt9/A2f++dWuNtziU6dhVDCBBqP8
   Ogn6SFerw2fcQC62wA+O5wbWeWSzu4MQwqQfm45pfh2jsvOBNi9Ppyk5E+WwHZWnSYBmZ3n3eqc
   u2dUxwzMDxu8nZnxXEr1/eBMNby5kof/UwAJN8NEqT3xtUiOX9o2thq/ouIVKgJqZgCjuqjZQD+
   E4yL4HeAjjYo/hGgBlcdt2+dn9aKW8LPRluoJ33lxkhf1W38jNMzA/ZlaCq7EMpDUrOzX5egj3q
   kWA3zQD6gq1iYipPN+zGs4e6WQaflSTyFssqoQ6HzipZUme/OXTHKC20TAkf7i1/RMDXArhpv59
   NH1wGhQZAQlO/A==;
Message-Instance:  m=1;
 h=sha256:
   1cIbjOfHvWfKMOxhYJriIReXh2nILyHfZeDNXNIyN18=:
   F/9S+u6zH0fVeQGRVblTVp6orsyetGsaslos23tGuaU=,
  sha512:
   EODK8dabSKQOqIFhc6Pzsng8RRUZ5fbygagjooQb93ce/mighVBKjH4j1jvCSpWMW14d/aW/0okNgKZN0tyC3Q==:
   67PnsfNNoyKtFFw+jBfW3bodYNY496YF3XMyIya46gWYfUz0N23h0bOnPhthb/SBuswFJRbG1Cm0YAxPExLelQ==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1795553924; x=1796158724; i=quwenruo.btrfs@gmx.com;
	bh=kx7JuV4M/7yg3dBkY042bY8BmV3Wgtt39dxb5d8+6d8=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=iiIlOmeJ/Z+RFwW4h41z0Glpgc6Z3uS7Vjw4MqObI/E/x8gj13XdV3w7SvpCbuXI
	 CyVzVi9gNwvvGN/UVFZNUMWsyRQydJp2QwdkKUX+X8GR075IZrtOh4VPhDGpSj9XP
	 E0rTIy8+Q0qYRH2c/vmLoMle6Ym7u4k6MrNRybLbpiuxBVYYfjwKnxCBWQWIxosNY
	 7IgWU7MRLz9QKmV5eJCQv3xYjMdgaxLx5jfti9YNNfXMgdWTl/nhI9HpHUHvBgXEi
	 zs/x7DpP12htzc61BB6Dvi2oPifbO9JRFqDIOv/8tiX0qZlptFjy33yCRKgRF85M3
	 W672BY4pMFaEKTgQ/w==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MYNJq-1y1Bbt3Bkw-00Sorz; Tue, 24
 Nov 2026 21:58:44 +0100
Message-ID: <b6147b91-d8ef-4fcf-bd87-0bc30f2aa741@gmx.com>
Date: Wed, 25 Nov 2026 07:28:40 +1030
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
Subject: Re: [PATCH] btrfs: use super_set_uuid to support FS_IOC_GETFSUUID
To: Alexander Mikhalitsyn <alex@amutable.com>, dsterba@suse.com
Cc: mason@kernel.org, Lennart Poettering <lennart@amutable.com>,
 linux-btrfs@vger.kernel.org
References: <20261124154604.77736-1-alex@amutable.com>
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
In-Reply-To: <20261124154604.77736-1-alex@amutable.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:rPPgADQMF1oGL9xXSAoX3pHnQcpi5kPFYhDPo8JphhYALkQSqtl
 Rl1PhLbAxWWgyqLhQElutQKsWSC1SoP0jNC2gBQP8dXKHYllz5nVC7uG9fJVoDJPNoCc2Td
 pZyFXtvz/ARLffEXsnxO7AzzCi97Ab83lWmZ4MI5OMC692o1EzOR7WlvUp8YV1ASIUblSsl
 J5Ji9JjL5vYRhi6zNrNoA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:dvmKAttaW3g=;erVkOzj6BU7RyTC/glXrIUBCV3B
 egj/SMpdzyRCycdI64lEFMD6glia51hotqdaZsbB+t8kPzXOf086eBE7H5w1YKWH7nCgMMwox
 sbE1KPKUHpkE0Wj5/VS2BFwMRJj7WG6HzSFb+ox5IL5i83eqvhJeMtsPrCnKYAC1QcgQ9k9rU
 KMHjQ1kf3/1Jx9tWQZRyrPsPa4zrRklRWjkPTRTWoqpip+K+RdCR2q3ce2BDlepJ0ItDh/7Iu
 gW+yUbTT5rJIFX04bFOXgs9CJTQjRlfFDur+dKvjOt7HVx2egdK7lJtdQ5UrLmGlx8quAe7/1
 s9WJyBdJ/FHXhaAEt5rBLOJ5sDH7dodKZdUGWTnW3Yupht7O0kHRHChyTLwCNaEYP7a503XK2
 GFZ8Q+T3Bd4F+4JKgsbINsKIRrqIzUsIJalx1P1r12zt5i8LeWL0A0aeDyBvPG13N7GK6nv3W
 b3Jc1mvURTfOEb2QaYA7aLoiAwt1NKAnY4Stx9V0SQYfXktqgIfuOBnc6S8zlM9CQd+4oSFil
 v1IrB9slbFFdwuhiCQPK2316oL4YUicRYuJ5NC4OdmeYrDlQiYAgfoDFnuUDw9qdi4ci1Qc5e
 z17xa7KneKJJMqEZyXveTFKHE/bwAhTFPQTUpDxCEJKFae1Hk1SinJ3uAbG1ROSMW565PXcA9
 JaLApfKnhPlAjIHVWkLvGEuPJGEmiZYN85BFh+/7OMXXv1cVFV6sD2SBbqqOttolZ1xLgD5qy
 g38xlu/YlE1jxea7o9O4tJQFrji85dKFoNHmsy9xLMiDplfOgEDRBB3QizXTBmTW+u6jAhMBY
 l4QgipEZh2nrU0158/pLdxNjgRb/v75TGUZUvAiPOAIysojl1OAPHxWmNUQ7fPyP37zsNl7hM
 yziFeY1dtIILYjW1esgmj0A/WoNRrZuWOSiTU1B+9JoKLkIYmzqhZSPJB+61iMw9b5uVotnLr
 H7vW60P+TNyV6tRYDx+V8CfwWTw5Wh6KP8zmHCjZtaQPQDEyWXp0NEgKR14s6DEz4nMwEEZKH
 0Otp02rqeqsr9zBbY78HPTB482oS01bM+QALEpnu7NajNIrLrEYKqglxh6TKCAghv5f++dQqO
 B0V9SPVsqNFvHpgSBLgTMM+pXOoHU7LTtNJnhXL2z0Zr6pdMQ8liWL6HcnxL0j5EUqBTsIoJY
 vndAtsQU6m60EhHGl+LX2sWVAKGaDhqRRavHdwPBR//vfZV+vC8IA8zu78vkgqetsRY2ABWns
 jcIRqapYkmrT8NMUc6hougHXg1M33aCA/1uD4iTzZbivgiQF9uI7mcaFF4nvHcjzLZaqFHLTh
 2HcLb5TQK314XxnW+GZK+/mpQFweWR9BTbqtNVtZZRLCNdO4C3twE8CEDc5uPvEiY87Z894gW
 i4gt2m7AXWZ+eopsEEOJFlJf3gibNbO1c09yT22x4R7Cc9fsPzuz7d/J/IFklMnpP9W5LVjes
 VBesOKKc7MufAmNRYjx63YCigmTuck+MimneZmJtRZHwBI3n7tEOxO69ZStA1luYF6qgLd2Sj
 R9dMP2TivcEcf2npwjYbxV81Ygj5NQ2vPTWpiKyaITcl1vTv4F6JXzTcBs6BEpklNrdOPfaAI
 7eP60z/i9ZHHv6Ic6bLvdeaw8VHNoF+JL4pUP6UBWHXRxiIsrZgrexMQ0THWnNsNouGm2zLVR
 qEi89CuMiGDidpPbEhRs9osBimiMKq6wqU/cP14FVjgGh0oQ+QRr3fwJgM5qro9sJtLWromRm
 iM7JIKQd6qBapRKWirP5y0eqxyiv7rTkTGU2K5OV6dcHlEbqGm26iWByQ1z8Rsaw3R1WAXGSm
 K9ffqv3FFJuSXa/J6K4vKU7p3SMx9NB32i5IBd6oXq6pHMRpPAdvzIskX8HH6paMsEs1n7I31
 rUSYr0gGmPWR02r+rMTn79qjJceliVDBlt0mZgNFgWkB/3ACA9V48ZloNQaAJEBRrWYwlxk7q
 aLFu/SAx0pxJ+kz8Seop05BqryRFC8iP41po6x4PyUUSaM9tKLoN954j4MH/2ACC38Vcwn41r
 t8nxYCq9JW2k03vHnW9QWjm1Qrxb5a6l8rvJO3ZcLIKRyH5NkILJLLwTVg3VdAa5GVe1w64Dl
 uaAiyo/F8Dsgt/XofpGctObqdRSZ9uHpeQ/y0L6TSL7IOG988zWTITUr06tF2oS5fUNQ40jhx
 shqoD+vO/NrwmjrU14WLT8e9rQ1Ap1eb0hbQBf7zsmniRzLK+r+/14VT+AkfAoLcPPDI/5dzy
 0Ihu85viqQFAZKDGX3TIaLHAj19zNBn+Cm/kq8gtTnHr6XMJXmErdPaS/NyhtD13SrsR0UjsA
 gYxYwQ8+NclyPsk1f1WlMMBYbGuNQwLJFvmqqPDGXC214Oqpb/klhjE0aZH+HtKOzAkMwXGmJ
 tpWrG08hSI9zlnQafFjoWyX1PYRF1v80asCnLNK4oG9ZL4s4moTRnjtuNNrNv76szAj1XBkZd
 Wohxa8qd18GRykFRVIXk79/9Rt5Ke2dfl05Ze3NsdNvOcRhvtnT3L1amRC+VO0yxm9OfCtcLP
 C/qQtlGR2RdbxCNO0E33QzrGau3kGk3jK7qnmKBhhY4BaG/0RAkMczGEvtn/v3aPf3ccg5+tI
 fE6dCTYHuOxTjjEA/9yqnCPrcPrvVGR+eCw6h9VwRCxeVLFxNGDWFIpc/qW6VCc1fyiLrZ7No
 MpfErDZGkNt5ObTRb2Q5dRAQ2aCNCRe9maR5uJdHGgJBoFB2eyUn8vSXs18jXGi6Y7jR84xkt
 +Skdio+CrL1K1lWOpMo0cK9AOOQwJ5uDki3HHnVfu2DcizhVmYYHwuZArj3i/QkR3G+5kD9Ci
 XLHDRe2Mhb3huRc+weGTmuJ0/LdIBSayGl+dlIIjvGT3ZrFlHZeRCe3ziXE1ZA0nh3kfHkHBV
 jH2LGHhw54pOvX9B18gUKmCHk54Z2tWYFbxu8la+f8dsL6KJ9aJquOGB+FRL7epASHZs1vHOv
 K1GWR1mKyNcoTZ73YwjUWPERX5PwfgQM8uAieF8ZCcdnThdiMuCMo/wSEpR7FjWBkGL/4BnIl
 nPiQVjyp+E3/S2PZNqpYh8c9rQDBaOkZiPCI2A/cTAs+CGlOqEgFNWewjPGchIHWC0gTX1vhN
 oruQHmiy3pTqDOJrm+SNat/cBwGfGo95VHyVEtGJTZTxjEuQvlrpNsdRD+tFznNf44bs7osXx
 Tz5NmwKlgfXHWrQByzjOhl9g2Y8yukCkJInurMxq1WffJ793J51FDGBTB9xcFNw9LnU1KEn/H
 XnrQq2xQ1YPpxXfvSAQMAv3igHe/fJnDR0qa6FtkFRhGFVpjR+63Uiul3F2WhKf/H7tXM/MqF
 W5ODKLsCym3UwW3qNp4TeByU/XqGINaBxC3KmYWi5gCQSGMS1360EmjGK7JpUws1RqkMQMlfK
 eBKaSMMF97nJeRLi9nLIHVVQnSLVN4J7Rkh446XsnIvdoNftlsE+j+bdOY8W16e9HCNEmgt0D
 wpXRmKd53IAOki6fiPezfvC2PPiGorSo8JMEnWsHqW5giVNCs461bI20/6gyRqiVgyUz3YiAP
 39BZAwUttd6GyANF1l3lGU26JvPbM5TFpjwwzuyf58jSzyh5W4P6p3PYjmrdWKZM9MCB5HARA
 859xK+hx9QVtZMnuNNr6d07WDFVqWgQuHw7oSEpxIeU2N03opRcbJVKoa/5KMgSZnrm5KBPKk
 y3BYArwB3ckf246abutCI3/RhYpmxFQ/9WNqFp9ufqU1Q2Tilk/PA87F6EuJ9yz9hR36zXOoa
 hYoIMcfpjLGydmp9VIFBQCapuDZNKYA75IjE+9ze7SLTmCiZ6EZs6l6/n/pM9DH/+aNQ7lPK8
 E+woMvHaEuGfPK9dRIFyH6/+VGNF98kpQXVCd3rT2nDZmdtjYgVBJ1v9ENYjjQUlxFIqj19Kn
 ZV8d+34+Fllco0Unc0xSB6AUVaIjc7TDjGEG3J/YAY712I6T34a+IDwM9uZjr4A92i6bS+XEx
 o9sErvsnggC4ik/VRS+jXwAX4P1oOtfktV4DrXlnquidDuasgdiHClFVZOxe25DATVcu5HAh8
 7BdwXZd32gHNOF0tyPqwGachXx9kz+t7Ipz7hYJOP89TmHmfhOvIrfrMARPHVYSmz4MFFEDW7
 YZ4H3kmgUjZWDxnMsLnoLvQ8maQZXiHdWgDH4bxDs7UH7NCEB0/Ey1Ub0uMre2G+rjBxqN1HK
 pAUhY1QIxlq0Llwe5W3WmStC1WQPnctU4EMQW3YseV3IxBa8SSWF3o3r9M0enI1LN+aZP+m7l
 LAo54H6PRTWKIpF0hmOn0qeOUwJSWqoQeZnXeiDc8FfbelnSG1HCWSpHcA2pj6dT90yanG70W
 0KJ2/s3d/Obi7xF28yaT7gKH8SrsM2H1Zseq9RUTIuKIPv1GdrshTSSfO0GMRMSCly5XtmUSd
 Lmr9rqB082KspkEaHs7rmLxH3DnABvMWwLJm9jU6LlgfkCK5YXtbP33tJYKErAc/0tNsof0BH
 cvXz7ynmGRnOOCE5H8LL4Ekep7WRLtrmCaTjz+F9zGJySmVFJmSLm9O/qW2p32CY9QKk9uFUF
 I89Nsh08vPre97K5QjzRu89X/Hs9F07wCzXPBC9iLwkQIeRawYFmkyID3Wp062pw/edpZ7PZz
 zHgJK1xMXCZTZK9a1Mtmc4JRHyD6WbhJ0mQby3MqMBCVNP9JskIXjFrOZa0dmzJKC1YRf2G6u
 3Gas+V96CPhz1feLZ0mZ0ibnJO1CVYN11cMbXY2Owh0n/q3SD4gZAENwn8zCgVgNHQpEvHcdz
 2dKp+Y5sDhQdDiS/l9Q5I+nuLycgAOJrQ9pJdrd0+k5gk2CDI9U9lE+hI/c27ZkdIUx95A4xP
 CHL/mMcvAbrpzvFg/r8klyqv9SILGA330W4MKUGAIQ9q609I7iDAyCB4rdyhxgD1doo3WX8PL
 7aXBV7uOeG03TNGCEgVYw6Nsu3J+D3jbwa/X5CsLKMNCKvBOS8t9yMRImqaN8kktuDH9n5crS
 wFKZ30kyU0fVowQO8NLlkG+F1I49tmhgnXLYNR0dkqr2gjsy8Wu2bKX5u87YDw+s+qkVJBRT6
 Sz0RdTAWrnrcixkz7d+m+87BherzxHYnNdSNOXSbawYLmcRkbhLLVQIkxwnjzgUKL2KPV2iHa
 IimYx/oMrULtYGCWM7HJCVXePlOwLwnMUYrxTHUtkalO986sTlYhusVcIx7u6zPKVcfV1zbiK
 H+MIPiuMHtD1DDtAm7tbLYMbzM8yZq8bU/BdKGfu7CYqZ4VgIRWxdEFR2jrCr5w0fexxkKqWT
 Uyv/BKdBs3OA9qXCW3hsk1QBKKknGZ8vx+3LuvshHZfHGYqAf6BCABOc1DplVVIzttaDQMqLX
 /U09CX4C/bs0NEi66qggGMNB7QCuOw/odZSTQmxZMYjgF0/AICBxhUH2LNjWZLuuUV0HnoDz6
 UzqPEDLGwPoTP6oaB96fc83hQ34PYNU8zau7QbqLG6nzQS4+BNhvOuXR0U/mhZavscSzgHUC+
 9NhznM5xr2HT8ZwP+Z48ze2XQCd6W/ST1lpuUvI7vCykV7Dj5GXuq8VhU8PCS94/gLiq17Vhz
 QZsqUUCb9ZzGOp6ZhKAZtHhUM+hqdhDpN3uUbPgvWmW0e8UKaBTaZB/O1+6PfRW9g8OV9LFnd
 hIKg+KJjs4UPf7/2iyUjXlTyO5saBVJ1qU7FWOOgWl/oeZHi/dmOhDoY65R1A6IpgY7uiuCOp
 trzf1oPpcoBq9E7Wkt0RsWpQ5bThfR9yuCsZpUtw30BDBAlHr9GYMLxYHrnw2a1wW+VSL3mdX
 CfY98BpRaCxGXgucD5xC0l7UABa5MTI/Pf+uOWNoWkcYDnMEgTOqfm9qRQh1Y2e/kl463BWlS
 rchdI7z5L0kgrI5OcBI8wW6O1G/0CaBnXSEYf5u4iHeNYWnOpVUYxPHsp6R/pRTP4I+sCeeOx
 15nZfEt2dv1WPqAmpFwncymk036hvG14AEDHV3swFyCYadmVKljWymrN9RIlYoEgBbHGXi9dk
 R2dndhTSeXvXEjcUtE0WwWg/Yb/iCJD0YV0w8DFyqyUeOzFuSBTMPPvtny+VxiBKUX8quT3Zg
 Eq2MlHGklTPitT4S80NBOJs/RM5y/fbrN6vNJTk9Lbn+stcLoU632MNkmktiZfIp/aI5nPDci
 Hyr3h6p10Z/Qrr4Hjib3z7lKi/OiVOt/YxcceQp32tGvmBcc2/oiBJPj8klLJDClrASljKDLt
 R3PzUQcrc5IzWBo6JjMhiZFLx0XLpYp9qWjiv3Aq4wKA0H6dz8mKIEsTPboXwSsGwPguKGceq
 9vOuKdpt9GoEYTcnMoGI9PrA/0L7pyyJ4tSsFORek3+OygjjOAILiZCvCOUKmamJJrAdMVp7E
 rkeHiv/c6RbJk1+MgOp83aCNd6npDYxsDUnsJeiWKFhF0TKOCisEZlF3w1Sb40KWL+rPvENq+
 Nn20bc9hr6JcVo5GDjgb8755ZVnuQ25F9BW/ifJ2u2RrmfbxpbnvSXRlVO0m5goT8lDW8m9ZY
 LcLfwaoSV/UKkNfsqhdA5a49wY7RSn5Nma+QE7e5VlzLVDaYmNSki+5sctw+ASPEBWtl+YL7+
 zmmtn89sIvhCknvbW+3OXRqwFWuRm0FHsJO6Lj4Zb2tcnI3pQYTQr3FqYOm2rG4uGikI4GK/2
 3K/US2XQTc2HdqF9iIUlerELWXSjVKTjWoWAAAEVhFXfntPGWAO1e+qILItz5c7FTB9W7upuq
 N8jhJawwGpaF6tbgiopwd8ClRRoWpLF0WQa834tVnnLdy9Obbd3rIPgG3tXGf5WHh07NE3jZ5
 fqiuFC438hdgPSjY8BhaNoBN9q1rXjoPNA2vaJLqCPKWUuY7OOyaiU5t/VME3DW4/E4BNhxCU
 rJYevuDYt4/+qqHwgDRyylig2w7JtymJzHCSo6cl8+/gHd1pfBtD/sOeTrm4wv/MfRanWwtix
 eCIsgE/JGoNBZvwf9s6Z9RbI1EbZUVW5ffvnIx+JToAa0G0U5mgLWz0rVxEFJMVq9hnz975KL
 JITfD+RzymzUVdXA1pwBTPwxmmeUv1N9YtmPu1FwF8XD8uHDZE0xMiUZLmt06fnACpjL83jsb
 OvXE2gH8Gb4C9Pqwv0Bi3nPnVRlJqaMIUe0j0qz6MLRXbGAyep6xJepNin2bcE4659EwfrPDJ
 kNleTZZ+HGS8J/KyGVLuvBUIoYvxINk7Yw9cobu28nMYc+UJKGVQkZpdq9MBMGncjcxkBNgKH
 xiS/RbBSgFLYMiFSbgTSy3oL2EMfkvD5zm0/igrB6Sr53clyvBJOKtfLNEWb8oR88STGhYDJ5
 smscx9QpRo/qdRvkbttWgy/gUftYU5eNm29GK9JFpaZw5hukRG4cZFSsEPUDzaWrzdpC6FLtD
 3TwFF+hZVbLN5hVVQ9x8upioMPgdUmo+BWHGGmB21JVDeCTRmL6DtllqJl/ftHN+VzJKka9Q5
 dTw0cMIzfQlh7Bqt1l9xv7ZjSCkZGcb+hN60mM+IRGQc3VWd1p4bszsDc6fpIDK/yY14sG



=E5=9C=A8 2026/11/25 02:16, Alexander Mikhalitsyn =E5=86=99=E9=81=93:
> Currently, FS_IOC_GETFSUUID fails with ENOTTY. To fix that we should
> use super_set_uuid() as other filesystems do.
>=20
> Reported-by: Lennart Poettering <lennart@amutable.com>
> Signed-off-by: Alexander Mikhalitsyn <alex@amutable.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Will push it for for-next if no other review.

Thanks,
Qu

> ---
>   fs/btrfs/disk-io.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index d8d433ac458b..fde9f4c4ea11 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3616,9 +3616,9 @@ int __cold open_ctree(struct super_block *sb, stru=
ct btrfs_fs_devices *fs_device
>   	 * on-disk UUID directly from the super_copy.
>   	 */
>   	if (fs_info->fs_devices->temp_fsid)
> -		memcpy(&sb->s_uuid, fs_info->super_copy->fsid, BTRFS_FSID_SIZE);
> +		super_set_uuid(sb, fs_info->super_copy->fsid, BTRFS_FSID_SIZE);
>   	else
> -		memcpy(&sb->s_uuid, fs_info->fs_devices->fsid, BTRFS_FSID_SIZE);
> +		super_set_uuid(sb, fs_info->fs_devices->fsid, BTRFS_FSID_SIZE);
>  =20
>   	mutex_lock(&fs_info->chunk_mutex);
>   	ret =3D btrfs_read_sys_array(fs_info);

