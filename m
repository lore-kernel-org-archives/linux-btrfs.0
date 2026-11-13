Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.15.15
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794605737;
	b=zpFUYWRXk/LGfYVUlsjA1ntMPIeal/XJNHNs3KNNjwURusqzgbb8U9Nq/2BawH6FfugI
	 yYPh3kWZZ1v7dp01LHwutrK0VBF6Qxtt+lJPfTxd7oU4syVVdOlshpXp6G2MzB7aHCwYa
	 ZzO6HSmkpshaOf794WO1F+0gpesS/zmKPxZ2xhNYvhwsLQlyU+CQV9LET1ozI5fAZPFAO
	 11iRlSww1GwSGwvQ2T5a3i5fwTNOb4w/fbEBMv44oQSF+vd542VR8B595Wvpq3op43WSi
	 xVrs83BBDEK05IxQIS/6uuPaPBbMc/+UtPbPAgjEZyh0fSpoMe4Z88D5N0TEpf5E+2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794605737;
	h=DMARC-Filter:DKIM2-Signature:Message-Instance:DKIM-Signature:
	 X-UI-Sender-Class:Received:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:References:Content-Language:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:
	 UI-OutboundReport;
	bh=n98MjV8Tsg1/86yOAXozOcfFi6r07vPW988VA8whT50=;
	b=kCB/AAYLDGYHYntC0Kni5sb+awuT32mkB5Q4J/wdpp7WfRhWg00gL1bSgMpNn1PVthIE
	 5u6oKjLzK2LodPgK7BBhByn+8sVYnsVzzIzyPNn7piDE9rNxsvu+jdn1pkHmXfoWntJp5
	 8hzRor5SkP2uuGwH4AnuSowhYjhiwo3g8pefU0h/kQR7WszZ9s3wjnU/BMj/8K2x2QTeY
	 JzsujoWFtSCgEeb1xIzMY1ESyWhiD/KFV4XHI9fsaNbddvYiwrm8aXinDuZHPM9b7Otia
	 6W+zTIaMDTgViIiRES4oVpI0g1lkOI42jHTt/ofll/GpXR/I6ZaeSHCRnDUJtA9ju7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=m5cmrP5j;
	arc=none smtp.remote-ip=212.227.15.15
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F00B5606A8B2
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 21:35:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F00B5606A8B2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=m5cmrP5j
DKIM2-Signature:  i=1; m=1; t=1794605733;
 mf=PHF1d2VucnVvLmJ0cmZzQGdteC5jb20+;
 rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
 d=gmx.com;
 s=s31663417:rsa-sha256:QNOtizonU6jqWhEKkVq/EbTZLH+Y
   Yxg3N1HIsp5dKPxT080DzrQH6HWOl/fEL+k4lYPYHDs81urhQORyihIIfNT8DBr7hgaYtbSVnw6
   xLdYoh4wpXy9KtFxyJIZE00SaW84C7eqrzDNZ7WNQYIaGhg7is+7tfxIPXIbnSY10XcX6PC5KZq
   ukdxOIjnVKyZSRQ5MLCmEEuXR9dwuYdNVnG3ROpOFlFXyZZMoIqb40yvQl1NeBPuDVJr4Gxx3cf
   ryFk4oM5rUXnnEJKJ5bl7+RIDnYDpwFj34t/L0qv8gG7/vMBWfVb+hTEGMDOH5KuheA8E9/z8xG
   uNhs22Ya8CRlBw==;
Message-Instance:  m=1;
 h=sha256:
   xJw1zeIHEFgwEZuSBRfAf52rMO/S2QAdkZLu594juVw=:
   oy34r2TDuCU3v3wsRxicW++J2ic3C80GBO+dBS32sD4=,
  sha512:
   SuGXy7xTbTRR0tCzIaPdXEuTTmHrkNsBD6PYpbKPH9nM92EsSeKIjbfO2i1AN4abliWTjLwxeetQ69BOP0kCDw==:
   bANlTa17vBxxjMlyBLZ+gVbQl7vjIZPF/BUsHC2o9EKyTsrwa7MDLeP5VuMXl+yRNAD0AyffGaenZe4/ztjCrw==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1794605733; x=1795210533; i=quwenruo.btrfs@gmx.com;
	bh=n98MjV8Tsg1/86yOAXozOcfFi6r07vPW988VA8whT50=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=m5cmrP5j9DkVTUhhFC35zxX2ZHVJPT3oh/ZIIFAjhEfdP9W/2x+DYp4oyBNqaZnm
	 LiPERRUWEEbMftgS+wO7YGwqgrPFrFWFXPtlE+jLpKh5K5gHhmW0ocPvCVcOAKdmA
	 OYpPWUGLnPRqGh+DVnvKyxTfnHm59CF3IR4q+pFjYA7uDLYxLmsbhQE2kUL19EtcL
	 CyIxaRiLANNW72TErWuhjf4qoRSEL9scWDMXrvzn/E+c9d0UtddtLE3ijqG2OKiOB
	 Gyr4m5qdUzy3bLQrz226uyOtQqEfLs1UHr1VjlWkCAM7X0+zoxrW3t9Yk0gk+3kMg
	 KPUA9qZiL+A9owaPNw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MDhlV-1xHILS12wR-00Gcxw; Fri, 13
 Nov 2026 22:35:33 +0100
Message-ID: <d7ba75fa-9284-4da3-a19c-bf652041558e@gmx.com>
Date: Sat, 14 Nov 2026 08:05:30 +1030
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: abort transaction on failure to update inode after
 hole punching
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <76a5dcd7dd6a05e2790ddb9ee021ad890e88b35c.1794590636.git.fdmanana@suse.com>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCat7o8gUJFKS8
 OQAKCRDCPZHzoSX+qAogB/9C5ErH7KGAGpcLPte3Wcfdt3acCkGAuMpCjqOt8BVw30mX0kmF
 SRo2nODjz8YsYhWR1T8L3ylANAS/IGIJ64idBmObaqGHQn845nXLIvG33LqMsAGXmOJdRgTT
 BnBA+QFCEIZpo7L9Qt1dOQdHSpHT31Ta1kKsbDm582KPVBl6KRcJJBnjudIerOA1/L/zEyDa
 YjIfHIcvuM3Xm8AS00iBpsmc151QgCPljqnSRXBiup9C1oMgVlaROhY1iDam4UIQB6glkHQs
 LZhUmFDNimX5LxfOzi2pFJSjJvPclRZVX7Sq6XhK/OFb6IvswN7i0nUYZMQfuGDNqGn70ic3
 AQImzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYCGwwWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCat7pCgUJFMw7KQAK
 CRDCPZHzoSX+qEjbB/9crFFjips2NKxkt2XUutUIKjBoUlg/xCeFIj8PsTuJePhrV9HzgKsa
 rJgSqo3t78oQWmeaP9WPoDYjfhOkQXEs+G9UwHe/LENm70+Q1jrwY3nlcR3YrkDCJ+EvMZOW
 ackgcOYn46Iri9DN91FbSTszPMnwHi/nf0aeJXicO9krrY5C8mUxv4CSKeKSRg/5BR59uDiy
 9CMRHDtIDnpDWaLOXtUeowCdiC5O/jA571PMFx3Aolc7g4SSyNbYodblCBOdJrh0CVm2LlQW
 3SXrvFpSAw7LMVDgsS8pTRt4A11eTIS7mz0zqafTohXP1wt+575IBHK5ZpThQb+PzSQmxAqa
In-Reply-To: <76a5dcd7dd6a05e2790ddb9ee021ad890e88b35c.1794590636.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:rVmHHhAC2BMTDFFz/yriYpynpZV+w2dPynvgd1XMr4kgxpELV5x
 bLwiy8yxilO8jVTPhr80tawBFwIezozPS5rKkUhXJggIxClgPJyYAU4+QajTKPtPP+DIHjc
 rVPK7kLxc/EW7WQGZd2g8FkTUCyTDSzOan/l8/cdR9y+zWAB00fxYhN1L8D18qFmRVnUs8G
 drNTwAbZ42xuPAcpOBAqw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:newjhiNXC28=;ytiTfXCAtmxDeP2V53GVbBUebJd
 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
 zkvcmAykfw/EilRdpPI7xV/s5QWXV0mt3QP8A==



=E5=9C=A8 2026/11/14 03:54, fdmanana@kernel.org =E5=86=99=E9=81=93:
> From: Filipe Manana <fdmanana@suse.com>
>=20
> If we fail to update the inode we simply release the transaction and don=
't
> abort the transaction. This means the transaction can get committed and =
we
> will not persist important updates to the inode item such as nbytes (whi=
ch
> gets reduced after punching holes) and the timestamps. Fix this by addin=
g
> the missing abort.
>=20
> Link: https://sashiko.dev/#/bug/linux-d8b4cb7a-8dfe-454f-9b19-a67af28b81=
bd
> Fixes: 2aaa66558172 ("Btrfs: add hole punching")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu> ---
>   fs/btrfs/file.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index f568ded02300..83804dc454b8 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -2769,7 +2769,10 @@ static int btrfs_punch_hole(struct file *file, lo=
ff_t offset, loff_t len)
>   	if (update_times)
>   		inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
>   	ret =3D btrfs_update_inode(trans, BTRFS_I(inode));
> -	updated_inode =3D true;
> +	if (ret)
> +		btrfs_abort_transaction(trans, ret);
> +	else
> +		updated_inode =3D true;
>   	btrfs_end_transaction(trans);
>   	btrfs_btree_balance_dirty(fs_info);
>   out:
> @@ -2794,6 +2797,8 @@ static int btrfs_punch_hole(struct file *file, lof=
f_t offset, loff_t len)
>   			int ret2;
>  =20
>   			ret =3D btrfs_update_inode(trans, BTRFS_I(inode));
> +			if (ret)
> +				btrfs_abort_transaction(trans, ret);
>   			ret2 =3D btrfs_end_transaction(trans);
>   			if (!ret)
>   				ret =3D ret2;

