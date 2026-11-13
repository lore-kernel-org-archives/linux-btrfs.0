Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794592386;
	b=CDwWI0oz3AMF2vG0Mu1DmA88k7nMtEO5lcTaeYyH+G7/RO+zjfB2nn2gGIef1I4LHjt3
	 sNSz5zi6ilTi4A61YN2uGRNKzXZTB6dMY413NoLCKcwIo3ipWzORenFtr7FTzayAXzRyt
	 zg48c/ypjNM0LJz3qAXUmfZG3NFK+1+BI9yj/E+QJ8GZAOq8/BkK/EwceLq0MbBUNYo3I
	 QEa+xgqm0Fi/OUWGprkMHi/ImZra/TpgScUSRGxR/QT7ZltbdzYG5n8DRvPmhZx6IprTY
	 aqIQhb6VULzI6bwrSPUaGPihNCkYwHkRRKnk4uJpluRsQjLKEyog0Byos24Ixs3HrQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794592386;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=3K6GQGglJHS9t8V8FbeRCzBMBiOZNvgwdt+VXhB26ZU=;
	b=vVlHIQEQB/eeNzaCO0fFiARjuFOI1TUVVIITGzf2EEPSVfjYVl7uEKzwe2LsQublLz4u
	 4DsqhRWpO4iG8XHfqOwOTkFqjB51ICXKBwIuCpGIsGM1Zd73XNPnyulgCh5n7s4xzBP0h
	 N1FvlXr31JJUyrKYcDR1FaROwCSq+5UwnxhdK8HZEnNM+wzJMz22y551cuXOAt1hZhrnX
	 z6mbf+mzieVo4vnIpb/ClChS3LHIfSv54a6zKENAiCEZwRYrjWBNCNVHcnL9oEY9jDJez
	 xdOR8nB+q6x+qGXpabwaxM28j/N1ArFojrow9WtRrCQc49KNcGYtNHhNSfGTCnkUbrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CrrTARr6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D10606A883
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 17:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CrrTARr6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B7981F000C7
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 17:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794592385;
	bh=3K6GQGglJHS9t8V8FbeRCzBMBiOZNvgwdt+VXhB26ZU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=CrrTARr6RxvHMJeMRi2jzs3Q43M/LmeupBn6HwzdOrn8PJXAM6jQACYKEe79bajBs
	 +wMpgl8+SNwkbUEMQYzeAhkByUCc5sgWnC79hx98R/MbQF0GMAzrT5siMSGeR4raJu
	 mkF2buLZVksGtpZL2jCwPJv9JBHdkDshZGStdz4UivusZOSLKB/+NzQeaakw1tArsq
	 dDBSAzApj/hnzp9HnF9T5igVcOmniQ1UnRIi7LC4yddNoBUpJA6cPb/X62MsnXcPk+
	 zb8TCvomZp1wCdsgaNJKhPRD4WWP4WCL2Rs1Oqku9JbgpCqmVb67DEiKnvQFXPM/pM
	 oQQR2mLIiZJgQ==
Received: by mail-vs1-f52.google.com with SMTP id ada2fe7eead31-7d2dbe5c4b0so339582137.0
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 09:53:05 -0800 (PST)
X-Gm-Message-State: APuU4Z8pwSkzAl4PFDL3X/6ir8NAV2mPqa+rO2Y8Fi/qXAP2UM/ZtVQ8
	biFczVOa4vFqY1N2LRwW3fA7UT2EXiMeTVAlPmw9OxXoioJtYqUbSuV/t4m6ifVCa3Ogy1Vha8f
	nSq3Dhesup8NJjnSjrFqthicm7zNo1bU=
X-Received: by 2002:a05:6102:6cf:b0:7d2:75bf:2fd6 with SMTP id
 ada2fe7eead31-7d64d78d455mr950836137.18.1794592384712; Fri, 13 Nov 2026
 09:53:04 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <02d1a8fbadb25335495cdcf147785216b5cd8934.1794524252.git.wqu@suse.com>
In-Reply-To: <02d1a8fbadb25335495cdcf147785216b5cd8934.1794524252.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Fri, 13 Nov 2026 17:52:28 +0000
X-Gmail-Original-Message-ID: <CAL3q7H4E0DMoTzW2KKX+frLozi11Ci9wtOK97EDuBkDehowYpQ@mail.gmail.com>
X-Gm-Features: AclHuK9CI8z915mhUELuqd9OIQObXy9-KCm1wWulVzQ--sZYTI-TYyNDs8GLG_w
Message-ID: <CAL3q7H4E0DMoTzW2KKX+frLozi11Ci9wtOK97EDuBkDehowYpQ@mail.gmail.com>
Subject: Re: [PATCH] btrfs: do not unwind a committed device in btrfs_init_new_device()
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, Sashiko <sashiko-bot@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 12, 2026 at 11:33=E2=80=AFPM Qu Wenruo <wqu@suse.com> wrote:
>
> Sashiko reported an use-after-free bug during error handling of
> btrfs_init_new_device(), that error from btrfs_attach_transaction() can
> cause use-after-free:
>
>  btrfs_init_new_device()
>  |-btrfs_commit_transaction()
>  | ^^^ device is now in the chunk tree, chunks are allocated on it
>  |     and the fsid is changed
>  |
>  |-mutex_unlock(&uuid_mutex);
>  | ^^^ uuid_mutext unlocked.
>  |
>  |-btrfs_attach_transaction()
>  | ^^^ fails with -ENOMEM for allocation failure or -EROFS for
>  |     aborted transaction.
>  |
>  \-goto error_sysfs
>    |-btrfs_sysfs_remove_device()
>    |-list_del_rcu(&device->dev_list)
>    |
>    |-btrfs_rollback_sprout()
>    | ^^^ asserts uuid_mutex, which is not held anymore
>    |
>    \-btrfs_free_device()
>      ^^^ chunk maps still point to the freed device
>
> Since the device can not be unwound once committed, do not go through
> the unwind path. We have no transaction handle to abort, so call
> btrfs_handle_fs_error() to force the fs read-only (a no-op if it
> already is), release the freeze protection and return the error.
>
> Also let the -ENOENT and attach failure exits run btrfs_forget_devices()
> and update_dev_time() like the success path, as the device is committed.
>
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Link: https://sashiko.dev/#/bug/linux-c339b137-b739-4f8d-8cc5-0960dee662e=
e
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Looks good, thanks.

> ---
>  fs/btrfs/volumes.c | 19 +++++++++++++------
>  1 file changed, 13 insertions(+), 6 deletions(-)
>
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index f2b4664b5fd4..8b94c509b85d 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -3165,17 +3165,24 @@ int btrfs_init_new_device(struct btrfs_fs_info *f=
s_info, const char *device_path
>                                     "Failed to relocate sys chunks after =
device initialization. This can be fixed using the \"btrfs balance\" comman=
d.");
>                 trans =3D btrfs_attach_transaction(root);
>                 if (IS_ERR(trans)) {
> -                       if (PTR_ERR(trans) =3D=3D -ENOENT) {
> -                               bdev_allow_freeze(file_bdev(bdev_file));
> -                               return 0;
> -                       }
>                         ret =3D PTR_ERR(trans);
> -                       trans =3D NULL;
> -                       goto error_sysfs;
> +                       if (ret =3D=3D -ENOENT) {
> +                               ret =3D 0;
> +                               goto device_added;
> +                       }
> +                       /*
> +                        * The new device is already committed and in use=
, we
> +                        * can not unwind it anymore. There is no transac=
tion
> +                        * handle to abort, so force the fs read-only ins=
tead.
> +                        */
> +                       btrfs_handle_fs_error(fs_info, ret,
> +       "Failed to attach transaction after device initialization");
> +                       goto device_added;
>                 }
>                 ret =3D btrfs_commit_transaction(trans);
>         }
>
> +device_added:
>         /*
>          * Now that we have written a new super block to this device, che=
ck all
>          * other fs_devices list if device_path alienates any other scann=
ed
> --
> 2.56.0
>
>
