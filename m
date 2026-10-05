Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 331CD3921E4
	for <linux-btrfs@vger.kernel.org>; Mon,  5 Oct 2026 22:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791238413; cv=none; b=TWAiaILRA+HxIj489jRO8eI+Xux6+q8diDz6ydcZDCXvhdcTZcOus7FiYASdR7faIFF25jHI3N5Zadhp7wntO5FXIrqtUDD3IsKrZSSM2AkSBwNAo01OMxO8Kg3fccneDgdVCUpriGPDojPvMzk1s4tnHPnEOd3sA1Bcl/v3NyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791238413; c=relaxed/simple;
	bh=G85WHN4q7Kymv+oyV0XRn8TzVyUdk9heZRV/gBPRvyA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=cm1uoqXPC9uzbv25SbsqttUe/oPODGXRq/JvcYthwOiKMqs1JUxKWYX+gpL1iz4fyPczxChGMQXZrmS338bvjUg0ryTE5Yje8JOJfaJS/+0G7bOzATWYoS5IXjcNYSF4292bQ2xfekaJsYo9yNHq+TuwvXt4rCPgWhU/+gWoZU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=tj5T1iSl; arc=none smtp.client-ip=212.227.15.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="tj5T1iSl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1791238405; x=1791843205; i=quwenruo.btrfs@gmx.com;
	bh=IBb0DJX8d2ASrp5Qr/tGuur2Jj7AElv7xF+k4g9ZRpQ=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=tj5T1iSlrN/gTVqx3eKLP6IQIW29NEfalgQaKXKjeULgORjS9Z+OZln8vf4r0i8L
	 sP0lvXf3BMgNXs4V3E8+M/rl2yji01TBvumuuAcB3uaUcbfp7KmBTdV0s9s4GbqkO
	 II/V5fwNCtEMjHkujsGhE4EJE+V1mnzVwMPF4J9/OdOqNkigM0V+vDwbtRv43h8NZ
	 SsZX1lXmIMITz7APo31nJ687TTZGzbg3jRkJtuinzCRYtx5/21hHLbEUQb/1Iz6sT
	 sqgC6JlGYe0zZkLc8nvjhcvEQLZe0G4zbnahBq61BrRdDxYnUcVeHZpgKzBMThyWe
	 kvnswnDbFmw5jmH/ug==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MIMbO-1xPwIa1WmS-00DVqN; Tue, 06
 Oct 2026 00:13:25 +0200
Message-ID: <11db8f94-b974-4aa1-b74a-362814e89b94@gmx.com>
Date: Tue, 6 Oct 2026 08:43:21 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] btrfs: fix a bug with the squotas code and cleanup.
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <cover.1791202322.git.fdmanana@suse.com>
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
In-Reply-To: <cover.1791202322.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:tzMi4DSurwD5JLpbko9PWgek6Bp9glnYUp3lOg9/o6PSZivpRfb
 GBbL+/ex2Yiz1rA9NyBvLd1VznVRSlIJufU/MTygQLv/R6xb7udHU8ygVSmH6VMsTGMFlnH
 C3qUQVQsTemH5NtqqGtuEueGfN4S3W9opG0cktF8+RdUOFsEOIF0p4zpPPXdacUAbfnPgNp
 FurmefbwciB5z0Ijd6wig==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:/isoTDB9TKo=;I5ioP7K4hUn/hLaiq7MPq3xTEoN
 ThyBYLfpCyQn0oPo6jdvDpywMJTKoxdkga6KYTVrmW//SnC2ePo7SasJc3eiHqOneid9JPwq8
 kQvRy2xUDH4ukTwM3oqMppfV0at3NpblJO6H2rHKOGjGMhbq+hssgBGAgZ4D2sE1MCM7n9GOq
 L7oEdTWFc95GeZTYGyaHeWjSyR/WOXORddibBYj/HOhByW6AIZev8VzWrV6WPn7FhV53DM6ju
 jJbPNyWzTy+gis8i/ZG0+j628LSmAuaOY8ssdzKdUtgERn2PA3et7fT30PIL+hLNeP3U1y5iw
 PeI5qTAAykk/w+Yrg0iaYQCl5n2zKerh2U382NWoy76T6bLB8Dx2Vj8B48b1Wrsjtrguw7xgC
 9R1V6sYLPh74sI9Wh+HBMJKMAJTSPhW70LAP+0TwPi/l2DtKpvUK4UOssdHmNkfx8b4GPx3H7
 hOAwJDLN3AzpIOuALHkcy6nLhNv/Lw56/K74u+jASxw+T9ITzOtOs/Eogl+WK5fXCZJncku1j
 bInk87eprMrz1oGJlkCDCD3wAdaW3bANzLPyT9UFRDAVR7JgMs8JABK/0Ecc5OXuiHvXi+hLp
 CiOAbavs/WT4XGvOg/iEvclFJ2T3mL6CA7vx5sxqdNnhsec6RZ+ZEfcWXHeEBdbhOOKB/1au/
 6p38bGXBHXxkbKS6AT50UrsbCOWNvP5DP0yijnvY0zzMkINtU7eKe6jkjFPJUMa2XN9xodipk
 nYz2CcbBOHc/YGQGqPMI/9tziyUa1qDFLa7hMgbeMnb0KDyTq5eR0nzSkL8loaLXGG6vAgxXi
 wd51gAgyJ+ZOesxQ2sP1suLz6+Y30APl63+B/ksy9CKHTmRO3WArPHhz0zQkm8aYLxzFD6AWk
 3/pw0d/4Pg0P+50UhDHnjuPTpz68hEVmjaarKk7IiFgbmToMzCCJkU/Pz7cDge+TuZh/hdRi3
 dhAXTsn5Eu2I3Zau4u65TEvuNsUkUrpxfclB7m49yuJCn0blILhZJnsQICFt6PPyp/M99rEr2
 64/0Woww2WoMUqZip6oNJXMFrQuEg/7fLEADG1qnS5YYydLjNl+DBv2cdyHOzysYBjKehGzrq
 cfx1Gx8FRqLYgtu9pwnkyoyU85dYrfvFPA6RjTIQpDqZzEqa9IFNG4yQL3HDiW+S9v9FS8NBM
 m0+nP7lHr4SDUMtKzeKZkIr/UEYar7JSp/+/W/jUN3PVp6AEhJLyUA8foJHXUFdQfOlURC67n
 HI+/DDjy0XGoFSJk3DNgTZ7H+5h/n5lLGEUcc4wo4bBL7LHEfNr7ZCOsG5ETEsnC5jL/65+x9
 cS/08K7tFy2FReM8X5/vAy3ZpeJoUfM6kfh/0+tCD8xNkDLyjJr3LcO5DxxV7x0C1XDK901RW
 0KpEa1tzfI+CwzDUF5mXtSAenVwfLpob3R+U8YqhMvq4uWQZn5+9iyah4FmFFjWbAtVFm98FG
 GFo+gOeF6YpGbKtSj4AsypLsBE694Li+qG7wfvbgUMpBNleTCNe4h81wgFDHPGAx65xzpgxKz
 jv2wSRV8JSntBKpxJzvmWPcSe53xjSPIdtoF8zcPNakFraDFIJrfT6xGa9TZQCJGCYssg1GzO
 rfULgT7jT8bqMll8TBVE7rh0qmJm2Jfhup+ZD/qmVTjnMbYEvbF2UqI4xUr3ZqsIr9tE6Yr8Z
 /ZCMcGlLvLMRfH1C0UWyjXJEBEBt2Zl7tlYs5UwnXEGB12mkg+AaGtrJnjC1Yt9tGWTFi+wMQ
 Shqv6Hvj/zyO9Lhf9o4d5R75CQf/EYRFr4bhYgye/TQML6h4HXjXBH1d7eiA9Cv7BF2qOCFqt
 EqMXlMls1ZgXerkzvq6tbt73jV2WcLozfRmn+/t+TTXuHkngqMUoeAmG0PSisA5Sqgrw1ZdZk
 OjZSjTwjeMWhcVRV87IzABQYCDRSX+ZEUPig56/Cle9towEY0KnTHxoGDB1snA3gTr9Ar227S
 0NLmENNUSyX/R6joYuMteWHSbLYt1T0KPPYkWmU5QNSzHlDBvVekpbc8eYoNk4gMKMp3/DMy6
 YCGkJz1lq1Pd3aDRvf8g/XHy2xLBxjrhDJPYDYeQ3nFJsX/WriHFo7txJz487C8I46wGnS5vS
 VfZwnzlpDAKhnkgw3JQMmKdccWiyOeNWCqNzBjld5j73PbDbVpUeBL/jFoAS7yN21dtr3EsEz
 8AXbfFwUhEWRH2B3yCizqk/eJu4wfa+ualGYh/wG82mTFN4qriRazFUfYzdx71zU/gwkIQ+0L
 uKHDKfS5d53Km/TGS5BAxWKFizDhDhDgLXDMd8LFB5MvbxCUlOi7j1iniu5gCfAK75nMaig9U
 K6+vlFIR3ZOL5CXMuhZpMkfxzaIBcIyGaM5bwx3GGZ2wtc5FSMxgl/Bz7phKPRK8smbq8InFZ
 mb0r2I2sYLh6F4Demtmy1x2fUbIWgOmrzlwbmBxmtoIKPR+HXSbIWxwlkdK+FpanXci3dlDt6
 HcccxgZj3RrH+xceOZvM8UjowDoqy7y/Uyx6mFGRiG5NTteqTJwPp7NFSvxwkXTLpMJ1enFU8
 s2DPdEbswqnAMak2T89PRbudAmWli0XfnU+aa4vjYpONn1iYtVOoag7tPBkrzTDRCKRMJVH6a
 +fKIPTZr1t4DQ42uG8wjxaQfr5zS6GU+pQEoDRn4xigd6phFA57EUPZVUd2T+lrWjpkbZq/cV
 NSnJGtdFjva00PohT8EzDTmnt3Lj4OGhb+LwVMMe7bzbqOnqcIRENUAbTKdC7ZpRbFY7YjE92
 JYKu0qiMy+vQvdbOObomRxSJ9AvhHppnHnj33U+lzWFGRukBJsMAeE6xm+BWN9TgufBxgkavm
 af7ltMkrdtnHRIF8ECaienjZnH10qt2d6a0etCI/NHWGu8c3/humhRSokp1xUX63BYavPRkQw
 NV0BugBVsJmr4RamC1xV8NLtYtUy4w+ZD2p1whGWhzUZH+EPYtwnJXtF+/XOw24JtiRFezxct
 FhE/2Ut5w3OEU/ZAh0S+UMG/NL1YvfpDIfLzUS0F/MydVBVegnOvr1XbnrIYwm79FRnzB1HR/
 giFF+cjWSKVH3/Y5i8Y4VDpKufqH0phqKC0TAdMX3TRWeT3alfpXcC3833FUx0XFmO5eKJSW9
 K/hgi27R1TSmxOzt84ENgiLgcvdR3+XjxYtDexW8Lay/nn2gbYuQEOMVWeFBKONtxVdCFZ1wk
 h4Lv9mjLHFvZBrrYeTlQXWHhlygi2JMYufM80MOwrvcmelcuVTgRmUiEeAXyUbanH0hTedZhO
 H4pnagl0nU/aXte5fCPdXS7XnXbJ2RYINf3IazpbWHJYK9j7KB9sozNSLqIVcHOGK6zuMBQcI
 JvEma87atZ2V8LXQ+SH/BShsHX50uKaFt24azflbQ4VQEFkCO+Z0bIfuH8KOsnBSDp1sAU849
 xpaHxVNJiKGxfjpYrGyx9RW+1xVKm/5L8jyrIPBtietyUuJME6HG8OslPOkhFFjImYuPE9XGT
 axZr4ERQFhVehlQINog3ptglM8zlRdHuLXICJJsyfDIpGmtUY/htA6RAgjZRwPdDU5YQfgAnn
 ik1AWz3u0I2fYSpu8ZiKJpJZ+NPTs/3N2BOIxbRS0vezlYnBkneskfVGDcj7e6nRPjPGETk1e
 bVgA8JxvlmX/4AOH8G/NfnBc3+udz95AZ2b6G4yVms4vHHLtls120eYBdB6nkGZ65+3Fo7Wc2
 3i7aY+ZvQzdtdleKeZ9x+sOu0TBFsE2mzp2NobrnMBNRMO73abLJSciH06NC2XKo+0qPy8AVh
 6+ETVBOvtO+d3bJUpSle/HzN5BEUd50DGWPgCs5kJ91gPFFRD96ytFDMA1z+1es6OVzm+h92O
 NEisSzsMj7FtvlTa42MN2FkfNmOAO1MR4RSJcsCy+o9rE4BZ4uH6wPKk8WiQyJFgTD/shSFeI
 R4BJ6xxHOAU2kkcI01C1V9nnK8e9yYw4ksgZrFY4QSAoq2gGWecX4XDaRND2c2IRVB3t/dSoi
 LFX+iRt46IbohVPgYlD4nrYnhLwQcvbzdhCA9nsBZBwjs+5MArZnIFaUmKRlqLR0XXQLJCPlS
 gtj1RdcCqqYhVgDNfrBbojzxhNsAHrl7TxuM/z/a042mSpPDg5a5iKdH1BjpDJRv5SX2F9hnf
 Ag+Yh4c/jQ3fvvYgMbz6Em9nJeDbyzYAbOlDyYCbpPbjhviiovvLCvABRQRH7b/ks6VUhzugD
 7fvZiNWK5Xe77N0ELwBcyFxZFAyXAxq21yaWp2thJNH8uPPc1OGPHn3ZQvCnfj91YmamTMYKc
 1OED3xeeg67Zrvk7n66db5svFvrMcte122tgRJPDjzjjMIi8mbGf8WSgaHbvuHUmjsBbpDL4J
 qNkvnrgKzwCHflQyHjLSz7FuDM+Zk1TlSZ9Fv/bQps6X/RY3gygnpuzLY8NISfLfoo9lIzFR0
 IbWI85oJAXALdcqeHdnq+1eNdpjBATMq1jaFRskGmJ06MBTRHvHhCGj7Rg8gsHncZQq6jNouT
 rI3vFwiQSCc2rBVtwDz+KHLBm9Q5n4eV3A/x8KP7aeY4irn1OiA1kAZ2KkdgokTNBl8cJzDRi
 fpGJO3FAHR0HiyFMKjORwwHRM6vuggzSUcO1ewk0jrFUoO9QCZyNRYgNzfknasevfejljQy05
 x77jZcpb9ebx80ae871hXqSxKjSGjtfqCy9mA/ue11jfpz77WfMFzWPC7pud36meYt0Db1+TZ
 cvFuvgJOWtXgFpswpUEPJe6Iwtw9Q+6VEZHZbWm0fOweHfHT41g/NU4QabZ4zRVtIAPILx2+G
 37gdJzjJQLnYOdh0bB52uvxCeFENztHqRw/2TeVoLw1Beg7gdq4XZcFq/DskI9zSBzpD4O343
 4+vptix8gUPuvc5/QPVEWQn9kTT9uJ6JrntaeXDq73VYxV9HdZ7oni73FoS4Su44btLwdl63q
 8dtEyDlcyvo7Qd5y8aHeQLYKVKdUS15Y+4WchIFWCfSgRrebOAPGo92g1d41fj0c3GGtk4ukj
 8CFha9OIukfTb2KFaTP3DvXxhOp9uzGnY3a1GHC3aw1qO8sTEm0ezNT0KeQUZCG3HWLw3xBoA
 FxvBMUG5Tl18lqA4L+9A2JPowzn3hUI9ocbYx8JJmtxS5A+WYJwuEFAG/E9QJxRSbkXwKssv7
 o2RHHETGu2dHGR6X5dZtY/iMA4OvYtM9R6///fNqLZIlCrkl5KtE1/qnhnFqoDnY6lUVCFzFL
 zsVQ244sSE3dYUzRuCq7cXWjVPd77ZT638Rle9jf/bp7D6Gr5IMli7TpetugirAZ2pFdnL3xi
 JshA0jyS9UGAvTTguoXgOouFlyCGHPlgvt4CtcIEZDpcE5dA3kuXbVt3riIvA/p2qLwaSRw77
 AZ9ezyrxceDJSaGg2uNhTsMn4UuhO+uZ+VSuVXRp+t9/rtoBq6CV8Ny2hiiZ4x8et1le8spOS
 N8GVM3zUuhOJhgGdukxxJZ0yar0Mo+/ja1eK8e4JydaxRKghf7qR0/q9cp3CpcurtQe3ufpET
 kEBTk3nZyuGcs13a0OVtlQj8v8y35c5UTVjO5+UpUrJXt1554zqT1benpVdqU03X1AZResqM6
 kWYEz8FH9eASEM3yHhZKDxrvDxNTcvH7TAxW6vOSiMqW+Su4/+0CVasp9sCxcDdcs7VJPoOTn
 iUmpzWKeGfpeg6F5aKjKr4lRLKSIkcwv2AjfmkQhrJF2lQESgEpqPc610ih2KdKA0uLHcYnGf
 /AEy/CPIAoZGXTfLaDKpQn91ueh5Kl4IwvuMtIzq9Ygq9e/1fGsuP+JcBH/4xoQZhVFd9mqI4
 qKkwPSpbGhNZfYEFjEHzEFbJfY9V4IFx9JFTg9d7fMWau/4VWsyE8GMGa9wSeEI9nX5Y90c/G
 0ntgpn7JiYx2JCecprJyCiQipKPby52OGFOjkoJopGgMZMQgX5DLrQO9IQuxgfhmnfOIdn7Oi
 HVAVeQKevgj/uJKKynkoOfkNZX27m6gTKQk0GTUVmoU7macathhhiTXUIExlXApMb+0COYLmx
 lfP2QcZkPCMXCMfuu9jZowP0XoNjV0r+rattcYppevZk1Nt7L35GzbKV0ZfHYznhaq4xtETwU
 95nxTypKFYRPzlsDMsLs+/N+/rK7Y63FzR92AzdtQDCWrKf5lJ95wMFoNb+NSSUf9SR8ZQHgY
 rvcOs2rnKcQzpi8vBJXe7iHFkfrLdQ4YDQz4cHks8om5pojOmhb2za71yxK6pBxkCrBYr53f/
 ARCac8lJKTvTPX8mOXgOEebuLTaBMfKhONVEdGxZvgVKQTNp2lxBseGsvBJVS2VTWu9U50W7l
 su4Q149Onhvw1mg82xG8t8VwGYyxRV6SK6YRp/qx/bXju26KidjOTvF7ntpyHX267c5qPlQEF
 Tjlm4pOsw0AkQZdVSIiUBkWsWfH2EXZRBzBzStS1yISP29mUtH7MhOgONRd/fjNFP2rqgLpZ/
 PWB4MIWQGT1Cc1cYAVQIF3C6eVtP57MRvmkypJXjcij+oVk=



=E5=9C=A8 2026/10/5 22:43, fdmanana@kernel.org =E5=86=99=E9=81=93:
> From: Filipe Manana <fdmanana@suse.com>
>=20
> Fix a bug during log replay (regardless if quotas are enabled or not) an=
d
> a cleanup.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

>=20
> Filipe Manana (2):
>    btrfs: fix lost error return value in btrfs_alloc_logged_file_extent(=
)
>    btrfs: qgroup: make btrfs_record_squota_delta() return void
>=20
>   fs/btrfs/extent-tree.c | 11 ++++-------
>   fs/btrfs/qgroup.c      | 14 +++++---------
>   fs/btrfs/qgroup.h      |  4 ++--
>   3 files changed, 11 insertions(+), 18 deletions(-)
>=20

