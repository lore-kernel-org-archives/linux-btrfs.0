Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.15.19
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793686617;
	b=JOuPfoApKfjS9ArAvnZKnKMbiGmlb86y/yRb0UQmUL9104tQO7NLePjlynu1Y//97HyV
	 MUPJxYRH+XKmyj7wIGA16PC6QUAyXXEVDLp9AwuALGZr3YigB3JmYbfnqyNsJdV/bFkw/
	 lpb1grp9371grwONrEsI+05okYprQH6gEwjev+f3r0fXX1j8QPPcuUs9xwdsIiOupWnCw
	 9Ebj4zTnz19PRfI+yNLRVIsoDD2mmy/IS/Isf1kpXdHydBsa87yge/GWFHj7/GyNVUpeZ
	 8cK23k+07bMoW8TqNV4azIlKA2VX3iaB3aLmqrdaGCg4UIiiShRjgkW1wa4sQVtQISw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793686617;
	h=DMARC-Filter:DKIM-Signature:X-UI-Sender-Class:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:UI-OutboundReport;
	bh=fVGWYnrMsa9VkTWLkKU/H0OC69d6euFavzFvTKcVPBQ=;
	b=3/cF/pxJLF715tNNiWZbpEDMMkQoHsSrdNN92J5oa3wF2T8EqGhpMA0VGAuq89M/viiu
	 4lr8ndWtX6Sd57TjBS4ixYuTPetJQlMLLhIYQ+Kcc60FmmyFW5wuVIlQs04JHwZZ8RVAf
	 rewwqyvcd6xt6wGtm7/LI1Ke8gzDFm15thO+zmYHj0WJXi+MNFD0uhO1dbguKv6+2FqLe
	 noWeQTd/d1qlDVrKc5Ka7H3AojsIDM2PkzPpNPB77MJRx+SSpLXtlyHABG06UBa1MUhAh
	 4G6K2VhHy60lpMQO7O3Hm6pV+uBryYNEL4OcHYdu0KXn5weMxB4rbsOkKyNysuKxzig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=aLXpfNM4;
	arc=none smtp.remote-ip=212.227.15.19
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5425D606A330;
	Tue,  3 Nov 2026 06:16:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5425D606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=aLXpfNM4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1793686613; x=1794291413; i=quwenruo.btrfs@gmx.com;
	bh=fVGWYnrMsa9VkTWLkKU/H0OC69d6euFavzFvTKcVPBQ=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=aLXpfNM49DIL7ukOqccVXheLpzEjZSdkPZjFwr3+MWyGLW06rTzw0XsiwZqd/fSm
	 upl63qAaJZgetPevROLbFjyF2/aFjhM+ixpzku2TWiKkCu8pGf25qHYeJa3wccH2Y
	 B8YStY6lwm7zmClmUClXaXNgxRH7CSuxPZEMXHJF9/pDCXXEdTpjFKB4OYVwrddlg
	 UiklXd6x6KCQPyPZy+ro6Mw397kVM3jwHMFPT9aFKaoEaFDp6uHRHjeNlnwDm4oKX
	 c6wsmNLTrT0B3TGN0sR/qaCZOfBLpuIT/tJ7p5bBALZRvp8nEUKj/myv6l2/Nni2g
	 yQmdUv88CjIXtFib/Q==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MCKFk-1xFqMw2xgQ-009OFv; Tue, 03
 Nov 2026 07:16:53 +0100
Message-ID: <b2c34370-3a6d-4864-8093-654288885616@gmx.com>
Date: Tue, 3 Nov 2026 16:46:45 +1030
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
Subject: Re: [PATCH v2 2/2] btrfs: tree-checker: reject extent owner ref
 without simple quota
To: Siddharth Mishra <smish149@asu.edu>, dsterba@suse.com
Cc: wqu@suse.com, boris@bur.io, mason@kernel.org,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20261103061021.2213691-1-smish149@asu.edu>
 <20261103061021.2213691-3-smish149@asu.edu>
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
In-Reply-To: <20261103061021.2213691-3-smish149@asu.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:D4wiOeTqfLYbsf2XmUAIgoLQHei9wsUkzR5iAJozszzIBUZlbge
 MJ51aV1Y0sSGqHwSQhGhrbm8GGw607Vp1j/63PRTmXpnXwT2pf48ZTLEeawYBShZYxCkK+f
 vCTkozd8+w36YHQItLhCOedkvImtEN0THSXFAaQ86aryviAQqDOOp9R/4hZxmC8JMsJ3Okq
 Z5sNI9FU9mBYr79Pk8rSg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:58z++gsKJ7c=;7GaN52uuXFtoarFWRYaeV1MHHFT
 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



=E5=9C=A8 2026/11/3 16:40, Siddharth Mishra =E5=86=99=E9=81=93:
> [BUG]
> An extent item can contain an owner ref.  The owner ref is correct only
> when the super block has the SIMPLE_QUOTA bit.  If the bit is not set,
> check_extent_item() gives a WARN_ON() and then accepts the leaf :
>=20
> 	case BTRFS_EXTENT_OWNER_REF_KEY:
> 		WARN_ON(!btrfs_fs_incompat(fs_info, SIMPLE_QUOTA));
> 		break;
>=20
> For all other incorrect inline refs, check_extent_item() returns
> -EUCLEAN.  After the tree-checker accepts the leaf, a free of the extent
> calls btrfs_get_extent_inline_ref_type().  This function ASSERT()s the
> SIMPLE_QUOTA bit.
>=20
> On a kernel with CONFIG_BTRFS_ASSERT=3Dy, a free of such an extent gives=
 :
>=20
>    WARNING: fs/btrfs/tree-checker.c:1782 at __btrfs_check_leaf
>    assertion failed: btrfs_fs_incompat(fs_info, SIMPLE_QUOTA),
>    in fs/btrfs/extent-tree.c:354
>    kernel BUG at fs/btrfs/extent-tree.c:354!
>    Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
>    RIP: 0010:btrfs_get_extent_inline_ref_type.cold
>    (fs/btrfs/extent-tree.c:354)
>    Call Trace:
>     lookup_inline_extent_backref (fs/btrfs/extent-tree.c:919)
>     lookup_extent_backref (fs/btrfs/extent-tree.c:1100)
>     __btrfs_free_extent.isra.0 (fs/btrfs/extent-tree.c:3319)
>     __btrfs_run_delayed_refs (fs/btrfs/extent-tree.c:2134)
>     btrfs_run_delayed_refs (fs/btrfs/extent-tree.c:2246)
>     btrfs_commit_transaction (fs/btrfs/transaction.c:2278)
>     ksys_sync (fs/sync.c:104)
>=20
> Without CONFIG_BTRFS_ASSERT, the kernel gives only the WARN_ON().  Then
> btrfs continues to use the owner ref.
>=20
> [CAUSE]
> I made a crafted image : an owner ref, no SIMPLE_QUOTA bit, and no quota
> tree.  I removed the file of the extent.  At the next commit, btrfs
> frees the extent and gives the BUG above.
>=20
> For an owner ref without the SIMPLE_QUOTA bit, the tree-checker gives a
> WARN_ON() and keeps the leaf.  For all other inline ref types, it
> rejects the leaf.  Two sources can put owner refs without the
> SIMPLE_QUOTA bit on a disk : a damaged or crafted image, and a kernel
> without commit f2363e6fcc79 ("btrfs: fix transaction atomicity bug when
> enabling simple quotas").
>=20
> [FIX]
> Reject the leaf with -EUCLEAN, as for all other incorrect inline refs.
> Then btrfs finds the problem when it reads the leaf, and the ASSERT() is
> not reached.
>=20
> Link: https://syzkaller.appspot.com/bug?extid=3Dd7d1fc7e21835ca19219
> Link: https://syzkaller.appspot.com/bug?extid=3D4983e68a6d77180bfe33
> Cc: stable@vger.kernel.org # 6.7+

Again, use your common sense other than fully rely on LLM.

Will drop it at merge time.

Reviewed-by: Qu Wenruo <wqu@suse.com>

> Signed-off-by: Siddharth Mishra <smish149@asu.edu>
> ---
>   fs/btrfs/tree-checker.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index bb86c30a2..f021ac14b 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -1779,7 +1779,11 @@ static int check_extent_item(struct extent_buffer=
 *leaf,
>   			inline_refs +=3D btrfs_shared_data_ref_count(leaf, sref);
>   			break;
>   		case BTRFS_EXTENT_OWNER_REF_KEY:
> -			WARN_ON(!btrfs_fs_incompat(fs_info, SIMPLE_QUOTA));
> +			if (unlikely(!btrfs_fs_incompat(fs_info, SIMPLE_QUOTA))) {
> +				extent_err(leaf, slot,
> +					   "extent owner ref without simple quota");
> +				return -EUCLEAN;
> +			}
>   			break;
>   		default:
>   			extent_err(leaf, slot, "unknown inline ref type: %u",

