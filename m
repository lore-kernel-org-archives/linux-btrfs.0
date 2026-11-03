Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.15.15
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793686552;
	b=qPZecP7sIt55Ya8E0BdGrbV9KXTKpSfZQ8ZqWqN0vXDuheTXQAl/WwtqwXguwu993t5h
	 7Y2YLByVIYV0b8GCwXpgMAeVKIbyL7c76xwYEe/dHmN4KuDHm1DsuvwP7YlgpSEok9/W8
	 HMUYmuMB2+8wXJq+AAPq7yEIcSzT6BJos5xFzwrwGNULktyT0b1aqhUROrohYILdmwUVW
	 Rs6DRImnDEh01+Bi+rMiOTikkD5AAE1c/VY7nT7952nj1hPiryWVGzzME2EIxiDhN50LL
	 YKIJVDRZEeTq2tapF29UXzb591yBdIx42A1wX+1DiAJN3cyM29eEMv6RZ/BmbgS0Zog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793686552;
	h=DMARC-Filter:DKIM-Signature:X-UI-Sender-Class:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:UI-OutboundReport;
	bh=9Cdhq8tdAIuZP/3Nr5fUMfE65xyWoplzLPf21Jv14k0=;
	b=EhGXi/M94h04U7NkcJ8no2Z5KNEDhs3Xpf8k44FETI7x2q1rrzZfzCJyHB3lTkLstXQs
	 SAnH5nedNvtZUCQKQWPYQeF2Q9R/Wg8HQ/o0YKRtN0j7rkey5+nZSq2wYzITROz3YARe5
	 i/4uZOe5SGEroX2I10Fx1rATMI911TxZzQWmJ/lk1ktKySNws4LDvH4hNEA83cTK0EVTR
	 u9EYpZt6VsEdKScgvBLJ0bxixtcU+L8wsLLiaAk/iwMEmoWyxwDNP3/ht12qrlrKBv4fY
	 lpSCTluFMhmXQCrtjqAVIWl163uRWKnnnliY03wCFU1VsPqfHKrG0GAu4PZ2kjUQs9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=h+QUNakg;
	arc=none smtp.remote-ip=212.227.15.15
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43172606A324;
	Tue,  3 Nov 2026 06:15:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 43172606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=h+QUNakg
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1793686545; x=1794291345; i=quwenruo.btrfs@gmx.com;
	bh=9Cdhq8tdAIuZP/3Nr5fUMfE65xyWoplzLPf21Jv14k0=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=h+QUNakgqAjeytINqo+DasoCKVkMDCTP9+9Ns3VrX+K+/1n6EsSNECagMViZr+rM
	 ELxBcBAoAGPgrCtuh3l2IIWnaJYGhIm9QeXQ6Tae+7i50nKfW53PeDAJbB9RgxcnU
	 smpN4aR5Kw/E9e6UQs3xHn/NlqQ4cjD7CdmT93CQhgYTYfLpap5KuoX5Qo5Zr4e1D
	 3lAkocT+ogB2NARTLFjXMKGIMgszedZL62qUBkj1Svg+EjDgmkiSjJRoyyOUZ30Lz
	 NCmqoDTx5IYwxtDD2t5wnSfI7SPWs5FyanAf6EljTGlJ3P0Tt2cf1djoBGcf+FtHm
	 Zpo/hatm/5kJijB/yA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MSt8W-1wx3z500h4-00M9Ik; Tue, 03
 Nov 2026 07:15:45 +0100
Message-ID: <55887917-f5ef-4932-8081-1ea4986a62bb@gmx.com>
Date: Tue, 3 Nov 2026 16:45:39 +1030
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
Subject: Re: [PATCH v2 1/2] btrfs: tree-checker: validate qgroup status item
To: Siddharth Mishra <smish149@asu.edu>, dsterba@suse.com
Cc: wqu@suse.com, boris@bur.io, mason@kernel.org,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20261103061021.2213691-1-smish149@asu.edu>
 <20261103061021.2213691-2-smish149@asu.edu>
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
In-Reply-To: <20261103061021.2213691-2-smish149@asu.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:PwZdXJqrXxA1hg/y+BWZEbFEKddzDO7/tdsAtT1Sd/ihIesEU7q
 Xvrn1XobegSAn6UM0aUQ9MsvYtP3v9A0R0gqgG3aT9O8rbNGJ0KJxaYD/El9hCUEZhOsb/d
 apqDZx3q2VI/ePqcBIHEvSfTjf/82ITXtbltfLipBwLUunYeW5Rce1EqTS6eIAITQwbJMA/
 uqui45EV+R/TFIs1m/Yxg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:9KWDhrVPFqM=;XVlud7qDvl6YYz981tIP2UUMVAv
 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



=E5=9C=A8 2026/11/3 16:40, Siddharth Mishra =E5=86=99=E9=81=93:
> [BUG]
> An image can have a status item with SIMPLE_MODE and a super block
> without the SIMPLE_QUOTA bit.  On a kernel with CONFIG_BTRFS_ASSERT=3Dy,
> the mount of this image causes a BUG :
>=20
>    assertion failed: btrfs_fs_incompat(fs_info, SIMPLE_QUOTA),
>    in fs/btrfs/qgroup.c:411
>    kernel BUG at fs/btrfs/qgroup.c:411!
>    Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
>    RIP: 0010:btrfs_read_qgroup_config.cold (fs/btrfs/qgroup.c:411)
>    Call Trace:
>     open_ctree (fs/btrfs/disk-io.c:3789)
>     btrfs_get_tree.cold (fs/btrfs/super.c:2133)
>     vfs_get_tree (fs/super.c:1943)
>     fc_mount (fs/namespace.c:1282)
>     path_mount (fs/namespace.c:4337)
>     __x64_sys_mount (fs/namespace.c:4542)
>=20
> Without CONFIG_BTRFS_ASSERT, the mount is successful in simple quota
> mode.  The first data write then adds an owner ref.  The write-time
> tree-checker sees the owner ref without the SIMPLE_QUOTA bit and gives
> a WARN_ON() (tree-checker.c:1782).
>=20
> [CAUSE]
> The super block does not have the SIMPLE_QUOTA bit, but the status item
> has SIMPLE_MODE :
>=20
>    incompat_flags  0x361
>                    ( MIXED_BACKREF |
>                      BIG_METADATA |
>                      EXTENDED_IREF |
>                      SKINNY_METADATA |
>                      NO_HOLES )
>=20
>    item 0 key (0 QGROUP_STATUS 0) itemoff 16243 itemsize 40
>            version 1 generation 12 flags ON|SIMPLE_MODE scan 0
>                                             ^^^^^^^^^^^
>=20
> The tree-checker does not examine the status item.
> btrfs_read_qgroup_config() reads the flags of the status item.  For
> SIMPLE_MODE, it calls qgroup_read_enable_gen().  This function ASSERT()s
> that the SIMPLE_QUOTA bit is set and that the item contains enable_gen.
> Since commit f2363e6fcc79, the kernel does not write SIMPLE_MODE without
> the SIMPLE_QUOTA bit.  Thus only a damaged or crafted image has this
> state.
>=20
> [FIX]
> Add a tree-checker rule for the status item :
> - The item must contain the four members of all versions : version,
>    generation, flags and rescan.
> - With SIMPLE_MODE, the super block must have the SIMPLE_QUOTA bit, and
>    the item must also contain enable_gen.
> If a rule fails, the tree-checker rejects the leaf with -EUCLEAN.  Then
> btrfs_read_roots() cannot read the quota root.  It ignores the error, as
> before, and btrfs mounts the filesystem without quotas.
>=20
> Cc: stable@vger.kernel.org # 6.7+

No fixes means no CC to stable.

I'll drop it at merge time.

Otherwise looks good to me.

Reviewed-by: Qu Wenruo <wqu@suse.com>

> Signed-off-by: Siddharth Mishra <smish149@asu.edu>
> ---
>   fs/btrfs/tree-checker.c | 33 +++++++++++++++++++++++++++++++++
>   1 file changed, 33 insertions(+)
>=20
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index 61ea8f42c..bb86c30a2 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -2083,6 +2083,36 @@ static int check_raid_stripe_extent(const struct =
extent_buffer *leaf,
>   	return 0;
>   }
>  =20
> +static int check_qgroup_status_item(const struct extent_buffer *leaf, i=
nt slot)
> +{
> +	const u32 item_size =3D btrfs_item_size(leaf, slot);
> +	const u32 min_size =3D offsetof(struct btrfs_qgroup_status_item, enabl=
e_gen);
> +	struct btrfs_qgroup_status_item *ptr;
> +
> +	if (unlikely(item_size < min_size)) {
> +		generic_err(leaf, slot,
> +		"invalid qgroup status item size, have %u expect at least %u",
> +			    item_size, min_size);
> +		return -EUCLEAN;
> +	}
> +	ptr =3D btrfs_item_ptr(leaf, slot, struct btrfs_qgroup_status_item);
> +	if (!(btrfs_qgroup_status_flags(leaf, ptr) & BTRFS_QGROUP_STATUS_FLAG_=
SIMPLE_MODE))
> +		return 0;
> +
> +	if (unlikely(!btrfs_fs_incompat(leaf->fs_info, SIMPLE_QUOTA))) {
> +		generic_err(leaf, slot,
> +	"qgroup status item has SIMPLE_MODE but SIMPLE_QUOTA incompat bit unse=
t");
> +		return -EUCLEAN;
> +	}
> +	if (unlikely(item_size < sizeof(*ptr))) {
> +		generic_err(leaf, slot,
> +	"invalid qgroup status item size for simple quota, have %u expect at l=
east %zu",
> +			    item_size, sizeof(*ptr));
> +		return -EUCLEAN;
> +	}
> +	return 0;
> +}
> +
>   static int check_remap_key(const struct extent_buffer *leaf,
>   			   const struct btrfs_key *key, int slot)
>   {
> @@ -2475,6 +2505,9 @@ static enum btrfs_tree_block_status check_leaf_ite=
m(struct extent_buffer *leaf,
>   	case BTRFS_FREE_SPACE_BITMAP_KEY:
>   		ret =3D check_free_space_bitmap(leaf, key, slot, prev_key);
>   		break;
> +	case BTRFS_QGROUP_STATUS_KEY:
> +		ret =3D check_qgroup_status_item(leaf, slot);
> +		break;
>   	case BTRFS_IDENTITY_REMAP_KEY:
>   	case BTRFS_REMAP_KEY:
>   	case BTRFS_REMAP_BACKREF_KEY:

