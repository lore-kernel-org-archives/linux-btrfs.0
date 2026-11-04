Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793793459;
	b=m8ArnTai+P6lRHItF/X6RcnTfwX9mpXkCyqwcA9KkqbBge1GH+2LO4Wm+LafkxkUCk9Z
	 vu8/Gqcqj8n4gfAPF+mGQyDNrFy0/9VJFUicNpNOR8JfzVIDJdv8y9Fv7Ncm5knEH/Uwm
	 HbLVIQFSpNQ0DNsvR90Je3eQEGTfwpPNco/M6WNmGsqquJy6SSzm2cvktESl/wn7VRDTS
	 8rwnj8t5/2K2z5I6tfC4MQUzvhE+qvK9h8F5K8gZ7Ep6r0ZG56EQysLGMQwoXYzmhU4LL
	 8XNAjj4HdR2tnD81IjThLRpzPbZmaFhZkoYBMTA//eIY/gtDedZiY1LGtXAFOebUIjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793793459;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=AOSa42PZ0EBkvWUzilLM6ZlMyTO6uhgog9HjMJd/cKY=;
	b=Po4g1jpJwSmTydJc7I1RJHbB7mVY8unzSdjFkUQYG48EuAqnpVF1+DUq05ZQIa3fxeK1
	 lk47REEIqTk+4lypkhypDcnjaruDBYugTrKImX4OGJ+8qI8KorA8EDQh19SKfUiQNr1G2
	 GzJtQT1Xcomx0BXcqTBrqxSD6TcKe2WYPn4oW0P3+tIqg0zNWj9/VdTcjzDusNtD++bk7
	 ZtAyAA9KugNhPI9O4dG2ikU1k1xF0/fv4wO8GknUbaTlJSaGIb9RYg3n7DpS1CNOmUMKb
	 cgUC+8W+jS8kqR3T5yfMnBj4t6mwwG+IYnpt/1SUkwfM2lZbrmoZeEIi9jaCVLB5U6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fphZSRet;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 917BF606A31B
	for <linux-btrfs@vger.kernel.org>; Wed,  4 Nov 2026 11:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fphZSRet
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 336371F000C1
	for <linux-btrfs@vger.kernel.org>; Wed,  4 Nov 2026 11:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793793459;
	bh=AOSa42PZ0EBkvWUzilLM6ZlMyTO6uhgog9HjMJd/cKY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=fphZSRetoyf9CwLcnHqiWjUZjcbPUQgb940xMEiFGruO61NeHZDwqwlRM9QbsXsgI
	 Ij5lhyC1s5uC7yQJRYEhVzwy1xORCVH2E6DRgdPFJdSGzQfl9/stgop7ofAD285YED
	 0UO1SolEPHx8h7G1D5tCb8uHoa+0FFWuO7So3L2zWkdDwVDha7ogO1TsmKS/Bmtpia
	 h7BjjMqBzN1y3lOa7CD4TjnAMoKMksZtdvjA/9bInnoTuqdhK24VmePpc1VRG/uIxN
	 RsIsWACnCQQ2bUPq4NfkMVVV2hHDUHHwrRmrDUQ2XMaEvmxeqo6+V0wsOcChZO27/l
	 cvGqykmJVRfJA==
Received: by mail-ua1-f51.google.com with SMTP id a1e0cc1a2514c-998569550adso375664241.2
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Nov 2026 03:57:39 -0800 (PST)
X-Gm-Message-State: APuU4Z+byp5eHK4JjjcKk2YA6Kobq5hkzB2rJ5cH8uFndMlkdzk7v7XD
	IdMlxdMerjGKbCyF0dd4aKptY2BjSQkGoAbVKD+sJ9ABOFXNrB1CNNGffx6Mv4hkT51rskU/txV
	+MVqVsDeanCLzlyJwiV2SE1MUy16VsMU=
X-Received: by 2002:a05:6102:3707:b0:7cc:115:ddf1 with SMTP id
 ada2fe7eead31-7d072ca6eebmr5923139137.23.1793793458356; Wed, 04 Nov 2026
 03:57:38 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <c284dccd8c27a6434e56ed067b0ef4ea67935d8c.1793776224.git.wqu@suse.com>
In-Reply-To: <c284dccd8c27a6434e56ed067b0ef4ea67935d8c.1793776224.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Wed, 4 Nov 2026 11:57:02 +0000
X-Gmail-Original-Message-ID: <CAL3q7H7zcHB2Pf2NHnyJRSdMpi48QJeW4TvU0w4=geO2cStRtQ@mail.gmail.com>
X-Gm-Features: AclHuK-n_BRVdcUCH_d5oDBczmLPB2Lqs7GMrE8AEyfGvX1UkpNNsQuJEeJ0ZxM
Message-ID: <CAL3q7H7zcHB2Pf2NHnyJRSdMpi48QJeW4TvU0w4=geO2cStRtQ@mail.gmail.com>
Subject: Re: [PATCH RFC] btrfs: wait for encoded writes in fast fsync
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 4, 2026 at 7:11=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>
> [BUG REPORT]
> Sashiko reported a bug that encoded writes can have its file extents
> recorded before their data reaches disks.
>
> [CAUSE]
> An encoded write returns to the caller as soon as its bio is submitted,
> and its folios are not in the inode's page cache:
>
>   btrfs_ioctl_encoded_write()
>    \- btrfs_do_encoded_write()
>        |- btrfs_alloc_ordered_extent()
>        \- btrfs_submit_compressed_write()   <- returns before the bio end=
s
>
> A fast fsync only waits for writeback of the folios in the page cache,
> so it has nothing to wait for on such an ordered extent:
>
>   btrfs_sync_file()
>    |- btrfs_get_ordered_extents_for_logging()
>    |- filemap_fdatawait_range()             <- no folio under writeback
>    \- btrfs_log_dentry_safe()
>        \- ...
>            \- log_extent_csums()
>                \- log_csums()               <- csum_list may be in flight
>
> This has two problems:
>
> - fsync can return before the data of the encoded write is on disk, while
>   the log tree describing it is already persisted.
>
> - With async data checksum generation, the sums are attached to
>   ordered->csum_list by btrfs_csum_one_bio() before the checksums are
>   calculated.  log_extent_csums() can then log zeroed or partially
>   calculated checksums.
>
> For buffered writes this is not a problem, as writeback of a folio ends
> after the bio endio, which in turn runs after the checksums are
> generated.
>
> [FIX]
> Fix it by waiting for the encoded ordered extents in the fast fsync path
> before waiting for writeback.
>
> And if the encoded OE failed, also fail the whole fsync early.
>
> Such an ordered extent can only complete after its bio is finished,
> meaning the data is on disk and the checksums are fully generated.
>
> Link: https://sashiko.dev/#/patchset/8eb322321cac98013cc46dfe8d89fa58c1ad=
3dee.1793766229.git.wqu%40suse.com
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> Reason for RFC:
>
> This is only covering encoded IO, not direct IO.

And what is missing regarding direct IO?

Direct IO writes lock the inode, create ordered extents and wait for
them to complete before unlocking them, so an fsync will not miss
anything to my knowledge, as it locks the inode.

>
> As we should not mix direct and buffered IO in the first place, fsync()
> definitely counts as a function in the buffered IO family.

Direct IO and fsync are not incompatible in any way.

Applications that use direct IO writes need to call fsync to ensure persist=
ence.
Having worked in the database industry before, I can assure you using
direct IO and fsync is used in the real world.

>
> The problem is whether we should treat encoded IOs as buffered or direct?
>
> The encoded write itself doesn't wait for write to finish, so it looks
> like buffered, but on the other hand it doesn't touch page cache at all,
> which is similar to direct IO.
>
> Personally speaking, I tend to treat encoded IO more like buffered, thus
> that's why I sent the patch out, other than rejecting the Sashiko review
> result.
> ---
>  fs/btrfs/file.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
>
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 20e15dc30bfb..474bbb0adfef 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -1629,12 +1629,31 @@ int btrfs_sync_file(struct file *file, loff_t sta=
rt, loff_t end, int datasync)
>                 ret =3D btrfs_wait_ordered_range(inode, start, len);
>                 clear_bit(BTRFS_INODE_COW_WRITE_ERROR, &inode->runtime_fl=
ags);
>         } else {
> +               struct btrfs_ordered_extent *ordered;
> +
>                 /*
>                  * Get our ordered extents as soon as possible to avoid d=
oing
>                  * checksum lookups in the csum tree, and use instead the
>                  * checksums attached to the ordered extents.
>                  */
>                 btrfs_get_ordered_extents_for_logging(inode, &ctx.ordered=
_extents);
> +
> +               /*
> +                * Encoded writes don't mark any folio of the inode as wr=
iteback,
> +                * thus the fdatawait below can't wait for them.  Wait fo=
r them
> +                * explicitly, so that their data is on disk and their ch=
ecksums
> +                * are fully generated before we log them.
> +                */
> +               list_for_each_entry(ordered, &ctx.ordered_extents, log_li=
st) {
> +                       if (test_bit(BTRFS_ORDERED_ENCODED, &ordered->fla=
gs)) {
> +                               btrfs_start_ordered_extent(ordered);

We don't need to wait for the ordered extents to fully complete, we
only need to wait for the IO to complete.
So just:

wait_event(entry->wait, test_bit(BTRFS_ORDERED_IO_DONE, &entry->flags));

Otherwise, it adds unnecessary latency.

Thanks.


> +                               if (test_bit(BTRFS_ORDERED_IOERR, &ordere=
d->flags)) {
> +                                       ret =3D -EIO;
> +                                       goto out_release_extents;
> +                               }
> +                       }
> +               }
> +
>                 ret =3D filemap_fdatawait_range(inode->vfs_inode.i_mappin=
g, start, end);
>                 if (ret)
>                         goto out_release_extents;
> --
> 2.56.0
>
>
