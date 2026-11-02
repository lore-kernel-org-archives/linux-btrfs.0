Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.15.19
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793653469;
	b=VVKrzWAkHEqXEuaBntEX1ndPw2pgxHzyw08mc2z++al2HwptoJXMdm2YxAHTL1uOWLXS
	 8MP5lrn41Ah1kmvlq7MmkwjFj6coV1//eqK7zgiTRGyr6BKnzPn1ulhhT60GUdPiPuiwU
	 9E3zHTTTPa8eDpJbfAW1m0IKWHoJKrVyUQVsH/RuyGQyxGhyQRzHqZ2Z8laxzldCBsftf
	 dasNwQAC/ZgrLqeXjZf0Mks1Rr/7hQ93th6NmQXh6QcsNI3muWaY/SvF5SRPdSK6dAg6K
	 S9ID74sL3TTkuMAExNXWEzhIQZdd7Dj3Xg14ff+cvQWzDbpFDO/roaC4XytvBA8oMkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793653469;
	h=DMARC-Filter:DKIM-Signature:X-UI-Sender-Class:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:References:Content-Language:
	 From:Autocrypt:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Provags-ID:X-Spam-Flag:UI-OutboundReport;
	bh=RTRMPm6wUcm40OGUdxTqBVDD+4ScIIEeAfAwsEAENnY=;
	b=UoWq2/75ZQuVt212qqFZllZbBEp1z6jGbcR42vNLmxkKXOH8jVHLwSsXMbz01qfUyhHO
	 +oQ4QAruWOCjXJ7990FhxqrK4Odsecv+5Ho9gD7MqZkKvnQNspvv3ij0/21vo5yIvjw7+
	 jNR1MChAGxBJm/LCgNMFrdCN1hwZ1iI6XNqiW6v0221totpKlvrdixhCxvCdKHPyRULfE
	 QbvWoiZRuhRVM8Ul9Da95jGzgtlUQtUNyfTvm5+9qViK4yUbqq9v6rgYnnxfYQrLNwbmd
	 GxzeJW0foj+ZHEkLeMoNHqI7USXmeX1o/YqHg50uGJnxgkx+TpmXN3quyihdi8B0BxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b="D2dmWjX/";
	arc=none smtp.remote-ip=212.227.15.19
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25040606A326
	for <linux-btrfs@vger.kernel.org>; Mon,  2 Nov 2026 21:04:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 25040606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=D2dmWjX/
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1793653466; x=1794258266; i=quwenruo.btrfs@gmx.com;
	bh=RTRMPm6wUcm40OGUdxTqBVDD+4ScIIEeAfAwsEAENnY=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=D2dmWjX/sM30njyfHLgiGkjsUp27qvLoHKOwSEWHC1rBf3zXSri050+SLerFwOEy
	 ug24okVp0PqpWB9mSER9U8tjPVYfukhMWrd7ilQrUDZxlhjliMkD+hHwUHF7COZ4T
	 DVCZL3LNUpa6G7st5tGnsNqdd7M5CWj6s3BKs6JBcug6ZgSxfG7rKsrzC+w2SmujC
	 lYxaQg+Rkl4+YaqZQPMGzGRpIt433LteXZNgT2oYd0b/YZinso2cIEqncDAN+CTDL
	 zD2u9nTXpmgSDy0N049ZcZaf7tnVpZLyjTWY9ShQ8vadi0YSMQgYzJnXUlG8VcO7E
	 sAYNhr8Zw6FARb46qQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MuDc7-1wW9cy1ofV-014rtP; Mon, 02
 Nov 2026 22:04:26 +0100
Message-ID: <d2e4bffb-225e-44f8-8db6-a78edfcdbca9@gmx.com>
Date: Tue, 3 Nov 2026 07:34:21 +1030
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
Subject: Re: [PATCH] btrfs: dont propagate nodatacow mount option on files
 with inherited compression
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <1c729c63075e727042efdeb07df10a70b0ba1a0d.1793647368.git.fdmanana@suse.com>
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
In-Reply-To: <1c729c63075e727042efdeb07df10a70b0ba1a0d.1793647368.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:DCmFakPrkoF0uHrpAX6vZkROh6yKbc4gBUaaTHXjuZ5tKHfCiYv
 MhQ/W/I4+5V/L4lMXN8M9VBP7lXQPG/KJRxGTXOUNDXK4QgxH+ZB6iBsYIvmxpHqqbQOWvw
 WC/yj5NmGN/OQcZ2juPw0EkhKQDoTlF6DNl8nZQ//suceuowcReujKos0oWB+YwK0iNMQ+L
 ZBgUsprxGqRn+HjUaZc0A==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:kytGpijBXAM=;wRGaWyf3FKcGiLq003Fq0zANc06
 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
 0LrYLTQUBXgg=



=E5=9C=A8 2026/11/3 06:25, fdmanana@kernel.org =E5=86=99=E9=81=93:
> From: Filipe Manana <fdmanana@suse.com>
>=20
> If we set the compression property on a directory and the filesystem was
> mounted with the nodatacow option, then when creating a file under that
> directory we get both the compression and nodatacow attributes set on th=
e
> file. These are incompatible attributes as compression requires COW.
>=20
> This has a couple unexpected behaviours:
>=20
> 1) If later a user sets another attribute on the file, like immutability
>     or append writing mode for example, the chattr command will fail wit=
h
>     -EINVAL since we in the setattr callback (btrfs_fileattr_set()) we d=
o
>     some validation, through a call to check_fsflags(), that rejects hav=
ing
>     both the nodatacow and compression flags set.
>=20
>     I.e, doing a simple:
>=20
>       $ chattr +i file
>       /usr/bin/chattr: Invalid argument while setting flags on file
>=20
> 2) The file ends up not being compressed, which is unexpected since the
>     compression attribute set on a directory/file should have precedence
>     over the global nodatacow mount option.
>=20
> Example reproducer:
>=20
>     $ cat test.sh
>     #!/bin/bash
>=20
>     DEV=3D/dev/sdi
>     MNT=3D/mnt/sdi
>=20
>     mkfs.btrfs -f $DEV
>     mount -o nodatacow $DEV $MNT
>=20
>    # Create a directory with the compression attribute, so that all file=
s
>    # created under it inherit the compression attribute.
>    mkdir $MNT/dir
>    chattr +c $MNT/dir
>=20
>    # Now create a file with some data inside the directory.
>    xfs_io -f -c "pwrite 0 128K" $MNT/dir/foo
>=20
>    # Now try to make the file immutable, it should work.
>    chattr +i $MNT/dir/foo
>=20
>    umount $MNT
>=20
>    # Check the file has a compressed extent. It should have since
>    # despite the fs being mounted with nodatacow, the directory has
>    # the compression flag set and so that should take priority and
>    # it's what makes sense.
>    btrfs inspect-internal dump-tree -t 5 $DEV | grep -A 5 'EXTENT_DATA 0=
'
>=20
> Running it:
>=20
>    $ ./test.sh
>    (...)
>    chattr: Invalid argument while setting flags on /mnt/sdi/dir/foo
>          item 11 key (258 EXTENT_DATA 0) itemoff 15529 itemsize 53
>               generation 9 type 1 (regular)
>               extent data disk byte 13631488 nr 131072
>               extent data offset 0 nr 131072 ram 131072
>               extent compression 0 (none)
>               extent encryption 0
>=20
> Fix this by updating btrfs_create_new_inode() to not apply the mount
> options nodatacow and nodatasum on a file that has inherited compression
> from its parent directory.
>=20
> A test case will follow soon for fstests.
>=20
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/inode.c | 19 ++++++++++++++-----
>   1 file changed, 14 insertions(+), 5 deletions(-)
>=20
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index b071ed59a583..95455821ea02 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -6654,11 +6654,20 @@ int btrfs_create_new_inode(struct btrfs_trans_ha=
ndle *trans,
>  =20
>   	btrfs_set_inode_mapping_order(BTRFS_I(inode));
>   	if (S_ISREG(inode->i_mode)) {
> -		if (btrfs_test_opt(fs_info, NODATASUM))
> -			BTRFS_I(inode)->flags |=3D BTRFS_INODE_NODATASUM;
> -		if (btrfs_test_opt(fs_info, NODATACOW))
> -			BTRFS_I(inode)->flags |=3D BTRFS_INODE_NODATACOW |
> -				BTRFS_INODE_NODATASUM;
> +		/*
> +		 * If we inherited compression from the parent directory, it
> +		 * takes precedence to nodatacow/nodatasum and we don't set
> +		 * compression along with nodatacow/nodatasun, otherwise if a
> +		 * user attempts to change some other attribute (say chattr +i),
> +		 * it will fail at -EINVAL.
> +		 */
> +		if (!(BTRFS_I(inode)->flags & BTRFS_INODE_COMPRESS)) {
> +			if (btrfs_test_opt(fs_info, NODATASUM))
> +				BTRFS_I(inode)->flags |=3D BTRFS_INODE_NODATASUM;
> +			if (btrfs_test_opt(fs_info, NODATACOW))
> +				BTRFS_I(inode)->flags |=3D BTRFS_INODE_NODATACOW |
> +					BTRFS_INODE_NODATASUM;
> +		}
>   		btrfs_update_inode_mapping_flags(BTRFS_I(inode));
>   	}
>  =20

