Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B9841C72
	for <linux-btrfs@vger.kernel.org>; Tue, 23 Jun 2026 12:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782217018; cv=none; b=XwjutrGxQsZRQfIrICzIcK1fqDLngGjQH7rC/r/1qHQqw1oXhMat3n0jnPs/KIz2Qxe/NXRCpjaWfrPralalzXlCNjU9mp42MDQer3dnwrkO8IXlrDlj9kMGh/1XDx7ViRvksfLiRLni/8r7V8tK/2vWC9gzoSMCjLe5lNrS9OQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782217018; c=relaxed/simple;
	bh=laE0uEDtIeVmSJjCYt0hP/NBfUCr41CT2f6dGuL5Coo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jXCX6x+8OvfCWpWZF6F75Vx1qc2J4SxyureqUPWNYO/d/iyRhYUT2bab8ogPctePk9wFAUQ15az68uxube4577lm8oZBXamLLjacjhoceVGt+c/2zj6gJoeQop/dGb1XTONxYDLAHqxCPNLjQ8DaEkJobFdswEagq3lFUzXd078=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MwB8GG7/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MwB8GG7/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14C4A1F000E9
	for <linux-btrfs@vger.kernel.org>; Tue, 23 Jun 2026 12:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782217017;
	bh=Wcrl2XWTPNNshThcxZfPkl7O+SdYofa3JL60j7qkoSw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=MwB8GG7/m+D1KqBgziPPNwgjE/xgMM2+SYVE4nsmytoZeUoUTnvoAlZEY9xGdSCbL
	 JIv5hD4WSZpOx8ODZ3BHWpZsdx/f3JEg1vy6P924cEWQapzSOreOKk/Dh55GZUaet6
	 b6U9eFWz8YVbHPwPrLCV6MD4Qw8Hys/ukiMzVJ5c29SEOlVEUh9IXAgqEbQ51AKCwM
	 KZ8hQLm4zGRRMzVjOawN63dwoxrdkNCGIl6IxPR8b0ozG3rFJ6YXCLrLLHFgR7Es5E
	 1SKlp+4WqeXD0t98bEUnu0YfxCYqqDYwsmOQyc6r3UI5cWjYBjiu4CgDaVDi0a4HNy
	 o6FLaA2RFbSOw==
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6974a6e54dbso7448836a12.2
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Jun 2026 05:16:57 -0700 (PDT)
X-Gm-Message-State: AOJu0Ywpfp+VIX0ks7q2AzpB/+QRvIxMiLr4mcPEFi0lfhPWv/BsUtkr
	J4ZyGyB2lt/NBFjc+hVMbLHxlgKVhJ7h9C3TJQkyHccjAlm9gn68mdysejHc1UmHbrpO3RWuSGO
	yRLa2l98bmaN9McuFEAxLX/tr5rr+PrA=
X-Received: by 2002:a17:907:e0d8:b0:c0c:ab91:d1b with SMTP id
 a640c23a62f3a-c0cab91262bmr437270866b.31.1782217015809; Tue, 23 Jun 2026
 05:16:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1782214614.git.wqu@suse.com>
In-Reply-To: <cover.1782214614.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Tue, 23 Jun 2026 13:16:18 +0100
X-Gmail-Original-Message-ID: <CAL3q7H437rQcBhva3xE8jqO1Z8MNN=bAL0HCVPWW-rYmPK1NzA@mail.gmail.com>
X-Gm-Features: AVVi8Cf3F_Ovy6i0kHjAhP8Mqukbwmf34c9bEujg464PpjhQmEYE2p3cMF7lBi4
Message-ID: <CAL3q7H437rQcBhva3xE8jqO1Z8MNN=bAL0HCVPWW-rYmPK1NzA@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] btrfs: fix inlined file extent items in data reloc
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 23, 2026 at 12:38=E2=80=AFPM Qu Wenruo <wqu@suse.com> wrote:
>
> [CHANGELOG]
> v3:
> - Use btrfs_is_data_reloc_root()
>
> - Reword the cause analyze to avoid confusion
>
> - Expand the [FIX] section to explain why disabling compression will
>   avoid inlined extents
>
> v2:
> - Add more explanation on why we can created inlined extents even if
>   relocation is preallocating space
>
> - Add the fixes: tag since the behavior is caused by a specific commit
>
> There is a syzbot report that an inlined file extent item in a data
> reloc inode triggered a sanity check in get_new_location().
>
> It turns out that we can create inlined file extents for data reloc
> inodes in the first place after commit 3eaf5f082c4c ("btrfs: extract
> inlined creation into a dedicated delalloc helper").
>
> So the first patch will avoid compression for data reloc inodes first,
> then the second patch to reject inlined file extent items in
> get_new_location(), making the checks more robust.
>
> Qu Wenruo (2):
>   btrfs: do not try compression for data reloc inodes
>   btrfs: reject inline file extents item in get_new_location()

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.

>
>  fs/btrfs/btrfs_inode.h | 2 ++
>  fs/btrfs/relocation.c  | 7 +++++++
>  2 files changed, 9 insertions(+)
>
> --
> 2.54.0
>
>
