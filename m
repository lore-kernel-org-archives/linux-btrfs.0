Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DBDE395ADA;
	Tue, 12 May 2026 10:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778582477; cv=none; b=Heto9+utABT1Xzn4PqwpnUu99RYexlslwaRxp0V3/Zh20KTExi89vncb7MvL6MLWSxm/UU/pZ+twedkqCTl9Aph08u4lbQgKPpWimzmRzEZw4ZVisDSzsGD1wcu3VVzK5xIIny+kqWsg4tDHB8itsL508+pvntdMrcezxc8XGIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778582477; c=relaxed/simple;
	bh=GXXZBH/W4LtlVrKlCjWa1EUb/oBvQEeu7MKfEN8uFo0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Xu29OPR5HBKjhjBRgy6HJEIPcQPzgeB/DJ6CEPvjpaeDA9h/d3tt2zP3UoucN8pQR2jGgIhzlh+tPjJlYIbT35CIsbepVx9IkbXDrvKsdsBg3mnULrshosOkm+1bVhHeeWyVaPlggvspLK1Oc57PsTg/M3P3dOk7BL7mBcGqJgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=H4snEsqF; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="H4snEsqF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1778582469; x=1779187269; i=quwenruo.btrfs@gmx.com;
	bh=wjrPYNjyoRU6/3s6ti+x93J/SO+Re+qMb0RYc2hNkcs=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=H4snEsqFGmF0tYevxnmXHoG5cVEoelAzE4HJYqB9eT2FgwXv9X5yiC8phmbQLIzF
	 DyeKMxhbpAc/92l3jqtJ1ZutIz//DuNwl0LaxZ/zMb4qqHHIizrZwq28iLX1dCPxx
	 eBOtyZXg7wgfW90nSsPgKvl25ZlXpFvTILw20cyXYISCBPc04j9AkS28pz1St/nHK
	 JBkJCqlajmd5G8oYQsI1KviihMNx/CaQ/oqKvxLo+ESRclAREUycdERulXNzH/EDK
	 psUoA4JeLHBUEtZ3N0aaK7JeNAaTbkvkJXwam4bFn8O9Z6PQ256e276AvLTu/MCfI
	 mn69DBPHfSgm8CwxGw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MVNB1-1wnWkA1NGp-00HbxT; Tue, 12
 May 2026 12:41:09 +0200
Message-ID: <78e451d1-cc71-4e30-9ee8-903439f584cd@gmx.com>
Date: Tue, 12 May 2026 20:10:58 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: lock balance status ioctls against shutdown
To: ZhengYuan Huang <gality369@gmail.com>, dsterba@suse.com, clm@fb.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com
References: <20260512065342.537219-1-gality369@gmail.com>
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
In-Reply-To: <20260512065342.537219-1-gality369@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:B+nyTe+Qeuhw2e0eh736y1MhEwZOX2/G/28fYsLVDPijpbh/DVP
 tOPEw9mxsxrcNNvbYqvqFhQ8izr5g8Z9pKvDByWWNAfYTIA4CIljtlLKOGbEm61p9+0WC/k
 yGeoVQ1ExC2vmQadlOWBPpRrA7UZf9sN9ZxNaSypw/ieTV7j7iQ9b+9Mm+mL/9KkSWRwGQa
 gOoSEAX9+nRAmpKqiKYDA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:+yn5ic+/iJ8=;wMqvErBAw+28XQuaDPXnfjQ1u9T
 /pGdwdxOHbOhhXr7nRDiwHC/pka4B14jjgExeLh1JjRqN6NvqDdEkUsTU3z6pZWdi+tdpYUjb
 VshaowULGefkE49eO3rE7y+krBSLAkPeSiYxNtWfE23igZJIhvWp+eAIOfWvwbguLhJRwbeT6
 igjxxhQDX3znxWfgooPs9MVq1UR1Xdn3QM25Hy3AhYIjACGjVbYz90gycZecGvOizeLX/AvGU
 VShVTU65+CXp+wN8tlnPfr3WmMRsOKU+8WkYZR6WBq/NySdO8VQhmNfqogXW+rSqtDS9chV9x
 Q5O0Y3oFbZQeV6Otuz4TIj6jk19qYWT+iaNR2COjUKuVjIR2vsnUU/NfSVcAUbPQJwfsdDN5s
 zbZeaJNJ87YI/L9IKoKIfGhtr86faYKGahMIX27qSylKVBebQJjbiEHuueYdRqU8dfb+/TNSE
 p5WkpZ708Ib/vEB40lRAECo3CXKdW5YDa+Tcen9hSZLmoJqqUpkUfFjupu5mvTCP8JvtuHwfL
 NSuZO6hIrXdYCYiZ94NK5NR4vg7XzkxiTJRDr3BjC7jU6icfS/KE1+VK8pJF9NOt/KOKs52n8
 azNGhPm0JkDZshs8j+Lub0yUyLM/OlMKyO2zsrcY3+Z3teFfVtg3TSfhFkxSGBbHUpoXHGbQ4
 8hRjyGKH8p8LxKb8DHWKXn7xYNLn99It1jXiO/A8zMmeXIjwxRAHurdepFvsaTMc0T59puZmG
 DVlpE0vKd2Lq9S7VrDeAmKLUbEs82PUPq9lkO6Dvfv1Y9PomC392J3/u5vb/lFQfl+3o1y9If
 3SQcyPXoUdDo7h3q+F5+o3H9Yja15vQlj5rbuK0Rj5+LbP8GQj7/BGSvKKj8q7+I2RLA7041V
 lbd5hqV/7b8WdE7p5YkbLUx6FxdWtU0OqrAFUtJAqxc60qpseVdig/bXJ0w0Rba632Tj5Lta4
 JBTlEAw5ClwUFexpMTS6+hlrOldaIlqy/AJsl93P/kwB814/dM4csJmGiOUFgvANrjeqAcFLy
 WjAP/38OQvRWj7/ETugz1fFPqWPwky8XUK3MGoivEzCrRtH3Q716U+UGX7ri3hZZVQHxsWqgm
 oxwpslXW1Dgpbjb9XXw3xx70arxUqvoSL1U0XefMYAurVS8sewwpgV4nHxZfbJhULfvXFTH0m
 FNadZwph9bdD/LGoBw47MNmM11fhD6xXnar0AF5ZBE8zBtiRCm5iPCvjN6J64xa5eAAJWjtvx
 PgtZgCilRvKVWDuOpZb5plecFT9A9wbSvVP3K0THsHDkPoHkHGg1LcR7tXZnH2uT2lcknyhcj
 Vvva7yqG7ZtaUF3cyKBV8r2JARgFDP0z+ePe1smYZPlG111u+fNKR7l/jhM7/1iSVpNL689pl
 Y7gCZCC8S7GHNlr3K0pqYjFHQ62y0rqwvOTJt7nww6DLIvhSwo8McQuH7nqcKIlHXnzJ+tcHU
 LL0RGv9GzfyhdswBVxXIxuC6/e0BDRWI+IPrS2Eb1e1AE3vTBru4rhjO5Ukb4WUCRTcjLKtMK
 UjWdoMhUzkiFOaqkqWEpy98+bUzhxmFijmmFyO+XwQ8CBG/ODrOA4Xy+7iIi6KVpxdjFVRe4h
 oOjvxo4q8sekfAdo9SqWwGV+X1uhLxriTTyfVQ/+kgiFpnonYLysqPAKOFLhJW26t5W+xa3hC
 eJmnHnTC7DnLpacm70dWaG2qq6LDIUh3XhjzD3kDatLk1ScpZdls5IDjq46KPq2a2dd08kQcs
 5MIQCmGz3nx7oYCO5beRamu5+mOiQGJl4HmIPn8uAELpRh3OO+Ia3zEsMDosvMWIlwo6kW6Oa
 uDjjnUqKqlps4ualzxp0/ZxUbXOk0mWrozER9NQAcUeSpUL3fs6yDEY60MCpDngdFaMILY/5B
 /WG4hdvrDPXQm+4XisM/ak8ufaiQbscJuI/vmHl7YQCLJcQHkuM+AgTuasjkTv6ea85KV0TWk
 +Q9rSiXCbhEJEWLc/vgckihuRXdl+fgAGStKKPw0lNmspvN6Tlm8lfKQW5H8k3xX06j4jFkkw
 4UHuuiDg6bhG744Dg/LpX+hloYeJjwiIWjbh1MlVP5r1jSetPvz4z6GEay3eH+xAehZidLp5q
 97PyFP61Os7gVRNtyEThlCMc+xPovu0oAwR9zW+Bfy8CvuwyKbhwVx5uAXKTCLVbwvqIYrx5x
 VM/aZ3OmbLZEaRxed8oeUkR//ZNdKy4rRQZ/8V0CJdgmxZU1NpiHpDhvw5ZsD0WcTh4OjquNA
 Dd8SnsW42wYq7tVpyIJNIwckCjsobSKyOYq+KYU4oQ6uPG5RFGmIMrN1AL2F3kRJcT32hg3ex
 q4A+Mf1mnjd/bW/6FxpTC+Y5pfCriD4cHP4ppsHNJRcrx3UKehx8zYi1uIy8PCD9AWzR07IbR
 6Dh9Hv0x9eTJ/0nMVwTsV85a630wVAb0/lC8w9kj+Fbco4Ybj7KU1TCdzpNjIZbRlpXpVfkTZ
 V03s52AR3yXPJKuXhTE2PI8ClXBcZsq4ndO8OlHV3TqnlgzUwIyEvWDGbiMJU7KvKU2KU+6nI
 1P4JFmKTHc8UTlZZXkYB2b6EzrsJ4o19qLIt4r2sIbhgwas/WZXHDI8rSlLSIBxWbJ0Duy159
 LFOLdbCPMmZd5HE10rUTLtPXxu5HNwS47AfDSxbVvzew1o9QJSqrtcVHH895tyE5LDGfBaHWC
 8N1CD/K4rIR8gHk+TZHfE0EEg2wVtcPx2QoYMTAfvH5QO9u0v67Tn5rjuOFbOHkfBp1dCY50l
 dvjvNQnHq3frR05qb1nKGh5/DC4UdZZZIckWB053rn+VICyUpSdCD3KfubW+w4HJIKyCBTsXw
 gIxd9esHbf6LPwu0Wv5S8FC7WCNfTqa0ug2mb+IWPvpL3r1X9OqQldVZcRfnYvWyaaejPiFZ/
 rKv8/pcj8/xa7YUHACNpTAyhITR4ny5IvBfhgluweInkpjDjK+xN3ytJx9jRbtPch9v3mE7J6
 7SPMBwjaLL8q1o2+nZgR9w0v12x9S0PBqHahwpkyVPODPl2ewGtjsI6YMCLWOrIXWur8c62lB
 qV7YZNeQIys3n2sqEc7itRZmcgG1sPu5SnhXzqs+p+JPzCg8K/ZjF1bDPbZxenw2gV4E+qOFK
 gvtz8b/lhhoOZwbdh66pB0rDBtUo7s63C06h2+M2y+0i49w2F8Y6l2b4pkET0iLmCiY8MvLCB
 Wqp8RUm4OUsLQoUWgrZRBTjfi2Ax5IjAO+8yWkgM2vgbonlWADAtzYS4qqP16g7jkWX8kTncw
 KLALtw6YH2qsxXIm2Y7dIr133o9qARXAHOBpwyCj0+76BY41VYcy0C/iawSDD2COgQ6JkOINP
 IU1+4hT2qtAEzZ4VjeQ92Pynfeylkha7qd7SKwB9PMNgntieDP0YO8KoHWlBOrJcy+FhGQtf6
 0HGnlVkV+yeBQLh5LoMzGywhbYZq5tW+n5IeZq9sBTfCLnRaaDoeTEOAVz+nJ8hk+5JYgib0e
 iZD/tkh3uUNUZoG2pqikr96FzSVYzPvliCjzta4jWnh3CZQzW1fOFG1AKvw167+wX7GO2hTpr
 ommsa6UQ2dMyl8PeBK6mISAtpGCmqs6buFLDLrmui/+IuJHH8w9qoVBLwxxPPXaVkawCdR3CD
 qqLswTtv8HiCA+fAbJpfA79JYvpG7sTLCsJxTTtdrP0Sw6RnF9ZhQKuRMfeC3gbfVveIzVCC8
 +ZW9XBO21PFWHOi4gMrxO2yRWRu3ZUtGlIL5FLttuZqeD0Y9JUuNR2lS9ia0PSDyw+5WXorJ+
 mhDTcAHHMJsVxFzVIEj3XkdWEF3UfhJfEV4ZYHfOWd0Y1iD+bTXwPLEuA5rTCJdjsYAAZeQ67
 HY6cZhgXmqo1sGVLbthRAB6PjWFicHRcci0CJs2KwWKxS/R3lllZPMuNpbAbdW3vWltKCEn1w
 FmNRVrzcjlmCtLuXFxgNoTuzgumlGKM7s9ln44Z2XKD1e4ToLJD/eoOkeZsiEAgnXUVyUYfp9
 tshS7NgMxKIYoJ1twmDyKcnWVpFzHUb22SFmu77nlgrMh830m5+930jf9hyedQWqCmhj3Stdv
 kIjp2KSwF46jsXTbhJJZbFIFx5ZaDo06ZNfFM9kKQuNWu+DKU16FN2yBSWHWhPRT7qU63Jv23
 1zNA/PAczHgK8RH311YsWGUhfE4buS9zQxzQE931halX63E7xtRz7IKzhJzX2L8DzbBReDouT
 gETvAm+eW/NKErwFWtVCelSynCPG+p2OObLSqR3u/k/rPKwwhDY8MCkGniGU1/t0oM81bAUQP
 yAMhmvU4XEzViGjZ6ID3wYC8J6z6iAXpSR47vMYmb7LTJjxW6Y6VJXK/XH86Qlza6AMexYoiP
 276C5CkhFP/VtH+Uanp0gnMcU91gAD9DSJ0kTk9GAGGN5M4jw/wfHfs4d0bAS0nQQW9WpZXzI
 FRkm0YGyYfmQZM3gJ4Ms1R47TR9kQv2l9gGyIL4Nn3lnYPCWOUNVux+HneyvnR2OZmQjqE5+s
 UI9EggaB05QxNHe5LLJpbd5twwnzvwBCwMVQ7SMDu263JLgVo9pbkM9ESjsfsupNeKEZ9SNHY
 x4NBj+SdgT3HI8h91uw/dSO4AV0FYKcvv36XHJNa2F93VSVY0W1AYcZzKpe+sgW52X/tSzq17
 f3W8h8i5qyaLWUdPb7Q3FUtOpYJr7rJ09Ds6mQaXAVSsX0eiM9/AKkgltSWcAtetf6mO7d2hw
 V2qVXbH+hQPDys3Dp5QpThRlG/PwlbrHVGNgrgWKYmVYBoRantIt4GHislP1I/jFx5bqSjIbS
 IC12mGmszA5Q2zP0jslMub5DQot+9n2fB080B8egI10INE15VkGbdDuJNXL754XM6YGa9UrB1
 bm6h+oAW8MEoj8srlxcB6WPthzCHA+1zaPmEKdXgX/8Os0UxLu6ua2ycmDEqw/TAPu2C1aHkh
 ko+EvNpuE/i3xFXEo33IOCdMnHueJkcTaxQ98IxnbFrrPDHPX9ixV9b4LnwR+qEPOUrsN6wDB
 5W4hRVsRHcMSR4qpCAOCj+M4vHerK39ff5jF4vdcMYb5qGThjVjcJQPbhnXwsjDCNi5IAB6sZ
 0dCTXXMhqeU5Ezys1vBaZ5a9Gbi+N93xurX9HSxT9e89jqMqZD+5sj4vUl3kTGDQ2eWVGhfUG
 ayF+wt1Fh8gl1F+UIvHkN47/k+R0mK4Kx6eUTgDxbd186OJsSodE00u2awUPZR7PzluIhwT76
 UV6c9ntvgikHJeJhzxdf0YgJrnigEf7HLFq7B02XIqQLyP80HrLh7h/b+7GU6pinQyUd51ZVV
 9mTOG+MOAL0tZDWHE8+Uk4+vRI9EQBp0ceFOP+GWJTTC10o5SsvAwTA9xgPHDf6r9QUFjOqQ/
 GIV7uGXOjAXBflvtSbjKb+15vknD34DDnK/InUhcv9XwPLPhI+X6db9FC/hqdQSfIxIi0Mm6v
 FGobepIbUJ9BCiUqc1TBd0DESf9rzMswymj9a4WxqqLaXY+6GRx4L8v5MWIXm4LX59A/KrY5U
 PYZ6gynp/NRTCkCelb9egU73mVq/tyMYzFhY=

The word "shutdown" can be very confusing, as we also have shutdown=20
ioctl and super block operation callback.

If you do not mean the emergency shutdown ioctl, please change it to=20
"unmount" or something similar.

=E5=9C=A8 2026/5/12 16:23, ZhengYuan Huang =E5=86=99=E9=81=93:
> [BUG]
> A KASAN slab-use-after-free was reported while querying balance
> progress:
>=20
> BUG: KASAN: slab-use-after-free in owner_on_cpu include/linux/sched.h:22=
82 [inline]
> BUG: KASAN: slab-use-after-free in mutex_can_spin_on_owner+0x1cf/0x1f0 k=
ernel/locking/mutex.c:397
> Read of size 4 at addr ffff888012700034 by task syz.0.130/433
>=20
> Call Trace:
>   ...
>   owner_on_cpu include/linux/sched.h:2282 [inline]
>   mutex_can_spin_on_owner+0x1cf/0x1f0 kernel/locking/mutex.c:397
>   mutex_optimistic_spin kernel/locking/mutex.c:440 [inline]
>   __mutex_lock_common kernel/locking/mutex.c:602 [inline]
>   __mutex_lock+0x2e8/0x1d80 kernel/locking/mutex.c:760
>   mutex_lock_nested+0x1b/0x30 kernel/locking/mutex.c:812
>   btrfs_ioctl_balance_progress fs/btrfs/ioctl.c:3620 [inline]
>   btrfs_ioctl+0x3f20/0x5b90 fs/btrfs/ioctl.c:5317
>   vfs_ioctl fs/ioctl.c:51 [inline]
>   __do_sys_ioctl fs/ioctl.c:597 [inline]
>   __se_sys_ioctl fs/ioctl.c:583 [inline]
>   __x64_sys_ioctl+0x197/0x1e0 fs/ioctl.c:583
>   ...
>=20
> Allocated by task 291:
>   ...
>   slab_post_alloc_hook mm/slub.c:4978 [inline]
>   slab_alloc_node mm/slub.c:5288 [inline]
>   kmem_cache_alloc_node_noprof+0x1f9/0x7c0 mm/slub.c:5340
>   alloc_task_struct_node kernel/fork.c:184 [inline]
>   dup_task_struct kernel/fork.c:873 [inline]
>   copy_process+0x3d3/0x6e30 kernel/fork.c:2012
>   kernel_clone+0xe7/0x880 kernel/fork.c:2609
>   __do_sys_clone+0xf5/0x150 kernel/fork.c:2750
>   __se_sys_clone kernel/fork.c:2734 [inline]
>   __x64_sys_clone+0xc3/0x160 kernel/fork.c:2734
>   ...
>=20
> Freed by task 24:
>   ...
>   slab_free_hook mm/slub.c:2543 [inline]
>   slab_free mm/slub.c:6642 [inline]
>   kmem_cache_free+0x384/0x7a0 mm/slub.c:6752
>   free_task_struct kernel/fork.c:189 [inline]
>   free_task+0x106/0x160 kernel/fork.c:512
>   __put_task_struct+0x209/0x3b0 kernel/fork.c:748
>   __put_task_struct_rcu_cb+0x1e/0x30 kernel/fork.c:756
>   rcu_do_batch+0x397/0xe40 kernel/rcu/tree.c:2605
>   rcu_core+0x669/0xa10 kernel/rcu/tree.c:2861
>   rcu_core_si+0xe/0x20 kernel/rcu/tree.c:2878
>   handle_softirqs+0x1d6/0x840 kernel/softirq.c:622
>   run_ksoftirqd kernel/softirq.c:1063 [inline]
>   run_ksoftirqd+0x3e/0x80 kernel/softirq.c:1055
>   smpboot_thread_fn+0x3a7/0x950 kernel/smpboot.c:160
>   kthread+0x3f0/0x850 kernel/kthread.c:463
>   ret_from_fork+0x50f/0x610 arch/x86/kernel/process.c:158
>   ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>=20
> Last potentially related work creation:
>   ...
>   __call_rcu_common+0xcc/0x11b0 kernel/rcu/tree.c:3123
>   call_rcu+0x15/0x30 kernel/rcu/tree.c:3243
>   put_task_struct include/linux/sched/task.h:159 [inline]
>   put_task_struct include/linux/sched/task.h:128 [inline]
>   delayed_put_task_struct+0xbb/0x220 kernel/exit.c:231
>   rcu_do_batch+0x397/0xe40 kernel/rcu/tree.c:2605
>   rcu_core+0x669/0xa10 kernel/rcu/tree.c:2861
>   rcu_core_si+0xe/0x20 kernel/rcu/tree.c:2878
>   handle_softirqs+0x1d6/0x840 kernel/softirq.c:622
>   __do_softirq kernel/softirq.c:656 [inline]
>   invoke_softirq kernel/softirq.c:496 [inline]
>   __irq_exit_rcu+0x1b0/0x200 kernel/softirq.c:723
>   irq_exit_rcu+0xe/0x20 kernel/softirq.c:739
>   instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1052 [in=
line]
>   sysvec_apic_timer_interrupt+0x91/0xd0 arch/x86/kernel/apic/apic.c:1052
>   asm_sysvec_apic_timer_interrupt+0x1b/0x20 arch/x86/include/asm/idtentr=
y.h:569
>=20
> Second to last potentially related work creation:
>   ...
>   __call_rcu_common+0xcc/0x11b0 kernel/rcu/tree.c:3123
>   call_rcu+0x15/0x30 kernel/rcu/tree.c:3243
>   put_task_struct_rcu_user kernel/exit.c:237 [inline]
>   put_task_struct_rcu_user+0x61/0xd0 kernel/exit.c:234
>   release_task+0x108a/0x1ba0 kernel/exit.c:308
>   wait_task_zombie kernel/exit.c:1269 [inline]
>   wait_consider_task+0x1501/0x39e0 kernel/exit.c:1496
>   do_wait_thread kernel/exit.c:1559 [inline]
>   __do_wait+0x1fb/0x810 kernel/exit.c:1677
>   do_wait+0x1da/0x4b0 kernel/exit.c:1711
>   kernel_wait4+0x14e/0x270 kernel/exit.c:1870
>   __do_sys_wait4+0x14e/0x160 kernel/exit.c:1898
>   __se_sys_wait4 kernel/exit.c:1894 [inline]
>   __x64_sys_wait4+0x9b/0x110 kernel/exit.c:1894
>   x64_sys_call+0x16f0/0x26a0 arch/x86/include/generated/asm/syscalls_64.=
h:62
>   do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>   do_syscall_64+0x93/0xf80 arch/x86/entry/syscall_64.c:94
>   entry_SYSCALL_64_after_hwframe+0x76/0x7e
>=20
> The buggy address belongs to the object at ffff888012700000
>   which belongs to the cache task_struct of size 13320
> The buggy address is located 52 bytes inside of
>   freed 13320-byte region [ffff888012700000, ffff888012703408)
>=20
> [CAUSE]
> BTRFS_IOC_BALANCE_PROGRESS and BTRFS_IOC_BALANCE_CTL only take fs_info
> and then touch fs_info->balance_mutex and balance state directly. They
> do not pin the superblock against shutdown and they do not reject a
> dying superblock before taking balance_mutex.
>=20
> During unmount, btrfs_put_super() runs close_ctree(), which pauses
> balance and tears down filesystem state, and btrfs_kill_super() later
> frees fs_info. If a balance status/control ioctl races with that
> teardown, it can enter mutex locking on a stale balance_mutex. The
> optimistic mutex spin path only tolerates speculative owner reads while
> the mutex object itself remains valid, so a stale mutex can surface as
> the observed task_struct UAF in owner_on_cpu().
>=20
> [FIX]
> Take s_umount in read mode around BALANCE_CTL and BALANCE_PROGRESS, and
> bail out once the superblock is already dying. This gives the read-only
> balance status ioctls a shutdown barrier without changing their
> semantics to require a writable mount.

Why not just follow btrfs_ioctl_balance() to take mnt_want_write_file()?

Balance is always a read-write operation, there is no read-only balance.
Thus I think it's completely fine to call mnt_want_write_file() even for=
=20
btrfs_ioctl_balance_progress() and btrfs_ioctl_balance_ctl().

And this avoids unnecessary low-level access to s_umount.


>=20
> Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
> ---
>   1 file changed, 32 insertions(+), 3 deletions(-)
>=20
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index a39460bf68a7..a13fe50f2441 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -3469,19 +3469,43 @@ static long btrfs_ioctl_balance(struct file *fil=
e, void __user *arg)
>   	return ret;
>   }
>  =20
> +static int btrfs_ioctl_lock_live_super(struct btrfs_fs_info *fs_info)
> +{
> +	struct super_block *sb =3D fs_info->sb;
> +
> +	down_read(&sb->s_umount);
> +	if (!(sb->s_flags & SB_BORN) || (sb->s_flags & SB_DYING) || !sb->s_roo=
t) {
> +		up_read(&sb->s_umount);
> +		return -EIO;
> +	}
> +
> +	return 0;
> +}
> +
>   static long btrfs_ioctl_balance_ctl(struct btrfs_fs_info *fs_info, int=
 cmd)
>   {
> +	int ret;
> +
>   	if (!capable(CAP_SYS_ADMIN))
>   		return -EPERM;
>  =20
> +	ret =3D btrfs_ioctl_lock_live_super(fs_info);
> +	if (ret)
> +		return ret;
> +
>   	switch (cmd) {
>   	case BTRFS_BALANCE_CTL_PAUSE:
> -		return btrfs_pause_balance(fs_info);
> +		ret =3D btrfs_pause_balance(fs_info);
> +		break;
>   	case BTRFS_BALANCE_CTL_CANCEL:
> -		return btrfs_cancel_balance(fs_info);
> +		ret =3D btrfs_cancel_balance(fs_info);
> +		break;
> +	default:
> +		ret =3D -EINVAL;
>   	}
>  =20
> -	return -EINVAL;
> +	up_read(&fs_info->sb->s_umount);
> +	return ret;
>   }
>  =20
>   static long btrfs_ioctl_balance_progress(struct btrfs_fs_info *fs_info=
,
> @@ -3493,6 +3517,10 @@ static long btrfs_ioctl_balance_progress(struct b=
trfs_fs_info *fs_info,
>   	if (!capable(CAP_SYS_ADMIN))
>   		return -EPERM;
>  =20
> +	ret =3D btrfs_ioctl_lock_live_super(fs_info);
> +	if (ret)
> +		return ret;
> +
>   	mutex_lock(&fs_info->balance_mutex);
>   	if (!fs_info->balance_ctl) {
>   		ret =3D -ENOTCONN;
> @@ -3511,6 +3539,7 @@ static long btrfs_ioctl_balance_progress(struct bt=
rfs_fs_info *fs_info,
>   		ret =3D -EFAULT;
>   out:
>   	mutex_unlock(&fs_info->balance_mutex);
> +	up_read(&fs_info->sb->s_umount);
>   	return ret;
>   }
>  =20

