Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.17.22
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795468293;
	b=lf3BVPsdnmLB+c9yAestfpDzSbdzWrfm7LY2fXXg/JHIca9NSpU89FQC8HLfmWz0U31m
	 aTuvVH/iTtQ4n6sKbugEsQ8t7vrro/ICdp8RCaAxYad7FS004tGZepODdO6FdFbXztfRS
	 kPkGB6RM9xVow/o6hEosmokgBJ8QbdMJfz+kruoS/vH4u5z3ojvxi/7glrTB3g5J8ORUe
	 ujjE5+hSQmAAn8R0O1Dy2E7BN7Nu88c5Mxjfcqrtj50O+kDAzJMZwAAUkSpu5FszjBgoG
	 B2TeqgUAUHQ55z2mUmlxZ+lzDXliUkNwt/nXZSviKX4MvvAyW3D5HkFjh94akD9KulQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795468293;
	h=DMARC-Filter:DKIM2-Signature:Message-Instance:DKIM-Signature:
	 X-UI-Sender-Class:Received:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:References:Content-Language:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:
	 UI-OutboundReport;
	bh=Uq/A1/blJe6N/GFOy04tKdK86siIO7eLXmvRWdhXpVs=;
	b=d8+p/IX09AuVJg5NlXx3QHSishCmtazP+sdQMN+HIQcHA5vHSQqRXYpSVRU5zbqvzIqZ
	 U2Ee/SIt+zxsZuoVkq9//cNTLTJDjEatYo+el2NkJEaK7fQ5esJjJjvJKPi0YjAELw9Sh
	 tbp2zKNP/Y7rixbvqs+tu7KBqvpqV09Vq3yN7cRP+/BnKkLzS2tDv/SAeyiMDAsxJHEnW
	 HQd3uOePLdPw6XNUPs9W75Uh7OkWMOVMBfukjpyDsO2zxuf93kOl4QNPwUA3/PN6ax5iV
	 ndaO4k/PHjSlWFEzso09g0H0bnXzbVLlcKGZym7a3m9wou5NpE2swlcfb4dtzdqZnjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b="guW/+jGF";
	arc=none smtp.remote-ip=212.227.17.22
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED85606A31E
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 21:11:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5ED85606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=guW/+jGF
DKIM2-Signature:  i=1; m=1; t=1795468290;
 mf=PHF1d2VucnVvLmJ0cmZzQGdteC5jb20+;
 rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
 d=gmx.com;
 s=s31663417:rsa-sha256:BkzDYn/KTeqEteW1VjZYkzElGfOL
   KL8UGsijwCxt2bz7EScLRWW7ax+1PA/eP/qDq5DpUN1VaQGX+s9X2tLUS7lx4yrVaH/++Vs4dF1
   X4T6JoZsPzmnQnDWudkLhuQT2/0nA+ZD1xLikylWLeJogtm1mf8nGBeCb+vJ+GbU1WqdrhUJfmH
   gEh2zOsmYFPU2erAJdAD/8cc49wUmFdcAJ6y3+7Wdjx1hR6bIHjZ+CF4uOPkDbhTMaMkg+wEbfy
   dn4tHYG2eDTF+hKFsEDgXThc+cRdPK6z1Nmp89C5/GnInQlOUlC9bbLO+IZN+vtskGq5mz3QiNo
   ovrDVHp8/EJRWA==;
Message-Instance:  m=1;
 h=sha256:
   jDSCIGsd2RlwcB37mSqjc2K3S6aqx6n2gP9rRFu/Wcg=:
   6eQ/PmD0/Fej47HD2HqN3P0lpoxM8dr5jDuvm/1g4dU=,
  sha512:
   6WDmMyRRsWzrbqGQ8CMVC4JDLT7J2R7TyG9SBN4Ta0A+pI2tv2lHcj3loIM/w63+De+mQVKG68HYScHPM4I83g==:
   WDE5C7HQE8sjmOfOCFwV2BxaFSg1nZCR6rTDlknF6MxRg61JoDWcpabnSBuDJymTFXPJd738CrpPyE+IcRsoSw==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1795468290; x=1796073090; i=quwenruo.btrfs@gmx.com;
	bh=Uq/A1/blJe6N/GFOy04tKdK86siIO7eLXmvRWdhXpVs=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=guW/+jGFBjcmFMyz1Z/nhJS9rjekbqEX2vxi5TwYYRl+NX2oqHh6VE0JNPnugdos
	 wFqRGj+1WRYxYUGWgSL00ZOFw32g6JwzNf15lPoqJHxMHxmviCh3FC07o9b9tggla
	 QS9NAlK6sZInvLtLw/kgcbrcAqbgP6BPHcJe897Y5MJSLEL5IZytui2BTE1DzYxMG
	 GPA/vBrFkNhqsLHnjuqnS1yqhJTScoRo+NtzcXjDvzSK5fhF2UuHMLxPAoG1tUu0/
	 BQAc7bLhvvlQTUwePDPl/SpEASAsF4ynqRPuS89eEDN2Q2c/DSNqKqBPtXKjujAoO
	 wSJYGq+NFJE9cqUDlQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MulmF-1yN9qU23eN-00sXkz; Mon, 23
 Nov 2026 22:11:30 +0100
Message-ID: <f3171746-ab10-4ebb-84bc-38b194f3bdbc@gmx.com>
Date: Tue, 24 Nov 2026 07:41:25 +1030
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
Subject: Re: [PATCH v2] btrfs: fix race between setting attributes and
 writeback with compress attempt
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <1a3e3bed8b8bb64943745a02167b68c3f41d38e0.1795376976.git.fdmanana@suse.com>
 <bd1f1a6c32bc00afea7ba59d8c56056f8c4787d2.1795461404.git.fdmanana@suse.com>
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
In-Reply-To: <bd1f1a6c32bc00afea7ba59d8c56056f8c4787d2.1795461404.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:+xb+6L7XrjkPlcR4syghgApGuVvNhpxpgc/lIHEU1ZKS6qMWrWx
 YwerAGmTtlfl4T9A4cxCX/bklNVbvi+60Jtq0SSuyV4lvyVMXwfONfOa3+vTZa9AJPFRB2H
 zU9iHM6NQR4P08GJYYj7cA9L6+tvVFG14FBDIXq+aOJN9rJs2RBVuJtR7rp12pTdwzh4ZgZ
 D4ICogkN3ShcL1Ne9t/LA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:i6PJ9muoZwA=;lngCnygue2Juu92e27ualBU6Usa
 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
 fmLbVsRFKIN0mdVtxotZINY/RbibRNUZiIQhQ==



=E5=9C=A8 2026/11/24 05:48, fdmanana@kernel.org =E5=86=99=E9=81=93:
> From: Filipe Manana <fdmanana@suse.com>
>=20
> When setting attributes (FS_IOC_SETFLAGS ioctl) we grab the inode's flag=
s
> into a local variable, make changes to the flags in the local variable a=
nd
> then later assing the variable to the inode's flags member. This is all
> done without any locking and therefore can race with a writeback that
> attempts to compress data but falls back to uncompressed write since the
> data is found incompressible, in which cases it sets the flag
> BTRFS_INODE_NOCOMPRESS in the inode, also without any locking - this
> happens in compress_file_range() under the 'mark_incompressible' label.
> This leaves a time window where one task undoes what the other did:
>=20
>    CPU 0 (ioctl)                   CPU 1 (Writeback)
>    -------------                   -----------------
>    btrfs_fileattr_set()
>      inode_flags =3D inode->flags;
>                                    compress_file_range()
>                                      inode->flags |=3D BTRFS_INODE_NOCOM=
PRESS;
>      inode->flags =3D inode_flags;
>=20
> If CPU 0 updates inode->flags after CPU 1, it removes the flag
> BTRFS_INODE_NOCOMPRESS from the inode, wasting CPU cycles on
> incompressible data in the future.
> Butif CPU 1's non-atomic update occurs last, it silently clobbers
> the user's requested file attribute updates (chattr modifications).
>=20
> Fix this by changing the ioctl to lock the inode's mmap semaphore, so
> that no mmap writes can happen in parallel, and flush delalloc existing
> delalloc, so that it can not race with writeback and no delalloc can
> happen until it releases the mmap semaphore - the VFS's inode lock is
> already held at the VFS level.
>=20
> Link: https://sashiko.dev/#/bug/linux-249f973b-6e85-4fe0-80d5-5b42e7be3e=
22
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>=20
> V2: Use a different approach, to lock mmap semaphore and flush writeback
>      so that it eleminates other races too (pointed by Sashiko).
>=20
>   fs/btrfs/ioctl.c | 55 +++++++++++++++++++++++++++++++++++-------------
>   1 file changed, 40 insertions(+), 15 deletions(-)
>=20
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 4271f7a6d48a..3de41987b5f5 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -284,7 +284,7 @@ int btrfs_fileattr_set(const struct mnt_idmap *idmap=
,
>   	struct btrfs_inode *inode =3D BTRFS_I(d_inode(dentry));
>   	struct btrfs_root *root =3D inode->root;
>   	struct btrfs_fs_info *fs_info =3D root->fs_info;
> -	struct btrfs_trans_handle *trans;
> +	struct btrfs_trans_handle *trans =3D NULL;
>   	unsigned int fsflags, old_fsflags;
>   	int ret;
>   	const char *comp =3D NULL;
> @@ -297,15 +297,30 @@ int btrfs_fileattr_set(const struct mnt_idmap *idm=
ap,
>   	if (fileattr_has_fsx(fa))
>   		return -EOPNOTSUPP;
>  =20
> +	/*
> +	 * Lock the inode, flush delalloc and wait for any ordered extents
> +	 * to complete. Otherwise a concurrent writeback could be modifying
> +	 * the inode's flags (such as setting BTRFS_INODE_NOCOMPRESS when
> +	 * dellaloc runs and we find the file's data is incompressible).
> +	 * VFS already locked the inode's lock, so we only lock the mmap lock
> +	 * to avoid races with mmap writes.
> +	 */
> +	btrfs_assert_inode_locked(inode);
> +	down_write(&inode->i_mmap_lock);
> +
> +	ret =3D btrfs_wait_ordered_range(inode, 0, U64_MAX);
> +	if (ret)
> +		goto out;
> +
>   	fsflags =3D btrfs_mask_fsflags_for_type(&inode->vfs_inode, fa->flags)=
;
>   	old_fsflags =3D btrfs_inode_flags_to_fsflags(inode);
>   	ret =3D check_fsflags(old_fsflags, fsflags);
>   	if (ret)
> -		return ret;
> +		goto out;
>  =20
>   	ret =3D check_fsflags_compatible(fs_info, fsflags);
>   	if (ret)
> -		return ret;
> +		goto out;
>  =20
>   	inode_flags =3D inode->flags;
>   	if (fsflags & FS_SYNC_FL)
> @@ -333,8 +348,10 @@ int btrfs_fileattr_set(const struct mnt_idmap *idma=
p,
>   	if (!fa->flags_valid) {
>   		/* 1 item for the inode */
>   		trans =3D btrfs_start_transaction(root, 1);
> -		if (IS_ERR(trans))
> -			return PTR_ERR(trans);
> +		if (IS_ERR(trans)) {
> +			ret =3D PTR_ERR(trans);
> +			goto out;
> +		}
>   		goto update_flags;
>   	}
>  =20
> @@ -383,8 +400,10 @@ int btrfs_fileattr_set(const struct mnt_idmap *idma=
p,
>   	if (!((fsflags ^ old_fsflags) & (FS_COMPR_FL | FS_NOCOMP_FL))) {
>   		/* 1 item for the inode */
>   		trans =3D btrfs_start_transaction(root, 1);
> -		if (IS_ERR(trans))
> -			return PTR_ERR(trans);
> +		if (IS_ERR(trans)) {
> +			ret =3D PTR_ERR(trans);
> +			goto out;
> +		}
>   		goto update_flags;
>   	}
>  =20
> @@ -399,8 +418,10 @@ int btrfs_fileattr_set(const struct mnt_idmap *idma=
p,
>   	} else if (fsflags & FS_COMPR_FL) {
>   		enum btrfs_compression_type comp_type;
>  =20
> -		if (IS_SWAPFILE(&inode->vfs_inode))
> -			return -ETXTBSY;
> +		if (IS_SWAPFILE(&inode->vfs_inode)) {
> +			ret =3D -ETXTBSY;
> +			goto out;
> +		}
>  =20
>   		inode_flags |=3D BTRFS_INODE_COMPRESS;
>   		inode_flags &=3D ~BTRFS_INODE_NOCOMPRESS;
> @@ -431,21 +452,23 @@ int btrfs_fileattr_set(const struct mnt_idmap *idm=
ap,
>   	 * 1 for property
>   	 */
>   	trans =3D btrfs_start_transaction(root, 2);
> -	if (IS_ERR(trans))
> -		return PTR_ERR(trans);
> +	if (IS_ERR(trans)) {
> +		ret =3D PTR_ERR(trans);
> +		goto out;
> +	}
>  =20
>   	if (comp) {
>   		ret =3D btrfs_set_prop(trans, inode, "btrfs.compression",
>   				     comp, strlen(comp), 0);
>   		if (ret)
> -			goto out_end_trans;
> +			goto out;
>   		prop_set =3D true;
>   	} else {
>   		ret =3D btrfs_set_prop(trans, inode, "btrfs.compression", NULL, 0, 0=
);
>   		prop_set =3D (ret =3D=3D 0);
>   		/* If ret =3D=3D -ENODATA ignore and proceed to update inode item. *=
/
>   		if (ret && ret !=3D -ENODATA)
> -			goto out_end_trans;
> +			goto out;
>   	}
>  =20
>   update_flags:
> @@ -462,8 +485,10 @@ int btrfs_fileattr_set(const struct mnt_idmap *idma=
p,
>   	if (unlikely(ret && prop_set))
>   		btrfs_abort_transaction(trans, ret);
>  =20
> - out_end_trans:
> -	btrfs_end_transaction(trans);
> +out:
> +	up_write(&inode->i_mmap_lock);
> +	if (!IS_ERR_OR_NULL(trans))
> +		btrfs_end_transaction(trans);
>   	return ret;
>   }
>  =20

