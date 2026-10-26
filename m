Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.15.19
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792976463;
	b=xEBonkP6vLlO/j3glCYTWSUpPo0jwD9ZoYMhgkeiQTMlhqG70kqlkKimIDhot50btAb8
	 O+z7TgNd4wwYPD0Pg8O1OOh+AL9TUmGfy57I0Wi9IaW5wDZ6vbDW69+QREZwYwj4GFuXB
	 0QNIUvHrpLnb/ABYBm3AkpRqPYlxGXky+hRqoysbHR+Q2iI5uH1UabdSNcpgykg42Ofvq
	 LKYjqdqyr+3ILOyok45IQXmhiAd9zpKueHNo7XKUNNYZLHYQo+UTZUgBuxOIKL8KBTDXv
	 tHvUilm+Zg6lcFKlsJx6ulNCk+oMdNWx3aHTEqjV7ZBlK7S7dQWP4QylrdFMEBUO1QQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792976463;
	h=DMARC-Filter:DKIM-Signature:X-UI-Sender-Class:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:UI-OutboundReport;
	bh=VJETL2XTyF8u0Yh6/O9tO6IFbmCC1b90RwY7NCIWW9c=;
	b=VA6OU3R+MxeDpsC6I8n7IwwT05wpKYEdk5yTV2ke0zHsAtMdhJXHxzoO6XKuU8s17RX5
	 dwpfepkVkUven95naWGt9gqLtiCuBDtFjSyYyejZl43OIuJjW9hOpwpWT/WXzIj2HRNZq
	 pwVDA0edJmyLDXPd2Fi7Rm2B9u/vvFlIJ3UbLLPZdbHAp0yIm/sXDqn80OKtzH5k0wHUT
	 LwqFJLs47SoSvHFy1vZV0JAcaMyDODkekqVqRqs4hqPWzW3+LMbLe5wkNEsdCk1dQDiPO
	 9ZihSgxjtpEGqLvAJPoJFTgPzwUCH8t1ED/+HyY3l4cIClonGPsehW5O7HnLYg8lwrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=Immy1JzM;
	arc=none smtp.remote-ip=212.227.15.19
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C73606A31B;
	Mon, 26 Oct 2026 01:01:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 13C73606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=Immy1JzM
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1792976459; x=1793581259; i=quwenruo.btrfs@gmx.com;
	bh=VJETL2XTyF8u0Yh6/O9tO6IFbmCC1b90RwY7NCIWW9c=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=Immy1JzM/45RmMrHJa/zE0hqZFhdGQUmKTZ+HZZ1FPnzGEp25ult4H/OJHkKYTfq
	 PaQi/JH99ukvgKzkTlr796Ao3CX5+Wp8SYCndpLEJNjTPiC/gHXpQSoPCFvx0xUu1
	 u4dmY7u5NzELYepmMys+PasYRXT6Q2EStC4dJTk3cy3p13OCBuclKVyR31/uN6KCZ
	 cs9MWvkLFd/24UznZXfsKi2qHBljv6YEzH7AUNuZtkFa9RjKoecEqv/L1rC+xzzFt
	 YH/1+M8YAiikNhgZ0/VBaJprImliegCgPq946Ap0hJvQcGPxPPS162h3UF3PbWXeH
	 aJXLF7zxMJxsKc3ObQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MJVDW-1x1QKw3ki0-00SruF; Mon, 26
 Oct 2026 02:00:59 +0100
Message-ID: <99a4733b-7c60-4a52-9882-a0aa4f913fb5@gmx.com>
Date: Mon, 26 Oct 2026 11:30:54 +1030
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
Subject: Re: [PATCH] btrfs: remove devid kobject when deleting a missing
 device
To: Cheng Yongkang <teel4res@gmail.com>, David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261025180252.349049-1-teel4res@gmail.com>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
In-Reply-To: <20261025180252.349049-1-teel4res@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:SGze4oB89BVlD0uggjQrOklf0UgX0odzvoAQiKuLdjpcqUhr5KR
 nJPcG0beoTPasuozIu7qiYAD5cChq05bZflmwdQcmEOpfZfv1GnOn5i7ySAs7CVHdefFd0y
 2pXD8fcAj90MF4lVjIaYnzfPbIreuvgNSg0vwm1szioIVUm/+36lK0rqHjtLzRvdRw6TTle
 dUyHvWaC5MJq5keivoOHg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:icpCii373SU=;h7WXZGAsddw0GVacF9rxooWfQ/t
 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
 Bwexe8HMgACC3OD8E7EQN57HYDxARgOSoRx/JfS+AS4TtBvwHophQQqXtqUJtAhOI/DHe+R/0
 Rfg53AVyDxFMfW6sqySJ0u6UXAFyjXjZykreGwIJZXbX0uPYaHNizJxdA9jxb1iL/DZE5KqhY
 GJVhiFHzY+YRKJ2xFapbAap/loqv5/R+vecYS9b1URNQFPwrKn53rwQL65rNdbpNKUlv1dQDW
 447j6lkYfL/1tSvCsFcLcLUxa7zdKSNE+z3RsjUidNUxKc1LcSCSPp97CA9k8slnbI7BWbLqr
 a8jSFPP6A3rzsq8ziCxNNl42Vsvuv/FplObGN3wesrTKqW4z9ZPttXxAKs2A3PU027RYtxoGA
 N+alaGopPKkcW6LyA9uX381E50IXQtLbNwMvlnP95xsZzZeo6Uz1wihTjQFYVbYhMltIlX2vQ
 x0Sf1RfnsgPgXzlBR8cuDqlXrM8az9WbbjtSUUXe5fO/LZwUsc9MDVW5mkwTdNXTT1BKfWOE2
 aWVVyYN8fd6PJIlKW9IQ0ElVaanTBBUEimMQZ5rMvHJ/bnN8ioWsd6XYmivWrT8DrKqFGGxxD
 tpntV4o2HPdoxez3+NtubdmW36KFhjEBXtsgvpoRHMLSG8SHATtFMo582lZwkSA0kOoiztSy+
 ImPyeiPY900+J0LrK4o8giTV3bZWsWur/HqoSoLVU9VTnJW05lVpfjuKRFjdq8eKgUF6tuOQr
 BXOT39egsNTxM1qf/s0VGxyoEqAzgucVZjGTkwUvrdTDeQBJkmXomRMute3CG7tLT7bQjUzz4
 O/iJZiM6NREjhf/03Qkq4XltkgHBSUCNqbDEQD8u5mdpMS3kNvc1Ep37koSjzrNaJWbxi65He
 GjqGmndZNdmN5XlfCWX5+6a8HvIXBwY/J/q2vc0iaaom9kPv795adxzYE0genQX66RizfIH6V
 a8+wL15jG4nsVKTGuduWrOArh5FnhQe1lExxSxnz/kSgFD5DfH+gfgMDy3rjmVK1iwIFe4ZsC
 UoLb9tvYbcY+JkyiM6A8G66CPDQa0VhXzUMOjKb+q3gv+keP06X72cGnxcPEz6pDh6ftqRNfB
 YPITumja0OUYYK894mgRy9LmKQNkHH+GE4UzSh10r1anmPKAgVUGwwQNbd/2F2r0mDpl3MsK2
 QBcrXpOnqMa0Aq75gu5hiUwI8tJLVSoav8nC9xG87k2By2TsowFPILwGB9ZIUO9om1ZrjYHLZ
 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
 p8IGENiv257+Dc57nxDTY=



=E5=9C=A8 2026/10/26 04:32, Cheng Yongkang =E5=86=99=E9=81=93:
> btrfs_rm_device() removes the sysfs device entry only when
> device->bdev_file is non-NULL.  A missing device (created by
> add_missing_dev() for an absent disk) has bdev_file =3D=3D NULL, but
> btrfs_sysfs_add_device() still registers its devid kobject under
> /sys/fs/btrfs/<uuid>/devinfo/<devid>.
>=20
> When such a device is deleted, btrfs_free_device() frees the
> btrfs_device while the devid kobject remains registered.  The kobject
> is embedded in the freed btrfs_device and its show functions use
> container_of() to reach it, so reading any devinfo attribute is a
> use-after-free:
>=20
>    BUG: KASAN: slab-use-after-free in sysfs_kf_seq_show+0x157/0x490
>    Read of size 8 at addr ffff88801d8172a8 by task poc/9385
>    ...
>    Freed by task 9385:
>     kfree
>     btrfs_rm_device+0x11ee/0x17b0
>     btrfs_ioctl_rm_dev+0x265/0x400
>    Allocated by task 9390:
>     btrfs_alloc_device+0x7e/0x400
>     device_list_add
>     btrfs_scan_one_device
>     btrfs_control_ioctl
>=20
> The freed object is kmalloc-1k and the faulting access is 680 bytes
> inside it (offsetof(struct btrfs_device, devid_kobj) =3D 640 plus
> offsetof(struct kobject, ktype) =3D 40), confirming the embedded
> devid_kobj.
>=20
> Reproducer: create a three-device RAID1 btrfs, detach one device,
> mount with -o degraded, delete the missing device with
> BTRFS_IOC_RM_DEV("missing"), then read
> /sys/fs/btrfs/<uuid>/devinfo/<devid>/fsid.
>=20
> btrfs_sysfs_remove_device() already skips the block-device link when
> device->bdev is NULL and only touches the devid kobject when it is
> initialized.  Call it for missing devices too.
>=20
> Assisted-by: LLM
> Signed-off-by: Cheng Yongkang <teel4res@gmail.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

> ---
>   fs/btrfs/volumes.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 85ea9c5..912a1ef 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -2479,11 +2479,11 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_inf=
o,
>  =20
>   	btrfs_assign_next_active_device(device, NULL);
>  =20
> -	if (device->bdev_file) {
> +	if (device->bdev_file)
>   		cur_devices->open_devices--;
> -		/* remove sysfs entry */
> -		btrfs_sysfs_remove_device(device);
> -	}
> +
> +	/* remove sysfs entry, including for a missing device */
> +	btrfs_sysfs_remove_device(device);
>  =20
>   	num_devices =3D btrfs_super_num_devices(fs_info->super_copy) - 1;
>   	btrfs_set_super_num_devices(fs_info->super_copy, num_devices);

