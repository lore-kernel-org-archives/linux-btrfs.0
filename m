Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.17.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795648018;
	b=VA9qUIbTuVUcx61amwMpE5s/PkXaQirSXORtvQ6gZnPR2A65y+q+g4zx0ftYVq9WqtAt
	 VFiqyRnfUcodA11++Pld+jqacmywusWjDM670Zm2cW8+SgK+qwV+y7fSsPw32NKE+T07Q
	 xFaVI5ShbZ501tC9i3Ek1lw6S2V+mpO9nRiZE3aj/I8nNDcNSQ4L1gQlo2PPBqXDxYYx4
	 fPgAeHGeQhbo4QB5SyjRwrWp7WZ3xHfAocPS5LG1yvd/9iCahhbVglP6jzyTu9zXOPOOZ
	 nW4mQ/VL5QFk89oOnIMQ9FNSbc4WHrvRU5B9r3Ws078cW7Oj6KGb158ItsB9D11e1HQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795648018;
	h=DMARC-Filter:DKIM2-Signature:Message-Instance:DKIM-Signature:
	 X-UI-Sender-Class:Received:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:References:Content-Language:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:
	 UI-OutboundReport;
	bh=Lbr9S1I2tMmBKQBfKX3KSUYzzTfoyVnAis+sMxQaqRU=;
	b=nV0XnOBfat6za8VRM6Sbhg/0CNeiv1uL9o7vKW1Zd6BBfjzXpZ1EHUJzjwA9XqXUOpXv
	 xtMhFYUC/qK1pp2Qtu2qS6yA8vcMTIuZWlqsSXPIwdZPXq0VZi/vnztjBfSXDvdZzT+FS
	 ELI+RL3lzapN4D0iFuC0DD+BGXUpCncFc6ZFjZ/tzZjsiwEza/NiENd7Ch+7QiWR/FhYx
	 DildqOPjv8AX4WUEnqYboZGS4XBtBl83JquWMaZ1kC4nCKn08Wh1Xp4MalUrYSsHP5ybn
	 V+mfhEqiPj1aQBZq0PXZH5DV6GPJkOLG5hw6YQbkvn7ZusdkMVBAVY9zwxTk5Dp1BtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=lSbHTrXZ;
	arc=none smtp.remote-ip=212.227.17.21
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 495BF606A31E
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 23:06:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 495BF606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=lSbHTrXZ
DKIM2-Signature:  i=1; m=1; t=1795648015;
 mf=PHF1d2VucnVvLmJ0cmZzQGdteC5jb20+;
 rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
 d=gmx.com;
 s=s31663417:rsa-sha256:Kfe/dK9Xw8G8z2DSTUsPWxukRHdK
   hfb0QN5tozUegqh+svLXgtTZ9zF+fVrR+eV6bODuBRZlr7Av2ZU8QZD0Yzl+AYbWKh406fJi/Lh
   RjGoQI8N23yIJO4MNjU2v8nx8lYKZuflihcfn54d512qnWzeMz6hh+9HWpZPBHXcNYXfMwt+Iaz
   jJ0xMq4XY9Cy57EMLtnYJpP2SfvVzHZD/4Mp10jorU7BLX+mTDpgmO1wvP5LIWQu1p89SF37NVa
   /YYBKKX45IVJKQYk+HBzhoubNhQTclN6t4jomTy94qq7CejDv/OVUEwmsmGSb8RlLOM1VlZQf+E
   XBjRa24GUBsUxw==;
Message-Instance:  m=1;
 h=sha256:
   xyAVd+lWuVKtUpyflufK+PO2zUj5/xRf9uG6weTpvVM=:
   XRjaoY9xH+EKCEPJK8ubS0fReDIxuyUYVymGWY4d/04=,
  sha512:
   +qVAiQF8z8gz0tDqWrnbZa0G+4Efsq+qp7M14KfSusmfjJj6Ej4IytHgZrfUt2NbXPPa+vge9hQgko6CoUVyjg==:
   FNNjd8HlVHN4JOzm0cm33AtnoOG2iffAgKJwyqNUSfE39zR8mdYUttIqPCE4EHi1xs1rzbQ8/4FVdUOmeDKxqQ==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1795648006; x=1796252806; i=quwenruo.btrfs@gmx.com;
	bh=Lbr9S1I2tMmBKQBfKX3KSUYzzTfoyVnAis+sMxQaqRU=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=lSbHTrXZrWIuMlnrnByEQpACNgkVEMmy42NNTLfd/ah0aMQFLJ6K0iufZRDXiRfQ
	 UQKzddf7bKobSkQ4FwSCHLAVUYpfqNLsnUpvnT/W2XgeZe7WAhwjOuv6FV/QFc19c
	 qih1iufwHRVtxM//dsV5h/2Ifg1vpQRh/0KNvFnshoutJCfhsV9eE1MLfz0wWB+vM
	 +3+z61ifeV7uLJA7h1yIsH/QUEWiKuohNME3psSCJLM5X9puNrZy78kXs+ug+MWgD
	 i9n4cJQvcTx2G3yxfvTFJavxQlyqeqAF5ccz9g/adm3iPpySLFJjVxHlKb8VIV4E0
	 c+NE9w+7+/cEkHed6A==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MEV3C-1xlAzv3QSY-0078cF; Thu, 26
 Nov 2026 00:06:46 +0100
Message-ID: <83926a62-a1a4-487e-bea7-5ba65eec2730@gmx.com>
Date: Thu, 26 Nov 2026 09:36:43 +1030
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
Subject: Re: [PATCH] btrfs: return -EIO when attempting to start/join
 transaction after shutdown
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <46986ec836a3f93b77ab9d6f664733cf12640e37.1795615479.git.fdmanana@suse.com>
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
In-Reply-To: <46986ec836a3f93b77ab9d6f664733cf12640e37.1795615479.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:dDo7RlhEb0mZ1cQE0lJsf8ZI1ZEy4CIj+4ZfpiEHKyaw4/c9OzK
 rmI/dJcJ0soVkxIcrw6xohT5DqpZIrtwc6bterAVLCSjdURjHd7yLwwHlprdY/4PRP/PB7J
 LZqqv3slgkta7K7ZY5LrRtMAePL7IkwbH9FylIk76S7gPBtGQ8fzGlizStzHPYyeHEKqQm1
 G6mePrWV01wJlggq1Vngg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:elvuXItKHdM=;B6+Dl4gUIVbikDvMXfMaJAJYV74
 HCRbQlJBTS/pwn5QIvaMzgRChmNJMzLx+JzYsPvGxa6Li19YHghGoqs0YRo4unLyS1cQQaM5O
 gTHPSpoQvk0smSjISG8dJyMzReYrEa9Jcuev5EawIt7TTtq53zpIUsk6OW+r1ZNQlSLGiUNEn
 k4Mtya3WFnoUIjVX8+icxWlJIZzz+KnVORUG9ypW0/xgaQl9fBclHaW1VK2V99s5sGBnthPHT
 mzBRz3qrea4Iv5myxT8J1Eems+Y6PDOsL3UVkWb9w1jOpV+XDd9k/nt5csUCRuJAKkcHVhfhq
 pHj4eaUnifo4lcOM8qJ0nwh9uzQjpGbQvCjClujy4fSN1Twnz8WBQmWLNTWSCp+O4eyYDVq0q
 HUuf/lJZb4nFN/XQw1jXH5eFc5zLKhaBS3N6y4VZ/YzrUrDTy/rS7n6hx/f9NADf9hDKWs+lE
 +xhUDEySC4aYpZWpTMzrlIh2bKbH3VHWKERX5c1pOof2AFRUbXSXU0WpHe/gh+g2xr7pKbQJj
 SHdY3/lNNnhzge8YpuwUn+ebfQ7jGXXwCLMGPKjZYIof+hVaGCCkiyYJBiiKpvQ4vp1hbkMPZ
 g8RWZbUdv8wYJlQzGI1YndxGZO4BasPRuiCZJOjx5T+AGnwUeTZLoZWB4fFNbgigg2srqs8VK
 /qs88vFXZnLgLUNMsU12KNQJHB5yVw2CsLiKkShNYeypWAqN89GEqWRlWjhkJXph8mvAyo8gj
 e0TLiEqaoLdrB/0OOABTPHGzhaGWdAa0k3dNW7lwdqbKs2x6CJdPYQFim7fs0x+u6ipjM6zyn
 cjBs4PVqgHS1h9kYdDeoOeyRHlbgTH28D4IhNj6Oseug2egDAJ39gJcMOKmORk+4LHMbnWOwU
 6sfbzb2MGiod9to5uMy0AUSXV78x5l/DGXHs6K3B7BFHHYLq4U/3vl90qyi0OwdpC7Zvg0PDn
 2Pug+v/O83NA80VjJDUmaC5ziaOFdqiwwBNPw2ds/cdzByzZ+WqV328xqqhadu2YuZH1iC/vo
 WhjhJG4mVtidi5jRpZPvw849nw0vETKtbUVIPcA6PKmiQ/+nAQTZz+G/3BKKs7LyoTyKh3Nxq
 y+Tt0l0tVeDyfCkl66XiMUNCLz5j1oqXWc+5rtrz4FKeN8QK8hS760hPLhMxsAxSxYbMzC+Af
 E6a5pbTsH9BPaJ69DDcF+8hRQY8LpkyUPDB99gWJiVMcKEHPaAAphZxa+CmfYY/E43/eJWx6T
 2hzJ8HzlGij0Wbc4incVML7ijqfgTEy5Bt8Xq5y0EQ6C+a+ucx4FR/ZaA7KZKXai1SumYd97e
 2srU9r7CTmJLcvTkdYyPvt0w73MUK0FS+1XNLlHLIMaAxqaL5BTAwWyV/NdjEs7PqMsstewNs
 0pJqG7Ho3VN0WE16lNqWFsSFazqnQkmDeqlzjNXan5zzTxqY0ZOjSye5tpkRLQ49iZmKzDGxT
 RDtFqplNjgwvSj3Jdob6ZgS7979nBrZ8lIrIHxzGDhHAG3FrrUhFfv9eurlnihbGFtW89eFhr
 N/w9VlYAyxpMzWttc2AVTn3u5TvkM97aGkADW7Q31xbOPDX3EcyIM1CuiwnFhkZptLbdN/1Eh
 sJ0xQ2TL4WfinAGF1GTGs1lGw5L1tf1GAfPLRbycTb5SgmsbSF6NbA0CQaEgmFasVYuifT7qu
 PKMDhXsSjiHeugu/qysbVLIhxp3XY0US0kawghIW5KOYW5aFFIkWxz61rS2Y2teXmVxrAt2W0
 kVvAqVtKI+T0WPf+4qbyMDTYgvIk8x9pbOLKiD8P/GrBP06WTuMe/CX757P4aBqWHUX95z5rh
 N5bkxoWdO7+HXcDMjdLAa6ZPCSRQ8nQFFxBWf40BgrMgiICmxVrhnKeECIoVR1CMLCTS1XOV/
 LEtahVn7/L+pSP68ZxhRNUk2gO4IMGveyE8UjcuLOE15dfzgFGkLoWHPYIGgvQG1WW0N4YLN7
 85JUCPWjXeZcvF9KstHfQ8ByNRf4QWvredlJYx7tOXHOVfwk7Nv9g3u5a6xmRCZ0ORwGYFCXS
 GD0RL9qZf2e/IBqT2/hd3CMt6gUHps0iIP6tApzcXoozY3mDcI4sci9Y9nfwmnP9abBLkYxHR
 /zrAWwUh/J4+SGboRQsnUurBciodD28sg6sZKq+Elel2b22LtpNKKu9Xvav3wFlf3uaVyOKwa
 XTOGZxyDx9yugCoSbYo1XIbguhRKNYr7RPfJwc9JztwgTIxM93DvHeE3mndN91UosZfC+XGw/
 7xB8tGFg/o5AFQQJvC151due9o8xIN+z+iSlHH6xcr5SlPj15RCGlGvIMWFgvdouIKRzcnUuE
 MHStRz7iwpLMWukmnfbyCYdOGdGT3Bx2IoUKK8P96tL+CJGK87RgtTHWyFQ8H2/p/bgazwSL+
 mqPbg4dQNMEYy3slw8aawG7EulcolhOZIZ8OaJOtUBDTRsBTg9pxHMogjBeBY39SP1kUtNa2F
 qNerygOWakN4avAkqjZ1+7QCkKGATt1pdqW6CfkzLnpqSJRGHoYMWTP8jXOu21SaGFWxJgzVO
 l1VzDbj2KdZsxrqsCmt4xYnJyS8ZfWNkiRXtYpfMPDPn9q/TTEy69+iVJQvft7StG4z8e45S5
 oNuyJ5Qmtrn+uM3sDUFp++RUV5fX9ngEJ/Z+Lz6XCpWZ+GdBgnKmpq3XdovZbhpMxw77HqfIv
 XkKnXytyfzjVr5sMsuxFHXp/b9ZiTZhKvYO7a/P8IX8xLLc0u+ff2MFL5sC8EUiz+4XkD2rid
 Om2YchcQ3o5lbp9fwWayUwqO7F/zmkzvGMx7MeRZPSPEg3QEHg9z+giu6P5GHpxrilEHAAkm5
 X1itpeuPPmv8PKAj86tpPw+smgdvOQW79CsT28c1qGYhLlx7pvNDHemIWh0OG0Wat2XFwEaOw
 wyaXtZ87bu1gOURluK27UX+X2wmJqR0ztVzIXN3UP4xVDwAq8yrn2ukU7quyg8/47/PpPeo6Q
 Ri2hmqKhhfb0HnmKpdhLgroMTmSDiXG7NiT5jg+LnlIikp5I+M+uXHeYA7vRv/5Z6M47+B+P/
 XeikEQou5bvGiibsqN5ZxVFr5vTTW3HP6EMB87P1kteKTxxO/HiCPdSlgePE1dgZG0xCI/r/E
 20xbWDIQVuWYqS2i9ZT8bc87K7WUL6I8umBloe67/Jvl5VZugIFVW54DL62HVlXPvuV9o4psm
 LU4E3ELQtI52HdN1a6t7pS4qld1TlgMuHDU2bmVeclZSadBhM8Jln8/mS3COpriS2lSeRqAeJ
 0ciSyNYUDYuQi0FEKwOaS+KHPor1g/YLrXu3Q9KzsSfywUX2hn+XvtcSqXrd44oxhrKmnfD7u
 c4vmcsqAKxZpQ8vHHtESh31VsEE0PytBk7rrhDptc7HgJVxv84I7/UuRxxPw3UeAsRUeDHthb
 pa0WVOSA09euvNaER880v5BMgKfDq0uRlYeoiGm3TbbUwwETsTEnNmutmCCsfIxAImUJ3obIN
 G7l0So4iNvXiT0y/2fiMp4n/bdzQaYcxRcJakGTGcYrkBgtVP5rHaqkNYEQDohtzA0qMgnq4Z
 VKkyCm0SFOdMcLgkHLh8phT53r92CE33U+vLJhL9jkB3jss//d3AclvBwiG3X7cdF/BU3n70D
 TjmBHrpWBnf7CVF1bmfdABuhqwZCDJoTjHd6hZ6XutWSSoO8dwIEUoQvSo5KP4G0mRn2dnwOJ
 2z97zZryVu2/OCbBvjFaUW8X2LYYwtO7c3tLXy8KAwM3MYdU08vUX/TOXdp0vEq4v/OqxuNR+
 6AcKgtohQG5YLb17qICcEAS1pHQsVwFHWqXH3OQMSeDd6RLaXnDsGTJiyU3z1FX3JRD9pFbdW
 TeMveN+XKw8sPPWyrhi5E2PJK6FIVbIZAluihcOBRG6FyzQv0ok2R4Ei+wvXiT9rDqSC/9nrm
 BktYqairyfECYwds+Ov1CfV8DOi7MmmofchKn1Pwvwg9dDZ7qf2nsHbIc2TUie1KJXitIrhY0
 +stWN2n6Kw9alVQbhlbbrqMWiexB6NoOr60Y8v13fwSiR7EO+nq7ahSALHAF5fslskDr7vCvO
 Zvp/EbGL8QzEB0UA1niXvVoWEcOVBIlW8vjO5ZNuYwKC3XAspeplgMZuDsKMu44DhRlE8DeQZ
 NIriT4oiCR8syyj8Fimg/HLSofiTnKenPPykoCf5Ar6ACcdCWV2IJL3Ei455tzFBybmDRJar1
 YP2tXGGwQYwT1TIH4NpApa/VsAsOy67I0Irhepj/dycwgQyaN5W2aEvxVLwT5b7BhZqIwZ/FO
 qR2fO9CL30IKUgBstMe2wiFuVWXqyuBYb/A5MYze4aqUJSY2EpDLMKD5cTfNfOAPFWAC7xaBL
 Vc27tFEzMf4V0ARFYB60DLj/mbu+WRyEc/Qn49+zmVL9tR9BWe7ulRgZR9Wp0QXR8xxg3pA2p
 wTM4be/GdjhHLJBpPkaeZKSlT5IIwI0DwX3ZpltGHt/LQPbfRksQD4Ob3s/opsokHe9ok07Na
 Cfn2STKT8y47fGUYqzrTdFRPlbFN9gjWl0d8WKM78jJc9p8lzpIv+zwfGNx18Rjs6AW25LqHO
 2o7w7ueP/WePNZ6RtIWHdwXPwYXf/NM8DCfstdMnruolKOzJOs3P0PhW9ztFeSgqUWxW4NAdT
 4qcjN6FPpbuB6vxGTpAUccHadNAspJ/8w3mRGQd9+liA16nLN4O7nBBVVwJ1gI8wBGhGWmm6S
 X05fS0+Rmvg0YrTKoWO9rQf+NI5DoDFySQpENsHVmNbRbpymLBUIKeairX81xz/2Ljiq2wM6D
 5KC0hBy6tVZm2faBimyI4TeUj7i99V4ZIMzLTQtqjl+mhSWWsXtPLcpkzA0vlhzMY2toVrXoT
 a6oUSRHwiZoqyf8L0kyJ7mtixI3xQ4L4w2PHMSpK1ZcGXyh7d7kesetyrMnzExc30lbGpQjoN
 P/nogXwuR+x+MSTsYn5zCK2zXNog2cAirX2dyDvqQy1RwDCm2UC0d667KiBDgpRD0H6RbeVdE
 EiAhsggXbyHvwpOdRElxIT0fOyXwzMfxfDIs0NjaYcGrNJLmNxYLQ0iNX3oOyb6jT1i5Z1XLK
 FnbfXmi2YowgdlIgQsP8ygHeOPfMiuvWg/B07OkKfuFOGs8bOPanWYjWcD6a6PULMfaZboICN
 BLW7ZtQlXIjfLm01vPVo8e2horQ8KLUQQdlyVrZOMtoSYAUrHI+BxZCZT8NUqCmA3dEFR7rjU
 VhEHzdjCJ/1PamburMgg6nNAG6ir4O8omlHXYcEPGAOhf5eRzybEDHkgMyJoPgHGlnyemqhY8
 4WIEZjF2HGY1ZZb9MWpaSnnUTzuIk08piAm3BXQDVJ7d6u+DpCp1flP6j5hNvLEh00q0wv2Aq
 M5fVeg+19FmdLdcNvhlse4fATI/ZIpLBPBXhgzoApFWg0Lsweqm1eQkTN8IG1UIhhlLlXAsWZ
 TbkHvFEOXHD3P7EQruPFch52mY7xIGZYNgd1RQnwyNPGE0ZayLEcQSIsUbVgqSvsxGTdGgkft
 Gz+DocaULydwM8pIttS9y0BEtSPOtTLAXDWhY5zzyME9Ei+IZnEGy40YbggGH+qBiaoVTnssv
 fhBiH8bqVo/xxuswdvAKe7V4M9xlZRwqq7pgrT6eRsgBwkEsEoqUlyvkVcXIDJgpiYsYDSnQt
 3ijCWyMRO739Kiuh9Tkr3Kw9j2ZKSGcIZ3ES7gAcVblJ/1lW+dp+Khh/MFHYh0DmWoNkpw8Ti
 9EsOKFhU0MilH9JGjvfJJ4i3JaMdNBrprZiJwDH/YBPhb/hpYCYdHqDqHnrt3DZxRQ3XCLMDV
 OB2x3bkCG9XwSOX8Lr8VxAdpcs5n3oWF58wewiXnCRwWMCAO2nwjCH0NCPAmNQKDcDbgwgRw+
 chsB5KmZqxjDinM1olhbl5JgsIkawjFQP6Ix/gwt8nFzyGQ9cHtYEEEVOoZbg3JhwHyX21o3w
 GLFJifx2Ywk5KKnd3eWS+59R4s6O8yj0Dwauc8vFrzWF2sc7R5DB6S/6FoRzgoXrG63quAY/a
 E7achlFoQEh3EC+6MwKLkvdIbfCXy31Lo/GUcVI72cECMKSE/bRPFKoBgQBgEoZFxoyYfUdoK
 N1gHoryKPjYQwyLPUI6cUzDYN/IpN0NHGVmwiMHA1pEvrEnoz3AmVAeXcog3LzsZRgr7aI7Uv
 jhGEJX7a2AJOXTR8/mAZ0BQL6rvYIpvBEBHbvnyzl549TALLagoD8EA+HjeJIYnkbCy1Pv22e
 VGuxRKJfhhkn1Rn6gklgaVwfxtSFDDXHmtzPHyBPo7WsejioUX8SJSZWWJDaG0iX9mkd6/3vY
 gSv4Sn/SGoT911ntkq7RQedRrNNf1j6V/EefPmgN5Eb9OGY5lIf7S4c2Nq+rCW34RwBzh6GZl
 wYbkMRWJFotDvJBpTDChUp0aZzGLclUITNaH0PBZc9nDTpLZS4y0nwCNacoe163yY6h1xXEHa
 ecrcN92DVGBvgy2IjbRsAE+f+Q93LoAmiHalZ24TJKYR+r2QppzDk31c9WhSDgzaM1uGmgSUv
 k9Om3GS3v2NExMpi3ALlZl9Fb0hR7aR/DL7BuwVZHJVnLcCmUnwsHh5Zv2FKKHIioD+BM9qIL
 FDWXX5evQJFvNCY2l3Yuauv+0EA0HCGbNhQVnHFaSPYqJmK44xXYxkPvguHK0mg58/o2g3MSn
 h/sYGbgjxoF9GPyM/6+RxRpbBe76E7zx5Ze2OvhQ093TVe077ynOEU8C+2Dx2OqhwvHeJxDuT
 //v02BRXYk40U9bZ+gPCAzcbr49SEJQbSAcAbFfjj4uKR4HEMcBVjeqHR+yilMXegPY3aspp3
 yUy3ecpQIbmYUvPAWAyZlsblqlvYERrEyA2cXPBiJMoDOB7dR1X/JTaGzcOSJy6Pd+Fc8V3IK
 GJkCtmGDNAfXWg3p1P00+anUOZV53pQ76NEOeY7CHFBJWQkzlVLxpr3WdSq9XMR4DaLDdt9O/
 z/o+KuIIUqoBSaZtsWhCUnIZr8asr6F9Jqqn3Ehk7i1XzO7Iu0Wjqb3lqquSYsy0g1deF/J0t
 4JKZWjbH5F+gj4CRr8iSRuv5U2zKX3M7WHPfnnGWB8IdMgIjqRJrQ5D+sF2tpDoAE1CiDgkk8
 pmO0WHDVVAV7LSsuIJfEcsBZ4pHIJ18Nt6BdVg+ytCEN5a/wS1kJ+X/l767XtnnYufiflhyxo
 0VVzhbNicydQvPlQqcGd1gVkPMUVHJa8D8AINTn2s4tjXIWYXxilhYjso73v1ss4yWjZ8Gpex
 mTBKZxy4sufGbrQZdl4bzA8LTFMRa075LmzilqAPrYVuAj2s5CCE9UJQlbpTjm31j76BlXSDq
 /HiPSEUKzEwYjEP62rZbmLSW1bdzCrZx6oyIdtctvc+vry/k3iJI1vUBcPwr3C8wlsfuemmgQ
 oCPWzXq2xyCdIQg1Mh/LsXHYzBwivJPNfxq5WdF24u5IX+hdTT87WUQ9sE=



=E5=9C=A8 2026/11/26 04:09, fdmanana@kernel.org =E5=86=99=E9=81=93:
> From: Filipe Manana <fdmanana@suse.com>
>=20
> After shutting down the filesystem, if we attempt to start/join a
> transaction, we will return -EROFS since we don't have any code in
> transaction.c to explicitly check for the shutdown state, all we do is
> check if fs_info->fs_error is not zero, and if it's not, return -EROFS.
>=20
> Everywhere else in the code base we return -EIO if btrfs_is_shutdown()
> returns true. Probably applications don't care about -EIO versus -EROFS
> but this can trigger very sporadic failures in test generic/623 which
> does this:
>=20
>     xfs_io -x -c "mmap 0 4k" \
>               -c "mwrite 0 4k" \
>               -c shutdown \
>               -c fsync \
>               -c "mwrite 0 4k" $file
>=20
> and expects the fsync to fail with -EIO, which normally does since by
> the time the fsync is called there's usually delalloc from the mmap writ=
e
> and when fsync flushes delalloc, it gets -EIO which comes from
> cow_file_range(), where we return -EIO when btrfs_is_shutdown() returns
> true and it gets propagated up the call chain to the fsync code.
>=20
> However if delalloc happened to be flushed before fsync is called, due t=
o
> memory pressure, then when fsync flushes delalloc it does not get any
> error since there is no more delalloc, but then when it attempts to star=
t
> a transaction it gets -EROFS and returns it to user space. This makes
> generic/623 fail since it explicitly expects -EIO.
>=20
> So change the transaction code to return -EIO instead of -EROFS when the
> filesystem was shutdown. This avoids the very sporaric failures of
> generic/623 and makes the return value consistent.
>=20
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/transaction.c | 10 +++++-----
>   1 file changed, 5 insertions(+), 5 deletions(-)
>=20
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 1ea8dc522d2e..df3a3c78e681 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -306,7 +306,7 @@ static noinline int join_transaction(struct btrfs_fs=
_info *fs_info,
>   	/* The file system has been taken offline. No new transactions. */
>   	if (unlikely(BTRFS_FS_ERROR(fs_info))) {
>   		spin_unlock(&fs_info->trans_lock);
> -		return -EROFS;
> +		return btrfs_is_shutdown(fs_info) ? -EIO : -EROFS;
>   	}
>  =20
>   	cur_trans =3D fs_info->running_transaction;
> @@ -361,7 +361,7 @@ static noinline int join_transaction(struct btrfs_fs=
_info *fs_info,
>   		btrfs_lockdep_release(fs_info, btrfs_trans_num_extwriters);
>   		btrfs_lockdep_release(fs_info, btrfs_trans_num_writers);
>   		kfree(cur_trans);
> -		return -EROFS;
> +		return btrfs_is_shutdown(fs_info) ? -EIO : -EROFS;
>   	}
>  =20
>   	cur_trans->fs_info =3D fs_info;
> @@ -654,7 +654,7 @@ start_transaction(struct btrfs_root *root, unsigned =
int num_items,
>   	ASSERT(has_single_bit_set(type));
>  =20
>   	if (unlikely(BTRFS_FS_ERROR(fs_info)))
> -		return ERR_PTR(-EROFS);
> +		return ERR_PTR(btrfs_is_shutdown(fs_info) ? -EIO : -EROFS);
>  =20
>   	if (current->journal_info) {
>   		WARN_ON(type & TRANS_EXTWRITERS_MASK);
> @@ -1156,7 +1156,7 @@ static int __btrfs_end_transaction(struct btrfs_tr=
ans_handle *trans,
>   		if (TRANS_ABORTED(trans))
>   			ret =3D trans->aborted;
>   		else
> -			ret =3D -EROFS;
> +			ret =3D btrfs_is_shutdown(info) ? -EIO : -EROFS;
>   	}
>  =20
>   	kmem_cache_free(btrfs_trans_handle_cachep, trans);
> @@ -2371,7 +2371,7 @@ int btrfs_commit_transaction(struct btrfs_trans_ha=
ndle *trans)
>   		 */
>   		if (unlikely(BTRFS_FS_ERROR(fs_info))) {
>   			spin_unlock(&fs_info->trans_lock);
> -			ret =3D -EROFS;
> +			ret =3D btrfs_is_shutdown(fs_info) ? -EIO : -EROFS;
>   			goto lockdep_release;
>   		}
>   	}

