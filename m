Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.17.20
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794262050;
	b=JS3iG/g4ptUW2Sk2Qa8nn0Gvf36/bSFcnBKpm0f8n6zTglJT45mmCsL5AeZo8sf5JCnC
	 O4G+Wg+Fr04VwANXSyR9TIAhHiT5WgG1Ief02324zGiDovfRUfTU5fln+hOlIV+UxmPtV
	 XtfZ293tM9W8adv4hlBLt85cHI3ac36BG4BgJzozSg7stL+KgRAxpsqfQLDh3lCpyfSAq
	 2i7NkdWxmHzdmSOAnasnYV6EsIW0TG1aFqK6DmOKE0g9bjqzIKfOdYYs8KGswgwY84yoj
	 aV25pKQ0lV6EQSff8nNPIjAcTL1HflGI+p0Fq0eqLySUidFSFDTaveuNEc99RTC605A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794262050;
	h=DMARC-Filter:DKIM-Signature:X-UI-Sender-Class:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:UI-OutboundReport;
	bh=FMYwBPSxB5xGETOyhuZPb9JImZEgspV6OX3E24U6CBc=;
	b=QMNp3d1OqqQNXFr/n1lCDwiJJiMvzc02XxxWvSmAgulND20VgmTiFepXmpWusHm93eOu
	 uqZ9QatsloFYHKO3sOVWm0cLzTWEhoClvs3nESFOIGSiM0xmo3jlCQ8gSMo14EkMbTSRo
	 G0JL3YAleFc/W2CTdzFfs67pjO/YeiJ+ONqJ6zZD0zDaTg2FZv6P/r+Ohz1tF6LSTQUp1
	 sIt4PmluvGpcl+GWuEMelUosSjlLWfZmAdclSlOTjloNSx+En19dlVS9STSeVcuOamlM9
	 0FpEyQ87RmVPqWkXUF5wOeLJdASaK0z6g5AZLbEI5iT/fiiGcBkfJkrfbX6G42UOIEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=itOj6sJm;
	arc=none smtp.remote-ip=212.227.17.20
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D70E2606A31C;
	Mon,  9 Nov 2026 22:07:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D70E2606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=itOj6sJm
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1794262042; x=1794866842; i=quwenruo.btrfs@gmx.com;
	bh=FMYwBPSxB5xGETOyhuZPb9JImZEgspV6OX3E24U6CBc=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=itOj6sJmac2hiAn3iCCaQVf94ifzdcm2hZNXlOUP1NLQG0v78cyYv5HWSu1pJ3dl
	 gH7T9z6WYfhoZrJ5rt4cdw0bJ07Va/LcJoAr8Im+e6tQi9Uq0LiaVIQoOHigpeQaP
	 Gsa1vFwi0k2RjJrOwpahQXDKGJLnsRF/8pBZS0wKpmDvkJ6Ptvgb445/bIr6Zic1S
	 nljZVZcOXKdBPbyntsPKFP/kJ/+7M5JiSbiEf8t3ANiQF7gRcJmeUIftkA1v/O9Yq
	 0iXveShTJzRa5HqkTZGx5GUdPWTG5bq7LCcRJxi8c8AxA1Wxjdhm0LOnOVq29w4fM
	 IyxTh35cm3oBkDwThA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1Mwfac-1wX5gB373S-014lhD; Mon, 09
 Nov 2026 23:07:22 +0100
Message-ID: <d3e07f45-58f3-4668-b9c2-e0cf63decd4c@gmx.com>
Date: Tue, 10 Nov 2026 08:37:16 +1030
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
Subject: Re: [PATCH] btrfs: Clean up delayed inode items on transaction abort
To: pavankumaryalagada@gmail.com, dsterba@suse.com
Cc: mason@kernel.org, fdmanana@suse.com, josef@toxicpanda.com,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 skhan@linuxfoundation.org,
 syzbot+55d1814e49f1fc0ba542@syzkaller.appspotmail.com
References: <20261109202914.64371-1-pavankumaryalagada@gmail.com>
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
In-Reply-To: <20261109202914.64371-1-pavankumaryalagada@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:LQOSa62LFj+4QPsSTNaXWSLmlaKU7Y3RECMRQKg/vmPNvXQvae+
 hSfuqb1M4sy0x8/k2fIoN44x6Mbu9CCtZwIbqHS1VxkhFy2+TqU3m68QuwldXMmD4WZzk9E
 B/+wYZcU7zQ1FMblCzQ8f2OAXUdM41QZvoULajb4gkNADhuRc2BN9m86J4uu6kQoshiZEJA
 i8hp6VybH8m3uEjpLjccw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:spBsKVMkC40=;YmDPJOlIyHdmh/iNGSrCRFRl1X9
 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



=E5=9C=A8 2026/11/10 06:59, pavankumaryalagada@gmail.com =E5=86=99=E9=81=
=93:
> From: Yalagada Pavan Kumar <pavankumaryalagada@gmail.com>
>=20
> When a transaction is aborted, btrfs_commit_inode_delayed_inode()
> fails because btrfs_join_transaction() returns an error. This makes
> btrfs_evict_inode() skip btrfs_kill_delayed_inode_items(), leaving
> pending items in the delayed node.
>=20
> Move the error check after btrfs_kill_delayed_inode_items() to
> ensure pending items are removed when the transaction is aborted.
>=20
> Reported-by: syzbot+55d1814e49f1fc0ba542@syzkaller.appspotmail.com
> Link: https://lore.kernel.org/all/6af131f2.44d55313.247daf.0001.GAE@goog=
le.com/T/
> Fixes: 2adc75d61203 ("btrfs: move btrfs_kill_delayed_inode_items into ev=
ict")
> Signed-off-by: Yalagada Pavan Kumar <pavankumaryalagada@gmail.com>
> ---
>   fs/btrfs/inode.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index abaa33471456..397aa64b4816 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -5623,8 +5623,6 @@ void btrfs_evict_inode(struct inode *inode)
>   	 * the inode update is released.
>   	 */
>   	ret =3D btrfs_commit_inode_delayed_inode(BTRFS_I(inode));

What if btrfs_commit_inode_delayed_inode() failed but without a=20
transaction abort?

E.g. btrfs_alloc_path() failed inside=20
btrfs_commit_inode_delayed_inode(), then the transaction is just ended=20
regularly without aborting.

In that case, won't the btrfs_kill_delayed_inode_items() call causing=20
problems?
> -	if (ret)
> -		goto out;
>  =20
>   	/*
>   	 * This drops any pending insert or delete operations we have for thi=
s
> @@ -5634,6 +5632,9 @@ void btrfs_evict_inode(struct inode *inode)
>   	 */
>   	btrfs_kill_delayed_inode_items(BTRFS_I(inode));
>  =20
> +	if (ret)
> +		goto out;
> +
>   	btrfs_init_metadata_block_rsv(fs_info, &rsv, BTRFS_BLOCK_RSV_TEMP);
>   	rsv.size =3D btrfs_calc_metadata_size(fs_info, 1);
>   	rsv.failfast =3D true;

