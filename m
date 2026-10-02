Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87ECF2C21F7
	for <linux-btrfs@vger.kernel.org>; Fri,  2 Oct 2026 18:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790967549; cv=none; b=gJSndb9AJhRFOsHgub6vK6r/5itQVL/zKLoh+L9nquQldl4AoCn3x+ltTUPoMKxX7oG/cldeIWud+y4NdsG6GPDPC2voKXxP+towauNtgLDPzuuCNTM61qIKM6YadpRBHNbq+DSEGhBCrMNkLNz/3j4z5WK5PKeDwXLreeNmWQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790967549; c=relaxed/simple;
	bh=QrtxS9T1y9LzYrSuTkGuSU7KoUPANKNekIUUgUlC80E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=cE9YISBVrCr8gucfJKxQT4vcYw/UjgvOUIw42zIYMZ/+0iRo1pIZYgigcQ7gw3QeLajF1m/9JZjhGIccv/txDemrc8TyTcaM7YDJUjbw5CBRqPfpDPY1KOdWpDElx10ufXEPR6WTb3AgHF+K6CT3hGplwS3EnvnwDhSXXT6+2Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JM9c2krZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JM9c2krZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F8D21F000FF
	for <linux-btrfs@vger.kernel.org>; Fri,  2 Oct 2026 18:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790967548;
	bh=OQ2/AzTFpz/EcVuYAgtjvKoOyuFO5TJkET1BmqG61DE=;
	h=References:In-Reply-To:From:Date:Subject:To;
	b=JM9c2krZjfSHR3+uExi82Oobyj4ObgcOzhYKyxWuUQWiphrR/LEnCJUzsvVEDBuJ2
	 fTgglngaTBisB0LqBHKm9vZsxkevyVYTPS8prZbkvGoOIlsbmIGcKevdTOGtn+CCKK
	 0fxEo1c7QlF3Rk/aJ/ebsgs8nIcs8J2GFhx9n2c7bv8DoVfq3sI/qSAcRkHVwpqgvF
	 pz0wsxKc4prMW/YPGb91szZmY8N0r+hD70kM1k4mVytDc+LdKdlX7oHYFHQ0ZQWv7G
	 dSlBAwg2xqvUERsMzmjFi7T0YdLD0+0zKEln3E2/I/3CjMv+paj9TsRKMcPsRDi2MT
	 TFGGQYZckKHCA==
Received: by mail-vs1-f42.google.com with SMTP id ada2fe7eead31-7bec5112765so401918137.1
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Oct 2026 11:59:08 -0700 (PDT)
X-Gm-Message-State: AFq9FYIxFKIOtyPx6PUj46ujdI3F7aE8drSZhlxNtAlxE5s+TYyofmRj
	/U53lKjvUVHNrtym3XfAtvtrBkGIIfEXUMGp654LEs7Vl9a4tAVsynuWgR/ALjrcr1A3XIfBKZC
	eVLkQdsWmMBCAzxIJ2bRPW7UmO0f+Oog=
X-Received: by 2002:a05:6102:f14:b0:7b3:5873:4b03 with SMTP id
 ada2fe7eead31-7c245de8fe4mr129617137.29.1790967547600; Fri, 02 Oct 2026
 11:59:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1790967259.git.fdmanana@suse.com> <1a8c03f1c6777f2cafa76ff9c4309e381c6f761a.1790954970.git.fdmanana@suse.com>
In-Reply-To: <1a8c03f1c6777f2cafa76ff9c4309e381c6f761a.1790954970.git.fdmanana@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Fri, 2 Oct 2026 19:58:31 +0100
X-Gmail-Original-Message-ID: <CAL3q7H7HDi64TXBE4WuSjWxvzV35nKmvaXTZrX3PbOa+JWRX8g@mail.gmail.com>
X-Gm-Features: AclHuK-Q482iG0PDmBQVQXMGPgXlrDS5TUNYB8ombw6EyPW0enKPjOavuade7UM
Message-ID: <CAL3q7H7HDi64TXBE4WuSjWxvzV35nKmvaXTZrX3PbOa+JWRX8g@mail.gmail.com>
Subject: Re: [PATCH] btrfs: qgroup: fix race between subvolume creation and
 adding/removing relations
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 2, 2026 at 7:56=E2=80=AFPM <fdmanana@kernel.org> wrote:
>
> From: Filipe Manana <fdmanana@suse.com>
>
> When using simple quotas, we can have a race between creating a subvolume
> and auto inheriting quotas and the ioctls to add or remove qgroup
> relations.
>
> This happens like this:
>
> 1) Task A is doing subvolume creation and calls btrfs_qgroup_inherit()
>    with the "inherit" parameter as NULL (since BTRFS_SUBVOL_QGROUP_INHERI=
T
>    was not passed in the flags of the subvolume creation ioctl).
>
> 2) Task A enters qgroup_auto_inherit() and calls list_count_nodes() to
>    get the number of nodes in a qgroup's list, then allocates an array
>    with a size matching that number of nodes.
>
> 3) Task B enters the BTRFS_IOC_QGROUP_ASSIGN ioctl to add a qgroup
>    relation and enters btrfs_add_qgroup_relation() where it locks
>    fs_info->qgroup_lock before calling __add_relation_rb() where it
>    adds to the list of the same qgroup that is being processed by
>    task A.
>
> 4) Task A iterates over the qgroup's list elements and assigns to an
>    array that has an insufficient size, since the number of elements in
>    the list is now larger, by 1, compared to the count it got in step 2,
>    resulting in an out of bounds array access.
>
> This all happens because btrfs_qgroup_inherit() does not take the lock
> fs_info->qgroup_lock before counting the number of elements in a qgroup's
> list and iterating it. So all sorts of other races can happen, like
> iterating the list while another task is calling either
> btrfs_add_qgroup_relation() or btrfs_del_qgroup_relation() and modifying
> the same qgroup list concurrently.
>
> So make btrfs_qgroup_inherit() take fs_info->qgroup_lock.
>
> Fixes: 5343cd9364ea ("btrfs: qgroup: simple quota auto hierarchy for nest=
ed subvolumes")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Ignore this one, it's not valid since we are protected by the
fs_info->qgroup_ioctl_lock mutex.


> ---
>  fs/btrfs/qgroup.c | 27 +++++++++++++++++++--------
>  1 file changed, 19 insertions(+), 8 deletions(-)
>
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index c07cf6041cb9..195326ef0388 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -3256,26 +3256,34 @@ static int qgroup_auto_inherit(struct btrfs_fs_in=
fo *fs_info,
>         struct btrfs_qgroup_inherit *res;
>         size_t struct_sz;
>         u64 *qgids;
> +       int ret =3D 0;
>
>         if (*inherit)
>                 return -EEXIST;
>
> +       spin_lock(&fs_info->qgroup_lock);
>         inode_qg =3D find_qgroup_rb(fs_info, inode_rootid);
> -       if (!inode_qg)
> -               return -ENOENT;
> +       if (!inode_qg) {
> +               ret =3D -ENOENT;
> +               goto out;
> +       }
>
>         num_qgroups =3D list_count_nodes(&inode_qg->groups);
>
>         if (!num_qgroups)
> -               return 0;
> +               goto out;
>
>         struct_sz =3D struct_size(res, qgroups, num_qgroups);
> -       if (struct_sz =3D=3D SIZE_MAX)
> -               return -ERANGE;
> +       if (struct_sz =3D=3D SIZE_MAX) {
> +               ret =3D -ERANGE;
> +               goto out;
> +       }
>
>         res =3D kzalloc(struct_sz, GFP_NOFS);
> -       if (!res)
> -               return -ENOMEM;
> +       if (!res) {
> +               ret =3D -ENOMEM;
> +               goto out;
> +       }
>         res->num_qgroups =3D num_qgroups;
>         qgids =3D res->qgroups;
>
> @@ -3283,7 +3291,10 @@ static int qgroup_auto_inherit(struct btrfs_fs_inf=
o *fs_info,
>                 qgids[i++] =3D qg_list->group->qgroupid;
>
>         *inherit =3D res;
> -       return 0;
> +out:
> +       spin_unlock(&fs_info->qgroup_lock);
> +
> +       return ret;
>  }
>
>  /*
> --
> 2.47.2
>
>
