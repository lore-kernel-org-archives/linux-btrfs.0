Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.17.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794346141;
	b=igxZSaL9t06tUtQYv4iVE1EARwrGbr6o3K0kQXh1SgCt7CsrE/LQLx9uaQPRYCcNFt3J
	 FGTV/FZI8RRFXf4WZBWwS+jlooNug7eNpyM3zj/5HS8Q3i+phPqDZGG+yHJteoNwAdHd7
	 qro/HLbt6YhUpKt5SZjNKrB9B8eDIKVwy4sN9JPja55lD1GemCyM0D4ACht/GHyCkoniV
	 gnqZMkuYBXoSw1AFumVzqGcoFrDUwq1jFAI0ySHLBFj5U6j4BUr2KTghHLOBMOn8l1D5K
	 3UeYqJO3aUJ+z82gsqsr0uep6XRBOVrizkkV4Fnau9zdx/YHQHKPMj03gxL7NK6EhIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794346141;
	h=DMARC-Filter:DKIM-Signature:X-UI-Sender-Class:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:References:Content-Language:
	 From:Autocrypt:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Provags-ID:X-Spam-Flag:UI-OutboundReport;
	bh=NUvl7hiI4b5dZteO12bBevb0/hMxismpK1Jgi02YBKM=;
	b=xDPyj/U1BKsrUu6VRDPlyL3EW9PHUYNzaFwZWgmcYRBaWmU/j/EO7vcDd9BXbjEZSDHM
	 HJyogNAuGlOn0RdnSCvXaimZE2Qu5EJOGzbJAf2Vaj9oAyxzvI/RwehkQbZB9VL2SWElQ
	 Glh1D6wOVcgLiSurMmQ3TVu8flayCieAt/TRLgLp97jdyQ+6cKKQ+gN+Zsct9QajXq/HO
	 cQNWa5Pm7VaBsHoWqvwl82xp4VRBSvG64XXT4Q3B3oY6Yw/S1EgfandukDqZUI7pOfkJs
	 iFcMzplXRUWaFDSauwVn795iKwi0KPdB56fV+AMGFF/iDLJf38mXn/XFh64Hv+Z3F0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b="HdO5IX/P";
	arc=none smtp.remote-ip=212.227.17.21
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17423606A320
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 21:28:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 17423606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=HdO5IX/P
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1794346138; x=1794950938; i=quwenruo.btrfs@gmx.com;
	bh=NUvl7hiI4b5dZteO12bBevb0/hMxismpK1Jgi02YBKM=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=HdO5IX/PxVtqIE03QAQaUeCGEYgu1mSG+VXJBLB/cUjoRjkAZomWhcadbl1tlXbl
	 Nrfd23DH3X/URnsW3G0EcvstggrVXIZ41bAlErqbq8aZRAJqd95Q18ejnOiZs8OA4
	 Vx8o4Ek1uusQvx20NU3e7GsGhHy4+sG4m6xrWlp1wqvuk33wGy6viI+qzOO9lsD8a
	 pxrXteKIVfne6Dt9ZuYumJj2Rvm567ZrDitMyXXQ3xqZERk0+kslQGp08M6iJ1SsP
	 Pozpz+1wSNFWrGbyPHXee82i29PWZXRbPoXlnyiovwZxnt/Gi4XGkdsBdD3GOVQMY
	 EpleqLRlUQJR57OXGA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1M2wKq-1xUBBV1K3A-009toX; Tue, 10
 Nov 2026 22:28:57 +0100
Message-ID: <3371a102-604f-40bb-b7aa-3ad23cf0c3e5@gmx.com>
Date: Wed, 11 Nov 2026 07:58:54 +1030
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
Subject: Re: [PATCH v2] btrfs: fix race between concurrent sync direct IO
 writes
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <9d7367f9498173442964c97ddeae9f1be248e48d.1794338999.git.fdmanana@suse.com>
 <7c0a309c28d95b92a3fb3cbf14e4a80e428edd93.1794340795.git.fdmanana@suse.com>
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
In-Reply-To: <7c0a309c28d95b92a3fb3cbf14e4a80e428edd93.1794340795.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:1nk22WQiFugjQHbEvGqqrFkuhJsHdq6onTNjE2sHGED4rD4MprC
 7Xmx5wA4JdLWbaxHSvjyEHAl+kiXRQZ8h9bNpaFm5NkyVbkyQyhj+oVUuXCEd1BAu7s4oFv
 VOhI5Cfb+voS0eV3ebt8BqSD3rsD5HMo3H23+O8m54/qbdoI0aa5kxE62QDQD/yTqkVwZDa
 uURPBF9/WLEh21sqD/+tw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:tRHIM6f3J/o=;8Qo1G3XEjYYoq5KAltFQLG1zCrV
 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



=E5=9C=A8 2026/11/11 06:31, fdmanana@kernel.org =E5=86=99=E9=81=93:
> From: Filipe Manana <fdmanana@suse.com>
>=20
> If we have a direct IO write within i_size, we lock the inode's vfs lock
> in shared mode, which allows for concurrent direct IO writes within
> different ranges of the file, which is an important optimization for man=
y
> applications such as databases.
>=20
> However if we have a sync direct IO write within i_size, it locks the
> inode in shared mode and then enters fsync through the call to the
> iomap_dio_complete() function from iomap using the shared lock. This
> means that if we have another concurrent direct IO write that locks the
> inode in shared mode and the fsync is in fast mode (the inode flag
> BTRFS_INODE_NEEDS_FULL_SYNC is not set), the fsync does not wait for
> the ordered extent created by the concurrent direct IO write to complete
> before logging its extent map. The fsync code relies on direct IO writes
> to create ordered extents and wait for their IO to finish while holding
> the inode's lock, while the fsync should hold the inode lock in exclusiv=
e
> mode. This means that this race can end up persisting a log tree with
> file extent items that point to extents that were not yet written when
> the log is synced.
>=20
> Fix this by always taking the inode lock in exclusive mode if we have a
> sync write.
>=20
> This issue was identified by Sashiko in the link below, which identifies
> two different races between direct IO writes and fsync. The race fixed
> here is the second case identified by Sashiko in the link below. The fir=
st
> race is already being fixed in a separate patch from Josef.
>=20
> Link: https://sashiko.dev/#/bug/linux-ee047626-2fa7-46d5-b543-861136993f=
c7
> Fixes: 939b656bc8ab ("btrfs: fix corruption after buffer fault in during=
 direct IO append write")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

This is way better than my initial idea to force exclusive inode locks=20
for direct writes.

Thanks,
Qu
> ---
>=20
> V2: Address issue pointed by Sashiko.
>=20
>   fs/btrfs/direct-io.c | 16 ++++++++++++++--
>   1 file changed, 14 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
> index 66debd730e42..dc37ae15b232 100644
> --- a/fs/btrfs/direct-io.c
> +++ b/fs/btrfs/direct-io.c
> @@ -896,9 +896,14 @@ ssize_t btrfs_direct_write(struct kiocb *iocb, stru=
ct iov_iter *from)
>   	 * If the write DIO is within EOF, use a shared lock and also only if
>   	 * security bits will likely not be dropped by file_remove_privs() ca=
lled
>   	 * from btrfs_write_check(). Either will need to be rechecked after t=
he
> -	 * lock was acquired.
> +	 * lock was acquired. Also if this is a sync write we will need to fsy=
nc
> +	 * and therefore we must lock in exclusive mode, otherwise we would ra=
ce
> +	 * with other concurrent DIO writes and the fsync would not wait for
> +	 * their ordered extent to finish IO before logging the new extent map=
s.
>   	 */
> -	if (iocb->ki_pos + iov_iter_count(from) <=3D i_size_read(inode) && IS_=
NOSEC(inode))
> +	if (iocb->ki_pos + iov_iter_count(from) <=3D i_size_read(inode) &&
> +	    IS_NOSEC(inode) &&
> +	    !iocb_is_dsync(iocb))
>   		ilock_flags |=3D BTRFS_ILOCK_SHARED;
>  =20
>   relock:
> @@ -920,6 +925,13 @@ ssize_t btrfs_direct_write(struct kiocb *iocb, stru=
ct iov_iter *from)
>   		goto relock;
>   	}
>  =20
> +	/* Sync writes must use exclusive locking, see the comment above. */
> +	if ((ilock_flags & BTRFS_ILOCK_SHARED) && iocb_is_dsync(iocb)) {
> +		btrfs_inode_unlock(BTRFS_I(inode), ilock_flags);
> +		ilock_flags &=3D ~BTRFS_ILOCK_SHARED;
> +		goto relock;
> +	}
> +
>   	ret =3D generic_write_checks(iocb, from);
>   	if (ret <=3D 0) {
>   		btrfs_inode_unlock(BTRFS_I(inode), ilock_flags);

