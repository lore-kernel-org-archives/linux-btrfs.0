Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE5D53939A3
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Sep 2026 14:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790693687; cv=none; b=IVVrfbBJIdHlDATY+jD+0GTe0fRLwbROlfLV0K955ESUcFcf86W9THpiCBdDxZli1NZ5tqF1ouGjRdGdi3zavWgw1aobEMNLt7X10uTVRkE8u03Cc5AqeSZu6LuNIHau3GjqYBhrCs4bJu3Zh9zP1fUV3SnYxD9sqyVy6rHw9Z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790693687; c=relaxed/simple;
	bh=h1+pctqcq1qWd56R87lBN9GIERta4NrA2sbTHn+wKf8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LquZ6/2ONRjIi9jv/i0ob6u36FlHeaB14OSuMPFOvP8v29PYZS32aaU2Z0pVsqxgmdp0/K86mrrAqL+60nvouUfWvmSjNwdbTd8E27M847En5mGb5JtseHj/71C1lWdH3yBtQdROJMy3PuO/Q2HX/EDczYfKgx9E/wTi3yarL2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=len947Gi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="len947Gi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 641D21F00893
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Sep 2026 14:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790693686;
	bh=1qp6xVkVqJX9C36hJHCSy+8L+9fk65wb1hiofnIKcFs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=len947Gi81nm4btcgrQzffVVd3GVs5+N3CXeenNIhCooOfWhGORwXzwxA9FY5SyBY
	 Cuw0FSTQsRjci8G34OQalrHy6sGlR3N6NVdddcClDvMcb2p8aDlBWU8z3pgcn/7/ZP
	 s4wkoqSlgQ2CMAHShuHAM3BoN2+1f45LEWDEazBwjZNJ3xgzMrCqYs9rh8pOUuOkie
	 dx55Ml+n2P9/CPa3dw1DUptH5EK97D9CdvU0LGX2ppaS29DB4kyeoieGToT7hGm0/w
	 AwtjprbASAM9ulkeDxTAEOEQ9DW783KZomhaDaVF9bwjUbN0lqZj+q0E+r0uYBAQjM
	 zEz/IXkAVeV3A==
Received: by mail-oo2-f42.google.com with SMTP id 006d021491bc7-6d8709e0de8so1244832eaf.3
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Sep 2026 07:54:46 -0700 (PDT)
X-Gm-Message-State: AFuF++lss+UOFXyps7Dkn7AYGjgttiBBvVNJrnZW72JCB5il3G9t64ZQ
	7p/FW897LJLwBpabqDdyhFsoosTvNw9FlX9P9VLBfbSmzioE2OMmi3twzOcP6/QNPQYufm2J03e
	UHLMa3gawJzNMi585PXBZBReqcT0Af5Y=
X-Received: by 2002:a05:6820:83ce:10b0:6d7:69c6:5292 with SMTP id
 006d021491bc7-6d769c65376mr4417584eaf.45.1790693685612; Tue, 29 Sep 2026
 07:54:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1790641111.git.boris@bur.io>
In-Reply-To: <cover.1790641111.git.boris@bur.io>
From: Filipe Manana <fdmanana@kernel.org>
Date: Tue, 29 Sep 2026 15:54:09 +0100
X-Gmail-Original-Message-ID: <CAL3q7H5u6ETBx8n29b80PZE0ayxQPOG39K1AXE0Y-7cEag+d7A@mail.gmail.com>
X-Gm-Features: AclHuK_gH-2ZsXoWn8ENFJ7yYFdbk3DoNEG3kXD_AB_JV2qR8Q0nL4PW_J9Lfc0
Message-ID: <CAL3q7H5u6ETBx8n29b80PZE0ayxQPOG39K1AXE0Y-7cEag+d7A@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] btrfs: ENOSPC fixes for unused block groups
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 29, 2026 at 1:21=E2=80=AFAM Boris Burkov <boris@bur.io> wrote:
>
> A few fixes for system chunk allocation ENOSPCs caused by a sudden influx=
 of a
> large number of unused block groups in a filesystem with no free dev exte=
nts.
>
> In practice, I saw this on a fully allocated fs with 30TB of space, a 4Mi=
B
> system chunk (single metadata mode) and ~10k unused data BGs.
>
> - The first patch tries to avoid the condition by allocating earlier for =
the
>   system chunk.
>
> - The second patch eagerly commits a single deletion when the system chun=
k is
>   at risk.
>
> More details in the patches themselves.
>
> Changelog:
> v2:
> - refactored some names and the flow in patch 1 to make it more clear.
>
>
> Boris Burkov (2):
>   btrfs: allocate additional SYSTEM space earlier
>   btrfs: commit after deleting an unused block group if system space is
>     low

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.

>
>  fs/btrfs/block-group.c | 59 +++++++++++++++++++++++++++++++++++-------
>  1 file changed, 49 insertions(+), 10 deletions(-)
>
> --
> 2.55.0
>
>
