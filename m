Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7840503BC0
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Sep 2026 22:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790376453; cv=none; b=XchiNTe81NC8Rudqu5RLbhrQHoKMrARBZ69LjYGAy81ci9iNRiKJag2JU4IYhGo+KyyGaxd7WWXMnK1UJM2PouWmHx9ABMB6/QVkv1ecCfhIjbipf9p3OGTuKasTj0WiHW4N91kH+hwixJO5Z77vYbFw2nN2Eb/SuhX48aekPcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790376453; c=relaxed/simple;
	bh=ChDzKQzc8onka4Oi5UCNsRdvo54hY65PyDE88df2pEo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Cy91nIHsbouNErqNEUOpWQuCUg32phLnRO27Rj+jHTf3A5VutZk5YwanR4oIvjrUOx1SWsFoVrWbVSHfATZiV81N3CE0Q2UMt3o3E/iRksLg+ufWurwqTUi/kH1H5JI+oVgbHe3tcDyUt69ghCIwdoYpJZHkE6mM/DcqukKYEjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=MyTAxSb/; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="MyTAxSb/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1790376449; x=1790981249; i=quwenruo.btrfs@gmx.com;
	bh=usdQSqDL10hZwpagYundxSo5bThA6VYE6Ttq9MIVr70=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=MyTAxSb/ucJvH6qdB+3IwxD27l7CE/cKVSeuwItXb0gG7TCfklXp2pPi/fZkgku6
	 xUlBRUuSk8xrYJt6NjlVWSwpqdRRnvaoT/XC5/KjtojHqGJzfKgSFnXmyJaPY5rHn
	 CowV14ephKv7GS3IXe1DbG9noGLIyv2AXXLQGGu0tpuTfz66HCHP5uduAFwNBn7ny
	 kb2U7lGl6xWOr9gdXnNp3JedDHGJfB3oIaLO6hj5xjXMVOb0MExMvXPlTUtt+h2eA
	 0OvkvadyJnBgwNpwcHWuoBSVBEIAE2Eb3TgmlPvMzkGjYle/++tlo6n66Nkutoa+M
	 tjyckODJf7DaqXnq2g==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MzhnN-1woI6b1akb-00ul4a; Sat, 26
 Sep 2026 00:47:29 +0200
Message-ID: <72db09ad-7cf8-4d8c-84e8-612344b44d7e@gmx.com>
Date: Sat, 26 Sep 2026 08:17:24 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: fix lost error return value in btrfs_listxattr()
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <3a22684fd6ee950fdd7bf1a6119e87366e9a1de8.1790355229.git.fdmanana@suse.com>
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
In-Reply-To: <3a22684fd6ee950fdd7bf1a6119e87366e9a1de8.1790355229.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:zNsV6s9Crp1VU4DJaNI2INq5nTfaL5rg8uXf9fYnFWCYV3r0nV0
 8QRXgUc1Ffo4Ue9ZZgriHymxOtDskSgd4ILmQtcBPXE+XNumbKGvMfcs5Gk9gkZxDemS3zr
 ssxOFvLQUSWXy3LJGetXMmoQRKuJ0RWuzam8jMW43H6SCrBsyGo/aualQa533CwZmi9zMlS
 iWzqUFzs2Pb+uBHH1UJXg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:fiRyCPMET+8=;w8k3gPxvKctGfLyBjEuzU1guFJA
 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
 bioW



=E5=9C=A8 2026/9/26 02:24, fdmanana@kernel.org =E5=86=99=E9=81=93:
> From: Filipe Manana <fdmanana@suse.com>
>=20
> If we input buffer does not have enough space to store the current xattr=
,
      ^^ the

> we set 'iter_ret' to -ERANGE and then do "break", but that only exists t=
he
> while loop over the xattrs in the current btrfs_dir_item, and then we
> continue the btrfs_for_each_slot() iteration, which overwrites the value
> of 'iter_ret' causing us to lose the error return value and proceed as i=
f
> the buffer has enough space.
>=20
> Fix this by returning -ERANGE directly (the path is automatically freed)
> instead of breaking from the while loop.
>=20
> Fixes: 184b3d190087 ("btrfs: use btrfs_for_each_slot in btrfs_listxattr"=
)
> Assisted-by: LLM (found the bug)
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/xattr.c | 6 ++----
>   1 file changed, 2 insertions(+), 4 deletions(-)
>=20
> diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
> index e8762e12f3e1..cb001a211f55 100644
> --- a/fs/btrfs/xattr.c
> +++ b/fs/btrfs/xattr.c
> @@ -329,10 +329,8 @@ ssize_t btrfs_listxattr(struct dentry *dentry, char=
 *buffer, size_t size)
>   			if (!size)
>   				goto next;
>  =20
> -			if (!buffer || (name_len + 1) > size_left) {
> -			        iter_ret =3D -ERANGE;
> -				break;
> -			}
> +			if (!buffer || (name_len + 1) > size_left)
> +				return -ERANGE;
>  =20
>   			read_extent_buffer(leaf, buffer, name_ptr, name_len);
>   			buffer[name_len] =3D '\0';

