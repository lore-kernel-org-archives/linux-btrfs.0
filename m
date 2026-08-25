Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E390E402442
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2026 12:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787661470; cv=none; b=P7znWFEFpNRE/s8HD33GRhx645KyqRKfDUO4EIf7LNzPnZAS6CcEvC+6BrxwvoyKUgUnOF33gColq9siCaLpfsTFp+TDkVnR9qRP9VAEeu2iucym7rk/iQ4B4uHfgMJglAHxI5Za6lvdutOAlJh1jATf0IadNUNA3CJ1k0xSzNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787661470; c=relaxed/simple;
	bh=nW0goDF1lw3wgVX+hXVdQ5JzKrikmGp0byjidOzKKc0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dB8RbrLZ5cje5Wwy2XmpLvZZK58Bta81DYlmzmtWV/+yFLuv4qYUEDUuTJhomqVcvd/yDla9Idnokyqnd27jKG8uJSZZFCH1iyMle7jVIMarGEzy6AI4rzL/ZJuUYvvHOTKGzijcRCoT+DYzOz1e45iVsuADpg0L32VG3pBnUB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dPHhgAsD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dPHhgAsD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E93E1F00ADB
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2026 12:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787661460;
	bh=YpLoxNm9E1OxWsRjz58S3a9Uf0rMpUscWFH5s7BZk6k=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=dPHhgAsDLpMia3kLb4c6owLgVbEPJzE4Y5WG8vg3fYD1J36Mvo39yxLUlTKetnIVT
	 fyRY3FcAhik3lAjU0s0V8a091jZ57v6+lA9nCBD7Y9Tx8uktKSd/g4gTYtDosQsQXO
	 Y/i+YCFC0hH4uuCUqTBm7rzbGLnjRuRtki3P/CVLBGk3SlkSpM0h4sfIlBwepE+6W/
	 7kJyMwEfingQ0XQGN7iEtFj8YywRnZg8XvjcYWo9ftQmHlp37OnKeFdmrKGeqNqMIZ
	 vea48SI3wHj1MVRlxGW8uzytE8fxPzpoM4HqlzscFdFRbhbkN8tRXuVu/CrzQO4gqs
	 8CSDX1Q3feNCA==
Received: by mail-vs1-f49.google.com with SMTP id ada2fe7eead31-7389cff36bdso1331199137.1
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2026 05:37:40 -0700 (PDT)
X-Gm-Message-State: AFuF++nQzDXgQ9iUMgLUVQRb4wz+80OeivWAp/pYHz/74QEA2PiT1TlR
	gJT213ozMdTiNSndxsm062K2zyXuk0OnoD1fOLrmYzBXLFIMluPAXHF81RBI7oWdu93i8St4487
	CkZBpONIVGx9N4ows2pk2KTgNRm6RPDs=
X-Received: by 2002:a05:6102:3714:b0:77f:7df:c9ef with SMTP id
 ada2fe7eead31-77f07dfde0dmr3616637137.0.1787661459443; Tue, 25 Aug 2026
 05:37:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <698c480ec13cd6e74c2175924f614b7e324e6cc3.1787099421.git.loemra.dev@gmail.com>
In-Reply-To: <698c480ec13cd6e74c2175924f614b7e324e6cc3.1787099421.git.loemra.dev@gmail.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Tue, 25 Aug 2026 13:37:03 +0100
X-Gmail-Original-Message-ID: <CAL3q7H7xw8ettj+HuHsbED_znfrtL_JYicsHN-TnmS5njxWJ4w@mail.gmail.com>
X-Gm-Features: AcwNN1UM9XYeWTDi5mzluo04A0EatJuCIB3CvspSPfdBtuuqQblfzIfXX0Vitc0
Message-ID: <CAL3q7H7xw8ettj+HuHsbED_znfrtL_JYicsHN-TnmS5njxWJ4w@mail.gmail.com>
Subject: Re: [PATCH] btrfs: abort transaction before releasing tree_log_mutex
 on commit failure
To: Leo Martins <loemra.dev@gmail.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com, Chris Mason <clm@fb.com>, 
	David Sterba <dsterba@suse.com>, Filipe Manana <fdmanana@suse.com>, 
	Johannes Thumshirn <johannes.thumshirn@wdc.com>, Josef Bacik <josef@toxicpanda.com>, 
	Qu Wenruo <wqu@suse.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 19, 2026 at 1:40=E2=80=AFAM Leo Martins <loemra.dev@gmail.com> =
wrote:
>
> When transaction metadata writeout fails in btrfs_commit_transaction(),
> the current code only logs the error, drops tree_log_mutex and then goes
> through cleanup_transaction(), which aborts the transaction and records
> the fs error.
>
> That is too late for the tree log side. A log sync can already be
> waiting on tree_log_mutex, because the committing transaction is moved
> to TRANS_STATE_UNBLOCKED while that mutex is held, which lets fsyncs
> join the next transaction and queue up in btrfs_sync_log(). Once the
> failed commit drops tree_log_mutex, such a log sync acquires it, sees
> BTRFS_FS_ERROR() still clear, and writes super_for_commit. That
> superblock holds the roots prepared for the transaction that has just
> failed to write out its metadata, so it can point at tree blocks that
> never reached the disk, and the next mount fails with a parent transid
> mismatch.
>
> Commit 165ea85f1483 ("btrfs: do not write supers if we have an fs
> error") fixed this class of problem by making btrfs_sync_log() check for
> an fs error right after taking tree_log_mutex. That check only works if
> the commit path publishes the fs error before it releases the same
> mutex, and commit 68d4ece9c30e ("btrfs: don't call
> btrfs_handle_fs_error() in btrfs_commit_transaction()") removed the only
> thing that did so.
>
> Restore the ordering by aborting the transaction while tree_log_mutex is
> still held. We have a transaction handle here, so this does not need to
> bring back the btrfs_handle_fs_error() call: __btrfs_abort_transaction()
> records the fs error itself, which is all btrfs_sync_log() looks at, and
> the error message put in its place is kept.
>
> This is what commit 3810ab40afa5 ("btrfs: abort transaction on error in
> write_all_supers()") already does for the next call in this function.
>
> This is reproducible on an unmodified kernel by failing the first
> couple of bios of a transaction commit with fail_make_request while a
> concurrent fsync workload keeps log syncs queued on tree_log_mutex.
>
> Fixes: 68d4ece9c30e ("btrfs: don't call btrfs_handle_fs_error() in btrfs_=
commit_transaction()")
> Cc: stable@vger.kernel.org # 7.0+
> Signed-off-by: Leo Martins <loemra.dev@gmail.com>

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.

> ---
>  fs/btrfs/transaction.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 13a7e5f4e08c..ed850bf0546a 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -2583,6 +2583,12 @@ int btrfs_commit_transaction(struct btrfs_trans_ha=
ndle *trans)
>         ret =3D btrfs_write_and_wait_transaction(trans);
>         if (unlikely(ret)) {
>                 btrfs_err(fs_info, "error while writing out transaction: =
%pe", ERR_PTR(ret));
> +               /*
> +                * Abort before releasing tree_log_mutex, so a log sync w=
aiting
> +                * on it sees the fs error and skips writing super_for_co=
mmit
> +                * for this failed transaction. See btrfs_sync_log().
> +                */
> +               btrfs_abort_transaction(trans, ret);
>                 mutex_unlock(&fs_info->tree_log_mutex);
>                 goto scrub_continue;
>         }
> --
> 2.53.0-Meta
>
>
