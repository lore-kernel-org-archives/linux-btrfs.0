Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5519138238F
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Jul 2026 06:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784873939; cv=none; b=YPK3fp5D4quNKq+7sgkZB1L6LO00tkFFJ99woIwa9RDGCU1/7qAVEHB2Ac1qY/IzhbpcGkevNoprWHyvKddr+RdELRKDSuU2eGT0JAdMN4bZlirgjYKN3FVOhE95GVFRI74Dkze0qu7dDbYUXQ+b5il2sAp/erVE8a0MRO8Fm70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784873939; c=relaxed/simple;
	bh=+C2gi7fmhPXck9qSuURom/2+1NjrKbUizOSHWBpBpH4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=kUdntWU3sspca0feMvEdBzAAKqktHm8bJeqQeZoZB9HELzTaqLpQsp+xvKHdDojsZQcCPDI7kS1/e9petHzciJ2JBx91IfkM1+mKOcewMcVCwkkrnFkIu+4iZpL+TH/xUk7AmpSELqwvayIlOkrV9CcgZV3nfJyjObbtOUpQ2yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=DpmadHw7; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="DpmadHw7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1784873934; x=1785478734; i=quwenruo.btrfs@gmx.com;
	bh=+C2gi7fmhPXck9qSuURom/2+1NjrKbUizOSHWBpBpH4=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=DpmadHw7pJ66PtrTOxBUDATHxUmUubigNOLpqnqlRcukMMtW+B9Fb2qVJtsCLImE
	 e5nIyrxH6w2IgkP3PlzVOCatcAnGW4Fse5zE/iHB4qpJST1voYo7VM0WhvawdqOeO
	 TtVJ37xS9vrSn71ApcGhpBwXhE7IeYlgPx9mgla6HC4wMFZCcxYC1m34zpp4ipUEz
	 io7JsWVtvksYMlkV05y32uRgH9Nj64/93Qm/Fb3vwYkFgdrItkFa2e81oWQDrBliJ
	 vM2+qcwovf3EK9AcDMGd+krVXYXRy+RBbw7JImuoT5Vz+JXlGnACXJMqhVVZWWCw7
	 5tlCeT2kuHNMo17uYQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MvsJ5-1x5EE50F2F-00u46H; Fri, 24
 Jul 2026 08:18:54 +0200
Message-ID: <05a230f8-63c5-4f12-8397-952ec4c1849d@gmx.com>
Date: Fri, 24 Jul 2026 15:48:49 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: use ordered extent to grab the logical address for
 submission
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>, Qu Wenruo
 <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <2d35e00bd75f890fd61937b9fbf29a7f621e5605.1784868445.git.wqu@suse.com>
 <a391c628-dfb3-4eab-b9cf-5e5bb1931c7e@wdc.com>
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
In-Reply-To: <a391c628-dfb3-4eab-b9cf-5e5bb1931c7e@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:WyEScUw7W9VJa+g/+BqsdbAHtg+iLqSHVwhI71xwLOOPRu4PQM4
 cyNjomd9pY1dLYIYqDucsGcqXCjGNY18dA4ITgXp5lPweTNtT0h+TZfvOioc0dZVkJznUWb
 OumCYWljemCIxs4QWFYbBp+lShIEGMXqWzqWi/5K5SaQ3/JQt4Zol4MrYybPhEOS5PmusL9
 gKueUm1Z4zJTqIqd1bnTg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:RGDpf38yq/Q=;PUgGCEo3w6fyD2aM0NT2X+zFa05
 SGrHF7R7xYC4ppSqsvpx8vEH9JvOWUS98MLYbxgdWFfqBsFaxSB4tzv59TTD1eFPbSNtwEgQb
 BUggNW5blD+Rh/rTJ+lMDUFjby6i6v/PlC9YN4ChIDGPC2NukJiD0iWNbMaNFmoENRfgElXeM
 W32EfnUEefIYqbbNI4Y610y/H4T/owNW8J3EcaMH5b5vazEYNynN0TMWsQlc4EFKRi310T0rM
 D9/JadGKIpDtWDf8e5l+Qe9p01KZlK+48ZtkvWNvBvdGzFE9zvb9JZv+1wvMqEXl5whwWcYlS
 pmRE3FiQVbH+6qBSaJKJfOcFBZ0JBe3SoApqvdsASe+YcQxtvBzsAhQAeFEyv63K7gFZyVft2
 wQ03/nNYLjCxkcki5desdp0832/b9QNFVwA5Q8QHiRzI8y4lXfvItH837HsLnxtw9a/rgQxrR
 tS6iSS5oB7z+LT9pVygaUnXZDfVxUVR9G92qQxYnORkNhdvbGIm1A/4t98bXf0qkFPlACP8uE
 BkRvG2MZNKs2S49DLtMDuwl4LLjcJ35v9MKpWJ/XhHNssvMn4S+Qj2bxRi5LeZNmwz9kJYQ6R
 JnKf4goJ0/MJ0L8uVFtdOvP+Q0sCx+Di0AHOhcBe+Vq927mmu+U3Zioh++r1jyMy1fha5vqrc
 QUOWmeiFG+H7lo+IwS6ztNoyqrj8URB/XRj/vpJLoZm3/4lHCydepzoV+eHmYe8SkPV5EG57B
 5uJ4lk70Kzg2ckqouSzkTz4M//lMs2TYbAk29V7Z8mWDjiiIPmJinl9ZK76P6fin6FlJmldf5
 5f1epI2+HiDOhVaVnBAiC9uFdN2qnpnShnR2ZGkFnhNvKfe7o0zrj0vtRqCDamSi2m+N1CgBP
 KdVeqmWeWCB82vGYqoBn+Uowj1eUHzwjL3kVOv+mp+r9uGroj9tqNC1pFylXLByko4lAzYkOX
 8QJ3y5WNXPJS0A3g+uoppE+iM80nIgWt7igjqdfbKhlUBGfdvy5uEvmY2bRRruGd8TJQG5u+F
 aSclbT/BjmPoVCUiOO1O4O+OjhdArtGQsf6VRwB0cw7L4v68ROv+O7z9pwXRxpEvT6rFHOcRB
 ciWm9ToqF1/zCpvrohsg+hbkxWvrBs7LQZwKJgYLnRsS5jHd6Lszzsl/reFN9S1wOisHv0S7a
 0XuyMbYT/zxZBx/pSHPGOoHn2PuUTukH50J8/YXWhllmUv71F0fhlTeWh3hIFq2scmgeQ/n+h
 zClicVtD9Ufh1aRgqJVHQZAqX7txFKcYevK721ifNSZ3ql1AobKXBQnGFY/JhFU/roYZ3TosL
 UOeziWqRgbqf8ylXexoP3JVbsmG6IOgsDrBok804RuAv7tgGVkbgFagX3X0MmsxPJowcHR+By
 cAe3hV3VRYM66FTw9q3QLLXm7b8q/HhFK5Z3T5JLYZBBeUzqTpmR2m1AYynRXTeU1+h2msKyO
 rJBXU1Jp0Gf/Vs/DGG7h+UONvtTgxutjv6wzc7Y1/QEQGdB3Ct8NSwRMLUBRGiKzOJv+owrwG
 m/LCIK9zhOfPyy71lJH+WFYhs4hjvsWOMsfxnkf3lB2vqOd/O6+Wxoax3sJRvvMMaGv92bHPW
 xOprpXfgviPNBFS7URk365q3FCE3sQ7FwFFsVKi5SsqY2OEgaDMtbJs1rbO3lR/CwEBLJ5kLQ
 jZ1ZHz/1l0AwC2POsKtlIXcBV4lQldx4YGbPSvGAGnKcfkX5DJqIwp3ByFJVTqdyaGVOyhMfj
 AuZnXgWqvjjeOuZKhCgvO8kPUKczzsmY8SxvQdG8ePLtLYLI8Wu1zuiBGvo16LI7XHao20SIq
 YZhnHgLK/vJkwL44F060pPlxGdeaBhHUmgZP9kaw1aFnwnf7aBiWY8SpVI5y3bBiZDYa62Sim
 0LAfJMZ/HfIXe/vGWkUYi25gk+1WiTNpneOzrXP/nPhPIRCJ1jzV/gUhyAJRPrGKy+jSSC9gQ
 kRpxEC5R6jyc7BlGnWpOXL9/gY5EDQdlKzUZCm+Tdw5BHEdlZs9PyHQWjQeiM+PThN1k05AlY
 lwzAdL63+bbOZmQf5MZ10OKVpboJjpYtKK+V6q6ySR2nHeJSYiIocDF20naEuQ8uaCQNB4dF2
 pyBYgdLwGOoiHQ3n6wr9ZgDHok7a4iE13DLAa1r0SHIS1i/23+ys820CMCS+9sYntZFjK37Af
 iTaLUhgmC5ZO421KeS6U1RK4fbj3zh/bspGqtEy7vZtAEW/qxjRnFnnQ4iXJh1s1z2MHhIVnB
 wJGUHXDC85G0EeAnBk3Vg7mbUUk0wx2lqBRxrul5QRBva96lzSUA70pq0+Ck1IyPEfoWy0TQ5
 h1snSJgTibt7Re+d4OW2NqHfKfYZp5jq7cvFFiY0yUtLGWzOGUPQOhcLcr73+PZBWe829l7jH
 3gTsvb0i9biTjfwBwN3NxWD6NWtyG8RfRYmcNKtRPEIXECIdCTZIB9ttyptrbGfCKLBpDcYmX
 Ba6SCmt8z3T7ApYr0HcBANnfNhZCl0wCMoo9ff6fIFwUBszvaOOIqvXGKneLDQQuqhAwXZ1tX
 Hw5XbNOLShC5NxSq/5tZva7fZeInzD/NKBnISOZ2cbw9tKT6nW4FhMnPxbeJNaQs+phSG8lcJ
 M51g39ElR99x7scewHPNGGHYPxD8fdMRRFZkM4tGaboeghn564B3a8OY8hL8H+8bF3ortPTIn
 ltYxX1vxkNvS3I92SN+IVJMeoWJebiRDxQQNpNUZYo64QN8VzyEbCVUPAmM379vFmIBrUCFJD
 SsvLn03cAEVDOMxO4emo4gNw/GLlnAvfpkC4L1pCNLsM2xvHaAfcC6mqzLEkaWMgBAGP19BdU
 grToXRzEtuy3/UVoxlMgM/sMgXafyfAvVtrA9Q2jCbpeHCH/m3N4wb1lmpV25pIf5fm6DTicS
 UzN81PHk8n+EHYZ52FreeECHhvEVMExK84xOrSr1yOGVkbDCj/5xNe4LW8DGRGLvafdxbHHyI
 MuLy4daF6OODSK1rJ0R/hEU7ZJaY5oVTNDZD8fTm4b9k4niQ4/RBvOGKZ1kQi4xIxiC3STKky
 u5ccZCCsng0Oju1so8qe0U+HLMYvw+Yoc690jeu3IqdCGKTVy53zFES/IVrOv8IutAhVyajP0
 GeSn6et5pMFmXC0VtZmfQ4wrWvfnIYflFR6h3ih/oLtWOOGf50Hh15i4PEuy9gp7cd0h86BNU
 jI+n3O1qs7JWhDm49WzNfn9yyZ0DgKJRnZmlx5k2MYbVRyZvKJmgSKNg709iEW6zGdah75wW8
 uUHu4FQ03RY+N8bBq+o3/jQxNIllMbPRgLgLVcawDVSgn86l7wfHmOvtcvGFF0H7194Jj3l0B
 PiTSL6p04VfbR7s+CYwnEG4/GV1PzArCmztknV3huW41NdfjMBeX2BpGsUVtjkM/RFI2jNUR7
 7Nv4qbxgMPwzVP+fSwzcpiK4mhs0lXYZTkh9GGBPwkX0R5ohGfrvWefQg6KOtAyXGWlAl8z8y
 nKdL7svy58vloNL+18ePfGfZdEP6xQPa9nMkWNqS5+Jn5NRDN37cfwT08u9kHH80k7n0XOxJE
 GamO/anhyRChZyiV+6JO/A/qAeyQikZCLs4fRTWNjwh10j27e6e1pqFnm2GKP+eDCITwa/MLA
 r7XTWt+S+KSvBmM6e1HZdf+0dTlvMfD5SIW8zdX00eIR2ngHACkS5hb+7Y01vlHWEcveEVvYK
 HCPcb8GkahDvxI2qAzIs3fpnfYDTTmYcDBPDGgMrnfD4DHumbeFJewSvfvlGZvcFXJ8FJ4DtO
 ukOPFd26TlIlSASR5jXx/EEtWWm5xvl7Z8/Te3mrCU5E+My28WhyP1nC/AYTLtgd+CGUPt7rx
 TYznAec+F0MD3ueQhuszjvokq9M7YXNWLGX7fWEgMxhfvdDS5s2nfHhlyOJ3cGmq8KQ6H5t4S
 24fRj+oiSel25OtuffpTkj/scNn4tvq+pAbATy5hAvHj/LfhV9W56pr4X2vPlGVXICiAG7bBV
 5NgzWJpAEWe6SfEExegGFwy63IREQLdxp6mbtiEcvil5fBdPf/LG0CQ7d6bPinH5FyNpLFThr
 s/dRakg9ThE+LIGWL5NHE/4sn7l73/pK/OnEKaV7IgqgsZryxCFu/HdWRKYlP2sa0ECyuwHyC
 fGcnq+NuEgHFrFQFa3Ma2Jv1UVM4Y27/ifL14O2XIQ3ytb4KWNN+afsMnnTBWjJv8hptaOERR
 79hWAAePnfayP9wnLEj0WK8fMUDmbCRCBW/fl7on8Jv+huMnzTLNGZoncXU8lpy3ZeczioZKF
 gFSbMGNn2z2Dqtv6esxZm6iUv0AyAZ3MMVO1vY6E5XkA7GtLTAv0XEiedDtj+zw7I0Mp2LJPa
 055xwGGNPNhdYYWM0zltFo2xq51HCpCOKJgsJeU5/dhuqPu3MXOEIFGbg9AdXyqaFxLf2eR0P
 ReoyA+HdTJ1l/5qKmQSeeTOiOWPxLiYQf/6OsH9XJwiFXElvnZOlJ5KhzjNvmqW0FEPKBicGM
 nKEXCAtiWLu5FY2WyWNewUAH20zeI8mltW0qZ5R82jtrw5DQ/KzpVxaEExleoIBmveMw1X0pe
 pgNic7Le8L30SUpVwqdCM1yI/hrMwUFLIkTIInOoScI50NFrQm9KLjORpN8ifFRIl5NYj3gte
 MwUAI4yQVOT6Kq50UDCWVQB4uaQiBhiufrvUprJ4ZHfeRuxWzn0vPYqQ9TZL7xK1ehf6bMyBw
 7qcxv5wB8p5dTlFY23W937QyEFfrOBwOzCyBwtcUvI3uOSdkCeRPFYV2IHi6o27eGjtJJMAvE
 gIDjOkm8RPv6SbjfkciZWKMYs5Yk5ZTNLcbWwoQcxlIYBFZ798d3n1lo9Yy3KZ0ApusJkVJdR
 G0rzW58FhbN1VN4Iz5UtjDLoi9Wn2W9Ms4eYOeQY3TAciBEZa1ETb7DfXuS9uliE5VLcz48Zp
 /30iD996mOSeee2TCPIEI+GUtldDBNB7qi/4nsV2DqrW5Cpn5Wkg6/nM4gdximcoRg0A9072G
 IobphTh+18CA3L05j3vtYcsQY56sblICKnEXNLhfSQv24mGGRF59lcKXK2tBihDJ7EI2Nd6oi
 fPoAGReCN/zuAhLelVyl9CbMQ2tWBdPeu+R+rCZifORCsD8G5AqBIr/t1gE+pXAqL5Ly8YdJj
 cFtQXBjRtAWjxHdIAHlFYfi2yzF+hf4vETXqoi4cc+4Lvsy2GjT8kOgV06fe3KdJGdT9Ctwjh
 IXybOfbjW7F0O7fmtpXlTYsKNWTO2eNw/hv7CIWQR5ElM8cpmkSLVkKfxrsgLOBnWf+Eh3Jxd
 QUGHyQb4K/jyjRJRlleb91T1HYdMMnAzoCYOJQ0orZA2V9MWayt2UeiEd8V5LehB9gQJN07O6
 bmDWWsochCwEBMMFyMHNxG5pS0Mn8qdslLSYCBwmZ+7JxI15eobuyUSeUcAWx0gsyshanR5VU
 nV2M2CqwmQmHdhtTmfEJp7LUc/4OSS6oO3xZlUA2r1Fs5UCFUhCJfKOTCpIpiHSeSsw6dSbp2
 iqA25LzMWphuE/dvlpgcEABpIrwasz6XGsDnmf2L7lF3jmt/b07UhIpZhRayeX1eqM5UyfSWn
 /7lz5IBbwZLAAQaebtEb0WrYZqFkl/OHPCu5vtmDQt+0+24Zwd8wEbKpiheuB4fAdpm0Zg==



=E5=9C=A8 2026/7/24 15:38, Johannes Thumshirn =E5=86=99=E9=81=93:
> On 7/24/26 6:47 AM, Qu Wenruo wrote:
>> +=C2=A0=C2=A0=C2=A0 /* Try to reuse the existing OE from bbio first. */
>> +=C2=A0=C2=A0=C2=A0 if (bio_ctrl->bbio && bio_ctrl->bbio->ordered &&
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 filepos >=3D bio_ctrl->bbio=
->ordered->file_offset &&
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 filepos < bio_ctrl->bbio->o=
rdered->file_offset +
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 bio_ctrl->bbio->ordered->num_bytes) {
>=20
> Nit: in_range()?
>=20
>=20
Thanks, I'll use in_range() in the next update.

If there is no other problems, I'll do the change during merge.

Thanks,
Qu
