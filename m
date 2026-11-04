Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.17.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793832670;
	b=MrhMlkKlk3SiuQ7yLPOhsbDuMzAvan3r3ZD+FP/x8MqiIlVDyJ890bh85iLHQs7xBor2
	 dpMpOpVEKNsn7Wj5Tz9CwfmuJQe7jTbttW6WY/rfDAd2btD2iXDKW0DVJqMmFGN9VNhCp
	 gOuVqZh4TkiWaTE/dfE68VVmJsDK8QZ1E5MkxgeSuWfGmYTR//g2D5PrG1mAM16jhzNu2
	 mANyKaSyN4f+4XI1H4zrLAeOhcaNmDBIoV70lx2WzuBYk1ckfoopYyTznp4eSD3l0w7a6
	 nm75uy9hoIDAc7Ws8tBbRU24Xx7YR2X5jc5di5+P6PNQKBLs8cXdVlSkW9+ijy//ltQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793832670;
	h=DMARC-Filter:DKIM-Signature:X-UI-Sender-Class:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:UI-OutboundReport;
	bh=3pp5pgHFSBMKLq5ggJn6n7pTaGZ6IbOUyeHanZ9IuOc=;
	b=Xs2D/7x6Dr1jdachsz5R2daNp/bbZutidyO2mR5c+e3ZxxKqhe7ssOFuE7Wab5bJ6YhX
	 jj3RgU+J4DO6kgoEUqP+lYGIHLcRfRsLYnaHAm4jrDuNs86VHOBnfjFnhi+yUpk2YPXMJ
	 Y6iBgSAb1yT9PBwF3OSzAp/Mv6u0w31kxLyAnYy+TflYLBiAPOyyDL+F3JtISGsVJ1xYF
	 knrx15yBrCjhiXp9S2eQDb7Lxshx5HsAKu2dDXJWGf0L1PYn1XNWP883Jt2wEg2wyZI4z
	 lXsr3NHW6fdEMSx1u67kSvLzICfI8VkkrqBSC4uTQPOyoTNCohwo4Go2jpW4q2i5AlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=T60K9pv4;
	arc=none smtp.remote-ip=212.227.17.21
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C20606A31B;
	Wed,  4 Nov 2026 22:51:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 03C20606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=T60K9pv4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1793832659; x=1794437459; i=quwenruo.btrfs@gmx.com;
	bh=3pp5pgHFSBMKLq5ggJn6n7pTaGZ6IbOUyeHanZ9IuOc=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=T60K9pv4dHC3x045qKAqqZPtX+oClG5WCPxzFTLQFXMtQZfPU0Zc6BcHpx901Whh
	 bd01LY8TP0ZGqXJB0XfsxBDPn9yAgRoYEjfrBbZrsUxR+pUc0m7NdaEIs590ANXu3
	 u1d3UcxzPHaSgchhFrC9XhOLOpO2pOmuVcIu5b/xblhyCFS+iFgpOnktuKrsB6kfS
	 D9/7rPUkqSGO58esFaJkIAZmZ/u3rS98bq3IVbNpu93JpAOVMHrUGQYk5Xq/GqMu8
	 knSA2r3YK9iuor4EXvu+f49tMtZXkQWs3lcV41PKHxOB+V6iT0LBQmVWAZFnsXuAB
	 wKxSlhJwzZt9W7eG2g==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MwfWU-1wZVk3447u-00sMCU; Wed, 04
 Nov 2026 23:50:59 +0100
Message-ID: <9de049c9-429b-46f8-90e7-02b30d2e91ee@gmx.com>
Date: Thu, 5 Nov 2026 09:20:51 +1030
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
Subject: Re: [PATCH 0/5] btrfs: owner refs and tree blocks
To: Siddharth Mishra <smish149@asu.edu>, dsterba@suse.com
Cc: wqu@suse.com, boris@bur.io, josef@toxicpanda.com, fdmanana@suse.com,
 mason@kernel.org, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261104102323.4090290-1-smish149@asu.edu>
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
In-Reply-To: <20261104102323.4090290-1-smish149@asu.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:maNsUZmJnWmnxFZDT42ZgN4ATr52aern0Znzd80uPwBMREgyWQs
 MgdaxxOWY1/DoS+ccKWzHu5XpyDapCCnNWBQ9VUgBmdkWvMAVIfmT2+nD3aHA48P/vwxvaE
 PoffHpTUt+7lmptIn9bhdBCVc2uy/6bvC1a8ejhakwLq+mQ4xKxlNdhyYju6ZFRveybwS2M
 2sa89xVRh0PTtitMBinPQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:bbgnByWnuXU=;2Srqei53sxgyXB2hPniy56S9Kjd
 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
 dmM=



=E5=9C=A8 2026/11/4 20:53, Siddharth Mishra =E5=86=99=E9=81=93:
> Simple quotas store the owner of a data extent in an inline owner ref.
> Tree blocks never get one: their owner is in the tree block header.
>=20
> Patch 1 fixes btrfs_get_extent_owner_root(), which also looks for an
> owner ref on tree blocks. On a filesystem without skinny-metadata it
> reads the btrfs_tree_block_info as an inline ref and warns on subvolume
> deletion, snapshot writes and balance. The filesystem is valid.
>=20
> Patches 2 and 3 are hardening. The tree-checker rejects refs whose type
> does not match the extent type: inline refs in patch 2 (for example an
> owner ref on a tree block), and keyed refs in the same leaf as their
> extent item in patch 3.
>=20
> Patches 4 and 5 are for btrfs-progs (devel 3737c260) and have the same
> cause: a tree block without skinny-metadata is taken for data. mkfs and
> btrfs check do not count such tree blocks in simple quotas, and
> btrfstune --remove-simple-quota can corrupt their extent items.
>=20
> Found by fuzzing. An AI tool helped with the analysis and the patches.
>=20
> Tested on btrfs for-next df5b88a7914e, KASAN and non-debug kernels:
> - Patch 1: no warning on subvolume deletion, snapshot writes and
>    metadata balance without skinny-metadata; same qgroup numbers.
> - Patches 2 and 3: crafted images with an owner ref on a tree block,
>    and with a keyed tree block ref on a data extent, are refused at
>    read time instead of aborting a transaction later. No valid
>    filesystem was rejected: skinny and non-skinny, 4K nodes, mixed block
>    groups, no quota, qgroups and simple quotas, with reflinks, snapshots=
,
>    balance and scrub, and filesystems from btrfs-convert, mkfs --rootdir
>    and btrfstune -x.
> - fstests btrfs/quick, and the qgroup, balance, snapshot and subvol
>    groups with -O ^skinny-metadata: no new failure.
> - Patches 4 and 5: mkfs -O squota,^skinny-metadata writes the right
>    qgroup counts; btrfstune --remove-simple-quota leaves the tree blocks
>    intact and btrfs check is clean (before: "backpointer mismatch").
>=20
> The crafted images are available on request.
>=20
> Siddharth Mishra (5):
>    btrfs: skip tree blocks in btrfs_get_extent_owner_root()
>    btrfs: tree-checker: reject inline refs not matching the extent type
>    btrfs: tree-checker: reject keyed refs not matching the extent type
>    btrfs-progs: check: count non-skinny tree blocks in simple quotas
>    btrfs-progs: tune: do not remove owner refs from tree blocks

Please, never mixed progs and kernel patches in one series.

Send them out separately.

>=20
>   fs/btrfs/extent-tree.c  |  3 +++
>   fs/btrfs/tree-checker.c | 56 +++++++++++++++++++++++++++++++++++++++--
>   2 files changed, 57 insertions(+), 2 deletions(-)
>=20
>   check/qgroup-verify.c | 5 +++--
>   tune/quota.c          | 4 +++-
>   2 files changed, 6 insertions(+), 3 deletions(-)
>=20
>=20
> base-commit: df5b88a7914e18488908ddf13e14e31ab39f954c

