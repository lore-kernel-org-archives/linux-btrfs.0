Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.17.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793221643;
	b=vYUk0rT2d2nMcBtI8xcMPf4m4Upelm5d8cf0NKEypa4yzK/C6FLuC91gH31MvuNu6aqS
	 Yn2TAy4ok1ljWD3I8/f1Gt15ZPzcWxON7l5ap26IFdKSAVyV+6tej+Tk0nY11ce1O2pUn
	 f/VVbIfFwqlEc4nyvZ8E2mft0jNhXCvn6ZqQw14iMeq5yJmmfanzz50zUuzJwT5d7DM9x
	 JXQ1Lwl7+dApyfyYN+gfSr2EIzk/jlxDZryNMgbCtapZgcsajbpO+GyIvXTScR5fosV1l
	 OJDlberkQRYR4IYn43069lkn89kETD04xOarhBOuww/WCSJ5jaHU3XsxPAnggaotIjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793221643;
	h=DMARC-Filter:DKIM-Signature:X-UI-Sender-Class:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:UI-OutboundReport;
	bh=FKYnHbTgCqwc1IkAPS7CCUPVQ1KIHyP9R7tC+A0uWmY=;
	b=Lr+r/S6heM1ECiecvPo4LYzolPIqpnQAwfMuwiiUgE8xJi8TXGExW5yR4KZ/f967GpD+
	 sDeTxygTtG9TlDfIeE/JpGoK0pjJ70wdvjn9Jk2bnLLlTuNc3aoOW2uejU8eGFKhHEXoU
	 GPvaSYdzhdF3209Jd4Qz54XCQPzr/eLRjDc8Nvj8idMB+LWUQb9fc4YCIRB9JKRVaZTdY
	 qfbDvSGYD1r7M/GayKHZr4cpqUZiVKZqWcQVoitBDr+DjTX0aS/2F1uwoKdIu5fW4UiDs
	 oKm5lvcYAQz1DLHL/oWsY2eOtgPlGIsoOW97Z6DboOFA784mmRGUPbBj4rriEwztZHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b="tTAAd/W5";
	arc=none smtp.remote-ip=212.227.17.21
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B169C606A322;
	Wed, 28 Oct 2026 21:07:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B169C606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=tTAAd/W5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1793221620; x=1793826420; i=quwenruo.btrfs@gmx.com;
	bh=FKYnHbTgCqwc1IkAPS7CCUPVQ1KIHyP9R7tC+A0uWmY=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=tTAAd/W5wuqWN5QtUUdSNQnj2ErlKSLCWmpKepjaU18+RdU5bQEdicGWlK8udQZn
	 cUki8P06jzAScZ48B63AI45F5O1f9XjHwAVfwIb5JfvtzO/72zSYK9RGkg0J1hy7B
	 T4uX7J0VHU6AUfwkUo8AJzQBRqHgspmI2tdkFz488YNWuxxR6uV0VtmhJGWJy4IAF
	 ThAgzxreH6Pka+0IZM0X7SEYU6vSxlPbN57cSPwI3R2xfmcjKG9WWqgZFNtRU23zl
	 sMann5eX9lI03Q/EPpiEHN6u4mMnFnta5GcGKZB1RZ4LBaI0mSxnU3mM8si/5R6zz
	 k62rqWJDX2886S1+hQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MLiCu-1x4VRz31Dk-00SgGN; Wed, 28
 Oct 2026 22:07:00 +0100
Message-ID: <b00f8fc5-89f1-4483-8986-947392837a6b@gmx.com>
Date: Thu, 29 Oct 2026 07:36:54 +1030
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
Subject: Re: [PATCH 2/2] btrfs: don't report failure when trim is interrupted
To: luca.stefani.ge1@gmail.com, David Sterba <dsterba@suse.com>,
 Chris Mason <mason@kernel.org>
Cc: Robbie Ko <robbieko@synology.com>, Filipe Manana <fdmanana@suse.com>,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 Zhiwei Liang <zhiwei.liang@zliang.me>, Qu Wenruo <wqu@suse.com>
References: <20261028-b4-btrfs-fitrim-interruption-v1-0-bf5c53738b3a@gmail.com>
 <20261028-b4-btrfs-fitrim-interruption-v1-2-bf5c53738b3a@gmail.com>
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
In-Reply-To: <20261028-b4-btrfs-fitrim-interruption-v1-2-bf5c53738b3a@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:rFPNKMOZRaKsY3fyKqZbnAiK+DOmLPcPBER/U+Hf/PHLAn8FoxA
 Wqr6OdtwfBt+68egx8vpbw8sSte/HJ/ci1pmh5upz0DmOMet1wpeOvbW8S/ZJrzy/VHdFbl
 xwG7HLgLq1HAO41Y1Bwdq4szpKiEMMwxvyoSdpJHirQ6IgCuu8YTB4D93XiqDBF/epflag0
 cCg5hPcMucmlOq0+UeT2w==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:QjSZZtc/ao8=;iaKATJQWE943F82PDKwXhzktpQC
 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
 Tw13l/PRohgIjl3t/Y2914aPDIRQ==



=E5=9C=A8 2026/10/29 04:25, Luca Stefani via B4 Relay =E5=86=99=E9=81=93:
> From: Luca Stefani <luca.stefani.ge1@gmail.com>
>=20
> Treat cancellation as a successful partial trim as ext4 and XFS do.
>=20
> Reported-by: Zhiwei Liang <zhiwei.liang@zliang.me>
> Closes: https://lore.kernel.org/20261028-btrfs-fitrim-freezer-v1-1-0ad1d=
58aa94d@zliang.me/

In fact you should use Link tag here, for the original patch as a=20
report. Not Closes tag.

Otherwise looks good to me.

I can change the tags at merge time, so you don't need to resend the=20
series, unless there are other reviews that requires code changes.

Thanks,
Qu

> Suggested-by: Qu Wenruo <wqu@suse.com>
> Signed-off-by: Luca Stefani <luca.stefani.ge1@gmail.com>
> ---
>   fs/btrfs/extent-tree.c | 5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)
>=20
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 242db255cf1c..90e581c29609 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -6926,7 +6926,7 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_info, s=
truct fstrim_range *range)
>   			bg_failed, ERR_PTR(bg_ret));
>  =20
>   	if (ret =3D=3D -ERESTARTSYS || ret =3D=3D -EINTR)
> -		return ret;
> +		goto out;
>  =20
>   	ret =3D btrfs_trim_free_extents(fs_info, &group_trimmed, &dev_failed,=
 &dev_ret);
>   	trimmed +=3D group_trimmed;
> @@ -6935,9 +6935,8 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_info, s=
truct fstrim_range *range)
>   		btrfs_warn(fs_info,
>   			"failed to trim %llu device(s), first error %pe",
>   			dev_failed, ERR_PTR(dev_ret));
> +out:
>   	range->len =3D trimmed;
> -	if (ret =3D=3D -ERESTARTSYS || ret =3D=3D -EINTR)
> -		return ret;
>   	if (bg_ret)
>   		return bg_ret;
>   	return dev_ret;
>=20

