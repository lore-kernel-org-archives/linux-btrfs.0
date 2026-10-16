Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8F235AC10
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Oct 2026 22:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792188973; cv=none; b=XcJjPZO/qN+Et3xZu5xo+5/3lKoQBXcwf796QsOl95nxSx8JYDMhM9kZnNEIGWzJDw+Id1J/Qo/RUxDn6hS7jEgMFShN1iFEGQlQ/ofBlrrc7d59QtuSyYSZjb0erEt5spv7HqK8GLkKbVKZr5ZUSQ0wz99BeRMX0RgJ8FH7KQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792188973; c=relaxed/simple;
	bh=LiIcMNpSp2bqi+Mrgrbb0uq0O+maK6FFR3YF+U/rOz4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Np0O3EpN9sMyQXsft4GL8YEhGCj4JUYPOryTto9iB2SHPxXyTXcBT1EIvcUdXDRBD3h49x+16RJjQbU+U24jAA/GEKl4no2mAXdcXQdgk/BJIWn+iQhZOHX+EmFiDyiBMebFunxQnJ6BAk+BzC5P2AwCpPTjbDlxTICdZPGSse4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=jK4DhvZH; arc=none smtp.client-ip=212.227.15.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="jK4DhvZH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1792188969; x=1792793769; i=quwenruo.btrfs@gmx.com;
	bh=uvzY8tpUEuAAiKgVmyhbIENjNb+Z3QoqyEAWIEbxwMM=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=jK4DhvZHbTdOFug6vH7v4CVJ4L1ShWonWWi2+AoC/ZiFH2nTSReq5PR4lgerDvD0
	 SclAQ1B0liw0wpNXQK/u+Z3ZQPa/1vNefnJ7+8cl9BdJYb3d3BvhdEVhkBpw/gNNE
	 /5o2XCwSoDS64UuqBL2jdVHR+OiXZxZjpT0FCNK8gyJvN5oMrDcPCQzcZcQbonmtQ
	 M3JY6TUJm+KrKUZI8Nt1A1xHLt6abhYsAeEmLllNMG8vYc2CSrmiHRiFK1uKwNYTU
	 AuxcZ+hmVeS3Sx1B1yYTo9/Fvx3kvybh6hBWKTAnqclKsjBZcc5ZWY4iS41Khcr+9
	 2eS0hOhvCKOjMqm98g==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1N7R1T-1wYwpZ2K33-00yqiw; Sat, 17
 Oct 2026 00:16:09 +0200
Message-ID: <9f16b3e1-a55f-4823-98a2-8e4e64410ede@gmx.com>
Date: Sat, 17 Oct 2026 08:46:05 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: scrub: fix race between scrub and scrub progress
 ioctl
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <a2e99c3b10f86144bdae7ea4953dee3b3e69c2aa.1792168588.git.fdmanana@suse.com>
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
In-Reply-To: <a2e99c3b10f86144bdae7ea4953dee3b3e69c2aa.1792168588.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:sBcFyKJBPhwHdlsc/6invrkHGSZiOOKtGkA2P7Z64CEWEa3WuD4
 U9FUTi6qYVK0GYdNict94otLCoE5Xiwu4Tqxb/lOaPqabFJEzEDvEluIZkjmwSj31wJJfht
 Dg4Dglk/apD8e6wA6qcAyonUOc9Bq9qviMrDIHJxPKUAgxz6DcgHvad6MDtsiCSSkfXMd+7
 GuskO7PAP75rFD2wSN7Bg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:HuKEjFQM9z4=;GhEn7gju2F29tkqpcY3VrfzAjw7
 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



=E5=9C=A8 2026/10/17 03:06, fdmanana@kernel.org =E5=86=99=E9=81=93:
> From: Filipe Manana <fdmanana@suse.com>
>=20
> The scrub progress ioctl is copying the scrub progress stats without
> acquiring the spinlock that protects it and a concurrent scrub can be
> updating the stats at the same time which can lead to load tearing
> issues. So take the spinlock when copying the progress stats.
>=20
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/scrub.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index 0eb30625439b..a70a1eeb9ecb 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -3295,8 +3295,11 @@ int btrfs_scrub_progress(struct btrfs_fs_info *fs=
_info, u64 devid,
>   	dev =3D btrfs_find_device(fs_info->fs_devices, &args);
>   	if (dev)
>   		sctx =3D dev->scrub_ctx;
> -	if (sctx)
> +	if (sctx) {
> +		spin_lock(&sctx->stat_lock);
>   		memcpy(progress, &sctx->stat, sizeof(*progress));
> +		spin_unlock(&sctx->stat_lock);
> +	}
>   	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
>  =20
>   	return dev ? (sctx ? 0 : -ENOTCONN) : -ENODEV;

