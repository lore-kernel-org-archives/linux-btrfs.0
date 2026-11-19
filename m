Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795109128;
	b=QyKnrh3zwHH6QibO0ypCbP2IBDg5ux2aCpazcKdAqjs9yBVrjnAyqGwbb8feyMr1xqkb
	 1GK373vC95kqZgr5sA6F9W4Eqj/qkwEmuLmKqCWge2qFvdXDC4A7+YRkrJ7bcNxf8GO8B
	 9Oum2upd/w4z7L6sQaIwTGrv8uf8uPqZavJy8Sx3EK46iEJ3sN/ZB5ZBkfUdC+tBRxt5P
	 wHioSnOxbqp2Z13zg7PbhjzUzyYdS8lvPPB8rHy9hqoBIIIUFmek5DoReTwXSFHWN3IgI
	 J4OSk2wJ5pjlwPXdOG7fWUpACXqGK0ifraY7mL6oxqyva9mgKT+4wcGZ8Mr83DKJxSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795109128;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=3NoSJfl1tqPHZMrjtjOr+avKcj2bGSnTS+mj2gEXY4g=;
	b=RVeG3p673g0j2ubbQLxBLRZeIpMwg96e1nq88cqfCvkBllCPzbJDHqkSWXImgukueWYf
	 WGCnuu/WxrklLEvOw8jlWYvXt3i7kX4Gm1HiUHlh44OFQ+47GCksr+w3DsP7SDsDNo5ve
	 Co7K2Mt+gcXkYlsAOkPlBEicr3L4q4Gqg1t04NEQGUAwEWRp7Uw/DTy3kmM5m5lMjwDLk
	 02mYTg+gR+jZXT55ZVL/5AXJ5U+ox02gYzQzLfTRHBVh08psoPmF+0/QP0pxeW+PRyU2y
	 N71DBCUxVrIWrs2bQllXuXj1hX/mMDtM7WPhJugdiwSo5rplYZTVZi/w12Ry2bjZYwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i9sxPLmp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 031BC60A2601
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2026 17:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i9sxPLmp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6EF51F000D0
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2026 17:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795109127;
	bh=3NoSJfl1tqPHZMrjtjOr+avKcj2bGSnTS+mj2gEXY4g=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=i9sxPLmpU/uHzsHSeSBEmSkGOLpfHXZX5pm+/F0Kx4GRHKanFH21C+etGgFQ/qaSF
	 E3vDHPY+j43vwEGvErHRK0xLbXC3C09HCHTBANWn89f7+C8CaZAOakxDBBbfsCL+Mw
	 gjsNNVBAXu1Fl36G9RYd9oCK7G9KFiQevyZa1mmGTd9SpXpYgprwxgEFjPFoNYQU4j
	 QSJpHEzraxL2f0bSUsO8vYvcsbY5ydkuZkQF8UiBs6ccsQ3rKDb5Ieoush2xEdPpPl
	 xBTKMffUa1wJgum2i/zWn7mmQ31yu8UWzVue6W5wg/Y0/DSFbgRghF0U2Ab4q7CgLo
	 i164QxuA/sKww==
Received: by mail-ua1-f51.google.com with SMTP id a1e0cc1a2514c-97ccbba8e86so629241.3
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2026 09:25:27 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErFZS9tX/Pnz30sJvv6/w5pozzGu/smvYNKkK9QRfiRDXL06bnsq/SP2dteOzR1uhnpLwAlQDe1IdaCExg==@vger.kernel.org
X-Gm-Message-State: APuU4Z/TVhw9QU+Fk+eTqm7kpXN0qSiaEqbLXAPvO/mtSraLE32dZ4tZ
	ERWTRNy+rNkQBCv3wNyv1whLCdygsy54uJFyFfG25UcrrAuUFwV6SbZVQS/B3u5C/AEwpAdT3ri
	/szuLjkH/p/D25HR9l8a3cSeFYL5u0os=
X-Received: by 2002:a05:6102:f86:b0:7d6:5e38:3418 with SMTP id
 ada2fe7eead31-7d72b361662mr77131137.1.1795109126797; Thu, 19 Nov 2026
 09:25:26 -0800 (PST)
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
In-Reply-To: <20261117-my-btrfs-patch-v1-1-4b934a7ff69a@shangen.org>
From: Filipe Manana <fdmanana@kernel.org>
Date: Thu, 19 Nov 2026 17:24:50 +0000
X-Gmail-Original-Message-ID: <CAL3q7H6zzrx-oHoiXqMA6U=GoS8rZpWE7gjtZDkrA-87UycM-Q@mail.gmail.com>
X-Gm-Features: Aa3M54qLUJH02-K1Z64C4KQNI1pPF-WbaI7fXt34O8XuDtnG3g3eFGBh7xxyv50
Message-ID: <CAL3q7H6zzrx-oHoiXqMA6U=GoS8rZpWE7gjtZDkrA-87UycM-Q@mail.gmail.com>
Subject: Re: [PATCH] btrfs: pin folios before dropping the last extent buffer reference
To: Shang En Sim <sim@shangen.org>
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, Boris Burkov <boris@bur.io>, 
	Daniel Vacek <neelx@suse.com>, Filipe Manana <fdmanana@suse.com>, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 18, 2026 at 12:20=E2=80=AFAM Shang En Sim <sim@shangen.org> wro=
te:
>
> release_extent_buffer() drops the last reference to a mapped extent
> buffer (eb) before detaching its folios.

To mapped and unmapped extent buffers, so remove the "mapped" part.

> The eb holds no reference to
> the folios themselves.
>
> Since commit 3649833a58b6 ("btrfs: fix broken drop_caches on extent
> buffer folios"), the page cache owns the allocation reference. Once the
> eb's reference count reaches zero, another eb can take over the folios.
> They can then be evicted before the original eb detaches them:
>
>   task A                         task B                    task C
>   release_extent_buffer(eb)
>    refs: 1 -> 0
>    remove eb from buffer_tree
>                                  alloc_extent_buffer()
>                                   attach_eb_folio_to_filemap()
>                                    grab_extent_buffer()
>                                     refs is 0, take over
>                                     the folios
>                                  ... new eb released ...

It's not "new eb released", it's the new folio that is released and we
take the existing folio into the new eb.

>                                                            drop_caches
>                                                             folio->mappin=
g
>                                                             =3D NULL

And where does this happens?
Please be detailed, add the call chain triggered by drop_caches that
results in setting the folio's mapping to NULL.

I don't see how that is happening, because when we end up in
try_release_extent_buffer(), eb->refs is 0 and that
makes us return immediately with 0:

spin_lock(&eb->refs_lock);
if (refcount_read(&eb->refs) !=3D 1 || extent_buffer_under_io(eb)) {
        spin_unlock(&eb->refs_lock);
        spin_unlock(&folio->mapping->i_private_lock);
        return 0;
}
spin_unlock(&folio->mapping->i_private_lock);

Thanks.

>    btrfs_release_extent_buffer_folios()
>     detach_extent_buffer_folio()
>      mapping =3D folio->mapping (NULL)
>      spin_lock(&mapping->i_private_lock)
>
> The result is a NULL pointer dereference. With a delay added in the
> window (not part of this patch), it reproduces as:
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
> btree_release_folio().
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
> I reproduced the oops with the test-only delay below.
>
> Testing, on btrfs for-next 6f4bbde7e036, 8 vCPUs, 2 NUMA nodes, 120 s
> per run of the reproducer below:
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
> Builds with W=3D1 with no new warnings in fs/btrfs/.
>
> Test-only delay patch:
>
>   @@ -4037,6 +4038,10 @@ static int release_extent_buffer(struct extent_b=
uffer *eb)
>                                GFP_ATOMIC);
>
>                 btrfs_leak_debug_del_eb(eb);
>   +             /* TEST ONLY: widen the window between last ref drop and =
folio detach. */
>   +             if (!test_bit(EXTENT_BUFFER_UNMAPPED, &eb->bflags) &&
>   +                 ((eb->start >> 14) & 7) =3D=3D 0 && (jiffies & 3) =3D=
=3D 0)
>   +                     mdelay(20);
>                 /* Should be safe to release folios at this point. */
>                 btrfs_release_extent_buffer_folios(eb);
>    #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
>   (plus #include <linux/delay.h>)
>
> Reproducer, run on a 128M loop btrfs with -n 16384, mounted -o commit=3D1=
:
>
>   ./repro-xattr 120 /mnt
>
>   // SPDX-License-Identifier: GPL-2.0
>   /*
>    * btrfs: release_extent_buffer() vs. folio reuse and eviction.
>    *
>    *   task A                         task B                    task C
>    *   release_extent_buffer(eb)
>    *    refs -> 0, removed from tree
>    *                                  alloc_extent_buffer()
>    *                                   grab_extent_buffer()
>    *                                    takes over eb's folios
>    *                                  ... new eb released ...
>    *                                                            drop_cach=
es
>    *                                                             folio->m=
apping =3D NULL
>    *    detach_extent_buffer_folio()
>    *     spin_lock(&folio->mapping->i_private_lock)   <-- NULL deref
>    *
>    * I have only seen this program crash a kernel that has the TEST ONLY
>    * delay patch applied.
>    *
>    * Usage: repro-xattr <seconds> <btrfs mountpoint>
>    */
>   #define _GNU_SOURCE
>   #include <fcntl.h>
>   #include <pthread.h>
>   #include <sched.h>
>   #include <stdint.h>
>   #include <stdio.h>
>   #include <stdlib.h>
>   #include <string.h>
>   #include <sys/stat.h>
>   #include <sys/types.h>
>   #include <sys/xattr.h>
>   #include <unistd.h>
>
>   #define NFILES 64
>
>   static volatile int stop_flag;
>   static int fds[NFILES];
>   static int root_fd =3D -1;
>
>   static void pin_cpu(int cpu)
>   {
>         cpu_set_t set;
>
>         CPU_ZERO(&set);
>         CPU_SET(cpu % 8, &set);
>         sched_setaffinity(0, sizeof(set), &set);
>   }
>
>   /* Readers take and drop references on the leaves that hold the xattrs.=
 */
>   static void *xattr_reader(void *arg)
>   {
>         char buf[256];
>
>         pin_cpu((int)(intptr_t)arg);
>         while (!stop_flag) {
>                 for (int i =3D 0; i < NFILES && !stop_flag; i++) {
>                         fgetxattr(fds[i], "user.a", buf, sizeof(buf));
>                         fgetxattr(fds[i], "user.miss", buf, sizeof(buf));
>                 }
>         }
>         return NULL;
>   }
>
>   /* Writers COW the leaves and commit, so old leaves become clean and st=
ale. */
>   static void *xattr_cow_writer(void *arg)
>   {
>         char val[128];
>         int tick =3D 0;
>
>         pin_cpu((int)(intptr_t)arg);
>         memset(val, 'X', sizeof(val));
>         while (!stop_flag) {
>                 val[0] =3D (char)('A' + (tick & 15));
>                 fsetxattr(fds[tick & (NFILES - 1)], "user.b", val, sizeof=
(val), 0);
>                 if ((tick & 7) =3D=3D 0)
>                         syncfs(root_fd);
>                 tick++;
>         }
>         return NULL;
>   }
>
>   /* Evict clean btree folios from the page cache and migrate the rest. *=
/
>   static void *evict_and_compact(void *arg)
>   {
>         int cfd =3D open("/proc/sys/vm/compact_memory", O_WRONLY);
>         int dfd =3D open("/proc/sys/vm/drop_caches", O_WRONLY);
>         int iter =3D 0;
>
>         pin_cpu((int)(intptr_t)arg);
>         while (!stop_flag) {
>                 if ((iter & 1) =3D=3D 0 && dfd >=3D 0)
>                         (void)!write(dfd, "1\n", 2);
>                 if (cfd >=3D 0)
>                         (void)!write(cfd, "1\n", 2);
>                 iter++;
>         }
>         return NULL;
>   }
>
>   int main(int argc, char **argv)
>   {
>         int duration =3D (argc > 1) ? atoi(argv[1]) : 60;
>         const char *mnt =3D (argc > 2) ? argv[2] : "/mnt";
>         char init_val[180];
>         pthread_t tids[10];
>         int nt =3D 0;
>
>         root_fd =3D open(mnt, O_RDONLY | O_DIRECTORY);
>         if (root_fd < 0) {
>                 perror("open mountpoint");
>                 return 2;
>         }
>         memset(init_val, 'Z', sizeof(init_val));
>         for (int i =3D 0; i < NFILES; i++) {
>                 char path[256];
>
>                 snprintf(path, sizeof(path), "%s/file_%03d", mnt, i);
>                 fds[i] =3D open(path, O_CREAT | O_RDWR | O_TRUNC, 0644);
>                 if (fds[i] < 0) {
>                         perror("open file");
>                         return 2;
>                 }
>                 fsetxattr(fds[i], "user.a", init_val, sizeof(init_val), 0=
);
>                 fsetxattr(fds[i], "user.b", init_val, 128, 0);
>         }
>         syncfs(root_fd);
>
>         for (int i =3D 0; i < 4; i++)
>                 pthread_create(&tids[nt++], NULL, xattr_reader, (void *)(=
intptr_t)i);
>         for (int i =3D 0; i < 2; i++)
>                 pthread_create(&tids[nt++], NULL, xattr_cow_writer, (void=
 *)(intptr_t)(4 + i));
>         for (int i =3D 0; i < 4; i++)
>                 pthread_create(&tids[nt++], NULL, evict_and_compact, (voi=
d *)(intptr_t)(4 + i));
>
> printf("[repro-xattr] %d threads on %d files for %ds\n", nt, NFILES, dura=
tion);
>         fflush(stdout);
>         for (int s =3D 0; s < duration; s++) {
>                 sleep(1);
>                 if ((s + 1) % 10 =3D=3D 0) {
>                         printf("[repro-xattr] %d/%ds\n", s + 1, duration)=
;
>                         fflush(stdout);
>                 }
>         }
>         stop_flag =3D 1;
>         for (int i =3D 0; i < nt; i++)
>                 pthread_join(tids[i], NULL);
>         printf("[repro-xattr] finished %ds, no panic\n", duration);
>         return 0;
>   }
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
> base-commit: 6f4bbde7e0364b3676d7644af2d4be386f512b0e
> change-id: 20261117-my-btrfs-patch-984742ed64b0
>
> Best regards,
> --
> Shang En Sim <sim@shangen.org>
>
>
