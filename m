Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.17.20
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792737564;
	b=Vn1x+6TsNN7JfqDKBv2gpkduvoq6sijS4xrE4HEAqrieQKWRffxIDIYblRTo4esI3EzV
	 Amg/XsgsO561wA7/DSc6kHyZug9Ktd6u/PGg/M1Nlv4TUFsTHoFcbvZbNmF/4vjfos/CJ
	 h4OHtHXbxFOBam0RUI0OGETDyG5SE34GG3TbGV9fXzSEBZhIFBsP25pUzl/zEmyVyxpvi
	 77L/W+lQ/kRRQ+ZjT0mb00wvM7L/8sd8d1xP4m2o32oBr97UiaLzDdf2EBbaPHgBHXaIl
	 hBtulPjo6CGoRrCEZegfV+aWdirtwzURUK1MVrCA5KfrA1qgXWMjWCg1xlbTOQUv6VQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792737564;
	h=DMARC-Filter:DKIM-Signature:X-UI-Sender-Class:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Provags-ID:
	 X-Spam-Flag:UI-OutboundReport;
	bh=03sdvm581essYN7M3shYiIOgJXYfEc7j7KTr+Kkdngo=;
	b=GNZmUbzamEnBEVZKYPpmlb5SjsKmawP8fGBqS/J5hDlVnwn1kJCuVLIVVhwdninUnXug
	 hnAIpz79oXee4WdkdsdyGC4ZXRW8IdtQiIgfJdmGV72TgIHHH+wfTPrkmbTTIZdqrItwv
	 ZHwpZW+UCEdOCxYbJvONoYVvEc+0fTVXpFpPr8oYIt0LrYva1yOwf/HqTnD2HYYKtLAqY
	 7ffh/2nYIuVY2+/yu9NH3MYHI/WxNJR4kR/fGUHqcHTtl9MjONorqJ8qKuHCpGByx7uA6
	 5Q/Db3DzO41wyC9TdMpHsJtM35W+cQ7fvb5FwELiPDWdC+wXUWbcC6pXM+od4AoQigg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=aAWK44Ax;
	arc=none smtp.remote-ip=212.227.17.20
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F43F606A31A
	for <linux-btrfs@vger.kernel.org>; Fri, 23 Oct 2026 06:39:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2F43F606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=aAWK44Ax
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1792737561; x=1793342361; i=quwenruo.btrfs@gmx.com;
	bh=03sdvm581essYN7M3shYiIOgJXYfEc7j7KTr+Kkdngo=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=aAWK44AxAT0wBzerq27lKFhGTOl/e9Joah4CD5CT8TXdbcBw2a5pKhtE9+4q8Rdk
	 ota2fgXSnkootnyk56jwfG87WI2myg+LXVR+wz8B3cDZUEo4T/FVAr5oJQBoNdoA0
	 V/S+SqdHQ2Ng5i3cUNCa/43dmvNFIAuF3o1Uhg4MGz2nWHgc1vbipHXDToc95URv9
	 ir0WQKoYpP/A0iHR+SMfZ4s7MoJt45JUH7VvcPx56pRXCfv5gWeklfs6j5sCE+skB
	 xhdh0zQ63bf75z41zFynaCSI6F+DsDnUQi7hoNCnNfsjT8rDbbQhHOOJkdFIMeZOZ
	 ox+UoBb/lyLySS2JRQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MStCY-1x9oQQ1tde-00SQ2s; Fri, 23
 Oct 2026 08:39:21 +0200
Message-ID: <31e4e491-c331-43fa-bbf5-7459860834de@gmx.com>
Date: Fri, 23 Oct 2026 17:09:16 +1030
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
Subject: Re: [PATCH v2] btrfs: send: fix missing hole punching during
 incremental send
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <25a6b104e8af433508c425cd7470426470f811f2.1792613378.git.fdmanana@suse.com>
 <087634ad0970d81654b2f1cc72cd35bbde47df97.1792618636.git.fdmanana@suse.com>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
In-Reply-To: <087634ad0970d81654b2f1cc72cd35bbde47df97.1792618636.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:357CFN0H9g6Cl5nhJk8SWKp9lln6AWcYYQaUPtTZeFYaUeBcGER
 qIepSYh+adNuo99v0fvzBICyGlI4jNpo2y4qrd4yf7EG2GwkUHFna67gwjVDw2QZjRVc6ic
 VARDeV7xl2MRHxtB72k7D/jpn+70BgCDdCMYdX7NasWBIIWRwVK+HLd2F1F9WVGTxgYcxfy
 WlfX44ChKUfuo7E/8/wgw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:sW1scuHaEj8=;GPAJ9UHXs8J+ZOlRnUxlkObGRh9
 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
 FD6NGcJtPpmYMcX/XUns652



=E5=9C=A8 2026/10/22 08:11, fdmanana@kernel.org =E5=86=99=E9=81=93:
> From: Filipe Manana <fdmanana@suse.com>
>=20
> When using the no-holes feature (enabled by default since btrfs-progs
> v5.15) and doing an incremental send, we can miss issuing a hole punchin=
g
> command when the following conditions happen:
>=20
> 1) A hole is punched in a tail section of a file extent item that happen=
s
>     to be the last item in a leaf (for example the extent covers the fil=
e
>     range [1M, 3M) and a hole is punched in the range [2M, 3M)). Between
>     the end of this file extent item's range and the i_size, there are
>     other file extent items;
>=20
> 2) The next leaf was not modified in the send snapshot, remaining shared
>     with the parent snapshot.
>=20
> In this scenario we are unable to detect a hole was punched and never
> issue a hole punch command because with no-holes there we don't have an
> exlicit file extent item to mark a hole.
>=20
> Fix this by teaching maybe_send_hole() to detect such case.
> A test case for fstests will follow soon.
>=20
> Reported-by: Tristan Elvers <tristanelvers@gmail.com>
> Link: https://lore.kernel.org/linux-btrfs/CAFoLKK+aErV4p6ZJPnVeH5SHQ5++0=
f=3D8ZgxPWe-E-CkeKBs8PA@mail.gmail.com/
> Fixes: 16e7549f045d ("Btrfs: incompatible format change to remove hole e=
xtents")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>=20
> V2: Address a couple issues pointed by sashiko, simplify a few things.
>=20
>   fs/btrfs/send.c | 62 +++++++++++++++++++++++++++++++++++++++++++++----
>   1 file changed, 58 insertions(+), 4 deletions(-)
>=20
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index c523bf950c89..cec1aae5ce14 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -6371,6 +6371,8 @@ static int range_is_hole_in_parent(struct send_ctx=
 *sctx,
>   static int maybe_send_hole(struct send_ctx *sctx, struct btrfs_path *p=
ath,
>   			   struct btrfs_key *key)
>   {
> +	BTRFS_PATH_AUTO_FREE(next_path);
> +	u64 next_offset;
>   	int ret =3D 0;
>  =20
>   	if (sctx->cur_ino !=3D key->objectid || !need_send_hole(sctx))
> @@ -6397,14 +6399,66 @@ static int maybe_send_hole(struct send_ctx *sctx=
, struct btrfs_path *path,
>   		ret =3D range_is_hole_in_parent(sctx,
>   					      sctx->cur_inode_last_extent,
>   					      key->offset);
> -		if (ret < 0)
> -			return ret;
> -		else if (ret =3D=3D 0)
> +		if (ret =3D=3D 0)
>   			ret =3D send_hole(sctx, key->offset);
> -		else
> +		else if (ret =3D=3D 1)
>   			ret =3D 0;
> +
> +		if (ret < 0)
> +			return ret;
>   	}
>   	sctx->cur_inode_last_extent =3D btrfs_file_extent_end(path);
> +
> +	/*
> +	 * If we are the last file extent item in a leaf, we may have had a ta=
il
> +	 * section that got a hole punched, and if there is no change in the
> +	 * next leaf, we must find out if we have such a hole and punch it.
> +	 */
> +	if (path->slots[0] !=3D btrfs_header_nritems(path->nodes[0]) - 1)
> +		return ret;

Just a nitpick, do we need to check NO_HOLES features? IIRC without=20
NO_HOLES, we should always have a file extent covering i_size, thus=20
without NO_HOLES, we should not need to check for the next leaf?

Thanks,
Qu

> +
> +	next_path =3D alloc_path_for_send();
> +	if (!next_path)
> +		return -ENOMEM;
> +
> +	ret =3D btrfs_search_slot(NULL, sctx->send_root, key, next_path, 0, 0)=
;
> +	if (ret < 0)
> +		return ret;
> +	if (WARN_ON(ret !=3D 0))
> +		return -EUCLEAN;
> +
> +	ret =3D btrfs_next_leaf(sctx->send_root, next_path);
> +	if (ret < 0) {
> +		return ret;
> +	} else if (ret > 0) {
> +		/*
> +		 * No next leaf, must punch hole to i_size and set the path back
> +		 * to where it was before.
> +		 */
> +		next_offset =3D sctx->cur_inode_size;
> +	} else {
> +		struct btrfs_key next_key;
> +
> +		btrfs_item_key_to_cpu(next_path->nodes[0], &next_key,
> +				      next_path->slots[0]);
> +		if (next_key.objectid !=3D key->objectid ||
> +		    next_key.type !=3D BTRFS_EXTENT_DATA_KEY)
> +			next_offset =3D sctx->cur_inode_size;
> +		else
> +			next_offset =3D next_key.offset;
> +	}
> +
> +	btrfs_free_path(next_path);
> +	next_path =3D NULL;
> +
> +	ret =3D range_is_hole_in_parent(sctx, sctx->cur_inode_last_extent, nex=
t_offset);
> +	if (ret =3D=3D 0)
> +		ret =3D send_hole(sctx, next_offset);
> +	else if (ret =3D=3D 1)
> +		ret =3D 0;
> +
> +	sctx->cur_inode_last_extent =3D next_offset;
> +
>   	return ret;
>   }
>  =20

