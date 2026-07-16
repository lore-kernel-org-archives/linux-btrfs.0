Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F312538889B
	for <linux-btrfs@vger.kernel.org>; Thu, 16 Jul 2026 15:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784216361; cv=none; b=lUxzrgr0qT4Dg9i3ZC+3+xIXwIY15ZF3W5FiMntHxCqaHcuLYlCwnyn2sm9oCrDsSS+ImYT5ftoPUBsilnQoan6WWe+d8Zc3ixVEoVRwrFyBxWyf/EmlFB/BJlc8jIe8pD/c4dwMOWT+BX4+oq5iyPEI9E+4QlM2onT9oj1pSmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784216361; c=relaxed/simple;
	bh=LHR49OnCodmr0xMFFh0Qh3qpkyNtV5BYRW0iT2TRgJU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=du0UA+LttNUNbG06yJI8H23AvtVy2d/ZOGEqyKA9xrN98MRFS11okiHDrN11CW7kCUhGOZ2wnxG3viE7Wyrf1x031f0hwTGXF2RLY2DQbvKP3DhDqB+dGtJSF5F9KjccuCMVkrGpz4JIm+XjVT2HxbDqTNSsUYnFDH3XSY44N64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c0+z47Ul; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c0+z47Ul"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 971B91F000E9
	for <linux-btrfs@vger.kernel.org>; Thu, 16 Jul 2026 15:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784216359;
	bh=KzOUOowJt3Jnd5LS6UFEKWZPqQrc62bTlc8gSLrJRrU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=c0+z47Ult8vXx6RB4gO/rce7kp/HwYQ2BZj0cZ0Fwm7DSYmszJg8P4VDwJX8uV00A
	 uHIg1vWcC1abx2rfDrelJ3bRHOaabZQYoitNr5jNcYrk4SRqCJnlonqVAVmint9g3G
	 77wU5rlOMoTAMNyrgpa/gMGE/FINnhn6ywvg/06cLDj7/uK429G2mZZHH4CXMy8CQw
	 Qt6EAOD3iWJRrsmTzAIGJ+33DYw1tZpX5KRcuSNsIb0PhwSsYZPjnELJdNfNKOSUA7
	 jlJ7V4CQA/wNn0v4HjSLMVud1y/KQy5KwCtUVRwDA3WmXQARDG1tiP3UWFZFn9IH3M
	 bVFUjgsesnphQ==
Received: by mail-vk1-f179.google.com with SMTP id 71dfb90a1353d-5bdc96b0714so5326169e0c.2
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Jul 2026 08:39:19 -0700 (PDT)
X-Gm-Message-State: AOJu0YxiYz0ufq1ZGw/A33o9pIO4yzH04QSnZSpLjvr1YjO73WqITXZj
	+vKry85p3XaO27mTvs7sRMJrXRrJrC67JgJthHV/Lu0sZS5kB8SzAm8vFXTlpACTnFm52k0SQAb
	BnPJL7oYIqbUO70RFW1uc41vzgdepJXY=
X-Received: by 2002:a05:6102:1492:b0:738:1ef6:51b9 with SMTP id
 ada2fe7eead31-74599d9898dmr4790896137.5.1784216358833; Thu, 16 Jul 2026
 08:39:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <14aca1944da7170799aea08df9af85728a2f2233.1781932019.git.wqu@suse.com>
In-Reply-To: <14aca1944da7170799aea08df9af85728a2f2233.1781932019.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Thu, 16 Jul 2026 16:38:42 +0100
X-Gmail-Original-Message-ID: <CAL3q7H5jMG=KBEUyd6UgBPU=rtCvFxc=V-Z80ZUgCaOTpTg-iQ@mail.gmail.com>
X-Gm-Features: AUfX_mwcPYWxYLdkTjoqoVnlSOvD31D1ZcweGtv4Voq2_Ld0mKAJNmmlOg73MEY
Message-ID: <CAL3q7H5jMG=KBEUyd6UgBPU=rtCvFxc=V-Z80ZUgCaOTpTg-iQ@mail.gmail.com>
Subject: Re: [PATCH] btrfs: make sure EXTENT_BUFFER_READING is cleared under refs_lock
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, Su Yue <glass.su@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 20, 2026 at 6:07=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>
> [FALSE ALERTS]
> There is a bug report that the warning inside
> invalidate_and_check_btree_folios() got triggered duriong btrfs/298:

duriong -> during

>
>  BTRFS info (device sdd): first mount of filesystem f9bf732a-a19b-44b9-99=
a7-614ddff168e2
>  BTRFS info (device sdd): using crc32c checksum algorithm
>  BTRFS error (device sdd): failed to find fsid cb2fdb42-b638-4f2f-badd-41=
27467ba674 when attempting to open seed devices
>  BTRFS error (device sdd): failed to read chunk tree: -2
>  ------------[ cut here ]------------
>  WARNING: disk-io.c:3342 at invalidate_and_check_btree_folios+0x260/0x3c0=
 [btrfs], CPU#4: mount/125993
>  CPU: 4 UID: 0 PID: 125993 Comm: mount Tainted: G        W  OE       7.1.=
0-rc7-custom+ #1 PREEMPT(full)
>  Hardware name: QEMU KVM Virtual Machine, BIOS edk2-20250812-19.fc42 08/1=
2/2025
>  Call trace:
>   invalidate_and_check_btree_folios+0x260/0x3c0 [btrfs] (P)
>   open_ctree+0x1f50/0x23b0 [btrfs]
>   btrfs_get_tree+0x89c/0xc48 [btrfs]
>   vfs_get_tree+0x30/0x110
>   vfs_cmd_create+0x58/0xe8
>   __arm64_sys_fsconfig+0x39c/0x518
>   invoke_syscall.constprop.0+0x48/0x120
>   el0_svc_common.constprop.0+0x40/0xe8
>   do_el0_svc+0x24/0x38
>   el0_svc+0x50/0x310
>   el0t_64_sync_handler+0xa0/0xe8
>   el0t_64_sync+0x198/0x1a0
>  ---[ end trace 0000000000000000 ]---
>  BTRFS warning (device sdd): unable to release extent buffer 365985792 ow=
ner 3 gen 17 refs 3 flags 0x5
>
> [CAUSE]
> In that invalidate_and_check_btree_folios() we wait for the eb to finish
> its read, then check if it's only held by us and the btree inode.
>
> If not, then do a warning as it may be still held, and could cause
> problems.
>
> But there is a small window where the check can lead to false alerts:
>
>     Thread A (Read endio)         |        Thread B (Unmount)
> ----------------------------------+-------------------------------------
>  end_bbio_meta_read()             |
>  | The eb has one extra ref held  |
>  | by the reader, and has         |
>  | EXTENT_BUFFER_READING flag set | invalidate_and_check_btree_folios()
>  |                                | |
>  |- clear_extent_buffer_reading() | |
>  |                                | |- wait_on_bit_io();
>  |                                | |  The EXTENT_BUFFER_READING flag is
>  |                                | |  cleared
>  |                                | |- if (refcount_read(eb->refs) > 2)
>  |                                |    The eb is held by the read, us
>  |                                |    and btree inode, thus it
>  |                                |    will trigger the warning
>  |- free_extent_buffer()          |
>
> [FIX]
> Introduce a helper, free_extent_buffer_clear_reading().
>
> If the new parameter, @clear_reading, is set, we will hold the spinlock
> at the beginning of free_extent_buffer_clear_reading() to make sure the
> READING flag is cleared inside the same critical of decreasing refs.

missing "section" after "critical"

>
> Now free_extent_buffer() will just call
> free_extent_buffer_clear_reading() with @clear_reading set to false, so
> no behavior change.
>
> But for end_bbio_meta_read(), it will not clear_extent_buffer_reading()
> directly, but pass @clear_reading as true.
>
> Then inside invalidate_and_check_btree_folios(), hold the refs_lock
> before reading refs.
> So that we eliminate the race window completely.
>
> Reported-by: Su Yue <glass.su@suse.com>
> Link: https://lore.kernel.org/linux-btrfs/DC0C775E-13B3-47D9-9AB2-895BB11=
C029D@suse.com/
> Fixes: 83f7e52b7ed1 ("btrfs: warn about extent buffer that can not be rel=
eased")
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/disk-io.c   | 15 +++++++++++++--
>  fs/btrfs/extent_io.c | 42 ++++++++++++++++++++++++++++++++----------
>  2 files changed, 45 insertions(+), 12 deletions(-)
>
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 0a7d80da9c94..c4143c847827 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3318,6 +3318,8 @@ static void invalidate_and_check_btree_folios(struc=
t btrfs_fs_info *fs_info)
>          */
>         rcu_read_lock();
>         xa_for_each(&fs_info->buffer_tree, index, eb) {
> +               unsigned int refs;
> +
>                 /* Increase the ref so that the eb won't disappear. */
>                 if (!refcount_inc_not_zero(&eb->refs))
>                         continue;
> @@ -3327,17 +3329,26 @@ static void invalidate_and_check_btree_folios(str=
uct btrfs_fs_info *fs_info)
>                 if (test_bit(EXTENT_BUFFER_READING, &eb->bflags))
>                         wait_on_bit_io(&eb->bflags, EXTENT_BUFFER_READING=
,
>                                        TASK_UNINTERRUPTIBLE);
> +               /*
> +                * We hold the spinlock to make sure above READING is

I would prefer to have the full name of flags spelled, i.e.
EXTENT_BUFFER_READING.
That makes it easier to avoid leaving a stale comment in case we
rename or remove the flag someday.


> +                * cleared with the held ref dropped.
> +                * Or we can hit a race window and lead to false alerts.
> +                */
> +               spin_lock(&eb->refs_lock);
> +               refs =3D refcount_read(&eb->refs);
> +               spin_unlock(&eb->refs_lock);
> +
>                 /*
>                  * The refs threshold is 2, one held by us at the beginni=
ng
>                  * of the loop, one for the ownership in the buffer tree.
>                  */
> -               if (unlikely(refcount_read(&eb->refs) > 2 || extent_buffe=
r_under_io(eb))) {
> +               if (unlikely(refs > 2 || extent_buffer_under_io(eb))) {
>                         WARN_ON_ONCE(IS_ENABLED(CONFIG_BTRFS_DEBUG));
>                         btrfs_warn(fs_info,
>                         "unable to release extent buffer %llu owner %llu =
gen %llu refs %u flags 0x%lx",
>                                    eb->start, btrfs_header_owner(eb),
>                                    btrfs_header_generation(eb),
> -                                  refcount_read(&eb->refs), eb->bflags);
> +                                  refs, eb->bflags);
>                 }
>                 free_extent_buffer(eb);
>                 rcu_read_lock();
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 0edd532174fa..33f50cb89a81 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -3709,12 +3709,30 @@ static int release_extent_buffer(struct extent_bu=
ffer *eb)
>         return 0;
>  }
>
> -void free_extent_buffer(struct extent_buffer *eb)
> +static void clear_extent_buffer_reading(struct extent_buffer *eb)
> +{
> +       clear_and_wake_up_bit(EXTENT_BUFFER_READING, &eb->bflags);
> +}
> +
> +static void free_extent_buffer_clear_reading(struct extent_buffer *eb,
> +                                            bool clear_reading)
>  {
>         int refs;
> +
>         if (!eb)
>                 return;
>
> +       /*
> +        * We want to clear READING flag and decrease refs in the same

Same here.

> +        * critical section.
> +        * This will make sure invalidate_and_check_btree_folios() won't
> +        * see an eb with READING cleared but refs not yet decreased.

Same here.

With those minor fixups:

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.

> +        */
> +       if (clear_reading) {
> +               spin_lock(&eb->refs_lock);
> +               clear_extent_buffer_reading(eb);
> +       }
> +
>         refs =3D refcount_read(&eb->refs);
>         while (1) {
>                 if (test_bit(EXTENT_BUFFER_UNMAPPED, &eb->bflags)) {
> @@ -3725,11 +3743,16 @@ void free_extent_buffer(struct extent_buffer *eb)
>                 }
>
>                 /* Optimization to avoid locking eb->refs_lock. */
> -               if (atomic_try_cmpxchg(&eb->refs.refs, &refs, refs - 1))
> +               if (atomic_try_cmpxchg(&eb->refs.refs, &refs, refs - 1)) =
{
> +                       if (clear_reading)
> +                               spin_unlock(&eb->refs_lock);
>                         return;
> +               }
>         }
>
> -       spin_lock(&eb->refs_lock);
> +       if (!clear_reading)
> +               spin_lock(&eb->refs_lock);
> +
>         if (refcount_read(&eb->refs) =3D=3D 2 &&
>             test_bit(EXTENT_BUFFER_STALE, &eb->bflags) &&
>             !extent_buffer_under_io(eb) &&
> @@ -3743,6 +3766,11 @@ void free_extent_buffer(struct extent_buffer *eb)
>         release_extent_buffer(eb);
>  }
>
> +void free_extent_buffer(struct extent_buffer *eb)
> +{
> +       return free_extent_buffer_clear_reading(eb, false);
> +}
> +
>  void free_extent_buffer_stale(struct extent_buffer *eb)
>  {
>         if (!eb)
> @@ -3868,11 +3896,6 @@ void set_extent_buffer_uptodate(struct extent_buff=
er *eb)
>                 btrfs_meta_folio_set_uptodate(eb->folios[i], eb);
>  }
>
> -static void clear_extent_buffer_reading(struct extent_buffer *eb)
> -{
> -       clear_and_wake_up_bit(EXTENT_BUFFER_READING, &eb->bflags);
> -}
> -
>  static void end_bbio_meta_read(struct btrfs_bio *bbio)
>  {
>         struct extent_buffer *eb =3D bbio->private;
> @@ -3896,8 +3919,7 @@ static void end_bbio_meta_read(struct btrfs_bio *bb=
io)
>         else
>                 clear_extent_buffer_uptodate(eb);
>
> -       clear_extent_buffer_reading(eb);
> -       free_extent_buffer(eb);
> +       free_extent_buffer_clear_reading(eb, true);
>
>         bio_put(&bbio->bio);
>  }
> --
> 2.54.0
>
>
