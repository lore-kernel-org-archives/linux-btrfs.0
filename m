Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EA573655DD
	for <linux-btrfs@vger.kernel.org>; Mon,  8 Jun 2026 11:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780917975; cv=none; b=fpz0FReUENmH6BsClrw1XxsbxZtMox43zUyzrDHKmWhRColKAxEMZPsNAVDdOd8djKHBBzKCfISfP4PDTTnGaFcuOEN3QuRNDZQUQrtxluSB8+r5pDGv8EFCKjY/LlnrGrEvbZxKyFesX/CMRdr/PW8Yi36EJ/3ECct/5drBph4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780917975; c=relaxed/simple;
	bh=AYcNsLUWBNivjUgyjTkqW5dcaYcP5iaOrwScI1lNzI0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kJ/q6QmsQ/TceDUJtjAF4IEaExi0XOBpdY1SHUxFbmzyy5jzN0ySoTNVx/KAsM7akeV7KbT3R50AjBobVp0wWnKRrIeqP5Wj3QGW89sS6Zng9QnCzfTDUPfXt580RWG4dfKBf+4GcOqN6pmLmO03QX9+TjxNYyI3fNyyRG08Vwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NuQAzmud; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NuQAzmud"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86AC11F00898
	for <linux-btrfs@vger.kernel.org>; Mon,  8 Jun 2026 11:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780917974;
	bh=Qy+6oX9Zs4LVqKtmtW5x12NdT5K1IpIhXTNacXCEvqY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=NuQAzmudzx9dP1h8pqWoW5eGhQnWDWrnb0SoOkPANokKQwIUtEhFjqscgey5wEwh5
	 iNO9HFbbBGV8l9v1K6ylVKaxXtjIN7UXRDrwqo4WeXI0MTVS992YV1rHUg23dU1ucJ
	 TjFr8zpR8KaEDbB5YxNdMX1R8vaBfDEumwSruZEJxrIvdNe46C128F4ilywYIFDWwP
	 pBPk7Wh05iLRHnuGX++lCnTiGzfy+oHsPtIbSZN62eNK6KdIWpjyoGQsYvXP3Ycac1
	 GD/Df7Iu23URDAEDlUMNr/MAaW/VvuWvjkMTCj9YZDaTWUjRs95++CXn8nm1D/4lbx
	 zoU29quDfhblw==
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-68c5eecdd56so6135216a12.3
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Jun 2026 04:26:14 -0700 (PDT)
X-Gm-Message-State: AOJu0Yzk5mdU1n2VQSmXXnI9Jsa57d92v663HsgwDAF9AnG1iFStOmRi
	QJOduadTfq6KC28KbFEONDhSQu1OEMrqoYKbo1JpbDDKv4A2hgtUfxaGBUHCAzcFl1thujdmBUT
	HQCzBTfSPR20sO1JPr24XwONLLqVmNwY=
X-Received: by 2002:a17:906:c10a:b0:bec:da1c:c4be with SMTP id
 a640c23a62f3a-bf37283d3cdmr766412566b.34.1780917973026; Mon, 08 Jun 2026
 04:26:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1780873489.git.wqu@suse.com>
In-Reply-To: <cover.1780873489.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 8 Jun 2026 12:25:36 +0100
X-Gmail-Original-Message-ID: <CAL3q7H7dSMbRUYS-4DOmMUL8O2sDmPSy8D=7x5SGs4Lav5ko2g@mail.gmail.com>
X-Gm-Features: AVVi8Cd4T4WBedvM5m7rxteinwsbaWabwf9JJ7P9G-vL0pggBVeMKlO-I-sfXPA
Message-ID: <CAL3q7H7dSMbRUYS-4DOmMUL8O2sDmPSy8D=7x5SGs4Lav5ko2g@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] btrfs: minor fixes and cleanups on direct IO path
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 8, 2026 at 4:03=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>
> [CHANGELOG]
> v2:
> - Drop the first 2 patches
>   The problem with APPEND NOWAIT direct writes needs more consideration.
>   If short writes happened for APPEND NOWAIT write, there are more
>   factors to consider.
>
>   Firstly we should return -EGAIN so that the caller can retry in a
>   blocking way.
>
>   Secondly we should fully revert what has been written so that isize is
>   not increased.
>
>
>   For the OE conflicts I have not yet hit with upstream, so it should be
>   something wrong in my previous direct locking changes.
>
> There are several small problems inside the direct IO code:
>
> - Duplicated btrfs_dio_data::submitted
>   The iomap_end() callback has @written parameter which provides the
>   same value.
>
>   Fixed in the third patch.
>
> - Badly structured btrfs_dio_iomap_end()
>   Refactored in the last patch.
>
> Qu Wenruo (2):
>   btrfs: remove btrfs_dio_data::submitted
>   btrfs: refactor btrfs_dio_iomap_end()

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.

>
>  fs/btrfs/direct-io.c | 131 ++++++++++++++++++++++---------------------
>  1 file changed, 66 insertions(+), 65 deletions(-)
>
> --
> 2.54.0
>
>
