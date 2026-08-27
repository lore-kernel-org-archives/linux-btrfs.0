Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EC1D30E85D;
	Thu, 27 Aug 2026 08:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787820064; cv=none; b=jXiHumK8d4kpRm4oAv0Uit23AQmLEbCAl34GiXGljAYirPG1LkKwsJCq0T89KZqHncIyb+8KreSUKyhq3HiYzAZdMP6mZ14FYxnWbQEkryH5s9iC9Zy4pRj7Xd2YSo6MINqXNZ+psMyknnf6cWtZo3dXo8tYYRiL77u/psIR8j0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787820064; c=relaxed/simple;
	bh=dp1O+BXLR5VAEre6zsN4XRokrdgJD8Pw8/1YoajT7Jk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PvGIP0xHDQvSIfUEgigqEF02ONM8ZnKKlK3Xg14gLzctAXbiC4iWeRtj783K1oBKa5V0t4K0UhtvPe9oU2mHgPlftczJJ8WbksG6YphxzkYBuOAn4IMwODZ2Q+e4yydOU5ESe7NKUF+FC0gNVkfclyupVC3hBEr0spomEtrzRi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=Ygw7JBpv; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="Ygw7JBpv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1787820057; x=1788424857; i=quwenruo.btrfs@gmx.com;
	bh=gsbOJ4o6UZc4wHzpEVx5VhXCirULfjENt7MUi5r62mA=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=Ygw7JBpvglUw/lrGQo7QirjzaO8fLPhK9Wzs7g19l4IS/ZjhEY8V6uPjoSeEHwBF
	 YPCxuT8YbupMKgEM0jFQ7WPKAmeU8GxC/eseqJvny4SVz0tcASXH4QuVPFZI9i5Xt
	 ICww0xfVWvrzWQNGYszS5eq5PLggo5W416/KaJ8av0/BLruoderLTy1210yKh4hHr
	 28MTwNQKpTBP/ApupKJWUfQZbxYzfDO8bi+f3jGOk60m60ua1Xj78BpfKxfG+egt/
	 XrefsZZMAP1QwUfuA7Ov91tymto8Oe4FhBviVgMch36t/P58hknsKX/yGWL6ckowS
	 1zzA19rTysJE2Jc3kg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MTzb8-1xPG1l3ILS-00O8lW; Thu, 27
 Aug 2026 10:40:56 +0200
Message-ID: <51bd5680-7990-496f-8223-ceaa9d1af30e@gmx.com>
Date: Thu, 27 Aug 2026 18:10:49 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: zstd: fix lost wakeup when waiting for a workspace
To: fy15309206903@gmail.com, Nick Terrell <terrelln@fb.com>,
 David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260821-btrfs-zstd-lost-wakeup-v1-1-84f358d4ea67@gmail.com>
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
In-Reply-To: <20260821-btrfs-zstd-lost-wakeup-v1-1-84f358d4ea67@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:ALKAYY7dt7ONsUu9EASqKDZvqJlbluRpJK9+jRKAOeJnjoRuWy5
 8JxDWbxESPG1THiZt/NYS7+y4tVXclnm5tU4a7FJS2Y5FYaSMiTDuv95MHcBEJVpQDE7zEm
 hfvmwnB3kklZZSRtzVFB26X/WZhgovWlvx3h/FIHdRAaAV3vzR/cXmrIw/wWT7DLH75yOWu
 2LZ8tUUYqCJe833PiHgxA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:AzSPegN1Q1k=;39N6KuMk7aA54h88EHsvlCvnO7T
 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



=E5=9C=A8 2026/8/22 03:20, FAN YE via B4 Relay =E5=86=99=E9=81=93:
> From: FAN YE <fy15309206903@gmail.com>
>=20
> A writer can sleep forever in zstd_get_workspace() even though a workspa=
ce
> is free.  When zstd_alloc_workspace() fails, the task is queued on
> zwsm->wait and schedules unconditionally, never re-testing the pool.
> zstd_put_workspace() publishes the workspace and then calls cond_wake_up=
(),
> which only wakes when a sleeper is already visible, so a workspace retur=
ned
> between the failed allocation and prepare_to_wait() wakes nobody.  The
> window is wide: zstd_alloc_workspace() goes through kvmalloc() and may
> enter reclaim.
>=20
> Only a max level workspace triggers the wakeup and one is deliberately k=
ept
> allocated as the fallback every waiter waits for, so once its wakeup is
> lost the writer stays in TASK_UNINTERRUPTIBLE until some other task happ=
ens
> to return one.  Re-check the pool after prepare_to_wait() has published =
the
> waiter, and use the workspace if one turned up.
>=20
> Fixes: 3f93aef535c8 ("btrfs: add zstd compression level support")
> Assisted-by: Claude:claude-opus-5
> Signed-off-by: FAN YE <fy15309206903@gmail.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

> ---
> Reproduced under QEMU/TCG: CONFIG_FAULT_INJECTION_STACKTRACE_FILTER forc=
es
> zstd_alloc_workspace() to fail exactly once and widens the pre-wait wind=
ow
> to 400ms while six concurrent zstd:15 writers race it. Unpatched, a
> btrfs-delalloc kworker hangs in zstd_get_workspace()'s schedule() (hung_=
task
> warning, >120s); the identical race against the patched code does not ha=
ng.
> Compile-tested (W=3D1, x86_64 defconfig + CONFIG_BTRFS_FS=3Dy).
> ---
>   fs/btrfs/zstd.c | 11 ++++++++++-
>   1 file changed, 10 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/btrfs/zstd.c b/fs/btrfs/zstd.c
> index 86919293fd54..cb15cbd737c4 100644
> --- a/fs/btrfs/zstd.c
> +++ b/fs/btrfs/zstd.c
> @@ -307,8 +307,17 @@ struct list_head *zstd_get_workspace(struct btrfs_f=
s_info *fs_info, int level)
>   		DEFINE_WAIT(wait);
>  =20
>   		prepare_to_wait(&zwsm->wait, &wait, TASK_UNINTERRUPTIBLE);
> -		schedule();
> +		/*
> +		 * Re-check after being queued: zstd_put_workspace() only
> +		 * wakes a queue that already has a sleeper, so a workspace
> +		 * returned since the failed allocation woke nobody.
> +		 */
> +		ws =3D zstd_find_workspace(fs_info, level);
> +		if (!ws)
> +			schedule();
>   		finish_wait(&zwsm->wait, &wait);
> +		if (ws)
> +			return ws;
>  =20
>   		goto again;
>   	}
>=20
> ---
> base-commit: 531ed942bb0df04f6747983fecdedce76a22d07f
> change-id: 20260821-btrfs-zstd-lost-wakeup-0b0ee88ed52f
>=20
> Best regards,
> --
> FAN YE <fy15309206903@gmail.com>
>=20
>=20
>=20

