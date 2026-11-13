Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.15.15
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794606108;
	b=draFmD+GmrPILoXeD65BiHd9yDA5iyjRkuKy5uTFcR4MUbdXa2w6xMmTuliTtdPI/Ogo
	 mSRzh5ccGrdzmz19O6mJYw6k97jMvLAC7hVYdJWwG3rJOYxS9ubiHAoqju0F+ThGQRgTx
	 mY+V/QZREQV7096uQ+r4Eeg1d7nOpUmy7FRVYVuqtSk/VG1NB1iMEfOpZ9T/KxG/+/ZbG
	 0K3hnM5X0dD1OFNrc18V9364TWrklEAR3VRLI147txjQtKENlimVKqnaq3Z4wYKzFgif8
	 iKJ4VJIRXZet4ysQdh06swNb9ISRxpoYiidRGksuz+4Du3fOw1TNujyUM372a1dGS8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794606108;
	h=DMARC-Filter:DKIM2-Signature:Message-Instance:DKIM-Signature:
	 X-UI-Sender-Class:Received:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:References:Content-Language:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:
	 UI-OutboundReport;
	bh=uoyyjV6HZX3lG49xW/DIs+pEE1sOEyE2U2vRkzxYwc0=;
	b=bUyWFzQ2JHHoSCvp5XoGTozN0NGpSZT3IndjzM7FTydGpbXo0uXy2r44MleI9anCYU01
	 t62l3lOgqYz1QdYq/g3bh/GwZ6oc39xL/0Mg2vWpBtgYInbHE17HXxcGgl0wL8RkkydwY
	 4RhyMyeD8vRjADXL+jRVyHcbYuphLPKjYYZqsIyZ8EGDATDvW/O6Mt+Rc33f9uVRaSj7M
	 TtbPqL7SjRYK/CWU+drFSVTBtJDuq2lgTV5goxXQZtNRIwWP6UiyOkFI9T18aZPWGacB8
	 /ewBUL8VW7sC3xpcyMwN/Vf5xSCSGdMZ/Y6e1ZUD0vPvkYLb6PsRtfOfwmLutDSpYxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=obIb4HP6;
	arc=none smtp.remote-ip=212.227.15.15
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011CD606A330
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 21:41:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 011CD606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=obIb4HP6
DKIM2-Signature:  i=1; m=1; t=1794606105;
 mf=PHF1d2VucnVvLmJ0cmZzQGdteC5jb20+;
 rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
 d=gmx.com;
 s=s31663417:rsa-sha256:lpgbnES5ZV92CpqrvFibXAzbT6D+
   DYe+Ccx01wpZ4PUDmlzmICkGSD3vK2SAb9KxJiqxYOV9A/SbmHEQpuCrwC5a6D3wAxEbgCuJioz
   aQOZFJ6/MVh30DxAgFjUzaauayCHtMcDQINGepp/3PgEU75kZsJtA83l9f3RIg1gd5I7FeAFAY/
   IoWp47gmuxYWO1vzqRQkBWgCgr7nkI4B7+HJ+iaHCdRflZAiDAMkU4kxdJ5KAlF/HMm3nBM6KwG
   5jdyIG0NH9xaZUa0ggvTldyDd8et2Thy4JUn0sYIyeHwDaMHOvkBo4NnbnreiB+8WuP9X2stvr3
   IC6NGGOHmqm8Yg==;
Message-Instance:  m=1;
 h=sha256:
   2fB7d/vWgsEq0mWUYTYEemuFfYiyEJGlqOiXJCManrQ=:
   QBhb7mqUadmIG2KR+Hep/JzYherRt8ZBWtRx1h82zLc=,
  sha512:
   SroMDnIRrFQMLssDM0WbTudSHLNd3cD00TA8H8fX2ijHyIGN2kZFtPIZC8o27ZYCaboQrD7uX62LUTJpZiYcvw==:
   FtqXO484hBPzzdOM85nyw67RJETHN59iYdab2F6vepSrC/dIW0uDvvEVB3ku1BiTGO+w7xixdpaTkd4zy81QGw==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1794606105; x=1795210905; i=quwenruo.btrfs@gmx.com;
	bh=uoyyjV6HZX3lG49xW/DIs+pEE1sOEyE2U2vRkzxYwc0=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=obIb4HP6iq+P/n+thSzdk5L2rbWnRBE0XmIQzgZMr2ucmDsTHAJxM/2CTfxUCeYL
	 j77WKQKLwuGFLnAcbKIoklFX/LkEQHu47mIRnU/Gv6Ku7gvZWFcNHauePnG0skOSg
	 z3yKWET0nnma6mAkQY5GcSZA1x4VNiPPjHSgKXJqNkVENIb68g+7s/4swe8e82rhr
	 rMlsGj6beO6LUJ8oHSflzyApfJ402Y/Dtei2VWbfbaTGSUUJD9GBnHH4F3XLQOo9f
	 fGTFYm5VZ3OSsRp+If+KrMsfaac84FaBDY0qpjDjoYRdR2JqTINxJ3eTRE0kO1Rcm
	 MIJ8JpWzYHrmMO3i+w==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MUGi9-1x0rnv18Pz-00X3ch; Fri, 13
 Nov 2026 22:41:45 +0100
Message-ID: <3778f217-7b82-43fc-a582-971faeaa2f18@gmx.com>
Date: Sat, 14 Nov 2026 08:11:42 +1030
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
Subject: Re: [PATCH v2] btrfs: improve the algorithmic efficiency of
 btrfs_check_rw_degradable()
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <33b22f1310f84ccf116f1beeb1c2ccfbe50bca9d.1794592972.git.fdmanana@suse.com>
 <4985458289decdf18db45d0f7b6db8b79a44f4df.1794593883.git.fdmanana@suse.com>
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
In-Reply-To: <4985458289decdf18db45d0f7b6db8b79a44f4df.1794593883.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:e/+1YDZgKrw966hk928AXtNhtWhWQ4gQ9OfAVeEolQsbpHtpRro
 9t0T03ksut2xaTCoBNAlg8AI20CyzjVda/Eh2AsAtSgNni58ReIN0KgTN4mRRfFfVZJA4XQ
 heGGprNkW5xnks1JUf4NeLTOUxVDDDd/oL4EYc6gc1lifS0++kKxyvEZ4o62viWzzMeGgZm
 SWGZLAJG7h5I92t48spKQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:4AxfEe28BFA=;aD0l2bhJl94pnseJrG1rb8n51RT
 x1bW4EBjgtFINxNvPL+RKq+rl8C7E4i7CQjiSVGsp3iK3CygCvxiHmPuOstdhwbtPZgaqEQro
 uMbvm8PRaQTeNTH/ZpQK/tdqHeUWOQhOYNlxooexF84+wvYp9UBYkYAjPn05xGJybiilXDk44
 VKB9d0U5ZYHKefd3X9yf0AsFiYbfzppNUyj3nZePbB9QliGdxkTVLtNaftzOHVujFAT2qr+Go
 SUkxJXB5GzbBpkAkNZ8YtbjAk6ZH8fL+oix5mItpcdNqEBl4hIpflvuSqeXZNU4IFWym5KuG8
 4u+Q3bRlAWb9Ij91K4DdKjnb9fNbKyMx2MD6vEnvgbD0kq5xVbUWj69EI41Nzfjx0iOXkwj5q
 1t0rjSQravgo3/r4r91VD1qFd/s/mszRlB0WfIJxMrXJ0fWPVKL/TG6fdNfF+wbdsWtD7X6oQ
 4VpTXYUZ5il9Cd53xbtIheuj/WW4dycZXWjKbggO+ewZ0GUoH6GLU91m2lm40mPsnrh97+sKk
 7SZF/ezACUww55KsEdq7/h907RJ36/7UbsfewzwEfwcjpGryRWLmRx4iaFBifm+wnxT1dkPyk
 K14HEts6C8wppeCNT5NfedF8Z+TeUYvVKRwdZ60zTunIJCSXiQ+E5ug5L3iRZPGhSg4JcXgS3
 xe+KOnAp9/60GQbYtpHHELtrt/TECj+xcEzHj5c+zM1hOn9XL6WlgO17APC33C2te+UI8wbYP
 bGhPp7gZ+k7Q7M2uJMEfCA8ukACV0yUpPpvaHii9cHgvGpeC3I25EmByygaV9jId73Vf3QGFT
 YOAnhksS2FOKA31NLDkqSHKllNURch6Ni2W+jbvmpvzdsRVlBPIo9P00xL5wBMx7660XiLeIV
 UHlNLsqppWD+T/6YW87XKEV5JG1JSzqZty0hJsVDovAcwpdmPzDML1kZ7woSZjjv5HEMcKgqt
 ocqlGya3jisHpwS5A1uooZDetIPhgTN0UzCpZGPD60RcvBQBxrVHIR8Yimlzi3ifyJJi0ed4S
 VBDib2bMhzunmzNde8BrG427QOCGDCyGvy3uW+QtHWZKJqVT8w/fGE+rrmoGNX9Yze2TB6Qrq
 +rNcs65SV7J8vBcsrl4AX/AGpX5npWZvlAblBHdWjhEcwnd0qWouRvm7Y0AKH74PaChtYRZTO
 d1c3zZlkn9WtwYVoHofVWAD9DgHRJMkT7/MmTszbNX/Rv4xBVeNNu96gbZprFROFiL7s97z1S
 MGqNW3u9iHTOGQd5TMrGhIHsuBFhyYWxLMNa9ez+xVUkZ4C07R8n6AcpnDrRoHGbLaDfoaPVt
 m+kIlVJsIzVO5sIX9wh/fS2h5lJVDq8lNPDuBPzNcmY4t/fCd6/98x+DYWKVmmU2QOwTosa06
 8hsjXJimgGdMn8x/cQRB893PYsoH8xoEJIaUrrQNHGgjSS5osMA2TMwZrbtoxhzBwNX31i95s
 erjNslCm2rvFd88o0Zdd9V3RfQaGSLfOOBHBcv9NuTBu27LRoNE2PwceAVnylsXwKJx34N+gj
 Ul3M3GDN0UFXK/dpjOA9MUVSxje6KB2QkIdp65YV4yrbAouK/n+AlDlVjBtxAXhczYrkMacRi
 Zt5Uyp9corZX0en+vIMu4cy3OPIrGuVieR9bYIpiuho22rPNLrC2VyvpV5ClfEgt2O0GhW/7J
 V+ETASXAeNrKGiHiNhVX1PcWqscnXTTQlElMuNz3pm/EsRbZiM3ukXHUKAnxq3nyHZ7xROi40
 /Rvx0ITerjMXGOc99JnQWlkRP2qdqO6keB/Vi1xiQW+eB2rC1WCIMhkhA5ulCyLrih2orZUYW
 5ZAoW8bB9gnW8eYw1nVjrpTrshApK/rFZtp4qQmzgSbhre+poaMPepy5NjSC08iFHWJgqzvkz
 QF0Z6cuEUUWwaFuafC1KPGlGjFWJbSx74gITeQ9xBwAvkZ1keuUzRc3v6yY+Qw1G4n1yYkJlL
 EfDZsaseUMzBiEL3e64b9QfjY+9d0FHvQyDbRdz3rkPEFZn+ruw1+LEoNEP6aCb1GUOOTHmtT
 kmManH5ksvV4qe20Nv57Uzr1sRAgS6qActxxzVoF8mRjz8MyCCIPobnXOL1IYTEyZerTAcBzu
 ox1ydJI/rdl0qq+Fi1Wex1CHPDlYh0QBem21SsxOwg8JwD20b8MfvM3nI2fgVaK8KCZnEwlp2
 q6K+kHBA04jB6v/ejYkj1QzS37QlaFi1yx6PGSjhzUzzaZFh28cujMnabJmjTOqQx5L04i3zb
 Q1YkERc7tYQEr5AEiSgk0Zw6H/Yfow8Co6BRn3fHHYy1qgJYxN/3cGTSnzlpeyz4euaI3pkQA
 q4kSgtXHkAb6GjluZ2v0NCXtalifFtnUX+m8cyp+vqMs/4putt1JekLaz9m6V0vINbxdWQHin
 sCWLxF1FpWuTnO1Av0kOiSw5OYx7FAu6LMqfB+tmY8Huf9HnN8PE3Q/klUjJchoySAZK3gzAM
 ceTpzhQxlVwaScbeBzKZAwdzdwhvVdjXQ0dtsjumfi/k7adDouHPrb379FRGUhrG4WIl8A2UV
 QXL2tYq+gkG9rZyyWlXgPRjHLF7KJaFz79bEa4zjvzilRT5Yr/mwc5ZrFdzKC/zsiLmdyasft
 DNii4XtTz/tzFLg4ehWAKqdXtPhblBij8qP5Skk2LakS/yrWvEMKI8ZNzR3cYQiLdAIe00z25
 TOvAEJ2pDiXSaFE5Dsn5TV4wmAp3soo8C1morMMvjVcbivD9F5V1ZhV1Qtr+0yKahjVoTGC5K
 3PSqDMeNlDxTBcAjiCGDG/n3kSpFBP4UUx61vMUnCkc5AmCjbE8QyntcZDL30ywP/X6Jxqfj1
 koA4bSikpxDUKN6ynF1y7p+6VeW06rhFhIiR2HbmMLssCfyzP/Y/9e+2rjBCzog4jNhGMwBjt
 hbn7mh1I4iUR+KpAkbdtf3PUlBQklLLD2TUVCTfTxocdX2FtC7VR8u4W7eeWMBoy3X33ijkV4
 04893pZgGicVAAH7/XNT3XTEKUn+UpvWNkNHnoqUBMjecbFOb3d/2nAtyq1RFo1FQwqHmpslS
 8iHz7BgwqfH9gtw5CBLlkh4+Dh6ACo0OELbla6XlY1sUc2xgNz5ayqNPuQ6ZFPFjzdPCNfXI1
 De+LELXlQhrJXEitoSXXxJj1mGaA4UvoncQQ2pfUpM23mTDK+e6OdOJpZCjpfebHZp8QmLZ30
 NoQ5Md7NisH5zxMi+IbQaFWgMTrSbpxnUFmUZR4uHepkKxjXLEWvUlkX2PgLYQx8i3sjMtgt0
 rEiPdqgxkJKGhzGB46iXjCaTo4OiRILSr/e/4ZVCt0cjqa7FYwmgrn0Fp1GOlnd0PJWQ7OsRp
 H3tvL1onppOBdvF1/eII4HuZVPMzRFu6t9pv80ZY5F9sDdTGpJ6qOec/Qae1ZKBNulZfozj8I
 v7Yq5C7viVYq9/NNTkngxOmS2kEznq9CjBNpZcsZ4j+WRqxTu6XrG5okdVD591QonQ9z9/lfm
 xqpyPo5qyke3k7+fBlLnfw6ZzCwjrbQE2POJcE3+Z2vQyKkvTv6kUu3UwuW+tchKnnU1yssSc
 Mv6r5vVzgX6yPH5CHZhkt4m76BnoWj7Y+OSCnKTNHWwr9eWNE7V1fhRjhslPpMWlRSN0xRcJM
 qLr2piQGff08QhaONiautmOfNG11GisGUQm6E6rLPbfFMbYqZwCCvwftPmxNNqDKI/lqH2UuE
 KJZ9ZByso8mCjBTrBUzXrICZnvYVfvYYEoAcZ6r4b8gP3rapL/rDEj6Sq/12Yo9c3dWKuysEA
 pJPqHpXBhXzZh/0jB1LzG31xIlIlvSYApiqoe4E4U6xiBd1Megzp2fy5/mqIQ81RS7jCHgtWd
 sYeUICnJBAzdb1dhZfh83cwDnc3h9PJE2OaeHZOmGQ29XxNFRFy/KCK/JqgCuKbvvS39cqADR
 +q0unaRbz6WaJvArwhQASkCtSgIAIM17iatxor9utwoXw2k6IvEcdos6YF33QT99Ab4VvmstX
 x55Jr/UsAvDv+olp9ok8OZoPagrWikvWr9/hq4c3hSpQyfL2eXJAYY+llfvLKhbai/mqxYuXZ
 0SQ+/OwM93UXS7lBzT+GiMPErJ2b2CPMAFGRW/Z0U308CAe29n6ESyQ1BHJOzvl8mN6+IeOoN
 o1vaTPKj7PJuwZ7xToOlm+PFThEZUWmpv7FiAVTLRnKMAn/7o5m09Xl0Npq7neIyrr6ItAIOj
 QgjKYCSimk+HJqSlA9XZ+bUPsr9HR9MJj3gnA9JyoXlNtgcR40pHiym5IW2yC6jw91rF6pWSo
 9FRupZjSMI+J8nFDWlbOQzhIfq8HaTykAnd+FkNu1awfJGVCyelC21+C56N1Y9GhGmy355CAu
 sZug+aNpswp00IkAanVK46J5/rR1Y1CnEr/xotQMdPbD2DAk9EyFjk5OuRZMAqYougzFYRSUI
 YJNarMCb6MDiBpooBecQZxkp5o1UxBcqF5qgIwLkzqZEo4VM1b/Unf7QSmtmnVV+rmbProKgi
 XqAY3IyUj2s8DIa8tWDEoRoYBm2OrPGQBwWVUnnPA7ik4BG/TB0Ptg0HH17CvKIdarhA56ccE
 rCpP5Fn/qzGmEu8g2gPgu8vdOA68HE8OQQ/mqqRy5NjXVT/juPAck9NSlP/49ffPBmTQSDL43
 ayL2O/6mpSxBIC/H/T2PjoT+xco0WvHfpHk8OBdBY5fnmeDlhdEdrS1sp9BVVmuzMTOWY4JNj
 DRQRU0PsXSdJDMWOjJ3mx+TpZGBBy+UqELTkA+fxj3jqQcdabNpk37KnYj5lGvXOggEMgrfYY
 D/PlQchEPLplEvTkhI0tAB/N++bErZFKf6iEyVNixhgcXuY+C+VwB1wiSY4Y12JKInt9rmRFt
 FeowP8t80xix9H7eci5rzOB3NV9tAPn5Cgd0366Fi1TWITF6DKbYDUVOfqWBvxEzmkL0dl0pB
 FLhja8urCmCvB94aB+GD/xd1UKZaKgtCqs/As9euNf2Ka/LQsiPR0aBVLHLOgnIddS9G6MO/K
 hqz6nkwf6JJ2NrqD35+4oC5SJjN8SRvOMWsa2uPjIYzojADZS8yyGLaOUd7ZgCUOM4+2RjJPe
 njNoYStc3lkaQhdwqGCE06wMEC7ZNZFhiQQGHgBDpyrE3+lmszpZo/xpY/R8oeVKwQNOARDnC
 amUwSnQr+XRDOexg6mE4FvlThrefRZ+cc8KrsFGJegnEBAub4EkBves6e3g+f1b7S+Kl/WNWt
 S5uIp2Hqf89WFlM05ruinECY/e+XIbWOH6a6RfmRommfQlJR1bvxVTIsZCDSZZ3caumsJjCJy
 gaHfH0CvuTDIaSV8eYqs5hkrcT5BxhbhGwp4ZzCmQmBRjQQxpzfRdcN63GUsZ92UUvRvyBFgF
 8psOZf8aB8tcFRbA+VnDQ2ch93rzDjN6kkgY7N9SxclAj0OWzsC6VWKc8TXzyqXXsOGUEs7w9
 nLqRS2gkZoL4YFjFWFHHB/1D77Nzq8hlBE3/wmj5H3N3jtX7gt18aIXVxPdCIGK5HvZIEy6HG
 3jiHeg0MzBGJTq6TD6bTciB6xr4k/29GVlKhtkkV85JOBbW+sJWTn9aUripG5ygD52eiWM8bE
 KAaqtyaiVSMcmlwDNQNRf3Wo4oVxjCPjdiABIZev7ckUTC3GGWRNjdSy6NU46JCL4RjTyzvg7
 zt+31V39LzWmBcOG1RHU7kvWANF4OcMtgpRNonjkm0Ix5S84DdQQCkziNAVwiH32vW6TA6U5z
 j+Hlt7VNtlJgJWRClrC4NmvVUqTjD/mK548WxM1jMJwRqVQq2qBlMGKMgjxUC71L0J/ktgd2S
 wiZ44gCtigmZr6SCAhU+Z0holeW5gcwx/KnDfiv4Xdz6feiHGytTme45Kg6a3yylQNQNt8814
 PBIBft7PCaC4ttboGE+oxc6p3XCtF5o5E4iW5UwM9DDNDT1/CmQ8TWjngJ+XLvc6B5PoBJzal
 nyylH25I4oWh/AGCa0rH4//L/DkSgIykQOz67eNiNBtqMVea9bvJbd422e2OZaKHF7y2xW6WJ
 vCa1z7ZXyW7PvE49SID47rac924+CNTHwHdJ/x85qvTONjZVf+vC4Ssmz9tBDuYvHrExWI6AX
 AQXQDeofTEgaGBk5HgajhScBWPvJ1Fa2bLFz72Plb2960PphWKBxRWi1Izom3FTkJEtBXD3Ef
 9FMn8UTqA+LaaBFq5IDef+qHsqM7loKQfE2jp7iCkBb/y0WAQ5XYbV9yGICdJbvWHL7dMAqjt
 WffbDRuXv+BcfQH2bqVZYkwm63X3YBy3fW5422dSo1t3weCOqwkyRUD5GXyQ+ppr65Kt9iVRO
 lzRSB8NjgVTqlo0SvzzDnN2o+c23aF+u57ImzJgLZsvsFQkIymNG4c1JOKciUiCg2EDnBf1BT
 gL1JpfqSqz3bFrdr2STZ3orxCzkLNhovXS8ehdjTkcNSS2oWyl/lUDCJTGQVSsdAWiDVj5ICH
 5YoElYT74o5F4d/PpJkQyZeUvnbS07RH69yNStkR82NoWmmOd0uOST8ByDUS6qPiNYCl3+ZEI
 zNwnQaihSS5aiqIIkeoV8aKnVP1x7Ohm7c3zZQpXANT/LQO1GGyRlqJ75WMBCi43IGFY1s8C6
 u/QSaLKRw3egNCfAcLIbyED3gO8IQpPGRsgW6HAOevpaKdo/vm1DiUGL320kfIaPAWBA1na6O
 /os73kOy2Or79R9Q6VuGL8wZ1rMqYFJ7PSzwzEOVMNn0Fh3kURyf9TTq7rQ3Xc8Pu68jyrVDa
 B+yJaU/NpPt7KlLq7Ueyf/bvlWz5Ih3xPwuRV/wUvDWckpD77ZJfE2GyXrl+TwG56kLfwBZk6
 Ml48Eo9hLuQjZhJxtAv5GOFWjJhMWzZzGO/jH/78fZwuXU7kh4jGOPTrjrX7vxDrai/fYXTBC
 uMJ3kTj/TtLhZDkXAwAeNfrrdHL7kYSoGublZEIiUHBCJJNEhhj0YKpbGmvASVYhpKd0gflTv
 insnFoqjnHPTaTl+G34DNepyUa09P79JkniEmEzvQOhcjsTFpCOZc++lUdAl8HLNnTpBS6CzY
 ed4bbFw1RlQmG8AcaArXX/07NTZnQZae28P2lE4ece2Ll4183PIWel2Vhe6hqO4w9W7v+E/Zw
 3wKbRHuC/Pqcs2+gMM+CSai4O59Bt8WXXS07jk0Q10wA17lsXAj/4hHz25nvdODPIBwDtxxVf
 346rClXmOR7jBB7wyPxNnV4uwEybfTXTk2M7h3PFZpDPUoFhXgMFj9FGVd+FzN75e579dZyiY
 rcwKPuRs/17MNJN7EjbGXvj+sJ1AKOIQBGjMWKhxcBsXTPPGHKimnPQIw1uoUp1SiP259DX9q
 IabWPH8XInhXJeWI3t1WZr+41bfm8mptxu0sOKlQkcmh37rsew+Wy9wl5ASn86B9DyYMV9eKK
 iJmZ5CvQqZUHRc4B7840nPszkr9UI71+2AkSdY2ZjMDUXVdLq3luCo3zxtcSbWR6B7J7yOYDO
 hltCLQXpqgD3meevHnMMxTUIxqiAupPu3ETckzubYnJ4Pb45xgY+KIFjy5KyxCLR2kxb6LExT
 lzVk68iMNfEYMQCaHrw==



=E5=9C=A8 2026/11/14 04:49, fdmanana@kernel.org =E5=86=99=E9=81=93:
> From: Filipe Manana <fdmanana@suse.com>
>=20
> The current algorithmic complexity is O(N log N) since we do a rbtree
> search (O(log N)) for every chunk map (until we find one with too many
> missing devices). If we have a large filesystem with many thousands of
> chunks this can take some time.
>=20
> Improve this by grabbing the first chunk map using rb_first_cached()
> and then move on to the next with rb_next(), which is way more efficient
> then doing a full rbtree search every time. Keep the read lock that
> protects the chunk map rbtree and release it periodically if needed,
> and when that happens do a regular rbtree search and keep using rb_next(=
).
>=20
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>=20
> V2: Fix a chunk map leak pointed by Sashiko.
>=20
>   fs/btrfs/volumes.c | 38 ++++++++++++++++++++++++++++++--------
>   1 file changed, 30 insertions(+), 8 deletions(-)
>=20
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 590d9bd4130c..a8e381565eb2 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -8174,16 +8174,21 @@ int btrfs_read_sys_array(struct btrfs_fs_info *f=
s_info)
>   bool btrfs_check_rw_degradable(struct btrfs_fs_info *fs_info,
>   					struct btrfs_device *failing_dev)
>   {
> +	struct rb_node *node;
>   	struct btrfs_chunk_map *map;
> -	u64 next_start;
>   	bool ret =3D true;
>  =20
> -	map =3D btrfs_find_chunk_map(fs_info, 0, U64_MAX);
> +	read_lock(&fs_info->mapping_tree_lock);
> +	node =3D rb_first_cached(&fs_info->mapping_tree);
>   	/* No chunk at all? Return false anyway */
> -	if (!map)
> +	if (!node) {
> +		read_unlock(&fs_info->mapping_tree_lock);
>   		return false;
> +	}
> +	map =3D rb_entry(node, struct btrfs_chunk_map, rb_node);
>  =20
>   	while (map) {
> +		const u64 next_start =3D map->start + map->chunk_len;
>   		int missing =3D 0;
>   		int max_tolerated;
>   		int i;
> @@ -8206,15 +8211,32 @@ bool btrfs_check_rw_degradable(struct btrfs_fs_i=
nfo *fs_info,
>   				btrfs_warn(fs_info,
>   	"chunk %llu missing %d devices, max tolerance is %d for writable moun=
t",
>   				   map->start, missing, max_tolerated);
> -			btrfs_free_chunk_map(map);
> -			return false;
> +			ret =3D false;
> +			break;
>   		}
> -		next_start =3D map->start + map->chunk_len;
> -		btrfs_free_chunk_map(map);
>  =20
> -		map =3D btrfs_find_chunk_map(fs_info, next_start, U64_MAX - next_star=
t);
> +		if (cond_resched_rwlock_read(&fs_info->mapping_tree_lock)) {
> +			map =3D btrfs_find_chunk_map_nolock(fs_info, next_start,
> +							  U64_MAX - next_start);
> +			/*
> +			 * We got the chunk map while holding the lock so it's
> +			 * in the tree and we don't need to keep a ref on it.
> +			 * When we don't resched we keep getting chunk maps
> +			 * without taking refs on them, since we are holding
> +			 * the tree lock.
> +			 */
> +			btrfs_free_chunk_map(map);
> +		} else {
> +			node =3D rb_next(&map->rb_node);
> +			if (node)
> +				map =3D rb_entry(node, struct btrfs_chunk_map, rb_node);
> +			else
> +				map =3D NULL;
> +		}
>   	}
>  =20
> +	read_unlock(&fs_info->mapping_tree_lock);
> +
>   	return ret;
>   }
>  =20

