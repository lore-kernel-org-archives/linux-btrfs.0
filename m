Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.15.15
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794607267;
	b=plmU+N3+/IY6liq2idrpFJNNTSeuG9Y4ra6ll9uDfZAU1WSpOw+gjZMYiXFUuSfDFjHh
	 nkuHdqPLpW1kQeqor7pQ5NVf7wq8ljV7BaOC69hymLxgnY+txOL9OlsirJuAFSCnvd8su
	 risSfMdkzC7anKsOoy86uHXb4GVmyBTGnXj0xce9/At/ikvYHLjTlaKEfg9FvXueoOvWK
	 ujutItuA97wl4h3Xw6Kst88J9THn3yxZ4zVAbeOkH+h/80rcYHSezp7lczKDIftjQfC3E
	 /nuf5N8oFgWHHocxtKoYzJ7iRer9zu0yCIJ8oeFnKHY35otTEidbO2dLAcWDTdiH5YQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794607267;
	h=DMARC-Filter:DKIM2-Signature:Message-Instance:DKIM-Signature:
	 X-UI-Sender-Class:Received:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:References:Content-Language:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:
	 UI-OutboundReport;
	bh=4nrmQoejH7xd/zWHroynLggViRstsV17l61q1NT1pRY=;
	b=0ZSQQeiRxaUkAbavnRmaHq5Dnj8Znq109o56eKldx5qvzhzHg5vwLxc9z+Uyb1YroOh0
	 NRu2uzdOvtB4S4Q+MCCL+fu3FiWSt890hQN+raTZUM1Od+uZ+Q2fX3WA0q9KL0u6YKOYO
	 //PkkDZWxejQuUrISHkaIkb/eF9OQ1u58aCVt/Dzh7Ph84Nrde0vyMNcsF5jDFWVeDEMR
	 ANo24qnAOi7kgzm5QUsh8PydbFKp1Cpi6wbnRhUGag36r1O1l9zv164775hWdJ6GMWBLX
	 IAPNh6lbps1WF9cuwhbc/rMsw/6j+3void727TaWL7XVpQBqep+nVsRz5yUZ9aWo1Yw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=axLLeCz7;
	arc=none smtp.remote-ip=212.227.15.15
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE71606A335
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 22:01:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DAE71606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=axLLeCz7
DKIM2-Signature:  i=1; m=1; t=1794607264;
 mf=PHF1d2VucnVvLmJ0cmZzQGdteC5jb20+;
 rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
 d=gmx.com;
 s=s31663417:rsa-sha256:ooLT+MqJgk4bccS/u4VIg7O7RyFh
   7Y/UCAeaBJk66sph+B0JKhPUagtX1fd2TT9lCaUmz9ngVlbOJgGWPFDx2rNRzu2E0lQkcSP8XxT
   qc4lJlYl0WjLcUejR9Xh0/qcw3GTcjUqXkHjr8hsXM/cniEF56c4gP3/ub+Jx+XtIfcrugIlq+E
   r9OoUpbS3oNNVdoOkRmJTqUhCi+nSXUARcWlNPPIiDmduUY4Qe+z+UU5DavT/FIBckzoMlPXJBK
   QL55Z5qYoGz2Um98vKyHuKCy/JFxNl/Lp1p60tOZnoC+wuq8a8MUplUURQPS3Dx4QBGiP2o+YPv
   UcoPQX1ET5blcA==;
Message-Instance:  m=1;
 h=sha256:
   wHoc58TawaYh/VFoEDnVXOkGKcUKLiDla/47o7kGroc=:
   stPyWNpxnppcghu+jq/Kw5FRDrcofUUYWgW2XWuA1Zo=,
  sha512:
   obZ205U/qLKVhftmNsBTM0Ok2+MFp/kb76E98qrb4rVjH5F9nks2mMt1J/2khDcUZOhPaOdgCTir4EhDap3kzQ==:
   VSy7YedGBCkm4ahjmgKol0oEduCVVrzZTrKlNG7pD36hw86TqQjsShQjVNE6AzaVp5rPUztpIT/1x0fopinROg==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1794607264; x=1795212064; i=quwenruo.btrfs@gmx.com;
	bh=4nrmQoejH7xd/zWHroynLggViRstsV17l61q1NT1pRY=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=axLLeCz78vh+mfjku1OtLj7xHhipUD+Bf87Gc31N8DbBRdduC/y96F+ekpx5ioui
	 uGVklt6nKMz8y+X16nOXlTLgOSU3mB86znqHpC7TDqUtDJ3dEwp4diLvCYeCZzVbw
	 TvfEppf4vhwRF0OWwhgdJ7VFj2Qm3y5YiGJZ4XO0cat0AYHQHyYuww74SzPQZs2f9
	 JihS5E3cpn+V/WroZ+0iRxTJA4WIx095F0HvcP3W0XMunnrbV3lsEB7p6eCXzI/TI
	 +7mNMIlflArwiVZGV0u6LBCh9fP0s38ugzk9m2QhKDQqzJjpurcMmmN6eLHQ8RmwZ
	 aqaqGz7sBNR9ykgdAw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1Mw9UE-1wa1jH1Qgu-00xeYg; Fri, 13
 Nov 2026 23:01:03 +0100
Message-ID: <734e7a93-cd11-430b-a34e-ce4816aac59c@gmx.com>
Date: Sat, 14 Nov 2026 08:31:00 +1030
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
Subject: Re: [PATCH] btrfs: tracepoints: fix wrong order when printing extent
 map type
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <3ee0089580dc34794dc85f9d9850a31038407c6f.1794606255.git.fdmanana@suse.com>
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
In-Reply-To: <3ee0089580dc34794dc85f9d9850a31038407c6f.1794606255.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:rrXrEgciOTIjEOlvdDW/BonJSAs3oC7mFsMJazeQbNnTi/MmE8a
 8+zlmTIK7yZW6effbLs3S8qVxad3WC9GsP3Ce/R0OcL7fhYQuMSn3WZTw4P3Ql742x0AHb0
 t7BJbExSzHd7xr0au3g+HqIAgKPa4AZ4sSvulL8ILOpzfSgAaK5TunITR8vJAf+z+S4bZCh
 KjMOXNYLyKarHlqlk7eIQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:UoQC7EjXRPM=;+uJbbIfUBoiTEbIWqsgG7/DIF+u
 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
 uDYh8r



=E5=9C=A8 2026/11/14 08:14, fdmanana@kernel.org =E5=86=99=E9=81=93:
> From: Filipe Manana <fdmanana@suse.com>
>=20
> If the type is >=3D EXTENT_MAP_LAST_BYTE we have to print a symbolic str=
ing
> defined by __show_map_type(), otherwise we should print "-", however the
> logic is inverted in the show_map_type() macro, so fix the order.
>=20
> Fixes: 1abe9b8a138c ("Btrfs: add initial tracepoint support for btrfs")
> Link: https://sashiko.dev/#/bug/linux-3be22632-2176-447b-b5bc-5906fba873=
a8
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   include/trace/events/btrfs.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
> index 6ecfab97c1a9..dd862d1f2a2c 100644
> --- a/include/trace/events/btrfs.h
> +++ b/include/trace/events/btrfs.h
> @@ -336,7 +336,7 @@ DEFINE_EVENT(btrfs__inode, btrfs_inode_evict,
>   		{ EXTENT_MAP_INLINE,	"INLINE"	})
>  =20
>   #define show_map_type(type)			\
> -	type, (type >=3D EXTENT_MAP_LAST_BYTE) ? "-" :  __show_map_type(type)
> +	type, (type >=3D EXTENT_MAP_LAST_BYTE) ? __show_map_type(type) : "-"
>  =20
>   #define show_map_flags(flag)						\
>   	__print_flags(flag, "|",					\

