Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FEE82264A7;
	Sun, 24 May 2026 22:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779661084; cv=none; b=Cr2nJTlpAAf3La+nALfJVUZCViqwN0j/+0HcAY49Id2owwiQdx5dDuAdbp1IWg8wIZoKJCGujFjhNwWzgVj6UWVMhGD5GLMq9Qn95uF4eFrcTqkFehmzd8TcKov24YpU9USA+DTowkZSEaGS3oA6jtkHPnCvlF7IHrW3mqsOvi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779661084; c=relaxed/simple;
	bh=h5Kk5Xi6k1uzkye4mGVHk4vXRJ2FzMJo4ZwJiWjGm1g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VPEc0Jc74T/m6w5par1uFehOlaio/ERc7qcioiwAN0+9l4ZlDlfA6X+A2eLrGzq/HMZDWOe/PoaDYM2oUVSX2jheE0CW5uAI00sRx6Q3OWyoLRZxgt1Xxt4condB9hI1ejwMEz1x202o0HBgBtkWx4AuBt9Qy85vWzU1qL2i90Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=DKjQb7ik; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="DKjQb7ik"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1779661077; x=1780265877; i=quwenruo.btrfs@gmx.com;
	bh=h5Kk5Xi6k1uzkye4mGVHk4vXRJ2FzMJo4ZwJiWjGm1g=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=DKjQb7ik134sI95SCNpptv5QFofgjWd+MKi/222LXjHhNGHZBoTOyzt/CcU+BHtv
	 kMIMfFZlQBl7q7qbQ6BmqpmC2GgD810/RBgwjUraBifkwEZWu1SDzW7udeCdmMT4L
	 KTwXdpYxnUsixPK+lRABxkOVyZyX4hq1qH2Ki5wygmIG2X8ej6AK2Sve6sSZj4TjE
	 Rm4+5iMuqHFCnuTuSh7/hkOo9hiQEW3vbo1nyP2Fx8unnfDluNBYzC+w4c0sQK0Fq
	 ptyDVvEUPv9p3X7b6HCjZpXc2mZbHxY9f/4+W/kL2RgrWTBfmES+Wy52oOcm2DCdY
	 Ge3hCo6btAVH1zQacw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MOzOm-1whgUq2FkC-00Xsee; Mon, 25
 May 2026 00:17:57 +0200
Message-ID: <12c0106a-c626-444d-a403-51d83808a30b@gmx.com>
Date: Mon, 25 May 2026 07:47:52 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] btrfs: dev-replace finishing commit error reaches WARN_ON
 and panic_on_warn
To: Yifei Chu <yifeichu24@gmail.com>, linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 linux-kernel@vger.kernel.org
References: <CAPJnbgKVuBQCLSTgYUO1kir1ibBp_=ap==OoE6xbikBjn_S_3Q@mail.gmail.com>
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
In-Reply-To: <CAPJnbgKVuBQCLSTgYUO1kir1ibBp_=ap==OoE6xbikBjn_S_3Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:g5XRGaXINmGumcvJ+emj0Sz8PtuUp0iz4hAEz3g/nrkseACU8nq
 UG1gFT2hS9vbI9ztwpzVNv7u51QoT8CpPrPvHyeslg2AM3k0F4VO5GoJidNiZUPqhAYAuvL
 wkgzeW+UlRWxCGlcv5Q52/eupAT9UDck5rNRKfyZiWqj/2ezBkodI2/QoJ/Zjgy4Wi4/mZ2
 JfvUkUicmPiQZ829O6Umg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:FBHstUblhlY=;GZuTkW9MwoEwIdYBwbw9LAKyCL8
 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



=E5=9C=A8 2026/5/25 00:45, Yifei Chu =E5=86=99=E9=81=93:
> Hello,
>=20
> Short version: I am reporting a second Btrfs dev-replace error-path bug=
=20
> found with targeted fault injection, this time in the finishing path.=20
> The injected -EIO is in btrfs_commit_transaction()=E2=80=99s normal erro=
r-return=20
> domain, and the injection is placed at the transaction-commit return=20
> boundary. With that rare commit failure made deterministic,=20
> btrfs_dev_replace_finishing() reaches WARN_ON(ret); with panic_on_warn=
=3D1=20
> this panics the kernel.
>=20
> Tested kernel:
>=20
> v7.1-rc4-640-g79bd2dded182-dirty
> commit base 79bd2dded182b1d458b18e62684b7f82ffc682e5
> x86_64 QEMU, KASAN config
>=20
> Reproducer shape:
>=20
> The initramfs source mounts a single-device Btrfs image on /dev/vda and=
=20
> starts device replace from source devid 1 to an empty target device /=20
> dev/vdb. The validation patch forces the commit in=20
> btrfs_dev_replace_finishing() to return -EIO.
>=20
> The point of the injection is not arbitrary state corruption. It makes a=
=20
> valid transaction-commit error deterministic at this caller, so the=20
> finishing path=E2=80=99s error handling can be tested.
>=20
> I reproduced this twice under targeted fault injection. The signature is=
:
>=20
> BTRFS info (device vda): dev_replace from /dev/vda (devid 1) to /dev/vdb=
=20
> started
> BTRFS error (device vda): AGENT_BTRFS_DEV_REPLACE_FINISH: forcing finish=
=20
> commit EIO
> WARNING: fs/btrfs/dev-replace.c:912 at=20
> btrfs_dev_replace_finishing+0x295/0x13a0
> RIP: 0010:btrfs_dev_replace_finishing+0x295/0x13a0
> Kernel panic - not syncing: kernel: panic_on_warn set =E2=80=A6
>=20
> This looks related in theme to the dev-replace start-path error=20
> handling, but it is a separate callsite and a different state surface:=
=20
> the commit happens after scrub returns and before mapping-tree/device-=
=20
> list updates. I did not find a direct current-upstream fix for this=20
> finishing-phase WARN_ON(ret) site in my local duplicate sweep.
>=20
> Expected behavior:
>=20
> The commit error should be propagated and the replace state should be=20
> left consistent, rather than treating the error as a warning-only=20
> invariant. A real fix likely needs to audit target/source device=20
> lifetime and replace state around this finishing path.
>=20
> The attached tarball includes README.md, repro_init.c,=20
> positive_instrumentation.diff, QEMU args/results, and both full serial l=
ogs.

Your attachment looks very malicious.

Firstly the tar.gz is way larger than the only file inside the tar.gz.

Secondly the only file inside that archive is a hidden file, named=20
"._btrfs_dev_replace_finishing_commit_warn_panic_20260523".

The file is hidden is already suspicious, and "file" tells me it's a=20
"AppleDouble encoded Macintosh file".

Nothing matches your description.

You have a lot of things to explain.

>=20
> Thanks,
> Chuyifei
>=20

