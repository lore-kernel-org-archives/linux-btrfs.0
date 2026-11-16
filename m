Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.17.22
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794861263;
	b=cemNyOWYWlMenDLG56KJcIe5IJbEYYJem8RdX2AbDhtJQt6gMM95Civ/UyrdR+p1BjoF
	 wwTeLmgLsxhKWto9zaD8lBDh1iLZt0XBvLUJaQYW9GXZXJ9z/HyFxN8QRfixrEW0adDDS
	 x2UhKjsrMEOMJuo0ToLdTgiz3mrX5fQ3vLuItO9PM6wtK0mA2X0ysY9GLhc2rFmAPmy+r
	 brJFnjVtr4DGnisdnOErmud2o9h0mp7vdvsWDNTvx/dFUppB+joSrWTL0+GplEfYkojv3
	 0JjeXSH1O5tu0gpLohzzRYbGehbmpPcH5otMx2P/hzVzAAmpuez9I8oC+lKiNaw7iww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794861263;
	h=DMARC-Filter:DKIM2-Signature:Message-Instance:DKIM-Signature:
	 X-UI-Sender-Class:Received:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:References:Content-Language:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:
	 UI-OutboundReport;
	bh=MI2UPur+jyfao3ix9K89KF3TiIG83L1BysJTb7phIew=;
	b=sabbMJ24PT+yN8AEFapT+91uhzfjOyKXo69TZ7jOPM01MeoQN0pg6g9zSRd7hobMZvgK
	 mPfNSdjICtvnbn2wf675DYz7sCbkH6ibxw/77XXPC85j2kiJYt4ou6DAlPX2fuza4MusC
	 RXr9DLb5Kuhxy3pjxcLkulypNCuNo8+e7EY6HjacuKiMDuoI3UsaKi1zLwAoCL6Xy3+WW
	 JWj8nijt+ZoPY7y6FkMGGhJugplZRWdcU3cbfhL6Z0Y1vF8V5g7ajclZm1a17qP/+dp4D
	 JLncRkXpP1J8Bwjak9JtxkOlZ6IxvkkKAwTfPpcDyHgYdxVrgGoaKQ7YrTlT3/07tOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=VOEyn01d;
	arc=none smtp.remote-ip=212.227.17.22
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 055C7606A31C
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2026 20:34:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 055C7606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=VOEyn01d
DKIM2-Signature:  i=1; m=1; t=1794861259;
 mf=PHF1d2VucnVvLmJ0cmZzQGdteC5jb20+;
 rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
 d=gmx.com;
 s=s31663417:rsa-sha256:WhreOMtzaiJ90++qapXH0P00Oy/z
   aKIckpY83+FIEV/04VtGXn2LPz7Sh/e/fur/1lOqAmG59hismsk9vavaEbm8ayE7DWyJMMqMe2O
   KQscOnwtG7ejnHFQ++m72GcoAIT5duHoEMIRrRpMd9VTUQgcvXpL1nTFehBFExGhhnFbb2KwXhi
   7iiR20pPoubIQz3sGjarARjCeqRPaGez547dPwGwuCwo3vDZubA2LMncK6blCAZxdlGUaDNjcXV
   y9GUU0y/ZParV7VtXxiqdHojLLc8yaM3hC5nke2s+uhbJNJKeZTfpAjDfEVUNJAPEZPsJtmNX7P
   PziC4RRqVkWxdA==;
Message-Instance:  m=1;
 h=sha256:
   LP00IC5VDl8KWZeKDspZ5PRETwSZtRt9FYIkzgQGVoo=:
   scgk6Hs/hKhfJBSA8IsRzkn36Rs5aCaWT/KjOeTwpeE=,
  sha512:
   Kzdm1I8lRYBX124IeGKxYpym3Dt2VB1o1TYLmSVx3dHRe2kRqSI061sCPLncpZeh1YungD/TYQ0C53pLP2aLWA==:
   H+6PPqT1MOrsetVw7oPcCS+zkAGrzMj0LjwbSrAAMsnKUs1GSh3ataf3uE8fU9wTcVU3N1EK71slRPTB8c5PkQ==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1794861256; x=1795466056; i=quwenruo.btrfs@gmx.com;
	bh=MI2UPur+jyfao3ix9K89KF3TiIG83L1BysJTb7phIew=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=VOEyn01dXNnS9FJCfJxkL7U1tTkFMMQKuswpTSU1/L2HxZT96RrU5J++/l0T5SLn
	 +S7NzH+fJMARIdSzOj4qmM3Z1UMggyx/hl820ZRt/EWPpkFsU5YGkFpBUj9k4AzoI
	 3Z9t3E3swypKM4SdOCCNi2ASPbH2Dv5h+LNJAtrbHEgJ3beogN5no5K44I+KwwXTN
	 gVIHrtlXOk72PQhD/zEcWDPV5+vqLMOdHsjracvGswuq5FiSW2vW/3Dp/o1mfLfz3
	 qUfPdd99CH2IY7ZtyyhJbwIikpvAabeoaf2zOi2kMzMujaM5auG56UI2waQlehjR/
	 BHcbdjydhwtIdV2p1g==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1M3UZG-1xSVRF2TAo-0025kp; Mon, 16
 Nov 2026 21:34:16 +0100
Message-ID: <7eac394b-824d-48ef-bc30-2488195568e4@gmx.com>
Date: Tue, 17 Nov 2026 07:04:13 +1030
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
Subject: Re: [PATCH] btrfs: add missing unlikely tag to branches leading to
 transaction aborts
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <df971dad64e73d71fe7e9bd9188efe5f22e9bea4.1794833257.git.fdmanana@suse.com>
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
In-Reply-To: <df971dad64e73d71fe7e9bd9188efe5f22e9bea4.1794833257.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:ujF4qKQp4fxy8bg8aSz8rCVsldGvgOTxNMvvBQJum+f1JBbK4tt
 MkcWbDcrokMPT43eOez8Ux7Y7PCwf5zSVWOYv/rTHpNVv+tErduDT9t9AIwaxn9Z3CJZNpF
 SZjEgXY6wICm9wVi8huJMG1odopqhTE54Xb9joPtCewLM336izzCfana2r1M4FBqWrJn5B4
 3gGIt6bj59axe4RwFfQ4Q==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:3FZFsQsTfRA=;q0XMMOHlYi17S0o5GadtzsiSrQw
 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
 y9vpa38oxTubn+gXY4a+d08J



=E5=9C=A8 2026/11/16 23:18, fdmanana@kernel.org =E5=86=99=E9=81=93:
> From: Filipe Manana <fdmanana@suse.com>
>=20
> We have a few branches that lead to transaction aborts that are missing
> the unlikely tag, so add it to them as these are unexpected scenarios.
>=20
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
[...]
> @@ -4445,7 +4445,7 @@ static int move_existing_remap(struct btrfs_fs_inf=
o *fs_info,
>   	if (unlikely(ret)) {
>   		btrfs_free_reserved_extent(fs_info, dest_addr, dest_length, 0);
>  =20
> -		if (trans) {
> +		if (unlikely(trans)) {

This seems to be overkilled?

There are a lot of goto end callsites in the function and @trans=20
shouldn't be NULL for most cases here.

Otherwise looks good to me.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

>   			btrfs_abort_transaction(trans, ret);
>   			btrfs_end_transaction(trans);
>   		}
> @@ -5158,26 +5158,26 @@ static int do_remap_reloc_trans(struct btrfs_fs_=
info *fs_info,
>  =20
>   	if (bg_needs_free_space) {
>   		ret =3D btrfs_add_block_group_free_space(trans, dest_bg);
> -		if (ret) {
> +		if (unlikely(ret)) {
>   			btrfs_abort_transaction(trans, ret);
>   			goto fail;
>   		}
>   	}
>  =20
>   	ret =3D copy_remapped_data(fs_info, start, new_addr, length);
> -	if (ret) {
> +	if (unlikely(ret)) {
>   		btrfs_abort_transaction(trans, ret);
>   		goto fail;
>   	}
>  =20
>   	ret =3D btrfs_remove_from_free_space_tree(trans, new_addr, length);
> -	if (ret) {
> +	if (unlikely(ret)) {
>   		btrfs_abort_transaction(trans, ret);
>   		goto fail;
>   	}
>  =20
>   	ret =3D add_remap_entry(trans, path, src_bg, start, new_addr, length)=
;
> -	if (ret) {
> +	if (unlikely(ret)) {
>   		btrfs_abort_transaction(trans, ret);
>   		goto fail;
>   	}
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index 399414ae67c8..763487114f85 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -434,7 +434,7 @@ static int process_one_buffer(struct extent_buffer *=
eb,
>  =20
>   		if (btrfs_buffer_uptodate(eb, gen, NULL) && level =3D=3D 0) {
>   			ret =3D btrfs_exclude_logged_extents(eb);
> -			if (ret)
> +			if (unlikely(ret))
>   				btrfs_abort_transaction(trans, ret);
>   		}
>   	}
> @@ -2943,7 +2943,7 @@ static int clean_log_buffer(struct btrfs_trans_han=
dle *trans,
>   		int ret;
>  =20
>   		ret =3D btrfs_pin_reserved_extent(trans, eb);
> -		if (ret)
> +		if (unlikely(ret))
>   			btrfs_abort_transaction(trans, ret);
>   		return ret;
>   	}
> @@ -3019,7 +3019,7 @@ static noinline int walk_down_log_tree(struct btrf=
s_path *path, int *level,
>   			path->slots[*level]++;
>   			if (wc->free) {
>   				ret =3D btrfs_read_extent_buffer(next, &check);
> -				if (ret) {
> +				if (unlikely(ret)) {
>   					free_extent_buffer(next);
>   					if (trans)
>   						btrfs_abort_transaction(trans, ret);
> @@ -3038,7 +3038,7 @@ static noinline int walk_down_log_tree(struct btrf=
s_path *path, int *level,
>   			continue;
>   		}
>   		ret =3D btrfs_read_extent_buffer(next, &check);
> -		if (ret) {
> +		if (unlikely(ret)) {
>   			free_extent_buffer(next);
>   			if (trans)
>   				btrfs_abort_transaction(trans, ret);
> @@ -3617,7 +3617,7 @@ static void free_log_tree(struct btrfs_trans_handl=
e *trans,
>  =20
>   	if (log->node) {
>   		ret =3D walk_log_tree(&wc);
> -		if (ret) {
> +		if (unlikely(ret)) {
>   			/*
>   			 * We weren't able to traverse the entire log tree, the
>   			 * typical scenario is getting an -EIO when reading an
> diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
> index cbee10b6b49a..1a71a1472c27 100644
> --- a/fs/btrfs/xattr.c
> +++ b/fs/btrfs/xattr.c
> @@ -260,7 +260,7 @@ int btrfs_setxattr_trans(struct inode *inode, const =
char *name,
>   	inode_inc_iversion(inode);
>   	inode_set_ctime_current(inode);
>   	ret =3D btrfs_update_inode(trans, BTRFS_I(inode));
> -	if (ret)
> +	if (unlikely(ret))
>   		btrfs_abort_transaction(trans, ret);
>   out:
>   	if (start_trans)
> @@ -446,7 +446,7 @@ static int btrfs_xattr_handler_set_prop(const struct=
 xattr_handler *handler,
>   		inode_inc_iversion(inode);
>   		inode_set_ctime_current(inode);
>   		ret =3D btrfs_update_inode(trans, BTRFS_I(inode));
> -		if (ret)
> +		if (unlikely(ret))
>   			btrfs_abort_transaction(trans, ret);
>   	}
>  =20

