Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0171313524
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Feb 2026 12:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770812369; cv=none; b=IYK6w3neAIZHlgRiFk/1s2vpnWbkxYbUaRWjb4nhG33louhB5r/L9nMzHVbBDe/59HFRXpBpHQB+ctDWyb5HjD+bltglwVQe+gLJ4NqaqvJWZM9tGKVmsPwOblb+4ujHoRD1RMHJrK+2C5FAFASnww+PqcyAuS27aVRa6UV/+D0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770812369; c=relaxed/simple;
	bh=8+5hLYKlkfel9X+VHKVMLiSanpnmUT1kL7MOSwMJWmE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MSsdeCUFm8MOqmcFFOchduzkjmAaqUltqcGNgYldlpdlEa1LLZJ7fz3DiTSwxQdj4V2C4CBBtwV3kuULX+e1v09p+vbUkBqr9tD9+NXQ/0J6t+DpnAiR3bk75b+BzZ3AtXXWZfXfQp/QAe9FfN8mXCW9hzCBOZXhaP0RIiduA0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oOA8OvK8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oOA8OvK8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0470C2BC86
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Feb 2026 12:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770812368;
	bh=8+5hLYKlkfel9X+VHKVMLiSanpnmUT1kL7MOSwMJWmE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=oOA8OvK8OOECi/osWYM5dbgvmu4YzWvxwVlnIHJ7dbc1GgNatNj5U/6ROgTaliMnZ
	 2hxgS19R83PhgZ08qkEC6DHbtoxPtuuD7EKBFVksUmXdfLmGjhd8+9NRo/Qhx+JTfS
	 qQ8J0Yqr5Acu835T7mYG4VK4eR2iqIyw6U+vkKBMvCbK/q7btgplYH3C5/zeAmRAgF
	 2NMJGeCZ09fxX9qrZ9nS85AQUsOX84FTF/oPt0l6uUaLtH+P0w+jdaPjt9luZJRSjq
	 TK6guW/pia1olT521rkq+mbb1H5jGA6cFstN6Z975l3Ltt2I3cBL2BBJMrrNLBbXdz
	 eni+fr/jE/PFw==
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b87677a8abeso1005597166b.1
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Feb 2026 04:19:28 -0800 (PST)
X-Gm-Message-State: AOJu0YxnuiB3xNLqw0w4hN/9WJoboawZ56HtOov7W5Gj7YMiMoT3JBrb
	uBZ9d/usiuiK4OwuiaUuLHvYwxPIjmFiDdGeF7FHzhYFJtYgQD7OjilqSW2+WbC7PRRQzLefqE7
	cG7fcFpEOEPEwJXqtqkozbmPyf/bimZw=
X-Received: by 2002:a17:907:3f88:b0:b87:b0ba:5d2d with SMTP id
 a640c23a62f3a-b8f6f1d265amr127344566b.57.1770812367195; Wed, 11 Feb 2026
 04:19:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260211044032.2935837-1-nichen@iscas.ac.cn>
In-Reply-To: <20260211044032.2935837-1-nichen@iscas.ac.cn>
From: Filipe Manana <fdmanana@kernel.org>
Date: Wed, 11 Feb 2026 12:18:49 +0000
X-Gmail-Original-Message-ID: <CAL3q7H4Zu+zyagYMmYhD7j8HGVvrzq6q93M8z0miTusd-R4B5g@mail.gmail.com>
X-Gm-Features: AZwV_Qgb4Rjm9MXZkBVrORI3a57SSdzvxX9q2jXN3mN76dMlpkrg6B6mzEpBIzY
Message-ID: <CAL3q7H4Zu+zyagYMmYhD7j8HGVvrzq6q93M8z0miTusd-R4B5g@mail.gmail.com>
Subject: Re: [PATCH] btrfs: remove duplicate include of delayed-inode.h
To: Chen Ni <nichen@iscas.ac.cn>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com, dsterba@suse.com, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 11, 2026 at 4:41=E2=80=AFAM Chen Ni <nichen@iscas.ac.cn> wrote:
>
> Remove duplicate inclusion of delayed-inode.h in disk-io.c to clean up
> redundant code.
>
> Signed-off-by: Chen Ni <nichen@iscas.ac.cn>

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Pushed it to the github for-next branch, thanks.

> ---
>  fs/btrfs/disk-io.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 13e400046c87..09c2ea2f82f2 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -50,7 +50,6 @@
>  #include "relocation.h"
>  #include "scrub.h"
>  #include "super.h"
> -#include "delayed-inode.h"
>
>  #define BTRFS_SUPER_FLAG_SUPP  (BTRFS_HEADER_FLAG_WRITTEN |\
>                                  BTRFS_HEADER_FLAG_RELOC |\
> --
> 2.25.1
>
>
