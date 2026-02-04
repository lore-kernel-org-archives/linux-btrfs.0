Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A676C41B360
	for <linux-btrfs@vger.kernel.org>; Wed,  4 Feb 2026 15:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770219790; cv=none; b=kWAKeNiQDrrrt/j7hyzDts0JzR/OmkvIpsWHfGqyH2dPAmbs1+rGdhsX8r/j4bJBXKDZCNU+a3PoiJd4bibXQFQc6tctU36KbafsSHHqZfMKiT5YB0rwK+2xo/o3zPz8S/O/5QOvuiRYVNHQj762S/5Oe7jsIKXAGEPMiVooumg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770219790; c=relaxed/simple;
	bh=BZq/7RcQBWY9fsgc1BYJz5n/WVD8pt//mONPqYZL01o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XDF32X4ICtI/YxpTLPkL96IOrD01Y2xsVvR5U6aUOoKOk6N+MEYZBTmyui3eywwIF+PZn8kn50uVhKzkNjl5TsWJ1FHJfy82NTLy7XLuvYnsporJU1d7h+yw57GZ6rkpO2Hhrp4HyZqHuoP1A06uNj3K5mH5jSXuBdJKKlCSXEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TbX4txil; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TbX4txil"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34F93C19423
	for <linux-btrfs@vger.kernel.org>; Wed,  4 Feb 2026 15:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770219790;
	bh=BZq/7RcQBWY9fsgc1BYJz5n/WVD8pt//mONPqYZL01o=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=TbX4txilNW0k+b9GjIFxa+NyvD+LEFQhgU1TpAGOTTMtbi0RJZwy+dWoSUVkX2EpF
	 IUMcQFJkySIOmZJHsIBCjteO4oPg/TJzHMSyCZ+gmungmhAO8SYUmyn+rd63KqZ/RE
	 vHhXHAHE1QZk1QvPJVtEO+hweTpnJDII8SNjNrwgQnX/uhNvdGUqr2hlPzaX0H5vun
	 vR9HusOquV6R7w6km+9DgOIUluSFuqUNCXOC1Nw5ch3NjbbsubszNIiN2rKIjL6cP/
	 H1M1DnAWcx6MEg8rj1keEPKzSrjeN3N0bMxwnObAcQAbcZ308MM+Lj2r921v2cl7/x
	 7dAy+1v3rgaUg==
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b8837152db5so1096308566b.0
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Feb 2026 07:43:10 -0800 (PST)
X-Gm-Message-State: AOJu0YyXywIkE3Fj3zZA1S88cf/LfYCuzMYLcJnq6ki+2FsrbygSpSDD
	Sr+6NUpParHyatk35pJQprvkFlzS603VYFNg/mmEByHl0u5UX0sM2uA5pZLXwk9IAcyB2QfEZGp
	u013J7CxT4wC+2IDCA5DzW3/bwWhXyOY=
X-Received: by 2002:a17:907:d1f:b0:b87:31:d29 with SMTP id a640c23a62f3a-b8e9f2ea705mr224207666b.44.1770219788583;
 Wed, 04 Feb 2026 07:43:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1770173615.git.wqu@suse.com>
In-Reply-To: <cover.1770173615.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Wed, 4 Feb 2026 15:42:31 +0000
X-Gmail-Original-Message-ID: <CAL3q7H5=qH2yejLcPiWhkhXfcFx7UnhLcvC6z9WiY9gcenXg6w@mail.gmail.com>
X-Gm-Features: AZwV_QhgGGYc6wFf_4lEJF7drpbamD1Mz_G0An8fe6yc-7mfmdCwlALFnO7H2b8
Message-ID: <CAL3q7H5=qH2yejLcPiWhkhXfcFx7UnhLcvC6z9WiY9gcenXg6w@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] btrfs: unbalanced disks aware per-profile
 available space estimation
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 4, 2026 at 2:54=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>
> [CHANGELOG]
> v2:
> - Various grammar fixes
>
> - Fix a u64 division compiling error on ppc64
>   Which requires the dedicated div_u64() helper.
>
> - Ignore unallocated space that's too small
>   If the unallocated space is not enough to even cover a single stripe
>   (64K), don't utilize it.
>   This makes the behavior more aligned to the chunk allocator, and
>   prevent over-estimation.
>
> - Use U64_MAX to mark the per-profile estimation as unavailable
>   This reduce the memory usage by one unsigned long.
>
> - Update the commit message of the 2nd patch
>   To include the overhead (runtime of btrfs_update_per_profile_avail())
>   in the commit message.
>
> - Minor comment cleanup on the term "balloon"
>   The old term "balloon" is no longer utilized and there is a typo.
>   ("ballon" -> "balloon").
>
> - Update the estimation examples in the first patch
>   As we allows 2 disks raid5 and 3 disks raid6.
>
> v1:
> - Revive from the v5.9 era fix
>
> - Make btrfs_update_per_profile_avail() to not return error
>   Instead just mark all profiles as unavailable, and
>   btrfs_get_per_profile_avail() will return false.
>
>   The caller will need to fallback to the existing factor based
>   estimation.
>
>   This greatly simplified the error handling, which is a pain point in
>   the original series.
>
> - Remove a lot of refactor/cleanup
>   As that's already done in upstream.
>
> - Only make calc_available_free_space() to use the new infrastructure
>   That's the main goal, fix can_over_commit().
>   Further enhancement can be done later.
>
> There is a long known bug that if metadata is using RAID1 on two
> unbalanced disks, btrfs have a very high chance to hit -ENOSPC during
> critical paths and flips RO.
>
> The bug dates back to v5.9 (where my last updates ends) and the most
> recent bug report is from Christoph.
>
> The idea to fix it is always here, by providing a chunk-allocator-like
> available space estimation.
> It doesn't need to be as heavy as chunk allocator, but at least it
> should not over-estimate.
>
> The demon is always in the details, the previous v5.9 era series
> requires a lot of changes in error handling, because the
> btrfs_update_per_profile_avail() can fail at critical paths in chunk
> allocation/removal and device grow/shrink/add/removal.
>
> But this time that function will no longer fail, but just mark
> per-profile available estimation as unreliable, and let the caller to
> fallback to the old factor based solution.
>
> In the real world it should not be a big deal, as the only error is
> -ENOMEM, but this greatly simplifies the error handling.
>
> Qu Wenruo (3):
>   btrfs: introduce the device layout aware per-profile available space
>   btrfs: update per-profile available estimation
>   btrfs: use per-profile available space in calc_available_free_space()

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Just a few minor typos in patch 1, can be fixed at commit time.

Thanks.

>
>  fs/btrfs/space-info.c |  27 ++++---
>  fs/btrfs/volumes.c    | 183 +++++++++++++++++++++++++++++++++++++++++-
>  fs/btrfs/volumes.h    |  34 ++++++++
>  3 files changed, 231 insertions(+), 13 deletions(-)
>
> --
> 2.52.0
>
>
