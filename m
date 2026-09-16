Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7424C3DDDCA;
	Wed, 16 Sep 2026 05:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789536518; cv=none; b=VkycTCsOKhw1SbcguyiA32KWVdJLgtf2BycpQIaSS0izfYkj+EPQWSYld0lCBJx3owwvT/I0q47GwJQ0vYkRfr5ONC1OJqDAPaX8BPmf0z7zuben6e6iSCs21Lo+Sz6nDZF6TJsVLhpRjyys60R6fvNjP3mB5RGqE+5wNj9YiwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789536518; c=relaxed/simple;
	bh=Ke9mw1SgN6oy0duPoAmlGtiA+5iA/78O/GTyrXwROVc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HoNC0mglzG0jsqGZ8VQ3n4DUUhEBb9YHBS1ZHM+X26/5ykgRjCMXIzqFRNoM60o7skqJmUdkjZeIRpq/gu93hJEuo8Fj5HCYXqGjg4w6m0ov4XHBmcicPGg0C7JvDSLE02jvmCxh9ot7iaYcnUPLf+60iRZmYQFqrR3Vy0wmn9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=VQd9yNEh; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="VQd9yNEh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1789536511; x=1790141311; i=quwenruo.btrfs@gmx.com;
	bh=wXhCcHHMcSHm5oTGGTaAAAXGER3rw753AhLSBx3Xge8=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=VQd9yNEhacGBLqz+rhuFOBzPOtt8FbB+V2470+cN/yaR4ZO/bwDwMqmYft/RYYZC
	 /v1RIkz2iSiw2j2yJWC+PrCTWLCikoCCy0L7vCSFFYDWpnILDeaFxYO7CUwCEyyG/
	 A8DZdtLnl9DQz0NPyY2QbENvSZYZ+LyOuqryWI+Z0wUdtFMoO1N0tLaOeqMbXwmng
	 lEB3zU0M3yHjE2AJUohICT2mz294mukPxQQbimx7tcp72VJ8NiZnpHxOoV3Zyytkf
	 172H+iFDyIoqgDOmv59vWojXLJWQzP/Cc6v0q2SHxLE3jVNpugGbhSI28mJy96zM3
	 tt5RIO2ZwkHBcJX3dQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MWzfv-1xI1tn3MHR-00V6qp; Wed, 16
 Sep 2026 07:28:31 +0200
Message-ID: <c59e1aea-616f-40e6-97aa-ac14d187d727@gmx.com>
Date: Wed, 16 Sep 2026 14:58:25 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] btrfs: clear free space tree creation state on rebuild
 failure
To: Guanghui Yang <3497809730@qq.com>, linux-btrfs@vger.kernel.org
Cc: wqu@suse.com, boris@bur.io, dsterba@suse.com, mason@kernel.org,
 fdmanana@suse.com, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <tencent_705010B6315454003C478AE79E1F215E6E08@qq.com>
 <tencent_17320F87E281276888825B1844508C179506@qq.com>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1YAUJEP5a
 sQAKCRDCPZHzoSX+qF+mB/9gXu9C3BV0omDZBDWevJHxpWpOwQ8DxZEbk9b9LcrQlWdhFhyn
 xi+l5lRziV9ZGyYXp7N35a9t7GQJndMCFUWYoEa+1NCuxDs6bslfrCaGEGG/+wd6oIPb85xo
 naxnQ+SQtYLUFbU77WkUPaaIU8hH2BAfn9ZSDX9lIxheQE8ZYGGmo4wYpnN7/hSXALD7+oun
 tZljjGNT1o+/B8WVZtw/YZuCuHgZeaFdhcV2jsz7+iGb+LsqzHuznrXqbyUQgQT9kn8ZYFNW
 7tf+LNxXuwedzRag4fxtR+5GVvJ41Oh/eygp8VqiMAtnFYaSlb9sjia1Mh+m+OBFeuXjgGlG
 VvQFzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
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
In-Reply-To: <tencent_17320F87E281276888825B1844508C179506@qq.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:20K8O0D4uuE5uwRJ5ue8JaQGliGkQuSvVBzipXtoV6QxNQwLY5C
 g8perIcw7arQLIAeXS+TBOU8r3r707TxSdmECMaw0FVwsT4yefwi1TIqNL8x1TFHWiTZVDi
 npSZlKtxuJGDbHg2U9O0hsdT/FObHB0QIgxRucW2kTVUCMxOyYZVpQiKArf7zLf5m1uPxI2
 RbegocE0pAOUE916T+xpA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:q7k8ZI8eZZY=;9Xio5EaBVmv8uQTHvIDuOpqEieQ
 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
 /q74cJBeD9Jfq



=E5=9C=A8 2026/9/16 14:46, Guanghui Yang =E5=86=99=E9=81=93:
> btrfs_rebuild_free_space_tree() sets
> BTRFS_FS_CREATING_FREE_SPACE_TREE before rebuilding the free space tree.
> Several error paths return without clearing this flag.
>=20
> The transaction restart failure path can leave the flag set on a live
> filesystem, causing delayed reference processing to be skipped. Clear it
> on all free space tree rebuild failure paths. Keep
> BTRFS_FS_FREE_SPACE_TREE_UNTRUSTED set, since a failed rebuild leaves th=
e
> free space tree untrusted. Callers must fall back to extent-tree caching=
.
>=20
> Fixes: 882af9f13e83 ("btrfs: handle free space tree rebuild in multiple =
transactions")
> Cc: stable@vger.kernel.org # 6.14+
> Tested:
>    xfstests btrfs/015 btrfs/032 btrfs/104 btrfs/131 btrfs/352 (pass)
>    xfstests btrfs/quick: 261 passed, 30 failed, 90 not run on
>    Ubuntu 5.15.0-60-generic

WTF? You're not even running the tests with an upstream kernel with your=
=20
patch applied?

Thankfully the patch still looks good to me.

Reviewed-by: Qu Wenruo <wqu@suse.com>

I'll remove the stupid tag, and finally stop wasting time on someone who=
=20
doesn't have any brain cell to properly test the patch.

> Assisted-by: LLM
> Signed-off-by: Guanghui Yang <3497809730@qq.com>
> ---
>   fs/btrfs/free-space-tree.c | 14 ++++++++++----
>   1 file changed, 10 insertions(+), 4 deletions(-)
>=20
> diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
> index 1b3d82ae3de8..b7a4a6ade30f 100644
> --- a/fs/btrfs/free-space-tree.c
> +++ b/fs/btrfs/free-space-tree.c
> @@ -1353,7 +1353,7 @@ int btrfs_rebuild_free_space_tree(struct btrfs_fs_=
info *fs_info)
>   	if (unlikely(ret)) {
>   		btrfs_abort_transaction(trans, ret);
>   		btrfs_end_transaction(trans);
> -		return ret;
> +		goto out_clear;
>   	}
>  =20
>   	node =3D rb_first_cached(&fs_info->block_group_cache_tree);
> @@ -1371,14 +1371,16 @@ int btrfs_rebuild_free_space_tree(struct btrfs_f=
s_info *fs_info)
>   		if (unlikely(ret)) {
>   			btrfs_abort_transaction(trans, ret);
>   			btrfs_end_transaction(trans);
> -			return ret;
> +			goto out_clear;
>   		}
>   next:
>   		if (btrfs_should_end_transaction(trans)) {
>   			btrfs_end_transaction(trans);
>   			trans =3D btrfs_start_transaction(free_space_root, 1);
> -			if (IS_ERR(trans))
> -				return PTR_ERR(trans);
> +			if (IS_ERR(trans)) {
> +				ret =3D PTR_ERR(trans);
> +				goto out_clear;
> +			}
>   		}
>   		node =3D rb_next(node);
>   	}
> @@ -1390,6 +1392,10 @@ int btrfs_rebuild_free_space_tree(struct btrfs_fs=
_info *fs_info)
>   	ret =3D btrfs_commit_transaction(trans);
>   	clear_bit(BTRFS_FS_FREE_SPACE_TREE_UNTRUSTED, &fs_info->flags);
>   	return ret;
> +
> +out_clear:
> +	clear_bit(BTRFS_FS_CREATING_FREE_SPACE_TREE, &fs_info->flags);
> +	return ret;
>   }
>  =20
>   static int __add_block_group_free_space(struct btrfs_trans_handle *tra=
ns,
>=20
> base-commit: 587858367581b9c55c3690f4e63382ad622719d4

