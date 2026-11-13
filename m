Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.17.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794539432;
	b=P+b4sjZ/ExNpKLra6Z1bwmImfS4xuo23ijV2t3Qsz11a+XKXSYJw9q5hrM5MOeLM72Fs
	 AxKrVvrpkfbYjpIuS2MH5XEYN5GIyZt8nf9KlBrA4VY0ckGy9pNA7p1QPLlE9kkdcMkEF
	 yliKRfIJgZ0vgZXqLbSG62yh9hwNAtAEGvqfo/I+ndmEI4hkoEs8/e5vVfSEA1yO6rq9H
	 GVrg2Pl5LfIZEo+fBXh7bjcSVTunq4czBNB8B4UBdpmfn6BTS5xYu3FGpVGWST0IjnZjN
	 2iB0wmEOo+pRJ3d34znK/cKY8UEFbdO4z9kkM76i/dRqvpVT27Zn5N+2bPDmiRjBQ0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794539432;
	h=DMARC-Filter:DKIM2-Signature:Message-Instance:DKIM-Signature:
	 X-UI-Sender-Class:Received:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:References:Content-Language:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:
	 UI-OutboundReport;
	bh=7TTWdwN6Dc2y0fLRLjEzGOVMqQCeMfRgf+2qYgDnFzs=;
	b=UyD+umx/yZqWPv/g9mxHvg37TA46xJuFDdonsPbB6S1iMjMXZseZDR1wo9kEzMg+ZCQQ
	 rGEi9kcb1mWg2to/9UYiTOwGqGK2hK7uoMs6eH7x5TA/orjbCzOmsav3Uffi17RSHpItr
	 i5F3bMnWTixZ1rvZUMd2revNZpbPYSNEX/vWVXKWJImP7ab6TqQA4bcAeqvBJRIhWPMaQ
	 y6fqyFZeT4E0a7wgrF6yUOdmAa+pFY3tWruYymXQk1IEwIl2rORO4v3uA6/dLo6s+OXx+
	 bhKaWmsyylgte+K6Xl7nAm2OofGD3oXfGfJxT1iGVcCYiyzy5xHgTGKENQa3fbbP6MA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=KqQUSPFO;
	arc=none smtp.remote-ip=212.227.17.21
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01929606A31C
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 03:10:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 01929606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=KqQUSPFO
DKIM2-Signature:  i=1; m=1; t=1794539428;
 mf=PHF1d2VucnVvLmJ0cmZzQGdteC5jb20+;
 rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
 d=gmx.com;
 s=s31663417:rsa-sha256:i0MrRpE22wydM1mDbQEOKs9dyH+V
   6+FUr9BCg3BdIshX5OLahmH/tHpJPgQHid++D1S2irMXL2T9cyLSbQXHUbU0lRz9iJaoJe+Cj/R
   RhiVZbAq8qLD3qlFLXY/l6u8ydYlajIFDkDJRUJRmgCLq9Ca/oiDrQzLQy8MMx0APQvyhOjwdCh
   56amFZpJbAxe3ipe7RFYZQKsiBUE7XT/IXxG1+4/eEmtUp5ch8DGftLG0jPPYWc6VIUoXgovloJ
   Oc8GQPEM00yb39n/Iiz+qfhqbg6B8bJeP4+msVR3Z7DHoVAm+vT3qlZGAsRfwhZJ9TY67SIQiIL
   avd+fS1xK8NjvA==;
Message-Instance:  m=1;
 h=sha256:
   5oK4GScSsF35oPjdVQdSIvLzaYBkSg0izNhIlaT5TR8=:
   Jnlkk4IWJES6seh3FFJDjzdYmwIOdMi/OpF0tNYdyU8=,
  sha512:
   bd7EIPQ4KHsGTzXlLMtsZ3Z3fmlIbFVL/LFo9B9ifn2shvrqit/CervSCZS+o67ZDpnD8rwsXxiuRPL8kIm3iw==:
   /Cwp0LK3nCPO8JbclKBMikqznv4xcX0Aw7zDqmyLyuA36okJUbW1ZBbtQwaixa4ydA5//7IAiDzL5L6l5FCBmw==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1794539428; x=1795144228; i=quwenruo.btrfs@gmx.com;
	bh=7TTWdwN6Dc2y0fLRLjEzGOVMqQCeMfRgf+2qYgDnFzs=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=KqQUSPFOjtk3xQuOWY53GN+S93RkIPc3045JOdsxedZX8Xj4hZ0WKHvHNR0NvUtZ
	 gSqJzlGqR84qvOMJV/LICFr6Ozz8ibZL6P/Pl4pSd59PLyM7oUroR4XQbL40qAyBt
	 0Wo3AMZl0H0nx/FY1LXEYOx8EbNvvb5vcrHEyBK47hQG+2GW0TJFMEOeGGa06wtL7
	 PlK+c//noVLHu5e3tH1loXFDySD1Z0y669NfrN81/p16VpKOASiR9AXw/WZlqvbRq
	 aXajAj0q8yprG56xy17IRSbDlFajk6pIL6uIyfOFQ5X+UkewqfzHKb2IkA4p422JE
	 ac4UC6EkUw8csLS1og==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MLiCu-1xA2J21AXY-00JDDc; Fri, 13
 Nov 2026 04:10:28 +0100
Message-ID: <a66e8165-c819-4748-adc1-6c82bdcc6c9f@gmx.com>
Date: Fri, 13 Nov 2026 13:40:25 +1030
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
Subject: Re: [PATCH v2] btrfs: send: fix invalid access to inline extents in
 clone_range()
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <a8f80de0fd18699ffc6f9fbbdfa794e80e9a1fe1.1794504038.git.fdmanana@suse.com>
 <3a9994c5325a0d6687798909f9d02688420aad83.1794505101.git.fdmanana@suse.com>
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
In-Reply-To: <3a9994c5325a0d6687798909f9d02688420aad83.1794505101.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:/WXJNdAKh9XehfqWnGgIcVDUPHyzCt/RL6bRM4bphbzi0d4Dxkj
 FUP3hqPu2lLWdfVpbldEAyzbXngmhXirXLLKgs722bTF6MhSfchV0ZK35sNSFwHgtIX6YTq
 Ar4Ngd1ykmKJ3uHR6MDj35YHZtE45/CeMfL8FR5PH8PhuDeb+4q7aHJQDYpHaWtjFDb8XV9
 H3+obW1SaRQDn188PAd4w==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:+tsxhZFKai0=;6/vDVRnsaZpPpAc/tZjYDc06DLP
 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
 Wk4yv3Ip0JCYp57



=E5=9C=A8 2026/11/13 04:09, fdmanana@kernel.org =E5=86=99=E9=81=93:
> From: Filipe Manana <fdmanana@suse.com>
>=20
> We can't access the disk_bytenr and offset fields of a file extent item
> that represents an inline extent, since the extent's data starts at the
> offset of the disk_bytenr field and the offset field is after that, so
> both fields point either to inline data or beyond the file extent item
> in case the data is too small.
>=20
> Fix this by not reading the disk_bytenr and offset fields if we are
> dealing with an inline extent.
>=20
> Link: https://sashiko.dev/#/bug/linux-b662b951-0491-465b-a262-f01a108d81=
46
> Fixes: 040ee6120cb6 ("Btrfs: send, improve clone range")
> Fixes: d906d49fc5f4 ("Btrfs: send, fix file corruption due to incorrect =
cloning operations")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>=20
> V2: Fix a missing extent item offset access.
>=20
>   fs/btrfs/send.c | 29 ++++++++++++++++-------------
>   1 file changed, 16 insertions(+), 13 deletions(-)
>=20
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index 1b903e75cec0..3cc7749f0452 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -5842,7 +5842,7 @@ static int clone_range(struct send_ctx *sctx, stru=
ct btrfs_path *dst_path,
>   		u8 type;
>   		u64 ext_len;
>   		u64 clone_len;
> -		u64 clone_data_offset;
> +		u64 clone_data_offset =3D 0;
>   		bool crossed_src_i_size =3D false;
>  =20
>   		if (slot >=3D btrfs_header_nritems(leaf)) {
> @@ -5906,23 +5906,26 @@ static int clone_range(struct send_ctx *sctx, st=
ruct btrfs_path *dst_path,
>   			crossed_src_i_size =3D true;
>   		}
>  =20
> -		clone_data_offset =3D btrfs_file_extent_offset(leaf, ei);
> -		if (btrfs_file_extent_disk_bytenr(leaf, ei) =3D=3D disk_byte) {
> -			clone_root->offset =3D key.offset;
> -			if (clone_data_offset < data_offset &&
> -				clone_data_offset + ext_len > data_offset) {
> -				u64 extent_offset;
> -
> -				extent_offset =3D data_offset - clone_data_offset;
> -				ext_len -=3D extent_offset;
> -				clone_data_offset +=3D extent_offset;
> -				clone_root->offset +=3D extent_offset;
> +		if (type !=3D BTRFS_FILE_EXTENT_INLINE) {
> +			clone_data_offset =3D btrfs_file_extent_offset(leaf, ei);
> +			if (btrfs_file_extent_disk_bytenr(leaf, ei) =3D=3D disk_byte) {
> +				clone_root->offset =3D key.offset;
> +				if (clone_data_offset < data_offset &&
> +				    clone_data_offset + ext_len > data_offset) {
> +					u64 extent_offset;
> +
> +					extent_offset =3D data_offset - clone_data_offset;
> +					ext_len -=3D extent_offset;
> +					clone_data_offset +=3D extent_offset;
> +					clone_root->offset +=3D extent_offset;
> +				}
>   			}
>   		}
>  =20
>   		clone_len =3D min_t(u64, ext_len, len);
>  =20
> -		if (btrfs_file_extent_disk_bytenr(leaf, ei) =3D=3D disk_byte &&
> +		if (type !=3D BTRFS_FILE_EXTENT_INLINE &&
> +		    btrfs_file_extent_disk_bytenr(leaf, ei) =3D=3D disk_byte &&
>   		    clone_data_offset =3D=3D data_offset) {
>   			const u64 src_end =3D clone_root->offset + clone_len;
>   			const u64 sectorsize =3D SZ_64K;

