Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.15.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792977240;
	b=CKXqMiPLCQBA3qFIXUvvjw3KsySklDeMKM26u+YFuDBBMOXmZ1JNr1Dv0nIggrXyL+uI
	 dIreLHkEATrRq4HGRBupU4zUnY2oxXZmc+eyJzTh6xqNvJz7jDmssmTJvcj85TCF52V+N
	 Tkkc6QOylB01BGSZTswKapkIt+8NSHSJSKx297+ZDXNlGm4NonSUdwoshY6i7v3GJ7ERl
	 d1NcaqmG72pQZ/KYO5+jMwBPL4dj/diC+AzxnbHa5GZ4KXX9t3cu0G9I/b/vjZuOr0Efv
	 SqcBowqztJ4GbfstLShnzeE24Jl6a079P4nbFHWaNsxVc1p88N/R5aB/VEtJLj52PuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792977240;
	h=DMARC-Filter:DKIM-Signature:X-UI-Sender-Class:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:UI-OutboundReport;
	bh=3tztcZ9V+WoMx5fe6Vfs+qt9l9yIbvsO2CHhZ3wz+Ac=;
	b=XS/j/TLzEg8HV5t4wsJMNqr7+AovZdMPMiiuLQw/Z9My4s5KOtsr+pykoct1Xls7CdU8
	 bdQoPZrWPYT7ZnuffsvkiQ9N3nhGqJLGBHGE2lc6OauyV6TWOcmMU0wJBmPURds9Jw+Iz
	 uUV0hce4WuG3C1E83z497+U9prYuctze3oWaMdYdXs7XZ2I8lTkR6W1Jw7BSU1ukBF1R1
	 m9a66mIMTjoIS45PLSN63YFIm9E9OT3xVBpxjWoMFRHpweXvKSjcH6KUzd8btp7Ijqf6Y
	 op09iSBshCmuiSwjdf8eHjAkKmDH7sBnqGomqW3sTouuELOOKLVGTm66/97+HKygYeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=Krv3jpGL;
	arc=none smtp.remote-ip=212.227.15.18
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7652B606A31B;
	Mon, 26 Oct 2026 01:13:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7652B606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=Krv3jpGL
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1792977234; x=1793582034; i=quwenruo.btrfs@gmx.com;
	bh=3tztcZ9V+WoMx5fe6Vfs+qt9l9yIbvsO2CHhZ3wz+Ac=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=Krv3jpGLWQwY+IGHxBwWuREpZkawb0Ctmk5UVICT3+sjZoDC4FRZUfHXyTBgrDtz
	 8bjXE928RE0P0e6s1oor3LEtp67OsgLv6w+3vYP2uWYtPqap3ivGZihQrhahrVMgo
	 vSwyoU3QkmxyfXF0dskrLs6bTep7M9c4wqicQgicMrouaxB2Z67td2sbiVqxKxDsN
	 UJhLupQwFYdEuAW8hbcce21sMD9Y04hMBPH3XQD0GMJhd6Y7y2M0aWvsFOzbkWEe1
	 N+Pv0uDVEyVcHDzSFifRs64IKtiS/dV6IRp5W84yH4aSS/6WXrbzbeCDtNUgAgKjW
	 hxBrwgOEQwAQtHr6mA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1M8hV5-1xH2Xo1Fab-00EapB; Mon, 26
 Oct 2026 02:13:53 +0100
Message-ID: <dd97efe9-91ec-495b-b698-acff1447421c@gmx.com>
Date: Mon, 26 Oct 2026 11:43:49 +1030
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
Subject: Re: [PATCH] btrfs: reject refs=0 subvolume without DEAD in
 SUBVOL_SYNC_WAIT
To: Cheng Yongkang <teel4res@gmail.com>, David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261025180258.349175-1-teel4res@gmail.com>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
In-Reply-To: <20261025180258.349175-1-teel4res@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:vYvjP+NvlMz2HgBgkrpegdfjKTwoiDmN1dNbOW6WJz85IbF9evs
 T3YxihGW6enHxN5NzoWhCw+yXFHOkUo0ZhjY+0ElviGhFA8OSSPLr6rdEWQ/4l72rlHsn6R
 zWORwJ/FQpU8xj1fr+J/shRjJeOQESpZC2vBxtwoOHsnM0otGywxTFMOU3vXcOmAY5eyMMa
 nWSEoRyDGSsDEBiM+yM/A==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:7GZtPI2hl6g=;OAp1XN7duCNddcAUdq08e7o+InL
 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



=E5=9C=A8 2026/10/26 04:32, Cheng Yongkang =E5=86=99=E9=81=93:
> A crafted image can leave a tree-root ROOT_ITEM with refs=3D=3D0 and wit=
hout
> BTRFS_ROOT_SUBVOL_DEAD, plus a matching orphan item.  Mount accepts it,
> and btrfs_ioctl_subvol_sync() then reaches
>=20
>    ASSERT(root_flags & BTRFS_ROOT_SUBVOL_DEAD, ...)
>=20
> which is BUG() on CONFIG_BTRFS_ASSERT=3Dy.
>=20
> Return -EUCLEAN instead of asserting, and log the inconsistent state.
>=20
> The ioctl BUG was reproduced in 2/4 baseline boots (the other two lost
> a race to the same image's unrelated cleaner WARN).  With this change
> the ioctl returns -EUCLEAN and no BUG; a normal btrfs mount/write/
> readback/check regression passes.
>=20
> Assisted-by: LLM
> Signed-off-by: Cheng Yongkang <teel4res@gmail.com>
> ---
>   fs/btrfs/ioctl.c | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 576cd76..00eab0b 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -5149,8 +5149,12 @@ static int btrfs_ioctl_subvol_sync(struct btrfs_f=
s_info *fs_info, void __user *a
>   			return -ENOENT;
>  =20
>   		wait_for_deletion =3D true;
> -		ASSERT(root_flags & BTRFS_ROOT_SUBVOL_DEAD, "root_flags=3D0x%llx",
> -		       root_flags);
> +		if (!(root_flags & BTRFS_ROOT_SUBVOL_DEAD)) {

Use unlikely().


Secondly it's still possible to hit a subvolume without DEAD flag at=20
runtime.

btrfs_ioctl_snap_destroy()
|- btrfs_delete_subvolume()
    |- btrfs_set_root_flags( | SUBVOL_DEAD)
    |- Some error hit, goto out_end_trans or out_undead tag
    |- btrfs_set_root_flags( & ~SUBVOL_DEAD)

Although in that case, the transaction is already aborted, so no on-disk=
=20
metadata is corrupted.

Then someone can still call the ioctl on the subvolume and trigger the=20
warning.

Although this is not a regression, but a pre-existing problem, I'd=20
suggest to do some writeable checks for the SYNC_WAIT ioctl.
> +			btrfs_err(fs_info,
> +				  "subvol %llu has refs 0 without DEAD flag",
> +				  args.subvolid);
> +			return -EUCLEAN;
> +		}
>   		sched_ret =3D schedule_timeout_interruptible(HZ);
>   		/* Early wake up or error. */
>   		if (sched_ret !=3D 0)

