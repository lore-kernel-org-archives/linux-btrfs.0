Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 784363C09E3;
	Mon, 10 Aug 2026 11:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786360576; cv=none; b=e4pUikfhh31+I0eW53cxbS4lkB8Pa5lKQwge7zFuMCZGOF/eM5DPjXSWsB3jlBxRxAv6EMVfhobYlNyt8LdWBfjm1oNRibChldQ7a1emHlYD42Cc5F/4rljZHGZOp2kttb8pca9j6zzEPr5FYmL9XYBCNBlQbFfEfgV4Hnh9Py0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786360576; c=relaxed/simple;
	bh=Id94ze8NVCkzptaiZorhexDFy0n8AFvsZyVK9riCV8o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bXUfCCUgcN258KnEGp9tCGXVVWwWe5ESGoZWSjV6lPZHhzqb+awGnH9h/0YVWmp8eTb+iLNZ+FV+Env633Zt7GCiAVE2UuKk+keqWrFay6IU+lduTsiIzQTSdY4ILE7okOnEdt4Kzp83Ghf8D/upQzRSMYjHTjFB+aGa4PAle20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=pDuTbNfk; arc=none smtp.client-ip=212.227.15.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="pDuTbNfk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1786360564; x=1786965364; i=quwenruo.btrfs@gmx.com;
	bh=TowFgdwIt2wfSqxTm830KLeHp63FgH7yNq3A7DEdn/o=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=pDuTbNfkIIP/vj62Iur57Nkq+UvNI6461GvdAmSilE4reYzRweOHYl5QHleb1VNa
	 HGXZqyPPAYVLQICyMhXdA9MDXKijVXgoCoPjSap8QKipfBLEue81ifUHNvfUwN/Sl
	 zaCCo0qvzskRMZVr/2bBEokxq+ihpivvHKWh+KHi3rGqpUHc/1Mr7g0v1O+hbDkwE
	 P/W4GZG7VL2gN2NmvOFkpdIQ7onXdZfVLMEtRM2D2oSTGmxqWsgMJGvoW1UDbGafY
	 IytmLrEeSPSt9ninNcL7v2X4ORXlApF/ATc2+O8oJJQmuYqnyQFUWHegaAzPJDK/Y
	 5wig/0vNdPIGeeoVVw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MacOW-1xQnnN1vqM-00fCbM; Mon, 10
 Aug 2026 13:16:04 +0200
Message-ID: <df7cd47d-4c37-4504-9b5c-2e9f8e81a4c2@gmx.com>
Date: Mon, 10 Aug 2026 20:45:59 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] btrfs: fix failed sprout device add rollback
To: Guanghui Yang <3497809730@qq.com>, linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.com, linux-kernel@vger.kernel.org
References: <tencent_A4486230A84078C414753C894308DC342009@qq.com>
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
In-Reply-To: <tencent_A4486230A84078C414753C894308DC342009@qq.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:l3EtY7Aq6zMlb08siZNNbBJDoOr1Mo/dy3HDoFz4X5mYhgRljGC
 21RFpjFGlFk0rzhzhZUPmLYxEtk2qfA7GvK40IZ4G8nqtydKZ0uJ1Bm9YqRP+wEKHsKs+7f
 0sV+c2j2a5zy00970xywBXZBj8lDnRJVNKtTpVEAOFNUghCx0i0o6Es6CNwqf8WbEDMPVT/
 byVQJEBI3SuUP6Wcb70dA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:OERPbHxMXKQ=;lbFWxvN6eVFXEptALnt8opBIra6
 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
 qna8Lmw==



=E5=9C=A8 2026/8/10 20:29, Guanghui Yang =E5=86=99=E9=81=93:
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

Missing AI disclosure?

>=20
> Guanghui Yang (3):
>    btrfs: detach failed sprout device from transaction update list
>    btrfs: restore active device pointers after failed sprout
>    btrfs: roll back sprout setup after device add failure
>=20
> This v2 keeps the code changes unchanged and adds the local reproduction
> result to the cover letter.
>=20
>   fs/btrfs/volumes.c | 43 +++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 43 insertions(+)
>=20
>=20
> base-commit: 38fec10eb60d687e30c8c6b5420d86e8149f7557

