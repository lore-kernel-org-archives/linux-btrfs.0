Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0EDC418A2C;
	Tue, 14 Jul 2026 21:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784066158; cv=none; b=V+Hi7JzKTS6SLjWluygrrovwZPC47sqyLNac4klBu5B4+XYk+7QWOFhQj1Y83vmP3ZYikEiaeV+SK5bGpAwiP0mGZ872p1YNVB9rucEv2SDGOJ6pi99lO5u4Sh0DTDLflFJYM+mxSPXdny4dhXA0XVLESNx9JckLc+SLvGLcAJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784066158; c=relaxed/simple;
	bh=k20xtO3ct5bdT1SyAkIewBLitv3h3CWImIcVEnBxIfc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kWIKnVxMINAki2hgZl0q7zYZhcH7NkpA3XXK2b81Zmqrba9UmTA1pvvDZyCcQ9RiaaFAZ7Nx/YczlxwYizqIjNaLbdCqX1n6ARNBrpD+BowhikC4R9aJNH4ijhuSyqDdqHOedU6KJSGFm4KkFia3emCWpMEzakaBLYCplp/Wz4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=NHAPXYTm; arc=none smtp.client-ip=212.227.15.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="NHAPXYTm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1784066154; x=1784670954; i=quwenruo.btrfs@gmx.com;
	bh=qAJ4COxUg3qgvs2BDt2+5WCpnoTvGzF72BgbCy549Lc=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=NHAPXYTmwPKIIyGgAuxkjOxP/7nInUcVsb0e7ePVV8x3hF63N+CV0FiPKayF29hb
	 2DiI4JHkcZucbtnGkW751eBdTN3rb8oqzRMgM1zoWX+jVMT2tlA4CxLVo2ACkbbHq
	 u8Ob9nLYvaS0EankmqXqq/1lRKUZmrtRCrt+9EiGJTvssWetvb9qvrnObfrl5xgK7
	 5AEdAhRvuxFInfaMm5K5un6vhvIPstc5XNJURrCnNk2AHvlK2B1jPqOK2zXeGwOXZ
	 BSGkL/PaUy061j73PbLMut3/6FWuN2bVR7FS1CoHh0rA6uJ25iWergVp8X+7V+Uff
	 Nx19LkusycE9XYVIEg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1N0oFz-1ww3Ke20KD-00zpZa; Tue, 14
 Jul 2026 23:55:54 +0200
Message-ID: <c4392627-feb6-4353-bf59-eb152997af72@gmx.com>
Date: Wed, 15 Jul 2026 07:25:49 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] fs/btrfs: KASAN "args" initialization gripe in
 btrfs_ioctl_get_csums()
To: paulmck@kernel.org, Boris Burkov <boris@bur.io>, Chris Mason
 <clm@fb.com>, David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <b2c3772b-f4f1-41a1-8fc2-468c4ac896e8@paulmck-laptop>
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
In-Reply-To: <b2c3772b-f4f1-41a1-8fc2-468c4ac896e8@paulmck-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:ZrxHyGyaM0XiNdNB5X6x3u/txUQpnK66/skhFeU89R2pgzZmDU9
 5edIISHns3NNy9+7/bejmGXuQsH2carxVuZaeZIW6BJv54HmcqE6LGLMk0ubVj647WOXt4C
 ENTuCRHXneXvOILjbbbhnEdsNwnBOlw7942aFQNnCo8vnvGQ/257WqpMPl0GsJcuBEHVJmM
 l/LRKR/OlDHcjtwukpz7w==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:yR3st3UGveo=;X+FnGkCWNeVecFJGmtfd5tdqA5R
 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



=E5=9C=A8 2026/7/15 06:02, Paul E. McKenney =E5=86=99=E9=81=93:
> Hello!
>=20
> This should be considered at least as much a bug report as a fix.  Thoug=
h
> this "fix" does make KASAN happy, so there is that.  ;-)
>=20
> The following compiler diagnostic appears when building with KASAN on AR=
M:
>=20
> In file included from ./include/asm-generic/rwonce.h:26,
>                   from ./arch/arm64/include/asm/rwonce.h:81,
>                   from ./include/linux/compiler.h:369,
>                   from ./include/linux/array_size.h:5,
>                   from ./include/linux/kernel.h:16,
>                   from fs/btrfs/ioctl.c:6:
> In function =E2=80=98instrument_copy_from_user_before=E2=80=99,
>      inlined from =E2=80=98_inline_copy_from_user=E2=80=99 at ./include/=
linux/uaccess.h:184:2,
>      inlined from =E2=80=98copy_from_user=E2=80=99 at ./include/linux/ua=
ccess.h:222:9,
>      inlined from =E2=80=98btrfs_ioctl_get_csums.isra=E2=80=99 at fs/btr=
fs/ioctl.c:5220:6:
> ./include/linux/kasan-checks.h:38:27: warning: =E2=80=98args=E2=80=99 ma=
y be used uninitialized [-Wmaybe-uninitialized]
>     38 | #define kasan_check_write __kasan_check_write
> ./include/linux/instrumented.h:146:9: note: in expansion of macro =E2=80=
=98kasan_check_write=E2=80=99
>    146 |         kasan_check_write(to, n);
>        |         ^~~~~~~~~~~~~~~~~
> fs/btrfs/ioctl.c: In function =E2=80=98btrfs_ioctl_get_csums.isra=E2=80=
=99:
> ./include/linux/kasan-checks.h:20:6: note: by argument 1 of type =E2=80=
=98const volatile void *=E2=80=99 to =E2=80=98__kasan_check_write=E2=80=99=
 declared here
>     20 | bool __kasan_check_write(const volatile void *p, unsigned int s=
ize);
>        |      ^~~~~~~~~~~~~~~~~~~
> fs/btrfs/ioctl.c:5201:43: note: =E2=80=98args=E2=80=99 declared here
>   5201 |         struct btrfs_ioctl_get_csums_args args;
>        |                                           ^~~~
>=20
> Fix (or at least suppress) this by initializing "args" to "{ 0 }".

This is a little weird, as @args is immediately written with=20
copy_from_user().

So I'd say this may be specific to certain compiler version.
Mind to provide the name and version of the compiler?

But still, initializing the structure to zero makes no harm.

I'll convert the report into a proper commit during merge.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

>=20
> Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
>=20
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 9d47d16394fc56..1e28f1411e20f8 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -5198,7 +5198,7 @@ static int btrfs_ioctl_get_csums(struct file *file=
, void __user *argp)
>   	struct btrfs_inode *inode =3D BTRFS_I(vfs_inode);
>   	struct btrfs_fs_info *fs_info =3D inode->root->fs_info;
>   	struct btrfs_root *root =3D inode->root;
> -	struct btrfs_ioctl_get_csums_args args;
> +	struct btrfs_ioctl_get_csums_args args =3D { 0 };
>   	BTRFS_PATH_AUTO_FREE(path);
>   	const u64 ino =3D btrfs_ino(inode);
>   	const u32 csum_size =3D fs_info->csum_size;
>=20

