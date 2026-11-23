Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795432587;
	b=et1Ii45DTkCS6F15+tk1IapUM4Vd9y2af6j9PxopyQLW681OZFFr+YC0gym+UOwDUB6q
	 7sHgz27ZPCSK6e350EHJhDLRfzez5J/byh/IFu8XlQlo3+Pauu1nzdB16wIpWNXDhpQXa
	 DVjhfY2u9vt3rei9PLIt4tmhZqszKhMzMDMpfYJO3WbU1yqxzNPafW+Yl7RKapVdtR2Pt
	 FxBFzX6Gh954vcsGxD1jZEW2FD/+v8G09j/mUSeVNziU8Ts/uKn2dErAQ8cj4ks1ssodI
	 3sNnaHLGUGq6pi7B0RbEvsMza8rVYPH8lL/mNQKMSMvUeuf2mwmxlxdoS4E9sEEGmkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795432587;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=VqgpEXu0QCmPpvbNu3p2fiG7kDspfbJ1mHbeSkV3Q80=;
	b=VOTTYhreF7DXiou/H+LzAX+CewLkFJ9l3SNSrK3ljaAUBOQ1WP87neD/g7o6qQu04oVj
	 fUKib68NmVxNYHo5Ah3qZYxpWZ+8Vf5R2ioDUJWyzJqvR1tsoECj34+yL99ta7umCGJNp
	 3LIc5Jgfg1dKaxAGOipieWDOC94QXWS23XVsftkh6R80bxGt4cDxO+D/ZVEBWxeuwOHsw
	 VnwYfudfjw9WVo5uopNtWYF8zfwO+hfF/MjLOA3V+8ges6wbbKSGGcWVsmiZehk0Uj4DY
	 1TntDJv+Y3lonJZH+xqys9T5YDqIPt4bKlKjlLVYTvQ9oBFex7kgJIRGDLWeF/Fs7ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HqT9QxNa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 475E8606A32E
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 11:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HqT9QxNa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3E321F0089E
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 11:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795432586;
	bh=VqgpEXu0QCmPpvbNu3p2fiG7kDspfbJ1mHbeSkV3Q80=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=HqT9QxNaG+h01GQo4rWUOXvXYt4gvEdPRHoE5KE/fcdQS0tqSrcFLVt89ZXa48C88
	 hKutX78/mxjSTL8ek6Y+j+WyoGFjFb53OpOETTscUp0wrtaYxzlot2lID0lHU4by5Z
	 e1zBak8AQ1MXj9CJYeTT6Omk8m92L3cC1zu7ZQKXk2wTP5J2H0x0kK5kpEckqnXy59
	 Z7wyyR0r0iRo6mjK98yxVjII1R2d3FTdFITJZDdmZj4HvR7K5rVOpcbQvsi0H/RZ0k
	 0qYI1FugSbzPVcAkZdqeanYaR5wlnjeJOhwurDi2ClUG3t280gnhNbCXfMPrs8NQTF
	 ZvLeCyJno0WGA==
Received: by mail-ua1-f42.google.com with SMTP id a1e0cc1a2514c-98301b325c4so714766241.1
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 03:16:26 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErFr1GzwrFSHGs7oja+lNXn4ll9ATj0uYeg05WIPsq8Mf7Nu2a57CYJYmjlhBOPVL5XXRnzJ4IR9ZwOHYw==@vger.kernel.org
X-Gm-Message-State: APuU4Z9aLDY0FoU/M2Ok7Ud+ibQcNzpNfgg3O+Ns4DlXamd//20cZRL1
	I19/phpsPHHtnuzfwa66wlb2AglcbdLzwJkuVoe20gszG8axQFm8vxyKHQxFYT0jrcp/7ZRrfHp
	aoIQYvQD8f7lYYJWgWGZJp4wjVScUUXM=
X-Received: by 2002:a05:6102:6c4:b0:7b3:8f0a:f76c with SMTP id
 ada2fe7eead31-7d7393caab1mr3796876137.13.1795432585865; Mon, 23 Nov 2026
 03:16:25 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261120-my-btrfs-patch-v2-1-5807593231d4@shangen.org>
In-Reply-To: <20261120-my-btrfs-patch-v2-1-5807593231d4@shangen.org>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 23 Nov 2026 11:15:49 +0000
X-Gmail-Original-Message-ID: <CAL3q7H5EhAi8Bc9FQQCGfKpR06ScK5UwJU=rn1A75jD0wc-DKg@mail.gmail.com>
X-Gm-Features: Aa3M54of1LMvN_03wwcVLgHgBZNx_K_thm58yundR029woX1L0Md89VbQlotCSQ
Message-ID: <CAL3q7H5EhAi8Bc9FQQCGfKpR06ScK5UwJU=rn1A75jD0wc-DKg@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: pin folios before dropping the last extent
 buffer reference
To: Shang En Sim <sim@shangen.org>
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, Boris Burkov <boris@bur.io>, 
	Daniel Vacek <neelx@suse.com>, Filipe Manana <fdmanana@suse.com>, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 20, 2026 at 10:06=E2=80=AFPM Shang En Sim <sim@shangen.org> wro=
te:
>
> release_extent_buffer() drops the last reference to an extent buffer (eb)
> before detaching its folios. For a mapped eb, alloc_extent_buffer() has
> dropped its references to the folios since commit 3649833a58b6 ("btrfs: f=
ix
> broken drop_caches on extent buffer folios"). The page cache and the
> folio's private attachment hold the remaining references.
>
> Consider the following sequence, starting with an order-0 folio F in
> btree_inode->i_mapping with F->private =3D=3D existing_eb, F refcount =3D=
=3D 2
> (1 for the page cache, 1 for F->private), and existing_eb->refs =3D=3D 1:
>
> 1) Task A drops the last reference to existing_eb:
>
>      release_extent_buffer(existing_eb)
>       refcount_dec_and_test()        # existing_eb->refs: 1 -> 0
>       spin_unlock(&existing_eb->refs_lock)
>       xa_cmpxchg_irq()               # removes existing_eb from buffer_tr=
ee
>       <window before btrfs_release_extent_buffer_folios(existing_eb)>
>
> 2) Task B allocates new_eb for the same bytenr, takes over folio F, and
>    drops its caller reference:
>
>      alloc_extent_buffer()
>       find_extent_buffer()           # NULL (existing_eb removed from tre=
e)
>       btrfs_init_eb_prealloc()       # allocates new_eb and new folios
>       init_extent_buffer()           # new_eb->refs =3D 1
>       attach_eb_folio_to_filemap()
>        filemap_add_folio() -> -EEXIST
>        filemap_lock_folio() -> F     # locks F; F refcnt: 2 -> 3
>        grab_extent_buffer(F)
>         folio_get_private(F) -> existing_eb
>         refcount_inc_not_zero(&existing_eb->refs) -> false
>                                      # existing_eb->refs =3D=3D 0
>         folio_detach_private(F)      # F->private =3D NULL; refcnt: 3->2
>        folio_put(new_eb->folios[i])  # drops new_eb's unused new folio
>        new_eb->folios[i] =3D F         # reuses existing folio F
>        attach_extent_buffer_folio(new_eb, F)
>         folio_attach_private(F, new_eb) # F->private =3D new_eb; refcnt: =
2->3
>       __xa_cmpxchg()                 # inserts new_eb into buffer_tree
>       check_buffer_tree_ref(new_eb)  # sets TREE_REF; new_eb->refs: 1 -> =
2
>       folio_unlock(F)
>       folio_put(F)                   # drops lock ref; F refcnt: 3 -> 2
>      free_extent_buffer(new_eb)
>       free_extent_buffer_clear_reading(new_eb, false)
>        release_extent_buffer(new_eb)
>         refcount_dec_and_test()      # new_eb->refs: 2 -> 1 (TREE_REF)
>
> 3) Task C runs drop_caches, releases new_eb, and evicts folio F:
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
>                folio_get_private(F) -> new_eb
>                new_eb->refs =3D=3D 1      # check passes
>                test_and_clear_bit(EXTENT_BUFFER_TREE_REF) -> true
>                release_extent_buffer(new_eb)
>                 refcount_dec_and_test() # new_eb->refs: 1 -> 0
>                 spin_unlock(&new_eb->refs_lock)
>                 xa_cmpxchg_irq()      # removes new_eb from buffer_tree
>                 btrfs_release_extent_buffer_folios(new_eb)
>                  detach_extent_buffer_folio(new_eb, F)
>                   folio_detach_private(F) # F->private=3DNULL; refcnt 3->=
2
>                 returns 1
>             remove_mapping(mapping, F)
>              __remove_mapping_unfreeze()
>               __remove_mapping()
>                folio_ref_freeze(F, 2) # F refcnt: 2 -> 0
>                                       # (existing_eb holds no ref)
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
> 4) Task A resumes and detaches existing_eb's folios:
>
>      btrfs_release_extent_buffer_folios(existing_eb)
>       detach_extent_buffer_folio(existing_eb, F)
>        mapping =3D F->mapping           # NULL (F refcnt is 0, freed/reus=
ed)
>        spin_lock(&mapping->i_private_lock) # NULL dereference
>
> If new_eb was already fully freed and detached before task C runs, e.g.
> via free_extent_buffer_stale(), F has no private attachment and
> filemap_release_folio() returns true immediately, with the same result.
>
> With a delay added in the window, this reproduces as:
>
>   BUG: kernel NULL pointer dereference, address: 0000000000000074
>   RIP: 0010:_raw_spin_lock+0x18/0x30
>   Call Trace:
>    detach_extent_buffer_folio+0x68/0x140
>    release_extent_buffer+0xac/0x120
>    btrfs_release_path+0x17/0x80
>    btrfs_free_path+0x17/0x30
>    btrfs_getxattr+0xe2/0x110
>    ...
>
> Compaction can also hit this window, since it calls
> release_extent_buffer() through btree_migrate_folio() ->
> filemap_release_folio() -> btree_release_folio().
>
> Even without the NULL mapping, the folio can already be freed and
> reused when detach_extent_buffer_folio() looks at it.
>
> This race requires nodesize >=3D PAGE_SIZE. With subpage metadata,
> grab_extent_buffer() never takes over folios, and a shared folio keeps
> folio->private set until every eb on it is detached, so
> try_release_subpage_extent_buffer() does not release it while an eb is
> in this window.
>
> Fix this in two parts:
>
> - In release_extent_buffer(), when refs is 1 and the eb is mapped, take
>   a reference on each folio before dropping the eb reference, and drop
>   those references after the folios are detached. This keeps the folios
>   alive across the window, as the eb's own folio reference did before
>   the commit above.
>   Checking refs =3D=3D 1 under refs_lock is enough: free_extent_buffer()
>   only decrements a mapped eb's refs without refs_lock while refs is
>   above 3, so no one else can drop it to 0 under us.
>
> - In detach_extent_buffer_folio(), take i_private_lock from the btree
>   inode instead of from folio->mapping. A pinned folio can still be
>   removed from the page cache. All folios of a mapped eb belong to the
>   btree inode, so this is the same lock in every other case.
>
> Fixes: 3649833a58b6 ("btrfs: fix broken drop_caches on extent buffer foli=
os")
> Cc: stable@vger.kernel.org # 6.16+
> Signed-off-by: Shang En Sim <sim@shangen.org>
> ---
> I reproduced the oops with a test-only delay.
>
> v1 testing on btrfs for-next 6f4bbde7e036, 8 vCPUs, 2 NUMA nodes, 120 s
> per run of the reproducer:
>
> - delay only: oops in 3 of 4 runs (at 61 s, 83 s, 46 s), trace as in
>   the commit message
> - delay + this patch: no oops in 3 runs
>
> Subpage, arm64 with 64K pages, nodesize 16K, emulated in QEMU:
>
> - delay only: no oops in 3 runs (expected: grab_extent_buffer() does
>   not take over folios for subpage)
> - delay + this patch: no oops in 3 runs
>
> v1 built with W=3D1 with no new warnings in fs/btrfs/.
> On the v2 base, fs/btrfs/extent_io.o built with W=3D1 on x86-64.
> ---
> Changes in v2:
> - Drop "mapped" from the first sentence, release_extent_buffer() handles
>   both mapped and unmapped buffers (Filipe).
> - Replace the race diagram with the full step-by-step sequence from the
>   v1 discussion, using existing_eb and new_eb (Filipe).

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Perfect, thanks!
Pushing it to github for-next soon.

> - Rebase onto btrfs for-next.
> - Link to v1: https://patch.msgid.link/20261117-my-btrfs-patch-v1-1-4b934=
a7ff69a@shangen.org
> ---
>  fs/btrfs/extent_io.c | 33 ++++++++++++++++++++++++++++++---
>  1 file changed, 30 insertions(+), 3 deletions(-)
>
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index b2739838c646..ce6880b1d64e 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -3155,15 +3155,18 @@ static bool folio_range_has_eb(struct folio *foli=
o)
>  static void detach_extent_buffer_folio(const struct extent_buffer *eb, s=
truct folio *folio)
>  {
>         struct btrfs_fs_info *fs_info =3D eb->fs_info;
> -       struct address_space *mapping =3D folio->mapping;
> +       struct address_space *mapping =3D NULL;
>         const bool mapped =3D !test_bit(EXTENT_BUFFER_UNMAPPED, &eb->bfla=
gs);
>
>         /*
>          * For mapped eb, we're going to change the folio private, which =
should
> -        * be done under the i_private_lock.
> +        * be done under the i_private_lock. Do not use folio->mapping, t=
he
> +        * folio may have left the page cache, see release_extent_buffer(=
).
>          */
> -       if (mapped)
> +       if (mapped) {
> +               mapping =3D fs_info->btree_inode->i_mapping;
>                 spin_lock(&mapping->i_private_lock);
> +       }
>
>         if (!folio_test_private(folio)) {
>                 if (mapped)
> @@ -4011,8 +4014,27 @@ static inline void btrfs_release_extent_buffer_rcu=
(struct rcu_head *head)
>  static int release_extent_buffer(struct extent_buffer *eb)
>         __releases(&eb->refs_lock)
>  {
> +       struct folio *pinned[INLINE_EXTENT_BUFFER_PAGES];
> +       int nr_pinned =3D 0;
> +
>         lockdep_assert_held(&eb->refs_lock);
>
> +       /*
> +        * Once refs drops to 0 our folios can be taken over and freed, s=
o pin
> +        * them until they are detached. refs only drops below 3 under
> +        * refs_lock, so checking for 1 is enough. Keep the folios in a l=
ocal
> +        * array: if refs does not hit 0, another holder may free the eb.
> +        */
> +       if (refcount_read(&eb->refs) =3D=3D 1 &&
> +           !test_bit(EXTENT_BUFFER_UNMAPPED, &eb->bflags)) {
> +               for (int i =3D 0; i < INLINE_EXTENT_BUFFER_PAGES; i++) {
> +                       if (!eb->folios[i])
> +                               continue;
> +                       folio_get(eb->folios[i]);
> +                       pinned[nr_pinned++] =3D eb->folios[i];
> +               }
> +       }
> +
>         if (refcount_dec_and_test(&eb->refs)) {
>                 struct btrfs_fs_info *fs_info =3D eb->fs_info;
>
> @@ -4039,6 +4061,8 @@ static int release_extent_buffer(struct extent_buff=
er *eb)
>                 btrfs_leak_debug_del_eb(eb);
>                 /* Should be safe to release folios at this point. */
>                 btrfs_release_extent_buffer_folios(eb);
> +               for (int i =3D 0; i < nr_pinned; i++)
> +                       folio_put(pinned[i]);
>  #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
>                 if (unlikely(test_bit(EXTENT_BUFFER_UNMAPPED, &eb->bflags=
))) {
>                         kmem_cache_free(extent_buffer_cache, eb);
> @@ -4050,6 +4074,9 @@ static int release_extent_buffer(struct extent_buff=
er *eb)
>         }
>         spin_unlock(&eb->refs_lock);
>
> +       for (int i =3D 0; i < nr_pinned; i++)
> +               folio_put(pinned[i]);
> +
>         return 0;
>  }
>
>
> ---
> base-commit: 184fa2c40f5c50afb1d8bf900eafadf450db392e
> change-id: 20261117-my-btrfs-patch-984742ed64b0
>
> Best regards,
> --
> Shang En Sim <sim@shangen.org>
>
>
