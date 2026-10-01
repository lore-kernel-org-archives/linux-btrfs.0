Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F494ABBB2
	for <linux-btrfs@vger.kernel.org>; Thu,  1 Oct 2026 08:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790845180; cv=none; b=iicmNNEs6yJf/6q0Yo0o7x8IvI1n3OrrRG2s4kNGbIXF0v2VrsUoQPxY+Av2PXRyjkiBEjUwggbqvpUYGmElnguxSOKA//p73/Xld0nnZshb/h5mh36O/tNmzvy1OGr+Hb9tIfru2kluUzxqlLmi81NnHaJHv2cfNQr+tOwULWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790845180; c=relaxed/simple;
	bh=joqA6yky6MA/PGDPDZl1W+wqvipr6E7HW6XyufOaV2o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XMGg7e32XW9A/k2rh7am0dlYo5auncMGWTbY1E76u/9kIFYrnzSiB7PHIfb8drzqZa95TH9eLiWG/fdfclGw1bA5bBRyFE+Mp8eBGrQWX6yO3a/3Ui1uJVAs0uLb/wyOzjqMEtP2IbCaZo07WixeBBg+bdh3aI5V2dhfP0xNNkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fi3nozpY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fi3nozpY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 807E51F00898
	for <linux-btrfs@vger.kernel.org>; Thu,  1 Oct 2026 08:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790845178;
	bh=dbKDkO5sc2blN7nLolaRttIamhXgI567L5jAEFuc/mY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Fi3nozpYsQ8S7ptobe1ouFHqecw8qcgfFhHxn13B56V7UqQ2RbjtYUYRg2E2iaBP3
	 LW7R70CiHIa9PxJYMkjMw9DdnpLqEm+U7U9l3ejbqeTc1fQwJuo9KSX7oFD5583Bl0
	 aWVYzAUu6FDU/+AhtOJ/7KcP3vqGl8/y3++gmu5dDLrCHgulwNYV6HUgKTLdxlAm6w
	 OGaT7/QnMum9IvLmmvUW5zzp8yBJFTK+H4E6+EBqCASpd41xutdaBxSldRHaz+8+Hh
	 XzH8jpILFX21jpJyVIvYCNVoYG1oXs04o3ylMavIfinjfsNiaNVpYc471iH0ZSYdMP
	 EhgKC96dOW2xQ==
Received: by mail-vs2-f36.google.com with SMTP id ada2fe7eead31-7bf43e81472so403993137.1
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Oct 2026 01:59:38 -0700 (PDT)
X-Gm-Message-State: AFq9FYIWy16gMW2qzF0p2GvH9GCIl70xD2ZJov1u2pxMEwWDnvDAs2ao
	KDKLbKtksuiJhL53zARb97mYyttC6UTzkiHzaZEmyOYpyF1qEJnEMziPxBRO8KI005sC7YFNGot
	Aj7eEXHlBF+pr6r+rD+sKl1919NR0H5I=
X-Received: by 2002:a05:6102:390d:b0:7a7:ad9f:53c4 with SMTP id
 ada2fe7eead31-7be72cb40e8mr1111057137.15.1790845177700; Thu, 01 Oct 2026
 01:59:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1790831600.git.wqu@suse.com>
In-Reply-To: <cover.1790831600.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Thu, 1 Oct 2026 09:59:01 +0100
X-Gmail-Original-Message-ID: <CAL3q7H4bc4K0vy+yFHGHdsOsW88VRFYTy1EGE_GVfJ57M9M3iQ@mail.gmail.com>
X-Gm-Features: AclHuK-tlL6-pp6pcXW0qCPpjbInA8WPvoCm1MvUqBygQF76U1SP0YlFQDb5ujk
Message-ID: <CAL3q7H4bc4K0vy+yFHGHdsOsW88VRFYTy1EGE_GVfJ57M9M3iQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] btrfs: small fixes related to qgroup deletion
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 1, 2026 at 6:17=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>
> There is a recent bug report that when deleting a qgroup that is not
> fully exclusively owned, it can make all future qgroup operations to
> fail.
>
> It turns out to be a problem handling "ret > 0" cases when deleting a
> qgroup.
> The first patch is the root fix.
>
> The seconds patch is to improve the error reporting of
> quick_update_accounting().
>
> Finally there is a pre-existing problem exposed by that "ret > 0"
> handling, that if we use btrfs_remove_qgroup() on a qgroup that only
> exists in the rb-tree, it will return -ENOENT meanwhile still deletes
> the in-memory qgroup.
>
> Fix that -ENOENT leak in the last patch.
>
> Qu Wenruo (3):
>   btrfs: qgroup: do not treat "ret > 0" as error when deleting a qgroup
>   btrfs: qgroup: use qgroup_mark_inconsistent() in
>     quick_update_accounting()
>   btrfs: qgroup: do not leak -ENOENT from btrfs_remove_qgroup()

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Looks good, thanks.

>
>  fs/btrfs/qgroup.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> --
> 2.55.0
>
>
