Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ABB532B108
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Sep 2026 21:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790027348; cv=none; b=BLSovf4V/b+kb68MTULRBNThgGmL+maY3Q1y/nN1rDBqXrD5udTlkNVPfA2V82g/FX9zQho5h0VSg5tNJ79BFGDowMcxZoJc7wyZhYx8HPGJG/R7knTTiUzWfy6hwTfKHj9gjJVUzejIdFZSzrwDJ2XNbkBxISHZVwJ6s40aJTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790027348; c=relaxed/simple;
	bh=WeDb8mOVI6z7Nz/S8RXAIL1gmDhEUA7sJ7BTBOQPJ7Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BbXLydxUZn3g4hqnMYlUw0WtrjdCrWFv15HZnbng3l0xEot7hXcZSDUSUItEh7O6XMUQlAvmcIhv3Ak+4R0drMi6CnBtrIOaPtSF48WrarOV4syLeqoK3+QEq0yyHT7pT2tIX50PqUPuPAeE+Bif0/U+UZFrfeQgy/05RApkO5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=R3RlIn2d; arc=none smtp.client-ip=212.227.15.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="R3RlIn2d"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1790027344; x=1790632144; i=quwenruo.btrfs@gmx.com;
	bh=+sjl9EyszGF94FHgFVRvedsVbNukuhgp40iZzbZBi+0=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=R3RlIn2dKJrlW7dFeoTA46zM9iIuPl/FcnXfZO3qZ7TX8N+Ln9kfuIn+S1p5FXLt
	 UDYKk9kWndTITdiRvrpDN7kcNXjD2UolL+CrJDTS25dSVV88bbaTOuCxdiA0ardzy
	 75RoRlDmPaS4Y4p8RuYlBUj4jt9sjwybqajilWMuiwpBy37JbnTFIwHUawjhMxn4d
	 PWX6BrUjxc5tWDEyLRQEhyOvPP8jEHVddnfUD14Xy8/K2htQBclMnuXeDz6iuQGsv
	 foV6BfeyXel+uxSUx6/xGJOVzceQqeLylxwMt5WQHukfJnuVs2pkyiVxoJ8lOTnt5
	 +VTJo4v8p1GXg8l7bA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MWzk3-1xF9nT2MTh-00YDB2; Mon, 21
 Sep 2026 23:49:04 +0200
Message-ID: <3259c715-8fd1-4644-abaf-6d983295d559@gmx.com>
Date: Tue, 22 Sep 2026 07:18:59 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: make qgroup rescan work to handle fs freezing
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, Richard Weinberger <richard@nod.at>
References: <cover.1789981860.git.wqu@suse.com>
 <cfc34be50699e2e0e5c84e4d57345c7e0506caf8.1789974081.git.wqu@suse.com>
 <20260921131844.GF54722@twin.jikos.cz>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCaqsNDQUJFJfy
 XgAKCRDCPZHzoSX+qPcICACxEFp2nh6g7JQyRkN855kqXeAYiWGZRWbCo+QQcGU0vjlm6s5K
 4CRT8U6RtY0Ou1Ss/MYrpf3z0joYh0hoWDgiVqhUXLG5jM2FeBY6bHl8WHKsMOiVpcB6yJqu
 Umqira0lLmg0V+9zHkijuH9cqxIYURsDNNkUueMy3ZBBxLq14w5JFcqOU7tdHxa2NZoO/pck
 qEZSL9lrsmRFe2dzFnxw4nOhikr9tkAqQN2wpW2OG8D1oLNARDx3hnhMYj9pKZ0ICZDtl6J3
 ACi9ZIWLNGqwb8ayizmyKmCGouN0gLAuwGFq2qRpXGCxe2lTYknUk71CvBcCzFgCX8qlobxF
 NCYXzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
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
In-Reply-To: <20260921131844.GF54722@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:0RODuD02cTTUmUszPe8plv+i7QI9e380N3ijwJmkvHoe/AsRrfu
 4yV43/pyokW0lqMQ6Wnfd6cLMuCEVU/xHesYA4aQp2sXsCQnbijQju82ZX65ZQ/Fp48YKst
 n3UWNP46EBfqXfXqzEi6Lvgq3BIaIBMcdg946aAIPhw+tkzck3ENOFZJEP4ET757luA0ZPW
 ISpF/Klo1jJ405gGa+IBw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:VXOkmt+IW28=;CxqP7QBtqH8Y/8/X4xQL0+MlOS2
 Zz6h8NjsT3502EfibcVNMilWjifaSeO8xKh1Yn+Zckj6TW0Y271jqiDO07bnoy31ZbMNq63Js
 uafdGMfA9CWV7wIDBRg9j8TXAiUrbieDDgX/21bl96a/9s+vuGP3hJeh9Kh9khOywRXzIGVH3
 +nxFEa91FzykdGXmr612BL4aCmvnyIfsqLlfF6YkKZtb0r4hBNXDu2sJEQjEes+rAdzo37Xj4
 CVnCnKxCADtVH+YgQMJpi/p/UVcei4hbLrd7HqjLRThR0hBKPcuNvnRDRZeS7F7NrHTmlXwpa
 w+qZOmJoVfGVx28bmTyh03Zg6z0q62r3EPY+TOImtFUcGpzxmBkQBwl2Af3UnIEu/jqy6AgdD
 dECGg5oNKgrakhm2WXTllMiLWYhria87y5ufJU8h3pqCEv5twQ73DYdMWCa1JX1ziWHyvbKnT
 WGMleM+4bKMg7ugLtpGDfbg4PqElySo9YS/UW9PkIC7f5AhpYSKMgN3vbO9JezC5VsZkx0NDz
 2UiOkPyS8LgYb0foLWyfL++hPsGbyoNIgiqnK99Zwt40d62VigBMYXlCbkYKKxljd5+kPpipf
 e3DOfOEm0fjIyzSQ3KH1MgiLycmO4NwqflA441KsvUdhKHQH+dqKHuyM2bk14BcUtru7P8dQG
 y197IPK+6VRDfZmA7ZKbITF2IJ+v6Sy9dezHNpE+mzHOiGukX2J8yeLivQlORSeYEaxx6des7
 cN5JLA+DWgMxu15yzQJkkahxJoRlIEFXOJ4zHxrraGL9xjubhGFDInuXjK7SmEPuPN6/TkoWS
 cT3SV1/7EhUZskXgVzebRwM8pDvJK5dHIZXNHPiakVFFOkTKcDmglTlN8YNpS1Xqk+30uQ3c0
 aMtHhT/PSh2oy9nflZVrpDBWz7f+8EveI0hNjjO4jXnUgM1Rg38JJ6mbaRrX2ndmeQeJ6QIfN
 /ygOAiQqOnOGRyveJ+MGCL6KpzBc6iVv4yweh5pjz0Okrqrf/WwK1GhN1oK7E2ctrjHuS7+4x
 u2TMG9yfptfKC2gJQ5xqZ8gOoIDsjM1hUYhvqYHGzPesTQWa403RXhKLBmbGQC6TJjSiJ/m3H
 0f1OpWgdDfmd/pWKBrbiY1wxbIAEDbsQxjD3HPjXX9JHiRUvPQ8wtgTaJILIGNvIMOWgM/0Ap
 fQCnMmsZ4BmtH5gWrR08sqg6OR/AM+LG5i4FwcS0rMPcbsqM2Zc+TIZ4QwBtdEMb+eYUWHxfO
 BQEzT6Zbnqo8nqnNzY0PKfWEk9R3C5WlTHd2Wm3uzTLmO0gDVHDfokL0brAG9kV5qUqiTjIkE
 XqLJpQW+ToXtHit5Y7R29+4aC/iqklWsPC5CEFVQsv5UXHtJjnrwmHQduDz8nRLJyxB9oVUsp
 YFC4wLrmOipKO+/LcubDwNTNyzexdWRA26g0yQ4Yt+q9ZS7L+d1v/KmG0CTJNMrF1V3eNVe+0
 jHMo9WmIcQyMeoGHSFzNwqUQrABsGLqB9Nez8lSCSenvLH9+TbsYrZ3OzjbTeKc6Bih6R+M70
 FaIRVjv9WO5SshnLfe1rtY0OgKBlgxJtXbMGKsoOUPY+I20GuKcQp6p5QRiVcixS40UoWhBoI
 GM53NhyjjBQ/4Enj/uPMgMyrN+JR2cRXEReDBRzHIW+Udl8WlOKXarjjcP1BblQhvdW9rUiGQ
 hW3U9J3W/fPKXQX62c9nm4JUM9LdRpCnoZ4g697udi0NhwJchaaq/0T6OIekDLj/299Y11gz1
 LnZ3/YmVmHOejKwBpgqfiJGWnUMxpVAujfpuO1fLLSmtGbNmct+BAFgPZayH1vi866u8FM828
 wsgLffH0YokTAAkzdvCq0aR/wWYSBY6yJdEIgxpLnwZuRtOdw/eMMK3IO5JaEFQ/nKRGhS/C7
 UiHJQ9eA3mNxVFK/b08omiyLasuh+SNE+NMVbkJxGtA2bz927DOs2l5fcQ5BUENca3okAjSsH
 vszue6GR3Y1aOPXXnvM8uAJi+rdyF+FtRIv0sVLhUSDu8wH9lMAufUvw5q7NhX+/a37mue1pz
 ByqVfcd4siY1oLqMt1lYyqPAeGHTHJtqgpseqWIbQisw492U1DWar6Y594o1RVYvSSgkBOOpN
 3tLJGIZaKEkGA7Qy2S1cU2JerSf4pORNprhE820kU63emLoay3ljKa1pLdAhKSprEcEgkBcRB
 IOuMpJt8fWvAYV8oQbqcJmI2Mp1T7qmElBY387rSq8u0DG3c03jUFxOvDlt/1ECT20xR8LVDa
 J8JvY7sskhB3T6vlB/CzH0JJPW8qgqLnOTS2IAfKOzbJn6zh3dPUNOyB7zPkybOLKwfMsHQ3h
 air/ZE/CIjvKvUpu3Yg77TIbIXIybDnsF8xCOVYUH+cLXOMxrAX1ezbVHSeF0lOa1iWTUt53m
 Kd9P8GIK66FpRe/euUf3vxB5sGN4HOFVITB4DkwYcSoISOI7vUxq1ZHD9+2kBYNFaGLtYF6af
 uJhDy2qydE9k3NFk8SDuOoliCbadjsdo5yCor9pTMjwOKg2yYVMISUePWIgaaqkE9Wc/pOYEg
 N3PuKAM2jaK6BJFdKFhgAlZMjjVYgvK0b95sxzu5swIqPI70ZKH6uYPqBBpIBCPpmzLCb1B/W
 SvQqllFWHjrefg7Dsk1feTx40CO33YZKYc6kUEQbVnfeMCv8DuJABmTYZZVkQnr3SXqQHE5ED
 x3Eus5EXfYGUL7mld2cSzuGJ0oOhYORziK8bP785P7M3nKguFMP1Xez469nTvRPQD9rknWXu2
 cITu3J+KSciJyvexmS28j0QS4t6Ad09qurzKbpHA0D3JfihlmbwqZH6oWL7vIY69+0cSsmxQv
 oxlZrDEifVcacuCICXU2bBcnIdMjqbdiOiTaCKMURDozRB4fi267BBYlvM9Wvl6wtskDqiXqU
 fo72jmrwPXmk+7kRqhVqiVo2EzB+zhWX8i0cG3Cs7jgGoCiqvStgR9FNPxRolU+dxq1clSNE7
 wL9mBvjZf81zt4wrGHtng6CA5org+1yUYWqkWu8+KBr84I5nfVLc0GjtndD/OfFg2XVVVjcUj
 ucaKeju6d1ik/aKtJ4Kb2JBte+PWBW8SyAAzzINdmYNTGP+htvTh/p3L+dua1MeT6izRKJ6x2
 cKVDgsj/C75LNibqEKUIX8g8QhEEZtE7OuqyIXNxcYqJ9owd1G6ftJM+O3gr4U4t2E2oOFo5u
 IfPLt950L2136p52eNM18Kd9norKvCplVON9ICZER8fgcx0BJVdOM6skHouWzw25qrvjKPsZL
 Hr0UaxIlpq65eGNPLxPL7trs+dEyijkCp0PacXAXF7UPl4CO4aSDDdHndYmWOvMXHOiGdak0P
 yJO7IPDFAv9n4zCOL92/swh5C2TiNhZucVj7XRlheIAA1YJbEXQ8McUt3CJNSQWlNcVU9dmlC
 ILbLcjVQXidm9QfSUdlBKjwvdsGa8dOCsCLmm6w6GX3moSATlTSDPG97YgaMKinOBXgo7oHYK
 wuNtf41sqqosSvPS3aIFE+8Kq/E+4cJSaQLz2gdnCp1yeB9aceRje78bU610VGAbljTPBnkSX
 PG00fd2ZSFdY2bzXcbNEl+M7THoqXA+73k+1NalkxwsXxsIDcBB5EjNrNurEV7aRriUtGX7Al
 OC6qYdofrQ3C7WPyiTGCxkQyja0gXfxKIeuzJELEctz3CX6q2GbWIxvoCI7t2G/0rAoGQP8lE
 Nved4BlBQDskxmUEdSr66wwF8P8PYGFkEFpwz1a8rZWGDpfu+zNnlgu4c2SecMSZe4FMq6QiM
 xI24WZnVsDkLYDSau23zQyfMb6LWRcCBVQP+SsXWd7sBWX6ZiK9rL3XaRGnsD5zypF3iWjM3V
 iXvQbhCPwQW05oGWTDy+QdRZZoSJLizvfZrqtjIcUUBVdwEOjoG/MFLC/NPEnRDo33hB9s41P
 DBbKD8RoWcUufKXUHtBOM3CewZ1QMi47xncjk1Gofop2EJatq/palgRpD0FZm8reOKTw7x1vK
 gHTjaJ2zWpl40kARcmJXjtdO7xtxWl0ta8NdoUJK6f3EzhDrLa7rPqsITZfRq6lxQCb8h1ns2
 jjZCKSaXgD1HK45WSOhL+woLTwrPVHlCnKFkhsIFx/Kh+ycK/Nc8opEWYPJ0JfFdOeUzhesdR
 VFWGL8mi7BXgd9flnmEwCAZDFWNToj0RwTXF2HiNfKFK5SJ45RSMLS/Bziv/Bia7HZWihe+hv
 m5H/JisO9GbF0KIhVsH6sOniIdfRjpctdPOfYgr76dnRxbB6982zKrZDWjL687uvg7exjG4RN
 81Q8sTKtNUx3wqOpRlQmsNuzxq8315JhzY2gq718+iPuMvoGyX6Ns5JufcCQtPAEo6DVp64kh
 V0nCt4cPrn8I6uC30CblfvhMFcFEV5KXSTJ2tS2tDmSnxTMK+mptwQrInbIpUvWdrKRnJVK17
 ClYLlXU908Nwjs0TCfSVX60+oSJjYcm8SM8LNIqNM4OTDp3PhusphlS+WE9rkaVegEdcqqYBF
 La5CtoZ+4fV+YvGdPsP1iOrKrH+E9YgSonkV9/FNZZYeNSf7b1vyLRc4kTOKMO9KSh8j62rHS
 PlYz4rfWSniwCZbSNh3Xu73sdHYFeSMvYObwAm6HijBeYgjXuxBQKJLIWSdmkNM+/HJ6aksNl
 ko7vpU8bC6fHHS3CbIMM1FqBqrjFqH8GZfiRzyNSmOvwBf/It/qVIIcTBrRP5iUz/4nqQSAGz
 EN57ksK4bRtawghH075oXl+wiGwu9wQuEScqkZg8F6S8eEYS0mvGKhj4Ws2ketQKtBc4/t5Q7
 dUcYTv9JujtnpXV0KmnA/SeZYawHh/f4csAH/jEKmz35ijwMhw+tNR2x/JZ4no27BI2SR+dKv
 RrCXlQsInEDeJySFvR2M+dPuxNBCpi4HrQ16ZiCz2cgR9kIGm+ke9a5L/zHcjHAMHbTFQ8vuR
 7jGiTbBTCMbqi+U7GFd/8g3tY7cdUVYgaNd850nm+VDLSTW7n8RChmM4ft8ZMlRp1QKb9Piuv
 SeMnOkQ/iNN0APxjrGljJjBWSjQDxvI+yOkgv/RzVpA0IzOUnAmFCrPEAaEJstcwUowkBtVgN
 KjPuzi4Lsco7YLzYIydvbDmV+QBRlr3vm2kwVcVAUdAKuDVKLJwXiOZGWkYamH/J+iSgkmqYZ
 HY5HTP+6dik+Gh+rgHFGIeuJmRPmtqWnQbY4QjzfLhJBWn/exUV8I7R8UFePve4aLwVpD4W9N
 IFS0pZjXLT4iuPlY4yzrIvIWGmRx/WgIw86oFprbSiztOkjRrHWo7xrF8Q8/K8NfxKaDMx7C/
 xPEOOxtADOZxOeiHWHhmww0ON+UaN+B9CnyBZzy6ukF4STTcfVvPVMQ4jWkGSUANQknLjms/M
 yIysSdD2bbYLsTIqNMp2QG/ujn2B7ZjbMAstYVrldI/OP52aymD0j72dHCYpPa6qsUPc2s2Mm
 yLH/RveLwn6qzkloSg6IFsG6VgKPBhiZHnguprdB5cdE1uBXDOV5NxuJcN9rWpuFVE16twvWn
 jyb6UbN6LWc3E47eiQ4MJU2FSJQIGONfBrQBNGy1cOwCbcR2yJptNX3zzB/XhW/yNpZV8lJQW
 J3sZT07enOAmzDHErRO5FmeOr7lRcv38dh2JWGeP9XjcdPDYYHYRsnW/am3AKoDw+yymQkolT
 2gDERUMrnr9wYVm/+CSyKBlo3w/3l4UOoPMYuNxi5AtQyJdJG+vvW4pnGCKMZI8gM3nAtdYji
 IO1SamSjyt99qsXyhjPPuC11cHX++FvHslvJhR4Db9q5E6dl56Ndx40+zlwvRvoPxrcmmFsK5
 mra1UCUAI1f3tGHWFSGULKIoDQpmO0TxHKlGUBLATcA+MBQj7Y4mIuWUAB1G0DXzM4X6O45eC
 kO4ZeC8KQGLepCucDwCI+eBSKr/wIosGhbZTJ+vFou8yp1qpAbX+7xwTCl4o8KiPd8KdrYLz8
 uMDE5rgm9SmC0rnWN1ufP9MmF4qwJP+gvhffioaFBuqoZjT3Ks+n5cR0pJl8+RpTsZY22BD1h
 rohXPOQbY+Kzkp93ui+UvTC/SZz0exAhW2MltnUP6yuB7KM8cDukJg+okG0bqdX4AE2Oy02Gk
 muSfzDtsZ5xj6XwnqIKX5WDS0RdpIk0i9dHjs6WfoKhM3ChvMEleLk8Ccv8tjrQSvEiTiGJCo
 v6WX8uy98OBYmBa64KCWdd0+qKgBC5Cvsm3uIPAS



=E5=9C=A8 2026/9/21 22:48, David Sterba =E5=86=99=E9=81=93:
> On Mon, Sep 21, 2026 at 06:46:45PM +0930, Qu Wenruo wrote:
>> --- a/fs/btrfs/transaction.c
>> +++ b/fs/btrfs/transaction.c
>> @@ -559,7 +559,7 @@ static bool may_wait_transaction(struct btrfs_fs_in=
fo *fs_info, int type)
>>   	if (test_bit(BTRFS_FS_LOG_RECOVERING, &fs_info->flags))
>>   		return false;
>>  =20
>> -	if (type =3D=3D TRANS_START)
>> +	if ((type & TRANS_START) =3D=3D TRANS_START)
>=20
> This does not seem right, the type should be a single number, not a
> bitmask

But TRANS_START is already defined as a bitmask.

>=20
>>   #define TRANS_START		(__TRANS_START | __TRANS_FREEZABLE)
>> +#define TRANS_TRY_START		(__TRANS_START | __TRANS_FREEZABLE | __TRANS_=
TRYLOCK)
>=20
> If you meant to distinguish normal start and 'try' start then it's check
> for two values.

So what your recommended change?
