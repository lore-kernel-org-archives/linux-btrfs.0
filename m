Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:58349 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbaCIQn1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Mar 2014 12:43:27 -0400
Date: Sun, 9 Mar 2014 16:43:21 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Josef Bacik <jbacik@fb.com>,
        Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: send/receive locking
Message-ID: <20140309164321.GI6318@carfax.org.uk>
References: <20140308215350.GE6318@carfax.org.uk>
 <usnory0eq5h626p5eaeeh4ki.1394315749442@email.android.com>
 <20140308220027.GF6318@carfax.org.uk>
 <gm5l2kqc332h7w6arx688tf2.1394316159256@email.android.com>
 <20140308221652.GG6318@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Li7ckgedzMh1NgdW"
In-Reply-To: <20140308221652.GG6318@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Li7ckgedzMh1NgdW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 08, 2014 at 10:16:52PM +0000, Hugo Mills wrote:
> On Sat, Mar 08, 2014 at 10:02:39PM +0000, Josef Bacik wrote:
> > Don't do it on a fs you care about, cow is broken with that branch so i=
t will corrupt your fs.  So actually just find Wang's patch that sets skip =
locking for send and do that.  Thanks,
>=20
>    Aah, that's good to know. It's not an FS I care about massively
> much, but it'd be a pain to recreate all the setup. I think I'll go
> cherry picking tomorrow morning. :)

   OK, I'm running with btrfs-next, plus a cherry picked

    Btrfs: skip locking when searching commit root

=66rom Wang on top of that. It's just locked up again in exactly the
same way. Twice. The first time I forgot to capture a SysRq-w before I
killed the script. The second time, I got the SysRq-w, which is
appended below. I've also got a couple of "task blocked for more than
120 seconds" traces in the syslog from the earlier run, if those are
helpful.

   Hugo.

Mar  9 16:34:58 s_src@amelia kernel: SysRq : Show Blocked State
Mar  9 16:34:58 s_src@amelia kernel:   task                        PC stack=
   pid father
Mar  9 16:34:58 s_src@amelia kernel: btrfs-transacti D ffff88003dc92640    =
 0   224      2 0x00000000
Mar  9 16:34:58 s_src@amelia kernel:  ffff88003ac46d00 0000000000000046 000=
0000000012640 ffff88003ac46d00
Mar  9 16:34:58 s_src@amelia kernel:  ffff88003ad75fd8 ffff88003c093d50 fff=
f88003b19d000 ffff880008b11f00
Mar  9 16:34:58 s_src@amelia kernel:  ffff88003a4dc6e8 ffff88003a4dc690 000=
0000000000000 0000000000000000
Mar  9 16:34:58 s_src@amelia kernel: Call Trace:
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff81158404>] ? btrfs_commit_t=
ransaction+0x306/0x808
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff8105ebdc>] ? finish_wait+0x=
60/0x60
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff81154c82>] ? transaction_kt=
hread+0xd5/0x185
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff81154bad>] ? btrfs_cleanup_=
transaction+0x3e3/0x3e3
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff8104cede>] ? kthread+0x9e/0=
xa6
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff81050000>] ? blocking_notif=
ier_chain_cond_register+0x13/0x40
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff8104ce40>] ? __kthread_park=
me+0x55/0x55
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff813a6ebc>] ? ret_from_fork+=
0x7c/0xb0
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff8104ce40>] ? __kthread_park=
me+0x55/0x55
Mar  9 16:34:58 s_src@amelia kernel: syslog-ng       D ffff88003dc12640    =
 0  1995   1994 0x00000000
Mar  9 16:34:58 s_src@amelia kernel:  ffff88003b2fdf60 0000000000000086 000=
0000000012640 ffff88003b2fdf60
Mar  9 16:34:58 s_src@amelia kernel:  ffff880038d1dfd8 ffffffff81811430 fff=
f88003a4dc690 ffff88003b3441e8
Mar  9 16:34:58 s_src@amelia kernel:  0000000000000000 0000000000000000 fff=
f88003b344000 ffff88002969e460
Mar  9 16:34:53 s_src@amelia sudo: Libgcrypt warning: missing initializatio=
n - please fix the application
Mar  9 16:34:58 s_src@amelia kernel: Call Trace:
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff81157a0c>] ? wait_current_t=
rans.isra.19+0xad/0xd1
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff8105ebdc>] ? finish_wait+0x=
60/0x60
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff81158bf2>] ? start_transact=
ion+0x2ec/0x4c5
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff8114e66a>] ? btrfs_lookup_x=
attr+0x68/0x97
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff8115cf27>] ? btrfs_dirty_in=
ode+0x25/0xa1
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff81160a4f>] ? btrfs_setattr+=
0x230/0x267
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff810f39b8>] ? notify_change+=
0x20c/0x2ef
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff810dec32>] ? chown_common.i=
sra.16+0xc9/0x12e
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff810e26a4>] ? __sb_start_wri=
te+0x8e/0xbb
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff810df6ef>] ? SyS_fchown+0x4=
7/0x6d
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff813a6f66>] ? system_call_fa=
stpath+0x1a/0x1f
Mar  9 16:34:58 s_src@amelia kernel: mosquitto       D ffff88003dc92640    =
 0  2093      1 0x00000000
Mar  9 16:34:58 s_src@amelia kernel:  ffff88003a882210 0000000000000082 000=
0000000012640 ffff88003a882210
Mar  9 16:34:58 s_src@amelia kernel:  ffff8800380cbfd8 ffff88003c093d50 fff=
f88003a4dc690 ffff88003b3441e8
Mar  9 16:34:58 s_src@amelia kernel:  0000000000000000 0000000000000000 fff=
f88003b344000 ffff880008b111e0
Mar  9 16:34:58 s_src@amelia kernel: Call Trace:
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff81157a0c>] ? wait_current_t=
rans.isra.19+0xad/0xd1
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff8105ebdc>] ? finish_wait+0x=
60/0x60
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff81158d1a>] ? start_transact=
ion+0x414/0x4c5
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff8113abef>] ? btrfs_release_=
path+0x38/0x53
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff81162897>] ? btrfs_create+0=
x35/0x1c2
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff810e986e>] ? vfs_create+0x4=
6/0x6c
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff810ea425>] ? do_last.isra.5=
8+0x544/0x95e
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff810eaa5b>] ? path_openat+0x=
21c/0x488
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff810ebbdc>] ? do_filp_open+0=
x35/0x7a
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff810f4555>] ? __alloc_fd+0x5=
6/0xda
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff810df880>] ? do_sys_open+0x=
65/0xe9
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff813a6f66>] ? system_call_fa=
stpath+0x1a/0x1f
Mar  9 16:34:58 s_src@amelia kernel: krb5kdc         D ffff88003dc92640    =
 0  2195      1 0x00000000
Mar  9 16:34:58 s_src@amelia kernel:  ffff88003b4d8da0 0000000000000086 000=
0000000012640 ffff88003b4d8da0
Mar  9 16:34:58 s_src@amelia kernel:  ffff880038215fd8 ffff88003c093d50 fff=
f88003a4dc690 ffff88003b3441e8
Mar  9 16:34:58 s_src@amelia kernel:  0000000000000000 0000000000000000 fff=
f88003b344000 ffff880008b11320
Mar  9 16:34:58 s_src@amelia kernel: Call Trace:
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff81157a0c>] ? wait_current_t=
rans.isra.19+0xad/0xd1
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff8105ebdc>] ? finish_wait+0x=
60/0x60
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff81158bf2>] ? start_transact=
ion+0x2ec/0x4c5
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff811159fc>] ? locks_alloc_lo=
ck+0x4e/0x54
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff8115cf27>] ? btrfs_dirty_in=
ode+0x25/0xa1
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff81160a4f>] ? btrfs_setattr+=
0x230/0x267
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff810f39b8>] ? notify_change+=
0x20c/0x2ef
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff811018fe>] ? utimes_common+=
0x119/0x174
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff81101a3e>] ? do_utimes+0xe5=
/0x11c
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff81101ad9>] ? SyS_utime+0x64=
/0x66
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff813a6f66>] ? system_call_fa=
stpath+0x1a/0x1f
Mar  9 16:34:58 s_src@amelia kernel: postgres        D ffff88003dc92640    =
 0  2250   2245 0x00000000
Mar  9 16:34:58 s_src@amelia kernel:  ffff88003b2fb680 0000000000000082 000=
0000000012640 ffff88003b2fb680
Mar  9 16:34:58 s_src@amelia kernel:  ffff880034533fd8 ffff88003c093d50 fff=
f88003dc92640 ffff88003b2fb680
Mar  9 16:34:58 s_src@amelia kernel:  ffff880034533c40 0000000000000002 000=
0000000000000 ffffffff810acdc1
Mar  9 16:34:58 s_src@amelia kernel: Call Trace:
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff810acdc1>] ? wait_on_page_r=
ead+0x32/0x32
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff813a46ba>] ? io_schedule+0x=
54/0x69
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff810acdc6>] ? sleep_on_page+=
0x5/0x8
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff813a496c>] ? __wait_on_bit_=
lock+0x3c/0x7f
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff810ace6b>] ? __lock_page+0x=
64/0x66
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff8105ec06>] ? autoremove_wak=
e_function+0x2a/0x2a
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff810ad615>] ? lock_page+0x9/=
0x18
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff810ad668>] ? find_lock_page=
+0x29/0x49
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff810ad9c4>] ? find_or_create=
_page+0x28/0x85
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff81165652>] ? prepare_pages.=
isra.18+0x7d/0x120
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff81165f16>] ? __btrfs_buffer=
ed_write+0x1ef/0x43c
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff8116651a>] ? btrfs_file_aio=
_write+0x3b7/0x47b
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff810c573e>] ? tlb_flush_mmu+=
0x4e/0x64
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff810dfb6d>] ? do_sync_write+=
0x56/0x76
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff810e0157>] ? vfs_write+0x9f=
/0x102
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff810e0868>] ? SyS_write+0x41=
/0x74
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff813a6f66>] ? system_call_fa=
stpath+0x1a/0x1f
Mar  9 16:34:58 s_src@amelia kernel: postgres        D ffff88003dc92640    =
 0  2251   2245 0x00000000
Mar  9 16:34:58 s_src@amelia kernel:  ffff88003b2ff3d0 0000000000000086 000=
0000000012640 ffff88003b2ff3d0
Mar  9 16:34:58 s_src@amelia kernel:  ffff88003455bfd8 ffff88003c093d50 fff=
f88003a4dc690 ffff88003b3441e8
Mar  9 16:34:58 s_src@amelia kernel:  0000000000000000 0000000000000000 fff=
f88003b344000 ffff880008b11aa0
Mar  9 16:34:58 s_src@amelia kernel: Call Trace:
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff81157a0c>] ? wait_current_t=
rans.isra.19+0xad/0xd1
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff8105ebdc>] ? finish_wait+0x=
60/0x60
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff81158d1a>] ? start_transact=
ion+0x414/0x4c5
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff81162897>] ? btrfs_create+0=
x35/0x1c2
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff810e986e>] ? vfs_create+0x4=
6/0x6c
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff810ea425>] ? do_last.isra.5=
8+0x544/0x95e
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff810eaa5b>] ? path_openat+0x=
21c/0x488
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff810e67b2>] ? pipe_read+0x31=
e/0x383
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff810ebbdc>] ? do_filp_open+0=
x35/0x7a
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff810f4555>] ? __alloc_fd+0x5=
6/0xda
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff810df880>] ? do_sys_open+0x=
65/0xe9
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff813a6f66>] ? system_call_fa=
stpath+0x1a/0x1f
Mar  9 16:34:58 s_src@amelia kernel: btrfs-endio-wri D ffff88003dc92640    =
 0  5436      2 0x00000000
Mar  9 16:34:58 s_src@amelia kernel:  ffff8800381906d0 0000000000000046 000=
0000000012640 ffff8800381906d0
Mar  9 16:34:58 s_src@amelia kernel:  ffff88002dd81fd8 ffff88003c093d50 fff=
f88003a4dc690 ffff88003b3441e8
Mar  9 16:34:58 s_src@amelia kernel:  0000000000000000 0000000000000000 fff=
f88003b344000 ffff880008b11dc0
Mar  9 16:34:58 s_src@amelia kernel: Call Trace:
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff81157a0c>] ? wait_current_t=
rans.isra.19+0xad/0xd1
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff8105ebdc>] ? finish_wait+0x=
60/0x60
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff81158bf2>] ? start_transact=
ion+0x2ec/0x4c5
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff8115f0a1>] ? btrfs_finish_o=
rdered_io+0x19b/0x3c2
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff8103d700>] ? ftrace_raw_out=
put_itimer_state+0x3d/0x60
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff8117ba9d>] ? worker_loop+0x=
149/0x4a7
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff813a4338>] ? __schedule+0x3=
52/0x4f0
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff8117b954>] ? btrfs_queue_wo=
rker+0x269/0x269
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff8104cede>] ? kthread+0x9e/0=
xa6
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff8104ce40>] ? __kthread_park=
me+0x55/0x55
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff813a6ebc>] ? ret_from_fork+=
0x7c/0xb0
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff8104ce40>] ? __kthread_park=
me+0x55/0x55
Mar  9 16:34:58 s_src@amelia kernel: carfax-backup   D ffff8800223cc420    =
 0  5486   4964 0x00000000
Mar  9 16:34:58 s_src@amelia kernel:  ffff8800223cc420 0000000000000082 000=
0000000012640 ffff8800223cc420
Mar  9 16:34:58 s_src@amelia kernel:  ffff880020dfffd8 ffff880031cdb680 fff=
f88003a6acbc8 ffff8800273d2c10
Mar  9 16:34:58 s_src@amelia kernel:  ffff88003a6acbe4 000000000002e000 fff=
f880020dffc90 000000000002efff
Mar  9 16:34:58 s_src@amelia kernel: Call Trace:
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff8116e069>] ? lock_extent_bi=
ts+0x108/0x180
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff8105ebdc>] ? finish_wait+0x=
60/0x60
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff81164bc4>] ? lock_and_clean=
up_extent_if_need+0x66/0x191
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff81165f44>] ? __btrfs_buffer=
ed_write+0x21d/0x43c
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff8116651a>] ? btrfs_file_aio=
_write+0x3b7/0x47b
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff810eb952>] ? user_path_at_e=
mpty+0x60/0x87
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff8108af43>] ? from_kgid_mung=
ed+0x9/0x14
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff810dfb6d>] ? do_sync_write+=
0x56/0x76
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff810e0157>] ? vfs_write+0x9f=
/0x102
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff810e0868>] ? SyS_write+0x41=
/0x74
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff813a6f66>] ? system_call_fa=
stpath+0x1a/0x1f
Mar  9 16:34:58 s_src@amelia kernel: kworker/u8:1    D ffff88003dc12640    =
 0  6881      2 0x00000000
Mar  9 16:34:58 s_src@amelia kernel: Workqueue: writeback bdi_writeback_wor=
kfn (flush-btrfs-1)
Mar  9 16:34:58 s_src@amelia kernel:  ffff88003b9cdf60 0000000000000046 000=
0000000012640 ffff88003b9cdf60
Mar  9 16:34:58 s_src@amelia kernel:  ffff880031909fd8 ffffffff81811430 fff=
f88003a4dc690 ffff88003b3441e8
Mar  9 16:34:58 s_src@amelia kernel:  0000000000000000 0000000000000000 fff=
f88003b344000 ffff88002969edc0
Mar  9 16:34:58 s_src@amelia kernel: Call Trace:
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff81157a0c>] ? wait_current_t=
rans.isra.19+0xad/0xd1
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff8105ebdc>] ? finish_wait+0x=
60/0x60
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff81158bf2>] ? start_transact=
ion+0x2ec/0x4c5
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff8115d361>] ? cow_file_range=
_inline+0xe9/0x281
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff810dbf07>] ? kmem_cache_fre=
e+0x32/0xb9
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff8116d73e>] ? __set_extent_b=
it+0x3c3/0x3ff
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff8115d5c7>] ? cow_file_range=
+0xce/0x37d
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff8115dfe8>] ? run_delalloc_r=
ange+0x9a/0x2c7
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff8116cfd3>] ? free_extent_st=
ate+0x12/0x21
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff8116ffb3>] ? __extent_write=
page+0x1cc/0x5f4
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff81055320>] ? check_preempt_=
curr+0x27/0x62
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff8105536a>] ? ttwu_do_wakeup=
+0xf/0xb0
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff810ad5bf>] ? find_get_pages=
_tag+0xe3/0x11c
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff8117059f>] ? extent_write_c=
ache_pages.isra.24.constprop.44+0x1c4/0x25a
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff8105b724>] ? update_group_p=
ower+0xb9/0x1f1
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff811ea9c3>] ? cpumask_next_a=
nd+0x1a/0x36
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff8105b94c>] ? find_busiest_g=
roup+0xf0/0x4d2
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff811708c8>] ? extent_writepa=
ges+0x49/0x60
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff8115bcdf>] ? btrfs_submit_d=
irect+0x3f5/0x3f5
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff810fd953>] ? __writeback_si=
ngle_inode+0x4b/0x1c2
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff810fe1b9>] ? writeback_sb_i=
nodes+0x1d3/0x314
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff810fe365>] ? __writeback_in=
odes_wb+0x6b/0xa1
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff810fe4ac>] ? wb_writeback+0=
x111/0x273
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff810f191e>] ? get_nr_inodes_=
unused+0x24/0x4b
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff810fea5b>] ? bdi_writeback_=
workfn+0x16a/0x316
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff81048729>] ? process_one_wo=
rk+0x179/0x28c
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff81048be7>] ? worker_thread+=
0x139/0x1de
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff81048aae>] ? rescuer_thread=
+0x24f/0x24f
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff8104cede>] ? kthread+0x9e/0=
xa6
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff81050000>] ? blocking_notif=
ier_chain_cond_register+0x13/0x40
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff8104ce40>] ? __kthread_park=
me+0x55/0x55
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff813a6ebc>] ? ret_from_fork+=
0x7c/0xb0
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff8104ce40>] ? __kthread_park=
me+0x55/0x55
Mar  9 16:34:58 s_src@amelia kernel: sudo            D ffff88003dc12640    =
 0  6899   5354 0x00000000
Mar  9 16:34:58 s_src@amelia kernel:  ffff88003b9cd1c0 0000000000000086 000=
0000000012640 ffff88003b9cd1c0
Mar  9 16:34:58 s_src@amelia kernel:  ffff88001d7e3fd8 ffffffff81811430 fff=
f88003a4dc690 ffff88003b3441e8
Mar  9 16:34:58 s_src@amelia kernel:  0000000000000000 0000000000000000 fff=
f88003b344000 ffff88002969ebe0
Mar  9 16:34:58 s_src@amelia kernel: Call Trace:
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff81157a0c>] ? wait_current_t=
rans.isra.19+0xad/0xd1
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff8105ebdc>] ? finish_wait+0x=
60/0x60
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff81158d1a>] ? start_transact=
ion+0x414/0x4c5
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff811652f7>] ? btrfs_sync_fil=
e+0x16a/0x250
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff811015b8>] ? do_fsync+0x2b/=
0x50
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff811017cd>] ? SyS_fdatasync+=
0xa/0xd
Mar  9 16:34:58 s_src@amelia kernel:  [<ffffffff813a6f66>] ? system_call_fa=
stpath+0x1a/0x1f
Mar  9 16:34:58 s_src@amelia kernel: Sched Debug Version: v0.11, 3.13.0-001=
89-g56a5aaf-dirty #6
Mar  9 16:34:58 s_src@amelia kernel: ktime                                 =
  : 5633983.834345
Mar  9 16:34:58 s_src@amelia kernel: sched_clk                             =
  : 5634341.491684
Mar  9 16:34:58 s_src@amelia kernel: cpu_clk                               =
  : 5634341.491817
Mar  9 16:34:58 s_src@amelia kernel: jiffies                               =
  : 4295500694
Mar  9 16:34:58 s_src@amelia kernel: sched_clock_stable                    =
  : 1
Mar  9 16:34:58 s_src@amelia kernel:=20
Mar  9 16:34:58 s_src@amelia kernel: sysctl_sched
Mar  9 16:34:58 s_src@amelia kernel:   .sysctl_sched_latency               =
     : 12.000000
Mar  9 16:34:58 s_src@amelia kernel:   .sysctl_sched_min_granularity       =
     : 1.500000
Mar  9 16:34:58 s_src@amelia kernel:   .sysctl_sched_wakeup_granularity    =
     : 2.000000
Mar  9 16:34:58 s_src@amelia kernel:   .sysctl_sched_child_runs_first      =
     : 0
Mar  9 16:34:58 s_src@amelia kernel:   .sysctl_sched_features              =
     : 11899
Mar  9 16:34:58 s_src@amelia kernel:   .sysctl_sched_tunable_scaling       =
     : 1 (logaritmic)
Mar  9 16:34:58 s_src@amelia kernel:=20
Mar  9 16:34:58 s_src@amelia kernel: cpu#0, 1297.893 MHz
Mar  9 16:34:58 s_src@amelia kernel:   .nr_running                    : 2
Mar  9 16:34:58 s_src@amelia kernel:   .load                          : 2048
Mar  9 16:34:58 s_src@amelia kernel:   .nr_switches                   : 428=
9270
Mar  9 16:34:58 s_src@amelia kernel:   .nr_load_updates               : 307=
219
Mar  9 16:34:58 s_src@amelia kernel:   .nr_uninterruptible            : 125=
12
Mar  9 16:34:58 s_src@amelia kernel:   .next_balance                  : 429=
5.500693
Mar  9 16:34:58 s_src@amelia kernel:   .curr->pid                     : 6909
Mar  9 16:34:58 s_src@amelia kernel:   .clock                         : 563=
4339.618360
Mar  9 16:34:58 s_src@amelia kernel:   .cpu_load[0]                   : 0
Mar  9 16:34:58 s_src@amelia kernel:   .cpu_load[1]                   : 0
Mar  9 16:34:58 s_src@amelia kernel:   .cpu_load[2]                   : 0
Mar  9 16:34:58 s_src@amelia kernel:   .cpu_load[3]                   : 0
Mar  9 16:34:58 s_src@amelia kernel:   .cpu_load[4]                   : 0
Mar  9 16:34:58 s_src@amelia kernel: \x0acfs_rq[0]:/autogroup-55
Mar  9 16:34:58 s_src@amelia kernel:   .exec_clock                    : 0.0=
00000
Mar  9 16:34:58 s_src@amelia kernel:   .MIN_vruntime                  : 0.0=
00001
Mar  9 16:34:58 s_src@amelia kernel:   .min_vruntime                  : 715=
=2E021351
Mar  9 16:34:58 s_src@amelia kernel:   .max_vruntime                  : 0.0=
00001
Mar  9 16:34:58 s_src@amelia kernel:   .spread                        : 0.0=
00000
Mar  9 16:34:58 s_src@amelia kernel:   .spread0                       : -37=
9893.663525
Mar  9 16:34:58 s_src@amelia kernel:   .nr_spread_over                : 0
Mar  9 16:34:58 s_src@amelia kernel:   .nr_running                    : 1
Mar  9 16:34:58 s_src@amelia kernel:   .load                          : 1024
Mar  9 16:34:58 s_src@amelia kernel:   .runnable_load_avg             : 0
Mar  9 16:34:58 s_src@amelia kernel:   .blocked_load_avg              : 0
Mar  9 16:34:58 s_src@amelia kernel:   .tg_load_contrib               : 0
Mar  9 16:34:58 s_src@amelia kernel:   .tg_runnable_contrib           : 0
Mar  9 16:34:58 s_src@amelia kernel:   .tg_load_avg                   : 0
Mar  9 16:34:58 s_src@amelia kernel:   .tg->runnable_avg              : 0
Mar  9 16:34:58 s_src@amelia kernel:   .se->exec_start                : 563=
4339.618360
Mar  9 16:34:58 s_src@amelia kernel:   .se->vruntime                  : 380=
604.574667
Mar  9 16:34:58 s_src@amelia kernel:   .se->sum_exec_runtime          : 448=
=2E443805
Mar  9 16:34:58 s_src@amelia kernel:   .se->load.weight               : 1024
Mar  9 16:34:58 s_src@amelia kernel:   .se->avg.runnable_avg_sum      : 0
Mar  9 16:34:58 s_src@amelia kernel:   .se->avg.runnable_avg_period   : 468=
18
Mar  9 16:34:58 s_src@amelia kernel:   .se->avg.load_avg_contrib      : 0
Mar  9 16:34:58 s_src@amelia kernel:   .se->avg.decay_count           : 0
Mar  9 16:34:58 s_src@amelia kernel: \x0acfs_rq[0]:/
Mar  9 16:34:58 s_src@amelia kernel:   .exec_clock                    : 0.0=
00000
Mar  9 16:34:58 s_src@amelia kernel:   .MIN_vruntime                  : 380=
603.194337
Mar  9 16:34:58 s_src@amelia kernel:   .min_vruntime                  : 380=
608.684876
Mar  9 16:34:58 s_src@amelia kernel:   .max_vruntime                  : 380=
603.194337
Mar  9 16:34:58 s_src@amelia kernel:   .spread                        : 0.0=
00000
Mar  9 16:34:58 s_src@amelia kernel:   .spread0                       : 0.0=
00000
Mar  9 16:34:58 s_src@amelia kernel:   .nr_spread_over                : 0
Mar  9 16:34:58 s_src@amelia kernel:   .nr_running                    : 2
Mar  9 16:34:58 s_src@amelia kernel:   .load                          : 2048
Mar  9 16:34:58 s_src@amelia kernel:   .runnable_load_avg             : 0
Mar  9 16:34:58 s_src@amelia kernel:   .blocked_load_avg              : 0
Mar  9 16:34:58 s_src@amelia kernel:   .tg_load_contrib               : 0
Mar  9 16:34:58 s_src@amelia kernel:   .tg_runnable_contrib           : 2
Mar  9 16:34:58 s_src@amelia kernel:   .tg_load_avg                   : 4
Mar  9 16:34:58 s_src@amelia kernel:   .tg->runnable_avg              : 6
Mar  9 16:34:58 s_src@amelia kernel:   .avg->runnable_avg_sum         : 97
Mar  9 16:34:58 s_src@amelia kernel:   .avg->runnable_avg_period      : 467=
83
Mar  9 16:34:58 s_src@amelia kernel: \x0art_rq[0]:
Mar  9 16:34:58 s_src@amelia kernel:   .rt_nr_running                 : 0
Mar  9 16:34:58 s_src@amelia kernel:   .rt_throttled                  : 0
Mar  9 16:34:58 s_src@amelia kernel:   .rt_time                       : 0.0=
00000
Mar  9 16:34:58 s_src@amelia kernel:   .rt_runtime                    : 950=
=2E000000
Mar  9 16:34:58 s_src@amelia kernel: \x0arunnable tasks:\x0a            tas=
k   PID         tree-key  switches  prio     exec-runtime         sum-exec =
       sum-sleep\x0a-------------------------------------------------------=
---------------------------------------------------
Mar  9 16:34:58 s_src@amelia kernel:         kthreadd     2    380039.82703=
6       280   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:      ksoftirqd/0     3    380602.69974=
7     63098   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:     kworker/0:0H     5       256.52940=
4         3   100               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:           rcu_bh     8     20085.38268=
6        12   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:      migration/0     9         0.00000=
0      1523     0               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:        kdevtmpfs    15     87065.78937=
2       157   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:            netns    16       262.52410=
8         2   100               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:        writeback    17       262.52921=
7         2   100               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:       devfreq_wq    23       791.13600=
3         2   100               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:       khungtaskd    27    380120.83146=
9        48   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:        scsi_eh_0    48       903.71912=
5        17   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:        scsi_eh_1    49       897.79118=
2        18   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:        scsi_eh_2    50       897.78591=
9        18   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:        scsi_eh_3    51       903.74840=
6        20   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:           bioset    60       925.38122=
1         2   100               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:   btrfs-worker-1   206    380122.51307=
2       956   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:  btrfs-genwork-1   207    380171.32645=
5       112   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:    btrfs-fixup-1   210    380123.09207=
8        78   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:    btrfs-cache-1   219    380123.11429=
0        81   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:    btrfs-cleaner   223    373144.93401=
9       186   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:      edac-poller   489      2677.69494=
9         2   100               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:          rpcbind  1690         4.31872=
3       290   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-5
Mar  9 16:34:58 s_src@amelia kernel:        rpc.statd  1718        13.24236=
7         9   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-6
Mar  9 16:34:58 s_src@amelia kernel:           rpciod  1723      6264.80488=
4         2   100               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:         rpc.gssd  1739         0.08945=
5         1   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-8
Mar  9 16:34:58 s_src@amelia kernel:        syslog-ng  1995       134.91032=
3       443   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-12
Mar  9 16:34:58 s_src@amelia kernel:            named  2076         3.00695=
3         1   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-15
Mar  9 16:34:58 s_src@amelia kernel:            named  2080       209.94088=
8      1234   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-15
Mar  9 16:34:58 s_src@amelia kernel:            named  2081       202.58690=
9       641   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-15
Mar  9 16:34:58 s_src@amelia kernel:            named  2082       204.84755=
6       960   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-15
Mar  9 16:34:58 s_src@amelia kernel:            inetd  2155         0.91164=
9         1   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-17
Mar  9 16:34:58 s_src@amelia kernel:          apache2  2310       126.88668=
4         1   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-32
Mar  9 16:34:58 s_src@amelia kernel:          apache2  2311       126.86756=
1         1   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-32
Mar  9 16:34:58 s_src@amelia kernel:          apache2  2312       132.88625=
7         1   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-32
Mar  9 16:34:58 s_src@amelia kernel:          apache2  2313       132.87581=
5         1   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-32
Mar  9 16:34:58 s_src@amelia kernel:          apache2  2314       132.87569=
3         1   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-32
Mar  9 16:34:58 s_src@amelia kernel:          apache2  2315       132.89418=
0         1   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-32
Mar  9 16:34:58 s_src@amelia kernel:          apache2  2317       132.94915=
4         1   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-32
Mar  9 16:34:58 s_src@amelia kernel:          apache2  2319       132.99778=
3         1   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-32
Mar  9 16:34:58 s_src@amelia kernel:          apache2  2321       133.04922=
8         1   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-32
Mar  9 16:34:58 s_src@amelia kernel:          apache2  2323       133.09322=
3         1   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-32
Mar  9 16:34:58 s_src@amelia kernel:          apache2  2325       133.14341=
9         1   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-32
Mar  9 16:34:58 s_src@amelia kernel:          apache2  2327       133.19195=
2         1   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-32
Mar  9 16:34:58 s_src@amelia kernel:          apache2  2329       133.23468=
9         1   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-32
Mar  9 16:34:58 s_src@amelia kernel:          apache2  2331       133.28371=
7         1   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-32
Mar  9 16:34:58 s_src@amelia kernel:          apache2  2333       133.33586=
1         1   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-32
Mar  9 16:34:58 s_src@amelia kernel:          apache2  2335       133.37553=
8         1   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-32
Mar  9 16:34:58 s_src@amelia kernel:          apache2  2342       134.33774=
0         1   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-32
Mar  9 16:34:58 s_src@amelia kernel:          apache2  2344       133.87571=
7         1   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-32
Mar  9 16:34:58 s_src@amelia kernel:          apache2  2346       133.76418=
8         1   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-32
Mar  9 16:34:58 s_src@amelia kernel:          apache2  2348       133.74164=
0         1   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-32
Mar  9 16:34:58 s_src@amelia kernel:          apache2  2350       133.72891=
7         1   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-32
Mar  9 16:34:58 s_src@amelia kernel:          apache2  2352       133.53132=
9         1   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-32
Mar  9 16:34:58 s_src@amelia kernel:          apache2  2353       133.53527=
3         1   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-32
Mar  9 16:34:58 s_src@amelia kernel:          apache2  2307       122.84912=
0        73   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-32
Mar  9 16:34:58 s_src@amelia kernel:          apache2  2330       128.77950=
7         1   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-32
Mar  9 16:34:58 s_src@amelia kernel:          apache2  2343       133.84068=
5         1   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-32
Mar  9 16:34:58 s_src@amelia kernel:          apache2  2345       133.72395=
6         1   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-32
Mar  9 16:34:58 s_src@amelia kernel:          apache2  2347       133.74423=
6         1   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-32
Mar  9 16:34:58 s_src@amelia kernel:          apache2  2349       133.73622=
2         1   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-32
Mar  9 16:34:58 s_src@amelia kernel:          apache2  2351       133.53424=
2         1   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-32
Mar  9 16:34:58 s_src@amelia kernel:          apache2  2354       133.52942=
6         1   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-32
Mar  9 16:34:58 s_src@amelia kernel:          apache2  2356       133.52939=
4         1   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-32
Mar  9 16:34:58 s_src@amelia kernel:          apache2  2357       133.52966=
0         1   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-32
Mar  9 16:34:58 s_src@amelia kernel:          apache2  2358       133.52936=
1         1   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-32
Mar  9 16:34:58 s_src@amelia kernel:          apache2  2359       133.53016=
0         1   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-32
Mar  9 16:34:58 s_src@amelia kernel:          apache2  2360       133.53366=
5         1   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-32
Mar  9 16:34:58 s_src@amelia kernel:             cron  2422        99.76544=
1       101   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-33
Mar  9 16:34:58 s_src@amelia kernel:          kadmind  2475         2.41599=
5        99   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-35
Mar  9 16:34:58 s_src@amelia kernel:     avahi-daemon  2478        46.81656=
2       567   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-34
Mar  9 16:34:58 s_src@amelia kernel:     avahi-daemon  2479         0.96622=
3         4   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-34
Mar  9 16:34:58 s_src@amelia kernel:             sshd  2485        27.54630=
2        12   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-36
Mar  9 16:34:58 s_src@amelia kernel:            nfsd4  2585      9747.46916=
3         2   100               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:            lockd  2589      9753.49818=
2         2   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:             nfsd  2596    224565.43528=
0         4   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:             nfsd  2598    224565.41680=
5         4   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:             nfsd  2599    224565.41515=
4         4   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:             nfsd  2600    224565.42360=
9         4   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:             nfsd  2601    224565.41703=
3         4   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:    apt-cacher-ng  2660         0.69431=
2         1   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-38
Mar  9 16:34:58 s_src@amelia kernel:       rpc.mountd  2704         0.54800=
5         1   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-40
Mar  9 16:34:58 s_src@amelia kernel:            getty  3054         0.34355=
6       126   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-45
Mar  9 16:34:58 s_src@amelia kernel:            getty  3056         0.73647=
0        63   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-47
Mar  9 16:34:58 s_src@amelia kernel:             sshd  4854        35.70099=
2        30   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-52
Mar  9 16:34:58 s_src@amelia kernel:             sshd  4862        48.77778=
7       343   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-52
Mar  9 16:34:58 s_src@amelia kernel:             bash  4865       428.43712=
6       156   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-53
Mar  9 16:34:58 s_src@amelia kernel:               su  4955       471.82454=
1         9   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-53
Mar  9 16:34:58 s_src@amelia kernel:             bash  4964      9899.96053=
0       181   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-53
Mar  9 16:34:58 s_src@amelia kernel:             sshd  5006        32.15215=
2        17   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-54
Mar  9 16:34:58 s_src@amelia kernel:             bash  5017       446.45880=
3       154   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-55
Mar  9 16:34:58 s_src@amelia kernel:             sshd  5203        28.61578=
9        45   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-63
Mar  9 16:34:58 s_src@amelia kernel:             sshd  5211       165.18332=
9      2673   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-63
Mar  9 16:34:58 s_src@amelia kernel:             bash  5214      3151.39230=
4       248   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-64
Mar  9 16:34:58 s_src@amelia kernel:             sshd  5343        46.29609=
7        29   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-75
Mar  9 16:34:58 s_src@amelia kernel:             bash  5354       566.59063=
5       199   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-76
Mar  9 16:34:58 s_src@amelia kernel:         kdmflush  5502     87075.84838=
0         2   100               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:           bioset  5503     87079.83242=
8         2   100               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:       kcryptd_io  5504     87083.82459=
8         2   100               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:          kcryptd  5505     87087.81650=
1         2   100               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:           bioset  5506     87091.80474=
2         2   100               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:  btrfs-delalloc-  5516    380133.53087=
1        44   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:    btrfs-fixup-1  5517    380133.53144=
2        43   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:    btrfs-endio-1  5518    380133.57850=
5        40   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:  btrfs-endio-met  5519    380154.99693=
0       980   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:      btrfs-rmw-1  5520    380133.49089=
6        45   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:  btrfs-endio-rai  5521    380133.53411=
5        45   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:  btrfs-endio-met  5522    380133.53134=
2        41   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:  btrfs-freespace  5524    380203.19351=
2       287   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:  btrfs-readahead  5527    380133.51343=
3        49   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:          sshpass  5535     10173.52739=
1         5   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-53
Mar  9 16:34:58 s_src@amelia kernel:              ssh  5555    121266.17025=
2    519897   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-84
Mar  9 16:34:58 s_src@amelia kernel:     kworker/u8:2  5610    379971.13969=
5      4824   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:      kworker/0:0  5617    379940.32460=
7     26456   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:  btrfs-endio-wri  6672    380179.39961=
4       424   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:     kworker/u9:2  6703    378377.60539=
6     90095   100               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:             mutt  6708      8962.87534=
4      8326   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-64
Mar  9 16:34:58 s_src@amelia kernel:     kworker/u8:1  6881    379964.64458=
6       785   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:      kworker/0:2  6884    379915.59405=
3       314   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:      kworker/0:1  6891    380603.19433=
7      1025   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:     kworker/u8:0  6892    380602.79575=
2       289   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:             sudo  6899       658.29698=
4        58   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-76
Mar  9 16:34:58 s_src@amelia kernel:               su  6900       495.99964=
7        19   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-55
Mar  9 16:34:58 s_src@amelia kernel: R           bash  6909       715.02135=
1        88   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-55
Mar  9 16:34:58 s_src@amelia kernel:=20
Mar  9 16:34:58 s_src@amelia kernel: cpu#1, 1297.893 MHz
Mar  9 16:34:58 s_src@amelia kernel:   .nr_running                    : 0
Mar  9 16:34:58 s_src@amelia kernel:   .load                          : 0
Mar  9 16:34:58 s_src@amelia kernel:   .nr_switches                   : 452=
9939
Mar  9 16:34:58 s_src@amelia kernel:   .nr_load_updates               : 346=
773
Mar  9 16:34:58 s_src@amelia kernel:   .nr_uninterruptible            : -12=
502
Mar  9 16:34:58 s_src@amelia kernel:   .next_balance                  : 429=
5.500666
Mar  9 16:34:58 s_src@amelia kernel:   .curr->pid                     : 0
Mar  9 16:34:58 s_src@amelia kernel:   .clock                         : 563=
4339.558146
Mar  9 16:34:58 s_src@amelia kernel:   .cpu_load[0]                   : 0
Mar  9 16:34:58 s_src@amelia kernel:   .cpu_load[1]                   : 0
Mar  9 16:34:58 s_src@amelia kernel:   .cpu_load[2]                   : 0
Mar  9 16:34:58 s_src@amelia kernel:   .cpu_load[3]                   : 0
Mar  9 16:34:58 s_src@amelia kernel:   .cpu_load[4]                   : 0
Mar  9 16:34:58 s_src@amelia kernel: \x0acfs_rq[1]:/autogroup-54
Mar  9 16:34:58 s_src@amelia kernel:   .exec_clock                    : 0.0=
00000
Mar  9 16:34:58 s_src@amelia kernel:   .MIN_vruntime                  : 0.0=
00001
Mar  9 16:34:58 s_src@amelia kernel:   .min_vruntime                  : 101=
=2E697478
Mar  9 16:34:58 s_src@amelia kernel:   .max_vruntime                  : 0.0=
00001
Mar  9 16:34:58 s_src@amelia kernel:   .spread                        : 0.0=
00000
Mar  9 16:34:58 s_src@amelia kernel:   .spread0                       : -38=
0506.987398
Mar  9 16:34:58 s_src@amelia kernel:   .nr_spread_over                : 0
Mar  9 16:34:58 s_src@amelia kernel:   .nr_running                    : 0
Mar  9 16:34:58 s_src@amelia kernel:   .load                          : 0
Mar  9 16:34:58 s_src@amelia kernel:   .runnable_load_avg             : 0
Mar  9 16:34:58 s_src@amelia kernel:   .blocked_load_avg              : 0
Mar  9 16:34:58 s_src@amelia kernel:   .tg_load_contrib               : 0
Mar  9 16:34:58 s_src@amelia kernel:   .tg_runnable_contrib           : 0
Mar  9 16:34:58 s_src@amelia kernel:   .tg_load_avg                   : 0
Mar  9 16:34:58 s_src@amelia kernel:   .tg->runnable_avg              : 0
Mar  9 16:34:58 s_src@amelia kernel:   .se->exec_start                : 563=
4339.534386
Mar  9 16:34:58 s_src@amelia kernel:   .se->vruntime                  : 362=
795.231762
Mar  9 16:34:58 s_src@amelia kernel:   .se->sum_exec_runtime          : 97.=
286387
Mar  9 16:34:58 s_src@amelia kernel:   .se->load.weight               : 2
Mar  9 16:34:58 s_src@amelia kernel:   .se->avg.runnable_avg_sum      : 131
Mar  9 16:34:58 s_src@amelia kernel:   .se->avg.runnable_avg_period   : 475=
51
Mar  9 16:34:58 s_src@amelia kernel:   .se->avg.load_avg_contrib      : 0
Mar  9 16:34:58 s_src@amelia kernel:   .se->avg.decay_count           : 537=
3325
Mar  9 16:34:58 s_src@amelia kernel: \x0acfs_rq[1]:/autogroup-32
Mar  9 16:34:58 s_src@amelia kernel:   .exec_clock                    : 0.0=
00000
Mar  9 16:34:58 s_src@amelia kernel:   .MIN_vruntime                  : 0.0=
00001
Mar  9 16:34:58 s_src@amelia kernel:   .min_vruntime                  : 233=
0.309909
Mar  9 16:34:58 s_src@amelia kernel:   .max_vruntime                  : 0.0=
00001
Mar  9 16:34:58 s_src@amelia kernel:   .spread                        : 0.0=
00000
Mar  9 16:34:58 s_src@amelia kernel:   .spread0                       : -37=
8278.374967
Mar  9 16:34:58 s_src@amelia kernel:   .nr_spread_over                : 0
Mar  9 16:34:58 s_src@amelia kernel:   .nr_running                    : 0
Mar  9 16:34:58 s_src@amelia kernel:   .load                          : 0
Mar  9 16:34:58 s_src@amelia kernel:   .runnable_load_avg             : 0
Mar  9 16:34:58 s_src@amelia kernel:   .blocked_load_avg              : 0
Mar  9 16:34:58 s_src@amelia kernel:   .tg_load_contrib               : 0
Mar  9 16:34:58 s_src@amelia kernel:   .tg_runnable_contrib           : 0
Mar  9 16:34:58 s_src@amelia kernel:   .tg_load_avg                   : 0
Mar  9 16:34:58 s_src@amelia kernel:   .tg->runnable_avg              : 0
Mar  9 16:34:58 s_src@amelia kernel:   .se->exec_start                : 563=
4302.208649
Mar  9 16:34:58 s_src@amelia kernel:   .se->vruntime                  : 362=
800.837614
Mar  9 16:34:58 s_src@amelia kernel:   .se->sum_exec_runtime          : 307=
3.640955
Mar  9 16:34:58 s_src@amelia kernel:   .se->load.weight               : 2
Mar  9 16:34:58 s_src@amelia kernel:   .se->avg.runnable_avg_sum      : 35
Mar  9 16:34:58 s_src@amelia kernel:   .se->avg.runnable_avg_period   : 479=
83
Mar  9 16:34:58 s_src@amelia kernel:   .se->avg.load_avg_contrib      : 0
Mar  9 16:34:58 s_src@amelia kernel:   .se->avg.decay_count           : 537=
3290
Mar  9 16:34:58 s_src@amelia kernel: \x0acfs_rq[1]:/
Mar  9 16:34:58 s_src@amelia kernel:   .exec_clock                    : 0.0=
00000
Mar  9 16:34:58 s_src@amelia kernel:   .MIN_vruntime                  : 0.0=
00001
Mar  9 16:34:58 s_src@amelia kernel:   .min_vruntime                  : 362=
800.837614
Mar  9 16:34:58 s_src@amelia kernel:   .max_vruntime                  : 0.0=
00001
Mar  9 16:34:58 s_src@amelia kernel:   .spread                        : 0.0=
00000
Mar  9 16:34:58 s_src@amelia kernel:   .spread0                       : -17=
807.847262
Mar  9 16:34:58 s_src@amelia kernel:   .nr_spread_over                : 0
Mar  9 16:34:58 s_src@amelia kernel:   .nr_running                    : 0
Mar  9 16:34:58 s_src@amelia kernel:   .load                          : 0
Mar  9 16:34:58 s_src@amelia kernel:   .runnable_load_avg             : 0
Mar  9 16:34:58 s_src@amelia kernel:   .blocked_load_avg              : 4
Mar  9 16:34:58 s_src@amelia kernel:   .tg_load_contrib               : 4
Mar  9 16:34:58 s_src@amelia kernel:   .tg_runnable_contrib           : 4
Mar  9 16:34:58 s_src@amelia kernel:   .tg_load_avg                   : 4
Mar  9 16:34:58 s_src@amelia kernel:   .tg->runnable_avg              : 6
Mar  9 16:34:58 s_src@amelia kernel:   .avg->runnable_avg_sum         : 188
Mar  9 16:34:58 s_src@amelia kernel:   .avg->runnable_avg_period      : 478=
26
Mar  9 16:34:58 s_src@amelia kernel: \x0art_rq[1]:
Mar  9 16:34:58 s_src@amelia kernel:   .rt_nr_running                 : 0
Mar  9 16:34:58 s_src@amelia kernel:   .rt_throttled                  : 0
Mar  9 16:34:58 s_src@amelia kernel:   .rt_time                       : 0.0=
00000
Mar  9 16:34:58 s_src@amelia kernel:   .rt_runtime                    : 950=
=2E000000
Mar  9 16:34:58 s_src@amelia kernel: \x0arunnable tasks:\x0a            tas=
k   PID         tree-key  switches  prio     exec-runtime         sum-exec =
       sum-sleep\x0a-------------------------------------------------------=
---------------------------------------------------
Mar  9 16:34:58 s_src@amelia kernel:             init     1        62.27211=
7      1520   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-2
Mar  9 16:34:58 s_src@amelia kernel:        rcu_sched     7    362794.70457=
2     91712   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:      migration/1    10         0.00000=
0      1589     0               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:      ksoftirqd/1    11    362779.23188=
4     88447   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:     kworker/1:0H    13         3.43455=
6         4   100               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:          khelper    14         4.96928=
5         2   100               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:      kintegrityd    18        15.48028=
2         2   100               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:           bioset    19        21.49196=
1         2   100               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:          kblockd    21        27.50406=
9         2   100               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:            khubd    22      1199.04730=
1       113   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:          kswapd0    28    362779.12738=
1     64282   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:             ksmd    29       174.48514=
3         2   125               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:    fsnotify_mark    30    362612.10672=
7        19   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:           crypto    31       180.93954=
5         2   100               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:         pencrypt    38       211.31478=
4         2   100               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:         pdecrypt    39       217.33345=
7         2   100               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:          deferwq    61       306.80889=
6         2   100               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:   btrfs-submit-1   208    362594.71138=
1      1578   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:  btrfs-delalloc-   209    362594.78859=
5        82   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:  btrfs-endio-met   212    362779.52352=
3      4203   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:      btrfs-rmw-1   213    362594.81122=
7        80   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:  btrfs-endio-rai   214    362594.78934=
4        84   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:  btrfs-endio-met   215    362594.78950=
9        83   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:  btrfs-freespace   217    362611.55624=
4       833   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:  btrfs-delayed-m   218    362601.60128=
8       103   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:  btrfs-readahead   220    362594.81437=
4        86   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:  btrfs-flush_del   221    362593.97455=
6       298   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:  btrfs-qgroup-re   222    362594.80842=
7        79   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:  btrfs-transacti   224    358950.12319=
4      7410   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:            udevd   378       426.58776=
2       352   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-4
Mar  9 16:34:58 s_src@amelia kernel:        scsi_eh_4   493      2045.92055=
5         2   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:      usb-storage   494    362424.93555=
7    247809   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:  kvm-irqfd-clean   512      2275.12472=
2         3   100               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:           nfsiod  1727      6433.12142=
4         2   100               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:       rpc.idmapd  1735         0.42214=
9         1   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-7
Mar  9 16:34:58 s_src@amelia kernel:        syslog-ng  1994         6.06274=
2         3   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-11
Mar  9 16:34:58 s_src@amelia kernel:            acpid  2029         0.11738=
7         2   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-13
Mar  9 16:34:58 s_src@amelia kernel:              atd  2068         0.55323=
1         2   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-14
Mar  9 16:34:58 s_src@amelia kernel:            named  2079       105.24795=
2      1084   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-15
Mar  9 16:34:58 s_src@amelia kernel:        mosquitto  2093      1659.11364=
0     53988   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-16
Mar  9 16:34:58 s_src@amelia kernel:             ntpd  2176       314.21007=
2      6028   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-18
Mar  9 16:34:58 s_src@amelia kernel:          krb5kdc  2195        23.55138=
8       147   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-19
Mar  9 16:34:58 s_src@amelia kernel:      dbus-daemon  2213         0.85803=
2        12   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-20
Mar  9 16:34:58 s_src@amelia kernel:         postgres  2245       321.05435=
8       262   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-21
Mar  9 16:34:58 s_src@amelia kernel:         postgres  2247         1.42874=
0        19   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-23
Mar  9 16:34:58 s_src@amelia kernel:         postgres  2248        65.43970=
2      1677   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-24
Mar  9 16:34:58 s_src@amelia kernel:         postgres  2249        29.86521=
8      1164   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-27
Mar  9 16:34:58 s_src@amelia kernel:         postgres  2250       667.75686=
3      8450   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-26
Mar  9 16:34:58 s_src@amelia kernel:         postgres  2251       147.32293=
2       366   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-25
Mar  9 16:34:58 s_src@amelia kernel:          apache2  2303      2323.94669=
6      5588   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-32
Mar  9 16:34:58 s_src@amelia kernel:          apache2  2306       110.31401=
2        70   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-32
Mar  9 16:34:58 s_src@amelia kernel:          apache2  2337       123.16726=
7         1   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-32
Mar  9 16:34:58 s_src@amelia kernel:          apache2  2339       117.39723=
4         1   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-32
Mar  9 16:34:58 s_src@amelia kernel:          apache2  2355      2330.30990=
9     55777   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-32
Mar  9 16:34:58 s_src@amelia kernel:          apache2  2316       118.72595=
7         2   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-32
Mar  9 16:34:58 s_src@amelia kernel:          apache2  2318       117.44761=
5         6   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-32
Mar  9 16:34:58 s_src@amelia kernel:          apache2  2320       118.67757=
0         2   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-32
Mar  9 16:34:58 s_src@amelia kernel:          apache2  2322       118.58607=
7         2   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-32
Mar  9 16:34:58 s_src@amelia kernel:          apache2  2324       118.59519=
5         3   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-32
Mar  9 16:34:58 s_src@amelia kernel:          apache2  2326       118.48820=
0         3   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-32
Mar  9 16:34:58 s_src@amelia kernel:          apache2  2328       114.59850=
1         3   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-32
Mar  9 16:34:58 s_src@amelia kernel:          apache2  2332       118.72398=
9         2   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-32
Mar  9 16:34:58 s_src@amelia kernel:          apache2  2334       114.71180=
2         2   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-32
Mar  9 16:34:58 s_src@amelia kernel:          apache2  2336       114.65131=
6         2   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-32
Mar  9 16:34:58 s_src@amelia kernel:          apache2  2338       118.71917=
3         1   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-32
Mar  9 16:34:58 s_src@amelia kernel:          apache2  2340       118.74958=
0         1   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-32
Mar  9 16:34:58 s_src@amelia kernel:          apache2  2341       118.79672=
5         1   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-32
Mar  9 16:34:58 s_src@amelia kernel:          apache2  2361      2330.22662=
2     55778   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-32
Mar  9 16:34:58 s_src@amelia kernel:  nfsd4_callbacks  2586      9812.49545=
0         2   100               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:             nfsd  2597    220167.06729=
2         4   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:             nfsd  2602    220167.02150=
4         4   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:             nfsd  2603    220167.01760=
0         4   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:      rpc.svcgssd  2640        12.39793=
6         7   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-37
Mar  9 16:34:58 s_src@amelia kernel:            exim4  2936        58.61612=
5         8   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-41
Mar  9 16:34:58 s_src@amelia kernel:            getty  3051         0.82658=
5       124   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-42
Mar  9 16:34:58 s_src@amelia kernel:            getty  3052         0.81846=
1       129   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-43
Mar  9 16:34:58 s_src@amelia kernel:            getty  3053         2.06247=
3       127   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-44
Mar  9 16:34:58 s_src@amelia kernel:            getty  3055         1.90064=
1       128   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-46
Mar  9 16:34:58 s_src@amelia kernel:             sudo  4947       398.02026=
5        51   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-53
Mar  9 16:34:58 s_src@amelia kernel:             sshd  5014       101.69747=
8       754   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-54
Mar  9 16:34:58 s_src@amelia kernel:             sshd  5351        72.98749=
2       279   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-75
Mar  9 16:34:58 s_src@amelia kernel:  btrfs-endio-wri  5436    360147.03563=
7       214   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:    carfax-backup  5486     66091.15613=
1    280654   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-53
Mar  9 16:34:58 s_src@amelia kernel:  btrfs-genwork-1  5514    362601.01731=
9        77   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:   btrfs-submit-1  5515    362601.62222=
4     33414   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:    btrfs-cache-1  5526    362595.94250=
4        41   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:  btrfs-flush_del  5528    362597.49048=
5        55   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:  btrfs-qgroup-re  5529    362595.91299=
5        47   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:    btrfs-cleaner  5533    362779.10614=
0       509   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:  btrfs-transacti  5534    362779.13601=
5      4490   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:              ssh  5536    131713.07472=
8    440801   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-82
Mar  9 16:34:58 s_src@amelia kernel:          python3  5549     14344.67411=
6        13   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-53
Mar  9 16:34:58 s_src@amelia kernel:            btrfs  5550     66093.93117=
6    984146   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-53
Mar  9 16:34:58 s_src@amelia kernel:            btrfs  5551     66090.43738=
7    131126   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-53
Mar  9 16:34:58 s_src@amelia kernel:          sshpass  5554     14369.71351=
1        14   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-53
Mar  9 16:34:58 s_src@amelia kernel:          python3  5557     14567.70258=
4        19   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-53
Mar  9 16:34:58 s_src@amelia kernel:            btrfs  5558     66097.00820=
3    225880   120               0               0               0.000000   =
            0.000000               0.000000 /autogroup-53
Mar  9 16:34:58 s_src@amelia kernel:   btrfs-worker-4  5566    362601.63784=
3      5613   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:  btrfs-delayed-m  5575    362599.89556=
3      1006   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:      kworker/1:1  6662    362794.86029=
5     16139   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:      kworker/1:2  6879    361944.54977=
6       635   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:     kworker/u9:1  6887    362790.09763=
1     19032   100               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:    btrfs-endio-2  6894    362779.22522=
9       105   120               0               0               0.000000   =
            0.000000               0.000000 /
Mar  9 16:34:58 s_src@amelia kernel:=20


--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- You can get more with a kind word and a two-by-four than you ---  =20
                       can with just a kind word.                       =20

--Li7ckgedzMh1NgdW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBUxyaKVheFHXiqx3kAQIAJw/9E0oiYS7aX5C4xRuMM6Cc0qVmBFmCQ1J4
57VYyhTMY/298YjYqL1niMGc8GYegjRVSepKuXzyZWWa5/HvECUAw1pio8uJgiMI
XnRgHyKtOMEjFH6ywxGBtTVDqQZRKn3RxY/DNTGwL5l5f0Z3+yJgooEM7b1190OO
/URPGjNEB4hr05HulESv9fEC8psHEqPUiXH9BStQI9JUv3zSjZ9UrVRNyr36gwDk
EnZUkm5/bGWazlKJR5ZwxJt3K/TXTUUsG/GgvNoffQKq+FDbqUy8VUMVHKy/1364
lJ5/6a3nVp99IiVxFVUJdB9MQlZkJvxbfNc6YZmrsej+6fr+3edP3gAqH9GuDQ6D
/Y4nLUKKk9nEghymtO6eJCWdmfFm4IB4U4XziYa5VN/0ryvsEZuQRIYUDy0IA9Ed
M8w/WGLwCYy26Wt+nruJCHZnVk3CS4UJieQutzBZO3iQNcQVOhkLI3D1AhpK4ivL
LIB4MktXrenY3NM+REIdcf8fT9C6458UF6V1ns/0q55mXB6edjbORpz3lqkXpjEA
03VtUl4vlNH7di2ixXTZPf9hpAcmW97qM+CaVzfcgGSrUMKCnX6c2ssoUnnxkqW/
1Rsb52TC1cFS+9ofr25cKbRJ/TxIh5gGJLiv1xuwXl2hqDqwIK2SdgaxmpJD7/5l
WW9rbOWwRH4=
=MSrN
-----END PGP SIGNATURE-----

--Li7ckgedzMh1NgdW--
