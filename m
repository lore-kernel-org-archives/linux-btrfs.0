Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D0712D9ECB;
	Sun, 11 Oct 2026 23:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791761135; cv=none; b=cumiLvKnTw1HDgicT/ETksYAKS3SMecvcuDinkpoUnhuvTSq+OfTiA83Dkfpd3TrKgRK/0mw/FAk3EH5yKANxilkNs9h2vjdaMctynB796k3JU5cDQPX+MK9QDrRu0knXF/Gc4IxpDNcjMsuzEwbSQeFaNeVu3j1KQIjsA7xmak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791761135; c=relaxed/simple;
	bh=pGHVftalAHwQ/BpDpMCuBqdaxsT8bXXBOjFd7iUOmJE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OoN/5E/C81a7CSJZUOGJQwgYmgOrYq1I2FXcKv+eSYa4hS78EU9hf90+SzTwB8DF09d+S5TuvgwZ/WE5R5/SQftwEm9qapuo25TOU9s/e7C96cjg0b46J5foyazu6vpy7H6PdxH7Qc3qysF3ilxqZ+lAruQmv6+63BF+gjkb7MU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=JwBfINR0; arc=none smtp.client-ip=212.227.15.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="JwBfINR0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1791761131; x=1792365931; i=quwenruo.btrfs@gmx.com;
	bh=FVBWj/6cYmushd7gde+hbQqPNwJgbLT5LPXg6ANzFHg=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=JwBfINR04LYvV/zpwdcC/cRpRvLstK6zFzAmiYaiG7mTf89TTTanb0MsWtB0bhZ7
	 TTVonWFoXvCZw24yX830Jc4bH6iGh9kRMhqQnNQ7OWHnCNBcSWo4Zfod7IdW7umQt
	 UPVuKN+CZYUgR9qy2lLdsdpjUJBRQlUOdq08Ngbx1Ih3AvmYtAGNvcwxmWAWN6mjT
	 jYy/5dLls242540xJ2otxvbQMgOh9AT1CvEE981wPhdn36fd8pdO3ohbJU6CISFHl
	 JkS4G5Nxx0yMnPwLrwPaSMp9t6sG4BJrih01wCHLlMBqOwDQN8ICwq2TG5ql0J0Mu
	 XvFKBroK+BiiZnS6zQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1N4zAs-1wXC1e1G2m-00wUIJ; Mon, 12
 Oct 2026 01:25:30 +0200
Message-ID: <6eaddadc-83a8-491a-b7cf-964a4ea83622@gmx.com>
Date: Mon, 12 Oct 2026 09:55:25 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: fix chattr failing on nodatasum files that have
 the compress flag
To: Hengyu Liang <hengyul@cs.unc.edu>, David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>, Filipe Manana <fdmanana@suse.com>,
 Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261011155815.1563812-1-hengyul@cs.unc.edu>
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
In-Reply-To: <20261011155815.1563812-1-hengyul@cs.unc.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:fuxjY9gvhTCID7BxjfnECU+oxNU/pPg7WpgHtPDegy+i4RYWbFv
 Zm5aGxVMxH1ClmvP9I+KCbhfkHhbIG/EVGM1WUBVr18eytWwWGNtlWSvFbfJkIcrB2K7Wm6
 l0MvhnVnzH/rSMvXYRK3NDt9r38qEaokvqcWVyrQXDo4odGZ/c/FzhsaLXtRfemYJ/2EzmO
 M5TH2roo8gX10dDE3h76Q==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:xNI1Ux3f5Ig=;xYuyoUWPW98H9MsNqHLLaX+3sA8
 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



=E5=9C=A8 2026/10/12 02:28, Hengyu Liang =E5=86=99=E9=81=93:
> Commit cf1afec09e9f ("btrfs: validate properties before setting them")
> made btrfs_set_prop() validate a property before setting it. For the
> compression property, the validation fails with -EINVAL when the inode
> has NODATASUM.
>=20
> However, chattr writes back all the flags it read from the file, and
> btrfs_fileattr_set() sets the compression property whenever the new
> flags include FS_COMPR_FL, even when the compression flags do not
> change. A file created on a filesystem mounted with nodatasum has
> NODATASUM and still inherits the compress flag from its directory. As
> of now, chattr fails on such a file when it changes any other flag.
>=20
> The issue can be reproduced with:
>=20
>      mkfs.btrfs -f /dev/sdb
>      mount -o nodatasum /dev/sdb /mnt
>      mkdir /mnt/dir
>      chattr +c /mnt/dir
>      touch /mnt/dir/file
>      chattr +A /mnt/dir/file
>=20
> Before commit cf1afec09e9f ("btrfs: validate properties before setting
> them"), the last command succeeds.
>=20
> After that commit, it fails with EINVAL.
>=20
> This patch will make btrfs_fileattr_set() leave the compression flags
> and the compression property alone when the call changes neither
> FS_COMPR_FL nor FS_NOCOMP_FL.
>=20
> Fixes: cf1afec09e9f ("btrfs: validate properties before setting them")
> Cc: stable@vger.kernel.org # 7.2+
> Suggested-by: Qu Wenruo <wqu@suse.com>
> Assisted-by: LLM
> Signed-off-by: Hengyu Liang <hengyul@cs.unc.edu>
> ---
> Changelog
> v2:
> - Do not test whether the inode can be compressed. Leave the compression
>    flags and the property alone when the call does not change them, as
>    suggested by Qu Wenruo. Setting the compress flag on a NODATASUM inod=
e
>    still fails with -EINVAL.
>=20
> - In the failing call FS_COMPR_FL is set, because chattr writes back the
>    flags it read. A test for "neither FS_NOCOMP_FL nor FS_COMPR_FL is
>    set" does not catch it and would stop chattr -c from removing the
>    flag, so the check compares the old and the new flags.

Oh, sorry I didn't notice the read-modify-write behavior for the flags.

Great that you find out a way to use the old and new flags to detect if=20
the compress flag is changed.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu
>=20
> - Explain why the call fails.
>=20
> v1:
> https://lore.kernel.org/linux-btrfs/20261010105425.165104-1-hengyul@cs.u=
nc.edu/
>=20
>   fs/btrfs/ioctl.c | 13 +++++++++++++
>   1 file changed, 13 insertions(+)
>=20
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 52aab510aea0..43a945345cbe 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -375,6 +375,19 @@ int btrfs_fileattr_set(struct mnt_idmap *idmap,
>   		}
>   	}
>  =20
> +	/*
> +	 * Callers write back the whole flag set, so only touch the compressio=
n
> +	 * flags and the compression property if FS_COMPR_FL or FS_NOCOMP_FL
> +	 * changes.
> +	 */
> +	if (!((fsflags ^ old_fsflags) & (FS_COMPR_FL | FS_NOCOMP_FL))) {
> +		/* 1 item for the inode */
> +		trans =3D btrfs_start_transaction(root, 1);
> +		if (IS_ERR(trans))
> +			return PTR_ERR(trans);
> +		goto update_flags;
> +	}
> +
>   	/*
>   	 * The COMPRESS flag can only be changed by users, while the NOCOMPRE=
SS
>   	 * flag may be changed automatically if compression code won't make

