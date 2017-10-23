Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:55762 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750811AbdJWJRh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Oct 2017 05:17:37 -0400
Subject: Re: Scrub doesn't correct coruption
To: Wolf <wolf@wolfsden.cz>, linux-btrfs@vger.kernel.org
References: <20171023083933.wlm2ar5u44yjgmuq@wolfsden.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <ee364c15-5902-07de-ab66-e57e6aa02c54@gmx.com>
Date: Mon, 23 Oct 2017 17:17:29 +0800
MIME-Version: 1.0
In-Reply-To: <20171023083933.wlm2ar5u44yjgmuq@wolfsden.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ng1DQmwavBoJOdmrDj0xvHNXK8HaD8C9c"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ng1DQmwavBoJOdmrDj0xvHNXK8HaD8C9c
Content-Type: multipart/mixed; boundary="XVQKXoXGPjCN8GOnnnJG89DHwf2lOFDQs";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Wolf <wolf@wolfsden.cz>, linux-btrfs@vger.kernel.org
Message-ID: <ee364c15-5902-07de-ab66-e57e6aa02c54@gmx.com>
Subject: Re: Scrub doesn't correct coruption
References: <20171023083933.wlm2ar5u44yjgmuq@wolfsden.cz>
In-Reply-To: <20171023083933.wlm2ar5u44yjgmuq@wolfsden.cz>

--XVQKXoXGPjCN8GOnnnJG89DHwf2lOFDQs
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B410=E6=9C=8823=E6=97=A5 16:39, Wolf wrote:
> Hi,
> I'm having problem with corruption in one file on my disk array. This i=
s
> third time it happened (probably). First time I didn't checked the
> offending file so I'm not sure but it's likely. Btrfs scrub finds the
> corruption, according to both dmesg and it's output it fixes it.
> However, next run finds it too.
>=20
> However, according to SMART the disk appears to be healthy (see below).=

> Plus the corruption is limited to one file.
>=20
> Is this and issue somewhere inside btrfs or is disk HW related problem?=

>=20
> Thank you for your help :)
>=20
> W.
>=20
> smartctl -a /dev/sde
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> SMART Attributes Data Structure revision number: 16
> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDAT=
ED  WHEN_FAILED RAW_VALUE
>   1 Raw_Read_Error_Rate     0x000b   100   100   016    Pre-fail  Alway=
s       -       0
>   2 Throughput_Performance  0x0005   131   131   054    Pre-fail  Offli=
ne      -       116
>   3 Spin_Up_Time            0x0007   100   100   024    Pre-fail  Alway=
s       -       0
>   4 Start_Stop_Count        0x0012   100   100   000    Old_age   Alway=
s       -       8
>   5 Reallocated_Sector_Ct   0x0033   100   100   005    Pre-fail  Alway=
s       -       0
>   7 Seek_Error_Rate         0x000b   100   100   067    Pre-fail  Alway=
s       -       0
>   8 Seek_Time_Performance   0x0005   140   140   020    Pre-fail  Offli=
ne      -       15
>   9 Power_On_Hours          0x0012   100   100   000    Old_age   Alway=
s       -       401
>  10 Spin_Retry_Count        0x0013   100   100   060    Pre-fail  Alway=
s       -       0
>  12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Alway=
s       -       8
>  22 Unknown_Attribute       0x0023   100   100   025    Pre-fail  Alway=
s       -       100
> 192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age   Alway=
s       -       33
> 193 Load_Cycle_Count        0x0012   100   100   000    Old_age   Alway=
s       -       33
> 194 Temperature_Celsius     0x0002   147   147   000    Old_age   Alway=
s       -       44 (Min/Max 23/46)
> 196 Reallocated_Event_Count 0x0032   100   100   000    Old_age   Alway=
s       -       0
> 197 Current_Pending_Sector  0x0022   100   100   000    Old_age   Alway=
s       -       0
> 198 Offline_Uncorrectable   0x0008   100   100   000    Old_age   Offli=
ne      -       0
> 199 UDMA_CRC_Error_Count    0x000a   200   200   000    Old_age   Alway=
s       -       0
>=20
> SMART Error Log Version: 1
> No Errors Logged
>=20
> SMART Self-test log structure revision number 1
> Num  Test_Description    Status                  Remaining  LifeTime(ho=
urs)  LBA_of_first_error
> # 1  Extended offline    Completed without error       00%       357   =
      -
> # 2  Short offline       Completed without error       00%       335   =
      -
>=20
> uname -a
> =3D=3D=3D=3D=3D=3D=3D=3D
>=20
> Linux ws 4.13.8-1-ARCH #1 SMP PREEMPT Wed Oct 18 11:49:44 CEST 2017 x86=
_64 GNU/Linux
>=20
> btrfs --version
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> btrfs-progs v4.13
>=20
> btrfs fi show
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> Label: none  uuid: db7e86f5-649d-44ce-9514-53c7ee0fbe09
> 	Total devices 2 FS bytes used 9.91GiB
> 	devid    1 size 103.79GiB used 20.03GiB path /dev/mapper/storage1-root=

> 	devid    2 size 103.79GiB used 20.03GiB path /dev/mapper/storage2-root=

>=20
> Label: 'RAID'  uuid: 9a4be3ac-e942-4e6a-bb24-2c4009a42572
> 	Total devices 7 FS bytes used 6.48TiB
> 	devid    1 size 1.82TiB used 715.03GiB path /dev/mapper/data3
> 	devid    2 size 1.82TiB used 715.00GiB path /dev/mapper/data4
> 	devid    3 size 2.73TiB used 1.40TiB path /dev/mapper/data2
> 	devid    4 size 2.73TiB used 1.40TiB path /dev/mapper/data1
> 	devid    5 size 2.73TiB used 1.40TiB path /dev/mapper/data5
> 	devid    6 size 2.73TiB used 1.40TiB path /dev/mapper/data6
> 	devid    7 size 7.28TiB used 5.95TiB path /dev/mapper/data7
>=20
> btrfs fi df /raid
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> Data, RAID1: total=3D6.47TiB, used=3D6.47TiB
> System, RAID1: total=3D64.00MiB, used=3D944.00KiB
> Metadata, RAID1: total=3D9.00GiB, used=3D7.56GiB
> GlobalReserve, single: total=3D512.00MiB, used=3D0.00B

RAID1 for both data and meta.
So if nothing went wrong, it should be fixed.

And IIRC RAID1 repair is already tested and checked, so it should not
has such problem.

>=20
> dmesg
> =3D=3D=3D=3D=3D
>=20
> [    0.000000] microcode: microcode updated early to revision 0xba, dat=
e =3D 2017-04-09
> [    0.000000] random: get_random_bytes called from start_kernel+0x42/0=
x4b7 with crng_init=3D0
> [    0.000000] Linux version 4.13.8-1-ARCH (builduser@tobias) (gcc vers=
ion 7.2.0 (GCC)) #1 SMP PREEMPT Wed Oct 18 11:49:44 CEST 2017

Arch user here too.

> [    0.000000] Command line: BOOT_IMAGE=3D/boot/vmlinuz-linux root=3DUU=
ID=3Ddb7e86f5-649d-44ce-9514-53c7ee0fbe09 rw cryptdevice=3DUUID=3Deb4011d=
2-38cd-467d-b515-7acf3ef68f01:storage1:allow-discards cryptkey=3Drootfs:/=
boot/crypto_keyfile.bin cryptdevice2=3DUUID=3Ddd0821ae-8fc4-41d2-aab8-f31=
3e2f6d0e8:storage2:allow-discards cryptkey2=3Drootfs:/boot/crypto_keyfile=
2.bin root=3D/dev/mapper/storage1-root
[snip]
> [ 5499.268721] lxc_bridge: port 3(vethRUY5VX) entered blocking state
> [ 5499.268729] lxc_bridge: port 3(vethRUY5VX) entered disabled state
> [ 5499.268759] device vethRUY5VX entered promiscuous mode
> [ 5499.268863] IPv6: ADDRCONF(NETDEV_UP): vethRUY5VX: link is not ready=

> [ 5499.296331] eth0: renamed from vethTO2H20
> [ 5499.321534] IPv6: ADDRCONF(NETDEV_CHANGE): vethRUY5VX: link becomes =
ready
> [ 5499.321603] lxc_bridge: port 3(vethRUY5VX) entered blocking state
> [ 5499.321608] lxc_bridge: port 3(vethRUY5VX) entered forwarding state
> [22671.887860] perf: interrupt took too long (2508 > 2500), lowering ke=
rnel.perf_event_max_sample_rate to 79500
> [24159.239247] perf: interrupt took too long (3154 > 3135), lowering ke=
rnel.perf_event_max_sample_rate to 63300
> [27240.680874] perf: interrupt took too long (3952 > 3942), lowering ke=
rnel.perf_event_max_sample_rate to 50400
> [30658.875802] BTRFS warning (device dm-12): checksum error at logical =
37889245122560 on dev /dev/mapper/data7, sector 2743145096, root 23674, i=
node 206751, offset 762638336, length 4096, links 1 (path: =E3=82=A2=E3=83=
=8B=E3=83=A1/!waiting_for_better_quality/Gate: Jieitai Kanochi nite, Kaku=
 Tatakaeri/GATE Jieitai Kanochi nite, Kaku Tatakaeri 05v2.mp4)

Well, it's several seasons ago, and I think there are better BDrip raws n=
ow.
(Yeah, I'm also an Otaku)

Despite that, it's better to hide such personal info though.

And, did you tried to scrub the corrupted device other than the whole fs?=

Btrfs default scrub will start threads to scrub all devices at the same
time, maybe some concurrency caused the false alert.


Also, it could be possible to check/repair it by using btrfs-progs.
Although it's still out-of-tree.

Could you please try the following branch and use "btrfs scrub start
--offline /dev/mapper/data7" to check if it reports the corruption is
fixable?
https://github.com/gujx2017/btrfs-progs/tree/offline_scrub

Offline scrub gives us a quite good reference on whether it's fixable,
without the possible hassle in kernel.
So it's worth trying.

(But hey, there is better better BDrip raws already, so I don't think
you're really interested in fixing the corruption)

Thanks,
Qu
> [30658.875806] BTRFS error (device dm-12): bdev /dev/mapper/data7 errs:=
 wr 0, rd 0, flush 0, corrupt 1, gen 0
> [30658.900322] BTRFS error (device dm-12): fixed up error at logical 37=
889245122560 on dev /dev/mapper/data7
> [30658.902461] BTRFS warning (device dm-12): checksum error at logical =
37889245126656 on dev /dev/mapper/data7, sector 2743145104, root 23674, i=
node 206751, offset 762642432, length 4096, links 1 (path: =E3=82=A2=E3=83=
=8B=E3=83=A1/!waiting_for_better_quality/Gate: Jieitai Kanochi nite, Kaku=
 Tatakaeri/GATE Jieitai Kanochi nite, Kaku Tatakaeri 05v2.mp4)
> [30658.902471] BTRFS error (device dm-12): bdev /dev/mapper/data7 errs:=
 wr 0, rd 0, flush 0, corrupt 2, gen 0
> [30658.904943] BTRFS error (device dm-12): fixed up error at logical 37=
889245126656 on dev /dev/mapper/data7
> [30658.905427] BTRFS warning (device dm-12): checksum error at logical =
37889245130752 on dev /dev/mapper/data7, sector 2743145112, root 23674, i=
node 206751, offset 762646528, length 4096, links 1 (path: =E3=82=A2=E3=83=
=8B=E3=83=A1/!waiting_for_better_quality/Gate: Jieitai Kanochi nite, Kaku=
 Tatakaeri/GATE Jieitai Kanochi nite, Kaku Tatakaeri 05v2.mp4)
> [30658.905435] BTRFS error (device dm-12): bdev /dev/mapper/data7 errs:=
 wr 0, rd 0, flush 0, corrupt 3, gen 0
> [30658.908247] BTRFS error (device dm-12): fixed up error at logical 37=
889245130752 on dev /dev/mapper/data7
> [30658.912217] BTRFS warning (device dm-12): checksum error at logical =
37889245134848 on dev /dev/mapper/data7, sector 2743145120, root 23674, i=
node 206751, offset 762650624, length 4096, links 1 (path: =E3=82=A2=E3=83=
=8B=E3=83=A1/!waiting_for_better_quality/Gate: Jieitai Kanochi nite, Kaku=
 Tatakaeri/GATE Jieitai Kanochi nite, Kaku Tatakaeri 05v2.mp4)
> [30658.912226] BTRFS error (device dm-12): bdev /dev/mapper/data7 errs:=
 wr 0, rd 0, flush 0, corrupt 4, gen 0
> [30658.922809] BTRFS error (device dm-12): fixed up error at logical 37=
889245134848 on dev /dev/mapper/data7
> [30658.924887] BTRFS warning (device dm-12): checksum error at logical =
37889245138944 on dev /dev/mapper/data7, sector 2743145128, root 23674, i=
node 206751, offset 762654720, length 4096, links 1 (path: =E3=82=A2=E3=83=
=8B=E3=83=A1/!waiting_for_better_quality/Gate: Jieitai Kanochi nite, Kaku=
 Tatakaeri/GATE Jieitai Kanochi nite, Kaku Tatakaeri 05v2.mp4)
> [30658.924894] BTRFS error (device dm-12): bdev /dev/mapper/data7 errs:=
 wr 0, rd 0, flush 0, corrupt 5, gen 0
> [30658.926522] BTRFS error (device dm-12): fixed up error at logical 37=
889245138944 on dev /dev/mapper/data7
> [33389.149353] perf: interrupt took too long (4945 > 4940), lowering ke=
rnel.perf_event_max_sample_rate to 40200
>=20


--XVQKXoXGPjCN8GOnnnJG89DHwf2lOFDQs--

--ng1DQmwavBoJOdmrDj0xvHNXK8HaD8C9c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlnts6kXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qh/Vwf9GVGJa9JXE5xwFXlH+FLODNIg
c0vsZO35mXO8C+LxG6wTcLvJW7tOOiz9ZaARJNfZwI9UrLl9v0ZME1icLI2r2MGp
F7dTdzvwhGlw9/UeVGN9GTicuxVIpdqsTusl4GH+pBA2YhNGU5UohOfdfZWNzP9t
vf2UlR1KDVAWDJmGjl+sIdofNYz85lkgxs7lhJXdKVNliGQyo3ytrWSrNnzcatP3
2n29aRcE3GnZRRpz9nfDWonelh2vItHUTKhuJzKSj176OIl6zk4WCXJUNPbK7xG5
+mu47PLRvKn1tzW7yV1kuwLD0+b0PfoCzDMFs/O2EreXeCiSyKw6HKPe6lBaaA==
=RsDg
-----END PGP SIGNATURE-----

--ng1DQmwavBoJOdmrDj0xvHNXK8HaD8C9c--
