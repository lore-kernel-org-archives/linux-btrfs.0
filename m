Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C53C0145A05
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Feb 2026 12:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770727682; cv=none; b=XLSbw73UglMgmFT1a0kFjOprqOoqFCDaO/9xzv1vpwZ08nB/XuM+3MsF45qSqfQC/DQpdThnMRUh1RVMMT1LTUYpbLwhsQfrPnz1QW7xLNyWWiPPUesWCWerzsMmn9SMzuipZgFLPzvVcYMxgcEqZ0Pj1iH/3uEu+l8k7qYtz+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770727682; c=relaxed/simple;
	bh=8JopNUqiCvjf4RJ0UivVKWkaSe4+4Rn9gi/oczn5UzM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QD+587SkI4jBOolJsLrFJcOO4ONYiOqXnykHg5igW92BqxlQM/GwgIEd8Di57LKLoq925inlEjFdx41/Ksq86ZsId333FX3EGA7Bj8ucBGvproEaZXa3evUTDhpc5A3BgQxSe6UIJMJVIh/zU2dxBm5kcU/SK2/XPq37R0S/GvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qe77g47f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qe77g47f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A2FBC16AAE
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Feb 2026 12:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770727682;
	bh=8JopNUqiCvjf4RJ0UivVKWkaSe4+4Rn9gi/oczn5UzM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=qe77g47fK0haypDjochC3DTJWSBvjMMQ6Lc69Rjpiph6Xw+izoRd9eiEjjHSVAMUs
	 iqte9ImcUT1Bu4A10oqk7Lq9Vy8pO+s4hJQ1nxws1TsmOvwHP64Z5B4PLFq+pm/p1t
	 VoKnOIif8PyNVK2o/jNzBkjcKyB+7gNcMsTAUkKI+Sbx9Sm2SONwACJqx8RbazfnRF
	 TFFn6lctB8KkfKl4m5CXbjmo5iKuFcezA0kYsLvQYqs1OWw4QUA9QWS9+rkRxTUT+0
	 /Z54OtC//KOl/XhALSpFdTyTmtq4rbk2lJd3QLAXA7U5qC3x3C8XaNIBejIzs1nNeQ
	 F8ak9Z3onerqw==
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b79f8f7ea43so146205166b.2
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Feb 2026 04:48:02 -0800 (PST)
X-Gm-Message-State: AOJu0Yz/1ADVE+bwOPUzkq9oaNqNL7l+jg7PLZQ7GRpy5eeuGm3vSklR
	dXyDJDjJhaHdEwsEzRgIGyIfdkzyzcZqlvj8Ktg4jK3zoPtGHthSPqEWuae1g3XM9IKbyQCeW6T
	2ceyzEDhmZ5r4Jn2OFA2S8PUW4rIEeXw=
X-Received: by 2002:a17:907:1c8e:b0:b8e:a024:1c81 with SMTP id
 a640c23a62f3a-b8edf176c31mr803745166b.7.1770727681027; Tue, 10 Feb 2026
 04:48:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1770693583.git.wqu@suse.com>
In-Reply-To: <cover.1770693583.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Tue, 10 Feb 2026 12:47:24 +0000
X-Gmail-Original-Message-ID: <CAL3q7H64p=4TAsocvUPz=r_EjttF0cS3xt3SDR4sJUTYXOZ46Q@mail.gmail.com>
X-Gm-Features: AZwV_QjpJC1JwCRDSlg1PKNa3JiITrzNi-tQhe0BAqec8PprGlUgpkxKH0nux2k
Message-ID: <CAL3q7H64p=4TAsocvUPz=r_EjttF0cS3xt3SDR4sJUTYXOZ46Q@mail.gmail.com>
Subject: Re: [PATCH 0/3] btrfs: ordered extent csum list related cleanup
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 10, 2026 at 3:24=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>
> Trivial changes, please refer to the commit message of each patch.
>
> Qu Wenruo (3):
>   btrfs: rename btrfs_ordered_extent::list to csum_list
>   btrfs: make add_pending_csums() to take an ordered extent as parameter
>   btrfs: rename btrfs_csum_file_blocks() to btrfs_insert_data_csums()

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Looks good, thanks.

>
>  fs/btrfs/file-item.c    |  6 +++---
>  fs/btrfs/file-item.h    |  6 +++---
>  fs/btrfs/inode.c        | 18 ++++++++++--------
>  fs/btrfs/ordered-data.c | 10 +++++-----
>  fs/btrfs/ordered-data.h |  2 +-
>  fs/btrfs/tree-log.c     |  8 ++++----
>  fs/btrfs/zoned.c        |  7 +++----
>  7 files changed, 29 insertions(+), 28 deletions(-)
>
> --
> 2.52.0
>
>
