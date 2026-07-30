Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5582B3C3437
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Jul 2026 22:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785450735; cv=none; b=gX5oX2teVZ7sITYZmPwXSbuPLzLHFDuk30lVp0enEq01nDggYB28j86Qav5tphUYaWX8Gj+b5INdAqiuhhtYlj4FK+pku/a/HoFsrD5+N8LxJXYCtocnkFiV3BNVPnjke1d+3hDBBijajFIolNtZlqEbz2N2IGA98+L6x2nqy4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785450735; c=relaxed/simple;
	bh=QSEECZ3d7zsVZKyzTsXVtX5nysrM1vWWoNuMveF+ayM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Gy6dVj67m0up42j1/BKs7y4AAjmhENZz4rag8VOnIwWQT8FIEKhyK6v6V++AQLmUZDaxWIOJec/YxZqQ8oWLYowhSkwXVtw3C6HQB3g5dQ4NZ6ily/K6uUvcnYYd9yNJP7HAqZoS/bTNIIirjYOz322AltjItVAxYGAFLwOmx34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=SbfK96ji; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="SbfK96ji"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1785450731; x=1786055531; i=quwenruo.btrfs@gmx.com;
	bh=ZW5ExA87tXUfMKIe6J8UIHnAzrwZlM+N9tG0tjV2Sds=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=SbfK96ji93CEkiJUeruL1JcLshnMKzE0qLojBMLzbZr4W0tuoMqjK7+bgt9Wf/jj
	 YYe9Nj5AVjunaCMJMFj2KFZLnaHUb4XD+MtXKjhRGRMBf2ENzKfgidOHtPgpLD7Hd
	 iQwtiVqmipzZd8tgMgDGCWXEr2IxkvzIXwmnoy7lv4NxALFl/aEWCOsB9J3NsddjP
	 JMJGrbOLw75wnVh6Zp33e25HK/lMpZOFukI5WujjwlVG2J8LXL8EmHCWp4wvQkagw
	 LXepNn7SmgY2IdvhERoelgFvK8gqvIMA2zLbCpTMv3V1c8qLiCYBw1eZ0Jyt+yQkY
	 ZD3BXGZD0+inwny4WQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1M42jQ-1wpZIQ3ed6-00GzBR; Fri, 31
 Jul 2026 00:32:11 +0200
Message-ID: <3f077601-ccc3-4618-963c-ddb8570857a1@gmx.com>
Date: Fri, 31 Jul 2026 08:02:07 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: skip hole detection during full fsync for files
 without holes
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <2673cd12fadb5269b39417694d82e02b90a482f7.1785429154.git.fdmanana@suse.com>
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
In-Reply-To: <2673cd12fadb5269b39417694d82e02b90a482f7.1785429154.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:IIFbb0J9K9t3Ys+N/gbXPtUDJ7227ee7pku5lH1RG2+rPoNxAe5
 FcXqzGtivDVinxS1C9kL9wpYOSfy3nZhldnop7FfdmsrKrioGimcMPKOXbcCb5ljYzYcp5l
 wLiyI0YVpPe3Mwc4FZCpOdWf0FctiCaKwsL/I+/Ou9Fv40lqTUjwa0Xf7FxpGe0AFd4QrnK
 PFAmUT0h+Uw44v8ZFkxhA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:z9wWGI0QfUg=;3muDy1pyh6vKIYD8bOfAET6xsM6
 zqhuXSPtFITqxazmt0SyQA4kjAz1UXKUhYacC46BLBxLEagYEjrg/hvzCBV5bIlmyYsvhS9Xy
 LnnjaSQxGi9JBijJkmgs8svjxxygtVjXuP6ibo0cXuzi17ka4UvC63o5UVhBhaYiJ8fOaTbug
 mltaJVaKOaEqN8bbbnm7LdfCQFwdaCJ8MkgpvDzA1r93yRqwyIS7vCYv73vG2aGeV53+aHxqC
 RKq9M8TDQw61aB9oKfmqIyP1W7z4SljvvzMFnIy5grwkWsC3A8Fv7J8Udnj59/qIf9WNz8D4T
 bXz//AcWPfN+W4tAeojolf0Bjfjlzgn6BVWsD42Bq7WCJNLpK8FarbHzMlSooNyHDrmPlNP7B
 L1qM+YiNgeieBQw2cJpAZ7pysF9j35PgnW37mCbB3WcG75wzaUS6TDIKbBn98TCcdfOpca481
 Gyl9JJ98Do4PF2lVzcSYdpWiYERmGAVNYeOy710eairxIFvoiDiJGmmuVgqpTkb2PdoS2reVj
 j4l3Jw2vh0g7hVAuCJgK1D43EGwyP4bYSKAnfEL6KNvR7rwRgftjB/kXJE7dbTzhyA+ROiN8r
 GxHGo5yS8ePvWD0WqDZdLAZobPJydd/AxWtOLP9QJ/OX9KOLO6ebJH3Nu+zqtDgyMXoOeXjmo
 TxAks65ZPhteL/g0fajpqKIJbX4Sxsbov3dF6vzHo/zlVdxiN7p0ckPsCxFEFprrLIxIrejNI
 +j2VLfYZHL1r7nHcPPWpU99Nq6ufS/LqkLd+Z+vAFo15OZlBtH4S43jtYkW/gjVBrRTno5fdL
 NyroS12JSJFj4W/GHODEJs3gqfISnKfXSK3oFrNh4oF86AmNfa7QbBb8jc+7xMdhdeJxMZrHI
 k8Uwg4U9R+5hLaVe3h6DN2k6FtHvUOiGbrhAk/QZQAEsugNeFJW206UNj9+UTorcjRX7GrclS
 rVFbQzrqZhZlzZD5+mtry6Yc1wFSyhLpLKoz/+U4eXqDh4G92k2FOo/xesrkS409Rvnff4Wiu
 4J3+IZjoZGIhZRAFLez+BWRGPgSCxzhD5QNKBV5ca0bDdILfeBPrE5NNicTY2Rzr9oTTuhZpH
 Yynfufs1U6eGrxc+x57xz8v1W0U8yUWZgZbXLb17X+oQ0X5MGMmyJcHRqXLY4C8OUQ/DZs06l
 8dhXn/wgcNofcamMLLs+SdGIO02668W0v3xt2Tm5YINoaHMkUGXVrJ+I2MCiY8L88uvqoK7iq
 UlWE8KqOJww2SjcHK1DKFZ333QTVXvwa3tky97zR4YxlTDcvwPz17OGnnLKPsI/1i1jTQgy1p
 XSYdTn0+6ESf9wpnCDl0jWqfa63w41mpxjqqUpc3nk2QfvNbKE9oqOVVD73XWpCR/KB4FL8Rs
 AULAll70g0xgaYakLOwVhxeEP4O2EsavnOtFrA4+KOwdBtEzDmeQK82Xigx46oMMeRJoKruNX
 93hkTwObLEccjY6b3x+RO2ZTHY5kGQqnjlys5MwTYnJWe+ldqLdINspX2LoYTJ6wXzTC/BE1m
 UK8DJZayOFcT1/xz1CIQsfslA2b2vxWpLoZiB8ylDQ1k1SdTGVnj/GnwiLRtau29FX02cYTkK
 5/utq32r1+W4vP3E+LPnqBbkVw8ttQaQ1SHDl/n/UN/6HjPD/1Xr2pF2iBv97Nxan+Nz7xJo8
 AnOxmlrsIqHQsYISNJicyYuZkpbzQ96c2XQPFZwnxNZcEQe5TGufUSmZY31uHCbDC6w7fuRgz
 3xGwaT4v5J/HyCJUubLA5MgFflNze+mvmaAgdWEvWhZLmIc/AdtEgitGJcfQp0GtU/8mlOAdC
 sHYD89kc8ATFbRjQWGd7OhHhHOd6zzxBuQM/uSykhz6D+LK6+w4xO4Wf5PLM5Fo+doRR5Tysw
 c9rtJ3pNcbRd4aWYYNMA5KeRL1hMnLUqfvZOuD0cbazjclDRDhRq0Wl27f4nG3A6b+b41/5cP
 t+7ZvkkYylA6pS9GpgQxmohdpoDYkmzbmvtSuJVmlP4KhHNOiDGryrbuX5FRPt+DHqPqIbTjx
 e+fHsY4steUWI0Jesc16i08jARY6FduRso7z7Ye4buFOeOvN1aRFcRJd8x/ThsSJjEKXaDJFl
 e3OSPQi8ptbCBbAhA2Ku5FZDOfC5AC8h+mMW4dsv1vgNbytRpGz5EBJBwNMHOf4L+WMLEboYd
 xDm3nUWkRUcAknv2282qliHuTNZsbk0JBsazVWjRNGnw44tMUvm3DdiaiB3wiTIKIVBCos3DY
 qTE1pgus0WaNtBGEzWSrrcde0MCdCXvj5ZlFJIOc0fz2HVYpXA9zZh1pbAW3frcS8zAJNTepY
 P9x05+xZRA5zLQKQKSdJyXdM2Savxx/mKT/qx7QiEjmv+J46gLFmb9CUJ8UxCXiPcm7dkWnqa
 qNUpGxdudmSaLgZoN3fpO2eI+NsXMrRJtwCjmoa6SLN/6yJsLljjV2SL79/BNfO8p2opN7Lqn
 1zaiZgx3DwF3W7rdE3xelO2B+rt0nQ1KR0egKzTduk7KeIffziNsv70ln7H53KWuQCZpIcuJc
 yAS4r6sdEGZOM34alCSXDk5+GsgaXsdfjySxBQTGP3KWFFtZMLU9FAQx3MKos01u/1gemjPeM
 t3oR+EItZa2prHovYtIAoZvmaoeHKAAqbQTweSNnyWU+T3sEKCcYJe5zcNkdFcVNUoNokK3N+
 ynNolarIJ36xJwJ2/n0hJVcZDz3Zu9i796MOHhPOymNp3lrOAxa9AqBZl/T3We4eXQO+B+Yko
 aYajh6MMDpq5nWbWMhWQt4z7ho65iKw9ffU49V+aNojpBpvIce5hJ1DFMjojL704X6AUOWXh8
 wRDyzPIiRfcY3ptRF+2t2gQ1TnZd3BfDcS2Pt8VLJ2Gsy+eLC/VJ+pd89UD2wXrLKIIhMLamB
 CnKCUsy5wOPaB0sYQ2ts2T2HByc9ZASp7ME34i3vcOkLJORG46+VOC4TjYtTywBVk+hJYH+rs
 0EprlR4IfXfk34/7ro6GGOU5g3TAfWxRhdxqipBbfZol28gN1iTignOpsypdGheknmxwdY5L8
 gfkTvw/0BAcoYBZ2SJaGNxl3aQYfVR7XqkmqwTli7LOGduPKVp2HZpFE2VMqAabOgoHTIOIfk
 pjpY9DMB6bQl+OClHXQtpMUYz6+szLFPDUztUefN+wiuytS04IC07SGiJ+aypNshTDCpy5Fgj
 lvFanmzQmfYgQVM5BRRFHucl0jtdUKG++HDaB+Yvs3ELOfarznI/sa59WoiSDZ+/hA4KPkONY
 e3eFSF5r3eY/HOmV6Gmd45bc499lIz6WxQS+4Qe+jU6gUjBaDyt5WRCxcxBkAeth1vA2UWklw
 9u7kPDryzws/eyIB/6niUU1XhoX4Wi04Nadxk/LM017Ef/vA2EXt9qcQ4aozawZufAyIxenXp
 hwwyZcsK0ONBD68tdf4wd1W/QAS0lBH3MKnWJ3wTdU/PrnugDGtY87MQ9tkAMXaWsmoGF3xiQ
 sOI5oFtDI3W95hZXdc2mxLCYPMc181nPKv+kTqmCuWcKau8G4PpepNMmT+V+Cn6Y8BR9BvzU0
 cLob8aJr4/XrR32QTPFjPYxFnB23EnO7SKh/bbFZDX5NQd0mTYZEKcip5iebmWjv084jeSXaM
 cab+LLVJvH092As2wVNOhitEhzmJ4CSARIGUOkTz/XY7SqpRSu8g+8q4fSehHd86HNbND5KPk
 kA5B84ajQYZlxPnKdHVT301rWUgE3562khXKVxSHAnH92sQR6CzMI+lViKpHIM258Kc6Pj5Th
 dj1yLa7O5rJc/5FFm+Ss/w24e8HdYMM3IY3oUYvuj1fIgi4oBUglHd0yRqpOx50eaeMxPInND
 QNjq0cept25xhzfNQ285Xb6waCrqbp0hBNi6co8BC0p0TVwxiXcY481V0ptCo9ndvGnQRNmQ6
 edsXQ+rGVnVrElj2mWiNlDkrlzSg8cOAH6xm/PqqKmGGqtHZxsO/vxcYOxOyq3gm0NxVtvFYG
 7mGE39wTF3BNyzRNN9She0XiH+aMNrr6xRgrt5N/GHbG6QxUS49r0DpDb0xHs96UnLqQ39Bkl
 4YktMRw1LIsRp/CBkNNHqH0VL6sHrq3quK1eIcLxZ1scXnIoeav3ueLFIf3zrn2oKU8cxWfjN
 1wYaOI7OjsiQyT516xO4B4KOuy4r9c5tugBTsUBnmf70WLVnEtINOdK1sTN8hDIpVrRMtpdrH
 Hz4SX5TglIjH4O0+ilmOb+JB2TA/QbgstHc7Nkcg56L8idiIfBXYbsg+S7Dp2x7OVg3d7Y8gj
 7ZP3oxko7OyfJHrkRMszgIOyWSYrEyRo8BgGNWkaf8MQ1t4nm3Fk1t/Swh8E4HHPx1woYM70b
 mf/owKheRHGBO00BZYInF0gnu/u1j9f5no2wRCtHQmB03dLTCIe5SCPtEURev5InlLSkd3Ulm
 uSzoTTYQkf+sxb+kMqUJvvkPNtV1jMQpLTi0jhHl/TkYHM/84CrgO9MvXeGj2OD8SNmhC+24V
 GogmMENXBTikE9KFaKI3jGeTq2i/R73oNvVYo2OawQ8WsvMq1OQ1xfO8CEZ0dQao/4xodBka2
 mc9G7MJarquSm20x93Oi3RJ1tMS/vbX5YqnmZ5EJy7IGUzifXfNUzbU1ftGPPP43d+asBepoQ
 m4EzE5Jr6lJqH/6y+D48UahyrzYut35Iw4V6b7wL8BMPwxys9ba/NnuOe/DUPyJzZgxnZPtFv
 tQ90+rhAXiuH6v0TjVGKFRK48aC1xlXJgZV62IaaHxCgEWSzZQhw0bqfSQNBB633mgngNbVSh
 TS8Y8uH39ezSDzZnncop+vCfMOHBJioLltva3dw5MHFo5zGYdMA+xwZBKH9ppet2H50yt2/nY
 U5QTYs3Qj3dW3Sks4/uU2cEoCa9QxkNkruu27ijt9OHKiPyrwIwGl8ra6tH9AiEdAKptuvOHq
 9VNGhTrvR3XWGb94uyvNqNlW8J90RRBhwtTyWaPJQB+MKE1x3MFFHbkLDfCcKeJoleYlB/c6F
 3CzowokS7qkx9kbhkdj+KFOuWBFjRncxI5Km0yCYuRfdVF/gtx1BM6irt1GnNQ1BL9aI1BpC/
 4fCIHyN4yA6oIP59oMcTKHcM685hRx5+41d7ud67w4jRiMrOmkfczyPc5rAwN67dBcZmeKfdw
 FKdSZ97m476NalsF/IgfcQMP3U8S2Vm7TP+z8gyAVnOeZ6pbksOxXhalfh7diIXDluzwyPMW9
 HxhUoOUG+bxbScpk0Szgy7AvomYFxcatfo2uInfgWBwt6oISX7LshI37VIUM/fIkL1sKyOw4N
 2Km+MmlZqujxrlS1CGdGt+jAmA+SAilMWwjDZk+BIYiNT1vNAy8o6sWgpiQAGc20k5FXfXuoU
 lm4O+JwQABI31Ge5c61melU0paiJ8bK9vXXjG1u0KXKUvbvwgIoYU8I8mHPV38q8L21hxdC1l
 VRZJrtX74hI0C1zRA4FPYsZTmwEbmG0Rp6poeTy+bzDPpN5f3V2pEdx3pY+qGV61gLaDOguUC
 wRyiermQB6ukd1SdEIhL/2iWY/xRGsQfbLIfABuqRoXeFgfepbEEQ4KdZ/bgGuT0oDZbMMRFu
 BTLJiqaZjlDCeEIV0VkcTX56gha5O8eWWNcDs207CFDN5yf2iphllH6kbhDZUjYNzJo8GFF9E
 rpWCktqslCU75PFglWWc7h21PuEfJLvHGJAHSJB+vsbMwt2g9Ay6RohCDmyjukgC5FB6NZhLl
 i2SBBsqQeQ10DiG1CIzAElrqTINYpwTUUZRlGymYHGOXcTE6LvOCedPES8IzRo4WieQ2BnM6r
 RZDFkOLp4c7hbf0b8b+O/hJMXqZ4ANVm+t26JdYNGjApHIAmdGsGt0xEyQ3nU7qSYVhXwViOf
 4pOGUPTdYILp



=E5=9C=A8 2026/7/31 02:11, fdmanana@kernel.org =E5=86=99=E9=81=93:
> From: Filipe Manana <fdmanana@suse.com>
>=20
> If we the no-holes feature is enabled (a default since btrfs-progs 5.15)=
,
> when doing a full fsync we always iterate of all leaves in the subvolume
> root that contain file extent items in order to detect holes between the=
m.
>=20
> This can take a lot of time for files with a large number of extents.
> But if we know there are no prealloc extents and the amount of space
> (uncompressed space) matches the i_size of the inode, then we cannot
> have holes and therefore avoid searching for them. So skip the search
> if those conditions are met.
>=20
> The following test script was used:
>=20
>    $ cat test.sh
>    #!/bin/bash
>=20
>    MNT=3D/mnt/nullb0
>    DEV=3D/dev/nullb0
>=20
>    MOUNT_OPTIONS=3D"-o ssd"
>    MKFS_OPTIONS=3D""
>=20
>    umount $MNT &> /dev/null
>    mkfs.btrfs -f $MKFS_OPTIONS $DEV
>    mount $MOUNT_OPTIONS $DEV $MNT
>=20
>    # 256M gives 64K extents of 4K each.
>    FILE_SIZE=3D$((256 * 1024 * 1024))
>    touch $MNT/foobar
>=20
>    for ((i =3D 0; i < $FILE_SIZE; i +=3D 8192)); do
>        xfs_io -c "pwrite -S 0xab $i 4K" $MNT/foobar > /dev/null
>    done
>=20
>    xfs_io -c "fsync" $MNT/foobar
>=20
>    for ((i =3D 4096; i < $FILE_SIZE; i +=3D 8192)); do
>       xfs_io -c "pwrite -S 0xab $i 4K" $MNT/foobar > /dev/null
>    done
>=20
>    # unmount and mount, clear caches and ensure the next fsync is a
>    # full sync.
>    umount $MNT
>    mount $MOUNT_OPTIONS $DEV $MNT
>=20
>    # Do some change to the file in order to fsync.
>    xfs_io -c "pwrite -S 0xcd 0 4K" $MNT/foobar > /dev/null
>=20
>    T0=3D$(date +%s%N)
>    xfs_io -c "fsync" $MNT/foobar
>    T1=3D$(date +%s%N)
>=20
>    echo
>    echo "Took $(( (T1 - T0) / 1000 ))us"
>=20
>    umount $MNT
>=20
> Before this change:
>=20
>    Took 28721us
>=20
> After this change:
>=20
>    Took 5453us
>=20
> That's about 5.3x times faster.
>=20
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>   fs/btrfs/tree-log.c | 8 ++++++++
>   1 file changed, 8 insertions(+)
>=20
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index 47046dd14997..226dd3053564 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -5591,6 +5591,14 @@ static int btrfs_log_holes(struct btrfs_trans_han=
dle *trans,
>   	if (!btrfs_fs_incompat(fs_info, NO_HOLES) || i_size =3D=3D 0)
>   		return 0;
>  =20
> +	/*
> +	 * If there are no prealloc extents (which can be located past i_size)=
,
> +	 * and disk space used matches the i_size, then there are no holes.
> +	 */

I'm wondering if i_size < nbytes, can we still skip the hole scan?

Thanks,
Qu

> +	if (!(inode->flags & BTRFS_INODE_PREALLOC) &&
> +	    i_size =3D=3D inode_get_bytes(&inode->vfs_inode))
> +		return 0;
> +
>   	key.objectid =3D ino;
>   	key.type =3D BTRFS_EXTENT_DATA_KEY;
>   	key.offset =3D 0;

