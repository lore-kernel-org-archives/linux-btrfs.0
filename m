Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.15.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794607371;
	b=1DuGVI2LbgKhMVMU90L9yqscVSPFwWvnIi5USiyHxROVGJ+J17ySucxR/hmNWDDKZYbD
	 +z+0fUene6ZQ3qqlQy3yWo/wFl3XQ/pLr7BnqS51slCuf4wfCVDVPKnLUkXBgf2ed1T9q
	 Rnjv+I+L0NLhGNb0g/9FRir8kmsODu43S8XyVC4+PVY4zW9yN94X8xozs+OeJ2s/zkrFi
	 7Cl+g60loZeexkBWiIlO61GWKU/bYaHoMdO7k3FUP2PutUL7S5m/9gKhE3RIEQyyWk0NY
	 s4WdiyRP+PZZUZlQNJvheGVbGppfBXk3D4Anru9pdKj2O2RuYHhmVt8xpY2VqUYI6SQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794607371;
	h=DMARC-Filter:DKIM2-Signature:Message-Instance:DKIM-Signature:
	 X-UI-Sender-Class:Received:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:References:Content-Language:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:
	 UI-OutboundReport;
	bh=SEdm9uB4346nrHTDRE8U92VgXmTecBIZTdDYRshbo+o=;
	b=xeAlbok/d7GZAzVRWbE/guHTMRnT6gGO9MLTnFIkOVxWLU6IS6+ahYW6//2rDOKEPlOI
	 b0OrDGo51MGCU3BBlklCRgS+3Uw+VTsbDjSwN8K47JbgWQgVAZL85RfuNTjI4KGrDBOz5
	 YeDMJmxs0h26Q/Zsf+aoVn/DrDlKzswtjKnkQyol4GqY1KHaXfOgifNvMwpexcdth+JhQ
	 bsrMmf08foaETepKFKjoNKyNzDY0vnaDDq2T7I1JvlWFGAskbxjuEiRaN1V81JxoyMYIT
	 1t1+WBBOeT2Kxwl6OOVf2jCh2JD5+Oi7+ejJky4vWlg4NaCPH3ubKLNflF3wrDdDPLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=hvfm+4Xi;
	arc=none smtp.remote-ip=212.227.15.18
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AD2A606A329
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 22:02:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6AD2A606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=hvfm+4Xi
DKIM2-Signature:  i=1; m=1; t=1794607368;
 mf=PHF1d2VucnVvLmJ0cmZzQGdteC5jb20+;
 rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
 d=gmx.com;
 s=s31663417:rsa-sha256:Ivdv/0GZLcmssA1qhxe7BJwTxk0f
   7/8i97U2UHVmjX9xwHGI5wNkQ5V8aS5cd901i0+b2BmKKl+y8FnmMIiMA3yoQopfX713q17WQ0H
   24LM0Rts4E9kP9QvZbhkUPT9P7jooslXQYr3lAUficFLr46zn7fKDwWaVBJ043L4HzQrJLpxqpi
   hdcLsF7c39Frcbvto5rRUBgGxGaPpKsg4dxqKm+MH1Ht/zXgS26y9AbGS0FzsjVyd0zC+9+9viV
   pskmwi/rFKmJTHbYhoWVOY9hsPJFo6yrJJEuijEI4SBfEuQ+EuqdbF0N5958X8owgIvgdzoI30Y
   HLVp0lb7bS4ZFA==;
Message-Instance:  m=1;
 h=sha256:
   fN5AtVnNGpptj2jl4bPVFuGiO6KQHnVqSexjNE4RkAg=:
   vowA67nVK2ycYMJsYDRCxffFnoYAMp16o1KNXGby7BM=,
  sha512:
   K1g6Yv40mwtGUbcOqnCXSA1l7w4YQSeDVp08pUj/iLhy2gc92r6jmtfqMR5E5a7kBZHvM2ovY55irPFddBZulQ==:
   3G8x0gQ96kUBJcwZLiuuixo+AMR/Bgz1e5oRsv5xT/18Zzm9IYIMPB4pG6dpGInpwG1bJ39nLn+JPfnuZpglgg==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1794607364; x=1795212164; i=quwenruo.btrfs@gmx.com;
	bh=SEdm9uB4346nrHTDRE8U92VgXmTecBIZTdDYRshbo+o=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=hvfm+4XiFcXlqUoJjgykPFG/ezpeLKPQf4IBtZXN4f4tUD+uzsSCDWmP7e9N9nGt
	 xs3HARZN8xkuAQvu2AKI+1/MzHfkOXWNstkHwQsfVI5wyITAikKSiehI4Ogd5ipoV
	 6xRbweScDa0OteKTNOp/5E4voGwDHABtkIgvKCpCJVbWtg7Cv78qSV8Aj8cmS2cdL
	 0BDt9b6Jmt7lzf1KNqDTMKxjnkAqP/SkMsbMs4JP1ciqeF9cl6rz57HB/VhQ1jOUD
	 +c7rNvxUoTsR10GyBnlI1SmBmmn+e7q85EwJz6IbddstppV99V5aDJKgCykN+EcpX
	 XxLf8oRcV4fg5KMCPw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MKbkM-1xBYQy1G0K-00M80w; Fri, 13
 Nov 2026 23:02:44 +0100
Message-ID: <46865601-47bc-4663-a579-fe2a742906ee@gmx.com>
Date: Sat, 14 Nov 2026 08:32:42 +1030
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
Subject: Re: [PATCH] btrfs: fix incorrect task accounting on error during
 io_uring read
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <f032850d8109d8a1291c2a6ddf87e78b7a5be337.1794606967.git.fdmanana@suse.com>
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
In-Reply-To: <f032850d8109d8a1291c2a6ddf87e78b7a5be337.1794606967.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:k2P/lBAScBWTMqVglujnY38IZK8icOhj/4tQCJqnKc29JS+MpTG
 w2AzgONfEIQcKnA027PJbx/4U12yvbfVekPsvLxet0lMMPAY3D5QmS6jxBEDHKn2Jy5F0eF
 qDUoCGdzLaahDpd9cpNuDYwR2ngqRydt+B3VmfSpOzZyPSYxb5XJ9DDBLqhxH6OPGuXjumu
 +aI/g+dJtFdq7nICwVVgw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:pJPPeIEsw+E=;QQ49CzNwAvJr3iCAbL45B0ZcH7X
 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
 FeVPN/Ccfy3rUZiJz5UR8E+Mjomsnk=



=E5=9C=A8 2026/11/14 08:26, fdmanana@kernel.org =E5=86=99=E9=81=93:
> From: Filipe Manana <fdmanana@suse.com>
>=20
> We are passing 'ret' to add_rchar() under the 'out' label, which is mean=
t
> to take a byte count for accounting, however if we got an error we pass
> it to add_rchar() too, which is just wrong. Fix thing by passing 'ret'
> only when it's not an error.
>=20
> Fixes: 34310c442e17 ("btrfs: add io_uring command for encoded reads (ENC=
ODED_READ ioctl)")
> Link: https://sashiko.dev/#/bug/linux-beb0369e-eb47-41d3-86c1-e79cdc2de1=
57
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu> ---
>   fs/btrfs/ioctl.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 6cd12f586423..a4de331c46a5 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -4660,7 +4660,8 @@ static void btrfs_uring_read_finished(struct io_tw=
_req tw_req, io_tw_token_t tw)
>   	btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
>  =20
>   	io_uring_cmd_done(cmd, ret, IO_URING_CMD_TASK_WORK_ISSUE_FLAGS);
> -	add_rchar(current, ret);
> +	if (ret > 0)
> +		add_rchar(current, ret);
>  =20
>   	for (index =3D 0; index < priv->nr_pages; index++)
>   		__free_page(priv->pages[index]);

