Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A9E53F54A0;
	Thu, 15 Oct 2026 08:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792054399; cv=none; b=KpgikZDB5ZqPhEQUJAmFxxIhJ5tXOfm0pkoeYeF1ZGAe9Kg3iYtL6CxciW0egLOYeZWu7baJ5Gbph4cgv6omjm90N1+YBmLNAcDvGKjiz/aDeQVAyRO2O8eOGdcVnbLqOK12Vz8UjjbuEY97/X+GAKbEZoFvL4BDOeJlrPooyH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792054399; c=relaxed/simple;
	bh=heXjWZJkkEJiW1dPQp0EEFQsO5tDhUkeyO640myRzMs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PWmPFJVZl8rxRkqTDx/VvS8A+NuhPRQA003QKJzfWFyt7mLeY2F0VdepKos3gxKaKX33GAzVRoN635Rao7HFfLdg1QGmDMNDrmGAlFxBAYLftF9viTiGadc2oOKlp+L0mOFdZ6wzTLJ5BPA4CUYTk7SvSeOCg8ZeuI5RftKcSwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=M1gyBp75; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="M1gyBp75"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1792054382; x=1792659182; i=quwenruo.btrfs@gmx.com;
	bh=5YTrH65ax1pTsbkfFSE4zIxCSasv9b7oUqw3tvycgAg=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=M1gyBp75wwWmrflut9iiHoquAOdlMpUjNrmkmMNUqs29/dgb9RYgQU2/MyM0xxN/
	 Q+4ooZytU9ulKD7nn5m53cqZuMh2K32bFax6SX2h2CTMYcUOp9thF6j4as/zJT8p+
	 kTSE9dhvxswZff3b26YLrOHikgc/MhcyQwx5K6UHFVP7tsWeIcVUn1X1rw17i5yiU
	 HPJuFZd2h47vu5CnkJKlWwIIURyHvHWSS0upQiRCl8mBW3OwNT2cKLCDm3UY48162
	 glmRf2thF5+ihufOuHJ7oYHl35hzgdUkx86CSnWTTzv03WsDQuUnblMpCQuD47Khu
	 0BW8+yNmwt1nrlCLkA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MowKc-1wqDNj0Xsc-00oT0L; Thu, 15
 Oct 2026 10:53:01 +0200
Message-ID: <f8b3634e-4219-4544-a008-9f3781e9dce6@gmx.com>
Date: Thu, 15 Oct 2026 19:22:52 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: sysfs: restore NOFS context on early return in
 btrfs_sysfs_add_block_group_type()
To: guolingxing <guolingxing@tju.edu.cn>, David Sterba <dsterba@suse.com>,
 Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20261015065319.3246988-1-guolingxing@tju.edu.cn>
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
In-Reply-To: <20261015065319.3246988-1-guolingxing@tju.edu.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:at6lTIcaIrlGAhip8oxumGogNU3LcCTu7vwxL60gVSbYjGwSz6j
 6cXyokwueIZVarT85KUj5B+me1DTund1GD+qcwLScQslsN/QyexNdvCgBw/EsYVeigzEZue
 rSAsyZKvvVpC5G6F2AUjHWNMAQHHt9YgJVW2EjuKsm6clW9LxF7jY5Gv60KFXadnAhU/1vM
 NAWYbyLTJr/eHKJoE8NYg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:MwP1b9/L0GI=;YkrBJWBS0LyhutpgIDIWhdaggRv
 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
 nJnuoyFIZNZGHOx1+lvIi26CHmjko=



=E5=9C=A8 2026/10/15 17:23, guolingxing =E5=86=99=E9=81=93:
> btrfs_sysfs_add_block_group_type() sets up a NOFS context with
> memalloc_nofs_save() because kobject_add() performs GFP_KERNEL
> allocations deep in its call chain, and the function may be called
> while holding a transaction handle or a lock required for a
> transaction commit, where reclaim could deadlock.
>=20
> Every other return path of this function calls memalloc_nofs_restore()
> except the early return taken when another thread has already created
> the kobject for the same raid index (this can happen when restriping).
> Taking that path leaves PF_MEMALLOC_NOFS set on the calling task, so
> all subsequent memory allocations performed by that task remain
> restricted to the NOFS scope, which may lead to unexpected allocation
> failures or deadlocks later on.
>=20
> Restore the NOFS context before returning from that path.
>=20
> Fixes: 49ea112da0e6 ("btrfs: do not create raid sysfs entries under any =
locks")
> Cc: stable@vger.kernel.org
> Signed-off-by: guolingxing <guolingxing@tju.edu.cn>

Reviewed-by: Qu Wenruo <wqu@suse.com>

> ---
>   fs/btrfs/sysfs.c | 1 +
>   1 file changed, 1 insertion(+)
>=20
> diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
> index 39cb01ee441a..71b1ec6c0643 100644
> --- a/fs/btrfs/sysfs.c
> +++ b/fs/btrfs/sysfs.c
> @@ -1857,6 +1857,7 @@ void btrfs_sysfs_add_block_group_type(struct btrfs=
_block_group *cache)
>   	if (space_info->block_group_kobjs[index]) {
>   		spin_unlock(&space_info->lock);
>   		kobject_put(&rkobj->kobj);
> +		memalloc_nofs_restore(nofs_flag);
>   		return;
>   	} else {
>   		space_info->block_group_kobjs[index] =3D &rkobj->kobj;

