Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50901 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751123AbcIVQYM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Sep 2016 12:24:12 -0400
Subject: Re: [PATCH v3] btrfs: fix a possible umount deadlock
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20160909083104.10383-1-anand.jain@oracle.com>
 <20160922045613.25861-1-anand.jain@oracle.com>
Cc: dsterba@suse.cz
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <b16b4d32-9990-25d3-2973-f2bae1e6fba5@suse.com>
Date: Thu, 22 Sep 2016 12:24:07 -0400
MIME-Version: 1.0
In-Reply-To: <20160922045613.25861-1-anand.jain@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="RFXVsJO5ai6UOr8WEPKMvbHREvKhTr7j7"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--RFXVsJO5ai6UOr8WEPKMvbHREvKhTr7j7
Content-Type: multipart/mixed; boundary="ORdbulj9atxLHrj6JKc8lP2SM6oalEjXn";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Message-ID: <b16b4d32-9990-25d3-2973-f2bae1e6fba5@suse.com>
Subject: Re: [PATCH v3] btrfs: fix a possible umount deadlock
References: <20160909083104.10383-1-anand.jain@oracle.com>
 <20160922045613.25861-1-anand.jain@oracle.com>
In-Reply-To: <20160922045613.25861-1-anand.jain@oracle.com>

--ORdbulj9atxLHrj6JKc8lP2SM6oalEjXn
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 9/22/16 12:56 AM, Anand Jain wrote:
> btrfs_show_devname() is using the device_list_mutex, sometimes
> a call to blkdev_put() leads vfs calling into this func. So
> call blkdev_put() outside of device_list_mutex, as of now.
>=20
> [  983.284212] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [  983.290401] [ INFO: possible circular locking dependency detected ]
> [  983.296677] 4.8.0-rc5-ceph-00023-g1b39cec2 #1 Not tainted
> [  983.302081] -------------------------------------------------------
> [  983.308357] umount/21720 is trying to acquire lock:
> [  983.313243]  (&bdev->bd_mutex){+.+.+.}, at: [<ffffffff9128ec51>] blk=
dev_put+0x31/0x150
> [  983.321264]
> [  983.321264] but task is already holding lock:
> [  983.327101]  (&fs_devs->device_list_mutex){+.+...}, at: [<ffffffffc0=
33d6f6>] __btrfs_close_devices+0x46/0x200 [btrfs]
> [  983.337839]
> [  983.337839] which lock already depends on the new lock.
> [  983.337839]
> [  983.346024]
> [  983.346024] the existing dependency chain (in reverse order) is:
> [  983.353512]
> -> #4 (&fs_devs->device_list_mutex){+.+...}:
> [  983.359096]        [<ffffffff910dfd0c>] lock_acquire+0x1bc/0x1f0
> [  983.365143]        [<ffffffff91823125>] mutex_lock_nested+0x65/0x350=

> [  983.371521]        [<ffffffffc02d8116>] btrfs_show_devname+0x36/0x1f=
0 [btrfs]
> [  983.378710]        [<ffffffff9129523e>] show_vfsmnt+0x4e/0x150
> [  983.384593]        [<ffffffff9126ffc7>] m_show+0x17/0x20
> [  983.389957]        [<ffffffff91276405>] seq_read+0x2b5/0x3b0
> [  983.395669]        [<ffffffff9124c808>] __vfs_read+0x28/0x100
> [  983.401464]        [<ffffffff9124eb3b>] vfs_read+0xab/0x150
> [  983.407080]        [<ffffffff9124ec32>] SyS_read+0x52/0xb0
> [  983.412609]        [<ffffffff91825fc0>] entry_SYSCALL_64_fastpath+0x=
23/0xc1
> [  983.419617]
> -> #3 (namespace_sem){++++++}:
> [  983.424024]        [<ffffffff910dfd0c>] lock_acquire+0x1bc/0x1f0
> [  983.430074]        [<ffffffff918239e9>] down_write+0x49/0x80
> [  983.435785]        [<ffffffff91272457>] lock_mount+0x67/0x1c0
> [  983.441582]        [<ffffffff91272ab2>] do_add_mount+0x32/0xf0
> [  983.447458]        [<ffffffff9127363a>] finish_automount+0x5a/0xc0
> [  983.453682]        [<ffffffff91259513>] follow_managed+0x1b3/0x2a0
> [  983.459912]        [<ffffffff9125b750>] lookup_fast+0x300/0x350
> [  983.465875]        [<ffffffff9125d6e7>] path_openat+0x3a7/0xaa0
> [  983.471846]        [<ffffffff9125ef75>] do_filp_open+0x85/0xe0
> [  983.477731]        [<ffffffff9124c41c>] do_sys_open+0x14c/0x1f0
> [  983.483702]        [<ffffffff9124c4de>] SyS_open+0x1e/0x20
> [  983.489240]        [<ffffffff91825fc0>] entry_SYSCALL_64_fastpath+0x=
23/0xc1
> [  983.496254]
> -> #2 (&sb->s_type->i_mutex_key#3){+.+.+.}:
> [  983.501798]        [<ffffffff910dfd0c>] lock_acquire+0x1bc/0x1f0
> [  983.507855]        [<ffffffff918239e9>] down_write+0x49/0x80
> [  983.513558]        [<ffffffff91366237>] start_creating+0x87/0x100
> [  983.519703]        [<ffffffff91366647>] debugfs_create_dir+0x17/0x10=
0
> [  983.526195]        [<ffffffff911df153>] bdi_register+0x93/0x210
> [  983.532165]        [<ffffffff911df313>] bdi_register_owner+0x43/0x70=

> [  983.538570]        [<ffffffff914080fb>] device_add_disk+0x1fb/0x450
> [  983.544888]        [<ffffffff91580226>] loop_add+0x1e6/0x290
> [  983.550596]        [<ffffffff91fec358>] loop_init+0x10b/0x14f
> [  983.556394]        [<ffffffff91002207>] do_one_initcall+0xa7/0x180
> [  983.562618]        [<ffffffff91f932e0>] kernel_init_freeable+0x1cc/0=
x266
> [  983.569370]        [<ffffffff918174be>] kernel_init+0xe/0x100
> [  983.575166]        [<ffffffff9182620f>] ret_from_fork+0x1f/0x40
> [  983.581131]
> -> #1 (loop_index_mutex){+.+.+.}:
> [  983.585801]        [<ffffffff910dfd0c>] lock_acquire+0x1bc/0x1f0
> [  983.591858]        [<ffffffff91823125>] mutex_lock_nested+0x65/0x350=

> [  983.598256]        [<ffffffff9157ed3f>] lo_open+0x1f/0x60
> [  983.603704]        [<ffffffff9128eec3>] __blkdev_get+0x123/0x400
> [  983.609757]        [<ffffffff9128f4ea>] blkdev_get+0x34a/0x350
> [  983.615639]        [<ffffffff9128f554>] blkdev_open+0x64/0x80
> [  983.621428]        [<ffffffff9124aff6>] do_dentry_open+0x1c6/0x2d0
> [  983.627651]        [<ffffffff9124c029>] vfs_open+0x69/0x80
> [  983.633181]        [<ffffffff9125db74>] path_openat+0x834/0xaa0
> [  983.639152]        [<ffffffff9125ef75>] do_filp_open+0x85/0xe0
> [  983.645035]        [<ffffffff9124c41c>] do_sys_open+0x14c/0x1f0
> [  983.650999]        [<ffffffff9124c4de>] SyS_open+0x1e/0x20
> [  983.656535]        [<ffffffff91825fc0>] entry_SYSCALL_64_fastpath+0x=
23/0xc1
> [  983.663541]
> -> #0 (&bdev->bd_mutex){+.+.+.}:
> [  983.668107]        [<ffffffff910def43>] __lock_acquire+0x1003/0x17b0=

> [  983.674510]        [<ffffffff910dfd0c>] lock_acquire+0x1bc/0x1f0
> [  983.680561]        [<ffffffff91823125>] mutex_lock_nested+0x65/0x350=

> [  983.686967]        [<ffffffff9128ec51>] blkdev_put+0x31/0x150
> [  983.692761]        [<ffffffffc033481f>] btrfs_close_bdev+0x4f/0x60 [=
btrfs]
> [  983.699699]        [<ffffffffc033d77b>] __btrfs_close_devices+0xcb/0=
x200 [btrfs]
> [  983.707178]        [<ffffffffc033d8db>] btrfs_close_devices+0x2b/0xa=
0 [btrfs]
> [  983.714380]        [<ffffffffc03081c5>] close_ctree+0x265/0x340 [btr=
fs]
> [  983.721061]        [<ffffffffc02d7959>] btrfs_put_super+0x19/0x20 [b=
trfs]
> [  983.727908]        [<ffffffff91250e2f>] generic_shutdown_super+0x6f/=
0x100
> [  983.734744]        [<ffffffff91250f56>] kill_anon_super+0x16/0x30
> [  983.740888]        [<ffffffffc02da97e>] btrfs_kill_super+0x1e/0x130 =
[btrfs]
> [  983.747909]        [<ffffffff91250fe9>] deactivate_locked_super+0x49=
/0x80
> [  983.754745]        [<ffffffff912515fd>] deactivate_super+0x5d/0x70
> [  983.760977]        [<ffffffff91270a1c>] cleanup_mnt+0x5c/0x80
> [  983.766773]        [<ffffffff91270a92>] __cleanup_mnt+0x12/0x20
> [  983.772738]        [<ffffffff910aa2fe>] task_work_run+0x7e/0xc0
> [  983.778708]        [<ffffffff91081b5a>] exit_to_usermode_loop+0x7e/0=
xb4
> [  983.785373]        [<ffffffff910039eb>] syscall_return_slowpath+0xbb=
/0xd0
> [  983.792212]        [<ffffffff9182605c>] entry_SYSCALL_64_fastpath+0x=
bf/0xc1
> [  983.799225]
> [  983.799225] other info that might help us debug this:
> [  983.799225]
> [  983.807291] Chain exists of:
>   &bdev->bd_mutex --> namespace_sem --> &fs_devs->device_list_mutex
>=20
> [  983.816521]  Possible unsafe locking scenario:
> [  983.816521]
> [  983.822489]        CPU0                    CPU1
> [  983.827043]        ----                    ----
> [  983.831599]   lock(&fs_devs->device_list_mutex);
> [  983.836289]                                lock(namespace_sem);
> [  983.842268]                                lock(&fs_devs->device_lis=
t_mutex);
> [  983.849478]   lock(&bdev->bd_mutex);
> [  983.853127]
> [  983.853127]  *** DEADLOCK ***
> [  983.853127]
> [  983.859113] 3 locks held by umount/21720:
> [  983.863145]  #0:  (&type->s_umount_key#35){++++..}, at: [<ffffffff91=
2515f5>] deactivate_super+0x55/0x70
> [  983.872713]  #1:  (uuid_mutex){+.+.+.}, at: [<ffffffffc033d8d3>] btr=
fs_close_devices+0x23/0xa0 [btrfs]
> [  983.882206]  #2:  (&fs_devs->device_list_mutex){+.+...}, at: [<fffff=
fffc033d6f6>] __btrfs_close_devices+0x46/0x200 [btrfs]
> [  983.893422]
> [  983.893422] stack backtrace:
> [  983.897824] CPU: 6 PID: 21720 Comm: umount Not tainted 4.8.0-rc5-cep=
h-00023-g1b39cec2 #1
> [  983.905958] Hardware name: Supermicro SYS-5018R-WR/X10SRW-F, BIOS 1.=
0c 09/07/2015
> [  983.913492]  0000000000000000 ffff8c8a53c17a38 ffffffff91429521 ffff=
ffff9260f4f0
> [  983.921018]  ffffffff92642760 ffff8c8a53c17a88 ffffffff911b2b04 0000=
000000000050
> [  983.928542]  ffffffff9237d620 ffff8c8a5294aee0 ffff8c8a5294aeb8 ffff=
8c8a5294aee0
> [  983.936072] Call Trace:
> [  983.938545]  [<ffffffff91429521>] dump_stack+0x85/0xc4
> [  983.943715]  [<ffffffff911b2b04>] print_circular_bug+0x1fb/0x20c
> [  983.949748]  [<ffffffff910def43>] __lock_acquire+0x1003/0x17b0
> [  983.955613]  [<ffffffff910dfd0c>] lock_acquire+0x1bc/0x1f0
> [  983.961123]  [<ffffffff9128ec51>] ? blkdev_put+0x31/0x150
> [  983.966550]  [<ffffffff91823125>] mutex_lock_nested+0x65/0x350
> [  983.972407]  [<ffffffff9128ec51>] ? blkdev_put+0x31/0x150
> [  983.977832]  [<ffffffff9128ec51>] blkdev_put+0x31/0x150
> [  983.983101]  [<ffffffffc033481f>] btrfs_close_bdev+0x4f/0x60 [btrfs]=

> [  983.989500]  [<ffffffffc033d77b>] __btrfs_close_devices+0xcb/0x200 [=
btrfs]
> [  983.996415]  [<ffffffffc033d8db>] btrfs_close_devices+0x2b/0xa0 [btr=
fs]
> [  984.003068]  [<ffffffffc03081c5>] close_ctree+0x265/0x340 [btrfs]
> [  984.009189]  [<ffffffff9126cc5e>] ? evict_inodes+0x15e/0x170
> [  984.014881]  [<ffffffffc02d7959>] btrfs_put_super+0x19/0x20 [btrfs]
> [  984.021176]  [<ffffffff91250e2f>] generic_shutdown_super+0x6f/0x100
> [  984.027476]  [<ffffffff91250f56>] kill_anon_super+0x16/0x30
> [  984.033082]  [<ffffffffc02da97e>] btrfs_kill_super+0x1e/0x130 [btrfs=
]
> [  984.039548]  [<ffffffff91250fe9>] deactivate_locked_super+0x49/0x80
> [  984.045839]  [<ffffffff912515fd>] deactivate_super+0x5d/0x70
> [  984.051525]  [<ffffffff91270a1c>] cleanup_mnt+0x5c/0x80
> [  984.056774]  [<ffffffff91270a92>] __cleanup_mnt+0x12/0x20
> [  984.062201]  [<ffffffff910aa2fe>] task_work_run+0x7e/0xc0
> [  984.067625]  [<ffffffff91081b5a>] exit_to_usermode_loop+0x7e/0xb4
> [  984.073747]  [<ffffffff910039eb>] syscall_return_slowpath+0xbb/0xd0
> [  984.080038]  [<ffffffff9182605c>] entry_SYSCALL_64_fastpath+0xbf/0xc=
1
>=20
> Reported-by: Ilya Dryomov <idryomov@gmail.com>
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
> v2->v3: rename btrfs_close_one_device() to btrfs_prepare_close_one_devi=
ce()
>         use struct list_head instead of LIST_HEAD
>         use list_first_entry instead of list_entry
> v1->v2: Fix typo, remove static thanks Kdave.
>=20
>  fs/btrfs/volumes.c | 26 ++++++++++++++++++++------
>  1 file changed, 20 insertions(+), 6 deletions(-)
>=20
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 1ce584893d1b..0f4460e50cac 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -859,7 +859,7 @@ static void btrfs_close_bdev(struct btrfs_device *d=
evice)
>  		blkdev_put(device->bdev, device->mode);
>  }
> =20
> -static void btrfs_close_one_device(struct btrfs_device *device)
> +static void btrfs_prepare_close_one_device(struct btrfs_device *device=
)
>  {
>  	struct btrfs_fs_devices *fs_devices =3D device->fs_devices;
>  	struct btrfs_device *new_device;
> @@ -877,8 +877,6 @@ static void btrfs_close_one_device(struct btrfs_dev=
ice *device)
>  	if (device->missing)
>  		fs_devices->missing_devices--;
> =20
> -	btrfs_close_bdev(device);
> -
>  	new_device =3D btrfs_alloc_device(NULL, &device->devid,
>  					device->uuid);
>  	BUG_ON(IS_ERR(new_device)); /* -ENOMEM */
> @@ -892,23 +890,39 @@ static void btrfs_close_one_device(struct btrfs_d=
evice *device)
> =20
>  	list_replace_rcu(&device->dev_list, &new_device->dev_list);
>  	new_device->fs_devices =3D device->fs_devices;
> -
> -	call_rcu(&device->rcu, free_device);
>  }
> =20
>  static int __btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
>  {
>  	struct btrfs_device *device, *tmp;
> +	struct list_head pending_put;
> +
> +	INIT_LIST_HEAD(&pending_put);
> =20
>  	if (--fs_devices->opened > 0)
>  		return 0;
> =20
>  	mutex_lock(&fs_devices->device_list_mutex);
>  	list_for_each_entry_safe(device, tmp, &fs_devices->devices, dev_list)=
 {
> -		btrfs_close_one_device(device);
> +		btrfs_prepare_close_one_device(device);
> +		list_add(&device->dev_list, &pending_put);
>  	}
>  	mutex_unlock(&fs_devices->device_list_mutex);
> =20
> +	/*
> +	 * btrfs_show_devname() is using the device_list_mutex,
> +	 * sometimes call to blkdev_put() leads vfs calling
> +	 * into this func. So do put outside of device_list_mutex,
> +	 * as of now.
> +	 */
> +	while (!list_empty(&pending_put)) {
> +		device =3D list_first_entry(&pending_put,
> +				struct btrfs_device, dev_list);
> +		list_del(&device->dev_list);
> +		btrfs_close_bdev(device);
> +		call_rcu(&device->rcu, free_device);

This isn't necessarily a comment on this code in particular, but what's
the reason for using call_rcu to defer the freeing instead of
synchronize_rcu and freeing the device directly via __free_device (if it
accepted a btrfs_device)?  It's a pattern that's used throughout
volumes.c and it's old[1].  I'm not sure if it was intentional to defer
freeing since that was actually a functional change from the code it
replaced.

-Jeff

[1] 1f78160ce1b1b (Btrfs: using rcu lock in the reader side of devices li=
st)

--=20
Jeff Mahoney
SUSE Labs


--ORdbulj9atxLHrj6JKc8lP2SM6oalEjXn--

--RFXVsJO5ai6UOr8WEPKMvbHREvKhTr7j7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJX5AWnAAoJEB57S2MheeWyQJMQAIBZR9xIf2VwqHv5LV+pOu4L
9ZZxmd3DbJD/qSVm9mgRCNWYvwbTuQWPWpj2CfVBvIh7C2f6dYvFD4T2PQ1jQ2x9
TxuDG4PT2bNxdmPMZsnqepxDDkY/w3KVuT0B1N9GZcQ7LoHioZpzsigdko2LqqH7
Ve3cBiEDz++hPJjm2hwQj9ZlIdzuT8XPlw//MYmD/hHdcm9JPsBj8JkLgO9xA1hz
Lq65ObKBCLXYhpHlZa2AkXhWJHX2xn4SQVKYgH0SqvF4VOfD/Ty6v8lp+WvgNG3F
WXxH3brxUDrw/QQIK06PDapBYNGBCLmCsrIBOlLAozLXLLov8tE/eIs/0Ww0DTMU
67l4HUZUHNmJN/c7Lk0HQErsLGAxRszg0WAMIgczLWNhtsrZU1W+PypKsFEtJaRQ
3jERqSf6DAjYRpHkwDW4bF1vR41hL987dQo4+TG/jfN07krk0JVkD+ZXO4jwYSbh
VqpzEb0TZrU8kcip6ZZy0kr7OfXM8emPK31XNxQIfnVYJHGoOc0+RU48+TWwbUBe
jUcjpKB5etIshDJVWxGwDktPHTsNjkRJWGBqpzncItZ0Dblirtq8toYDs81IAr97
YZqA96z2eSjB3Jidi4iSDYLjMyv0mTZTqBjst6wI+i0K4peWj55CraEwcZZwF7Hw
GLJi/Ajx5gs55nIoPvWC
=Yha/
-----END PGP SIGNATURE-----

--RFXVsJO5ai6UOr8WEPKMvbHREvKhTr7j7--
