Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9333D43BDBD
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Jul 2026 11:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784805885; cv=none; b=uWBbmzFYhsYGQoBLcb8mgb6mNmMLE47z+YASXY8bg1Q6bMU4d7jbRkYPa0PIfZGJkV6GWAEBagDkwV+m5AAUsCyX7/EQ4aqz9p2HcKMhrV0kW6IgoAi4zwnQoRINK7kibnNjfhUC/S5f8ZsudLDRad0csaq6RBMcwRzrHPI5rAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784805885; c=relaxed/simple;
	bh=Ue+o/4dBliP41W1HJhvADj4Sn0Mj2IcqxLgdSFcCAvs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=u8VYZQd8yyHO/KKejWoFF+DWYgMUjfKrWJUpqwn4AchWRWjehzAUi93I59pKBBbcioNAV2YxEzAxU5kdRE8cRGlLZ3SAA5Tt68s/P0V7SL5P1Pn3iTnkzR87uWtGXBaMJSlm3raUkPTxYyel3WiFznREClzdP5p2Bwk7qrAtftA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L/S6UMxB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L/S6UMxB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 279DC1F000E9
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Jul 2026 11:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784805884;
	bh=Eg/8LdXmEVYJwgWut91g8sWAILu+KHttxEdlLg41ApI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=L/S6UMxB3hciC0Rl/J24YeWTpXUaRwQmLIAIQ0vMNuEd010Wom5gscYfk64xUwT3O
	 CJFFTmzwovO7RqKYxVTdntkOFlfo3635JYUwoHHCAju50vS8rTYbqqIMJlM8kwlb5A
	 Nssz2njYEEBcAv/1qMpuOusP10IVBIaNtfTCBPP4caARw56mbglrklGifp7EZWPHau
	 BsEXNeC5C8nfJFCwZxw+j2dfpqvvw6ecyAYISiWENnn8qYQ2g2kTQRrtFxLSKaTKt2
	 oQWpw1C2SV7TUuKPnj/gUaPUaCUT3X0CwWWIf+f1hGUrNDg5XB+T4fNmirBlcUqU2T
	 zZiF7N3o/NYVQ==
Received: by mail-ua1-f53.google.com with SMTP id a1e0cc1a2514c-97727c2064fso296773241.0
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Jul 2026 04:24:44 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RruoypszydHnz/Z0pVMXzh9sAIVpPFizi+czU2IdZ8kLS/PQJwKw6dpz4FjuUUpg8v+XHfaZblMqXXQdg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9jS14f+XPN8p17jBnOCbYsMXotYLLmq0wMlfZHbidxl2pXSPf
	SnGON79LjFhtbz5dHDKOZRT+wkxtpKi3gkaFOt7oRVQIItFEW6Kqie13ZaxGiZLJCsHm2vmYPpW
	sgm+uFGaOpB4HUbn6Kq0CLq+w5ha05g0=
X-Received: by 2002:a05:6102:c53:b0:739:4fa1:50aa with SMTP id
 ada2fe7eead31-74d5fbd62e9mr1128394137.14.1784805877027; Thu, 23 Jul 2026
 04:24:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <c6dfdac9fc51c94183e51a861eec269185239660.1784787211.git.wqu@suse.com>
 <CAL3q7H55GkjjCougzD3w2qarX0x6XoQu5G680xv3iuqTMgQ0YA@mail.gmail.com> <f4f41f37-304f-41e7-af53-d7037e54cde9@gmx.com>
In-Reply-To: <f4f41f37-304f-41e7-af53-d7037e54cde9@gmx.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Thu, 23 Jul 2026 12:23:59 +0100
X-Gmail-Original-Message-ID: <CAL3q7H4yxeAXzh+hHBsiD0ovotWpcoaK2byvS_5qz2cJybhNoQ@mail.gmail.com>
X-Gm-Features: AUfX_mwcX0Hj8CF-HxYKBlcXUbLQb3tm6KN8i-jrqtXORSYoyiO_M9mDrlGZC1o
Message-ID: <CAL3q7H4yxeAXzh+hHBsiD0ovotWpcoaK2byvS_5qz2cJybhNoQ@mail.gmail.com>
Subject: Re: [PATCH RFC v2] btrfs: disable direct reads to avoid dirty folios
 without fs knowing
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, 
	Christian Borntraeger <borntraeger@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 23, 2026 at 12:17=E2=80=AFPM Qu Wenruo <quwenruo.btrfs@gmx.com>=
 wrote:
>
>
>
> =E5=9C=A8 2026/7/23 20:08, Filipe Manana =E5=86=99=E9=81=93:
> > On Thu, Jul 23, 2026 at 7:16=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
> >>
> >> There is a bug report that a reproducer which doing the following
> >> workloads in two threads:
> >>
> >> - Direct read into memory mapped from page cache
> >> - Sync the above range
> >>
> >> This can lead to dirty folios without fs knowing, this can be a huge
> >
> > Can you please explain where, and why, the folio is dirtied?
>
>
> btrfs_check_read_bio()
> |- __iomap_dio_bio_end_io() from btrfs_bio_end_io()
>     |- bio_check_pages_dirty()
>        |- bio_dirty_fn()
>           |- bio_release_pages(bio, true)
>              |- __bio_release_pages(bio, mark_dirty =3D=3D true)
>                 |- folio_mark_dirty()
>
> At least this is the one from the reproducer.

That should be part of the change log, it's not obvious at all.
I also wonder why a direct IO read dirties the folio if it's not
supposed to change file data.

>
> Thanks,
> Qu
>
> >
> > How does a direct IO read dirties a folio or a sync_file_range(2) call?
> >
> > Thanks.
> >
> >> problem for btrfs, as even on the very basic bs =3D=3D ps cases withou=
t
> >> large folios, such reproducer can screw up the ordered extent accounti=
ng
> >> already:
> >>
> >>   ------------[ cut here ]------------
> >>   WARNING: fs/btrfs/ordered-data.c:390 at can_finish_ordered_extent.is=
ra.0+0x56/0x1f0 [btrfs], CPU#1: kworker/u42:0/68
> >>   CPU: 1 UID: 0 PID: 68 Comm: kworker/u42:0 Tainted: G            E   =
    7.2.0-rc4-custom+ #415 PREEMPT(full)  74dbeafab12c410178747d5bec9fb200a=
e56949f
> >>   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS unknown 02/=
02/2022
> >>   Workqueue: btrfs-endio simple_end_io_work [btrfs]
> >>   RIP: 0010:can_finish_ordered_extent.isra.0+0x56/0x1f0 [btrfs]
> >>   Call Trace:
> >>    <TASK>
> >>    btrfs_finish_ordered_extent+0x39/0xd0 [btrfs 7d1ffd99bb9696179883f2=
57e5fd838e2d1a0ca3]
> >>    end_bbio_data_write+0x1ff/0x280 [btrfs 7d1ffd99bb9696179883f257e5fd=
838e2d1a0ca3]
> >>    btrfs_bio_end_io+0x76/0xf0 [btrfs 7d1ffd99bb9696179883f257e5fd838e2=
d1a0ca3]
> >>    process_one_work+0x198/0x380
> >>    worker_thread+0x1c8/0x330
> >>    kthread+0xee/0x120
> >>    ret_from_fork+0x28f/0x310
> >>    ret_from_fork_asm+0x11/0x20
> >>    </TASK>
> >>   ---[ end trace 0000000000000000 ]---
> >>   BTRFS critical (device dm-3): bad ordered extent accounting, root=3D=
5 ino=3D257 OE offset=3D3465216 OE len=3D2826240 to_dec=3D319488 left=3D135=
168
> >>
> >> Unfortunately we have removed cow fixup mechanism, which is to work
> >> around such dirty folios by re-dirtying them and reserve space for the=
m,
> >> across several kernel releases, meaning we can not easily revert a
> >> single commit to bring it back.
> >> And without doubt, that old cow fixup mechanism is not support larger
> >> folios.
> >>
> >> As a hot fix, disable btrfs direct reads for non-experimental builds f=
or
> >> now, so this can buy some time before we find out a proper way to addr=
ess
> >> this.
> >>
> >> Reported-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> >> Link: https://lore.kernel.org/linux-btrfs/f12f70e5-d84d-4a9f-ac94-693b=
e4c863ac@linux.ibm.com/
> >> Signed-off-by: Qu Wenruo <wqu@suse.com>
> >> ---
> >> Changelog:
> >> v2:
> >> - Fallback to buffered IO to avoid failing existing direct IO users
> >>
> >> - Allow direct writes
> >>
> >> Reason for RFC:
> >> I'm not 100% sure if disabling direct IOs can fill all the holes.
> >>
> >> We still allow mmapping page cache into user spaces, thus I'm not sure
> >> if this is the only hole.
> >> ---
> >>   fs/btrfs/direct-io.c | 5 +++++
> >>   1 file changed, 5 insertions(+)
> >>
> >> diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
> >> index ed1779ccb4de..32b29a4faaf2 100644
> >> --- a/fs/btrfs/direct-io.c
> >> +++ b/fs/btrfs/direct-io.c
> >> @@ -1093,6 +1093,11 @@ ssize_t btrfs_direct_read(struct kiocb *iocb, s=
truct iov_iter *to)
> >>          if (check_direct_read(inode_to_fs_info(inode), to, iocb->ki_p=
os))
> >>                  return 0;
> >>
> >> +#ifndef CONFIG_BTRFS_EXPERIMENTAL
> >> +       /* To avoid dirty folios without fs knowing through */
> >> +       return 0;
> >> +#endif
> >> +
> >>          btrfs_inode_lock(BTRFS_I(inode), BTRFS_ILOCK_SHARED);
> >>   again:
> >>          /*
> >> --
> >> 2.54.0
> >>
> >>
> >
>
