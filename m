Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1EB7531602
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2026 22:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791929404; cv=none; b=lls0FAcRdQwTb66jQ0JGP6t9TNy5bSdzprBvWMQ24FMNc69SI/ABTL/ZCmUyukZvYGInyyhKROS3mKk5fRMCumXQn/6OCt5hI7bI8+1BKTQPnWNEHa+fI2vFDVh5xERpzcaUSpUj0IIzw1QpQ5ByYcnYaFHeYRc3hTe0AInXAIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791929404; c=relaxed/simple;
	bh=HLw27MdLKg39KtAHKQ7O3jCugN8eZX90m1HLt9kSsFI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Bsgcw5CS9QJDVBUI7T6nlNd7jKyRbUd5UVHcnTcOWCfuLbl/oThSzUTs+1v5Dti5XnPxHgGpU6Qup+shb6cxxXzEJZFAPYxWQCfJFubaO0PyC7mnOt4ooc6S3JF0kSr1BxHkbuP7mfEGmWEii/VpaLF9Hms4aj2Z7Gb6a87+pWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=UyDVLU50; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="UyDVLU50"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1791929400; x=1792534200; i=quwenruo.btrfs@gmx.com;
	bh=1JDOyvOvqID0kMIcuUAdMnIWDaTM/0XeLXAcL2HmY0o=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=UyDVLU50lsS9ymFdemEoqjaNT3bmsLElYBTYNnIiUuGNsiOoIaDGFqhJnUyFXBxw
	 5uzaMT0BHJ2PIzQ0UmNGjFp8d910l0f4hOD4XC4U6t9/qeG6ruSQfkZDYfkDzevBm
	 TkpZQg4NoTJPTbZnRUlBw4EYZh/CMJpqGq36TQKi3WCF826s11Sd2EVN46mFSvTk2
	 Brp9CXW0NNuZY0aYAFJEfMQJUhWan7+PGwzIkNTMGr0Wtgl2N+NMQH3i7FgM8dzTn
	 2yQakbH5n/tkwcn/Tvvr0o/AiMrOVCKx6MgDorEz1++JWOF6J6C22PmN/MryvhLcX
	 LB8Cuhnymrrz7XH7xA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MVvLB-1x79v842AH-00WdUN; Wed, 14
 Oct 2026 00:10:00 +0200
Message-ID: <202d137f-e267-4206-aa68-1fc7d4225f32@gmx.com>
Date: Wed, 14 Oct 2026 08:39:57 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: defrag: prevent inode truncated to zero from not
 being defragged again
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <a010e1306817aa6aaf248bbdce7fc37ce9147a72.1791910727.git.fdmanana@suse.com>
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
In-Reply-To: <a010e1306817aa6aaf248bbdce7fc37ce9147a72.1791910727.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:QH5b716npAR+Qs4iOYQllTn9GeT9WxI4SHZdez4SH3DqSf7rEiv
 7kHIcvGcQdBWd1NabnGayk28x3Z4hyBl7WxyJ/PP9wYPsfETGDGidcr9+AJDl6y7SWqLYoR
 qWcF18wDSh0DfemgqDpeeCE7nF2IjynOdLa3ay0Q5jgSNjy24ke/eCW7cI8V6uAIo0shlro
 +Ndy2V/+0hFSTwJalNd/A==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:nKXufbNVLOI=;vyw3qvKDNa+idLOZMWcgdDsB2z0
 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
 LaYUvkwESFH+VEJrf5yw=



=E5=9C=A8 2026/10/14 03:29, fdmanana@kernel.org =E5=86=99=E9=81=93:
> From: Filipe Manana <fdmanana@suse.com>
>=20
> If we add an inode to autodefrag and the inode is truncated to an i_size
> of zero before it's picked by autodefrag (run by the cleaner kthread),
> we exit btrfs_run_defrag_inode() leaving the BTRFS_INODE_IN_DEFRAG flag
> set in the inode, which prevents the inode from being auto defragged in
> the future until it's evicted, loaded again and small writes happen to
> it again.
>=20
> Fix this by clearing BTRFS_INODE_IN_DEFRAG before we check if the curren=
t
> offset is at or beyond the inode's i_size.
>=20
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/defrag.c | 11 ++++++++++-
>   1 file changed, 10 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/btrfs/defrag.c b/fs/btrfs/defrag.c
> index 7010d714cfe1..cbc532b49c67 100644
> --- a/fs/btrfs/defrag.c
> +++ b/fs/btrfs/defrag.c
> @@ -242,13 +242,22 @@ static int btrfs_run_defrag_inode(struct btrfs_fs_=
info *fs_info,
>   		goto cleanup;
>   	}
>  =20
> +	/*
> +	 * Clear the flag right away. On the first iteration (cur =3D=3D 0) if=
 the
> +	 * inode happened to have been truncated to 0 after it was added to
> +	 * autodefrag and before we were called, then we need to clear the fla=
g,
> +	 * otherwise if writes are done to the inode we won't be able to add i=
t
> +	 * to autodefrag again (unless the inode is evicted, loaded again, and
> +	 * small writes to it happen again).
> +	 */
> +	clear_bit(BTRFS_INODE_IN_DEFRAG, &inode->runtime_flags);
> +
>   	if (cur >=3D i_size_read(&inode->vfs_inode)) {
>   		iput(&inode->vfs_inode);
>   		goto cleanup;
>   	}
>  =20
>   	/* Do a chunk of defrag */
> -	clear_bit(BTRFS_INODE_IN_DEFRAG, &inode->runtime_flags);
>   	memset(&range, 0, sizeof(range));
>   	range.len =3D (u64)-1;
>   	range.start =3D cur;

