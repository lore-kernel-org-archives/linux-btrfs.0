Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794930627;
	b=nABIgQ8Ge4lVrU80+T1UpNW/lIeEVOBEacBfeSSh4GsZMXwRUv1G6zLX0Wm2PnSu5fw7
	 TPIYME/VWOPseZukaCxoXwfo1yqoZi9zUhhfm68C7xWZN1eJ5lyR9D/XCAS1PSngh3G8p
	 QOU4PmCFYoIOSKnz4fER3stD/9I5gsIwGdZG5XYAkEW9oEThDorB74nwSNFei9ya2NWAZ
	 DV+bfuVyZGJeEXXS99s4yIF2K/2Z+HjE0NQ/MIriL1GLTzvprAlkAw5QiPVun2bd0cBS5
	 nHbDYWy8j5VuFnns8MuCDkPzhZON8I9y69iNfYchdPXUHgKsUDASEkiFgQQ5f8lauHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794930627;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=6gUxlucUqiWrwK+PwYnkWBeXkLUxPIC3/V/otsal1ME=;
	b=hZrf9mJddOvz+21K6yU8snwM+1FcQZZ6ubSC0gSxJfrAqsjLn+l1N+SC6B7hOjMoylu0
	 27PL9ffdm2RhXrdqINTWff94kgS+NTSiScrbCfWM8GFS8jHSa7ugeCdV59Vv1ztl7GP8E
	 Lgud4afEwKbNahZ+Fiycgx3HMGjefQCsJh8PzqvPtDwL6mHMH1lKXPNMb8Ba9LSmGr4CI
	 pFdN0ksOQFWUFTKlqbf3ErXOqzn6pj/EcxqZZzJxHzqAMkbrn/xwktb8uiu8aNca/iIAs
	 4ut14NXORQ3T1EINIhc2RvRXJmT7zrnkwwFjeqBaj8jjbng5vdVzLPuzwJuIxnhChUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ki8cqMwg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D62DF606A890
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 15:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ki8cqMwg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 871791F000CE
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 15:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794930627;
	bh=6gUxlucUqiWrwK+PwYnkWBeXkLUxPIC3/V/otsal1ME=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Ki8cqMwgrUr6fJR26bpylLa4auVMFvBgYEtIHOLD6EnjPGsFoRPUuJHE9pt5x8Jy/
	 e9+ibYalVuEhKA4j8Hott+FnwmO0ppA2TEHU9N3DSCZlGXnCrSdA4G744kjDewd7vo
	 epOmA2XeW4sBkkeTkcj5IITZHbAQjy7nm6xzB/OSn28kQYsIVSd30s+ubGkojOivgk
	 APjOvNyrRBWZ+8kZXKgZZVGoxR/cw91FX4uhGT7isZ4cYKQfNDuLAD7oXAQumE36p1
	 kLCnCZym1engdPyxxjL/W09Y4xdgiac3FB8UH594qrsFNR6pJW9HDbyngVN/QvMH5B
	 JuAgwo8GFhdlQ==
Received: by mail-vs1-f45.google.com with SMTP id ada2fe7eead31-7cc91ddf447so1657028137.2
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 07:50:27 -0800 (PST)
X-Gm-Message-State: APuU4Z9F9/Hev6ChPPiFCyetEDvZDxw93e31a79EI7ltDPaPofMTQ+SE
	1DFi9PgmeDaOTa83RPPe6+N3UVXqHnzyhfAK41lcXfwAy9sQiU+KRgqUw92zVakinjKf5k6mK3x
	ntJ5tAYJArBCvVs9d8UmuoCEsV2uMk3E=
X-Received: by 2002:a05:6102:508d:b0:7c0:1d48:b2a2 with SMTP id
 ada2fe7eead31-7d64d8e0df8mr4736861137.31.1794930626703; Tue, 17 Nov 2026
 07:50:26 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <cover.1794864101.git.wqu@suse.com>
In-Reply-To: <cover.1794864101.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Tue, 17 Nov 2026 15:49:50 +0000
X-Gmail-Original-Message-ID: <CAL3q7H4dDTjzuHkccHi0_Kqyxs31A69fPR4Qx9-DzFoxTEKM1w@mail.gmail.com>
X-Gm-Features: Aa3M54qnfP6RxYY6opyrjgTJVW0_H3jw6ZqfHNLm5fTgqJHb0vEVXN6FAshpxtM
Message-ID: <CAL3q7H4dDTjzuHkccHi0_Kqyxs31A69fPR4Qx9-DzFoxTEKM1w@mail.gmail.com>
Subject: Re: [PATCH 0/2] btrfs: defrag related to corncer case handling
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 16, 2026 at 9:33=E2=80=AFPM Qu Wenruo <wqu@suse.com> wrote:
>
> The first one is a Sashiko report that we can step into the next inode
> and continue looping unnecessarily. Fix it by re-ordering the checks.
>
> The second one is another minor corner case where if the defrag range
> starts inside the last extent, we may skip a valid defrag target.
> Fix it by doing the backward search properly.
>
> Qu Wenruo (2):
>   btrfs: defrag: break the loop early in defrag_get_extent()
>   btrfs: defrag: fix missed extent when the lookup lands on the next
>     inode

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Looks good, thanks.


>
>  fs/btrfs/defrag.c | 25 +++++++++++++++++--------
>  1 file changed, 17 insertions(+), 8 deletions(-)
>
> --
> 2.56.0
>
>
