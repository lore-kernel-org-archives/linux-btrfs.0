Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:35021 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752005AbeF2G3Y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Jun 2018 02:29:24 -0400
Subject: Re: So, does btrfs check lowmem take days? weeks?
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs@vger.kernel.org
References: <20180629042707.vrjwbytg6bxmrgjg@merlins.org>
 <6658a593-3b4a-f1ef-f550-2fb951b2517d@gmx.com>
 <20180629052825.tifg2aw7oy3qyyvw@merlins.org>
 <3b240898-a96d-77f6-efb9-f0af81ee0cd1@gmx.com>
 <20180629060657.qrtcxfcy22zkstfw@merlins.org>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <e9264580-7853-fbfc-2c90-e28e8a45daf5@gmx.com>
Date: Fri, 29 Jun 2018 14:29:10 +0800
MIME-Version: 1.0
In-Reply-To: <20180629060657.qrtcxfcy22zkstfw@merlins.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="b6QJpFu35k1Tk4GvDw3pzgyiDgNRcs7sr"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--b6QJpFu35k1Tk4GvDw3pzgyiDgNRcs7sr
Content-Type: multipart/mixed; boundary="C1Rh3j1xzviIfItWba4FGOJAwUOCHWu3U";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <e9264580-7853-fbfc-2c90-e28e8a45daf5@gmx.com>
Subject: Re: So, does btrfs check lowmem take days? weeks?
References: <20180629042707.vrjwbytg6bxmrgjg@merlins.org>
 <6658a593-3b4a-f1ef-f550-2fb951b2517d@gmx.com>
 <20180629052825.tifg2aw7oy3qyyvw@merlins.org>
 <3b240898-a96d-77f6-efb9-f0af81ee0cd1@gmx.com>
 <20180629060657.qrtcxfcy22zkstfw@merlins.org>
In-Reply-To: <20180629060657.qrtcxfcy22zkstfw@merlins.org>

--C1Rh3j1xzviIfItWba4FGOJAwUOCHWu3U
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B406=E6=9C=8829=E6=97=A5 14:06, Marc MERLIN wrote:
> On Fri, Jun 29, 2018 at 01:48:17PM +0800, Qu Wenruo wrote:
>> Just normal btrfs check, and post the output.
>> If normal check eats up all your memory, btrfs check --mode=3Dlowmem.
> =20
> Does check without --repair eat less RAM?

Unfortunately, no.

>=20
>> --repair should be considered as the last method.
>=20
> If --repair doesn't work, check is useless to me sadly.

Not exactly.
Although it's time consuming, I have manually patched several users fs,
which normally ends pretty well.

If it's not a wide-spread problem but some small fatal one, it may be fix=
ed.

> I know that for
> FS analysis and bug reporting, you want to have the FS without changing=

> it to something maybe worse, but for my use, if it can't be mounted and=

> can't be fixed, then it gets deleted which is even worse than check
> doing the wrong thing.
>=20
>>> The last two ERROR lines took over a day to get generated, so I'm not=
 sure if it's still working, but just slowly.
>>
>> OK, that explains something.
>>
>> One extent is referred hundreds times, no wonder it will take a long t=
ime.
>>
>> Just one tip here, there are really too many snapshots/reflinked files=
=2E
>> It's highly recommended to keep the number of snapshots to a reasonabl=
e
>> number (lower two digits).
>> Although btrfs snapshot is super fast, it puts a lot of pressure on it=
s
>> extent tree, so there is no free lunch here.
> =20
> Agreed, I doubt I have over or much over 100 snapshots though (but I
> can't check right now).
> Sadly I'm not allowed to mount even read only while check is running:
> gargamel:~# mount -o ro /dev/mapper/dshelf2 /mnt/mnt2
> mount: /dev/mapper/dshelf2 already mounted or /mnt/mnt2 busy
>=20
>>> I see. Is there any reasonably easy way to check on this running proc=
ess?
>>
>> GDB attach would be good.
>> Interrupt and check the inode number if it's checking fs tree.
>> Check the extent bytenr number if it's checking extent tree.
>>
>> But considering how many snapshots there are, it's really hard to dete=
rmine.
>>
>> In this case, the super large extent tree is causing a lot of problem,=

>> maybe it's a good idea to allow btrfs check to skip extent tree check?=

>=20
> I only see --init-extent-tree in the man page, which option did you hav=
e
> in mind?

That feature is just in my mind, not even implemented yet.

>=20
>>> Then again, maybe it already fixed enough that I can mount my filesys=
tem again.
>>
>> This needs the initial btrfs check report and the kernel messages how =
it
>> fails to mount.
>=20
> mount command hangs, kernel does not show anything special outside of d=
isk access hanging.
>=20
> Jun 23 17:23:26 gargamel kernel: [  341.802696] BTRFS warning (device d=
m-2): 'recovery' is deprecated, use 'useback
> uproot' instead
> Jun 23 17:23:26 gargamel kernel: [  341.828743] BTRFS info (device dm-2=
): trying to use backup root at mount time
> Jun 23 17:23:26 gargamel kernel: [  341.850180] BTRFS info (device dm-2=
): disk space caching is enabled
> Jun 23 17:23:26 gargamel kernel: [  341.869014] BTRFS info (device dm-2=
): has skinny extents
> Jun 23 17:23:26 gargamel kernel: [  342.206289] BTRFS info (device dm-2=
): bdev /dev/mapper/dshelf2 errs: wr 0, rd 0 , flush 0, corrupt 2, gen 0
> Jun 23 17:26:26 gargamel kernel: [  521.571392] BTRFS info (device dm-2=
): enabling ssd optimizations
> Jun 23 17:55:58 gargamel kernel: [ 2293.914867] perf: interrupt took to=
o long (2507 > 2500), lowering kernel.perf_event_max_sample_rate to 79750=

> Jun 23 17:56:22 gargamel kernel: [ 2317.718406] BTRFS info (device dm-2=
): disk space caching is enabled
> Jun 23 17:56:22 gargamel kernel: [ 2317.737277] BTRFS info (device dm-2=
): has skinny extents
> Jun 23 17:56:22 gargamel kernel: [ 2318.069461] BTRFS info (device dm-2=
): bdev /dev/mapper/dshelf2 errs: wr 0, rd 0 , flush 0, corrupt 2, gen 0
> Jun 23 17:59:22 gargamel kernel: [ 2498.256167] BTRFS info (device dm-2=
): enabling ssd optimizations
> Jun 23 18:05:23 gargamel kernel: [ 2859.107057] BTRFS info (device dm-2=
): disk space caching is enabled
> Jun 23 18:05:23 gargamel kernel: [ 2859.125883] BTRFS info (device dm-2=
): has skinny extents
> Jun 23 18:05:24 gargamel kernel: [ 2859.448018] BTRFS info (device dm-2=
): bdev /dev/mapper/dshelf2 errs: wr 0, rd 0 , flush 0, corrupt 2, gen 0

This looks like super block corruption?

What about "btrfs inspect dump-super -fFa /dev/mapper/dshelf2"?

And what about "skip_balance" mount option?

Another problem is, with so many snapshots, balance is also hugely
slowed, thus I'm not 100% sure if it's really a hang.

> Jun 23 18:08:23 gargamel kernel: [ 3039.023305] BTRFS info (device dm-2=
): enabling ssd optimizations
> Jun 23 18:13:41 gargamel kernel: [ 3356.626037] perf: interrupt took to=
o long (3143 > 3133), lowering kernel.perf_event_max_sample_rate to 63500=

> Jun 23 18:17:23 gargamel kernel: [ 3578.937225] Process accounting resu=
med
> Jun 23 18:33:47 gargamel kernel: [ 4563.356252] JFS: nTxBlock =3D 8192,=
 nTxLock =3D 65536
> Jun 23 18:33:48 gargamel kernel: [ 4563.446715] ntfs: driver 2.1.32 [Fl=
ags: R/W MODULE].
> Jun 23 18:42:20 gargamel kernel: [ 5075.995254] INFO: task sync:20253 b=
locked for more than 120 seconds.
> Jun 23 18:42:20 gargamel kernel: [ 5076.015729]       Not tainted 4.17.=
2-amd64-preempt-sysrq-20180817 #1
> Jun 23 18:42:20 gargamel kernel: [ 5076.036141] "echo 0 > /proc/sys/ker=
nel/hung_task_timeout_secs" disables this message.
> Jun 23 18:42:20 gargamel kernel: [ 5076.060637] sync            D    0 =
20253  15327 0x20020080
> Jun 23 18:42:20 gargamel kernel: [ 5076.078032] Call Trace:
> Jun 23 18:42:20 gargamel kernel: [ 5076.086366]  ? __schedule+0x53e/0x5=
9b
> Jun 23 18:42:20 gargamel kernel: [ 5076.098311]  schedule+0x7f/0x98
> Jun 23 18:42:20 gargamel kernel: [ 5076.108665]  __rwsem_down_read_fail=
ed_common+0x127/0x1a8
> Jun 23 18:42:20 gargamel kernel: [ 5076.125565]  ? sync_fs_one_sb+0x20/=
0x20
> Jun 23 18:42:20 gargamel kernel: [ 5076.137982]  ? call_rwsem_down_read=
_failed+0x14/0x30
> Jun 23 18:42:20 gargamel kernel: [ 5076.154081]  call_rwsem_down_read_f=
ailed+0x14/0x30
> Jun 23 18:42:20 gargamel kernel: [ 5076.169429]  down_read+0x13/0x25
> Jun 23 18:42:20 gargamel kernel: [ 5076.180444]  iterate_supers+0x57/0x=
be
> Jun 23 18:42:20 gargamel kernel: [ 5076.192619]  ksys_sync+0x40/0xa4
> Jun 23 18:42:20 gargamel kernel: [ 5076.203192]  __ia32_sys_sync+0xa/0x=
d
> Jun 23 18:42:20 gargamel kernel: [ 5076.214774]  do_fast_syscall_32+0xa=
f/0xf3
> Jun 23 18:42:20 gargamel kernel: [ 5076.227740]  entry_SYSENTER_compat+=
0x7f/0x91
> Jun 23 18:44:21 gargamel kernel: [ 5196.828764] INFO: task sync:20253 b=
locked for more than 120 seconds.
> Jun 23 18:44:21 gargamel kernel: [ 5196.848724]       Not tainted 4.17.=
2-amd64-preempt-sysrq-20180817 #1
> Jun 23 18:44:21 gargamel kernel: [ 5196.868789] "echo 0 > /proc/sys/ker=
nel/hung_task_timeout_secs" disables this message.
> Jun 23 18:44:21 gargamel kernel: [ 5196.893615] sync            D    0 =
20253  15327 0x20020080
>=20
>>> But back to the main point, it's sad that after so many years, the
>>> repair situation is still so suboptimal, especially when it's apparen=
tly
>>> pretty easy for btrfs to get damaged (through its own fault or not, h=
ard
>>> to say).
>>
>> Unfortunately, yes.
>> Especially the extent tree is pretty fragile and hard to repair.
>=20
> So, I don't know the code, but if I may make a suggestion (which maybe
> is totally wrong, if so forgive me):
> I would love for a repair mode that gives me a back a fixed
> filesystem. I don't really care how much data is lost (although ideally=

> it would give me a list of files lost), but I want a working filesystem=

> at the end. I can then decide if there is enough data left on it to
> restore what's missing or if I'm better off starting from scratch.

If for that usage, btrfs-restore would fit your use case more,
Unfortunately it needs extra disk space and isn't good at restoring
subvolume/snapshots.
(Although it's much faster than repairing the possible corrupted extent
tree)

>=20
> Is that possible at all?

At least for file recovery (fs tree repair), we have such behavior.

However, the problem you hit (and a lot of users hit) is all about
extent tree repair, which doesn't even goes to file recovery.

All the hassle are in extent tree, and for extent tree, it's just good
or bad. Any corruption in extent tree may lead to later bugs.
The only way to avoid extent tree problems is to mount the fs RO.

So, I'm afraid it is at least impossible for recent years.

Thanks,
Qu

>=20
> Thanks,
> Marc
>=20


--C1Rh3j1xzviIfItWba4FGOJAwUOCHWu3U--

--b6QJpFu35k1Tk4GvDw3pzgyiDgNRcs7sr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAls10bYACgkQwj2R86El
/qg9Agf/acMzwaFv2DesuSjhKh0S23z0ZwykL22n2cSOuw3gPorsQoTXUDCPHHZr
fdSnclhY4Vp2eMXG+ccxyCBNhoyn07lcD4MbvLaLHDTL2YLtBEG/irZCqzi2Djlq
uLqewq37ASfM5RQXN4AMjUlqDe9GFn88YCMdkDypV+QXICPXkpfjQWwW7RQoLFJ+
5dnUN1XSkeBmqsQrqsFH8D1LO5M8ny7t0n5/xEPm3zs2Eh7olEEkB/t7cRuM8SE5
oRlERnx6wsmndXKaFEHS296Sao8hm6DtOn8xVdteFkbcReljgtggt1rU0Vefx77b
zkTw465vM8LC2kDkzGifPWJKhxkr9g==
=OgFt
-----END PGP SIGNATURE-----

--b6QJpFu35k1Tk4GvDw3pzgyiDgNRcs7sr--
