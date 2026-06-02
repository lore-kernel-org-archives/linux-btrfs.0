Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035C63CA493
	for <linux-btrfs@vger.kernel.org>; Tue,  2 Jun 2026 10:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780395677; cv=none; b=lJBlS87c4i/12JEj2O82d8n4EWLwMEAJkkX3BPgrYc78BYwcjD+DiNQbU8/Z8JjTnzfVM4uB28D0AnKPWhesMWfwxGrWk8DoSRdv8aAuf4sz7/nCEsbWsAv5zdpkdFOqebeZ5WFtnzGl7NK6z31CU9zRY6RqP1BNUjxSbduqikE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780395677; c=relaxed/simple;
	bh=tVR499rjYyDQFDTJ2pOPrqqQHq0rqbQnOKNNfqPDJGw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Dv2hzvtalmqQR/Zhc4x/f/JV3TYN0hI2ljvlLVuX8cgfRfSTq6iL8c12BGnovqPFlolAALVPTHe78PZV/lN3gSF+/FLsO1LAXEahsNuy4UEDKuNOKnpBZWXp4G+o8x7M26c9rfvVq/z4WyTMgUWI13SCQabwbCuHcBexnXWi+00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZoHyWd6I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZoHyWd6I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CADA1F00893
	for <linux-btrfs@vger.kernel.org>; Tue,  2 Jun 2026 10:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780395676;
	bh=mLhsd4V2VCNwUOlJ7zuQHEg5FPEkxc/BDhWd+ZgNWjI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ZoHyWd6I7YSkOc3UjgDkDnqnwYnu9H3d6754Ye9UvgFJ9VrIw2xhPFtvSjoBQLx3q
	 M1DLJ8z0E2vNkTB0A7M92DaU1MhP5IwPcqeam4FXM9dzR7u/dk8sEqQmK4QRJvztvI
	 IZCM90dn40ltdsfbtID3tDygOUiMqgE4cSGd5h3zwh557Y6w325u8Ys5yRpNMbNhYa
	 ZUIDshU552Vux2UQS4AovmZ6Ht2slZcaITZng1gLIF8l0A+9RFm4RL8ebUL4R/9GMg
	 gyTzfUFjo73uknm29UI7nHZoXWHgPTUE3aDgZ93PgLfptUU0bd6QmTzsiNnm1jmZyH
	 KMk235bbPRVdQ==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-bebde89cfd3so355281966b.2
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Jun 2026 03:21:16 -0700 (PDT)
X-Gm-Message-State: AOJu0YzTCWu3foLDBdlGP2rSaUbf6lfw49aH8fEfw8CYMEChXKLSMLf1
	UfhubTO0ld7RfSoY08pC4hB7zT+3EQdBkiqd4CspT5xqZ93GnVUzT6cOMgRqm4W9CgU/13jFYOL
	RAzTb/zWdywMC++SPaB1M5LIID83Ey70=
X-Received: by 2002:a17:907:9813:b0:bec:fad3:5b58 with SMTP id
 a640c23a62f3a-becfad362bcmr538894166b.27.1780395675316; Tue, 02 Jun 2026
 03:21:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <c7860a5196a885c39e01676c4a1b3a4323f56590.1780377988.git.wqu@suse.com>
In-Reply-To: <c7860a5196a885c39e01676c4a1b3a4323f56590.1780377988.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Tue, 2 Jun 2026 11:20:38 +0100
X-Gmail-Original-Message-ID: <CAL3q7H79eeyxS+r3rj76aHCgK53+CizpaiExbr6aJcNZq5MNrQ@mail.gmail.com>
X-Gm-Features: AVHnY4LKgo_sWW3xeyusEYBiS6wUJe1V9xzhJbJkA3rs-Fcybm9vR8QBztQwByY
Message-ID: <CAL3q7H79eeyxS+r3rj76aHCgK53+CizpaiExbr6aJcNZq5MNrQ@mail.gmail.com>
Subject: Re: [PATCH] btrfs: output a message when a missing device re-appear
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 2, 2026 at 6:30=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>
> There is a bug report that fstrim crashed, and that crash is eventually
> pinned down to a missing device which re-appeared and screwed up callers
> that only checks BTRFS_DEV_STATE_MISSING, but not
> BTRFS_DEV_STATE_WRITEABLE nor device->bdev.
>
> A missing device re-appearing can be very tricky, as for now it will
> result a device without WRITEABLE nor MISSING flag, and still no bdev

result a device -> result in a device
nor -> or

> pointer.
>
> As the first step to enhance handling of such re-appearing missing
> devices, add an dmesg output when a missing device re-appeared.

an dmsg -> a dmsg

Also in the subject, "re-appear" should be plural: "re-appears".

Otherwise:

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.

>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/volumes.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 93a923e4ecaf..716dcefb0fd8 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -963,6 +963,11 @@ static noinline struct btrfs_device *device_list_add=
(const char *path,
>                                           devid, btrfs_dev_name(device),
>                                           path, current->comm,
>                                           task_pid_nr(current));
> +               } else {
> +                       btrfs_info(NULL,
> +       "missing devid %llu re-appeared at %s scanned by %s (%d)",
> +                                  devid, path, current->comm,
> +                                  task_pid_nr(current));
>                 }
>
>                 name =3D kstrdup(path, GFP_NOFS);
> --
> 2.54.0
>
>
