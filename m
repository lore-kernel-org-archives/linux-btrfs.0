Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7885C329C7F
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Apr 2026 21:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775598772; cv=none; b=cVxOC0GWqdsay9cx+ZZpiZnXcQxXbEY4/GKf8J9VCUJol98YJbOAfaIOoSSkjHTBA+PLQVjdL0MopwfNTDoQrlug77eN5TGmGe59RzT9IN7PXxIuvPlcjyhEnvBjzW/0rNxtis5kv8GGMXZ84WTbgdGI2PRhrZf91CvOVLbUWqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775598772; c=relaxed/simple;
	bh=kpHZfG8dg9KpiLZ7zm76jJOnS61Bt2g04bMHxs3IQCM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j2VbE78t9m4XPqeJRN9Jt4rBIN1ck38xlEPXn0j0cFoFgr3++Rvlof2a35WNhoS4e0iiAZR+zPRwHx+Cri8QUpHOPGhwh+OoGxf+NK/juOUyfWJbSN10ZM28ucmFs+RyE43NIoS5AyJNenCPgb9AoSYzh0eHIV+43W6+cye6X9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=d0KBS4+P; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="d0KBS4+P"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1775598768; x=1776203568; i=quwenruo.btrfs@gmx.com;
	bh=kpHZfG8dg9KpiLZ7zm76jJOnS61Bt2g04bMHxs3IQCM=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=d0KBS4+PzgOtgD5vSf3wV9toaVFBZOhPC4CtUvMkBeGKDjMqht8zuM6qtLEfJzvY
	 KrdDro3eRyt+S3uQC9h6WYy23URM+TY/x/fkiTzlXG+PAvklpbqjkQQYmYAN0813z
	 O3H8zIuS+jJifCVfizDiU+YFWLlRgp2dRm96YObGVxKsE371pNciLC7XpI7W/OgTX
	 yMnziOjY8b6r9Yod0ypwgtYjuqK+6Ud03b2iUG0UjPt60SOVO3+1+NL9CULczOU2F
	 e0H/teoU6g+hm0Nu8f9KwTo4SD21GUh1JDBKPCi9t3a9hb41fAN03HU7p/deunJQF
	 lP4SZ9i89VEtYqRTLw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1Mkpap-1vlIeG3L1r-00n88D; Tue, 07
 Apr 2026 23:52:48 +0200
Message-ID: <7c2377be-ceca-44ce-8bcb-e201d142b4f8@gmx.com>
Date: Wed, 8 Apr 2026 07:22:44 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: add BTRFS_IOC_GET_CSUMS ioctl
To: Mark Harmstone <mark@harmstone.com>, Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org
References: <20260320125058.90053-1-mark@harmstone.com>
 <07cf5ebc-ac52-4fd9-82c5-404c0f4d6056@gmx.com>
 <3ad267b6-cc59-495f-b385-9b4b4686a473@gmx.com>
 <39496ce5-74c2-4300-ba39-032edace4cfe@harmstone.com>
 <a1675480-628b-46ba-95c7-f5ee29d6bf14@gmx.com>
 <97ff76b9-5c07-4083-a020-3499ff595460@harmstone.com>
 <e6b4ae42-8b83-487c-92b7-6f91c70e1b6f@gmx.com>
 <20260403224449.GA1806609@zen.localdomain>
 <2bb3df33-a9e0-48fc-bff4-957c7d7cb8eb@gmx.com>
 <a40afd17-bfb6-486d-8632-9663d6cf7ce3@harmstone.com>
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
In-Reply-To: <a40afd17-bfb6-486d-8632-9663d6cf7ce3@harmstone.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:SvfgzV87s2P4PHRDhorK0f/CrDJ33vF6QAwUNJDBr+fUDkJewVM
 smjCx+GCNB9yASB3dkL21IC+RRnsV9A5nAE5Y9nShx86ZkFItXdS2D4Pd+xHE0EYKk/DmVq
 VbJzf+1mvcR9lTbVXFFPurk3QDTfSNpIySHH/uK/Cit8MpW/kblTXObbgI7+MP2qLkCB0EI
 z8OgSVTvq0aDMNOpL0KAA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:/OtI6zGBLBA=;Wp/7qVaL/9BhBtzIgEi89j6nLsM
 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



=E5=9C=A8 2026/4/8 03:43, Mark Harmstone =E5=86=99=E9=81=93:
> I think all three of us are confusing each other a little here.
>=20
> The ioctl answers the question: if I were to read X bytes of data from a=
=20
> file at Y offset and calculated the csums manually, what would the value=
=20
> be? To which the kernel responds either with the values, that the read=
=20
> is guaranteed to return zero and thus we can use the precomputed csum=20
> for the zero sector, or that the value isn't known and userspace has to=
=20
> do it anyway.
>=20
> The value isn't known if it's a nodatasum file or if it's compressed. We=
=20
> store the csums of compressed extents, but crucially it's over the=20
> compressed data. So there's no one-to-one mapping between file blocks=20
> and compressed sectors (by definition, because it's compressed), and=20
> bookending means that it might be data we don't have access to.
>=20
> We absolutely can't give non-root users csums to arbitrary data, that's=
=20
> definitely a security breach.

If getting csums for random logical is a security breach, I do not think=
=20
the new GET_CSUM ioctl is any better.

>=20
> Userspace can already obtain the csums from the disk for a file by using=
=20
> FIEMAP and the tree search ioctl. But I believe the consensus around the=
=20
> tree search ioctl is a) that it's very difficult to use, as you need to=
=20
> know the internals of btrfs,

I completely agree with this part, furthermore due to the layout of csum=
=20
tree, one has to workaround by searching with a much smaller value than=20
the bytenr as the min_key, which means possible unnecessary reads of=20
previous leaves.

Thanks,
Qu

> and b) it requires CAP_SYS_ADMIN, at a time=20
> when containerization and finer-grained access controls means this is=20
> frowned upon.
>=20
> This ioctl is a simpler way of doing the csum lookup, and without=20
> requiring root.
>=20
