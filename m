Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7BA21255A;
	Sun, 30 Aug 2026 22:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788129333; cv=none; b=ZIzLujyd+YKS9SGLsOylMj12l3593fV8gxHR6ZcfcOkH3ajPtnrcVoWsjsXiOqYPkJ0MpqGz4KCFwIzliozZSlnICgfZ8FFcLFi0QjXBVqqPcQREA2u7lBCeDnESUFKIc1RWklPDGrspYY5OQLR0y4M0ohhrby5bHzM3Tm1ccWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788129333; c=relaxed/simple;
	bh=2cOmUu4VCZerbxZrCDDQDGZn5FyKLohGz9VvEpQOR9w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SXkTycT9q3JxWYpacyDGSOp1AwZ4GAazWB7rVVtLwySZ312GMlPw3r6zMYyBN/PfXKaKGQbCnsiuk0EloHKLrOKp+vKptCfG49kyzTZ5Q3Req9oWm84RzctVDJhYjtfBNB68sKCaqWPqcqKkPscry0W15Bfnu3ro1MKbN4TQ6cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=aE++5unX; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="aE++5unX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1788129321; x=1788734121; i=quwenruo.btrfs@gmx.com;
	bh=t1qO0U2XW54AFLDTc5NPOoGz33y3P46xItWMjpPcuac=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=aE++5unXQw5p+nh4F1o2/T/oEnui4J3TrQ82gZ74neibdJWktPlq9DiD5byoPKbp
	 9nq9xVyqo7XHGzLtttF9Ymv/3f3/cfnqZM3E0MDNGR6vV7T2eWqaai4Z7E3R7wZYg
	 r8tLpMD6mQXp0dWp35G8nbhdQUPWa9ct+38YXwoSKA84Gb4zpKLVLG/qCo93SZwy3
	 FolWlScm3KMagUw5RttG5/sfaOtPj3F2u+XEqO6fvkLNad67iuyF86c0OyrVa3RtZ
	 BXtWqXgvMQoaLvudLekIuXO3975WN1sf69iAOECjcu3DAVP6lcuVWntjEW3UjRUWz
	 fe8+jU9b8Tw6FnLugQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1N1wpt-1wuOEy04Ft-00yZB8; Mon, 31
 Aug 2026 00:35:21 +0200
Message-ID: <9a5f0b52-a363-4b7f-a207-677fa6938cac@gmx.com>
Date: Mon, 31 Aug 2026 08:05:16 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: fix deadlocks with transaction commit when cloning
 inline extents
To: Melon Liu <melon1335@163.com>, Qu Wenruo <wqu@suse.com>
Cc: clm@fb.com, dsterba@suse.com, fdmanana@suse.com,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <a74ov5nvs5u4nkqhrs5lp2jaj664wewkqqsjxzhuemzazzmzvx@eeof6sjb3xdc>
 <bbcc2791-442f-4bf5-aabf-40eb2edc0165@suse.com>
 <byfdpkxktwidszfv3yss7nxajjioxq7nhcmnxrzrwkvvzqaejh@ovl6qwbe6du6>
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
In-Reply-To: <byfdpkxktwidszfv3yss7nxajjioxq7nhcmnxrzrwkvvzqaejh@ovl6qwbe6du6>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:MD5zH7sRSqUlPfWyMdtjPI4tJYX+7hXRFUsmKINkUg+TX/Mxudt
 D+xk7eeAxqO8r/p9mnVNdNQZbmFtM6xcSWVJJQr4Ps1qUeStV9tdKwsET9erZ5wY0aOEUii
 +MyZqloogXj7+atcqCnT8pBluNCeGa3e0gvQfIifVVu3OsE8KsSpwE4k0+AKKBkZvJAqDna
 Dj5PiC5F+TSVQAnTSTcjQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:1ZxJhpSP2B4=;ix99TjxOCbxoXpnAKZkEi4N1hvW
 dIx/hC21YdgJbCfOxjr7y5G2b2QiTb52Wjnes+k18V3+EZVgfZHTameVfP1kMrrBuatU6Q13f
 QPDrWk4LGPtzHlTwg1TROyG5+5Av9uNPHFlVucWz5ZiriKAf+wFxpKNAwjSHbDnsq7ijTDiwz
 t+XCa+dNcroy54+HS0QWJ4FnJamNcPzDlMHivGJx56zSy35iPLS709OQ0mYaWwqflk+4Shgug
 f0JMlNF3x6LprI+phfp7x+rm/o5QrDDpy4UaPHItIsUeuh+FkllXAe2QpOLiQsqZF4vMYaWhm
 CazDIHD2nWIs95Pf+vSeYSzSXqbEJv4Jbqn8ZwoyC0zlmYSci3qVUzb4RmxRH5L89oNRSFPBO
 uRo9dAapEODArsBkcQNA2i9S9KGKBl3GVxS5/ZrqE+Lifg79wKinXo7vbvjHZa8AVRbAnF5v6
 XJ0/pDc+UmEADqxMqh8BMSoEa3X7jewoSwXC7ftZ3oVXxC0XQ9YEzCqA3x6gAn4n4A1ObzoIe
 JRV+bHjUODXTitQ1U97taMFzbsf29n3VMcQ482MYcfdVUSNep6cINkvYkjWnvwspk4d07bM6A
 WVbCN6ryFKm7ptFvQmPGjKreuXJ7XAk+uco+SQYxGIFjYEse5ZYrTAdYmPQIw5DmUwXV5Ef7k
 FPdRi8tNW3H+nCDlpb/UWKtIoMVNvTfbmZ1HlvwfdchmkGtEw9Tqd4d2nmkGWQvRYxh/kplYT
 KBYFIvJdno2CW2Q9jIA/FTxHo1eSqM6Fg4KZFTyzDGBf5o+qsxdAn7GrFGH/LTfakPIE+nQFJ
 V+aZvKfwbOU4jb8/0mCeLpJK40mxm1PmrSjQlEFcw5Gpc5beR1JN7g2bkrJtuQu4AEQpaS+H7
 6dgyschqeJ8AR5v+x/EZM4l5gmXGkA5GLmiAS6jQcLGx0T6RaumYxVAFk4C49q8IQF1kAfa7X
 pNtWlxGCM/7Ujwch/kVrscgiPVXuvCTJoSI8FnwfycSU1RVS6I9HeZ3XuBMX2+bll1pTd+st3
 4Z8Dkg2efdLSIsYBPPfzsHiAmGmoUnOiBJAso7N5nG5Mb2cijnJ2ZOYy2pAOBMEBv/F54rggp
 7rCt/Y0F1pLV/B5aI3M5rQLkd2D3ZObsq27Ojfj4GN0/dC4zoCB6HHcVtlLmMnwVw0u4H1gYR
 YeTu9GIBT7o1dHeQv3AyyEze3uePqM7Y0kpVgx8Xh/2/t14YfSIXMGFU2Q+du6D1Lf1HHqRjt
 hafCyk0GXmEU/wTPDoBxqQIUPwCvdj8nGtBbBtNgGqOPu4p8W6lFrE42BSrpG9p9obxYqe7rl
 5kJC1ssTqdsotKwJ9E/TyKuh3l1sSZPZgPUPzpeRCm5mgXSvElgUM//lfvBZNeBcTktBqYvfO
 GoPebo7AqO2/BuUkkMnxNqrdAAjmvmfdNH3MmpFgEFJu2C6WzkBJ1Qow6mpdlmyN3mMsz2zmy
 fNWGxv69/WOCzOj2ZwyM1tToVDpGtWkdrrZWuUIdUkhqcnCvZs/XQEl+nya0DjW+jE1OIniqO
 6BmJF0oriuRwcd09ujC1KgWVwHhM2QSLMDbFdLP0q78pjBcEEKjgEFBpKeTi3/81KZT0kp8rD
 HrFrN+Nfvku+CFnKRXmuBxzqyPR/vEPrEZ0unX90np5oheV+M+pDYimd5dDt81SlCA37+DI9Q
 81pdbVS4pTjBCT5mV+0Dc6lXObiKByiQT1HjmjbzHwr+g81FzgBe7h7Syuyy92JzAYGpuVYvv
 iKlUJbXDu5DZnkUiO091FzhXxB+dXi5PmYUWYUr8lwRH2+Jg54tAR26KU6GUMWzw7GTfZaXZI
 9Sr+IOHsxzhhBwWrF+QoD7W8YFpjBbRb96AYTDDMaEoP213xZYLRptJr8j30wz+epcf3IZ9a+
 wqSHOUlBwieyShMgxS4a/5zMX3c6IX+u9YaAHJFm4DHHF1CRE5ewtruHtja2CsiBcfST/XTB7
 xafLt0KKKQEDlCLLxmqqLV7Bu8mak5ZlM3L7L6Erjjc9W+NZo7rIZIjSQ4XgF2LPZ1z3gaP8d
 jLKk+tkUiXO7zdtpeZCsw3eENesMc54EjG4dqxmKatsy5kl4eexsFkRHzaVpgVr+THamWSfr7
 XMsyGsYo/2vcw6svnomAJpvAoWjvQTWlae1HQLtWGvuPc3pQEF+fRcj41oi7KvdXfGLyuicGX
 nws1EpYoJf9Bg0xMhpoRJv1ea2PQu9+hGXmT1rAyfUI7ofDljQ/ErnuSs7s6cX/JXPyAb5j6p
 mT6DH+DzQDXDv3npZQMqlpB5/rSYou7iLnR3ryxVbK8TR1Ei61qyhjpL/RS/IPv32yy3x0jn+
 aYqATN9sNjOFfvDN1vCznu8spm9xuyCgOidSvCijr9Q2EJzrwCIHvsQ+fSq5P+r65qAC4jBkJ
 StfZkVH+i+y7suXFt5Ny7TYPrfXt1NMTZ3iiqWKWAuoy82ofNSqwnqWA07fPnkT959xZq+wot
 zQFEgGll3nHWIjDcFyJBt+LWBS3p9wjnPYGwDi4tNUVKxPjKTCwr2HySW9/5u1pQrjQvt+UEQ
 0K8/azvXNtRrdwZGWqhVbPU4C6LeLHY3LuOCFLiQP+U3kGbfI5E5NfXyvow1ubPTNIm7AX4He
 woorJFUnyg4AHVYfqxm3DBtswz1wry3gDdG91g6/Xzbh9Oyv23ip5d8kvd572FHtmai+q7TRr
 UoBINdmUAl+WNF6EXRq2c/Jobydo1kP1AakDgxhGEYzz6s/pZ3v9yDLcLM5VCb9aHeIC+DnuD
 +4F4l1YLABEUrWXD6sUCFORprnLOdQcHWWOT+EHBHGEe6qk+UWNtZEDzmiV0rCVI6AAgWDRhd
 /sq9ExFahK0pLoj8Fo3Y6UBVLv9n/fem1jONC+rDYg6Mgd0IqNTB7x5AOwCgiqs4OHwEtx2wW
 p5znpSL88LB0bmiYbQIgS2z5KXEsSE5I9Nc7ON+LtEzbE2IpAn0ZG3eGYset5Y8cJs7VL5Afa
 7bFqxLkqNn4kZPLCZWi62ezcA7aV1mblNFp2PfNrpIHbSH86RDQyhzZGu6WBi24HrW5QnHgwI
 s7ppJ+pb1A6rLf/gHGwAXoqazSjClYxwKIQZuzpk/3KHUujCyo0p/EQ1f99hlaurRDMBU7oaZ
 7VyrS4Zb5WyX8sUCv23N9mILG74AQjAAfw+n/pJOWNZ2reigC8jrgPExo+UQBj/A+Sp/ixBp1
 wcIaiyhYSl9n0GACAZcWAT91/9eD5dDLzw3j25QxvEPaYLB1GO8QAhAggvRKtUmvRkFAqZFq0
 t/8Lhga9H7O0lNM50bmM6BK9qgSBjqe7iAKy+L9D3wd2CPyzZ2jxyx485fljKdiOPmHF8R0mw
 I8RnTj+HNg40Si/qd/oHgMB62xZx08nFk08pxMzAK0+ktTqWDFhRZeu89lHEDMODch7kfVHzF
 FT6NC7Yq78ls7u+smQIBGJPyhEoSA9xp6O3yYg/K+cjocUzDyaIilwfaLdreg2X9f/seO0i/e
 RIHzJYYfPMCrmEet6PSojmV44Nvpik/yYRyeyO6lowDQGHWMp4xJnKqkUCMxANK9xbbxmwQ8F
 dCmOuwxGqMNRfiS+DI/iBD1fE2figRu4wRztoSfy7v+vwsi3YD/rE4iy7WzfA9FDJqKFl9AWA
 b82hzxTaa90L67x2/NTS4vG39PNr98xAQaAf6LgAnTVtlWK3JP52L72hoWmnEDygBlbTm6HI4
 TlrpayRtZp6XK+VG6Es00PxljDW7iIXAKVo4W8dbpaV75x4RKwZYWp0qLGC37ajWl5sj+JZI1
 XTK6c+VE7uokdwTtA+9rRQxBAp00TEQxpkD4PISC6NDeSbX0xB6q8wUDEWszc6YK7k9HfRNju
 91aOcq8aAIAZb+LVhsGEiCck8w/XvSqE5jMdnSz5lyEbi2p5nyf0ahLNcF+FR0FIVDqkpubLH
 YcC8OFcD0O3stvS5v1TNPRXHTiyD2V1JSvo9F8fJoz5sTe685C0NiDD7E1TBZJhgGHl5czfLG
 M71gHshRsoC2sZhllGUB+jmc51H80DkXP4/oQqxP+Nq6BHi0Lg0TZ+DNuZhryrqOgNmwqwCZj
 UbXOS88xGZO66qUyFxNr6YhzUG+NVEZktGCKroayW3J1656Eq+qRl0xRjyjpSTkQ7U8K/kLwk
 L4WuU713DIsFKpGE7M/+JpwqxcP/oQMZ2xc0dwrY73LSS9TK98EHMWQ7ek1xZV3rr7UyVboFk
 oAn8/ZkpPkmWfpR0rBpQ7T2a4YlTwcwQcrG3h+y7UY7yfLB/VFWiS6cJP1IUt9WJ+I3skCDKK
 zzbFg2NCluzwJ3o27uDWZAFo/R+TIYPwLCettC7OebrfNzn7S7EasJqjANkT5dOPr62QxbUB8
 U7zZ7ppKs+gZ85StzrdRggqgitfiJH8JNs1iJ8czw8ojMrl4YXKlTryCdBLpyDqjcbMR1WUK9
 tQ20O4wlPZu9DMwnbTdaRCpYf5+GeH21tjsftUJwfCNizX+IR7nX1/0I9fU2l6PRVrpGisHjr
 vj2CR6zhzTmbsD30l/ekwaemfj1XJtLEwtucA35AGYDF2viAUtTiQw8BRxXmDwU9TDwtQCXNR
 93Mh0YF2ktgS2K6egJPgvFhLZxVkJRXPMhM6idc0MfGJ7eHyBggAhPE02lmPCfG6FWJif9s66
 Fl6/h3tPljYxI0Wcn/VrF6S6+ZYyd7bG5EqN9m9tAcJmgaMkD3AGaFsR+lI6FupVSeF3NGZef
 AGaj/SSIWDUQcyO4nP5pWVHX+g6M/gcyetafXkFpdTFY3K/vD5rdTxlAwIccM5glUYOI+cX9H
 w5mqwfLSf2UI5ELRh0wZnFcKvYTUtZE9r5TE3zzpYA06/5CBIqZ7kzNITn2+6WbVXxBvjcz/0
 anHIa0XvZySuMbRcbrhylgxjhueFH3GqUWlvviJ8W5cgfCZhcuSzYTbrMcEsLoTKnLclKs4+C
 JgxYUGxZxiHj9QXtZRobczid4zH1N9kgjLadeiCStiRU9LRPCcOuZSMaKkkBasklPI6xy3sZW
 w/iqoJ7az3QvuqhJLFh5dmS4eTuG2jt2lknRdHGItECqSAnoCDT5FyvkJAwn6OOV7Q3ydO07W
 fBIIN++aOStQRFFZ2YWTGWFSBD5PcqWgFv4VlqmLI8lgW70LzV6mxSisYL7KVbJsoUjNdb8Xx
 /73Rj7V9T4oAJ5P0ap5YI+RWkuB4fmYKymkOfnYc6XnhHZhKM3/I+jh02UwqEj4KAWgBFkFRm
 /+gb/cWMwFbY+6tmGmJyE3JVaEcLoDWXDqnUhJUa+tiscrTsr6MwIZ5ErA4rO4SQe/aXDTrmZ
 2Vl7hZ+2lxUEjvoxNOXGOqoeFaMtgAT2LdebyYwcRJ5iIQo+KTlEF22zqArt7sxzoXe9NbqGi
 QBu51MmHG7LQa76xNpZsGn6Bx71oH3ZDmjebPCyPV1NwsXWmVUJZGa1xVb+0hP+cqQSf/IwUE
 dmGEry5qVoYbLXARt7isrONSdKLBpJVkDwV56T0i5P6tQReqYpHXFrsn4DUic48e5idJMPMUk
 pzZSt/8Ew4kxtMnQ2pdjqpzr4BewKDPgyoofToCN/Hg2AM3VEHG5EsOovDziOPz3byaEB3ecp
 yxXOI0Vb36PTKqRq1t+NPkHfUh2Jbw1j2W+xyLfLhWTLwKDgG7GwGT0ccybG0WQ3Jg9Tu8ajN
 wHU2dDdDCLAdETl7NH2LLdvI/VvaCJXLpzIUnGECFwBz9xTeDZRcYsZ9CdW4nSSJ1v0Ilyqur
 xxEmwN5CVAnOkTjcjKZCHnIfmuSvG9XWm0w73WZ2jAc/KedT/B/ONaMKHx0d65K8jxhHtXyDB
 cfZVnMwZRPpIXpycLBfDQ3rE+aPx9E66tIAhH0oYTlSMQcKZeEJ1HYN3/ODiEs+uF8laIggt6
 iqYCZoxud3NgaMg4uwWTYqpIvyJxOP2KH5oOdjYLL9Cv7cAXrd7F4ar//twW3BHrpaqyoOJYs
 7Yj5k/sdrDF01rY2piSdzskJiaxJDwZlcB/fXnmtknzS76JH3v1taqsqkSm5WAWV56rQQjMEb
 WucTF5o9/aevqEvIqpNmVJE/8pVRKl9q+n8kuOxcivsdTsbfQxI/9y2ol5R4NzRFtSZLVHa6m
 uCZmHbFN6VUuG8u/xTCIPDAFg273qLSb5wPqFQV0wWTnEwj36FCk1MR64YKJUo+K2fvkZo8t7
 7E/VWXeuMiM8ofaxu6JkOELDwBEac8LI4+0pSc1A/Jhn1SvH48e+Dnh3WXvjWE/jCmHXMnMM9
 VPftRZubS1444l6/wO48xZs91uz3wYcDgqgozarz7OZpypV6t3Qttw/kAWWEF9uNRkmmAILa+
 MHH0c5EtKEET1t6XaZgFBE/d2vLg4MU/MfG/nQi0gN8RxLDTR9Nm7AF0QE8heYuQ0lL7DdzO7
 RFSgRAAdYkOLHABdZD16Fj91TIOxwtN3RSjD1LRogEovkYsfFOgP4n0nOjg2L1CD3jtNF4ZPb
 nLSJsXj7TKv/3d22rzX0yInV6O1bTVy/qmYNFLwsnGXU/v8Re/wz3s0TVK1aYOsqWoWE0oFHo
 TnOedCu3tjILB//9Wlqo3dsq7Z088AN9wcYRSgZPBAgzd7MAapqlo5wPK/uEAAmWkslcbavJu
 garKUQuzwQN0+44pOBtzYXyIpGxRPgxxlD53BYkGYvqVsi846oSER4KRgeEO3q2wNBYM+bvT2
 YDzVRc11wEKKDi5eumyfXHpyrzTz2zD8kzl5n5YAk5CnH+k8L6lUnsitn9zbz4e0WSGm7ajTW
 caKpEfUZ6wY=



=E5=9C=A8 2026/8/30 20:12, Melon Liu =E5=86=99=E9=81=93:
> On Sat, Aug 29, 2026 at 06:25:11PM +0930, Qu Wenruo wrote:
>>
>>
>> =E5=9C=A8 2026/8/29 17:09, Melon Liu =E5=86=99=E9=81=93:
>>> Commits b48c980b6a7e ("btrfs: fix deadlock between reflink and transac=
tion
>>> commit when using flushoncommit") and 532085d00eb5 ("btrfs: fix deadlo=
ck
>>> cloning inline extent when using flushoncommit") moved the destination
>>> i_size update before btrfs_start_transaction() to prevent
>>> extent_writepage() from invalidating a folio beyond EOF.  However, two
>>> deadlock windows remain.
>>>
>>> First, after the folio is dirtied but before i_size is updated,
>>> extent_writepage() can still see the folio beyond EOF.  It calls
>>> folio_invalidate(), and btrfs_invalidate_folio() waits for the destina=
tion
>>> extent range lock held by the clone task.
>>>
>>> Second, if extent_writepage() sees the folio within EOF, it proceeds t=
o
>>> writepage_delalloc(), which also waits for the destination extent rang=
e
>>> lock.
>>
>> What about letting the agent to create a reproducer, trigger it and pas=
te
>> the lockdep/hang calltrace?
>>
>> Also an ASCII chart showing the window between involved threads?
>>
[...]
>>> Fixes: 05a5a7621ce6 ("Btrfs: implement full reflink support for inline=
 extents")
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Melon Liu <melon1335@163.com>
>>
>> And AI disclosure.
>>
> Thanks for the review. I'll address your comments and send a v2.

And also check the sashiko review:

https://sashiko.dev/#/patchset/a74ov5nvs5u4nkqhrs5lp2jaj664wewkqqsjxzhuemz=
azzmzvx%40eeof6sjb3xdc

