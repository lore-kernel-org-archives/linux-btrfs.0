Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795006133;
	b=PXWvMfXg1OlfPxU8JVoYDXFD/kZyRxnbIPKvexPW+1T2dAfj4CZe2LiMoYzTGCvCjpE1
	 ANrJUnYLKr+Wq43NtgtCCD4mJmEBl7n9HXALKdqZPd0WVzMptmZoONmWQ4bsTKiTrzQsp
	 2L36wCoxzrA6Qh1ROB/ZO+kuov1QVeqtUslcVmAclFUf6qlMErkwF3NRBTavxuIvPZ0BY
	 ZTVOEu+t4X+n+XltiaaB6ohmBGLRFWh2L5gBt7Nc51qPDKHrKYjEKYwtoFl/pOrYucrdO
	 NsyupFq2mReH4aNy405sXEFRKypUv91b48fEY59xAdXrTYyh5kWmeMpaJSHRaVmsoVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795006133;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=ijijt3aMe0TazYPIMfhTGFaR/YWnT+r9LHmUs69Si5s=;
	b=0mo9fsnHxPEtiTBoKlwq7k3AAz9oSeF4AD5nTAs8iQPKvqzwTMljZDHnSuhLqxTTfUDW
	 sTFEzUJIQrqOAtgZ6AFT3pKATyqIKYB2ickpsAUSVolat73O/KMhNqdnFFguj9DJ/LGvP
	 MsbTPE46qmRyhegnaz+lOHmYfXedgnwSgnWhEcVCAWvFhNdqFECyniOHtWCcMQeJ+3bLQ
	 XrvYxYz9lzuHk/YSI4W0Ji7vFTn+tt0r8dYrbGFWXJavp4bDEf2TXj6FN/IoKyLv5cfW2
	 yPT7hlYhvQhsrd/xNWGSgszLMkpfghI5PVvBlNSzpOEQU1NiF++yTT4GRaQ9wS+iX6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hVSkAUs0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7417B606A31C
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Nov 2026 12:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hVSkAUs0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0244A1F000C8
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Nov 2026 12:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795006133;
	bh=ijijt3aMe0TazYPIMfhTGFaR/YWnT+r9LHmUs69Si5s=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=hVSkAUs0wgnWsQB7wbXpakTRyaVVpquyCDcupnP8oCFO319rEgSOLqanJ+lEzoQsD
	 FHnufQ3qsRQsdqS2rQC+1rFK2HxaWY3d3+e1LGZqk9d6bUmQ2OveyOmfGAASxBQqTE
	 0EL5wlOgwWE1jDy3jM5MR/TPdeSni398vNVPKFs39tbAX5MIQf9JKY6CUZTKsvrU11
	 UUB0I1islI/0swxSOo58QuIKPQ9AOR4i/3Ab9Vav38GXWVxR0ckGs+avdszUhOg0bK
	 EDFSgrQyyb7NqLObeis+nWjOk650sY/SxtaWFz7JSMIbhr5wM1LbcdGh7CHFFa+B6A
	 De9UvUwpabVZA==
Received: by mail-ua1-f54.google.com with SMTP id a1e0cc1a2514c-9912c47367cso465729241.1
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Nov 2026 04:48:52 -0800 (PST)
X-Gm-Message-State: APuU4Z8dj1d9xJSTIq93/cOsPuT8dIBbeiGfpzZs46D5gc7mIZ3r8ImC
	O/StYlx14Nl6h0j5xSDNHkFoiQB4926UTaqc7JGWqzd9ECRP9B5v9rZfRG6TE7Tyu6/rcOMceBN
	APTO9duDb7B/OeIVp7ST5fOLDN/AukAE=
X-Received: by 2002:a05:6102:4455:b0:7aa:d0a9:c5aa with SMTP id
 ada2fe7eead31-7d69f7b5db6mr1251705137.18.1795006132179; Wed, 18 Nov 2026
 04:48:52 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <cover.1794951798.git.wqu@suse.com>
In-Reply-To: <cover.1794951798.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Wed, 18 Nov 2026 12:48:16 +0000
X-Gmail-Original-Message-ID: <CAL3q7H40kxt_8REQMYTrJz=uv_j0rtXpmziCUXRBX72UsC=mgQ@mail.gmail.com>
X-Gm-Features: Aa3M54rW4c_PGqP5cIcsUY0r17Xu7VemW5wn9qAiVKeR-tFz_AjqcAqSbELOMy8
Message-ID: <CAL3q7H40kxt_8REQMYTrJz=uv_j0rtXpmziCUXRBX72UsC=mgQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] btrfs: scrub: fix several races which can lead to UAF
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 17, 2026 at 9:48=E2=80=AFPM Qu Wenruo <wqu@suse.com> wrote:
>
> [CHANGELOG]
> v2:
> - Fix the race charts where the sequence is incorrect
>   All functions are shown when there is enough space.
>
>   Also re-order the functions to properly represent their correct time
>   sequence.
>
> - Do not use non-upstream commit number in the commit message
>
> This is inspired by the fix in raid56:
> https://lore.kernel.org/linux-btrfs/20261116001903.63524-1-mc@raidlab.org=
/
>
> And there are two similar cases inside scrub.c:
> - scrub_stripe::repair_wait
> - scrub_stripe::io_wait
>
> The only difference is, the window is much smaller compared to RAID56,
> as most scrub_stripe structure have a very long lifespan, as long as the
> scrub/replace ioctl. Only the RAID56 data stripes has a shorter
> lifespan.
>
> But still it's possible in theory, so here comes the same fix for scrub.
>
> For repair_wait it's pretty straight foward.
>
> For io_wait we have several locations that we submit a batch of bios in
> one go, and pending_io may drop to zero during IOs.
> Follow the existing behavior by grabbing one extra ref to ensure the
> pending_io won't reach zero during IOs.
>
> Qu Wenruo (2):
>   btrfs: scrub: fix use-after-free when waking up the repair waiter
>   btrfs: scrub: fix use-after-free when waking up the stripe I/O waiter

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Looks good now, thanks.

>
>  fs/btrfs/scrub.c | 116 +++++++++++++++++++++++++++++++----------------
>  1 file changed, 77 insertions(+), 39 deletions(-)
>
> --
> 2.56.0
>
>
