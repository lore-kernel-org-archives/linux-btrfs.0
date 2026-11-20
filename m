Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795187097;
	b=G/MM/DuevKyOZ+lBnC1lLfy3kxgqXPJXl/3v6Y+xlB+MlQC6Ume2HESiX3WP5NTCasH1
	 Bzi6fT8cRshgmVXAfD3K7hZhW8Jtu46tCiv3wVozxeHR5DDSlxBK70VzL0NbqDcxCxMAx
	 SFFBW6qEEq2vuMTxzHuvi/jyhl+hIfpbBPhGAY3mlSTT3hbG6YEWFQDhv6VCEA6u+sxRA
	 6sbdUIVzesGk8LYn9XPf3NJpp9z/5G8CQcYMu7LGG28w3otm1DDb3NHZGKviEMGkS79TE
	 PjwhETg/vwWXFcC72R9tTlktsjpXaQ28HwDIBc7TiYcJcCPxpFFtEUhztIjU3u7f1Dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795187097;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=+xeHuRCftx4ZqUh8vLtYimSwGzxkTWRbyp2mv2pwGBk=;
	b=gmOLVVGslsiJn+iy9R5XGhE4FYq8uxq8yKZONSpeBEdeycEDB3/Zc9vAl2zJJKQxqPkG
	 qM+G745Cws+8h1SCnuZE6BaTi/HUD+PXDO8StivqiUufCfQFWcBlMXZG3WPjEXjxBL11D
	 SAdDImblgVKlZ7VEOhF+f9ohE4gqHNQTHjMOgJLlbqzJqKJ3oEX8uR1PivnQRiCuqpYTk
	 vfqj5i+4o332RAzbmfizi6xpi8VymX0zsZhrE1R3p6wPJwMYActAuO1a57uu446DIX8w3
	 PAvQg+vt1hFbK+5Vpfg96Azv+1ll99Ag3/G02FGpyuqUjYHa5WPmLqYP8r3x+cmB13A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="khqRf/IC";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F42606A333
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 15:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=khqRf/IC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8231C1F000F4
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 15:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795187096;
	bh=+xeHuRCftx4ZqUh8vLtYimSwGzxkTWRbyp2mv2pwGBk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=khqRf/ICQunDRvVU6qeYJc1UU3F/N/8PQ+UTWx5wvdFLiRxKn0VRVaguocBqZ1noq
	 CwJIrPnscWSdqK6K/XvrHkbYilR3DSFZzftIDNdD3h0glLsvRWJDfqjKqdLGJ/nlUX
	 JJNznybk6Wabs+S5SxoyMHEw5yLTT3pEJhYwq1+yJfG+wEDBTcZE8Q1dhFsLXN8ZFQ
	 1qRLTdJ/KzMG2y9K/83MPPFAlkIMg4kMdxYLx3ZoQKw2PSuf37NX5XGViFNN/PE5pa
	 iRQKojJkGFpFhBoZMz9zfkc93OQkBcfmPlDm6v8nqfvE4GnhBFKtOTY8L5IZD9KTo3
	 vI6sQcPRMjjwA==
Received: by mail-vk1-f179.google.com with SMTP id 71dfb90a1353d-5eac319a6c2so679562e0c.0
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 07:04:56 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErHby84ffR/iAYmSrOSVLRIOZTG7yIaOswRmnDyz/Jch1btzIbTR4zsXXtlTeYzQ42Mn/3zqN/B8W/R+Kg==@vger.kernel.org
X-Gm-Message-State: APuU4Z9jP9GILIHwNIOaUYYVPJLrzcQ3n55QqcXtUARFiP+wxcIgn1RD
	WAd8+cc9YJUkVlPUWuqbvEq2BbNnHZFFWb+p0w6Rq5Mnm4MZp6ypUdw6QvYl9nILdNu82upoVHC
	qsdRIy6XBCahrQcfrgF3u8W0Z0ZQT33s=
X-Received: by 2002:a05:6123:110:b0:5ea:c3bc:c567 with SMTP id
 71dfb90a1353d-5ee8aefbd39mr1836664e0c.9.1795187095559; Fri, 20 Nov 2026
 07:04:55 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261117-my-btrfs-patch-v1-1-4b934a7ff69a@shangen.org>
 <CAL3q7H6zzrx-oHoiXqMA6U=GoS8rZpWE7gjtZDkrA-87UycM-Q@mail.gmail.com> <YhW6lq8O4pm3D9oM5F5YIVpBGvPxrzy3vpbS@shangen.org>
In-Reply-To: <YhW6lq8O4pm3D9oM5F5YIVpBGvPxrzy3vpbS@shangen.org>
From: Filipe Manana <fdmanana@kernel.org>
Date: Fri, 20 Nov 2026 15:04:19 +0000
X-Gmail-Original-Message-ID: <CAL3q7H788fCFQdLG2_uCC1HRK5-5ujAH8-1Ff+sdSRtv3izWpA@mail.gmail.com>
X-Gm-Features: Aa3M54rwH8iAhUQu4HM3rCLG4FZhX4YksDYJ-zcG07gaSJKwQs6y3mS9A6yVzlI
Message-ID: <CAL3q7H788fCFQdLG2_uCC1HRK5-5ujAH8-1Ff+sdSRtv3izWpA@mail.gmail.com>
Subject: Re: [PATCH] btrfs: pin folios before dropping the last extent buffer reference
To: Shang En Sim <sim@shangen.org>
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, Boris Burkov <boris@bur.io>, 
	Daniel Vacek <neelx@suse.com>, Filipe Manana <fdmanana@suse.com>, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 20, 2026 at 12:48=E2=80=AFAM Shang En Sim <sim@shangen.org> wro=
te:
>
> On Thu Nov 19, 2026 at 11:24 AM CST, Filipe Manana wrote:
> > On Wed, Nov 18, 2026 at 12:20 AM Shang En Sim <sim@shangen.org> wrote:
> >>
> >> release_extent_buffer() drops the last reference to a mapped extent
> >> buffer (eb) before detaching its folios.
> >
> > To mapped and unmapped extent buffers, so remove the "mapped" part.
>
> I will remove "mapped" in v2.
>
> >>   task A                         task B                    task C
> >>   release_extent_buffer(eb)
> >>    refs: 1 -> 0
> >>    remove eb from buffer_tree
> >>                                  alloc_extent_buffer()
> >>                                   attach_eb_folio_to_filemap()
> >>                                    grab_extent_buffer()
> >>                                     refs is 0, take over
> >>                                     the folios
> >>                                  ... new eb released ...
> >
> > It's not "new eb released", it's the new folio that is released and we
> > take the existing folio into the new eb.
>
> My bad, that diagram was misleading.
>
> Inside attach_eb_folio_to_filemap(), task B drops its newly allocated
> folio and reuses the existing folio for the new eb (eb2), attaching eb2
> as folio->private after grab_extent_buffer() detaches eb1. After
> alloc_extent_buffer() completes, task B finishes using eb2 and calls
> free_extent_buffer(eb2), dropping eb2->refs from 2 to 1 (leaving only
> EXTENT_BUFFER_TREE_REF).

Ok, now I see it. Those are all important details for the changelog.
To make it clear, avoid using eb1 and eb2, just call them new_eb and
existing_eb (the later matches the name we use in
attach_eb_folio_to_filemap(), which make it clearer).


>
> >>                                                            drop_caches
> >>                                                             folio->map=
ping
> >>                                                             =3D NULL
> >
> > And where does this happens?
> > Please be detailed, add the call chain triggered by drop_caches that
> > results in setting the folio's mapping to NULL.
> >
> > I don't see how that is happening, because when we end up in
> > try_release_extent_buffer(), eb->refs is 0 and that
> > makes us return immediately with 0:
> >
> > spin_lock(&eb->refs_lock);
> > if (refcount_read(&eb->refs) !=3D 1 || extent_buffer_under_io(eb)) {
> >         spin_unlock(&eb->refs_lock);
> >         spin_unlock(&folio->mapping->i_private_lock);
> >         return 0;
> > }
> > spin_unlock(&folio->mapping->i_private_lock);
>
> When task C enters try_release_extent_buffer(), folio->private no longer
> points to task A's eb (eb1, with refs =3D=3D 0). Task B's
> grab_extent_buffer() detached eb1 and attach_extent_buffer_folio()
> attached eb2 to folio->private. Once task B drops its caller reference
> on eb2, eb2->refs is 1 (with EXTENT_BUFFER_TREE_REF set), so
> try_release_extent_buffer() inspects eb2, clears EXTENT_BUFFER_TREE_REF,
> releases eb2 (detaching folio->private), and returns 1.
> mapping_evict_folio() then calls remove_mapping() ->
> __remove_mapping_unfreeze() -> __remove_mapping() ->
> __filemap_remove_folio() -> page_cache_delete(), which sets
> folio->mapping =3D NULL.
>
> (If eb2 was already fully freed and detached before task C runs, e.g.
> via free_extent_buffer_stale(), try_release_extent_buffer() sees
> !folio_test_private(folio) and returns 1 immediately.)
>
> Here is the full sequence, starting with a 0-order folio F in
> btree_inode->i_mapping with F->private =3D=3D eb1, F refcount =3D=3D 2 (1=
 for
> the page cache, 1 for F->private), and eb1->refs =3D=3D 1:
>
> 1) Task A drops the last reference to eb1:
>
>      release_extent_buffer(eb1)
>       refcount_dec_and_test()         # eb1->refs: 1 -> 0
>       spin_unlock(&eb1->refs_lock)
>       xa_cmpxchg_irq()                # removes eb1 from buffer_tree
>       <window before btrfs_release_extent_buffer_folios(eb1)>
>
> 2) Task B allocates eb2 for the same bytenr, takes over folio F, and
>    drops its caller reference:
>
>      alloc_extent_buffer()
>       find_extent_buffer()            # NULL (eb1 removed from tree)
>       btrfs_init_eb_prealloc()        # allocates eb2 and new folios
>       init_extent_buffer()            # eb2->refs =3D 1
>       attach_eb_folio_to_filemap()
>        filemap_add_folio() -> -EEXIST
>        filemap_lock_folio() -> F      # locks F; F refcnt: 2 -> 3
>        grab_extent_buffer(F)
>         folio_get_private(F) -> eb1
>         refcount_inc_not_zero(&eb1->refs) -> false (eb1->refs =3D=3D 0)
>         folio_detach_private(F)       # F->private =3D NULL; refcnt: 3->2
>        folio_put(eb2->folios[i])      # drops eb2's unused new folio
>        eb2->folios[i] =3D F             # reuses existing folio F
>        attach_extent_buffer_folio(eb2, F)
>         folio_attach_private(F, eb2)  # F->private =3D eb2; refcnt: 2->3
>       __xa_cmpxchg()                  # inserts eb2 into buffer_tree
>       check_buffer_tree_ref(eb2)      # sets TREE_REF; eb2->refs: 1 -> 2
>       folio_unlock(F)
>       folio_put(F)                    # drops lock ref; F refcnt: 3 -> 2
>      free_extent_buffer(eb2)
>       free_extent_buffer_clear_reading(eb2, false)
>        release_extent_buffer(eb2)
>         refcount_dec_and_test()       # eb2->refs: 2 -> 1 (TREE_REF)
>
> 3) Task C runs drop_caches, releases eb2, and evicts folio F:
>
>      drop_caches_sysctl_handler()
>       iterate_supers()
>        __iterate_supers()
>         drop_pagecache_sb()
>          invalidate_mapping_pages()
>           mapping_try_invalidate()
>            find_lock_entries()        # locks F, fbatch ref: F refcnt 2->=
3
>            mapping_evict_folio(mapping, F)
>             folio_ref_count check     # 3 <=3D 1 + 1 + 1 (passes)
>             filemap_release_folio(F, 0)
>              btree_release_folio(F, 0)
>               try_release_extent_buffer(F)
>                folio_get_private(F) -> eb2
>                eb2->refs =3D=3D 1         # check passes
>                test_and_clear_bit(EXTENT_BUFFER_TREE_REF) -> true
>                release_extent_buffer(eb2)
>                 refcount_dec_and_test()  # eb2->refs: 1 -> 0
>                 spin_unlock(&eb2->refs_lock)
>                 xa_cmpxchg_irq()         # removes eb2 from buffer_tree
>                 btrfs_release_extent_buffer_folios(eb2)
>                  detach_extent_buffer_folio(eb2, F)
>                   folio_detach_private(F) # F->private=3DNULL; refcnt 3->=
2
>                 returns 1
>             remove_mapping(mapping, F)
>              __remove_mapping_unfreeze()
>               __remove_mapping()
>                folio_ref_freeze(F, 2) # F refcnt: 2 -> 0 (eb1 holds no re=
f)
>                __filemap_remove_folio(F, NULL)
>                 page_cache_delete()
>                  xas_store(NULL)      # removes F from i_pages
>                  F->mapping =3D NULL
>                returns 1
>               folio_ref_unfreeze(F, 1) # drops page cache ref; refcnt 0->=
1
>            folio_unlock(F)
>            folio_batch_release()      # drops fbatch ref; refcnt 1->0, fr=
ee
>
> 4) Task A resumes and detaches eb1's folios:
>
>      btrfs_release_extent_buffer_folios(eb1)
>       detach_extent_buffer_folio(eb1, F)
>        mapping =3D F->mapping           # NULL (F refcnt is 0, freed/reus=
ed)
>        spin_lock(&mapping->i_private_lock)  # NULL dereference

This detailed breakdown removes any potential confusion and should be
in the changelog.

>
> I validated this exact sequence with bpftrace probes during the
> reproducer run and observed try_release_extent_buffer() seeing
> folio->private =3D=3D eb2 with refs =3D=3D 1, returning 1,
> __filemap_remove_folio() running from drop_caches_sysctl_handler(), and
> task A subsequently entering detach_extent_buffer_folio(eb1, F) with
> F->mapping =3D=3D NULL and refcount =3D=3D 0.
>
> I will replace the diagram with this fuller breakdown (and remove
> "mapped") in v2 once you have had a chance to look at the rest of the
> patch.

The code part of the change looks good, thanks!

>
> Thanks,
> Shang En Sim
