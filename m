Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D712E0914
	for <linux-btrfs@vger.kernel.org>; Sun,  7 Jun 2026 20:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780864322; cv=none; b=hZeeo5YAKmHn5glNhcKNvaifawnYNCHykmXsjax8H9BKUUY/E6icEd+jZ1rcQCZF+nI3rnYwvh8C/qu+mvn9b7p76x2nm/fAdECnPWK8f1ekoepLLfY28azehop9e6Si2/ITDpQaS9Iyvg5+qtZYWvHNY9zKYqZnAA1OiiZxECc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780864322; c=relaxed/simple;
	bh=7AhTPB4lsPO5kOsmokM9jycV/pTGKN7SLETsMda0Hwo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=fLDITTApL5cKyIYihFq0422LSJ1RXUvVFbRVyWZgPStjfHYwSri7AX8KMpfSUOZSKT7Sk/m3q1NAjKD+C6P430yGuKqa07KDA2AtHcyQmUuOylZ80Hgwh/RkF00GB8AiOalvXAwUjXAXrCDeu9Q5wwqwTSLB/b8dkkViSBGhTEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mssola.com; spf=fail smtp.mailfrom=mssola.com; dkim=pass (2048-bit key) header.d=mssola.com header.i=@mssola.com header.b=LRnrODj5; arc=none smtp.client-ip=80.241.56.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mssola.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=mssola.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mssola.com header.i=@mssola.com header.b="LRnrODj5"
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4gYRSg6xq0z9tFH;
	Sun,  7 Jun 2026 22:23:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mssola.com; s=MBO0001;
	t=1780863796;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cFnoe2XkdNCXd/u7i4Sc+sdmG/etrOI4GiYGczyf0CU=;
	b=LRnrODj5eQY4S7p1v7KcBOZvRxzhPnn5j6z3XvjUmmb6LrckR8+pnSEdFIMfB5Q+QpaiAi
	55RP6fWCWSYK0WCv/MQMBvo15ewS2FtxtFGSXPiDJT7/kHvT6SwmBdbYtOjiIDE438Fw6n
	tJ/USPdq9gK50DU+GTCvwRON56dQ5ekZsqxBJwXRAAHIJYseJ4q6vDsGF2qw71pwVGduIQ
	O4F1RiYljdfh7YxVP3T/fENsoxInlFaVj5w2ijr7I9UayD19triimfAa4h6JNM4+gtZgZB
	PAY1YfYWee5tny+gXhObw+Hoh34WJDWgHpi8JI1O0seUgmGqCeTjLrjm+cXB8Q==
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=softfail (outgoing_mbo_mout: 2001:67c:2050:b231:465::1 is neither permitted nor denied by domain of mssola@mssola.com) smtp.mailfrom=mssola@mssola.com
From: =?utf-8?Q?Miquel_Sabat=C3=A9_Sol=C3=A0?= <mssola@mssola.com>
To: Weiming Shi <bestswngs@gmail.com>
Cc: linux-btrfs@vger.kernel.org,  dsterba@suse.com,  josef@toxicpanda.com,
  clm@fb.com,  xmei5@asu.edu
Subject: Re: [PATCH] btrfs: reject names longer than BTRFS_NAME_LEN in
 btrfs_get_name()
In-Reply-To: <20260607121429.2091845-1-bestswngs@gmail.com> (Weiming Shi's
	message of "Sun, 7 Jun 2026 05:14:29 -0700")
References: <20260607121429.2091845-1-bestswngs@gmail.com>
Date: Sun, 07 Jun 2026 22:23:09 +0200
Message-ID: <87fr2yw15e.fsf@>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"
X-Rspamd-Queue-Id: 4gYRSg6xq0z9tFH

--=-=-=
Content-Type: text/plain

Hi,

Weiming Shi @ 2026-06-07 05:14 -07:

> btrfs_get_name() reads the name length straight from the on-disk
> inode_ref (or root_ref) and copies that many bytes into the caller's
> buffer with no upper bound. The caller (exportfs_get_name()) supplies a
> fixed NAME_MAX + 1 byte stack buffer, but name_len is a __le16 read from
> the leaf and the tree-checker only bounds it to the item size, not to
> BTRFS_NAME_LEN. A crafted leaf with name_len = 4096 therefore overflows
> the 256-byte buffer with attacker-controlled bytes. It is reachable from
> a mounted untrusted btrfs image via open_by_handle_at(), and on btrfs
> filesystems exported over NFS.
>
>  BUG: KASAN: stack-out-of-bounds in read_extent_buffer (fs/btrfs/extent_io.c:3742)
>  Write of size 633 at addr ffffc90006c9fc40 by task exploit/5192
>   read_extent_buffer (fs/btrfs/extent_io.c:3742)
>   btrfs_get_name (fs/btrfs/export.c:289)
>   reconnect_path (fs/exportfs/expfs.c:222)
>   exportfs_decode_fh_raw (fs/exportfs/expfs.c:473)
>   do_handle_open (fs/fhandle.c:230)
>   do_syscall_64 (arch/x86/entry/syscall_64.c:94)
>  Kernel panic - not syncing: stack-protector: Kernel stack is corrupted
>
> Reject any name_len greater than BTRFS_NAME_LEN before the copy. Such a
> name is never valid on disk, so this only rejects corrupted leaves and
> leaves valid names unchanged.
>
> Fixes: 2ede0daf0154 ("Btrfs: handle NFS lookups properly")
> Reported-by: Xiang Mei <xmei5@asu.edu>
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Weiming Shi <bestswngs@gmail.com>
> ---
>  fs/btrfs/export.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/fs/btrfs/export.c b/fs/btrfs/export.c
> index c403117ac..a54c6e8b3 100644
> --- a/fs/btrfs/export.c
> +++ b/fs/btrfs/export.c
> @@ -285,6 +285,16 @@ static int btrfs_get_name(struct dentry *parent, char *name,
>  		name_len = btrfs_inode_ref_name_len(leaf, iref);
>  	}
>
> +	/* The caller's buffer is only NAME_MAX + 1 bytes. */
> +	if (name_len > BTRFS_NAME_LEN) {
> +		btrfs_err(fs_info,
> +			  "corrupt name length %d for inode %llu in root %llu, max %d",
> +			  name_len, btrfs_ino(BTRFS_I(inode)),
> +			  btrfs_root_id(BTRFS_I(inode)->root), BTRFS_NAME_LEN);
> +		btrfs_free_path(path);

Nitpicking: this is not necessary as 'path' is declared with a cleanup
attribute.

> +		return -EUCLEAN;
> +	}
> +
>  	read_extent_buffer(leaf, name, name_ptr, name_len);
>  	btrfs_free_path(path);

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJiBAEBCgBMFiEEG6U8esk9yirP39qXlr6Mb9idZWUFAmol0y0bFIAAAAAABAAO
bWFudTIsMi41KzEuMTIsMiwyEhxtc3NvbGFAbXNzb2xhLmNvbQAKCRCWvoxv2J1l
ZdoWEACxMUfUk7zv20+gRvQSpodrPYy9I/msztSOrHgdsXhkgtp0c02DjIMpnI8B
uo7azkFlyPYrBbg6d/v/tyQcKwfaoLmTdAKJN8RJHx0zM51DoBOImH3Y0pp+9zU7
rbBk85Z4OReWyNob6HIMiEm2GzMBYvn0ZtY6wxcG5m15RjSYk2/TNJe2QxfQ6Pnv
wLGOW6/KzOEu8nsfwUCrA1uQ3EYIHepOxWrmFUbNJ5WHUkSz7QkkzyXpbPVe80rb
UsRKSuiCP4fD/DF1ojtPkDZ4Gct7ceyBfwlEMuKZvJiyiFffAFI9En5cLuEq7Nf5
5idCMCMFh6BcawLxY5lCaxLaUiRV8ONKdNJTcgEUkvoCiKpK7CVAMAZt1Y4SgWUs
wl0vna43dvwZhKgiqbXcXKYd8g4TsmCQJYZwys0wtx4fJyrhXkX5lam6M4/O/g7g
rIGSnHGDz8Eo78d7NfJKHHgWSE+UgTm3Safxn2cBWaYOtC4LzWtwf93A/kMGCj0M
2Eyj6CQizL41BxYViGyWIdUZ1yi6qWHgT5kCqeDro1GYkjQidCjgUoIRMq1nXqvW
1I1u9767FCM0IybIkiYUQHEvrRHkErKxN/vf/HRJjtwtlk+v/FD9HOuiFN51SbXT
nQ2RT4j6435BiqXlYfCL0NRY68ZHBJ5rlOs1fpHvd+u7e5M99Q==
=kcma
-----END PGP SIGNATURE-----
--=-=-=--
