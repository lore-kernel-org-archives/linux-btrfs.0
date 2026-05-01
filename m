Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 417303806A2
	for <linux-btrfs@vger.kernel.org>; Fri,  1 May 2026 10:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777629991; cv=none; b=oa0VCcepVOYEVKJUJlhDwE/zvuOsPrD1G2RQ9R0LIYM5K37KW4g1oBEQp8uLaH0CHy2Ggb2PRdXpzdlt8eTtXyALXOwiPSWVnv7tRrQ0H9oDqkVFkYUMbldQgUrczQvfyadrTeb0bq5+8HfWp83M3/lv3453bheR38+AI4F8Cuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777629991; c=relaxed/simple;
	bh=A1Ucf5g9ZpEWyNtoOTZQFFNBwiwrIWfQt6fXTp/2RzA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=N2clfVIToXSIGQBUWcBspIghn80QTGNKcR4E9r+pShr3QW5ukVbC/1UDr2yy/PS2dRp5JyaYymksheZiOX9jO31a39m4SGTqBfv1Des9TvEyphVIIWqD0XSvMeXiSqAK6YgaBLboQ5NbzmiXfZRd0G9xgtQT0rd0ZIEqieAUbkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=HpgNJMHF; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="HpgNJMHF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1777629987; x=1778234787; i=quwenruo.btrfs@gmx.com;
	bh=7D80BbZ2wFKXm+ZG++TjweVrYQBsH4DVgHwn2m/3I9Y=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=HpgNJMHFE/Cr8rUXljTAxOJ8ptwPQX8mwbCRkE50W0G4RzZAduAQK4X8ha7Gj2hP
	 E/k2RXlLLDaJpa2L3g87Pa5dG+s2acYUEsmKqKQiIQwmQRZuWVzpws9LxF+DbS7ni
	 Vl0w5xRjoDrkdun9OBFZePOgCx/rMJ+ZWTIxXtZnAM1dputsJZ9vjj/QYkrAi7UG5
	 ppX7JwcesYnNN5H3eAYbTHoj0wcZtzwhLG3zUGDfJ+t/iB1+4cqjXNGiT1CKugKkI
	 Hj6xDM5pcu3gdZqyTpF7sVPXUK0squdjJznfv6DgAep6m5xYoZY/qapzQU8hXYcEL
	 QgOgDEWcIYsk0KTtAQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MowKc-1vY5PQ3ARa-00agte; Fri, 01
 May 2026 12:06:27 +0200
Message-ID: <d248a319-d2ff-4520-8ad5-8967e8cce43d@gmx.com>
Date: Fri, 1 May 2026 19:36:24 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Enabling qgroups causes 2+ minute hangs
To: Max Chernoff <git@maxchernoff.ca>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
References: <22a4a11e1933a7b07cee7d6896098a5b251cb755.camel@maxchernoff.ca>
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
In-Reply-To: <22a4a11e1933a7b07cee7d6896098a5b251cb755.camel@maxchernoff.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:3VZgW9HU7P3YrQAEgHlemQyXV6D2tATUwdfIulJ59U1M4r0i4t+
 hMx7kCRHFuzVgGZctCFP6Ba2Ztx5JAbXQPkSKWH+cX9xdvAqg9K2Rr6ACcHpcShKhUpgVjk
 Rc3F5P4z1cXjpUdACDWnIuCW9ltGdJejcLsOrs7cxZWh/cRP/IKFIpcN+05PUVaviBiuTNB
 CIAmhiWbLJ3UkC6TEZdTw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:HBdhnpIADoI=;66YM3wbvhwiSsgjMKTaXcUtUwKV
 NW4NeMF6rzUx8fxZ50gbrhL75pnh/nqECY3h8hkVEYvE7QqMEyPCSRViSvq2NMKYblB5LgeSk
 UXSM23Cb4zCY8dyjLNrOjfK1x9zLesSJFTLjzUNMIfAcqGqn0iEJv8Hb5KAWuq6Kr7M7FZpTu
 uWZFcSjDPSFb8/xrdxEinmKEILjkLoB3+9xZY1aT4wqq5weogzVm0EW1atzNumlX6fZ4ez8W1
 NdZw1EUKylPgZMXidBQssiuGAS9Bq0UDKVjAwf/r+s572TYbswT4wplB9ShOYCWUYTSpKwp3E
 XYnRypil8Wlig2ULE2K/ouoBgXjYcoajN0Q0jcjyjWDXSPACIUKXEGgGvoBWea1XvXg+De+0q
 Waj1sKFwSQ9S89lMg+Pu8RBOxjz7UB750ai7g35CfoWBys+vhKHv8nYUT8+8S+Shn3NnyEIPK
 pMiYocqesyxUXgnmmIW3G1RxjD6upNl3mm/tR0/iEil6btE+NWjI1aoY+3QdpSSM9BmQOyCpM
 IRQmAJLtcVHBDjh92h4Dq9N2L2Yjy6lQx2003RSi1GhzfTCBqLK/bzdkx+8xKIihsF63CGrlg
 ypb/4pV/kAaTw2Z/Qk+xGAhCh4tTFRe2oL9ab5CqUhCHpGP36WvixwTsyjdwmW6OX7DYd6HRg
 WXWWhcx5URzm/MEex4k4/viaqUIl34YwG5SyxHSfZJl/o3FQKbqpyXJkC6YYZEIJmA30sHkpa
 vCMJakp5OGYnZMPqIVtWe997Uqh873DolefiYybhDejixEFPia6Et6iILS9kz2IV8pZ7Xwx03
 7dpEPmiYSYIDDpzT51t8kNi1K6vYdUj3iJ4Y+qs6rwaxodpKPlAfGGIMOMmGJNN/ISk4OVkq0
 0DugLgk0ioouueQPNOjN5pW5f4yf7bSFqXnh9LM+hhc1QBAd1v8Eh8AiC4ATcsi9otQOWMJo0
 9ppoo8Tx82IPe3bT8up24GWdSnigdTws2PLHTVzPN8pDUPtfZH1Y1MZ0O3f1Jrgm/V4Keu3yF
 0OVE1MgtjvB6pIyi1nbemWDwzjhR098mIUIdH1/pIVjtxw2L44ea+QCMXcTxhEjof+V86ApUX
 jrg9WsU3XMljklpjUKZ1gC24+EP+JK9zcd/g9YscZXV0kKudWMrlALt3PWxb1ncPNxFJBfNkq
 Z4VDe24ql61wVAmZ2D8ixb7UDAPvxJmGtoIVe8qPF3JHIjkMift4o5fyIqRjK3NKG9wKlne5x
 IrHt+wznRZzjfs4tzjoUaqwZVtCGyztQanUzJSomtpWxALafwEcKW3U7Eluv1eG5/YuAoQdeT
 hnu2TV5AnsPXgXZn1IIJzi2GrfBnBmdrbR80ixQaA3wsSnXcOVK/GyR4A06IcmSQirGKXrMFd
 QoEBl0goC24B7XCpxAtVipEUXwx88ikW2K6bDHMd1abUpJPHPujlpQwuTqucBIBoOGhp9kD4P
 R8hyS34W/HBz19/a9bDP+0cHNQeKSYttNHndLzhuPCg2nEAUhxr+g/8UUcmqA8DHO3f8OZCm5
 wH/+yA1DuX5zS+LlFnUtHaIynnRoI1yQ71XywJz2jeD5igAfAi1+7X8vULV3SPe5JO6fF0j4c
 tleFYppDCFAXsGa1e1vJ/oJvCKQnY0XahvIlLVxVW/eYWfHg+NUB6mpLYSO98GmXJjq47Y3n0
 iD5/UbOCp0my0sKEqrcDCZJcMY2C3XhViAxgKbvWNREig8rmeGZVYlcunnqtTIrx7Z3r40eH8
 tW++oZPjHxMVDilAWWI24N4WsES5p+u0ushbGNL3T2fYrgq5nTH/HNhSeQCHsnFAwFkbz6VCa
 oSZfRAoKFX3brjn/K6r48hYz+8xwZT1jrPMRyRXZcWTXp3np4BVULhqyippJJQvMf2yclN/wI
 SlZx9TKzeXfn7wyeD5JyDBskV3sfD3ettqE82GkHyrWDoXVfmWf95j+q/YABlyFR6pH++San2
 szA4In0fGFhehYtbgqPxlEtclgGysq3Pk26CLlV/JYsLIqf5ju1jgcH2DQfMwDgpITKznHw2y
 j/v5MMUtUAzSMz+f7tUQr3i87YnO1DMSGVs+L2xqQY41051tQpCUxC+7sBg+VXsTTaoc1pKXH
 iosb4PChlBclr76donD+hLj01Y3/K0fA3wih87gJ2CfOODVR2adPOl18Yccb104DUfHNyE/oz
 +qRXVJLfvxtxP3W1qlHHhb1VDqvtMycSVQ2Xes2xT3jXJup9mTgDSpMJm0Rb2nuUPgURiOMbX
 FyJKBwOy2XgZuVidtmNooVzLTFm8aHqIzNZryYy2/Lf/YxtPOnIaVSp9hh6pj6isqCvHWLW1N
 eJU9i2co5JCa2bY21bGbkNe2oXfOmFmCSY2b+MM+2+rnyC0mROVZ2uTQ0nLnLI3YqhgEfaXnc
 TDDaPC3V+r+WCjlr22m1+0CkbPYnoXRngYrp3k1/1/buWBMPMgInns6LK2m2lvyc8Ph6c2V0O
 FSwGWFBydWp7DnMqMWCePQ3K+ZoJflCaK7OjNVfvWqhw5WaqGdgupdMJE5v97jMBiIEhssddQ
 8eZOF5Sa2JA63IiKeXhgLoEmWrUVUmorP7uGwfxU4rj9TlXHuNCQESFtPJHwH6oZlMhua5qjR
 a3f4/0Bl9AB8r8edEqhUfMMy1/IcuqTdMfJubFGlbn0ksOk3hFj3OkU22/KXuzSikHy4LuJ/x
 U9yMf7SLuBGl93S7TjG1AFTs+tkBWV79sRxipM8rYxowfg+GrHC/Nrok7os71QoPh+O/UTRrL
 9yIVDGINtn5xuihMA7yj4hCg8AEEvlyhY6mHsyEfo5iYAmAsvVHUZrwOByq8xLu24aRAp0K6o
 Qge+yAPOfX/Pusk8zVs/WDJvP8Spt3qfRkDgLPDUuzpvI+i3m1ZsOSS3lt7fXJhpnW0Qa1sJh
 foiZw9tdK4rDWA9UpKojKvkCH6Q7ujqvq4AS5g9Bsez8czJs/WoUqJ8lIRj2A+PAQGxrkdndM
 tLOs0GYpnX+HkiVwxH3eA3uPx/qSlYytynxmL1Z953in88obZ9deyacl7p5NgMqBDuDUFEz7L
 Yz+SuBBEFB8GcgP7EdswqkRDOwPEZz5HUhIcRLJaQlse9SMHcup0YfEjR5zsnetxDlgWbwnLo
 IQr70NIGefKe5RwVRkO6XArheoe4zYUjNR7KD+NCzpwT5swzFyRjo25Q5xr87LqADJqyLT6pJ
 XYXIApm0kGKZlw/e+BpXcObk5zSyWMMYnqWr7+xQ5bUkW1lsDNM6CadzjugM7y4U7zepCgfkq
 aj/e0MELFS/5il92wHndB2CQxjTyILZT3pX+zx/z/bGdafUwHgHSL2wsGjOzUzFs7Edz4E7j4
 1KufwVM4HiI9TxF8OrfxcywqFPGV8VFB1dccj4M7LGmez2Wu2BlEJdsbd0jf9bb5T/r1VAb5U
 AenOJ/PxfsexVodxcTDl1Sesa9zsMiHYv5pb2n0z513w+Wy1wL+hjWpBvYBMEW/JYgkJnujZn
 c+5LIp98Ly3vJ6B36j+xyhcnJGWSbzmd4JnePxkbho0UshncJ1J2asoq7lbHNfOI+k9l7Q5/3
 K+CeaeJc3deJ6wsZrs6pAFfJsRF24jy8wscTPtphEpjTooY+nQUlh6SYqUznxFA2bQKL1tkuy
 EGArsp0kyvy3SjFq2/7UC7iz8WV/9dN28U+7lxczBoKEA+lLzDvYc8NvIO/+nYUNGK6AltsCQ
 +wJgFx0sMZOnQptK++ShUA+8fqGR7YwF/tp9cvESOa9257tMEj6u26C5GZRrHWzBUrRmO70iz
 KWHWNphV0LwQsXdTADlUINSTtB7nj4AgRzQEEyB1RWlFvwzanfSAiaXZsxnpH07mao5Bg/oH7
 HrNPalU9OuWb9ET0d2hmsh2HORwhzunJK2duvo8WF/co4I1t1+wGRX2WBPFUuchbrfWletWuV
 CnbRvnoSfdncXtwORZ8PkOHpYj0UIbX/Y2XCRxP8874P3Ahtb+5GkVIakGivkAPXLX8yKj+6z
 Z0xVj4YRM6gNGL2mBjgiT1plXlPWSvw64boxAxlsHPwJYM8HV5q0I7DjsDig8kd+5k0g2iwMd
 p3avh6Mo+dq+rld9N08/oT38hQynUoMXyxc+1rmnYdVzTsxOCfpe94fiCRVMPwFuMmrp8wTWs
 rkoHtjFIO2T1Tygz+ZhWABNk61gfXvnKT2lb0eeAREcGobiPAusZzngu7g5ZJ+ta1tArkChZ7
 jk/OXucCu9Z02YGtiBDI0p2T0UhVJovgZ9d/7MRCyComXFBmox4AeTJ4ARQi2F5P7TE+8jbD0
 Eu/Sv+kH6apWPq9N+8VekHyxlGa92YeYDdyALOwtZL4rG41KfASGoOx7Ckpy4bwTf6EdC++BQ
 JGJHBDbKaPwVbaIipt2dKVDejj8uASRPAEa+SzhP/htA0pp1ct3Cw5lp2IXJv2XvXsf3WWGoo
 n3CIKOQY3HNyQDHVLsUNxgNbVGeXWyVwHMpmhQBA+AnOc3M8V+gAMYjp8FDCClMO1RWb41J+D
 hsOLDUkC6AaxBa+ZQhEiJYWPkC3xUsbG4jqVcONBHmw7N3AUT2FJ8tOLsyWmppjJ836mlnKzE
 plLL2ajtVrvs42VFAAWhoeAIx4q0xVTQ6xBZsbFQHvUP+d539wyB8Ob0owskMuyUNlVIIrL8Q
 hUf4/g6Fp8rq25IkBDCnwTj0DpP16NGA3sdm9zVsp9UpZYDVz83404OPUqLTfCPa8MfOvSzyW
 1BzxknGwrq9Wrvlb96rN58nCcxTIn/aW9A2wf99KT1kYAUNQtlE8F9soEYIH+uh+98VzSvqPA
 W8Bf0G3lZfkHzWW3pHBuLesXHX3heFALc2DyhX/YL75pls5yUsr6pamcQLoW+nFEvksrcTdXw
 3AN/Xx9CTYV5+csdxnmPVYVtU7HD+4OVE9tCSo+HcKC8BoUsgGqtS5QRqey2eyR7eipHSM8ai
 U8MA2ke3UehOoLn4v4DKKl7Y1yA4q723twIPU2FKJ1FbPsTtoxMXKEOaV4jJyJfhKGqKRT+Ng
 ivsydMG8xXrfUu6FFtRut+yrIpZ9ekjAvMrGunHEMyTQscNVMEYNJ7Lkq0rQ9zPP19AWc08Y6
 f2vwv2XtlFKMcy6nC0SMx+NP1xdqsbfhMbSqrAn5R/P7OMf9Eo2D/fG1PZ+AUNh9zazlwVeaM
 t/je7pVDMCybHyyONu0H0UgX7MniUMeeK7M7WBj3rqTqKfyg07WcGdjZH+lERJOVUMjCiP09W
 OPH9J5rrPeW6wIKOqB7GpjcZury8Q1L8W6ttiFoeDd6aW3U860dh0RNYWigmpOSPwbhFzI9Wb
 Sa4b26dRGRC2AoUtdugv5hbQAiDybYK4FKV4WWVrIf37M5+2s2+n/w0ENBWsAiBW6xVm+tcwl
 qokJXGWUInu/3Nku9mXUZ9iAWyOYVcBZgPmnb1ZufLqw7d/yBP3PTUnpcspGtvZPYPzXk1xdu
 sVCiuVrBp7rZoQZgP9MDB/X9R7UukLfXXj57Vpzv0yqm+SqCnkdtoTTScflX9FtlpmJX7ajm9
 OaaictXRUwxiBsQ==



=E5=9C=A8 2026/5/1 19:10, Max Chernoff =E5=86=99=E9=81=93:
> Hi all,
>=20
> (please keep me cc'd as I'm not subscribed)
>=20
> Yesterday, I accidentally enabled qgroups on my root filesystem, and I
> started experiencing severe system hangs. When I disabled the quotas
> again, the problem went away completely.
>=20
> I'm currently using "btrfs-progs v6.19.1" with "Linux
> 6.19.14-200.fc43.x86_64" on Fedora 43 x86_64. I have "/boot/" and "/" in
> the same btrfs filesystem, which is on 2 NVMe disks with RAID0 data and
> RAID1 metadata. I have a swap partition on both disks, and I'm not using
> a swap file. When I booted into the "initrd" for my rescue kernel
> ("6.15.8-200.fc42.x86_64"), I saw the exact same issue. My filesystem
> has 309 snapshots and 17 subvolumes;

This is the problem, btrfs qgroup performance is directly bounded to the=
=20
number of shared extents.

If you have over 50 snapshots, it's going to be ugly, if you have 300,=20
it's going to be hell.

And it has no good way to resolve, the qgroup rescan (triggered by the=20
enabling) normally should not block normal operations, but for such=20
heavily snapshotted systems, even doing qgroup accounting for a single=20
extent can take a very long time.
As such backref walk will need to iterate through all the subvolumes=20
that own that extent, in your case it can be 309 subvolumes.

This long time of accounting just one extent will block the transaction=20
for a long time.

There are a lot of optimizations merged, but nothing can resolve the=20
root problem.
>=20
>      WARNING: qgroups enabled on a filesystem with lots of snapshots, ex=
pect poor performance

 From btrfs-quota(8):

      When quotas are activated, they affect all extent processing, which
      takes a performance  hit.  Activation  of qgroups is not
      recommended unless the user intends to actually use them.

>=20
> to dmesg to make it easier to debug?

Normally it's not that a huge problem as the normal amount of snapshots=20
are only around one or two dozens.

Furthermore, if you only have subvolumes but no snapshot, and no shared=20
extent (aka, no dedup), then the qgroup performance impact should be=20
very tiny.

But unfortunately that's not the case for you.

Even with that dmesg warning, if your system is already hanging, I'm not=
=20
sure if the end user will even be able to see that message.

I can try to add a check inside "btrfs qgroup enable" command, which=20
will checks how many snapshots, if that's beyond 10, give a warning with=
=20
timeout before enabling traditional qgroups.

But please remember that, there are tons of ways to work around above=20
warning/timeout.
E.g. offline dedupe can easily recreate the worst case scenario.

Thanks,
Qu

>=20
> Let me know if you want me to run any more commands, share full system
> logs, or anything else. I'm also comfortable building a kernel if you
> want me to test any patches.
>=20
> Thanks,
> -- Max
>=20

