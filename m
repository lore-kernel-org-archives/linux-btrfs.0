Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:57012 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052AbaKKMEe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Nov 2014 07:04:34 -0500
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: btrfs re-entrance bugs
In-Reply-To: <1415706590-24159-1-git-send-email-dmonakhov@openvz.org>
References: <1415706590-24159-1-git-send-email-dmonakhov@openvz.org>
Date: Tue, 11 Nov 2014 15:04:18 +0300
Message-ID: <87ioimvt8d.fsf@openvz.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Dmitry Monakhov <dmonakhov@openvz.org> writes:

> If filesystem holds transaction open 'current->journal_info' it should not
> performs memory allocations with __GFP_FS flag enabled otherwise this res=
ult in fs
> reentarance which lead to:
> 1) reentrance to itself : deadlock or internal assertion failure due to i=
ncorrect journal credits
> 1) entrance to another fs: assertion faulure or silient corruption due to=
 incorrect journal
I've run xfstests suite for ext4, xfs and btrfs and it is appeared that
btrfs has number of issues with fs re-entrance

#BUG1: btrfs_create, btrfs_mknode, btrfs_synlink, etc

btrfs_create:
 ->btrfs_start_transaction
 ->btrfs_find_free_ino
    ->start_caching
      ->kthread_run -> try to allocate mem with GFP_KERNEL

I'm not expert in btrfs but it looks like this issue may be fixed easily by=
 moving
btrfs_find_free_ino out of transaction scope.

#BUG2 btrfs_ioctl_send create fake journal transaction
 current->journal_info =3D BTRFS_SEND_TRANS_STUB
 and then call vfs_write which performs various mem allocation
=20

WARNING: CPU: 1 PID: 30532 at mm/page_alloc.c:2808 __alloc_pages_nodemask+0=
xca/0x65d()
Modules linked in:
CPU: 1 PID: 30532 Comm: btrfs Not tainted 3.18.0-rc2-00012-g9f89e906-dirty =
#219
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.7.5-0-ge5=
1488c-20140602_164612-nilsson.home.kraxel.org 04/01/2014
 0000000000000af8 ffff88007acd79d8 ffffffff816bc74b 0000000000000af8
 0000000000000000 ffff88007acd7a18 ffffffff81086599 00000000000200d2
 ffffffff81144d2d 00000000000200d2 0000000000000000 0000000000000000
Call Trace:
 [<ffffffff816bc74b>] dump_stack+0x49/0x5e
 [<ffffffff81086599>] warn_slowpath_common+0x81/0x9b
 [<ffffffff81144d2d>] ? __alloc_pages_nodemask+0xca/0x65d
 [<ffffffff810865cd>] warn_slowpath_null+0x1a/0x1c
 [<ffffffff81144d2d>] __alloc_pages_nodemask+0xca/0x65d
 [<ffffffff810bc9fa>] ? trace_hardirqs_on_caller+0x164/0x19b
 [<ffffffff810bca3e>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff811863d6>] ? pipe_write+0x40/0x419
 [<ffffffff811863d6>] ? pipe_write+0x40/0x419
 [<ffffffff8118658b>] pipe_write+0x1f5/0x419
 [<ffffffff8117e80a>] new_sync_write+0x8a/0xb2
 [<ffffffff8117fdb7>] vfs_write+0xb5/0x14d
 [<ffffffff81375b9b>] write_buf+0x58/0x8e
 [<ffffffff8137c382>] btrfs_ioctl_send+0x5fa/0xdf8
 [<ffffffff810ab549>] ? sched_clock_local+0x1c/0x82
 [<ffffffff810bc488>] ? mark_lock+0x2d/0x1ec
 [<ffffffff810bdc0f>] ? __lock_acquire+0x3e8/0xf39
 [<ffffffff810ab852>] ? sched_clock_cpu+0x8e/0xaa
 [<ffffffff816c1d83>] ? _raw_spin_unlock_irqrestore+0x55/0x72
 [<ffffffff8134f6f8>] btrfs_ioctl+0x1258/0x1420
 [<ffffffff8104a9b1>] ? sched_clock+0x17/0x1b
 [<ffffffff810ab549>] ? sched_clock_local+0x1c/0x82
 [<ffffffff810ab852>] ? sched_clock_cpu+0x8e/0xaa
 [<ffffffff8118e227>] do_vfs_ioctl+0x43f/0x485
 [<ffffffff81197154>] ? __fget+0x8c/0x97
 [<ffffffff8118e2c7>] SyS_ioctl+0x5a/0x7f
 [<ffffffff816c2229>] system_call_fastpath+0x12/0x17





>
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  include/linux/kernel.h |    7 +++++++
>  mm/dmapool.c           |    1 +
>  mm/mempool.c           |    1 +
>  mm/page_alloc.c        |    1 +
>  mm/slab.c              |    1 +
>  mm/slub.c              |    1 +
>  6 files changed, 12 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 3d770f5..69923d4 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -232,6 +232,13 @@ void might_fault(void);
>  static inline void might_fault(void) { }
>  #endif
>=20=20
> +#ifdef CONFIG_PROVE_LOCKING
> +#define might_enter_fs_if(cond) \
> +	 WARN_ON_ONCE((cond) && current->journal_info)
> +#else
> +static inline void might_enter_fs_if(bool cond) { }
> +#endif
> +
>  extern struct atomic_notifier_head panic_notifier_list;
>  extern long (*panic_blink)(int state);
>  __printf(1, 2)
> diff --git a/mm/dmapool.c b/mm/dmapool.c
> index fd5fe43..c543eb8 100644
> --- a/mm/dmapool.c
> +++ b/mm/dmapool.c
> @@ -324,6 +324,7 @@ void *dma_pool_alloc(struct dma_pool *pool, gfp_t mem=
_flags,
>  	void *retval;
>=20=20
>  	might_sleep_if(mem_flags & __GFP_WAIT);
> +	might_enter_fs_if(mem_flags & __GFP_FS);
>=20=20
>  	spin_lock_irqsave(&pool->lock, flags);
>  	list_for_each_entry(page, &pool->page_list, page_list) {
> diff --git a/mm/mempool.c b/mm/mempool.c
> index e209c98..b5bb86f 100644
> --- a/mm/mempool.c
> +++ b/mm/mempool.c
> @@ -204,6 +204,7 @@ void * mempool_alloc(mempool_t *pool, gfp_t gfp_mask)
>=20=20
>  	VM_WARN_ON_ONCE(gfp_mask & __GFP_ZERO);
>  	might_sleep_if(gfp_mask & __GFP_WAIT);
> +	might_enter_fs_if(gfp_mask & __GFP_FS);
>=20=20
>  	gfp_mask |=3D __GFP_NOMEMALLOC;	/* don't allocate emergency reserves */
>  	gfp_mask |=3D __GFP_NORETRY;	/* don't loop in __alloc_pages */
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 9cd36b8..284a699 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -2805,6 +2805,7 @@ __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int=
 order,
>  	lockdep_trace_alloc(gfp_mask);
>=20=20
>  	might_sleep_if(gfp_mask & __GFP_WAIT);
> +	might_enter_fs_if(gfp_mask & __GFP_FS);
>=20=20
>  	if (should_fail_alloc_page(gfp_mask, order))
>  		return NULL;
> diff --git a/mm/slab.c b/mm/slab.c
> index eb2b2ea..43b0d2f 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -2844,6 +2844,7 @@ static inline void cache_alloc_debugcheck_before(st=
ruct kmem_cache *cachep,
>  						gfp_t flags)
>  {
>  	might_sleep_if(flags & __GFP_WAIT);
> +	might_enter_fs_if(flags & __GFP_FS);
>  #if DEBUG
>  	kmem_flagcheck(cachep, flags);
>  #endif
> diff --git a/mm/slub.c b/mm/slub.c
> index ae7b9f1..474fc53 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -1238,6 +1238,7 @@ static inline int slab_pre_alloc_hook(struct kmem_c=
ache *s, gfp_t flags)
>  	flags &=3D gfp_allowed_mask;
>  	lockdep_trace_alloc(flags);
>  	might_sleep_if(flags & __GFP_WAIT);
> +	might_enter_fs_if(flags & __GFP_FS);
>=20=20
>  	return should_failslab(s->object_size, flags, s->flags);
>  }
> --=20
> 1.7.1

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCgAGBQJUYftDAAoJELhyPTmIL6kBqKsH/R2DLDMXJ4fU5to9BfFs9Msp
8U2D5vBjCefS2YtkRUr3NHPadOeR0Shyy+1hoqaxo9bhMpzkVnUBH4nlC4fZhAxV
u8pbSb8rTI3fLdzEAYl5PbqyXNUFlxp7+iLd3t8hm2ZOsEMqkCaYhKQzSBcFHrx9
s7m/NkgoXiVakH28sxjuyaaOpK09YpnIwsQr+cWAhkCb4pfyZaoVFfgW2ySA19B5
4f7aiejIz08zZMr2lw1Wmhk8rJrmETPBZ3OuYIgALs6smn/30yPAjZ6FMlhvzRLf
KPiyeJPwkjg6P7/mORUhfriY37P/iAW6IWf55wjW+yyaIlwcNOlSSh4xl3HNJUQ=
=Ciw0
-----END PGP SIGNATURE-----
--=-=-=--
