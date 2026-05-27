Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49DAA396B70;
	Wed, 27 May 2026 21:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779918020; cv=none; b=G0GAaSgFOVjm/wQh1qflmNgs9ndRL/hO1iP2rTJxgoNHBv4Mt8NshhkSJQXkSsaBHwW5lSQYxGkK5ZDDGY8+Xd4FOCy2pOdeDc3gYAlyI0n5eOG1HmKwUkHAPPg1aO7w604bL45Ix5ad3ZLCYz6+Rqx6AAQF3EbGv5fsUPFwjjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779918020; c=relaxed/simple;
	bh=EkLmsNTwedAnTf1flJfLLhe3WkAJepQmlx7E26nvqOk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=piEUGWy+1sMxYKxhiuEGSDrm3F0BYAFEZ5TVuwIMFQKwrRCf3rvRENe36EfInwgLO7zTuyzkK3aR+qsOtmYXnDpV8hDyhHgUFSpA1cW2VCmyj/1s1wm8wVwKpP/8ET6rM1C4E8dwHN+4sOvRrr0we8Cm2dbFoCQ/X/jeuuzFgBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=kWi8uvR1; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="kWi8uvR1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1779918008; x=1780522808; i=quwenruo.btrfs@gmx.com;
	bh=vICc1c81uYj/Eq0otJeefy9l1xG3/JJjQ5kIda46RBM=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=kWi8uvR1wvcgDJimqd6TzWxW4AeBc3/7cKn1kZ0VwOw8L/tcpzf3xV5Odz6UjI+N
	 DWU2L0n6ezzk4H23wY0lmhYJjooOWFe8XpkpmsD8w54eHauuVwr8c5wZiBornT7FE
	 rDsgc4ApsT4vyYwk6BumTb+flYIvR4MT1yzsX2+ikkpIybLzFvIhL/h0YkibxqGLk
	 V44YU4VyDc3MqK/C5pqU5MFNJ/aHl4rVZtZ8PfK92C3EEc476mjZWpgrmq2kxKq7Y
	 a0rVoZojU1Q3fsD9jrua3KNE7m2EIXMnq1NnGgrkjlXQOT7qTyJlkqRaX1rLhHUrG
	 SUIG/0BosaGVcx09IA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MlNp7-1xBHdd1BZF-00nc00; Wed, 27
 May 2026 23:40:08 +0200
Message-ID: <2a0b085c-bc28-49b9-8c75-376ad2fe9daf@gmx.com>
Date: Thu, 28 May 2026 07:10:05 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] btrfs: fix false IO failure after falling back to
 buffered IO
To: Boris Burkov <boris@bur.io>, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, stable@vger.kernel.org
References: <cover.1779846117.git.wqu@suse.com>
 <b3393b113c45ac7bd7b2649576b5667395c22a1b.1779846117.git.wqu@suse.com>
 <20260527160112.GB1981571@zen.localdomain>
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
In-Reply-To: <20260527160112.GB1981571@zen.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:saDkYBV3EOYHwtGo5D6xVVWzYsluo3IWEFDF+92bOLtDYggi+wU
 7UXRtuEvr6RxL7W2Ynn799JmNNX+qyja+8EfBACxhnv1JbPiYe3gmNNxcw9p2gtprNGyTUR
 xstrdqazBjnZqGa2clV1w0qE6QJjkdsygod/W+yVgORT2dQQ0X/Ycb+MnzbSTEBtfpqWS+U
 WJJqeiVw8PuX2E8hgsVBQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:JwRVk2ucs7s=;9Yy+zsJ+a5YYwvUkXDNuixL5M9A
 2Japl6vvNvzLRi/ZG1i2+eo+Pyi4LThGqRaMSlKDaOC4p20oHTt3PpAFr39P3ZnqUZ8LNhqk5
 VhfOFcxlPlb4fSyBXUpKDLJBGAibV5NRYgFOpWciDPwoCwULjLRERplDj/ABxYzBq2+VMgMBY
 FxttHcbpRAh0LtKyLJtFOdqERYOjQmHGEUv7vhmS23xdFKqik7Nqzjt+CxXu03mZY0KWIlQg1
 5nDdIxiIZHF561aslblWc0x+CbSAc1u7mAPmIYCwt7QNMYI1QqwWYDNde5k6eVVdk7JUl5RPv
 i6NONuu6vaNXOg0xzePxExH/CfkGVnimOS2oCJwgFEVm48zvrvddZ+PiLhg62Sj6HZx+IpF4+
 1tNq5vpcmyMeQB4SF+SpkJLcYfiTYsYJL9AV58zMdxg1b0Gawugrhx9aLPPKn/jtvnukRn7jd
 12wapRnsDKKGqLaXg3uMbcx67RFaxr78r/ulz9cej34GWkr13EsjmfD2khv0z0MOVTHqs7Iur
 Z1i3+R437fz4Ik9iWeFEG4nTtyJ1qyEqydR2ihvi66R25vSWEisHKiL46kaOYuKpZ2+cvMVD3
 wWyg6SiirF0zIIxKu20QIwsbmy6zJa8dIY/4aDK6l6dqXqcPUWMKKpJFcboyyuocxtofx0YrL
 TT/H6gH+wPaMO1LM71Xgh7ZISQ04DQpajSLpqbMdzsjRfXQLSxJL+cz5pGf328SZxNkbiOOrt
 cAHNWOjgCZunoQ62hChQh1AJ9tXrEsHHaTsiYosxdXbUGR3aQl/gKnEJQpUO/fjfy8Y97HeAK
 xL8GVOIfZ4KoVnWqq1yds2bUYY4lvI6ufaaZpBrRAIiCXdnJfEX8CQ2XKCfGJFE+yKjrzjdZQ
 sSiNGYlN6lOmkptCNBGsayDhjlUQVFhgu7xGQr/720tfoLyiMoWfVipgr7o6Ld4HhvWqYFonG
 ucAqfFd0pdBGqkmpmXo38SF27iS04sOCzn6WbljQElrf2+qaBXP0QAFy1sgOlqWh1f+6SxUxI
 ZGX3pyIRyjSsD0y40esnhn7eh940l5jQ8GsFvBEsloEWjz8WBbe0L6gelOEbzyz+huV+oZ6t9
 X8KCuTlTKLhi3TAx0mTNMHaCezAXTh3E/7KVcA1ULEvWdIIN0LQPeicVGMa3fq4Djp486O4OF
 +UWWB/hkCxuytnu17AbsvZHzHWNBzd5yfy5O63iSDHxk17yBUFF+SakMhcB6VdcTTSIYWE6gr
 /dbRtwTZRDyx2ZpjwAIkZUNvmM5W8D7HoL0P8Y0SwisEY2cTiLYdDQHwZvaE4IXga1O1LyeBB
 9cScc8O6Fg/H54kptpp5R7ZkA90tL30qR22okcU/HExTc8v++p2wM0rrUxUXEZkWNadTW1Jx8
 RISKVN1A7NC7DWHLWH/k5k2Q3waRj2oz4Ybtz4PKIIkvq1ctsIGIYJYqKj5RIbSDDHz4IwZEN
 +8+hveSDJ8e7jSNrQtKP+NvI0n/n2dWE5nYJDShfNCxEQhoHbuivAe1BX1vLCQREuLJ6s3OyX
 mj5lGC6vusplv+bEVO/83q/jTEygJIEHwFBcwfOMBKdzhJCwtcu6Qh7lse1dpIn7ezKIGCmK/
 hs8e791Hqp+sJHg7p6p2zPeWPeRsMh2nyZhsjPBOxgsIjFZN8CObp0wPnq+9lIo5qaT/KQjqq
 WhHK32CdAc0eoRCp0TTb7rLodBEXt7lq+Z/ugOcNQGk9JJUG7tOW7g/ZUQuYnh4lr4DbKmtLm
 Rz0b+MaaTyb9AoS54PoLD9oHB4+YBPGrWANvJBazNgMxzxcX09kX/EM0asPzMDJtPeIE3txk1
 Kzb8RzkU2FwGj2XprzZLcbQAkoeAlfsnfcm177YIFILBJoMWps011SbeV5kYIOcWT70xKmdq2
 ON8Jyqjl9dsmn2WBsg6O2BQLh6loF87/StewJWniumh8NROmSujQ72Lx2A9PbYnGFlKuzPBN5
 oZjwd8/FfwaUjnuITmNh0Er9z88ZEq5kkVSVpyBdJtjb+7dTNp/1cSbbkWBxyva8KGckoak3H
 nwNwu5nhziZbUh3UL2GdTOnxUHy0q6AcKDKNhIgSITSwlvfN56cU2E1pC7Jf6dR79Ux6bYNYe
 IETInW3mC+v+0s1m8h1u4szfvpcGpqLlq6pHcMjC3H7TqbwszDZHH58JNC/zpjgDd15NpuSBj
 dGliD3JiguFdSTzbE1oVTvGUd4UJipAPz1rOiaIQX6/aya+hSzdUXlf1t2ay+OYunIYDSDdsc
 iQcoCfRhSzeqiECh8WyxOCadegt6Hv1Z9FY2VVg1IUl8QasQBzJYPJDqejQNA13zrxvRoTAA6
 xPIvXT8qCX/MRkH5fBgDb1NuRzbLYt8BHkb4PWSdVRaiL1GBWPcdu5oSGBynIXnvmv0VWMXYv
 OKXj57BY/ENv+1/4yV4OX0yRQEc59S4qunDqu7yfvKAh/P7XQxWTY9h5w+bHV7IdiMz2i49hT
 9ilCnWvKpVmhb5CE3/lXAJCqFANDAOHTAGLY5LApJ9eHuIOd+ScD+uCLqbkrOEb0aZJKMZi6z
 XbgZwiAaEotvVj3rHhR3NeAzTS9wXoQbDXnxCwlU3azJHxlvIA3/j6+QfekEt0xAqL2KYlMxC
 e0YFN+2qzTIRvVu+9XxD/U70Y1R5Qs+CiWjB60zV1V5tflEb5PVquOaB+tdyYTMjpHwNnKF0q
 iYJA91tA5zGKrtj+jPjxEV9uVUxigNUq0Vqdak6NsBScJ7KOaulhO2upQgAfvxzVbGZ6MRp/m
 yRYxa+98Syq8Ht3okG/zRAkgnJjvJ4znaL8fXqFcFJJskHQcK1VS2jg+fGf69Wkllv1RvPo5u
 98xgT50tfncUS2NSD+RLeHqZqA5/z1H2HQciXoXWItiEfPgLdQbvR08M0mtPkmzIsaDCn5XVZ
 PHN5+YNX8rAqAU5Iy1FEQsD9lyNO//mqw/RambL2hGWAlP2KRR9/hx1Rh4zTr3/u5/4Ssl915
 eDU9vgkLu0y5knmpsOxdiFrdvBItDh19VhobvEB0y4DxYOhrPtVXnf1yXfe/rcZK7uQWbmRCH
 YyoVhlVUhcTcTaQuuutz+33br9mTtgt2GYo9dKFcws6abJuFv94xu0dvsusrn71eIQvq9CRZF
 WMczS0lS/3rI1CTgIHLnZQqx3aaL/Y9n/tQuPY0WSA6otJ2A5tn0N8EaVM9FhhnQBxsRchrvx
 oW03klb5+NG0CTq1LkVbJftyNZ9oovyDxTm512J1ZJ2kzSPVRzZ/NrBsCh8gp2UhU6QwQ+h7u
 M2zVbUfZonBEg8OGrzPzjJnOUkCEy3B2e244U2Ft6+B0mLSK/cEsy3eNn7B2N3Cl2iueIuJC2
 5V9RlexOlLFH71t+osCvfD3+7ZpxyAfxt/t+iv0PSDocUXqx2AvkT4fgY7umz/hmmkbcWCwGt
 cXVXvpamuSDRzGrybvDshUGxfV5/+pCB88Vdi0wy83uKVWxw3bxKsckZT7JhDWiMc6vsaqQkK
 qKOv0iPjsMt3RhWwR9QvHAKOx4f6ppO1YDRerohIq9xsSZCg9TDGHcR1HSs/5SkeKpT+d5PfI
 llWfQO2fS+qKXHJNjWm/CleOk8FgAsa2vXK9Tr807q3q9l3Lp0+z6UP4d3UyvtZzTp9/G1eO0
 ooSNeNu2+uzhNafhsl5PgztE6jRnNMzPy0o3d3ZNi1NOlwEqhsM9fYtC4xp9wUFa/4oU0JgLN
 JMmZIaqtlrT7sMQxxT27IkvT+7UcS2kqb8h8z4OLCeKn6f5iqMlDPRoCPpkxvaNCYDPPqfNxD
 clzbJtTrxEu5LVBkOBoq6Tg1b6AhtcRRmlk4YWklnSAAgBHolwIM9+gMi6qAJlbZahjiUFU5p
 6lYpo5Rs33sMiLXAMq+10HpFa8mJHtoAXlCKY2MmtzHPCos5DYpM8oMZqW5CoUfaXmYQF7lCA
 tWbK/dKY7TT2VJatz7OH0UbHe8gpDFz2FTeFjl1oXcVKh3iBy961av8oW9EG5ldqnTEgT5nPc
 82W8yxLE0lQKhrz25rte+ZtEqqNmKQv4wyyC/ZjK9Aw+h7FUHjPBQA6WxPdt4Fxd/MVG+z6a6
 J3t4lv3NVyhFdV30OZ3XuFaJed7Yk2NPVho9ten/dOGYCNurkduasAl6hFOAUfO0vCZunuJqD
 8wlMzTt+cu26vv1yyTh2VO1xFWkwOJmG0cGLRfS1c6wr9Uku/D1KKCfKqNW08OtdV60xfbfXU
 S4AmFhVHFf3iShRhiR8nk2C+gTXrgc1o3NKxKvcCJE8CHj8u0FDxhvdROlVRFrl0vNwbshrzx
 ryCd5WUJ4dr+n4Z6SghuUDrYey/Ty7AIGCoQ4kiTzTz/TkHK+3zGG2+du3xW+3EecwsgoyrML
 jQoJwHk0Oah13JN5RmR9R1NhdV4nyV+4sYZHkqtfpx2RzdTXrEu01JsubnuqFoeMGgtCcH9ZD
 nYK/H0vJJdU+kiq2YELuEmRHdEWByrHn/1qyRYDQzId277+ZRb1KT6fN8vkPe+6O9RmwrdxzP
 yHRtjIFQNMceCdd/9vp5n9SOncRByPVXbW2RxDyiNBXqcgdVwmDa1TwFI+h+xX+SCQVyjnGY8
 ohDu94JkwVAL3BH+ClLaByTDlvHw88PL1BTPa+X0A74BDhHvhP43TlYdpubCdmAK6T5ge21zv
 TuS16oCitXkp8++W0oZeNrCL72Bw5ldGPrvnRh5iLbvfHRDqISFJ05jFbEY5dLJi94gE7Da57
 ob+z1BTChpaBbojPw9Fz7FsW3pcLC4bwefwofsH5NPqQZ1BF42AiXfd3lirvpEB9PQ7ZuEelf
 eKh/k9ntZXMxh2AGohEoPE9fHN+6N2WmRRwlNJZPCPX+6VoOgTraYNRVfAMq4Y33cpEQ8eSY0
 fmh/B1k7Uwf+xSgLnRxt4AwU2yPazAxjIWUxA/59gMHiEyoIb632J3xJOeBYXIXXS/N2AOjoO
 7+82Q5orqa2Yvhog9NElY/QEv1/pUOM2FZMKP1n1evwcog+fg9Hh9Xbr7hJHfpozrEIhfTqE/
 rStioNVTY3yuLF9g+3++6Ry+CGEVknp/bXUjNKEb16pJQveZyEqbew3qQprEgDTpQcIHLhLup
 Y3fmKujQr4d3O0XQSL1LmuwyPMuv0ctmK3ljIIpxHEmTCKe2gAdOrLUbdAwsNqNxrZ+ZWCeWe
 zrjMWOK3g5WYX62fFUht8fiZpQg27j/s9XAucteLz7Dpg03FIL9LguP8LXrKmig/vHi59xuhX
 Hbz3IwMIAt4Dq9r/Kl12zd/+wxy3kgCGhSw3nHoEzcYSa3o7/+rGC0LvNeDa3xTpwQLqx9qp0
 Jpzy930cAJ/JbndgyQfuUi7QFsHfBoZxLkiBaZzi+gHE1uJ7lOXIhDEjkMM8Pc9GzsijSsFfU
 nw5qLTT83mzlmYoww3VXhRiXrtYJvoVgJLo8fUtrcZYbifCgfoL/9zenpxOaZBa13PucDW8xr
 iWq3r9Hm3PoLk12+OqF5/qi9Ibtrxuw9gHSd54Il42FAfTm3HL79ZH3RZeDYRqlYgi+ymhe6S
 v3VriLpyPrGQ9KAHKvriNPsg5+71Om7tDiPcLrGXPeJRl0NWzzcd0qip8k7s05aDfCcSSG5b+
 sEy+54Yi3sIUtOeXnIj0oqW0FkxaGDa5qfUpe4rBR8YfhFNy



=E5=9C=A8 2026/5/28 01:31, Boris Burkov =E5=86=99=E9=81=93:
> On Wed, May 27, 2026 at 02:36:44PM +0930, Qu Wenruo wrote:
>> [BUG]
>> The test case generic/362 will fail with "nodatasum" mount option (*):
>>
>>   MOUNT_OPTIONS -- -o nodatasum /dev/mapper/test-scratch1 /mnt/scratch
>>
>>   generic/362  0s ... - output mismatch (see /home/adam/xfstests/result=
s//generic/362.out.bad)
>>      --- tests/generic/362.out	2024-08-24 15:31:37.200000000 +0930
>>      +++ /home/adam/xfstests/results//generic/362.out.bad	2026-05-27 10=
:21:17.574771567 +0930
>>      @@ -1,2 +1,3 @@
>>       QA output created by 362
>>      +First write failed: Input/output error
>>       Silence is golden
>>      ...
>>
>> *: If the test case has been executed before with default data checksum=
,
>> the failure will not reproduce. Need the following fix to make it
>> reliably reproducible:
>> https://lore.kernel.org/linux-btrfs/20260526070055.60193-1-wqu@suse.com=
/
>>
>> [CAUSE]
>> Btrfs direct write disable page fault of the input buffer, this is to
>> avoid a deadlock specific to btrfs.
>>
>> So for the test case generic/362, it uses an anonymous page as input
>> buffer. And since the page is not yet faulted in, the direct IO will
>> fail with -EFAULT, causing us to go through the following call chain:
>>
>>   btrfs_direct_write()
>=20
> I believe that when direct_write() sees EFAULT from btrfs_dio_write() it
> should do the fault and retry, not fallback straight to buffered.

It doesn't return -EFAULT.

btrfs_direct_write() returned an dio pointer, although it has not=20
submitted any bytes for that dio structure.

So later iomap_dio_complete() returned 0.

The full trace printk looks like this:

  dio-append-buf--2501    [008] .....   627.444860: btrfs_direct_write:=20
enter, root=3D5 ino=3D257 pos=3D0 iov_count=3D4096
  dio-append-buf--2501    [008] .....   627.444905: btrfs_direct_write:=20
dio complete, ret=3D0
  dio-append-buf--2501    [008] .....   627.444906: btrfs_direct_write:=20
buffered, pos=3D0 iov_counter=3D4096
  dio-append-buf--2501    [008] .....   627.444935: btrfs_direct_write:=20
exit, root=3D5 ino=3D257 pos=3D0 iov_count=3D4096 ret=3D-5 written=3D0


>=20
> 	if (iov_iter_count(from) > 0 && (ret =3D=3D -EFAULT || ret > 0)) {
> 		const size_t left =3D iov_iter_count(from);
> 		/*
> 		 * We have more data left to write. Try to fault in as many as
> 		 * possible of the remainder pages and retry. We do this without
> 		 * releasing and locking again the inode, to prevent races with
> 		 * truncate.
> 		 *
> 		 * Also, in case the iov refers to pages in the file range of the
> 		 * file we want to write to (due to a mmap), we could enter an
> 		 * infinite loop if we retry after faulting the pages in, since
> 		 * iomap will invalidate any pages in the range early on, before
> 		 * it tries to fault in the pages of the iov. So we keep track of
> 		 * how much was left of iov in the previous EFAULT and fallback
> 		 * to buffered IO in case we haven't made any progress.

Furthermore, the page fault in won't make any difference for this=20
particular case, exactly explained by the comment itself, that the page=20
cache will be invalidated.

> 		 */
> 		if (left =3D=3D prev_left) {
> 			ret =3D -ENOTBLK;
> 		} else {
> 			fault_in_iov_iter_readable(from, left);
> 			prev_left =3D left;
> 			goto again;
> 		}
> 	}
>=20
>>   |- btrfs_dio_write()
>>   |  |- btrfs_dio_iomap_end()
>>   |     |- btrfs_finish_ordered_extent(uptodate =3D false);
>>   |        |- can_finish_ordered_extent()
>>   |           |- btrfs_mark_ordered_extent_error()
>>   |              |- mapping_set_error()
>>   |                 Now the address space is marked error.
>>   |
>>   |- iomap_dio_complete()
>>   |  The dio bio is empty, nothing submitted.
>>   |
>>   |- Fallback to buffered
>>   |  And the buffered write finished without error
>>   |
>>   |- filemap_fdatawait_range()
>>      |- filemap_check_errors()
>>         The previous error is recorded, thus an error is returned
>>
>> However the buffered write is properly submitted and finished, the erro=
r
>> is from the previous short dio write.
>>
>> [FIX]
>> When a short dio write happened, we shouldn't mark it as an error, but
>> treat it like a truncated write.
>=20
> I am quite skeptical of this as the proper fix. I looked into this
> really thoroughly back in
> https://lore.kernel.org/linux-btrfs/20230328051957.1161316-12-hch@lst.de=
/
> and remember concluding it was much better to do the OE split and submit
> separate direct writes, and I believe it was more or less working. I am
> willing to believe that the mapping_set_error() thing slipped through
> the cracks, though, so I apologize if I missed that detail. Has
> something changed since then that makes us fall back to buffered on a
> write buffer fault?

The buffered fallback for datacsum is masking the failure for most=20
cases, and the test case itself is also hiding the failure even for=20
nodatasum mount option, so we are not detecting it for a long time.

Secondly I also believed the btrfs_dio_write() should fail with -EFAULT=20
initially, but that's no longer the case.

My guess is iomap dio error handling change, but will need extra digging=
=20
to pin down the iomap commit.

> Or am I misunderstanding something about what is
> happening in this case?
>=20
> g/708 is the test case for that particular corruption, FYI.

That's also the test case I'm failing with IOMAP_DIO_BOUNCE, but I think=
=20
we should fix the g/362 failure first, as it is already failing now.

Thanks,
Qu

>=20
> Thanks for looking into it,
> Boris
