From: Sergei Trofimovich <slyich@gmail.com>
Subject: Re: [PATCH] btrfs: fix warning in iput for bad-inode
Date: Tue, 30 Aug 2011 22:31:16 +0300
Message-ID: <20110830223116.5fc21074@sf>
References: <20110817185619.4660.78543.stgit@localhost6>
	<20110829063416.00f4652c@sf>
	<20110830195309.4882f478@sf>
	<4E5D25BD.3020901@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/DN/bKfCxGIN3tiPHNP=V26G"; protocol="application/pgp-signature"
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>,
	linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E5D25BD.3020901@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/DN/bKfCxGIN3tiPHNP=V26G
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 30 Aug 2011 14:02:37 -0400
Josef Bacik <josef@redhat.com> wrote:

> On 08/30/2011 12:53 PM, Sergei Trofimovich wrote:
> >> Running 'sync' program after the load does not finish and eats=20
> >> 100%CPU busy-waiting for something in kernel.
> >>=20
> >> It's easy to reproduce hang with patch for me. I just run
> >> liferea and sync after it. Without patch I haven't managed to
> >> hang btrfs up.
> >=20
> > And I think it's another btrfs bug. I've managed to reproduce it=20
> > _without_ your patch and _without_ autodefrag enabled by manually=20
> > running the following commands: $ btrfs fi defrag=20
> > file-with-20_000-extents $ sync
> >=20
> > I think your patch just shuffles things a bit and forces
> > autodefrag races to pop-up sooner (which is good! :])
> >=20
>=20
> Sergei, can you do sysrq+w when this is happening, and maybe turn on
> the softlockup detector so we can see where sync is getting stuck?
> Thanks,

Sure. As I keep telling about 2 cases in IRC I will state both here explici=
tely:

=3D=3DThe First Issue (aka "The Hung sync()" case) =3D=3D

- it's an unpatched linus's v3.1-rc4-80-g0f43dd5
- /dev/root on / type btrfs (rw,noatime,compress=3Dlzo)
- 50% full 30GB filesystem (usual nonmixed mode)

How I hung it:
    $ /usr/sbin/filefrag ~/.bogofilter/wordlist.db=20
        /home/st/.bogofilter/wordlist.db: 19070 extents found
      the file is 138MB sqlite database for bayesian SPAM filter,
      it's being read and written every 20 minutes or so.
      Maybe, it was writtent even in defrag/sync time!
    $~/dev/git/btrfs-progs-unstable/btrfs fi defrag ~/.bogofilter/wordlist.=
db=20
    $ sync
    ^C<hung in D-state>

I didn't try to reproduce it yet.
As for lockdep I'll try but I'm afraid I will fail to reproduce, but I'll t=
ry tomorrow.
I suspect I'll need to seriously fragment some file first down to such horr=
ible state.

With help of David I've some (hopefully relevant) info:
    #!/bin/sh -x
   =20
    for i in $(ps aux|grep " D[+ ]\?"|awk '{print $2}'); do
            ps $i
            sudo cat /proc/$i/stack
    done

  PID TTY      STAT   TIME COMMAND
 1291 ?        D      0:00 [btrfs-endio-wri]
[<ffffffff8130055d>] btrfs_tree_read_lock+0x6d/0x120
[<ffffffff812b8e88>] btrfs_search_slot+0x698/0x8b0
[<ffffffff812c9e18>] btrfs_lookup_csum+0x68/0x190
[<ffffffff812ca10f>] __btrfs_lookup_bio_sums+0x1cf/0x3e0
[<ffffffff812ca371>] btrfs_lookup_bio_sums+0x11/0x20
[<ffffffff812d6a50>] btrfs_submit_bio_hook+0x140/0x170
[<ffffffff812ed594>] submit_one_bio+0x64/0xa0
[<ffffffff812f14f5>] extent_readpages+0xe5/0x100
[<ffffffff812d7aaa>] btrfs_readpages+0x1a/0x20
[<ffffffff810a6a02>] __do_page_cache_readahead+0x1d2/0x280
[<ffffffff810a6d8c>] ra_submit+0x1c/0x20
[<ffffffff810a6ebd>] ondemand_readahead+0x12d/0x270
[<ffffffff810a70cc>] page_cache_sync_readahead+0x2c/0x40
[<ffffffff81309987>] __load_free_space_cache+0x1a7/0x5b0
[<ffffffff81309e61>] load_free_space_cache+0xd1/0x190
[<ffffffff812be07b>] cache_block_group+0xab/0x290
[<ffffffff812c3def>] find_free_extent.clone.71+0x39f/0xab0
[<ffffffff812c5160>] btrfs_reserve_extent+0xe0/0x170
[<ffffffff812c56df>] btrfs_alloc_free_block+0xcf/0x330
[<ffffffff812b498d>] __btrfs_cow_block+0x11d/0x4a0
[<ffffffff812b4df8>] btrfs_cow_block+0xe8/0x1a0
[<ffffffff812b8965>] btrfs_search_slot+0x175/0x8b0
[<ffffffff812c9e18>] btrfs_lookup_csum+0x68/0x190
[<ffffffff812caf6e>] btrfs_csum_file_blocks+0xbe/0x670
[<ffffffff812d7d91>] add_pending_csums.clone.39+0x41/0x60
[<ffffffff812da528>] btrfs_finish_ordered_io+0x218/0x310
[<ffffffff812da635>] btrfs_writepage_end_io_hook+0x15/0x20
[<ffffffff8130c71a>] end_compressed_bio_write+0x7a/0xe0
[<ffffffff811146f8>] bio_endio+0x18/0x30
[<ffffffff812cd8fc>] end_workqueue_fn+0xec/0x120
[<ffffffff812fb0ac>] worker_loop+0xac/0x520
[<ffffffff8105d486>] kthread+0x96/0xa0
[<ffffffff815f9214>] kernel_thread_helper+0x4/0x10
[<ffffffffffffffff>] 0xffffffffffffffff
  PID TTY      STAT   TIME COMMAND
 1296 ?        D      0:00 [btrfs-transacti]
[<ffffffff812d3d6e>] btrfs_commit_transaction+0x22e/0x870
[<ffffffff812cd5bb>] transaction_kthread+0x26b/0x280
[<ffffffff8105d486>] kthread+0x96/0xa0
[<ffffffff815f9214>] kernel_thread_helper+0x4/0x10
[<ffffffffffffffff>] 0xffffffffffffffff
  PID TTY      STAT   TIME COMMAND
 2891 pts/0    D+     0:00 sync
[<ffffffff8109d069>] sleep_on_page+0x9/0x10
[<ffffffff8109d28e>] wait_on_page_bit+0x6e/0x80
[<ffffffff8109d9aa>] filemap_fdatawait_range+0xfa/0x190
[<ffffffff8109da62>] filemap_fdatawait+0x22/0x30
[<ffffffff8110ae5a>] sync_inodes_sb+0x17a/0x1e0
[<ffffffff8110eae8>] __sync_filesystem+0x78/0x80
[<ffffffff8110eb07>] sync_one_sb+0x17/0x20
[<ffffffff810e9cc5>] iterate_supers+0x95/0xf0
[<ffffffff8110ea2b>] sync_filesystems+0x1b/0x20
[<ffffffff8110eb8c>] sys_sync+0x1c/0x40
[<ffffffff815f813b>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff
  PID TTY      STAT   TIME COMMAND
cat: /proc/4454/stack: =D0=9D=D0=B5=D1=82 =D1=82=D0=B0=D0=BA=D0=BE=D0=B3=D0=
=BE =D1=84=D0=B0=D0=B9=D0=BB=D0=B0 =D0=B8=D0=BB=D0=B8 =D0=BA=D0=B0=D1=82=D0=
=B0=D0=BB=D0=BE=D0=B3=D0=B0

disassebbled btrfs_tree_read_lock:

ffffffff813004f0 <btrfs_tree_read_lock> push   %rbp
ffffffff813004f1 <btrfs_tree_read_lock+0x1> mov    %gs:0xb5c0,%rax
ffffffff813004fa <btrfs_tree_read_lock+0xa> mov    %rsp,%rbp
ffffffff813004fd <btrfs_tree_read_lock+0xd> push   %r15
ffffffff813004ff <btrfs_tree_read_lock+0xf> push   %r14
ffffffff81300501 <btrfs_tree_read_lock+0x11> lea    0x6c(%rdi),%r14
ffffffff81300505 <btrfs_tree_read_lock+0x15> push   %r13
ffffffff81300507 <btrfs_tree_read_lock+0x17> lea    0x70(%rdi),%r13
ffffffff8130050b <btrfs_tree_read_lock+0x1b> push   %r12
ffffffff8130050d <btrfs_tree_read_lock+0x1d> lea    -0x60(%rbp),%r12
ffffffff81300511 <btrfs_tree_read_lock+0x21> push   %rbx
ffffffff81300512 <btrfs_tree_read_lock+0x22> lea    0x18(%r12),%r15
ffffffff81300517 <btrfs_tree_read_lock+0x27> lea    0x5c(%rdi),%rbx
ffffffff8130051b <btrfs_tree_read_lock+0x2b> sub    $0x58,%rsp
ffffffff8130051f <btrfs_tree_read_lock+0x2f> mov    %rdi,-0x70(%rbp)
ffffffff81300523 <btrfs_tree_read_lock+0x33> mov    %rax,-0x68(%rbp)
ffffffff81300527 <btrfs_tree_read_lock+0x37> mov    %rax,-0x78(%rbp)
ffffffff8130052b <btrfs_tree_read_lock+0x3b> nopl   0x0(%rax,%rax,1)
ffffffff81300530 <btrfs_tree_read_lock+0x40> mov    (%rbx),%eax
ffffffff81300532 <btrfs_tree_read_lock+0x42> test   %eax,%eax
ffffffff81300534 <btrfs_tree_read_lock+0x44> je     ffffffff8130057e <btrfs=
_tree_read_lock+0x8e>
ffffffff81300536 <btrfs_tree_read_lock+0x46> mov    -0x68(%rbp),%rax
ffffffff8130053a <btrfs_tree_read_lock+0x4a> movq   $0x0,-0x60(%rbp)
ffffffff81300542 <btrfs_tree_read_lock+0x52> movq   $0xffffffff8105d950,-0x=
50(%rbp)
ffffffff8130054a <btrfs_tree_read_lock+0x5a> mov    %r15,-0x48(%rbp)
ffffffff8130054e <btrfs_tree_read_lock+0x5e> mov    %r15,-0x40(%rbp)
ffffffff81300552 <btrfs_tree_read_lock+0x62> mov    %rax,-0x58(%rbp)
ffffffff81300556 <btrfs_tree_read_lock+0x66> jmp    ffffffff8130055d <btrfs=
_tree_read_lock+0x6d>
ffffffff81300558 <btrfs_tree_read_lock+0x68> callq  ffffffff815f4670 <sched=
ule>
ffffffff8130055d <btrfs_tree_read_lock+0x6d> mov    $0x2,%edx
ffffffff81300562 <btrfs_tree_read_lock+0x72> mov    %r12,%rsi
ffffffff81300565 <btrfs_tree_read_lock+0x75> mov    %r13,%rdi
ffffffff81300568 <btrfs_tree_read_lock+0x78> callq  ffffffff8105db90 <prepa=
re_to_wait>
ffffffff8130056d <btrfs_tree_read_lock+0x7d> mov    (%rbx),%eax
ffffffff8130056f <btrfs_tree_read_lock+0x7f> test   %eax,%eax
ffffffff81300571 <btrfs_tree_read_lock+0x81> jne    ffffffff81300558 <btrfs=
_tree_read_lock+0x68>
ffffffff81300573 <btrfs_tree_read_lock+0x83> mov    %r12,%rsi
ffffffff81300576 <btrfs_tree_read_lock+0x86> mov    %r13,%rdi
ffffffff81300579 <btrfs_tree_read_lock+0x89> callq  ffffffff8105da80 <finis=
h_wait>
ffffffff8130057e <btrfs_tree_read_lock+0x8e> mov    %r14,%rdi
ffffffff81300581 <btrfs_tree_read_lock+0x91> callq  ffffffff815f76d0 <_raw_=
read_lock>
ffffffff81300586 <btrfs_tree_read_lock+0x96> mov    (%rbx),%eax
ffffffff81300588 <btrfs_tree_read_lock+0x98> test   %eax,%eax
ffffffff8130058a <btrfs_tree_read_lock+0x9a> je     ffffffff813005eb <btrfs=
_tree_read_lock+0xfb>
ffffffff8130058c <btrfs_tree_read_lock+0x9c> mov    %r14,%rdi
ffffffff8130058f <btrfs_tree_read_lock+0x9f> callq  ffffffff815f73f0 <_raw_=
read_unlock>
ffffffff81300594 <btrfs_tree_read_lock+0xa4> mov    (%rbx),%eax
ffffffff81300596 <btrfs_tree_read_lock+0xa6> test   %eax,%eax
ffffffff81300598 <btrfs_tree_read_lock+0xa8> je     ffffffff81300530 <btrfs=
_tree_read_lock+0x40>
ffffffff8130059a <btrfs_tree_read_lock+0xaa> mov    -0x78(%rbp),%rax
ffffffff8130059e <btrfs_tree_read_lock+0xae> movq   $0x0,-0x60(%rbp)
ffffffff813005a6 <btrfs_tree_read_lock+0xb6> movq   $0xffffffff8105d950,-0x=
50(%rbp)
ffffffff813005ae <btrfs_tree_read_lock+0xbe> mov    %r15,-0x48(%rbp)
ffffffff813005b2 <btrfs_tree_read_lock+0xc2> mov    %r15,-0x40(%rbp)
ffffffff813005b6 <btrfs_tree_read_lock+0xc6> mov    %rax,-0x58(%rbp)
ffffffff813005ba <btrfs_tree_read_lock+0xca> jmp    ffffffff813005c5 <btrfs=
_tree_read_lock+0xd5>
ffffffff813005bc <btrfs_tree_read_lock+0xcc> nopl   0x0(%rax)
ffffffff813005c0 <btrfs_tree_read_lock+0xd0> callq  ffffffff815f4670 <sched=
ule>
ffffffff813005c5 <btrfs_tree_read_lock+0xd5> mov    $0x2,%edx
ffffffff813005ca <btrfs_tree_read_lock+0xda> mov    %r12,%rsi
ffffffff813005cd <btrfs_tree_read_lock+0xdd> mov    %r13,%rdi
ffffffff813005d0 <btrfs_tree_read_lock+0xe0> callq  ffffffff8105db90 <prepa=
re_to_wait>
ffffffff813005d5 <btrfs_tree_read_lock+0xe5> mov    (%rbx),%eax
ffffffff813005d7 <btrfs_tree_read_lock+0xe7> test   %eax,%eax
ffffffff813005d9 <btrfs_tree_read_lock+0xe9> jne    ffffffff813005c0 <btrfs=
_tree_read_lock+0xd0>
ffffffff813005db <btrfs_tree_read_lock+0xeb> mov    %r12,%rsi
ffffffff813005de <btrfs_tree_read_lock+0xee> mov    %r13,%rdi
ffffffff813005e1 <btrfs_tree_read_lock+0xf1> callq  ffffffff8105da80 <finis=
h_wait>
ffffffff813005e6 <btrfs_tree_read_lock+0xf6> jmpq   ffffffff81300530 <btrfs=
_tree_read_lock+0x40>
ffffffff813005eb <btrfs_tree_read_lock+0xfb> mov    -0x70(%rbp),%rax
ffffffff813005ef <btrfs_tree_read_lock+0xff> lock incl 0x58(%rax)
ffffffff813005f3 <btrfs_tree_read_lock+0x103> lock incl 0x64(%rax)
ffffffff813005f7 <btrfs_tree_read_lock+0x107> add    $0x58,%rsp
ffffffff813005fb <btrfs_tree_read_lock+0x10b> pop    %rbx
ffffffff813005fc <btrfs_tree_read_lock+0x10c> pop    %r12
ffffffff813005fe <btrfs_tree_read_lock+0x10e> pop    %r13
ffffffff81300600 <btrfs_tree_read_lock+0x110> pop    %r14
ffffffff81300602 <btrfs_tree_read_lock+0x112> pop    %r15
ffffffff81300604 <btrfs_tree_read_lock+0x114> leaveq=20
ffffffff81300605 <btrfs_tree_read_lock+0x115> retq  =20
ffffffff81300606 <btrfs_tree_read_lock+0x116> nopw   %cs:0x0(%rax,%rax,1)

=3D=3DThe Second Issue (aka "The Busy Looping sync()" case) =3D=3D

The box is different from first, so conditions are a bit different.

- it's a _patched_ linus's 3.1.0-rc3-00271-g3230739 (+patch from $SUBJ on t=
op)
- /dev/root on / type btrfs (rw,noatime,autodefrag)
  (note autodefrag!)
- 15% full 594GB filesystem (usual nonmixed mode)

How I hung it:
    $ liferea
    <wait it to calm down. it does a lot of SQLite reads/writes>
    $ sync
    Got CPU is 100% loaded

Perfectly reproducible.
I don't remembed it it exits or hangs. Will send detailed followup today.

--=20

  Sergei

--Sig_/DN/bKfCxGIN3tiPHNP=V26G
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk5dOokACgkQcaHudmEf86owfwCfXP2ZuUYDfokWgD7e2ziOyWX3
qksAn1IIXz7KqS6ZKrcsu67rXxxcZgo+
=cL8n
-----END PGP SIGNATURE-----

--Sig_/DN/bKfCxGIN3tiPHNP=V26G--
