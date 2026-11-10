Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.17.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794346734;
	b=am2Dz+B7ntAOqhcYXCYdwlWu6dfh1h7Vr7xmN7h3J8nVSKdl1rO+m1d0coWtfLS6wfy+
	 H32wh5btFrUSyElUI00VgCJAUnNdcfuWX6rqY724QlUg1OyUe6JGuIeiCaW6g/fUqnJF6
	 zmRysw5MidO9Hk5dz1V9Am7VJAjUQmh9rFiQpr3V9Yc4NTnxBRcP5FyzKwaWD+91Qkf0j
	 U55oOg1aKsg3vAC7I1qGYJ7U5SbMo2+CXwCUio0OyhkrWzpUctvQVjw4ddSzkLEUqJM0W
	 vU4MS7PQjCKbwV4IRA7CUOQDZZmwzyOZI05Spt7k4C7nL6lOCbmlXdAK2agQbHBkY+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794346734;
	h=DMARC-Filter:DKIM-Signature:X-UI-Sender-Class:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:References:Content-Language:
	 From:Autocrypt:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Provags-ID:X-Spam-Flag:UI-OutboundReport;
	bh=IRMzuD0W0HfcJPD89NOJ2g+9/qYgDDTdGVylgfuA6Hg=;
	b=xA2PVYcjZWfmJCPJXWjDBACGd59IkojZR/pRB0qEe5lSSeVdW9Z+xVFtLNWOlqn2bd00
	 Ow3oCFSVWJGqlikk57/6qbVMcfXjloK+iWezu7X5/JG/fixQeaQ8E4QJMC0StleidqKvr
	 kupJkGAzylpETc7v7Qnh63Dxam+I061J+sAdB/mIxeXxT8Dqp6ZN7qMZsEfTY4hlht2UO
	 jCq3coSXIhXGZTX4YzlDoA8a6MTT+ID80rHbl1mz6wSSbixley7AdreYn2iBFDoiuS9UW
	 2OFVI/RSFPw9iWwqeW6oPu75/pLj1lFg8COYsXvM+RiffGAv8A6gYtfPZNZofIXMS9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=EwK3i9PR;
	arc=none smtp.remote-ip=212.227.17.21
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D3A606A31C
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 21:38:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 97D3A606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=EwK3i9PR
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1794346730; x=1794951530; i=quwenruo.btrfs@gmx.com;
	bh=IRMzuD0W0HfcJPD89NOJ2g+9/qYgDDTdGVylgfuA6Hg=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=EwK3i9PR/b052Chj+Pa3m1HAqcI4v6JA3pFTu/BPnws8+cccNkSYYXiJSRC88+eq
	 JZnC5YUuLtaxpLN+t8E9IQ1GuqVpkLkEvfCI+xuzrYdvfVKtOw5nkVxduZZazKjU2
	 2wxX6rR4tp5bXUkeGXSdo5k8hdRl4YfTc0p418B/Bd+i3xhZXPZPnYrZq9g1qZRWe
	 Yf2OJippehJ+N+TA6dDRvAantopAiWMD/F2QEb5M//9NfTKPVBP6rfKKPWKfozUCM
	 gdXWRRjUJqhj8FSBgdRsQS6Sx4GOP8I9I2wiu3YH1tQ9xLyxCngqdXHNIMTW4kTYs
	 aJDlNjhnGNiKXbL1hg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MVeI8-1x1h9i0lNM-00OVk9; Tue, 10
 Nov 2026 22:38:50 +0100
Message-ID: <18b6b846-6af3-4c77-ad3e-4f203dc86fea@gmx.com>
Date: Wed, 11 Nov 2026 08:08:48 +1030
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
Subject: Re: [PATCH v3] btrfs: drop the link count of a subvolume inode when
 deleting the subvolume
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <de103b6af03cec8d98b21e0734fb482f9244bed6.1793988522.git.fdmanana@suse.com>
 <1b1749d57e2b5be1c47b04937f5d7b9e2546c178.1793994629.git.fdmanana@suse.com>
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
In-Reply-To: <1b1749d57e2b5be1c47b04937f5d7b9e2546c178.1793994629.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:UWnyJRDPBcr9md4ufVXyOg0LNh053PryfLQmatm+FD7QPdoUEWA
 sMJ8T37BLcZ2eV6G4QsMpa0Zc3etkXVYtNVKxanTUxQJq/7MfRsUam05M09cS4AVV5KnU5g
 BFVunfCC+KFHza+nrzi/K65KkKW5Z4N29j2QqrWZlwJ9VfctyWQlceIwVc7PPn8Np0H7fO9
 Ag0BYy+VhK0UAIr35dMbg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:3nnjZCWhapw=;NRw7YQxABxdRmfgzVDJVcHlp6zP
 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
 TCpNSN9skqAn3/YYkm8ktF98BVfUfMx9o



=E5=9C=A8 2026/11/7 06:27, fdmanana@kernel.org =E5=86=99=E9=81=93:
> From: Filipe Manana <fdmanana@suse.com>
>=20
> When we delete a subvolume we don't drop the link count of the subvolume=
's
> inode. This is harmless in general, however if someone is holding an ope=
n
> file descriptor on the inode while and after the subvolume is deleted, t=
he
> subvolume will still be listed by btrfs-progs.
>=20
> Example reproducer:
>=20
>    $ cat test.sh
>    #!/bin/bash
>=20
>    DEV=3D/dev/sdi
>    MNT=3D/mnt/sdi
>=20
>    mkfs.btrfs -f $DEV
>    mount $DEV $MNT
>=20
>    btrfs subvolume create $MNT/sv
>=20
>    echo "*** Setting up inotify ***"
>    inotifywait -m $MNT/sv &
>    sleep 1
>    echo "*** Setup done ***"
>=20
>    echo "*** Deleting subvolume ***"
>    btrfs subvolume delete $MNT/sv
>    echo "*** Subvolume deleted ***"
>=20
>    echo "*** Sleeping and syncing ***"
>    sleep 30
>    btrfs filesystem sync $MNT
>=20
>    echo "*** Listing subvolumes ***"
>    btrfs subvolume list -d $MNT
>=20
>    echo "*** Killing inotify and syncing ***"
>    kill %1
>    sleep 5
>    btrfs filesystem sync $MNT
>=20
>    echo "*** Listing subvolumes again ***"
>    btrfs subvolume list -d $MNT
>    echo "*** Done ***"
>=20
>    umount $MNT
>=20
> When running this, the first subvolume listing still shows the deleted
> subvolume and inotify does not report the subvolume as deleted:
>=20
>    $ ./test.sh
>    (...)
>    Create subvolume '/mnt/sdi/sv'
>    *** Setting up inotify ***
>    Setting up watches.
>    Watches established.
>    *** Setup done ***
>    *** Deleting subvolume ***
>    Delete subvolume 256 (no-commit): '/mnt/sdi/sv'
>    /mnt/sdi/sv/ OPEN,ISDIR
>    /mnt/sdi/sv/ CLOSE_NOWRITE,CLOSE,ISDIR
>    *** Subvolume deleted ***
>    *** Sleeping and syncing ***
>    *** Listing subvolumes ***
>    ID 256 gen 9 top level 0 path DELETED
>    *** Killing inotify and syncing ***
>    *** Listing subvolumes again ***
>    *** Done ***
>=20
> Fix this by dropping the subvolume's inode link count when we delete a
> subvolume.
>=20
> After this, running the reproducer gives us:
>=20
>    $ ./test.sh
>    (...)
>    Create subvolume '/mnt/sdi/sv'
>    *** Setting up inotify ***
>    Setting up watches.
>    Watches established.
>    *** Setup done ***
>    *** Deleting subvolume ***
>    Delete subvolume 256 (no-commit): '/mnt/sdi/sv'
>    /mnt/sdi/sv/ OPEN,ISDIR
>    /mnt/sdi/sv/ CLOSE_NOWRITE,CLOSE,ISDIR
>    /mnt/sdi/sv/ DELETE_SELF
>    *** Subvolume deleted ***
>    *** Sleeping and syncing ***
>    *** Listing subvolumes ***
>    *** Killing inotify and syncing ***
>    *** Listing subvolumes again ***
>    *** Done ***
>=20
> The subvolume is no longer listed after deleting it while inotifywait is
> running and inotifywait reports the deletion.
>=20
> Reported-by: Alex <linuxkernel+co@alexs.space>
> Link: https://lore.kernel.org/linux-btrfs/18e431317f832f21-26f56778@a-wo=
rkstation/
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Just a nitpick, maybe a dedicated cleanup would help.> ---
>=20
> V3: Address a couple more concerns from shashiko (deal with btrfs_rmdir(=
)
>      case and avoid truncating items during inode eviction).
>=20
> V2: Move the drop link count into btrfs_ioctl_snap_destroy() to address
>      BUG_ON() during rename as pointed by sashiko.
>=20
>   fs/btrfs/inode.c | 9 +++++++++
>   1 file changed, 9 insertions(+)
>=20
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 0bc668c9ec88..b3a123c8d9af 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -4850,6 +4850,7 @@ int btrfs_delete_subvolume(struct btrfs_inode *dir=
, struct dentry *dentry)
>   out_up_write:
>   	up_write(&fs_info->subvol_sem);
>   	if (!ret) {
> +		drop_nlink(inode);
>   		d_invalidate(dentry);
>   		btrfs_prune_dentries(dest);
>   		ASSERT(dest->send_in_progress =3D=3D 0);
> @@ -5609,6 +5610,14 @@ void btrfs_evict_inode(struct inode *inode)
>   	if (is_bad_inode(inode))
>   		goto out;
>  =20
> +	/*
> +	 * For deleted subvolumes we drop the link count to 0 and we don't nee=
d
> +	 * to truncate items in its btree (which is dropped all at once).
> +	 */
> +	if (btrfs_ino(BTRFS_I(inode)) =3D=3D BTRFS_FIRST_FREE_OBJECTID &&

By my first glance, I didn't get the point of such check initially.

It's to check if the inode is a subvolume directory.

It turns out such "!=3D BTRFS_FIRST_FREE_OBJECTID" or "=3D=3D=20
BTRFS_FIRST_TREE_OBJECTID" is utilized quite a lot.

Maybe we can have a dedicated "btrfs_is_inode_subvolume_dir()" helper to=
=20
do it?

Thanks,
Qu

> +	    btrfs_root_refs(&root->root_item) =3D=3D 0)
> +		goto out;
> +
>   	if (test_bit(BTRFS_FS_LOG_RECOVERING, &fs_info->flags))
>   		goto out;
>  =20

