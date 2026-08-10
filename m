Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4763348C4C;
	Mon, 10 Aug 2026 23:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786403799; cv=none; b=cHAHQn7FyAL+1KcKJYey6hYLdxLxE5/Dh4YkKuiw/56uEoYBuOTJ95fEkDG7aSAH2A00qDfTSIs6JAJFRXPaqMQxtII6WwvviqZ+TP/7HAx5NOyln09c4M3qbKg9CyGooeUWWrz+JdCt1ag3Y9TjaABypa8u81lhN1BO5sfY3DY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786403799; c=relaxed/simple;
	bh=whcLhE+7xItd8tcpdXUmvIZ+pvnbSHdkOL0JLiwtqdk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C1whBTT+kiQva4h8i1prEu7ECqQi/XOfjsOJRn9Sage5WSMnHEfl24QsP423Ot+B05do7kRJwQpKicC4c/Sj+3koUhVWwoHvDX6q4b8cVrjqbDvzAx2ZmOxO20FlBbrW80BJ0J68RHtSDaLe8Dd7vYec1sMDNoOv0LOwVFFgOoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=rpdahpJt; arc=none smtp.client-ip=212.227.15.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="rpdahpJt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1786403788; x=1787008588; i=quwenruo.btrfs@gmx.com;
	bh=RHvpnM032Gm8cnxCu4MZF10G/1kr1RgwviEuzsQucXE=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=rpdahpJt52p0b7aPpe9wnP+sIe6/TdgAyMJHTz7qNx3ad0+JKeNuxctT6K4kSFaC
	 8PmmvjNdfDst/Iwvgdg01tQMKo4BeM0CuC9h4QYF4UMMI8v66Oh4CW4Kj+HHoaIfD
	 SMgbBnrHYd8/JhULFMmy9ytvvk9N6olgKhxpr+EbcVdd43o7rv9CPWuTl6qElBwzB
	 JiEY1R8S5alZX27RCTKOBT6LJVu/QmevtyXkZS01VVvz7/nhF67RH31RAUj3sjmRE
	 4IZXMjS1mLrBF739KAgLlPg2WRidpl61apfRBmWJygy3YtYpoy+SgfLfWi3A8Tr8m
	 DhG23bwDSZEJmBfQ+w==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MZkpR-1wPXlU3z6d-00Tlbn; Tue, 11
 Aug 2026 01:16:28 +0200
Message-ID: <b3dd9bf2-7318-43dd-87c1-a72b979eb796@gmx.com>
Date: Tue, 11 Aug 2026 08:46:23 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/3] btrfs: fix failed sprout device add rollback
To: Guanghui Yang <3497809730@qq.com>, linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.com, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <cover.1786358930.git.3497809730@qq.com>
 <tencent_AD274BC8BB1B11444FCC2955080F81A2BE06@qq.com>
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
In-Reply-To: <tencent_AD274BC8BB1B11444FCC2955080F81A2BE06@qq.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:iIQ6iHl0I7fCxUw4O0vljU4o+dTASoiJBnbqdE814hfpM5hr7cB
 Ig74b3Q8/Uf3/tLGaziVOhhd2sMW4f11z9b0XVIQOtb6aN3rWdiEwVvDmSaORMNn31Mtm4Z
 YftVehHA3Xmf+p8nxchooKwwG78LnmliVGi1JYREuRhM+s/H1KYLmALD1LSd3QcjtBtzHc5
 gUe+QeiLhiGLM1Xd014Iw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:5b7VRJ9FHhc=;/fmph2RR8VnpF6/EpOt4FCtE8PJ
 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



=E5=9C=A8 2026/8/10 21:46, Guanghui Yang =E5=86=99=E9=81=93:
> Hi,
>=20
> This series fixes the error path for adding the first writable device to=
 a
> seed filesystem.
>=20
> I verified the failure path locally in QEMU with null_blk and a seed btr=
fs
> filesystem:
>=20
> - create btrfs on /dev/nullb0
> - set the seed flag with btrfstune -S 1
> - mount the filesystem read-only
> - run "btrfs device add -f /dev/nullb1 /mnt"
> - inject -EIO after metadata chunk creation in init_first_rw_device()
>=20
> Before these fixes, the injected failure triggered:
>=20
> - WARN_ON(!list_empty(&device->post_commit_list)) in btrfs_free_device()
> - a NULL pointer dereference through btrfs_show_devname()
> - the sprout fs_devices state left with no open devices
>=20
> Without the injected failure, the same device-add path succeeds.
>=20
> AI disclosure: AI assistance was used during code analysis, patch
> development, and drafting parts of the commit messages and cover letter.
> I reviewed the final code and local validation results and take
> responsibility for this submission.

I mean the assisted-by tag for each patch.
I'll add them when merging using your last disclosed one.
Especially you seem to intentionally leave a blank line for=20
"Assisted-by" tag but filled nothing.

Hope you are not pretending to find all those bugs by yourself, not only=
=20
for btrfs but also for all other subsystems you're going to submit patches=
.

And tell your agent to add the "assisted-by" tag or read the=20
"Documentation/process/coding-assistants.rst" file.

Otherwise the patches look good to me, and will be pushed to for-next.

Reviewed-by: Qu Wenruo <wqu@suse.com>

>=20
> Changes in v3:
> - Add AI assistance disclosure to the cover letter.
> - No code changes.
>=20
> Guanghui Yang (3):
>    btrfs: detach failed sprout device from transaction update list
>    btrfs: restore active device pointers after failed sprout
>    btrfs: roll back sprout setup after device add failure
>=20
>   fs/btrfs/volumes.c | 43 +++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 43 insertions(+)
>=20
>=20
> base-commit: 38fec10eb60d687e30c8c6b5420d86e8149f7557

