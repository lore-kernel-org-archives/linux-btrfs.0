Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793729458;
	b=DWluoA4L6Elrmxzl1wf1QoUrMi00Ut64V8f8RKBBbgyk0UPlz/1bwSQQvc2LkIU3ABuH
	 7L5JqMrUI1oAGjh+7lER7Y5R+liPe0H6/joOY9orCPtDvt4IddYeWrIy0+txKSGEaQkH+
	 EdYMX7nR/rpUuMko9S3hws9T1wh/CBThTLMHRvb4pMAhKtNKovNcf0dakDy6NPBVXa7Wt
	 XfRNlDoJYaylBPTIkKSREONRysHpB0Zg5wiPWDotxsaMQ1XkUM75c/IxRhPYqIg5cZ+jn
	 z3WKsDSltjF+1WuB4JLejpXdJ6TIPlt2Mi/2tEb0wzC01gOZt5kyQhNQPaSIUpjT7Pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793729458;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=tTVKurc9kGIhuhJC6hakp2QSmzsX9SX1tKAh9my/9n8=;
	b=nAEhz6oDPVcp01W2u0IXd7jby60ZklZlXOuHKrdCe6NJcMjPMi1DuM4GZ03vt85er4SM
	 qxJUknndoyJKfWhSSqxeLO6VOu4ZXuCrLg8R7pRzsdqZ5jmdIPX/5QX5Aj/N0n8/fvDgi
	 eEoqJLfjbS6AqR0jDtaop9cwWci04bMzlAvilB73yh8cB1tJDOUHoKc0mW8511A4MV9iU
	 I2CBAoYYkVF6ScYk3oljQWvhMx+ehFREiE/yoMLClt21MvWWRzH4viU+wwdy6pMbO2ezz
	 F21UCx5jj8XT5R9wvOY2v3hgckDEElrpTTeGj7p51ho1lHQh9xZ0rQme2KMVRBUKK8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CiVxSxyX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB57606A32E
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Nov 2026 18:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CiVxSxyX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F0D11F00A02
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Nov 2026 18:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793729457;
	bh=tTVKurc9kGIhuhJC6hakp2QSmzsX9SX1tKAh9my/9n8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=CiVxSxyXcV8KBx4YWfxiQ5fNcUhAzV3OPN/7XYb8GJwcQcLw4tirP8t6t+dkGUAXe
	 CB16uiBUhLKPiI0quA6HKqzw8ddg+HR33uZCN9H8jBN7fewXx/pcqwzAlxqTgfF30X
	 zW3Y1Kaif1YzomVeThV7ZKftUy8HkGF7GxPBMfG8F3fi2ab5AxiiK6kBF7mPmDsz0w
	 sU59+Uc01pogWNR2wi/iq2R8hAKTmzkzp88acDcPr5diXSZVk6WGXh2OWQ9UQRn97T
	 +pLjOb+R2wJc8UMMBIJx8AxIVk6OS74EueJ1lKQ5V9okFvAuOfx7RgkUpNamSqLYKA
	 y/DD8KL1d9w8Q==
Received: by mail-vk1-f182.google.com with SMTP id 71dfb90a1353d-5eadf48fb2dso1596505e0c.1
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Nov 2026 10:10:57 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBygZoybH9BUTB1yvfFTtwjPaLQpTC43JYtQxXa6M6dV/VqHUNDaIEwT4HnNVd3zs6Bxm0GYAdiN4qku2Q==@vger.kernel.org
X-Gm-Message-State: APuU4Z9vDHn11zyvd6A0/WouLWh7M78TP5Hj64AJTnRVW33WDq4TRlEJ
	HTSO/aA0rr/VINBZqOutvA0ZJtjCwcchCTqk8cynEMRJFTAvMgqK/6kieUIjf9TOgI8vwaiFgJy
	BS1gJIP54+syAcbM0Xb4YZMNJ/Q3aPXY=
X-Received: by 2002:a05:6122:488f:b0:5ec:3e18:a8da with SMTP id
 71dfb90a1353d-5ec689737efmr6255947e0c.17.1793729456351; Tue, 03 Nov 2026
 10:10:56 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261103-b4-btrfs-data-integrity-v2-0-577dc2690061@toxicpanda.com>
 <20261103-b4-btrfs-data-integrity-v2-3-577dc2690061@toxicpanda.com>
In-Reply-To: <20261103-b4-btrfs-data-integrity-v2-3-577dc2690061@toxicpanda.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Tue, 3 Nov 2026 18:10:19 +0000
X-Gmail-Original-Message-ID: <CAL3q7H6B9=fL2_Lx5OzWLRtFXNqfgnTn=kCf4NnE8JktuhSDKw@mail.gmail.com>
X-Gm-Features: AclHuK-enhHChCkU85AEg6Ya23uqbf2RYeIoQIh4TMc5ZRKj8fTxDdWuqhyj8Zg
Message-ID: <CAL3q7H6B9=fL2_Lx5OzWLRtFXNqfgnTn=kCf4NnE8JktuhSDKw@mail.gmail.com>
Subject: Re: [PATCH v2 3/5] btrfs: wait for ordered extent IO in fast fsync
To: Josef Bacik <josef@toxicpanda.com>
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
	Naohiro Aota <naohiro.aota@wdc.com>, Johannes Thumshirn <johannes.thumshirn@wdc.com>, 
	Qu Wenruo <wqu@suse.com>, Boris Burkov <boris@bur.io>, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 3, 2026 at 3:57=E2=80=AFPM Josef Bacik <josef@toxicpanda.com> w=
rote:
>
> A fast fsync waits for writeback and then checks
> BTRFS_INODE_COW_WRITE_ERROR to see whether a COW write failed. If one
> did, it must wait for the ordered extents to complete before logging,
> since until then the extent maps of the failed range point to extents
> that were never written. Logging them puts unwritten extents in place
> of the data that was there before when the log is replayed.
>
> The flag can be set too late for that check. end_bbio_data_write()
> clears writeback before it finishes the ordered extent:
>
>   end_bbio_data_write()            fsync
>
>   btrfs_folio_clear_writeback()
>                                    filemap_fdatawait_range()
>                                    BTRFS_INODE_COW_WRITE_ERROR clear
>                                    btrfs_log_changed_extents()
>   btrfs_finish_ordered_extent()
>     set BTRFS_INODE_COW_WRITE_ERROR
>
> The write paths that fail before submitting a bio, writepage_delalloc()
> and submit_write_sector(), clear writeback and finish the ordered
> extent through btrfs_mark_ordered_io_finished(), which never sets the
> flag at all.
>
> Fix by dropping the flag and having a fast fsync wait for
> BTRFS_ORDERED_IO_DONE on the ordered extents it collected for logging.
> can_finish_ordered_extent() sets it only after recording any error with
> BTRFS_ORDERED_IOERR. The wait costs little, because IO_DONE is set
> right after writeback is cleared, not when the ordered extent completes.
>
> Fixes: f13e01b89daf ("btrfs: ensure fast fsync waits for ordered extents =
after a write failure")
> Fixes: a11d6912fdd9 ("btrfs: remove folio parameter from ordered io relat=
ed functions")
> CC: stable@vger.kernel.org # 6.10+
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

The idea looks sound to me.

Sashiko found something and from a quick glance it seems valid to me:

https://sashiko.dev/#/patchset/20261103-b4-btrfs-data-integrity-v2-0-577dc2=
690061%40toxicpanda.com

Thanks.


> ---
>  fs/btrfs/btrfs_inode.h  | 10 ----------
>  fs/btrfs/file.c         | 52 +++++++++++++++++++++++++++++++++++++++----=
------
>  fs/btrfs/ordered-data.c | 31 -----------------------------
>  3 files changed, 42 insertions(+), 51 deletions(-)
>
> diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
> index f7aa0d145185..65ba8ec23258 100644
> --- a/fs/btrfs/btrfs_inode.h
> +++ b/fs/btrfs/btrfs_inode.h
> @@ -89,16 +89,6 @@ enum {
>         BTRFS_INODE_FREE_SPACE_INODE,
>         /* Set when there are no capabilities in XATTs for the inode. */
>         BTRFS_INODE_NO_CAP_XATTR,
> -       /*
> -        * Set if an error happened when doing a COW write before submitt=
ing a
> -        * bio or during writeback. Used for both buffered writes and dir=
ect IO
> -        * writes. This is to signal a fast fsync that it has to wait for
> -        * ordered extents to complete and therefore not log extent maps =
that
> -        * point to unwritten extents (when an ordered extent completes a=
nd it
> -        * has the BTRFS_ORDERED_IOERR flag set, it drops extent maps in =
its
> -        * range).
> -        */
> -       BTRFS_INODE_COW_WRITE_ERROR,
>         /*
>          * Set by reflink while it holds the source's VFS inode lock shar=
ed.
>          * Direct IO writes also take that lock shared; one that finds th=
is bit
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index f978c6524aa0..4ae9aed8993f 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -1512,6 +1512,42 @@ static inline bool skip_inode_logging(const struct=
 btrfs_log_ctx *ctx)
>         return false;
>  }
>
> +/*
> + * Wait for the IO of the ordered extents collected for logging to be do=
ne, and
> + * return true if a COW write among them failed.
> + *
> + * Waiting for writeback is not enough to know that: the end IO handlers=
 clear
> + * writeback before they account the IO in the ordered extent. An ordere=
d
> + * extent gets BTRFS_ORDERED_IO_DONE only once all of its IO is accounte=
d, and
> + * can_finish_ordered_extent() sets BTRFS_ORDERED_IOERR before that.
> + */
> +static bool cow_write_failed(struct btrfs_inode *inode,
> +                            struct list_head *ordered_extents)
> +{
> +       struct btrfs_ordered_extent *ordered;
> +       bool failed =3D false;
> +
> +       list_for_each_entry(ordered, ordered_extents, log_list)
> +               wait_event(ordered->wait,
> +                          test_bit(BTRFS_ORDERED_IO_DONE, &ordered->flag=
s));
> +
> +       /*
> +        * can_finish_ordered_extent() records a write error before it se=
ts
> +        * BTRFS_ORDERED_IO_DONE, both under this lock.
> +        */
> +       spin_lock(&inode->ordered_tree_lock);
> +       list_for_each_entry(ordered, ordered_extents, log_list) {
> +               if (test_bit(BTRFS_ORDERED_IOERR, &ordered->flags) &&
> +                   !test_bit(BTRFS_ORDERED_NOCOW, &ordered->flags)) {
> +                       failed =3D true;
> +                       break;
> +               }
> +       }
> +       spin_unlock(&inode->ordered_tree_lock);
> +
> +       return failed;
> +}
> +
>  /*
>   * fsync call for both files and directories.  This logs the inode into
>   * the tree log instead of forcing full commits whenever possible.
> @@ -1615,7 +1651,7 @@ int btrfs_sync_file(struct file *file, loff_t start=
, loff_t end, int datasync)
>          * IO of a lower priority task while holding a transaction open.
>          *
>          * For a full fsync we wait for the ordered extents to complete w=
hile
> -        * for a fast fsync we wait just for writeback to complete, and t=
hen
> +        * for a fast fsync we wait just for their IO to complete, and th=
en
>          * attach the ordered extents to the transaction so that a transa=
ction
>          * commit waits for their completion, to avoid data loss if we fs=
ync,
>          * the current transaction commits before the ordered extents com=
plete
> @@ -1627,7 +1663,6 @@ int btrfs_sync_file(struct file *file, loff_t start=
, loff_t end, int datasync)
>          */
>         if (full_sync || btrfs_is_zoned(fs_info)) {
>                 ret =3D btrfs_wait_ordered_range(inode, start, len);
> -               clear_bit(BTRFS_INODE_COW_WRITE_ERROR, &inode->runtime_fl=
ags);
>         } else {
>                 /*
>                  * Get our ordered extents as soon as possible to avoid d=
oing
> @@ -1640,15 +1675,12 @@ int btrfs_sync_file(struct file *file, loff_t sta=
rt, loff_t end, int datasync)
>                         goto out_release_extents;
>
>                 /*
> -                * Check and clear the BTRFS_INODE_COW_WRITE_ERROR now af=
ter
> -                * starting and waiting for writeback, because for buffer=
ed IO
> -                * it may have been set during the end IO callback
> -                * (end_bbio_data_write() -> btrfs_finish_ordered_extent(=
)) in
> -                * case an error happened and we need to wait for ordered
> -                * extents to complete so that any extent maps that point=
 to
> -                * unwritten locations are dropped and we don't log them.
> +                * If a COW write failed, before submitting a bio or duri=
ng IO,
> +                * the extent maps of its range point to unwritten locati=
ons
> +                * until the ordered extent completes and drops them. Wai=
t for
> +                * that, so that we don't log them.
>                  */
> -               if (test_and_clear_bit(BTRFS_INODE_COW_WRITE_ERROR, &inod=
e->runtime_flags))
> +               if (cow_write_failed(inode, &ctx.ordered_extents))
>                         ret =3D btrfs_wait_ordered_range(inode, start, le=
n);
>         }
>
> diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
> index df74c75d6c29..27aca31866fd 100644
> --- a/fs/btrfs/ordered-data.c
> +++ b/fs/btrfs/ordered-data.c
> @@ -436,37 +436,6 @@ void btrfs_finish_ordered_extent(struct btrfs_ordere=
d_extent *ordered,
>                                         uptodate);
>         spin_unlock(&inode->ordered_tree_lock);
>
> -       /*
> -        * If this is a COW write it means we created new extent maps for=
 the
> -        * range and they point to unwritten locations if we got an error=
 either
> -        * before submitting a bio or during IO.
> -        *
> -        * We have marked the ordered extent with BTRFS_ORDERED_IOERR, an=
d we
> -        * are queuing its completion below. During completion, at
> -        * btrfs_finish_one_ordered(), we will drop the extent maps for t=
he
> -        * unwritten extents.
> -        *
> -        * However because completion runs in a work queue we can end up =
having
> -        * a fast fsync running before that. In the case of direct IO, on=
ce we
> -        * unlock the inode the fsync might start, and we queue the compl=
etion
> -        * before unlocking the inode. In the case of buffered IO when wr=
iteback
> -        * finishes (end_bbio_data_write()) we queue the completion, so i=
f the
> -        * writeback was triggered by a fast fsync, the fsync might start
> -        * logging before ordered extent completion runs in the work queu=
e.
> -        *
> -        * The fast fsync will log file extent items based on the extent =
maps it
> -        * finds, so if by the time it collects extent maps the ordered e=
xtent
> -        * completion didn't happen yet, it will log file extent items th=
at
> -        * point to unwritten extents, resulting in a corruption if a cra=
sh
> -        * happens and the log tree is replayed. Note that a fast fsync d=
oes not
> -        * wait for completion of ordered extents in order to reduce late=
ncy.
> -        *
> -        * Set a flag in the inode so that the next fast fsync will wait =
for
> -        * ordered extents to complete before starting to log.
> -        */
> -       if (!uptodate && !test_bit(BTRFS_ORDERED_NOCOW, &ordered->flags))
> -               set_bit(BTRFS_INODE_COW_WRITE_ERROR, &inode->runtime_flag=
s);
> -
>         if (ret)
>                 btrfs_queue_ordered_fn(ordered);
>  }
>
> --
> 2.55.0
>
>
