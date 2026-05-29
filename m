Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 025CF367B93;
	Fri, 29 May 2026 04:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780029450; cv=none; b=UlNE7nAONea9tFOVu6WFVtkzKaW8qJHViefZH7IR/4+EqPJ4QdDByDK8sxVbsYBx3j3eAdbfqG+m8YhVfI8K1QKyKr0hf023iQoYUY71OOnAdsHcruA3qYCgZkljkCrJaNRWtX3T9bDTiedICLgeA7c5PJplAvsBTPWxIRkhhdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780029450; c=relaxed/simple;
	bh=IB6CCu/2f/eaTHRkg6ZJg8SpLFff628G4QmpvxqD4IQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WwVh4FYFobxuzAZuVxJ9LK61/G/Zrux/UQfIDJCPnnHiLDgbX5eSM7qskUaOhQOpCKOj6G8VZbO60L4k5wrt7ZSg2pfX5sHzzDkPRaxi67GxSG+cSGwZRVEnk6empEfacvW8sOXiukArnS5z7nFf4+w80euSGPaKzzvls0kfZOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=dB4FaWqJ; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="dB4FaWqJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1780029442; x=1780634242; i=quwenruo.btrfs@gmx.com;
	bh=XEImB6wZa9+U38kGcc5psGfvv3cq1QUR2lrTBM8cOVM=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=dB4FaWqJvgqmhjQnL9wzuD0/GacPtO7Qa1mrnNSoQIz1bI+xYLSgtjjgev/GOIZ8
	 9TZwJmgnlQ7nRI1ZbxzxRKSObAJ6JkDe9JH61A2wB8XdgQm3jMLQT3HJk89EvpCDg
	 Ilc8dZGdU74xl3hfCqmTtbYbOUrB2rxEMKbQc74jqym2Ep0JwRr7ayzOV4OWVxMLU
	 Oowqw966JiaqEWgsiwtvmT80qo8eyeq0L4J7nE2KyIWwoweYg/R5YY2mI7zh9JsV0
	 YOPKZDFSKSmWS5a4lR6/mfqs7pGHPCjrUmfzcbMhI9xQoPb0+2fFmdW7BfApZz2F6
	 RLdPueeZlq6L1F+avw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1M1Ygt-1wQtIX0XV5-00CCgD; Fri, 29
 May 2026 06:37:22 +0200
Message-ID: <bffdc5c8-1458-4aae-b250-4f1df215dc5f@gmx.com>
Date: Fri, 29 May 2026 14:07:19 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] btrfs: fix false IO failure after falling back to
 buffered IO
To: Qu Wenruo <wqu@suse.com>, Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org, stable@vger.kernel.org
References: <cover.1779846117.git.wqu@suse.com>
 <b3393b113c45ac7bd7b2649576b5667395c22a1b.1779846117.git.wqu@suse.com>
 <20260527160112.GB1981571@zen.localdomain>
 <2a0b085c-bc28-49b9-8c75-376ad2fe9daf@gmx.com>
 <48638d5d-906c-4280-aeff-cc68cacea595@suse.com>
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
In-Reply-To: <48638d5d-906c-4280-aeff-cc68cacea595@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:elEpFtW1K4pIhu2MvQSxx/ONuzVCLeB1yfwPYG1oTx11KEn4thy
 cnZzOLkSpPoz111Q1tnPNquGy2ckQkmUnZCToyciOYdCXW28/BDkxbRlz4P20R5Agk6xTJN
 aPC4s7WD6nQbXDS3rhyJA0gI1Hd2Y+uCUGPiUIX5nxeZk2gePyuUFBBxTPDgKYlurz0AAcY
 6+P6iWmcxZ9oAI+CjGtRg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:ichMU7LMF9I=;uILGM4WlELJApiO/QhV2bqwAd7C
 /sJI+Lw4W5kxMPuo/303fcQ8Gj3dTm1Hewx5DAomZk2KbxwKw1pjCf4Wjq6Fs3BjDgyne2UEM
 lJ08bkyy4RlzN8RLEK0UyDSbXJa2eH/FGOkt31Fe7UC6a/r9jhq0Uj4MBEpPPizgbNawJJ5nv
 IW6pRR9CHWQCLN98Im/N1oR/FVnhNQgpRZiVf9Ib9CK7nj6L7IfEmoUDsRQORHy6SZqa6pKHV
 ZNqo0l7Y7vVfFqlmzohYOLrEC/eCgXEvgEjMZlBMt/X3kJvvTIRnQD8S5/jmv8CYU9wg048kS
 zM7pxxoxIxHLR5FybrvQ1NDXAd1h3pGjc7ybmRZGr0pcMlqV7gVXqTQnGnVS9Z3KmIh6VkrZq
 NwzxuBGAysLg0C7gJdkuISGzgRaXOT01jIEPpmIkFS7B/15F9KtBXMfk/sqx9zp8wELsR46Qz
 fYqimsapNAxTlKjcw1UgV/WEV6qU/1Mmlr9hnLdevRwihaeXReGJ2w87qPXcdexoVWU+an0A3
 mS+YTq8rla1A0zNUZuR2s+NC0PyTsFkDXLiFuGCb6zXBR25qhNVkaufe5nVqyIbVydBsvESju
 NS6/BqXs3MS+DV3lyFmvL2Gwrm/gVdreAkdnghoB8qyh5g898pctys5xWAqFmMwLvQl9ckvIk
 8xZTalzDT40WqaLcJDUoCfv3vq0R+MVIrL3prUgOrfKVg6a9uA6Bomyp1ojTPHhZsPyhJ/4Bb
 X21BF/q/Ur8H2KM+Qqcy6NFTTRwwotfPbM6Zsagb2twZ6esoavGd9JIxOkPPfRJ8OC2PpSlFY
 p6r9Xxwhf7PGFQ4DhPshmoLi93NZmvwcxMhcNKRZCkQtBH+J2Sy7jJsQIVzsCrEUewMuOuAA1
 WmcVCbrEq0nmUWxgXMFdf2IzgfQj2akcYtXt4iUGlqAuTVcKED9D/djoA/0u+KITf8E0FVc+V
 gr1kWg2ElN0xXoxbyG2nfKNCMPd5+ZJMkHRLLLI31vGZlMhLN+zYEywKmtjjOdgMAZCQdxydr
 lGoPXKcfcnTXz771nwnSJrcZV6XAXS0O6EUKaLVm20RKHc5sjVOJNnDYu4y1fl2iXLVjIiV7P
 +g1qpf+o+yC/6inRjq2UZdiUAHv4ILZKk7q6tF7BbvQ0+7BEwu519ddWCOOKbIYgHaY8WKCzU
 qRMsO+Bq3DCPf18/is6ZKNUPz59iBbK7Lkrl/rjEYctjwksL1YuoKTNUkFgCeyuWUcYpRFHG9
 W6eqYpB8voB7zLTg9VvazJVOvssPUZ4gr26/DF+1zZgGfOhMDFQqv9RhEN+czpD4GEn77Y7z7
 CcProjVJkZdw70qybcoMemfAJZ9ZIsv2nw/Wf/bqhOOIEKC6ZLqRDwOp4ELjbQAPBa7e68zv9
 VYi7FdAEZ47iu0ikJ8//u/0+XJeGfGz+FJM2cLdQ22pneUSDLWJ7CE9vMzrHu/7/dCg9evMfI
 /WyX/nW86ZQZRnyadiZr1p2dcXF5/fRCR2Mwh7wVlDVQ8ioCYQghMBYZWEhN9/i8B1Aw8MBR4
 NJLkTAwzCof0pRAKVwk323Zc8YMeSuJ5UmfTkAPLtnjpVUeyloyzjsTILzsiWk3vQgn5Bli6K
 fbGdZg+GmPfTE/RjFW1/gJBcgn8HZQUONayrfFIv2umuPQxShCDOY73QL1bHIypPRUnEgsPBe
 NHhcXSMnmo9lTdbSgmYnHAcTfNiNS9oX+zp0eOesY+opyhOZgQWpZz5d2dVM87/Q6JCLTlPMc
 +3a60PqtaPpC/loo9b6VPU+vi7NzMidXPIaZnl5b6wvGFPQHGrUUPSbQIpkrcOfvmV4vBCqPD
 9FeO+qIIQA2HWBjCM/5GUwqR47UIbLX1KhBHbBan/g5I22TJTjE4Tahb+Yrx4FgModceHOQpr
 /kMbMFICjtFzbJkPwWt4XY6G4QtwzfqXtzpH/KYU7TiZCrhkZG+BMQj+RIt/u566hxnw95zBw
 3Hq9eXjw48QSVeORA+DREQAVnlE0dUmniUA2yIOHkOLBaVZIZVvdnSyvFGXUfKq4L/tGnRxDa
 jyyCa5PLUz3D2h1p5/MqC165g8PlquyRf0y9j5rsmx6pwEY/LX3baQ/O9u+mmRw3hbOgx56Lb
 tbhjTF+OS+mTG9JXH5czyPeW3F9ii4a8MuCctjRe4aXBhJumegAA1xjpHMtoIbCrNJx6ono9N
 wNQEqzBO5FZaShab8u9ZrwR8T+L+I3tSfh04gmHU5kYyeq65b5wgxmXAu/NpGUYPYwAmgdo3v
 vF64cVeUbShVMKiDU2fhOqoPG+hVNbnVHfBRnERnSxAuh7+bI1Syo1bFvs0qBh61nIxXgZ0xZ
 htofAV6r1OGiIinCWIFblkaWIqTU4YZTmqz4fti4Ocm2cG7y1vA2wjlw35Mhavt1R6Niy5U7m
 g3uaUexoCfhgrIRWxVSbdO0re/q3PRRwyRrBD2+6dpZapEUmb8Gu5gKpD5T+rhqHqa4OvtnG0
 JgBIb4qBtAuSew0+2sejUOuBR/5G/0/zjN21mQ+Biq32Qu7lH7JdRfP7uxOxkZYGrtBXv34Rs
 yaBj5bPYx6aw36AFZsp2NZSXoxlbmYJOBOA/OQLhX+KT7Swwnda77F7g/SMfcUGmW8k/WUgWT
 XW+lNvUsLI/NCuhm5AO6J91EhfznQ7+/+Ss+hpvp/9+qjgK1SdgWwAmYNdV7JhtWtHqWB7XJy
 JWXuMI2IdX0kMzZ257mtNBDyEC3XXJphDvzGZH17tRK2gGdClFnkNxlRuttkLhjMrAmNAAJgO
 TD5WFRh9LQhFMwc99j7BaE7UsxIhgdhdPp2bGHqoN4BRYiI58G7hFFb7x+ZMK7Eb9PJjsKgv3
 7j54IgH1bb/EgaG4cjDl0yEM8alfvy7ZdDeuh3RCf/HR1nWl1DRoPZj/YN2Df1T6wOs1Prq+9
 xq6abJKUIavAvWwopuI/O/MvxQQwYtpsBUuyEGX7jLqjmHVHupnOjt/0pSJWwOLxKgUwl9Ois
 AcPNb4DrLDJv7mx/zAgCZ2y7z2r1e0VDOA2732dfAjBOoBhx+GiKaLSHQ6dWLOPneyWHi/IVK
 grv5Uk0Rcdcypn51uDzkViDo/V65aZBGASVug+42hrOgOA2QHDnY1XVMrzsuRLcU5EtAfwMRL
 bWVm/POFUxXmFk6pGueegbhaHMrPCzMAaxRNCaN5SuTj5gc9d+xCs9JSwSj6w6zNoUIvZwA/m
 vajiJDA8EsRSChN+/m1fmlN9GGAfNAzIzR7tau4CpwF5GFIZIb639RssCKBIafKE9VxFj2K7L
 qvCDUdLXyOzABeIP5QOJGyPBBSgoSaQa7IooUHOaPcIjeAbu6IWwJiXrOeF+TdV3MZc7XfISu
 29RHhgeiESYDKIL42hjEQRTVa9D0qzDjKt7uj5XTyzO/DsL8Z+LqGrJ9Iz6JWNjk2hP6WzAmA
 q6hjyuA2OqINgmEGzmBrCqxFSliqvUT1kkZW0nCgfBvu/GZMv+fS2QSUXSAznZDyX9+/+C324
 9aTAdILOESRgG0hXM2+Kpdi4K92UBT1xU4EAoVPhR7BUeElgBdP669M4Lzds0cxue+7sQK4Iq
 MaFLrZxgGgBslR5cFzzn/7AuN5SSXKFX6rfKCnEMwfJjGLHvTQy5i+ecGAZ2kVoJM/qHdJyiD
 JV2GEP/qniubf6RdUVfvq+SUlEPYkjXSAE43wQ+b/T1n8sJNINLTGPTXbZoDEwyM+LC+cMGll
 3ZOg5mVHml1fJLjVY1thFi8AbpKlFXGnm6NY0OKEYx8H6MBX6ub2IoJzUvpqTE5ibjF1cwySd
 v5O5Ew8MzLSmlzI/IG68pt9M1CuZgosT+Flmu0Vz7I4OC7MshjUWg7O/CvvsM0qaFX10XDMTB
 IoOqkx1YjRH7WMlkVQX+r7tb9FzHfN17evpX8fZALiqigkMl0sftwxUWmYnPyn7VDtOMF0Dbq
 pVTouDK+zrtP3J+/FAEiNBELgue8gNIIq7sf8BwvaCUYIZMuV17z8p42kwwVQ+H4BRft3S4DG
 rgSAbSmcbLFox1aIP2ZcoK5nbQprJCgUxFtx+OrpWk4apXQlWGBTibMaDLH/SiM1znr0Z0aGs
 JnSGFeoNf8MwNGJftfq4VJGGYD/6z/aIBKrtJLg43rYVcbkTTLL+IfasfYe4DbAskHsUeRe2q
 MCfo6AAvq0RboBpWgX0nse3Ama1bvd2toOm1EA0XaVklvTT8HwJC9NhTQU4ZRibuSVH44ZX7l
 xMWpKfaM66BMitazv9urw/dcjSADLgqjcDtdSnKIuoz15TjG7l9YgFHx0J03hRwAWq5XTDAfk
 sNz0t8iMkZTKkpCN9OHQqKEPNiukIgnOmYOIMWNSgdSFtm6tT+qxmG3d0q3ophMJqOZLU87oj
 Qj+WZJA8ume2rg3YFB/PwmCjsRqnl8oJi+o/WQbIouToJOQfkwTh5yQ8rdNlPh+Rqw171otQK
 rIMzzcHhIplJiOfPXW6tFYD8yDXbMGPwIJLSn2MHUY0+nzYEfqx0rRet5mZ9tfBEKqX0Xn4LD
 X/Jt6DELTSohQ5iIJ3CqHsXa7vfq3G2BjPfLs2yhVxobVLepyytSRFErYnqUdE2RSC7uTEEOC
 VAN6Uz7pEnRDIYWQd3cE5EdaS2PYzF/SLDrwreD6Ks9F9mnTA9fX/ENADp2JaolE8R3WP0NkJ
 RX5mRz2I0IjZgiaJmptbij2+L8OhOccKMlMP6G+u8rQK1+jnG6XcPKBEnuH0Wrq1V3EwL/zJj
 bE08+YupRDCxU+SXr5WdSFNVDZaw5VLlLcTUIKc5PPg48l1FvgQJF4a6zBvSLF7h2ie3aVswq
 Po6be97oY0qlFN5+CCs0El/EpJ/E1bU1EZl97TaUF7pE4OsDLrNAfK8EaU1co4UQu9khFIP50
 LR9sYIbib/zr2uXSvPWFTSZT8SW158Rnvo1mcrrxZ5pEVAd0Ex8vWMZk42Ycpka0c4zDuOvAH
 bZSBrdXlHZDn9tIc6SXcldQUU9gIHC059yt7Ug9n+mTqVGCt2ZNjcV6TwV298sAnmPx/S/rpz
 rjWTjdsVxUrog1PM1YxK4w4d/+uh/w7PHrl5X7RgA7EpbuBkvOi6clcoCKgR1gR047Y0wBYAA
 3M/aKW1FOJJEP5JGtxEod6yUrTHaYvfzj1YHC6GsmTWSPb5qOiGDvWn7AqaAUDSXOjKltalhw
 4Haz2tgTbrjSZsCIn3b6GpQ96cYPAX17FrEuFfrjY3K65im4wc3SElmHOz+h5vOEdyoP6Uzuk
 phnRdROYwSUu8xSEPDlpx1G1S76NJXV55E/KO+VGjgq2gs8axluw5ELxYaPm6byVVn5o0jCvo
 8xaXjHB3M8+RWLKSL6TcPYHQCTSGGkutqRIJIfC59CXhADNgK4P6Cm2NPXu8hR/5LXKzOr2CI
 LUYUeuQx8xuS5034VTGqMaOrympULzuS0oqeGFHOPgpfczl/7MCVesKq6FmlxQ0ksULJClUAo
 6hlcc1U2D5Sy+U+3O08/o8qh+BrIs8L1lye3NhWR/2WGm/i6f1Hib6UY2etNU0QW/bkKp5N+Z
 UHAwPuvnLyM1NK+sKmd985Pul20wmXJOBtUdiCrQb2OMDCJmjZlZbawA8S023DSbqiZCA7NXO
 TK6v1J8fhWKy2RgcO9Bv8EiqPTtl2jJkKBNerrBjNKdE35ojmlqgJxIvS9l+uVwevfaBog==



=E5=9C=A8 2026/5/29 14:02, Qu Wenruo =E5=86=99=E9=81=93:
>=20
>=20
> =E5=9C=A8 2026/5/28 07:10, Qu Wenruo =E5=86=99=E9=81=93:
>>
>>
>> =E5=9C=A8 2026/5/28 01:31, Boris Burkov =E5=86=99=E9=81=93:
>>> On Wed, May 27, 2026 at 02:36:44PM +0930, Qu Wenruo wrote:
>>>> [BUG]
>>>> The test case generic/362 will fail with "nodatasum" mount option (*)=
:
>>>>
>>>> =C2=A0 MOUNT_OPTIONS -- -o nodatasum /dev/mapper/test-scratch1 /mnt/s=
cratch
>>>>
>>>> =C2=A0 generic/362=C2=A0 0s ... - output mismatch (see /home/adam/xfs=
tests/=20
>>>> results//generic/362.out.bad)
>>>> =C2=A0=C2=A0=C2=A0=C2=A0 --- tests/generic/362.out=C2=A0=C2=A0=C2=A0 =
2024-08-24 15:31:37.200000000 +0930
>>>> =C2=A0=C2=A0=C2=A0=C2=A0 +++ /home/adam/xfstests/results//generic/362=
.out.bad 2026-05-27=20
>>>> 10:21:17.574771567 +0930
>>>> =C2=A0=C2=A0=C2=A0=C2=A0 @@ -1,2 +1,3 @@
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 QA output created by 362
>>>> =C2=A0=C2=A0=C2=A0=C2=A0 +First write failed: Input/output error
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Silence is golden
>>>> =C2=A0=C2=A0=C2=A0=C2=A0 ...
>>>>
>>>> *: If the test case has been executed before with default data=20
>>>> checksum,
>>>> the failure will not reproduce. Need the following fix to make it
>>>> reliably reproducible:
>>>> https://lore.kernel.org/linux-btrfs/20260526070055.60193-1-=20
>>>> wqu@suse.com/
>>>>
>>>> [CAUSE]
>>>> Btrfs direct write disable page fault of the input buffer, this is to
>>>> avoid a deadlock specific to btrfs.
>>>>
>>>> So for the test case generic/362, it uses an anonymous page as input
>>>> buffer. And since the page is not yet faulted in, the direct IO will
>>>> fail with -EFAULT, causing us to go through the following call chain:
>>>>
>>>> =C2=A0 btrfs_direct_write()
>>>
>>> I believe that when direct_write() sees EFAULT from btrfs_dio_write() =
it
>>> should do the fault and retry, not fallback straight to buffered.
>>
>> It doesn't return -EFAULT.
>>
>> btrfs_direct_write() returned an dio pointer, although it has not=20
>> submitted any bytes for that dio structure.
>>
>> So later iomap_dio_complete() returned 0.
>>
>=20
> I added more trace_printk(), and it shows it's the EFAULT handling reset=
=20
> the error number:
> ("r/i=3D" shows the root id and ino from btrfs, "i=3D" shows the generic=
=20
> ino, "pos=3D" shows the file pos and length)
>=20
>  =C2=A022.223076: __iomap_dio_rw: enter, i=3D257 pos=3D0/4096
>  =C2=A022.223078: btrfs_dio_iomap_begin: enter, r/i=3D5/257 pos=3D0/4096
>  =C2=A022.223097: btrfs_dio_iomap_begin: exit, r/i=3D5/257 pos=3D0/4096 =
phy=3D13631488
>  =C2=A022.223106: __iomap_dio_rw: while loop, iomap_dio_iter ret=3D-14
>  =C2=A022.223107: btrfs_dio_iomap_end: enter, r/i=3D5/257 pos=3D0/4096 w=
ritten=3D0=20
> ordered=3D0/4096
>  =C2=A022.223126: btrfs_dio_iomap_end: exit, r/i=3D5/257 pos=3D0/4096 wr=
itten=3D0=20
> ret=3D-15
>  =C2=A022.223179: __iomap_dio_rw: after while loop, ret=3D-15 dio->size=
=3D0
>  =C2=A022.223180: __iomap_dio_rw: exit with dio, i=3D257
>=20
> As you can see, iomap_dio_iter() itself returned -EFAULT, which is=20
> expected as we disabled the page fault for the iov_iter.
>=20
> But then it's at the following code block that our return value is reset=
=20
> to 0:
>=20
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret =3D=3D -EFAULT && di=
o->size && (dio_flags &=20
> IOMAP_DIO_PARTIAL)) {
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 if (!(iocb->ki_flags & IOCB_NOWAIT))
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 wait=
_for_completion =3D true;
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 ret =3D 0;
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }

My bad, it is the ENOTBLK handling resetting the error number.
At that stage, @ret is already the error number from iomap_end(), not=20
from the iomap_dio_iter():

         /* magic error code to fall back to buffered I/O */
         if (ret =3D=3D -ENOTBLK) {
                 wait_for_completion =3D true;
                 ret =3D 0;
         }

>=20
> So that explains why we will never get a -EFAULT directly from=20
> __iomap_dio_rw(), at least for the write case.
>=20
>=20
>> Furthermore, the page fault in won't make any difference for this=20
>> particular case, exactly explained by the comment itself, that the=20
>> page cache will be invalidated.
>=20
> Sorry, I got confused with another case where the buffer page is from=20
> page cache.
>=20
> For this particular case, it's unrelated, and we are able to fault-in=20
> the anonymous page.
>=20
>=20
>>>> [FIX]
>>>> When a short dio write happened, we shouldn't mark it as an error, bu=
t
>>>> treat it like a truncated write.
>>>
>>> I am quite skeptical of this as the proper fix. I looked into this
>>> really thoroughly back in
>>> https://lore.kernel.org/linux-btrfs/20230328051957.1161316-12-=20
>>> hch@lst.de/
>>> and remember concluding it was much better to do the OE split and subm=
it
>>> separate direct writes, and I believe it was more or less working.
>=20
> Firstly, the OE split and the proper fix doesn't conflict at all.
>=20
> In fact both co-operate with each other pretty well, especially shown by=
=20
> the second write of the test case, shown by the trace:
>=20
>  =C2=A022.223529: btrfs_direct_write: enter, r/i=3D5/257 pos=3D0/8192
>  =C2=A022.223530: __iomap_dio_rw: enter, i=3D257 pos=3D0/8192
>  =C2=A022.223531: btrfs_dio_iomap_begin: enter, r/i=3D5/257 pos=3D0/8192
>  =C2=A022.223545: btrfs_dio_iomap_begin: exit, r/i=3D5/257 pos=3D0/8192 =
phy=3D13635584
>  =C2=A022.223561: __iomap_dio_rw: while loop, iomap_dio_iter ret=3D0
>  =C2=A022.223561: btrfs_dio_iomap_end: enter, r/i=3D5/257 pos=3D0/8192=
=20
> written=3D4096 ordered=3D4096/4096
>=20
> Here we only copied the first page, and at this stage, the original 8K=
=20
> OE is already being split into two.
> And the fix will properly truncate and remove the later half.
>=20
>  =C2=A022.223568: btrfs_dio_iomap_end: exit, r/i=3D5/257 pos=3D4096/4096=
=20
> written=3D4096 ret=3D-15
>  =C2=A022.223582: btrfs_dio_iomap_begin: enter, r/i=3D5/257 pos=3D4096/4=
096
>  =C2=A022.223588: btrfs_dio_iomap_begin: exit, r/i=3D5/257 pos=3D4096/40=
96=20
> phy=3D13639680
>=20
> This time we retry with the 2nd page.
>=20
>  =C2=A022.223588: __iomap_dio_rw: while loop, iomap_dio_iter ret=3D-14
>=20
> And still failed to fault in.
>=20
>  =C2=A022.223588: btrfs_dio_iomap_end: enter, r/i=3D5/257 pos=3D4096/409=
6=20
> written=3D0 ordered=3D4096/4096
>  =C2=A022.223590: btrfs_dio_iomap_end: exit, r/i=3D5/257 pos=3D4096/4096=
=20
> written=3D0 ret=3D-15
>=20
> So again remove the failed OE.
>=20
>  =C2=A022.223610: __iomap_dio_rw: after while loop, ret=3D-15 dio->size=
=3D4096
>  =C2=A022.223712: __iomap_dio_rw: exit with dio, i=3D257
>  =C2=A022.223713: btrfs_direct_write: iomap_dio_complete() ret=3D4096
>=20
> So __iomap_dio_rw() only succeeded writed 4K.
>=20
> Now btrfs will fault-in the 2nd page and retry.
>=20
>  =C2=A022.223717: __iomap_dio_rw: enter, i=3D257 pos=3D4096/4096
>  =C2=A022.223718: btrfs_dio_iomap_begin: enter, r/i=3D5/257 pos=3D4096/4=
096
>  =C2=A022.223730: btrfs_dio_iomap_begin: exit, r/i=3D5/257 pos=3D4096/40=
96=20
> phy=3D13639680
>  =C2=A022.223740: __iomap_dio_rw: while loop, iomap_dio_iter ret=3D0
>  =C2=A022.223740: btrfs_dio_iomap_end: enter, r/i=3D5/257 pos=3D4096/409=
6=20
> written=3D4096 ordered=3D4096/4096
>  =C2=A022.223741: btrfs_dio_iomap_end: exit, r/i=3D5/257 pos=3D4096/4096=
=20
> written=3D4096 ret=3D0
>=20
> Now with the 2nd page faulted in, this time we succeeded in handling the=
=20
> 2nd page, and every thing goes one.
>=20
>  =C2=A022.223755: __iomap_dio_rw: after while loop, ret=3D0 dio->size=3D=
4096
>  =C2=A022.223847: __iomap_dio_rw: exit with dio, i=3D257
>  =C2=A022.223848: btrfs_direct_write: iomap_dio_complete() ret=3D8192
>  =C2=A022.223849: btrfs_direct_write: exit, r/i=3D5/257 pos=3D0/8192 ret=
=3D8192=20
> written=3D8192
>=20
> So this looks exactly the correct fix.
>=20
> If this extra trace helps, I can definitely reword the commit message to=
=20
> reduce any possible confusion.
>=20
> Thanks,
> Qu

