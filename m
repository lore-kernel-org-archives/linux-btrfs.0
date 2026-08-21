Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6285D3655E7;
	Fri, 21 Aug 2026 22:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787350377; cv=none; b=OnvXyi94LQnmoIID5cXGkGWXzik1m0AxsysCIuDmGdIo9gIdUqaLar5j7829PlTmEKmnRcYOTwGq71K5N92xjxiLNsZP0RsQz7hsAFKaO1DHEJdk8zYuCp1qnUdLHv7FokO6T/b2lNRfRYAMl2nj+oTK4DNY0Tt78CWlNdO4FSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787350377; c=relaxed/simple;
	bh=JSbyw0ZCQFIJfxlkalX8/98Wde77a3Y2H4YYhfkeLFg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Fxe48ka5LS8Xqm8ObOGmmqmjVQbL0FTCYJijkhWNIczneFEuqPru7HHxM08sKU6LTriNUZCVNXb9UeXo4a+pUrBNQsS2Ep28hQHTscG4DqxPDsMNe+EfRu8shtQukuBrDF1S/9NthL5F0iuaPf13Ew+0+xetIMh7A3IDED//t0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=XLKGAg77; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="XLKGAg77"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1787350372; x=1787955172; i=quwenruo.btrfs@gmx.com;
	bh=b2l++53sBsCfAoQrkdFglLJA5pEKAETKL0IO7xIwxqA=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=XLKGAg77RnSdlTf6/INlCGN6wAn37HCOWVHni86Fq3W4Pz5Xuj1QCl/1zVOTA5+b
	 9Xf42HjhMHEH/ovyUaLfbF2C0+Be74TcVXlLG/XbSATdyvdAV+bLqN3ZbX5BTPRSB
	 zT1dRMFvufltNHSWCu+DoM3czL43FwWHK3iWkqGm67Ui/BtLWtqMuFkQB6p9SVXM+
	 T5xhpSoRh5AjPT3icIXnK6iaJ3BdIu2rB7BKvQz0wBnX/bQRv8w40CnpwtD7h+gcy
	 03iS98yAv7r7GEveZUzcrBtBYODYHsv4GdBq2gBJt282St/ylSNBqFB0flMcx2s4H
	 433+CROxYdM7czY83A==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1N4QwW-1wqDQb3w4U-00tkim; Sat, 22
 Aug 2026 00:12:52 +0200
Message-ID: <77862275-37d3-4acc-a52a-abf50e57e0d8@gmx.com>
Date: Sat, 22 Aug 2026 07:42:47 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: zstd: fix lost wakeup when waiting for a workspace
To: fy15309206903@gmail.com, Nick Terrell <terrelln@fb.com>,
 David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260821-btrfs-zstd-lost-wakeup-v1-1-84f358d4ea67@gmail.com>
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
In-Reply-To: <20260821-btrfs-zstd-lost-wakeup-v1-1-84f358d4ea67@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:yBTRjHyF7uLgWqtDcEA4eXOr/s3Tpb4bLY0/iqMJklZ4+oeEqzH
 L1nlllzSyrFQLlyEodkBMssHqCLleAZONmikECvP/zJcappvTdgRa0ltpYAj/rDvDHvupFV
 6TR5r7WmYvxaw3p5BrgFSnv27ubX+j8prS0xbNAtVAZaTrk3D4uBs/jG1M8anBM/uzXQ8ox
 kDN76B1BOO0sd0FROXjGQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:4vuzRovUEso=;Rmo6XmeFlUPEXan3a2VzRuK0+VL
 bnci43+6eWYilbzWzhcqGGnxyoD7+5C2A0ozR9V6oj2cyvAJOsXAxP5F0ePq6mzFPwejeWfP+
 ThERq1Tn5Bk0LUHZ1IJVKg35M6bQVrRAKyxQHoGdCM7XGfwz2Yt24k0xIkE1j8PkuhTkrID8K
 lYlYkfOyetfB2l0myJRU1Or1I5rxVDL+2fypG97Ct+Ylbw6y75jHyvbEN2haOC6aQDfw+cOeU
 FkIRMug2z7d0iuVA0a3rvFEzK7HLsJ26tGIal/bpJx6SOUWjr8/M9ML2p4reS8bjwVjufpwCT
 EHgcKpHCBjdAKUyC36gMK99jPNp09+uWZcLYC71P5kuao1sTRuoYZxdJ87WNAe1W0gF+Gy+bb
 BRyjGlVsccUdPZX8tL2xMciQWwnqB2UCUjRyM5E1/i4bYfQjf55JnG86vgS0lYFzZh2KtGrhD
 3lYBcm7Z1RrPbwZ8NjZAKf/Ukyy4qgCJJR9jT3uchXZCbRk+OFkWPnWHT3rDTIx+nYVuBlz3y
 2Bime2zz/QFD+EcgMM7q4/FfgLp1vNE2MmVclIsGO+9rhZqtzUpXZdM/iRaUNRx686VJvZh3d
 aTdp6OrzQqAGltH+K6vtL0w5nBjeHvCdRMvvOD00QZZ5qZjHUzXDTLs6xmXEvxHj5bflqWmhT
 gzIEGRZMoq1ztWhfwWSk1y92Orm1LeOg0qXp/9moabrboymz/DwpEobNjg7UA134DJ9jTcXKI
 jG32YxTvJjdnV6Ln5O5Wa3gySGkCijGpZz7f0hHk/CNp3g/nCjt5x4YYyEWX9TLD17D20HaGv
 O5GbSurl0BAS1g+ftrb3mAn7DVRakT9EQAH6GdA1ROuW5pfVH1lKSRDTBS/P5sZc3W/6HVQCI
 HBI+Q49iWmo1BDnsR41Q+2MuANWwq1pV475mvn+snW5YLV4TA2euGUVVjIeFS7renEt4aWSnt
 B2dyy/rq8TAJC+feVZBbowjTkjRMuZvSfZpDQEiTyMllvGII/2mjSmWnkZMH/KV2p4y7RGJrH
 TMXdJX0qPKXLGtiPIDeEgqQzg6uIkd4zCjv91cc/IclrhyGQRq/kwS/7x42Jxy276eT7NSQq4
 1PL4n10SQCeRr8SkcCm6VwrTFZzNR/XNrQzu0pIf+5adVUaLnJuyIp2IgcTOyuOQlbKcyKsEx
 g1npBkBQkRBXmq6nWfOq9z/alszmd+Duhv/mpMYbzNyoo0/XY279CwclPXrYNzruLjpjAW7oh
 Xsn9Qv23gWGnf3YqbLvKNN/MoSo2J2a9s0tNhjm3b6DqlZxXulJ0cW2zn+TlY+VwVBZED3tD6
 OLc6tctEZLa524GCab6Uo2SNAKLrJfz1neoAhJrE43bHgWMw7Vr1rs6oz5OVGn8dXy+ld9U3t
 u2ygnCzskwTblS4v6kUOEL5ZhcAQpePJtwUjvCnUqc5OTGbQUWaX0O/Mtzm8h0ey0A5RPllOT
 Jq9jod3JxOdAAudIk69+A0tNpcjZPd5hH3DerrZ7Ot874GPs1Kc/+vhdM8EWXbIugyaduIOuV
 vTL+XT3hrtx8et0JTX+IH7VhRmttE1bExVaKw2cG5e1BraYfksj969Ceak3Y0ymc1WpZtMJxc
 w5CEvMaK0pA7TsQ6cUhq2GDgdhptlThXJoy1ZDJFZTDnYdX2ivsxTUM9XAx7TrPf/+vOXtEd9
 D0auW+PqGJHAMYQTQJEzapm8bBsYuz+N5RZOcLCsOPOPWxMCVEKwm/AypOY9w8Ob7Qk10r0sR
 sY2+pLjhGsPP85Jn9B0+phoybFslXI7kANUNoZmSWeUUtmh+TEY097emyIt/ZydZ6T7yNKK56
 UQbLjt8z7LhmiRd4CWfmRCd3C4XJiSDaruXqv5YJzkQEql16zhYLot3hTupqtJwwQj7CZpVgS
 IjD18MFWRJxtFinkxlG8/QVp49jSoJ3K4TVyyZeZ/B3UH8TM41bmuBn5fJYKiZu/uLvsbejhw
 RpxguuwDUhG9ZckwVblXzxJfIaR6oL+NQrI5hrRX3bt/zslvBchs3JxhT87aWEM7XKGNPdObI
 IoxYt0iHN+6CsYYtdxooWeAzRI+f4MKK8PF7z195rf3n2MQdnctfgKZLPBxkYO2Q8tE6ei+zt
 3Y4uL5G9NkGBn+2ZQWpN7MSwwO1XhdBbqcWF25P4mg41Sq1tpQArpNTjoxjRpO/Og6+khs5f0
 i2pB3qxGFE/gzMBge379oTOY1RFLs+Q1FGl4F75aJxvDQ+kFy4Rln1KEGm0ZcUWGkANOcBdmt
 pgsG794V2YOAV6Jxb1o/dFLQ+DvEIVrFG78gLGbMK68KW4wTTSbAR194lGwUmxC1Ny0HGiBRX
 upJKWhUQuv9pvuFmnnL+Li+LaTrQnLNMGkArZQEpK+f4kgnmEjPUIi2HGk4tkpaFs0UGyqbHP
 tS9xAEeMnwJPV2pswjISWFjMdUkB49NuCTchRLFGrqyn4Xke+9G0gBoRKbNTs3qwUOTlI2iZO
 HLbWTogeeBiCL3OtvWOTF0RFowwkp9O1CfQ1L9wMvuRFD+1XtumX5gijuZYMnA3VLRU3kIK+J
 qt8Htf6qHx9FlobX2fpFogIPio2Fc6eoUr5efdjS5loliM05BcnTxxyXr9FMbSWfT7nG/cwl3
 RjMjkTBGVnMLcZDje3pLhykR1VLvk9yEdnss8z2PT3z5WSe/+2GFZjXZ/rBXHUebevcqiuX0q
 yBTr3CWeqg/ZL1JSoUZcysOM9gLrKnpVwRBcrJocbBbHDFbao2Qrz7MVepxYvZn0fp0bo5SXh
 xbCM3vjgJ7E1vxKLuCWtodzFY2ggi30AWmCNFT9tK78/F0E/VFZTksgRVa6O/I5vnT3RPtARH
 v5wTj8SdVgxYE907kggZ/BNgwiNXh7Ywcs3pPihTVEwHmcx+vuXM00gzAhd24LJiDevCFi2kA
 AC5+2sUt1zfe2l93NxfVqpDxAc2E3mtO+ZIi/P5ZlsGl7b3pGSOIm7/PCaIXjBLJpJTviFpmo
 T7ZYktCiJmjk/ozjf4gSBjLjS7vlvSUc+aNg5TOXnQ9Ndd2pR6h0y65Mzo316W3lNDLELoAGk
 IDQ4xqQEL871+UCAbNeKZ/2ZSK6EjDHKXBEbHqt/CrQg7GZQe/pq5fArH8X2O11RHiwjpZwNO
 apS2H4JLYmyWZP6ywwIK3YfGJsL8oH/+nUJn2ZZW0RrrQka5w2LRTNa9oJV3rCIZgnlKbllBc
 V//oxTeXKuCJ64otbHf5t4eiIV2vkNWWMundh8cAPCWV8MzRA5EaJtonkbzeBVHyvLnLGXW+C
 75n21Tlz5R1I+Qz7YDWxjslSd8oFczL8Q+gIcngQYfcG+lJq32c+vt1XSd41xgyTwanHHdNd5
 yIDIIFfwfbA/4GbesaSGwQjLZtCeSNExV+kdbPH2pjJnNBtUCQP22IF2d1QyEE6vbxqqZcmR9
 diTWO8gFm41vHmolSrfHTwEQ5mZcinHlvZkm5178HlT+RhU5KWt3xrpl4ATdXJ4tAGz7t630R
 tmnIfK7HC5m1d1dUz4JBPjHafj9f5zQyBmrXh13mTNYgKcWtRJPe3S2zTu5STy+DRyvqruWWp
 s8EVWsERmzvPjqzwcG6vmwfyZwMSWcBDtOmKYz13l06EVINmoaQUIsfBD1oKpA8WYFRPCm2sT
 h9tYTYycqFTzmCoB90q+a3w7fjryiNkW6rdLRmcg/ZD65UDN5G4mMIqBDBlnxh0w+iC3jbJXZ
 GWB8gmeklSpEJikv4255HgKPJCsf9/BfmQOyvEoU3BSysq8f0FcBS5mBwQrXfYpUgny+DzeAp
 I3CwKRc7ISAJ90d+fVHMT/KC8gnKhuyEQKMGg7vQ9GfBUaaKVkqweN4E2kAio3twTw/khfVvx
 NVD1mJTeeF+YO3ezuU46hzwJV/vn8UlgggHkAXgbewDofeHcccbP3ZzQ23N4eVdLEdJ8SJJoJ
 soQVVUWhcJ2J6b1TnLRrT4ZjuALXRUcKSGckSbN5I3uopZ0xXme7VFSAaX/efg70WTVYEAZdh
 KM3gE/2L+6Y4eLSVB3cv/RGxYvgMhmDlpapZZdAZocnTqYvLcfS8YADP1gT3xKlSgCzhAsZ3D
 C5k/bawbmpsD+coK2+rX8XjksqrTXSKo0Wfq94l2TmjwFa3Mt25GnjE1FRF5NpxwPFOrYTZ1G
 Wt9sK3kirlQBwMTnyMgQe+BULDj2odnffRF7iWUpgceaIFFg5GQM9OCyIaBHxt3iGYwv12pJ1
 7yLmfDyEMBVqChAoTartuuRAllGCUlr8VWo5x0c8AJFSXCZPZZ28JmS6N+WsT9KwFdbLrXu5t
 rPL6+dKDODnoQtTDfxQpWpkYEDiqaNy0FiSA6wSLl4uLcBNioSRBwrct9/eH3EASSXc9drBze
 9H6kFzBhL8rWIuibOuxRu1w3s36QQl20INB9+XdMbvsrG3hR63yNvj37INvi10Y15aEgea1b0
 dvPxEd29fZvQ/QOQNd5/lTUGOoUkoE+zAI5H+aCF2CwRHNHodrWs0lzbtco6yfOYiejhGKlyz
 5xcx5Fs6Ng8aPbr644yFEvRjwkbJ9/M/UwGv2kLayc4W3Rt3jG0ESGOVp2DkoHjzDGrVty4/O
 BNIiBMylXKXa2BWE04uwjnAa04hBVMMCwyqrU2Vkj+rKrJtBLgGZfAzH18VftafeFBFFVyPy/
 TGwzCIJ0ffqFSB/8BZzRYYdr8bivSZELS7GkWVf9cm2fGmM5dY6mlvN1t/GUU703qIiBBfLcQ
 1/tOCN3Qk48noOgVCv5UfsM60ai3TkWpU8Qf7Qa+VPgflvDWbsaPLfFn9njjYHV8smTasDv1U
 hr5KqF1AcQv6Qgd76ASDjtOYaUjPDnQ6Le89uEtuZGzj+Grjw8FM84qjlS05bBZxJp7sTWZ33
 kAg5Z6cSYD8/mHS9nGI1JoDHup53iXxLVJV6xa6evcxq1ATYo7HOmox83uSqDJ5qWlXBbPDNQ
 2tcSPoiNQnfq/4mzx+rWJedjF0x56p2GXEEiyTjHjEfuNdOlvxboM0Y6voTcxhbfeMmJThYxD
 mCdJ6nb1D869ZsG65JegAIuVS5VJn+WoSUcFTm5B42sivW0krvPHaF8Qyb40eYenKwH9oW7Zh
 UF6Q3N3zxwLBZUprpqnKMWUJFfH+JMF+ab6246sEdtHCu4bJaYwW5h+lCOPQUbLxYOPR99oQ4
 NklrTIP8BA6eBUFKJSaPH9TMmzdrUxfwpUONXOzggy0fdMNArMl7Du84lcVJhxihK49I+8273
 jF+4EOceJxyt/Eokhb6zlTVhsTZKyP7X9eUzS+i7iuIN7wT3yMxy6Hpi9pr0R2MfjGeQ+RMTn
 pWenWwW605l9DFuuqGRfeeFdlCKkmEhjk2OP7yNmgeVrRAmgft0IOJR5dbE1+Y6OKk0NakRnp
 Qu9IflRHdSDPvwmQ8RjEkBNx3vJ4HtOyfANEzahk5/15X+XBvFmLZu/A513O/ftnFWqZyGE3s
 f2FwtI+6Kq48jQK6TmiLMM4WsDOisknsbNKB5SBLU/N/O3sBjgnYEFv5LYsp245D1X/cBQfg3
 X36JGy1Z6anbET1bmhpOv6euI3kbjgi66GTux7E6puSewgIL3bkc/M52gN1QFv/N+bpkcvAmU
 ppw0t1uxc1f7KasnwGVnKFthLDmhRzfwNtV1d/3aJSetRrFemTRwbcjdIGrvepUhv/qKNG/8I
 CYn2E534mQ+jcTZDDZ44fiFdd19DWWRpHot/oszOX8wZRfzPcNEHVbSD7po3El1sPqUDyEsTG
 sY1sCb5madTcssH+0s8g5z8uEgc7aRO4l4hJULQEXfgFjbZt4OZerKEq/CAws8sYOe3RxMASy
 wBWO2FxsxpdorJV84keLvJuhXZKYUFRkrSrZy8CK5DJFDGjkBWlZJTgiSMgRHjqVzjWmai3ww
 D6ZceVSFoznUA1E9jmTOp7lUnbuMWDJqCacVkJ9lEDgikomrvzByHtKzM+OVFSdy1EzWYJKDH
 6VglBH9npoTSdqI6leXwx1G3fshAD1Fwu3SMMTeIpZSuXfMMb1j9ZoAhOO9XjuaM29A2UlwE0
 Fl/5WSWofKfKHe3UY542Tmg+ztzZle16AQSzjcWt5pjTArUfJoXDbfeuzvmgV34fBKOV6uzRL
 PP5zEcwcX5SCN65kzUqQFasY9CNBnf9T4J0JEW/UOiIJ4MUbI2PeojLMV25+l60xTL3V+cQHU
 8PFH+fMWHPifF9YAdSfcOJ9UzNK11W3IZiFvEgKu2mBf1pzo+N8noc6Tvr8z38H+Mec4Zpm8K
 cjafGPyqg5c/GcevDwljpJvuJDTl2HwePWhM+c2Q/A36tiOTnFQxtU/wHIntfsOTa+V7eCCYA
 nlg5l59nFUaujVZ7xY97OVofr/Dc+GvZ26tM+hFtmFtTj+B48G/t3oPIrnmJJkscpND3bFQNV
 2o69D3elnrcVnt3y+8RfBLVBIEg9Ivq+e7anQWWUr3U8wkqk7g/ODytnRV4f8hKA4wmFhHd0x
 4Gnn7yRYREwtnkzYLZoytPwFqa2YXm2YOz2qKiPe2Y6Zp2K2Vptofz7wFb4Yub6eN1E/+oiBQ
 NIl+G0kQroLjCxFeIgpTr1ogXRpaAsSdOv342oii89gyPSUflSzIXnBHwXIV3vPpik0D3jV69
 hgDDQmBklSda+uRgSrIj9UVPmJDVDQOdELFtqVnyrv4eVIIU2K5k1aTukxMlA3KG8uGmBiaYJ
 FOXlwTCWyn8fJTKpRcbpmhWlXGbmRm7C209Iw4rS1B71G9VQsJ513uYh1lnsv8EXXbV1Vos/Z
 ysz4Y1XRRwJNfB+9OPeEwQbut9wWfpc3



=E5=9C=A8 2026/8/22 03:20, FAN YE via B4 Relay =E5=86=99=E9=81=93:
> From: FAN YE <fy15309206903@gmail.com>
>=20
> A writer can sleep forever in zstd_get_workspace() even though a workspa=
ce
> is free.  When zstd_alloc_workspace() fails, the task is queued on
> zwsm->wait and schedules unconditionally, never re-testing the pool.
> zstd_put_workspace() publishes the workspace and then calls cond_wake_up=
(),
> which only wakes when a sleeper is already visible, so a workspace retur=
ned
> between the failed allocation and prepare_to_wait() wakes nobody.  The
> window is wide: zstd_alloc_workspace() goes through kvmalloc() and may
> enter reclaim.
>=20
> Only a max level workspace triggers the wakeup

Explain why only a max level wq triggers the wakeup, and why we can not=20
simply allow every workqueue to do the wakeup and fix the problem.

> and one is deliberately kept
> allocated as the fallback every waiter waits for, so once its wakeup is
> lost the writer stays in TASK_UNINTERRUPTIBLE until some other task happ=
ens
> to return one.  Re-check the pool after prepare_to_wait() has published =
the
> waiter, and use the workspace if one turned up.
>=20
> Fixes: 3f93aef535c8 ("btrfs: add zstd compression level support")
> Assisted-by: Claude:claude-opus-5
> Signed-off-by: FAN YE <fy15309206903@gmail.com>
> ---
> Reproduced under QEMU/TCG: CONFIG_FAULT_INJECTION_STACKTRACE_FILTER forc=
es
> zstd_alloc_workspace() to fail exactly once and widens the pre-wait wind=
ow
> to 400ms while six concurrent zstd:15 writers race it. Unpatched, a
> btrfs-delalloc kworker hangs in zstd_get_workspace()'s schedule() (hung_=
task
> warning, >120s); the identical race against the patched code does not ha=
ng.
> Compile-tested (W=3D1, x86_64 defconfig + CONFIG_BTRFS_FS=3Dy).
> ---
>   fs/btrfs/zstd.c | 11 ++++++++++-
>   1 file changed, 10 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/btrfs/zstd.c b/fs/btrfs/zstd.c
> index 86919293fd54..cb15cbd737c4 100644
> --- a/fs/btrfs/zstd.c
> +++ b/fs/btrfs/zstd.c
> @@ -307,8 +307,17 @@ struct list_head *zstd_get_workspace(struct btrfs_f=
s_info *fs_info, int level)
>   		DEFINE_WAIT(wait);
>  =20
>   		prepare_to_wait(&zwsm->wait, &wait, TASK_UNINTERRUPTIBLE);
> -		schedule();
> +		/*
> +		 * Re-check after being queued: zstd_put_workspace() only
> +		 * wakes a queue that already has a sleeper, so a workspace
> +		 * returned since the failed allocation woke nobody.
> +		 */
> +		ws =3D zstd_find_workspace(fs_info, level);
> +		if (!ws)
> +			schedule();
>   		finish_wait(&zwsm->wait, &wait);
> +		if (ws)
> +			return ws;
>  =20
>   		goto again;
>   	}
>=20
> ---
> base-commit: 531ed942bb0df04f6747983fecdedce76a22d07f
> change-id: 20260821-btrfs-zstd-lost-wakeup-0b0ee88ed52f
>=20
> Best regards,
> --
> FAN YE <fy15309206903@gmail.com>
>=20
>=20
>=20

