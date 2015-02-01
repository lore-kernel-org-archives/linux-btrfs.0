Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50889 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753662AbbBAXDt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 1 Feb 2015 18:03:49 -0500
Date: Mon, 2 Feb 2015 10:03:38 +1100
From: NeilBrown <neilb@suse.de>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Shaohua Li <shli@kernel.org>, Dan Williams <dan.j.williams@intel.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: __might_sleep() warnings on v3.19-rc6
Message-ID: <20150202100338.4fa9eefa@notabene.brown>
In-Reply-To: <20150201034315.GA20124@wfg-t540p.sh.intel.com>
References: <20141028142541.GA19097@wfg-t540p.sh.intel.com>
	<20150201034315.GA20124@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/9oiBLEO9vw8rQTIi8RbRl1S"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/9oiBLEO9vw8rQTIi8RbRl1S
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 31 Jan 2015 19:43:15 -0800 Fengguang Wu <fengguang.wu@intel.com>
wrote:

> Hi all,
>=20
> I see 2 __might_sleep() warnings on when running LKP tests on
> v3.19-rc6, one related to raid5 and another related to btrfs.
>=20
> They might be exposed by this patch.
>=20
> commit 8eb23b9f35aae413140d3fda766a98092c21e9b0
> Author:     Peter Zijlstra <peterz@infradead.org>
>=20
>     sched: Debug nested sleeps
>    =20
>     Validate we call might_sleep() with TASK_RUNNING, which catches places
>     where we nest blocking primitives, eg. mutex usage in a wait loop.
>    =20
>     Since all blocking is arranged through task_struct::state, nesting
>     this will cause the inner primitive to set TASK_RUNNING and the outer
>     will thus not block.
>    =20
>     Another observed problem is calling a blocking function from
>     schedule()->sched_submit_work()->blk_schedule_flush_plug() which will
>     then destroy the task state for the actual __schedule() call that
>     comes after it.
>=20
>=20
> dmesg-ivb44:20150129001242:x86_64-rhel:3.19.0-rc6-g26bc420b:1
>=20
>=20
> FSUse%        Count         Size    Files/sec     App Overhead
> [   60.691525] ------------[ cut here ]------------
> [   60.697499] WARNING: CPU: 0 PID: 1065 at kernel/sched/core.c:7300 __mi=
ght_sleep+0xbd/0xd0()
> [   60.709010] do not call blocking ops when !TASK_RUNNING; state=3D2 set=
 at [<ffffffff810b63ff>] prepare_to_wait+0x2f/0x90
> [   60.721646] Modules linked in: f2fs raid456 async_raid6_recov async_me=
mcpy async_pq async_xor xor async_tx raid6_pq ipmi_watchdog netconsole sg s=
d_mod mgag200 syscopyarea sysfillrect isci sysimgblt libsas ttm snd_pcm ahc=
i snd_timer drm_kms_helper scsi_transport_sas libahci snd sb_edac soundcore=
 drm libata edac_core i2c_i801 pcspkr wmi ipmi_si ipmi_msghandler
> [   60.759585] CPU: 0 PID: 1065 Comm: kworker/u481:6 Not tainted 3.19.0-r=
c6-g26bc420b #1
> [   60.769025] Hardware name: Intel Corporation S2600WP/S2600WP, BIOS SE5=
C600.86B.02.02.0002.122320131210 12/23/2013
> [   60.781193] Workqueue: writeback bdi_writeback_workfn (flush-9:0)
> [   60.788725]  ffffffff81b75d50 ffff88080979b3e8 ffffffff818a38f0 ffff88=
081ee100f8
> [   60.797820]  ffff88080979b438 ffff88080979b428 ffffffff8107260a ffff88=
080979b428
> [   60.806879]  ffffffff81b8c759 00000000000004d9 0000000000000000 000000=
0063fbe018
> [   60.815935] Call Trace:
> [   60.819368]  [<ffffffff818a38f0>] dump_stack+0x4c/0x65
> [   60.825817]  [<ffffffff8107260a>] warn_slowpath_common+0x8a/0xc0
> [   60.833269]  [<ffffffff81072686>] warn_slowpath_fmt+0x46/0x50
> [   60.840379]  [<ffffffff810afe95>] ? pick_next_task_fair+0x1b5/0x8d0
> [   60.848104]  [<ffffffff810b63ff>] ? prepare_to_wait+0x2f/0x90
> [   60.855215]  [<ffffffff810b63ff>] ? prepare_to_wait+0x2f/0x90
> [   60.862337]  [<ffffffff8109874d>] __might_sleep+0xbd/0xd0
> [   60.869044]  [<ffffffff811c7cd7>] kmem_cache_alloc_trace+0x1d7/0x250
> [   60.876830]  [<ffffffff817175d7>] ? bitmap_get_counter+0x117/0x280
> [   60.884429]  [<ffffffff817175d7>] bitmap_get_counter+0x117/0x280
> [   60.891807]  [<ffffffff810f6d02>] ? __module_text_address+0x12/0x70
> [   60.899452]  [<ffffffff81717f54>] bitmap_startwrite+0x74/0x300
> [   60.906601]  [<ffffffffa017659a>] add_stripe_bio+0x2aa/0x350 [raid456]
> [   60.914518]  [<ffffffffa017d20d>] make_request+0x1dd/0xf30 [raid456]


This one is a false-positive - I think.

It is certainly true that if the inner primitive needs to block, then the
outer loop will not wait.  However that case is the exception.  Most of the
time the inner blocking primitive isn't called and the outer loop will wait=
 as
expected.  Certainly the inner blocking primitive (a kmalloc) wouldn't be
called more than once without the outer loop making real progress.

If the outer loop sometime runs around the loop and extra time, that is no =
great cost.

However I see the value in having these warnings, even if they don't work f=
or
me.
I guess I could
      __set_current_state(TASK_RUNNING);
somewhere to defeat the warning, and add a comment explaining why.

Would that be a good thing?

Thanks,
NeilBrown


--Sig_/9oiBLEO9vw8rQTIi8RbRl1S
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIUAwUBVM6wyjnsnt1WYoG5AQIG5w/42JzBEtMo4RYB1O+5VFje7/PZ+oyQOAgQ
XvF7ESpW6MWad6AiUTsFwPdZZ3pc2Aj5iAyBFf4p+peAyUUQk0UCVbYoUeiQK1cH
SVjF2/FGHk0jxNGCoCNxZ+NRK0JsKi/lqPdTl5HOfeFpjMeECB5d2QTkeB9zFCML
MjVeaq3n+eP5VXaeoTRW2C0gCUvPGVL0EyZQDJwP8snpKlqXcSluGhOs8pHHZJ5T
6RjO1b8tnzJEyO/l45WZP8xN5qPobuZHYY6lC6XsZ3H49VgoHaVOJ3T18mBGzT8f
xXHVwTds0bNvBwW4XdsWTiCEvMYes5SZ4JVODyTVHiqOS6mRzt4yMg0ZM4xmpSZN
M2ma4L8OKBWyEPhdYte6TUKc2Bm1ynDsaoNRXq/k0uRT7q7j7mqYd/f76NGZ59Kw
MsCnTOkLwM+0vFG9L0FgNGPy+8tyKMDRW8SkNRsRo14IK6PmfbYig/OGNm4w6eNC
nNIJRBFimqzSY8p/V2fLowVtKjGJx/NcbhmzzUAjxoKQJpd0XafURy4NMvs920Uf
zpDhm6zGhIl6/keTew3vbj67mAyu4x4Yx5o9xaGBMmKUQ7FrtM0gzf6GcXAFKn+D
Av/QbFS6h/uTR99qRJ5daygi7BgT2QEWBmX6iX8wv9LxFVuLdNIzv7/QBAe3zggG
petZgYzJOg==
=o/0t
-----END PGP SIGNATURE-----

--Sig_/9oiBLEO9vw8rQTIi8RbRl1S--
