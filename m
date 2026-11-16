Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.15.15
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794863378;
	b=xF8Q/A1RXR8clK6MoQT26k29LcQGBnYfZfXlMOvdxhD/gszr/yZWSz/A7PZWJJJ0DCy/
	 CHjMWQmehxVwFM4OjHJFwoytv8r8WJwiUtgs1PUksfV3b7wLqYgW6728zg9bGWNi0SWmS
	 Y+FF6tRkTwhxX0bNFDWAbMsijsJ97ewBS2K69gAPCNbb4sYQPjkUx9CYLx8GHcgH/eeGl
	 ChEYMzVIltJBSReCw6pDIhWzwfyBqZZ/QrwH7CuaVYM42BTQt5Wkx+X6NxvMwOZxSpnGX
	 7nGzPCJWA2ixed5lnJWUi103g5gNQ7SrGaZbYEyeyElHdYUtxsWpFgWxvKg+jv1ATPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794863378;
	h=DMARC-Filter:DKIM2-Signature:Message-Instance:DKIM-Signature:
	 X-UI-Sender-Class:Received:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:References:Content-Language:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:
	 UI-OutboundReport;
	bh=8BfRD0E59iMxBbuDxWxqiPUbzVkuG8EE14XyFue/aS0=;
	b=GqX+FlyQZX4NCDBX2WHBbCrE/cXOrI62EjFTS2CyYcRihFgIORgKS02lT0YQAVvtUDwH
	 S0A6aNBpb/Ov6u/a0KEBq4h/BYTjRCIJ+wdrk5UgNAvQ+6Cz7xFz7RbVH8UA6u7EdGRAa
	 kBeEKsKkqBdyNsLzdv7X3sgi0XqmN86ONOVH/dn838iPLgjvmgFFLKUJYrOYv7r1CY3Fe
	 sNUfJRo+Rr0V6IPRL7Ph8HDfsyHc9IDNYbKvCR8JJZdmGQ6nLAMySmmBuRwnF1oDyUeUS
	 dyIdwSAbgIbxPd32FanOGPIwVXEJnk+dLWB4RmydONjYcxQ1Axcp0Q7IFkvvItnFicQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=XKoFx6Z2;
	arc=none smtp.remote-ip=212.227.15.15
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 668C6606A31C
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2026 21:09:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 668C6606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=XKoFx6Z2
DKIM2-Signature:  i=1; m=1; t=1794863375;
 mf=PHF1d2VucnVvLmJ0cmZzQGdteC5jb20+;
 rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
 d=gmx.com;
 s=s31663417:rsa-sha256:rFbr4baBDiQ53TmVvUzS3Lk9RssK
   1ehJ2ynRE4ZxShK6DhMRNN1TiiV0kJZaipCPTKkX4IaN5Us7TbRgBgAg8T8t2Lye/aNo4hX8rbz
   2QcoHhMvrWvHtlT1HaSo4ZKiATaWtLTNycmTQwDvZJju7VuobNew8UYqhdHjzULQj/9XEZB1daw
   ehN1c/lcuBqzsyrZ/o1xA/lPvMaXwXnXMPjio13/Jf/71pm8sZQNp4PPPhTrcQS19HU5Yp0+PaE
   BHZJmjjVMO/nAitkpoTI7/qvhewqS74yFM5plwzUtL0d7NDg2e9360c3RtX+ilEVHfqxqP8O/LQ
   rj/YcMSRFDvcPQ==;
Message-Instance:  m=1;
 h=sha256:
   qMcaukxrbS3fpCwAUBFWeQEYcdW6FFQ1kd6oqRTHNuo=:
   ehZnRXcDo0YoGw4jpgHLqcjDOKGMbZZXDAX9NiHc6r4=,
  sha512:
   xTCE5V6dqu7Eyny7lurf9/JrpKM3ieIWDsEB24Yy5wOBUYL1vbpJ8CD5XAvzLNtI42DME/9NwI9b1r1WouzHhQ==:
   C1Izzh5XxgT3mpIYgROGhUZkr0og3uJqIlREQKRVEKu69f9vo6k6xNcwZjYtjyEjMMMyv9RqSy9AM5K7eQtn7g==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1794863371; x=1795468171; i=quwenruo.btrfs@gmx.com;
	bh=8BfRD0E59iMxBbuDxWxqiPUbzVkuG8EE14XyFue/aS0=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=XKoFx6Z2imWEC+5mspGe7/cXcrn6Z9pnLyk6uPNKcGjrq3HSiw5aDUcJUgAVz+VK
	 tK66WLlwzs7MSoWyTMas3K2CRo7ziVkGucrAP7d6aQBoMFO/CqWGjzze2oAq6xm2Y
	 HxggLpooM4nvK3IwAqveVuSDSHtVTVBB4blial5e6BUg5d/VdonCIqyARHXM9CvVk
	 6yO5NykBumydJN7PCn7KUSWEkqs++4I72dyzCTnemJDBIKUOFofVTR+NX0ry3GNpo
	 0DDS5br5MdbUmuXtpoSAd4QPSHqypdTDMMBfSMcNf965CxSg6Eo5mSe0YXaqCh+gk
	 26Td7gVLtl+CSPMlew==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1Mi2Nv-1wpJIA0kmv-00cAZB; Mon, 16
 Nov 2026 22:09:31 +0100
Message-ID: <88943687-2052-4295-b2f3-9a0184d3042f@gmx.com>
Date: Tue, 17 Nov 2026 07:39:28 +1030
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
Subject: Re: [PATCH] btrfs: fix missing device freeze allow on
 btrfs_rm_device() failure
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <31108cde017b75b3f06f1839f3d1f42aa74efad9.1794591257.git.fdmanana@suse.com>
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
In-Reply-To: <31108cde017b75b3f06f1839f3d1f42aa74efad9.1794591257.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:78sjrpHSn/HCo6pzFOkx6eEFeQX0YG6izy/VSZnm1eJrin2dbeB
 tJvVL//G5+OdsIgKRWupp0X6I9fDTangRSuhfPOFQNhU4l4wq6My3aDdrPuFV7UpjQfRYgk
 bEpRzxccE8m/1afgnNhPbUgTYa5z2PzwgvBhFBCbAuNSV137Ws4Tdct7p/Vgs2QpGUE3Uht
 6FZL86dWWZqfZF7KG8I8Q==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:v3PrJkpLzLg=;jjEvcn198Yems7TmLMXWzD2D+M3
 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
 VMD4sByz/+5gBl2



=E5=9C=A8 2026/11/14 04:04, fdmanana@kernel.org =E5=86=99=E9=81=93:
> From: Filipe Manana <fdmanana@suse.com>
>=20
> If we fail to remove the device stat item we return without allowing bac=
k
> the device to be frozen, as we previously called bdev_deny_freeze().
> Fix this by adding the missing dev_allow_freeze() call before returning
> after an error from btrfs_remove_dev_stat_item().
>=20
> Fixes: ae5067f1533e ("btrfs: deny freezing a device while it is being re=
moved")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/volumes.c | 2 ++
>   1 file changed, 2 insertions(+)
>=20
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index f128115a3a3b..590d9bd4130c 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -2441,6 +2441,8 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info,
>   	if (unlikely(ret)) {
>   		btrfs_abort_transaction(trans, ret);
>   		btrfs_end_transaction(trans);
> +		if (device->bdev)
> +			bdev_allow_freeze(device->bdev);
>   		return ret;
>   	}
>   	clear_bit(BTRFS_DEV_STATE_IN_FS_METADATA, &device->dev_state);

