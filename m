Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFEE549E5F5
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 21:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789594684; cv=none; b=qkzjSFMJTWeC8pQzDTXLPZGo8OeonIAVS6gS2aG3U2W/KPyaQOsdkzHWthWiXXqDGg0ZWjcA7RmUmoACVnb6ip5f/wZxQy9qQX6An0IeDATMjU1oUUacNZaeQVey2oN45ZHWV2VMzvgnYSscRGfzer2hvfI5Jh3KxORuBA0R0SM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789594684; c=relaxed/simple;
	bh=WIxdEW+0//D9uMpRUVz4dcVT7TpomcjBmQZL4DQxNIc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=S/6y8khUNPcgeCTSwIEHcIVNIJr4QMeioRId8+vIWYLuv881x4hVhw0J6MdW+oNyu/xKE2o3G5SAkfZusbit7siPYExEDwCq5DUAR7ExRZbgG9VqqB1FbsWZp35BLyL3ogwHoZ7N08pr7wh3gwxBNiQtAH7+bIqGpiQIioLAOIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=U3o1x05T; arc=none smtp.client-ip=212.227.15.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="U3o1x05T"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1789594662; x=1790199462; i=quwenruo.btrfs@gmx.com;
	bh=bAr8k/QwAq5C7qtNjPuKECSiR6zrGj5V75aixkLpUEM=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=U3o1x05TFjdWiYmqnjUJu0DoedJ4ypOiHkGSZ0elV4oZdGymrGa20qNB8mwfCHuW
	 wtPYvdFAVm4++shHYvwW32waUfzJHEm/4V7C7TJ6Nf+N7ByOSStC3Kpb6YaJ8AfTW
	 vzVXNIrCbJVF4t9E6vdgVSZvSAxXwaYXMzx6azbOv6djjCEYL5zlDLQtSkiqMOsoE
	 xzl+1vNB2Y0FJ99LaJ7NyLvVC+5HNed6L3jEzufS8RolHx5VWPW/+UfeJBBd9CcaV
	 6JAtJOFxmw23kMhGekoUanIDDDnKnBkyPcc/9sJfWCzhy1TvRA5mL/n0DLsy5EG5S
	 17IlqN9BE6SEY3OgIg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MpDJd-1wRc5a2ewZ-00oZHP; Wed, 16
 Sep 2026 23:37:42 +0200
Message-ID: <3e48c02e-2448-4aab-ba9f-c19f97cb09ca@gmx.com>
Date: Thu, 17 Sep 2026 07:07:38 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: remove duplicate error message when writing super
 blocks
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <9621b3d58ea4af3cece1e00894d0241233fdd59b.1789576649.git.fdmanana@suse.com>
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
In-Reply-To: <9621b3d58ea4af3cece1e00894d0241233fdd59b.1789576649.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:dgO9inj3EKLJQEfcCkd2HQ5rorqC743E1Ow5N9vroEN6x4Z1VO7
 XPzOiWTfF73D3iYTa7Cmmg+oJG1hwr9mrK+XwogUbRaeUz5Wa8/5M12Djq/5YBpsOCcnd8v
 6DvqshLY8cwhKYlTFf2Dlnt/g2+H31TYKR1aLHpfOOcP4AxJqDcGYiviRpfRBdP9KJjmfNR
 VHQMnop2qql5r5toOLRNQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:cQGkt+n6IvQ=;gF/AZxP+XITTY8Nv1A9QKiak+Pi
 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
 fHVT1qu1EFybZS2no0veZW



=E5=9C=A8 2026/9/17 02:08, fdmanana@kernel.org =E5=86=99=E9=81=93:
> From: Filipe Manana <fdmanana@suse.com>
>=20
> If the total error count is greater the maximum allowed number of errors=
,
> we print exactly the same error message twice. Remove one of the message=
s.
>=20
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu
> ---
>   fs/btrfs/disk-io.c | 2 --
>   1 file changed, 2 deletions(-)
>=20
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 161a7b9bb27a..a8535e309b57 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -4228,8 +4228,6 @@ int write_all_supers(struct btrfs_trans_handle *tr=
ans)
>   			total_errors++;
>   	}
>   	if (unlikely(total_errors > max_errors)) {
> -		btrfs_err(fs_info, "%d errors while writing supers",
> -			  total_errors);
>   		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
>  =20
>   		/* FUA is masked off if unsupported and can't be the reason */

