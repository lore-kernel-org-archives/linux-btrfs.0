Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793206364;
	b=sPNnvCm40iWhSl0dGME5ny3Kf0i66g5PjGASMv46udxvPvLdzrISbCqo2lWCj/vdNsHm
	 0oJaAVcaoWHd91QFahiCLbSFgn38XD9TCRO124kcTnAclThjZufLM610Hh34lX9TbVPhF
	 T6iOS9n/CpjRSsSwaXy5nCOm9vvZ6RFnbHJXjABKvHUpoKyiLfXL4dV97OIUclsVuBk6v
	 hnbqIJlLQbz5WSrdlA8PaIantvYQCACxZKmAnML1V50tnbH6d8RbPxJCzulmKu0+1ghMe
	 65CvILs3NtV+yZ5/HwJ6LXc/W/QvlYaVcNhacqNeV81XcclmTfc7AhciSGNKR83+YyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793206364;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=wpc7iCC/LNDm9DEIf8Z2u5xVKDp7xq2SKdOl4V25TyI=;
	b=J2osLvSJP3JtuOmF6mROvgyIZmveyTRdhR2atJaKdxO52ZQWO6AI87+Ok9QWAUCXVYrb
	 bCX+ERTjZfZ3KwfBW1QgQSB8wUigQUeN9ugc9YhOv1X6TivWw5FoEfre6uvhwmSG5bylz
	 FIw+lNrN458YN5nQUgusCwkh99Vb3ZLcd6RH2pY+hh+7nF7LdJjNeqN6DjV6BGJAoTy9r
	 /i6ceOPcj22xTP1Wt57s9tiH9HmlBmR2FexoXxODDHmVg3F7zYmlxSLsYgVHl+QGSjMK5
	 6yO+igovkfR7tOXlWpmIUDssjoyZaAWV1v4rF2u0i27rc6a9p4Xr66jbGHiOpcnJwIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PdRJKbnT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A257606A31C
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 16:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PdRJKbnT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94AEA1F01825
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 16:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793206363;
	bh=wpc7iCC/LNDm9DEIf8Z2u5xVKDp7xq2SKdOl4V25TyI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=PdRJKbnT1qyMVZUtBlffaO02vmS1nIQptoLaiGvornTtNHfXxc28gi1DIyRMvNCT/
	 jePaF0UEK6GLBLKUE7v5fMgfklx8QRdmzVGj/Rh7tdcJKKH9Z8y0pUW9T7TQRdACYa
	 x7FZTNA7xDLEfSbYRhmMGTdOXxd1nkS7fVwH9an2CU55z0aTATo558wfpgA4RbfB1q
	 bQR+N3tgmfS2N5/S+NcyC/oWi31k3IROwwfFnuihSAyF5xajpGQp3yLO2D+0OEgZjT
	 CqO+jl42AiHg70lC/KE7P6oPMBj1ReDvHpDKCsZoJJZS3DkSrUm9AxaAeXewvXvq4G
	 2SkbD4XjSK+Og==
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-475920b9ca2so398640fac.1
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 09:52:43 -0700 (PDT)
X-Gm-Message-State: AFq9FYIazZGLdeAuTt2QJ7jC6v36pmwfibwug7EFtCo75xEx7hOMYiNO
	MzE50mf0L7LbZtwJrPpTMT4Wt5XlzpKPxFjWVrLtj6GMzT/6qss0qG5g5sW7mPCNrKEC8WqIgw5
	xDNaVuXH8QHsoWCGmqjnqX1DVn0rQyPY=
X-Received: by 2002:a05:6870:51cf:b0:49b:a2da:91e1 with SMTP id
 586e51a60fabf-4a8bb5c5c9emr2124775fac.9.1793206362707; Wed, 28 Oct 2026
 09:52:42 -0700 (PDT)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <cover.1793168898.git.wqu@suse.com>
In-Reply-To: <cover.1793168898.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Wed, 28 Oct 2026 16:52:05 +0000
X-Gmail-Original-Message-ID: <CAL3q7H5K=wdMWFsjV=mP5pNSauLTB6G+16Ro2Zydj2q3m=zyWQ@mail.gmail.com>
X-Gm-Features: AclHuK_b-1zAdhnJWfcRTqa4YyJRjyjhrufI8_EmXj5Ae01HfbvX9V2wGaikNYk
Message-ID: <CAL3q7H5K=wdMWFsjV=mP5pNSauLTB6G+16Ro2Zydj2q3m=zyWQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] btrfs: raid56: minor fixes to rmw_rbio()
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 28, 2026 at 6:31=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>
> I was checking the bio_list_lock usage as some call sites doesn't look
> sane, e.g. spin_lock(); set_bit(); spin_unlock();.
>
> But during the cleanup and reviewing, LLM exposed two new bugs:
>
> - rbio_orig_end_io() can race with lock_stripe_add()
>   And rbio_orig_end_io() didn't hold the bio_list_lock, under certain
>   race condition, a bio can even be missing.
>
>   Fixed by the first patch.
>
> - Failed rbio can still be cached
>   Fixed by the second patch.
>
> Qu Wenruo (2):
>   btrfs: fix racy bio_list changes for failed RMW rbio
>   btrfs: don't cache rbio if an error is hit

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.

>
>  fs/btrfs/raid56.c | 35 +++++++++++++++++++++++------------
>  1 file changed, 23 insertions(+), 12 deletions(-)
>
> --
> 2.56.0
>
>
