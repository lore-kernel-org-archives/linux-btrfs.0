From: Jeff Wu <cpwu@tnsoft.com.cn>
Subject: Re: 2.6.39-rc1: btrfs "WARNING: at fs/btrfs/inode.c:2177"
Date: Fri, 8 Apr 2011 13:53:20 +0800
Message-ID: <1302242000.2014.14.camel@cephhost>
References: <1302169286.1922.19.camel@cephhost>
	 <4D9DE43F.3000809@redhat.com>
Reply-To: <cpwu@tnsoft.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: ceph-devel <ceph-devel@vger.kernel.org>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Josef Bacik <josef@redhat.com>
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <4D9DE43F.3000809@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>


Hi ,
I applied the patch to 2.6.39-rc1,took the following steps to compile
it:make && make modules_install && make install && mkinitramfs=20
but , it seam that it don't run to "WARN_ON(block_rsv =3D=3D
root->orphan_block_rsv);"

i attached the codes and logs at the below:


=2E...........................................
int btrfs_block_rsv_add(struct btrfs_trans_handle *trans,
                        struct btrfs_root *root,
                        struct btrfs_block_rsv *block_rsv,
                        u64 num_bytes)
{
        int ret;

        WARN_ON(block_rsv =3D=3D root->orphan_block_rsv);
        if (num_bytes =3D=3D 0)
                return 0;

        ret =3D reserve_metadata_bytes(trans, root, block_rsv, num_byte=
s,
1);
        if (!ret) {
                block_rsv_add_bytes(block_rsv, num_bytes, 1);
                return 0;
        }

        return ret;
}
=2E.................................................




1.log1

=2E.....................................................
[  147.740003] CE: hpet5 increased min_delta_ns to 7500 nsec
[  147.740012] CE: hpet5 increased min_delta_ns to 11250 nsec
[  148.520005] CE: hpet4 increased min_delta_ns to 7500 nsec
[  148.520012] CE: hpet4 increased min_delta_ns to 11250 nsec
[ 2561.740727] ------------[ cut here ]------------
[ 2561.740746] WARNING: at fs/btrfs/inode.c:2177
btrfs_orphan_commit_root+0xb0/0xc0 [btrfs]()
[ 2561.740748] Hardware name: OptiPlex 780                =20
[ 2561.740750] Modules linked in: i915 btrfs fbcon tileblit font
snd_hda_codec_analog bitblit softcursor drm_kms_helper drm snd_hda_inte=
l
snd_hda_codec snd_hwdep snd_pcm zlib_deflate crc32c snd_timer libcrc32c
snd psmouse i2c_algo_bit ppdev intel_agp parport_pc soundcore lp
intel_gtt snd_page_alloc video dell_wmi parport serio_raw sparse_keymap
r8169 mii ata_piix
[ 2561.740781] Pid: 570, comm: btrfs-transacti Not tainted 2.6.39-rc1 #=
2
[ 2561.740783] Call Trace:
[ 2561.740789]  [<ffffffff8105fe9f>] warn_slowpath_common+0x7f/0xc0
[ 2561.740793]  [<ffffffff8105fefa>] warn_slowpath_null+0x1a/0x20
[ 2561.740803]  [<ffffffffa01ddc50>] btrfs_orphan_commit_root+0xb0/0xc0
[btrfs]
[ 2561.740813]  [<ffffffffa01d90e9>] commit_fs_roots+0xa9/0x150 [btrfs]
[ 2561.740824]  [<ffffffffa01da03b>] btrfs_commit_transaction
+0x34b/0x750 [btrfs]
[ 2561.740828]  [<ffffffff810837e0>] ? wake_up_bit+0x40/0x40
[ 2561.740838]  [<ffffffffa01d35f3>] transaction_kthread+0x283/0x290
[btrfs]
[ 2561.740848]  [<ffffffffa01d3370>] ? btrfs_bio_wq_end_io+0x90/0x90
[btrfs]
[ 2561.740851]  [<ffffffff81083276>] kthread+0xb6/0xc0
[ 2561.740854]  [<ffffffff81099dad>] ? trace_hardirqs_on_caller
+0x13d/0x180
[ 2561.740859]  [<ffffffff815b5ea4>] kernel_thread_helper+0x4/0x10
[ 2561.740862]  [<ffffffff815acf14>] ? retint_restore_args+0x13/0x13
[ 2561.740865]  [<ffffffff810831c0>] ? __init_kthread_worker+0x70/0x70
[ 2561.740868]  [<ffffffff815b5ea0>] ? gs_change+0x13/0x13
[ 2561.740870] ---[ end trace c68c126da4200e73 ]---
[ 2655.461017]=20
[ 2655.461019] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
[ 2655.467908] [ INFO: possible recursive locking detected ]
[ 2655.470882] 2.6.39-rc1 #2
[ 2655.470882] ---------------------------------------------
[ 2655.470882] cosd/2420 is trying to acquire lock:
[ 2655.470882]  (&(&eb->lock)->rlock){+.+...}, at: [<ffffffffa020d5f9>]
btrfs_try_spin_lock+0x59/0x100 [btrfs]
[ 2655.470882]=20
[ 2655.470882] but task is already holding lock:
[ 2655.470882]  (&(&eb->lock)->rlock){+.+...}, at: [<ffffffffa020d6c2>]
btrfs_clear_lock_blocking+0x22/0x30 [btrfs]
[ 2655.470882]=20
[ 2655.470882] other info that might help us debug this:
[ 2655.470882] 2 locks held by cosd/2420:
[ 2655.470882]  #0:  (&sb->s_type->i_mutex_key#13){+.+.+.}, at:
[<ffffffff811694e5>] do_last+0x2f5/0x8a0
[ 2655.470882]  #1:  (&(&eb->lock)->rlock){+.+...}, at:
[<ffffffffa020d6c2>] btrfs_clear_lock_blocking+0x22/0x30 [btrfs]
[ 2655.470882]=20
[ 2655.470882] stack backtrace:
[ 2655.470882] Pid: 2420, comm: cosd Tainted: G        W   2.6.39-rc1 #=
2
[ 2655.470882] Call Trace:
[ 2655.470882]  [<ffffffff8109b224>] __lock_acquire+0x1154/0x14b0
[ 2655.470882]  [<ffffffff8109b620>] lock_acquire+0xa0/0x150
[ 2655.470882]  [<ffffffffa020d5f9>] ? btrfs_try_spin_lock+0x59/0x100
[btrfs]
[ 2655.470882]  [<ffffffff815ac341>] _raw_spin_lock+0x31/0x40
[ 2655.470882]  [<ffffffffa020d5f9>] ? btrfs_try_spin_lock+0x59/0x100
[btrfs]
[ 2655.470882]  [<ffffffffa020d6c2>] ? btrfs_clear_lock_blocking
+0x22/0x30 [btrfs]
[ 2655.470882]  [<ffffffffa020d5f9>] btrfs_try_spin_lock+0x59/0x100
[btrfs]
[ 2655.470882]  [<ffffffffa01bee72>] btrfs_search_slot+0x7d2/0x850
[btrfs]
[ 2655.470882]  [<ffffffffa01cfa02>] btrfs_lookup_dir_item+0x82/0x110
[btrfs]
[ 2655.470882]  [<ffffffff8114e525>] ? kmem_cache_alloc+0xe5/0x140
[ 2655.470882]  [<ffffffffa01e2b81>] btrfs_lookup_dentry+0xa1/0x4b0
[btrfs]
[ 2655.470882]  [<ffffffff81171911>] ? d_alloc+0x141/0x1e0
[ 2655.470882]  [<ffffffff81099dfd>] ? trace_hardirqs_on+0xd/0x10
[ 2655.470882]  [<ffffffff812e63ee>] ? do_raw_spin_unlock+0x5e/0xb0
[ 2655.470882]  [<ffffffffa01e2fa6>] btrfs_lookup+0x16/0x30 [btrfs]
[ 2655.470882]  [<ffffffff81166ba5>] d_alloc_and_lookup+0x45/0x90
[ 2655.470882]  [<ffffffff81172195>] ? d_lookup+0x35/0x60
[ 2655.470882]  [<ffffffff81166cce>] __lookup_hash+0xde/0x180
[ 2655.470882]  [<ffffffff811694f5>] do_last+0x305/0x8a0
[ 2655.470882]  [<ffffffff8116a9fd>] path_openat+0xcd/0x3f0
[ 2655.470882]  [<ffffffff8116ae6f>] do_filp_open+0x7f/0xa0
[ 2655.470882]  [<ffffffff815acb9b>] ? _raw_spin_unlock+0x2b/0x40
[ 2655.470882]  [<ffffffff81178e4a>] ? alloc_fd+0xfa/0x140
[ 2655.470882]  [<ffffffff8115b684>] do_sys_open+0x104/0x1e0
[ 2655.470882]  [<ffffffff8115b7a0>] sys_open+0x20/0x30
[ 2655.470882]  [<ffffffff815b4d02>] system_call_fastpath+0x16/0x1b

2.log2

=2E..............................................................

[  156.240012] CE: hpet2 increased min_delta_ns to 11250 nsec
[  167.490003] CE: hpet4 increased min_delta_ns to 7500 nsec
[  167.490010] CE: hpet4 increased min_delta_ns to 11250 nsec
[ 2601.060330] ------------[ cut here ]------------
[ 2601.060347] WARNING: at fs/btrfs/inode.c:2177
btrfs_orphan_commit_root+0xb0/0xc0 [btrfs]()
[ 2601.060349] Hardware name: OptiPlex 780                =20
[ 2601.060350] Modules linked in: btrfs zlib_deflate crc32c libcrc32c
i915 snd_hda_codec_analog fbcon tileblit font bitblit softcursor
drm_kms_helper drm snd_hda_intel snd_hda_codec snd_hwdep snd_pcm
snd_timer snd soundcore psmouse i2c_algo_bit snd_page_alloc lp intel_ag=
p
ppdev video intel_gtt parport_pc dell_wmi parport serio_raw
sparse_keymap dcdbas r8169 mii
[ 2601.060435] Pid: 586, comm: btrfs-transacti Not tainted 2.6.39-rc1 #=
2
[ 2601.060436] Call Trace:
[ 2601.060443]  [<ffffffff8105f13f>] warn_slowpath_common+0x7f/0xc0
[ 2601.060446]  [<ffffffff8105f19a>] warn_slowpath_null+0x1a/0x20
[ 2601.060456]  [<ffffffffa024cb20>] btrfs_orphan_commit_root+0xb0/0xc0
[btrfs]
[ 2601.060466]  [<ffffffffa0248011>] commit_fs_roots+0xa1/0x140 [btrfs]
[ 2601.060476]  [<ffffffffa0248f39>] btrfs_commit_transaction
+0x349/0x750 [btrfs]
[ 2601.060480]  [<ffffffff81081810>] ? wake_up_bit+0x40/0x40
[ 2601.060489]  [<ffffffffa02425d3>] transaction_kthread+0x283/0x290
[btrfs]
[ 2601.060499]  [<ffffffffa0242350>] ? btrfs_bio_wq_end_io+0x90/0x90
[btrfs]
[ 2601.060508]  [<ffffffffa0242350>] ? btrfs_bio_wq_end_io+0x90/0x90
[btrfs]
[ 2601.060511]  [<ffffffff810812d6>] kthread+0x96/0xa0
[ 2601.060514]  [<ffffffff815a6364>] kernel_thread_helper+0x4/0x10
[ 2601.060517]  [<ffffffff81081240>] ? __init_kthread_worker+0x40/0x40
[ 2601.060519]  [<ffffffff815a6360>] ? gs_change+0x13/0x13
[ 2601.060521] ---[ end trace 4b0b0e47058a9a99 ]---











=E5=9C=A8 2011-04-08=E4=BA=94=E7=9A=84 00:20 +0800=EF=BC=8CJosef Bacik=E5=
=86=99=E9=81=93=EF=BC=9A
> On 04/07/2011 05:41 AM, Jeff Wu wrote:
> > Hi ,
> > I run iozone stress test on a ceph client for x86_64, ceph 0.26 +
> > linux-2.6.39-rc1 server,
> > printk "WARNING: at fs/btrfs/inode.c:2177"
> >
> Crap I was hoping I had fixed this, could you run with this debug pat=
ch=20
> and get me the output so I can figure out what's going on?  Thanks,
>=20
> Josef
>=20
>=20

--
To unsubscribe from this list: send the line "unsubscribe ceph-devel" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
