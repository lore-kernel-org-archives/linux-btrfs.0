Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BCBA54654
	for <linux-btrfs@vger.kernel.org>; Thu, 16 Apr 2026 10:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776334988; cv=none; b=Nzrai5xcgJYjadTZtRz9eoOUXpJ/8kZHlQwlgT1XqSYy/Icqzh70kuW6sw9mxCh9bdJl7mwcLDc+NewRLx5ixRBedVKT98SEsiZo02e0MyLZ0rSXaIrRid8sNmKaP28+xcIlS5IrkY0iX7NR9GJrUiMVNlbcAKgS3+95dGLfbXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776334988; c=relaxed/simple;
	bh=ZKiWKJ8SwdqvaKEqqbzM4V3ssnqSv8zG+SQ1rvnKAlE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SgKZgnVrVKq3gopRL9Ymft6He0XEXH9pg+0u3QLrWIosCM6nsIxC6mzN5IM7B89Zj3w96SUCL38FXMqFlrbwnDQANt775grENV3P48Wf/1Uw/TBySkpXTBtMH4S4DuqhO3SQmjfBxXqi8gNO/yHTOKRszGjKX67VAVrz9xEPzbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QVvAOeoM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QVvAOeoM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2DD9C2BCB0
	for <linux-btrfs@vger.kernel.org>; Thu, 16 Apr 2026 10:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776334988;
	bh=ZKiWKJ8SwdqvaKEqqbzM4V3ssnqSv8zG+SQ1rvnKAlE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=QVvAOeoM4Vk9wa+8d7XG5bJw+hdMfj4JyKL4c2j0uszTSWzNZK7a0ern020P/fX9F
	 C4E8V7sr99SJQf4c0wzGLppEiqcXxnN2jKvHSWbN/nw2UEPrnYNbSb+myUzKo5zyV0
	 qVQUXNsD29A14PP6purelbdc45HjWkDDUBHGNWDM9acIAgbKuw0JY3fBTjwzKOd6rB
	 W0rG7jAyMfWh9URfSRSvPnqMprMROxeiSZ/7zDDGiRzfqwX98W2c6GNgRAFvF61LsS
	 X32Hl5FcbOyvH9hf4N+xMxZCmUAnMRGg8VXw7ape4cE5KIICq0sVbEA2q1r5AQZh1F
	 YjRhjjI0I2jzw==
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b9d6c8871c7so1188353966b.1
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Apr 2026 03:23:07 -0700 (PDT)
X-Gm-Message-State: AOJu0Yzf25Httv2P9fy79fvR8QZcgeZ0AgtZ5nAmp+OJO2iw51PrwYZ3
	a6u371foEhaS53HkVUIUl4bQH2tQBkB3VcX8b/fMy+ceVyN55EqrDI+nqUaholosbNrfdbJrI+G
	TRUeg3IYg6moMh0yqIRUfa5Gw50TNv0Q=
X-Received: by 2002:a17:907:3e04:b0:b9e:f58:c581 with SMTP id
 a640c23a62f3a-b9e0f58c5c2mr622785366b.45.1776334986493; Thu, 16 Apr 2026
 03:23:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1c3a439e1e21c4ee32575b264ac0bc3935ea4f53.1775364843.git.wqu@suse.com>
 <CAL3q7H45KF=ptRmAEE32J07oeewV3h-Zq8k_-LhO15PnReL+2Q@mail.gmail.com> <ec6a7a95-28d2-41bc-85a7-ef36e58ff9bd@suse.com>
In-Reply-To: <ec6a7a95-28d2-41bc-85a7-ef36e58ff9bd@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Thu, 16 Apr 2026 11:22:27 +0100
X-Gmail-Original-Message-ID: <CAL3q7H5EoAZes0kfyTE_8G=idD-V_NmAGGuR_vu90+HBb6dTsQ@mail.gmail.com>
X-Gm-Features: AQROBzCIihvlLbpV7PYNJGAtBKK1usc52cbygkmJ6unvrOoTyTURFvRauF-GQMQ
Message-ID: <CAL3q7H5EoAZes0kfyTE_8G=idD-V_NmAGGuR_vu90+HBb6dTsQ@mail.gmail.com>
Subject: Re: [PATCH] btrfs: warn about extent buffer that can not be released
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, AHN SEOK-YOUNG <iamsyahn@gmail.com>, 
	Teng Liu <27rabbitlt@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 16, 2026 at 12:02=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>
>
>
> =E5=9C=A8 2026/4/15 20:55, Filipe Manana =E5=86=99=E9=81=93:
> > On Sun, Apr 5, 2026 at 5:56=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
> >>
> >> When we unmount the fs or during mount failures, btrfs will call
> >> invalidate_inode_pages() to release all btree inode folios.
> >>
> >> However that function can return -EBUSY if any folios can not be
> >> invalidated.
> >> This can be caused by:
> >>
> >> - Some extent buffers are still held by btrfs
> >>    This is a logic error, as we should release all tree root nodes
> >>    during unmount and mount failure handling.
> >>
> >> - Some extent buffers are under readahead and haven't yet finished
> >>    This is much rarer but valid cases.
> >>    In that case we should wait for those extent buffers.
> >>
> >> Introduce a new helper invalidate_btree_folios() which will:
> >>
> >> - Call invalidate_inode_pages2() and catch its return value
> >>    If it returned 0 as expected, that's great and we can call it a day=
.
> >>
> >> - Otherwise go through each extent buffer in buffer_tree
> >>    For eb that still has EXTENT_BUFFER_READING flag, wait for them to
> >>    finish first.
> >>
> >>    Then check if the refs of the eb is greater than 1, if so it means
> >>    it's still held by someone, give it a warning.
> >>
> >> Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D221270
> >> Reported-by: AHN SEOK-YOUNG <iamsyahn@gmail.com>
> >> Cc: Teng Liu <27rabbitlt@gmail.com>
> >> Signed-off-by: Qu Wenruo <wqu@suse.com>
> >> ---
> >> This new debug feature has exposed some problems, e.g. generic/648,
> >> after an injected failure for device barrier, transaction is aborted b=
ut
> >> we have a lot of dirty tree blocks unreleased and triggered the new
> >> warning.
> >>
> >> We still need to fix these corner cases.
> >>
> >> Meanwhile if Ahn or Teng can give this patch a try for the existing
> >> use-after-free problem, it would be appreciated a lot.
> >> ---
> >>   fs/btrfs/disk-io.c   | 52 ++++++++++++++++++++++++++++++++++++++++++=
--
> >>   fs/btrfs/extent_io.c |  6 -----
> >>   fs/btrfs/extent_io.h |  6 +++++
> >>   3 files changed, 56 insertions(+), 8 deletions(-)
> >>
> >> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> >> index b8ac3275d8f8..d450bfc6d89b 100644
> >> --- a/fs/btrfs/disk-io.c
> >> +++ b/fs/btrfs/disk-io.c
> >> @@ -3276,6 +3276,54 @@ static bool fs_is_full_ro(const struct btrfs_fs=
_info *fs_info)
> >>          return false;
> >>   }
> >>
> >> +static void invalidate_btree_folios(struct btrfs_fs_info *fs_info)
> >> +{
> >> +       XA_STATE(xas, &fs_info->buffer_tree, 0);
> >> +       unsigned int checked =3D 0;
> >> +       void *tmp;
> >> +       int ret;
> >> +
> >> +       ret =3D invalidate_inode_pages2(fs_info->btree_inode->i_mappin=
g);
> >> +       if (likely(ret =3D=3D 0))
> >> +               return;
> >> +
> >> +       /*
> >> +        * Some btree pages can not be invalidated, this happens when =
some
> >> +        * tree blocks are still held (either by some pointer or reada=
head).
> >> +        */
> >> +       xas_lock_irq(&xas);
> >> +       xas_for_each(&xas, tmp, ULONG_MAX) {
> >> +               struct extent_buffer *eb =3D tmp;
> >
> > Why use the tmp variable? We can pass 'eb' to xas_for_each().
> >
> >> +
> >> +               /* Wait for any readahead first. */
> >> +               if (test_bit(EXTENT_BUFFER_READING, &eb->bflags)) {
> >> +                       xas_pause(&xas);
> >> +                       xas_unlock_irq(&xas);
> >> +                       wait_on_bit_io(&eb->bflags, EXTENT_BUFFER_READ=
ING,
> >> +                                      TASK_UNINTERRUPTIBLE);
> >> +                       xas_lock_irq(&xas);
> >> +               }
> >> +
> >> +               spin_lock(&eb->refs_lock);
> >> +               if (refcount_read(&eb->refs) > 1 || extent_buffer_unde=
r_io(eb)) {
> >> +                       btrfs_warn(fs_info,
> >> +                       "unbale to release extent buffer %llu owner %l=
lu flags 0x%lx",
> >
> > unbale -> unable
> >
> >> +                                  eb->start, btrfs_header_owner(eb), =
eb->bflags);
> >> +                       if (IS_ENABLED(CONFIG_BTRFS_DEBUG))
> >> +                               WARN_ON_ONCE(true);
> >
> > Pointless if, just do DEBUG_WARN();
>
> The problem is we do not have DEBUG_WARN_ON_ONCE().
>
> We already have cases triggering this during fstests, and there were a
> lot of ebs that are dirty in that case.
>
> DEBUG_WARN() will flood the dmesg with the same call trace for each
> dirty eb.
>
> I can add a new DEBUG_WARN_ON_ONCE() for this particular call site though=
.

No need just for one case IMO.

I find code using WARN_ON(1), ASSERT(0), and so on, to be annoying,
unnecessary, and verbose.
We can pass a condition to avoid the if statement, making the code
shorter and clearer.

Instead of:

 if (IS_ENABLED(CONFIG_BTRFS_DEBUG))
     WARN_ON_ONCE(true);

WARN_ON_ONCE(IS_ENABLED(CONFIG_BTRFS_DEBUG));

Thanks.
>
> Thanks,
> Qu
>
