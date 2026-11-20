Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.17.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795206010;
	b=i3LrXVUPypYUc6EmrtfoRkJ9MFpmuQFugGmIAqKKwQL5WBylCDxN8u59dVE9/l3Qqs/C
	 mYSEluq2tj0jqDB3Lf4WvmWuaCwOTgLDtl6zFfFeGvRZSVR0IPQ9LRd4cFbjWfaQ2WimE
	 WP8ynSsYYGrNGfZwwsgPV9m2smldfObvm2RSKs7zGLiCjeWnpzMrn8/KQj/iEbCvOIqv6
	 9+u1SN5dXs6u2u4aG7VdSTPVxVjFpCkVwOrlPqHwP9ljGw1mNKQ0Nbi1rB0xUy9HkK9aJ
	 KezMFbXCLSKRNsRJ4j8+xBAyO5Qvqr+8+Roo1h1pxoGZveOnn8r075p2rrReMEeblrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795206010;
	h=DMARC-Filter:DKIM2-Signature:Message-Instance:DKIM-Signature:
	 X-UI-Sender-Class:Received:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:References:Content-Language:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:
	 UI-OutboundReport;
	bh=imB5xToCXjmHPergET3TVjHmEh4OpM9JGbpbtdHDsOs=;
	b=fLis89eCJhFWj/eZZAIptBkKp9Q0UupEe5lBkxic2ySjhdRGi6+DSjCw6Q+OiWODu2FW
	 kr8ad7e4UTdyY9WWFlbiZWZ7ASret1znKlZGqXDtrJ0bHm6+ZXRnBD55NnXsDON08FpuX
	 Xd2OwOzJuOyg5q977LWv0ps2WVma3ifmvG9xrN9hlfT+9134NXJRVo89FZ8dOzOxV+tBS
	 hNvi87wzTqOxu8bf52bL8l/yuHnZQjORXb/LWCT4IQV+G4pKfRt4khRXpt1IPwxV9ixs1
	 rZj5dywYcB5BljuMUQd+kN+x6XaerXuFUH9355EHMinNZ7j/atdCvnvqs/hKg0zXJeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b="A/pZHrKH";
	arc=none smtp.remote-ip=212.227.17.21
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E4C4606A6D4
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 20:20:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8E4C4606A6D4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=A/pZHrKH
DKIM2-Signature:  i=1; m=1; t=1795206002;
 mf=PHF1d2VucnVvLmJ0cmZzQGdteC5jb20+;
 rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
 d=gmx.com;
 s=s31663417:rsa-sha256:ZYy3j4pLjJcRks5Al1/mjwy7+Lz8
   xggpxGUUNh6XKIzVD9gA+Wf+TxlrdzQbBUXPntZBLeGfbCPvithNY7OYFb27IxZm2BjiOqL42/i
   CEFKEmrH+1cpBsISDbcjSH6LywPk97dkFYeks00BfyaxMZS+pJmHpjG0aMQ2OXqbXe/eDHINo0V
   bFov4PsNdllh9fgLQrLnh6O9CNkbvg8mGh9AkntZygMxC611pTBQCg0g1we7+WrsCeJhEX+XUIw
   B4M7NQbXu4xU/37Nh2UhmJ4Sr1MWETn06pa6LKGXIklvQ4yx2lhwkg1PlWYAj15ndgnvEN34s1M
   djTScNHrQCrUug==;
Message-Instance:  m=1;
 h=sha256:
   ZZDeEZy55vuYztDNfLVNc+OHyzBV3TSPZYcl3zR2xkU=:
   nHjb9kmNH2t8ShAK1p+XCcu0xmhSQE34MkJneNLxnVg=,
  sha512:
   Breb4dpSXD7lk7JMmCrABw9fGcXp7lmlTOOjnXcp6qCxoyZY77LNZKj0Csaf+qduF8+PyG1Q0HPzC/RlnErhcA==:
   L6jIXxUCm9yXNq2uNBw7lFKZ4/mn1pUPfi4VdwI5NAsuEsGHKfd6flyf8Qbps5QPRG8w5DDP5rM2vLNLwbvS3Q==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1795205992; x=1795810792; i=quwenruo.btrfs@gmx.com;
	bh=imB5xToCXjmHPergET3TVjHmEh4OpM9JGbpbtdHDsOs=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=A/pZHrKHMPTqBlZ8YZFDBKlR4Iiq9e5hiFfLweuGFcrm1494xQCgI4Jhw3iMSf0m
	 46bLTJi7WxizmkpdgNMvhyyiYsRW1uajPwACsfrhOwM2UMvDTHRbXVklx6PixiT34
	 n7YX45xdCPT7AqCUWwjIxHKi0HDwDyg3xaY5+ztJhpbSKNXGbun+9WPX7kncJKBCh
	 1lBs3nlrYHGy03FuC8v2n+d32lvxHAhFsIzG1+Taf5Gr3NbnG6F5XW9l3Ur3QE+X8
	 JC57H20y3WFYeUxOkfpWgzYclC5PfUaZPJO4rPjMKsRhXLnOtEPFojcq98LatJ609
	 Gpo/eEuda0nW3gN/5Q==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MgNct-1yC5yR04Eh-00gLjK; Fri, 20
 Nov 2026 21:19:52 +0100
Message-ID: <3633b7ad-253f-41f2-b43a-160cbe80cae8@gmx.com>
Date: Sat, 21 Nov 2026 06:49:50 +1030
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
Subject: Re: [PATCH] btrfs: fix double free of reserved data space on error in
 btrfs_zero_range()
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <09aefee29f14e92778f56805b7b8fe7a539e5a8e.1795009782.git.fdmanana@suse.com>
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
In-Reply-To: <09aefee29f14e92778f56805b7b8fe7a539e5a8e.1795009782.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:dwDJER+o8VucL1gevxf29AgeZj3uqZwjzT2p+j1aXAcyRY0yuaa
 Gkb+oPZnNg7eK033rhaaTEGDlQSG0uI0xLq+kRcIfnGS0UEYhgFmYmJJvBXpPNqUyO6nCHM
 eSNu1dyTt+UmQJF/BELad2C9Hve9ln4DiSog1jHpwOvdL/pCliuSQ1uVDRs9Gu9D+YYPVbd
 LAG60jX+maM4/w3opRyhg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:0Gd2oFDlDTw=;9IKgviCVlUnmH8pP/vt3y7UpXTO
 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
 C4Mn5U5NmiMym1gqWrwNPRqiMFXXt25e3oElQ==



=E5=9C=A8 2026/11/19 00:21, fdmanana@kernel.org =E5=86=99=E9=81=93:
> From: Filipe Manana <fdmanana@suse.com>
>=20
> If we reserved data space ('space_reserved' is set to true) and then got
> an error from btrfs_fallocate_update_isize(), we end up attempting to fr=
ee
> the reserved data space by calling btrfs_free_reserved_data_space(), but
> that is wrong because btrfs_prealloc_file_range() will deal with that, a=
s
> it either consumes the reserved data space in case it succeeds (by doing
> extent allocation) or frees the reserved space if it errors out by calli=
ng
> btrfs_free_reserved_data_space() - that means the second call we do in
> btrfs_zero_range() will either result in an underflow of
> space_info->bytes_may_use (in btrfs_space_info_update_bytes_may_use()) o=
r
> free space reserved by other task.
>=20
> Fix this by always setting 'space_reserved' to false after calling
> btrfs_prealloc_file_range(), as it clears the space reservation both whe=
n
> it succeeds and when it errors out.
>=20
> Fixes: b778cf962d71 ("btrfs: fix bytes_may_use underflow in prealloc err=
or condtition")
> Fixes: 9f13ce743b1b ("Btrfs: fix missing inode i_size update after zero =
range operation")
> Link: https://sashiko.dev/#/bug/linux-c6462d6d-8e2a-45f7-8918-88f8788394=
a4
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/file.c | 10 ++++++----
>   1 file changed, 6 insertions(+), 4 deletions(-)
>=20
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 78af88168f18..ee1e1f90d660 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -3077,11 +3077,13 @@ static int btrfs_zero_range(struct inode *inode,
>   						update_times);
>   		btrfs_unlock_extent(&BTRFS_I(inode)->io_tree, lockstart, lockend,
>   				    &cached_state);
> -		/* btrfs_prealloc_file_range releases reserved space on error */
> -		if (ret) {
> -			space_reserved =3D false;
> +		/*
> +		 * btrfs_prealloc_file_range() releases reserved space both when
> +		 * it succeeds (by allocating extents) and when it errors out.
> +		 */
> +		space_reserved =3D false;
> +		if (ret)
>   			goto out;
> -		}
>   	}
>   	ret =3D btrfs_fallocate_update_isize(inode, offset + len, mode,
>   					   update_times);

