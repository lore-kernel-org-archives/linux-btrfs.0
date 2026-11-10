Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.17.20
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794351372;
	b=dLuzArOerRskIKK5VOap5drVpPkjnb7nHiaBKOsifdNW2nPS3EjOUCFG46BaQ+VH6H0k
	 Zk9LcHfBf8kttKTb2oDNTZvho8Y48YiLA5KvYQQ3iqmw+kluwOpIXYidj/C+q5+lvDYHB
	 i9WQaFVSu1jKlwMZ2Hj1TwyQuarv+8RF1Z6+CUMSWnuCNw1n1vKRztTZiXtExqmwc8ajD
	 51BRPUq4O4+45+Kx540XCEt6D38STnbvMBXlX1NJ3C1UCN9pE7qEqENcBM4v8G6AZ3H0X
	 d9FcNg71pHyWKQsb39JyBHopkywiCj1WaVJvI89pVvKTLwDDRawf3VcsCgOlNsqcOOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794351372;
	h=DMARC-Filter:DKIM2-Signature:Message-Instance:DKIM-Signature:
	 X-UI-Sender-Class:Received:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:References:Content-Language:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:
	 UI-OutboundReport;
	bh=rL9BQz3tKz39fXelKtRhSV4jd4otZrVTT7y3epH0dFs=;
	b=tBxTQFOTtNlbBYpfdI9lAoFxGeqA2rq720Q5Ge3VxZn/DQkGLMNF/ymNIr3P6IeCMpOE
	 ngR/JZ7VxEDpr0Ypn1PorZ+0Ukb/+hShvg/kJ+PT/Z3wiNHJSR/f8BGisU1KGwbs09D8c
	 xlQu2hN2puaxAZFkCZgvGTV6XdLlwrmy7uHZwdT1vLXQ/SXZYdX23cRWZQpQSpZM5Jm+/
	 1fOLAlTlFGKUMDW6aG3PJYU7Ap1HtObJaKFEBNrHAAi51bw4PK9W0jtPTmZfkfWhayK/+
	 epcT4gi4cpjgAljbjU4qbMybAhsbKhPycTU7uH7D7J77W+aCX5OQwzonFQm/Mm7EEVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=C2+8G0Mt;
	arc=none smtp.remote-ip=212.227.17.20
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F97606A320
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 22:56:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E3F97606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=C2+8G0Mt
DKIM2-Signature:  i=1; m=1; t=1794351369;
 mf=PHF1d2VucnVvLmJ0cmZzQGdteC5jb20+;
 rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
 d=gmx.com;
 s=s31663417:rsa-sha256:PMfWsMUsmTULDXwKBgOe4YiKVY+R
   hWMi0+8MaRyFI1IXTRRnL8Hq7eqjuH4cdJ9qJi3wMTsU3JTzKFoW2lOgOr+Oseu6Tsw7P2HUdwl
   /6mSvYa+cFCpuUMp/Wo1TkS5eGcnGJ4pJgLj8jPx5rwByEGmvfsoWzqCJUb7IDmYk14zOt4GAGS
   R/P/bFz2rqnN+GbCm6ciXlrE5+FbEqEExRtwewN/86BirqPmIL5j9rsJNCJqsnzf0hcEV1ZLvAM
   t50S+kodINsCS6ZgyRqvZLfLEJh2a+f695L/XBRKbkktUVE5fV4wMHZGd2AgZ3G9r41QYgAc2tO
   64Cjffu/3o5Gcw==;
Message-Instance:  m=1;
 h=sha256:
   JsOTSpGR/XkJhGuxEMmLrANpxwnNsMJcxOqRPgt8sbQ=:
   zOHCijQgNLtzBKNQRmUK3VXZaQJj2zjWXcMXWdseDaE=,
  sha512:
   x7Pwe0BeSoYunDO02jOCNK3R93qhjtOAJISOuOiF0EbhPt+50yUNEkfKY4p2/v+Z/Y5Kfg1vLMJusDIAu82Q8A==:
   lp0Ctu1wck+Y8Cz/YYA6wK5Luom3o4cqePYh1FSmXB51Jd1Xz6Zu/SNJ+A1cxd+2EfKz5D4errZHwJ+11/IvXQ==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1794351369; x=1794956169; i=quwenruo.btrfs@gmx.com;
	bh=rL9BQz3tKz39fXelKtRhSV4jd4otZrVTT7y3epH0dFs=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=C2+8G0MtovfNKUKjfp2bFrB8J0MprTC7ZnahjTNeqMG1Pw97ANvUfyoXZ5IXU5MC
	 3nidzU7ELFgiAxU/hqMnkAQyYUyhddT+DqX//BHRZJ5qWJqQonAWBOtcHy6EZ8G20
	 FaEMdMbBNroV394BnYMjcZXZ1WbPltFe46E1cNoqnMpWifD1vUlmywgUG15aMNIgt
	 JmkhPppoctG6W5tD24gUE9L3ZuohDFPnOEIBsxGtIS9/hY5/emjN0ZrqSQgCV9XYX
	 g6XDlfTmb2rVjhxY8Hb5YEtu9nZfJGchQYvtXJQzysVguZCvdltZsi2rRkFlJ9RkN
	 AcmQUaKxAYabhIkR1g==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MKKUp-1xBsDI3VWh-00SOay; Tue, 10
 Nov 2026 23:56:08 +0100
Message-ID: <4a15c3bc-eeb8-4ff3-bdaa-bf3dcf9c673a@gmx.com>
Date: Wed, 11 Nov 2026 09:26:04 +1030
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
Subject: Re: [PATCH] btrfs: zstd: fix UAF due to race between putting
 workspace and reclaim
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <e99992bc6c660128215a601d84675ede40930789.1794350146.git.fdmanana@suse.com>
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
In-Reply-To: <e99992bc6c660128215a601d84675ede40930789.1794350146.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:+0d3qIuwbGxXZCzJVwVoZfa9yhm3D0fHD2ODWXR/1XOUqH1xX7k
 eB0KpZ38hc26LfnbbKyTperMYEox+6mwJ2fOxvM/qNdPVyyo4Hw9Tef8GRE2vNTu42GAaBg
 mhXQRpp1eDmagNOvACKVVF8u1yNfooDFX+covfGsFHMOnsx9gyDrpePD0YJU3KkYa7wqFPK
 4wBEqPa/VVlv5LSHeYs2A==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:YFzhbNwS8BU=;kFBTIGn1VrfG9uYst5zuILP/9wN
 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



=E5=9C=A8 2026/11/11 09:08, fdmanana@kernel.org =E5=86=99=E9=81=93:
> From: Filipe Manana <fdmanana@suse.com>
>=20
> When we put a workspace with a level matching the requested level, we ad=
d
> it back to the lru list of the workspace manager and set the timer to
> run the reclaim function (zstd_reclaim_timer_fn()). If that workspace th=
an
> gets used by some other task, obtained with zstd_find_workspace(), for
> some compression level lower than the workspace's level, we set the
> workspace's req_level field to the requested level (done in
> zstd_find_workspace()) and leave it in the lru list without updating the
> last_used field of the workspace. Once the last_used field ages past the
> ZSTD_BTRFS_RECLAIM_JIFFIES value, when zstd_put_workspace() is called it
> skips the lru update branch because the workspace's req_level does not
> match its level, and then it sets its req_level to 0 before releasing
> the workspace manager's lock - and after that and before
> zstd_put_workspace() does:
>=20
>    if (workspace->level =3D=3D clip_level(ZSTD_BTRFS_MAX_LEVEL))
>         cond_wake_up(&zwsm->wait);
>=20
> the reclaim function, zstd_reclaim_timer_fn(), can run, see the workspac=
e
> in the lru list and see that it has a req_level of 0 and an expired
> last_used time, and therefore call zstd_free_workspace() to free the
> workspace, right before the task that is putting the workspace executes
> the code above to read its level.
>=20
> Fix this by reading the workspace's level before unlocking the workspace
> manager in zstd_put_workspace().
>=20
> Link: https://sashiko.dev/#/bug/linux-92b08485-a86c-4bb5-9138-fa80c84389=
f0
> Fixes: 3f93aef535c8 ("btrfs: add zstd compression level support")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/zstd.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/btrfs/zstd.c b/fs/btrfs/zstd.c
> index b686f67d52ec..8756b19f37b6 100644
> --- a/fs/btrfs/zstd.c
> +++ b/fs/btrfs/zstd.c
> @@ -340,6 +340,7 @@ void zstd_put_workspace(struct btrfs_fs_info *fs_inf=
o, struct list_head *ws)
>   {
>   	struct zstd_workspace_manager *zwsm =3D fs_info->compr_wsm[BTRFS_COMP=
RESS_ZSTD];
>   	struct workspace *workspace =3D list_to_workspace(ws);
> +	bool wakeup;
>  =20
>   	ASSERT(zwsm);
>   	spin_lock_bh(&zwsm->lock);
> @@ -363,9 +364,14 @@ void zstd_put_workspace(struct btrfs_fs_info *fs_in=
fo, struct list_head *ws)
>   	list_add(&workspace->list, &zwsm->idle_ws[workspace->level]);
>   	workspace->req_level =3D 0;
>  =20
> +	/*
> +	 * Check if we should wakeup before releasing the lock because after
> +	 * that the reclaim function can run and free the workspace.
> +	 */
> +	wakeup =3D (workspace->level =3D=3D clip_level(ZSTD_BTRFS_MAX_LEVEL));
>   	spin_unlock_bh(&zwsm->lock);
>  =20
> -	if (workspace->level =3D=3D clip_level(ZSTD_BTRFS_MAX_LEVEL))
> +	if (wakeup)
>   		cond_wake_up(&zwsm->wait);
>   }
>  =20

