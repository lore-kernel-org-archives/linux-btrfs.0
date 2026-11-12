Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794495207;
	b=rqpb66gOzwrZlfpWH8f8axm+I4EgsUziUacNsJtGI1TVpF6kIBAR+7lYgC+/FyCjVzGJ
	 bqRbBh2D82mYg82xv3amCy+qwMzh3Gk/GcsKNgFqrb0ru/9Pkt1n9umwo5m9t4EJdzT6T
	 EC2If1GDhcwbjjP8xd1Ok07xJE0JYq6UVWbfCLwC2qHzjbldv5vs65OHWOCupPTJLJxNB
	 EAWsoAHfAJvdYVFBpQw2gdris6FE87hebnOGv3cLFd+yjHoPUK8P5+md57lcg/SneFzB2
	 N7lC4ig3LL/gksDd2Adh9VEUOhBXr/OUi1gNXxWCex+U12G9rV02NP6LnsES0gdkTXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794495207;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=L/v5qWn68YMFs8B3Gf+RGYVilFpufPgqWHu/IxMthQ0=;
	b=3MwHSidzxB52nBVifffDJesB5ojHQqluRlk5YU4A1J4TZMSSbbcxH/Y+zKUv7FUGNyfh
	 PDEiCA9pu9TB3luoqjDyZtyFhFd4JeMEm+era5VU6Ee0os48QEiLrP03KMEgNtRtGIkyR
	 8i+OG9LmzVKQFz1ZS90gpbe/XQ+e4JuhsPw+NN0ca71SKabDZixiUDl1UkR7qIoKy0Ojj
	 wkbw1g5jJ3RxmEFWG0dSwSlt/xLWySxyMNGmTXLvwD2zZjOQoGciuij4RX1cXEL8q0Y78
	 cqc3/D9QTxRIcJ/7EHuqC7VTpSBgThD0mJ7KCkXQqj1LiV9K/fkoQyG0T1z4GrRCVgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oYJzdJAf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF14606A323
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2026 14:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oYJzdJAf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B1301F00A05
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2026 14:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794495207;
	bh=L/v5qWn68YMFs8B3Gf+RGYVilFpufPgqWHu/IxMthQ0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=oYJzdJAf4aYMUDBQEeXrpfh22yWpBUKHypF3AObESHT65Ioymi2bT+MZHtB7j6SC0
	 BDC47WbS3H91OaFjK0ky2fJyhYMyly+R2jaIdF8k3Mz+fV5OVOOaUuMxgZ601idQ1M
	 8tmVJvDeIddpGiu4yvsMw6Sj5UfgXpzqnrUeIUCY94FOoZl+y1KoJgYZwtaPLzJH66
	 yxd7/HWXaYbOwbUU2EU9wbOZrmEFJds9rtL63bGYZAyG+06C6hDrbywawjrEagNk1/
	 x9eAYDW1ovPA0RvsTno7FDg4CpJxUFRdrC8QwyKL6o+8qtm7gANLT5VDVRNfFtyZ/E
	 01pS85LUPEwWA==
Received: by mail-vs1-f42.google.com with SMTP id ada2fe7eead31-7d2f4cc314eso2184928137.1
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2026 06:53:27 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErGlSUkmlfCJVeM4XsgL+EeMEsc2jmgdhS9JiDcKn8rL7Sca0jnQ/D25Nh8qQHB29frO2Tq6XHrkLbpioQ==@vger.kernel.org
X-Gm-Message-State: APuU4Z/AqaXTRAroXwo+0dB3anKjMu7dxMv/70g2TPuykI5hkxGb+aLf
	E+t3AGm+3EdY9qpwrWNmBFFPeZawIm/RLQLdV6KvJBiAJIsXzcTzK5GpOeEccq00TAalHdVD+tl
	gtZohOPossTOipafS2JdphpyTKEJ5afs=
X-Received: by 2002:a05:6102:2c81:b0:7c1:9f20:36ad with SMTP id
 ada2fe7eead31-7d4ee0f082cmr2674233137.2.1794495206400; Thu, 12 Nov 2026
 06:53:26 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261111-btrfs-link-unlink-fsync-v1-1-a817d4a890af@columbia.edu>
In-Reply-To: <20261111-btrfs-link-unlink-fsync-v1-1-a817d4a890af@columbia.edu>
From: Filipe Manana <fdmanana@kernel.org>
Date: Thu, 12 Nov 2026 14:52:49 +0000
X-Gmail-Original-Message-ID: <CAL3q7H4xx2_ik775aK9KzNdBF+M=do+01FKVdL-KcdWNaSJnyw@mail.gmail.com>
X-Gm-Features: AclHuK89qaA7CCVafBDQqtIfrsEWX0NuC-UZNceAjGa8T_eBaD9Xl1LYLKe2ANU
Message-ID: <CAL3q7H4xx2_ik775aK9KzNdBF+M=do+01FKVdL-KcdWNaSJnyw@mail.gmail.com>
Subject: Re: [PATCH] btrfs: fix loss of fsynced file after link into new dir
 and unlink
To: mt4022@columbia.edu
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
	Filipe Manana <fdmanana@suse.com>, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, tz2294@columbia.edu, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 11, 2026 at 9:42=E2=80=AFPM Mani Tofigh via B4 Relay
<devnull+mt4022.columbia.edu@kernel.org> wrote:
>
> From: Mani Tofigh <mt4022@columbia.edu>
>
> If we create a file, add a hard link to it in a new directory, remove
> its old name and then fsync the file through a file descriptor opened
> before the unlink, the file is gone after a power failure.  Example:
>
>   mkdir /mnt/A
>   fd =3D open("/mnt/A/foo", O_CREAT | O_WRONLY)
>   mkdir /mnt/A/B
>   ln /mnt/A/foo /mnt/A/B/bar
>   unlink /mnt/A/foo
>   fsync(fd)                     /* or fdatasync(fd) */

fdatasync and fsync do exactly the same thing on btrfs, so no need to comme=
nt.

>   <power fail>
>
> After log replay, B and B/bar don't exist and the file is gone.
>
> The fsync uses the file's dentry, which is still the unlinked A/foo.
> The inode is new, so btrfs_log_all_parents() finds no parent in the
> commit root, and log_all_new_ancestors() then takes the fast path for a
> single link.  That path walks up from the dentry's parent A and never
> logs B.  On log replay the inode ref for B/bar is skipped because B
> doesn't exist, and the inode ends up with no links.
>
> Fix this by not taking the fast path when the inode had a link, unlink
> or rename in the current transaction.  The slow path finds the parents
> from the inode refs in the subvolume tree and logs B and A.  That only
> adds a search of the subvolume tree.
>
> The problem is old, e.g., v7.1 loses the file as well.  It was only
> hidden, by a fallback to a transaction commit, between
> commit 0f24ea456ae1 ("btrfs: tracepoints: add trace event for
> btrfs_log_all_parents()") and commit 36f9aafa46f5 ("btrfs: fix
> unnecessary transaction commit fallback from btrfs_log_all_parents()").
>
> With the fix, the file and its data survive.
>
> This bug was identified and confirmed with the help of a deterministic
> hypervisor currently under development.  The C reproducer below however
> hits it every time.

This last paragraph is useless in the changelog because:

1) It's pointless to know that it was found using a hypervisor under
development.
Unless it exists, has a name, and is available somewhere, it adds
nothing useful.

2) Who reads the change log after commiting the patch, has no idea
what the C reproducer is.
The link to the reproducer is after the ---, so it does not get to the
changelog.
Plus, the log should should be as self contained as possible, with no
links to  personal github accounts that may disappear anytime.
The reproducer is also unnecessarily long and complex, nearly 400 lines.
At the top of the changelog we already have simple steps to reproduce,
that is enough.

>
> CC: stable@vger.kernel.org
> Signed-off-by: Mani Tofigh <mt4022@columbia.edu>
> ---
> Reproducer: https://github.com/manitofigh/files/blob/main/linux-repros/bt=
rfslink.c
>
> It uses dm-flakey to drop all writes once fsync returns.
>
> No Fixes: tag since this looks older than the single link fast path.
> ---
>  fs/btrfs/tree-log.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index 85ef3c26e0e4..4f24b277f1b7 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -7543,9 +7543,13 @@ static int log_all_new_ancestors(struct btrfs_tran=
s_handle *trans,
>
>         /*
>          * For a single hard link case, go through a fast path that does =
not
> -        * need to iterate the fs/subvolume tree.
> +        * need to iterate the fs/subvolume tree. But not if the inode ha=
d a
> +        * link, unlink or rename in the current transaction, since then =
the
> +        * dentry used for the fsync may be an unlinked one, whose parent=
 is
> +        * not the parent of the remaining link.
>          */
> -       if (inode->vfs_inode.i_nlink < 2) {
> +       if (inode->vfs_inode.i_nlink < 2 &&
> +           inode->last_unlink_trans < trans->transid) {

So this now introduces the possibility of entering the fast path for
an inode with no refs (link count of 0),
wich will result in the function returning 1 (coming from the
btrfs_search_slot() call), and triggering a
transaction commit.

Early after the tracepoint call we should have:

if (inode->vfs_inode.i_nlink =3D=3D 0) {
    ret =3D 0;
    goto out;
}

See:  https://sashiko.dev/#/patchset/20261111-btrfs-link-unlink-fsync-v1-1-=
a817d4a890af%40columbia.edu

Otherwise it looks good, thanks.


>                 ret =3D log_new_ancestors_fast(trans, inode, parent, ctx)=
;
>                 goto out;
>         }
>
> ---
> base-commit: 4c34f0909344e48d917afac0eeffb6e1c2681524
> change-id: 20261111-btrfs-link-unlink-fsync-28ea82e5c56b
>
> Best regards,
> --
> Mani Tofigh <mt4022@columbia.edu>
>
>
>
