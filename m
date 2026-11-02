Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793636869;
	b=2kD5M+w6WYnMRZvpvN9rWXATiyqC0yQ1wZSUF98qfXaxXhBHjytpfzbmOm2Idw3FBwsY
	 L7vuq1tziJTYhFADUWVbyF2oP7zr12LSwdlraYpiNM7MeSq4qJh/hYuSVIJM3zLyHQjKs
	 nMK6arg+NQr9nujwNtWtjFmzY7N/PTz8hKZhJGhcCMEpgWJNwQkfFL7gR0lLvDOObk+7o
	 gOd8j061Q3WPJbTqkcaedF+pX4KL7Z8P/JUOKd7tXvZlTj4phNsn1SJGyTvna5GndW+Ol
	 J9HG4wCJo98pbF1XV0kr3Kubx8B4bLSXpc5XEH53O37ln0eRBrd3cmoADbTN6OkmrSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793636869;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=wHdtFy4kp/ZwM1BqNPeMTtm2ddmGgb+Bt7+4Qa7+AJg=;
	b=Dswo7ZagYt8hqiKovDBkBFcl9mwv6AsSf8CCOGnQaWand6ixNxcEA0rs64P1peBB2cSL
	 sdLmLJZjEXv8LtUaw2gvwKKGY8zQQzOS10bDS+OdXv/pwUpNedlT6WJMye0u8cizs2UpB
	 q87WgA5nI2n7WMS9kdVgMEUE5UrC124vwFJ4ZgQh4e8w8/ac8+st8yQw4FhDWtnpsrSLT
	 9PvXhgbbatJb48PLeI6DlIH6OOOxwiy+8aC7os/mR6h089b4tCQRA3V0ID6fltHnXgcwe
	 NTBtGAu3F5/zcaU+Z1P9UwIk0qjXQOnwd9RDwBKdOJlVVPmPnrVdE+OK1vjSSa22EXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eQiClhc3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 745EB60874E6
	for <linux-btrfs@vger.kernel.org>; Mon,  2 Nov 2026 16:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eQiClhc3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C10F1F00A28
	for <linux-btrfs@vger.kernel.org>; Mon,  2 Nov 2026 16:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793636869;
	bh=wHdtFy4kp/ZwM1BqNPeMTtm2ddmGgb+Bt7+4Qa7+AJg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=eQiClhc3f5SHGtIVBHZ4EBE4/N9ECAPQxqSFBKGKsk6A1gBkKKB3KVGS0zXArEqj5
	 WpifqFDNH2UNvXK40cNTsrOWSd/R3DPD6Jnr4lG86r5H+DNoUJXe+Y6Mx1q9yOv2Kn
	 4nFfaOpl5WlxYJBr/89t0ER2Hb18dh3cvl7yGV++MVX+Ur5DIXLhxT8TtA1hW/KTLh
	 W6b4w67lWb9blRbQ2gMz5Dm3cLpj04e4GGhj5mj8s6BmUz1XCV6uebtA9and2GBqHf
	 ytbS1BUUqIGz9dRWFn+EKbShfLUTohazZrL9uw6fuWQke1FBaifS0IAzLpJzc0hXFk
	 Y9JW9pdpphhpg==
Received: by mail-ua1-f47.google.com with SMTP id a1e0cc1a2514c-990fbae94f5so1962550241.3
        for <linux-btrfs@vger.kernel.org>; Mon, 02 Nov 2026 08:27:49 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBwOHrAgps2OGYK6LvPj4CKQVQPtUz/Ki8eWtR1Tep9NQ99pOY/L+NIWJREWZ+84eI0azL9aKj+bs2KwbQ==@vger.kernel.org
X-Gm-Message-State: APuU4Z+pN3IkUHn11u8AxKgel6xmzC01pppP318m/XoMH3PqgJjd5bYe
	ugbbRHOs6maXVEAiqtknhSc6OrkLmm5blNy642wLsgCbhEbDLu85KeAMyh5a4RtoM3QYWTyLH97
	5KDbvFcN6jJZmxeJkqB2wAnzhXViOTsg=
X-Received: by 2002:a05:6102:8092:b0:7cc:56a:58d3 with SMTP id
 ada2fe7eead31-7d07279cd1amr4474738137.31.1793636868341; Mon, 02 Nov 2026
 08:27:48 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261030-b4-btrfs-data-integrity-v1-0-f4d4196731e6@toxicpanda.com>
 <20261030-b4-btrfs-data-integrity-v1-4-f4d4196731e6@toxicpanda.com>
In-Reply-To: <20261030-b4-btrfs-data-integrity-v1-4-f4d4196731e6@toxicpanda.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 2 Nov 2026 16:27:11 +0000
X-Gmail-Original-Message-ID: <CAL3q7H5e4abXv+RCsy09Sb824yqNsrxMkn6PPt49aN9ZyZTj2w@mail.gmail.com>
X-Gm-Features: AclHuK9TcHojbk1WRwyX4MQgObBjTqCYoP4bFkRVWUT4s-4JmwoAESI9qBfcvLM
Message-ID: <CAL3q7H5e4abXv+RCsy09Sb824yqNsrxMkn6PPt49aN9ZyZTj2w@mail.gmail.com>
Subject: Re: [PATCH 4/5] btrfs: don't report success for a skipped log sync
To: Josef Bacik <josef@toxicpanda.com>
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
	Naohiro Aota <naohiro.aota@wdc.com>, Johannes Thumshirn <johannes.thumshirn@wdc.com>, 
	Qu Wenruo <wqu@suse.com>, Boris Burkov <boris@bur.io>, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 30, 2026 at 2:39=E2=80=AFPM Josef Bacik <josef@toxicpanda.com> =
wrote:
>
> When a commit of the log root tree gives up, because the transaction
> needs a full commit or writing the log failed, btrfs_sync_log() still
> advances log_transid_committed and hands the result to the contexts on
> the list. Unlike a successful commit it does not advance log_transid, so
> the log transaction it just retired is still the one new syncs join.
>
> A sync that gets to the log root tree after that adds its context to
> the emptied list, sees log_transid_committed >=3D its log_transid and
> returns its log_ret, which is still 0:
>
>   fsync A (subvol 1)           rename       fsync B (subvol 2)
>
>                                             btrfs_need_log_full_commit()
>                                               -> false
>                                btrfs_set_log_full_commit()
>   btrfs_need_log_full_commit()
>     -> true
>   btrfs_remove_all_log_ctxs()
>   log_transid_committed =3D N
>   log_transid stays N
>                                             log_transid =3D N, log_ret =
=3D 0
>                                             log_transid_committed >=3D N
>                                             return 0
>
> btrfs_sync_file() then ends the transaction without committing it, and a
> crash before A's transaction commit loses what B was told is durable.
> This was reproduced with delays added to btrfs_sync_log().
>
> Fix by advancing log_transid when a commit of the log root tree gives
> up, so a later sync joins the next log transaction and either commits it
> or gives up itself. The check for an already committed log transaction
> can then no longer be true, so assert that it isn't, and still force a
> full commit if it is.
>
> Fixes: d1433debe7f4 ("Btrfs: just wait or commit our own log sub-transact=
ion")
> CC: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>  fs/btrfs/tree-log.c | 20 ++++++++++++++++++--
>  1 file changed, 18 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index 1d9dfb63fc5a..b542b1d97989 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -3437,11 +3437,20 @@ int btrfs_sync_log(struct btrfs_trans_handle *tra=
ns,
>                 goto out;
>         }
>
> -       if (log_root_tree->log_transid_committed >=3D root_log_ctx.log_tr=
ansid) {
> +       /*
> +        * A commit of the log root tree moves log_transid on even when i=
t
> +        * gives up, so the log transaction we just joined can't be done.
> +        */
> +       if (unlikely(log_root_tree->log_transid_committed >=3D
> +                    root_log_ctx.log_transid)) {
> +               ASSERT(0, "log_transid_committed=3D%d log_transid=3D%d",
> +                      log_root_tree->log_transid_committed,
> +                      root_log_ctx.log_transid);

Can we please stop using ASSERT() where we pass a false value and have
code to handle the unexpected case?
Some distros like SUSE ones enable assertions by default, so this is
effectively the same as BUG_ON().

As we have code to deal with this and avoid a crash, just use
WARN_ON() in the if statements expression with btrfs_warn(), or the
DEBUG_WARN() macro we have.
Both will trigger a stack trace and make fstests report it if we ever
hit it, while avoiding the unnecessary crash from the BUG() call done
by ASSERT().

Otherwise, it looks good.
With that change:

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.



>                 blk_finish_plug(&plug);
>                 list_del_init(&root_log_ctx.list);
> +               btrfs_wait_tree_log_extents(log, mark);
>                 mutex_unlock(&log_root_tree->log_mutex);
> -               ret =3D root_log_ctx.log_ret;
> +               ret =3D BTRFS_LOG_FORCE_COMMIT;
>                 trace_btrfs_sync_log_exit(trans, root, ctx, ret);
>                 goto out;
>         }
> @@ -3575,6 +3584,13 @@ int btrfs_sync_log(struct btrfs_trans_handle *tran=
s,
>         mutex_lock(&log_root_tree->log_mutex);
>         btrfs_remove_all_log_ctxs(log_root_tree, index2, ret);
>
> +       /*
> +        * If the commit gave up, log_transid still names the log transac=
tion
> +        * we are retiring. Move it on, so that nobody joins a log transa=
ction
> +        * whose result has already been handed out.
> +        */
> +       if (log_root_tree->log_transid =3D=3D root_log_ctx.log_transid)
> +               log_root_tree->log_transid++;
>         log_root_tree->log_transid_committed++;
>         log_root_tree->log_commit[index2] =3D false;
>         mutex_unlock(&log_root_tree->log_mutex);
>
> --
> 2.55.0
>
>
