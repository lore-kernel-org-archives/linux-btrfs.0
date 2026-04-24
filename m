Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EAAB25FA10
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 22:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777069269; cv=none; b=lxyOLrG2HJDcSdF47I4ImzDwOEDJQFsqd4QKfnzuL96ci1exMeQfEtH25B0kmBWO+NKc2NLl8FgGh9lqKe3I8UuMC9u5ZRX1uSWYzBlYbVu2GE17i74t2FlPp8luED1w3vDSfjKm4ZKJGxWaqs/FbFS/jJFXJSpE4fDkmFvF6hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777069269; c=relaxed/simple;
	bh=bj+s4Uvy6ZFKVhw2p9N4ygkJ6wtuH5BOFXyo3BFZ/Z4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aFmFYaeCBf5mAzYCxwKnuE5e//JHQ8iCfULGtysJJFWBV+D5ek1P1i5DgIi5Hv1aGqLj6E8qOZSNo0an/+nlvGgOQgq1JJEyTBS47CiZFXT6C1OWnh4T9IUYjkXBjmcvdq5PsE78HpihjyW0PgYDMUJ3uo2fZaBo431DUMjtyf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=P4D0hSBY; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="P4D0hSBY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1777069265; x=1777674065; i=quwenruo.btrfs@gmx.com;
	bh=t2FfxMJpk2p7gu63Ui4XoRghwG7qs1iQq00IuUvCf4Y=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=P4D0hSBYW3Tyiz+RS4+E/maSihWBWESslkrFJN0SwnCqjshWC7Y2cDvB5/e/8Agl
	 j80k3g2qFeCXNRmcILk1FLVC1h1wEZp2HZM/0asHgk2ntzJPzh3Iqs8z++CloiRMl
	 Bi1hrB8jzgrEvjiTGNN4yKX7qfHohcQK+HhYhnzpF/X/dYb2CLCcQ0xKuHFOdSoTz
	 chWX6JnBUb6blLYXN20jeJ/JdipE5rzeaWwiSauvgvCdGtRL66842Xf65IhdqfMAR
	 SZbUKCFxuNFXq94mnCC8j7yqDcFWQH4S5TgTmiIHKBoPzzPgvv5TL3VEelMPrQaAL
	 PO6Q+J1VlNbRRGiJgA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MMGRK-1vzHS243p0-00YX3V; Sat, 25
 Apr 2026 00:21:05 +0200
Message-ID: <8bf661bc-2536-4310-a5cc-638b5cd9d25c@gmx.com>
Date: Sat, 25 Apr 2026 07:51:01 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/4] btrfs: cap shrink_delalloc iterations to 128M
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <cover.1775756789.git.boris@bur.io>
 <b990d13d17d8f6eeb341457801fdaabdf123f8e3.1775756790.git.boris@bur.io>
 <54030bf6-56a5-4633-9bc2-0008ca43191e@gmx.com>
 <d916e8e3-0c25-4540-b829-a13ef058c762@gmx.com>
 <20260424201054.GA2801466@zen.localdomain>
 <2dd6a177-b6f5-4c15-976b-7897c6d468dc@gmx.com>
 <20260424221059.GA2970690@zen.localdomain>
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
In-Reply-To: <20260424221059.GA2970690@zen.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:AP20nPnwDGa9W7j0jXa3isFc4WG60CcrsP/OKsapRdB2ZeOeyno
 Utw5f0jBA2H0Dh/owE4oEFQ2QdXg60fTks+sLFAIPUU6iyjxlQWgJYYm5t8c0Z4zAzT4z9k
 MvH4q+et4RhaWnDVAqSaGeSJk9XnZR64VPuldJxmLmHOQ8e6iO/2linZ0ZWoNV7ieQSNyPm
 9e+5qXHg6yCGU8xCRYpVw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:T0YApszNTL4=;VoevCUtd17sUUHG229dmvjKg6Tp
 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



=E5=9C=A8 2026/4/25 07:40, Boris Burkov =E5=86=99=E9=81=93:
> On Sat, Apr 25, 2026 at 07:36:49AM +0930, Qu Wenruo wrote:
[...]
>> At least we got something that both of us can reproduce.
>>
>> Another thing is, for g/027 on arm64 I'm also actively monitoring the C=
PU
>> usage through top.
>>
>> Have you experienced very high (~100%) CPU usage on a kworker during g/=
027?
>>
>=20
> No :(
> As far as I can tell the system is stuck waiting on a commit. I'll keep
> trying to repro your symptom.
>=20
> I'm curious if it goes away for you with Sun's proposed fix, something
> like setting pages to at least 1 after those to min() operations.

I go with the following diff:

diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index e931deb3d013..2c5214b24239 100644
=2D-- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -770,6 +770,9 @@ static void shrink_delalloc(struct btrfs_space_info=20
*space_info,
                 u64 items =3D calc_reclaim_items_nr(fs_info,=20
iter_reclaim) * 2;
                 int async_pages;

+               if (nr_pages =3D=3D 0)
+                       nr_pages =3D 1;
+
                 btrfs_start_delalloc_roots(fs_info, nr_pages, true);

                 /*


It solves the dead looping kworker on arm64, now the it's several=20
different kworkers taking around 5~15% along with 027 itself taking CPU=20
time.

But unfortunately the test case itself still seems not to end any time soo=
n.

I believe the old 3 loops limit is really what makes the difference.
It's ugly, but at least it seems to work.

Thanks,
Qu
