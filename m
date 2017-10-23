Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:49381 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751198AbdJWJYG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Oct 2017 05:24:06 -0400
Subject: Re: Scrub doesn't correct coruption
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Wolf <wolf@wolfsden.cz>, linux-btrfs@vger.kernel.org
References: <20171023083933.wlm2ar5u44yjgmuq@wolfsden.cz>
 <ee364c15-5902-07de-ab66-e57e6aa02c54@gmx.com>
Message-ID: <681cc996-e3c3-060a-a584-9076eca2be32@gmx.com>
Date: Mon, 23 Oct 2017 17:23:58 +0800
MIME-Version: 1.0
In-Reply-To: <ee364c15-5902-07de-ab66-e57e6aa02c54@gmx.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="qaoMScMLjdJtWATFlPIvLpil963HQAq5P"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--qaoMScMLjdJtWATFlPIvLpil963HQAq5P
Content-Type: multipart/mixed; boundary="lf9xjeMbNtGukBKDcdiIbdJXQUIjSrwGb";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Wolf <wolf@wolfsden.cz>, linux-btrfs@vger.kernel.org
Message-ID: <681cc996-e3c3-060a-a584-9076eca2be32@gmx.com>
Subject: Re: Scrub doesn't correct coruption
References: <20171023083933.wlm2ar5u44yjgmuq@wolfsden.cz>
 <ee364c15-5902-07de-ab66-e57e6aa02c54@gmx.com>
In-Reply-To: <ee364c15-5902-07de-ab66-e57e6aa02c54@gmx.com>

--lf9xjeMbNtGukBKDcdiIbdJXQUIjSrwGb
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B410=E6=9C=8823=E6=97=A5 17:17, Qu Wenruo wrote:
>=20
>=20
> On 2017=E5=B9=B410=E6=9C=8823=E6=97=A5 16:39, Wolf wrote:
>> Hi,
>> I'm having problem with corruption in one file on my disk array. This =
is
>> third time it happened (probably). First time I didn't checked the
>> offending file so I'm not sure but it's likely. Btrfs scrub finds the
>> corruption, according to both dmesg and it's output it fixes it.
>> However, next run finds it too.
>>
>> However, according to SMART the disk appears to be healthy (see below)=
=2E
>> Plus the corruption is limited to one file.
>>
>> Is this and issue somewhere inside btrfs or is disk HW related problem=
?
>>
>> Thank you for your help :)
>>
>> W.
>>
>> smartctl -a /dev/sde
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>
>> SMART Attributes Data Structure revision number: 16
>> Vendor Specific SMART Attributes with Thresholds:
>> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDA=
TED  WHEN_FAILED RAW_VALUE
>>   1 Raw_Read_Error_Rate     0x000b   100   100   016    Pre-fail  Alwa=
ys       -       0
>>   2 Throughput_Performance  0x0005   131   131   054    Pre-fail  Offl=
ine      -       116
>>   3 Spin_Up_Time            0x0007   100   100   024    Pre-fail  Alwa=
ys       -       0
>>   4 Start_Stop_Count        0x0012   100   100   000    Old_age   Alwa=
ys       -       8
>>   5 Reallocated_Sector_Ct   0x0033   100   100   005    Pre-fail  Alwa=
ys       -       0
>>   7 Seek_Error_Rate         0x000b   100   100   067    Pre-fail  Alwa=
ys       -       0
>>   8 Seek_Time_Performance   0x0005   140   140   020    Pre-fail  Offl=
ine      -       15
>>   9 Power_On_Hours          0x0012   100   100   000    Old_age   Alwa=
ys       -       401
>>  10 Spin_Retry_Count        0x0013   100   100   060    Pre-fail  Alwa=
ys       -       0
>>  12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Alwa=
ys       -       8
>>  22 Unknown_Attribute       0x0023   100   100   025    Pre-fail  Alwa=
ys       -       100
>> 192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age   Alwa=
ys       -       33
>> 193 Load_Cycle_Count        0x0012   100   100   000    Old_age   Alwa=
ys       -       33
>> 194 Temperature_Celsius     0x0002   147   147   000    Old_age   Alwa=
ys       -       44 (Min/Max 23/46)
>> 196 Reallocated_Event_Count 0x0032   100   100   000    Old_age   Alwa=
ys       -       0
>> 197 Current_Pending_Sector  0x0022   100   100   000    Old_age   Alwa=
ys       -       0
>> 198 Offline_Uncorrectable   0x0008   100   100   000    Old_age   Offl=
ine      -       0
>> 199 UDMA_CRC_Error_Count    0x000a   200   200   000    Old_age   Alwa=
ys       -       0
>>
>> SMART Error Log Version: 1
>> No Errors Logged
>>
>> SMART Self-test log structure revision number 1
>> Num  Test_Description    Status                  Remaining  LifeTime(h=
ours)  LBA_of_first_error
>> # 1  Extended offline    Completed without error       00%       357  =
       -
>> # 2  Short offline       Completed without error       00%       335  =
       -
>>
>> uname -a
>> =3D=3D=3D=3D=3D=3D=3D=3D
>>
>> Linux ws 4.13.8-1-ARCH #1 SMP PREEMPT Wed Oct 18 11:49:44 CEST 2017 x8=
6_64 GNU/Linux
>>
>> btrfs --version
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>
>> btrfs-progs v4.13
>>
>> btrfs fi show
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>
>> Label: none  uuid: db7e86f5-649d-44ce-9514-53c7ee0fbe09
>> 	Total devices 2 FS bytes used 9.91GiB
>> 	devid    1 size 103.79GiB used 20.03GiB path /dev/mapper/storage1-roo=
t
>> 	devid    2 size 103.79GiB used 20.03GiB path /dev/mapper/storage2-roo=
t
>>
>> Label: 'RAID'  uuid: 9a4be3ac-e942-4e6a-bb24-2c4009a42572
>> 	Total devices 7 FS bytes used 6.48TiB
>> 	devid    1 size 1.82TiB used 715.03GiB path /dev/mapper/data3
>> 	devid    2 size 1.82TiB used 715.00GiB path /dev/mapper/data4
>> 	devid    3 size 2.73TiB used 1.40TiB path /dev/mapper/data2
>> 	devid    4 size 2.73TiB used 1.40TiB path /dev/mapper/data1
>> 	devid    5 size 2.73TiB used 1.40TiB path /dev/mapper/data5
>> 	devid    6 size 2.73TiB used 1.40TiB path /dev/mapper/data6
>> 	devid    7 size 7.28TiB used 5.95TiB path /dev/mapper/data7
>>
>> btrfs fi df /raid
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>
>> Data, RAID1: total=3D6.47TiB, used=3D6.47TiB
>> System, RAID1: total=3D64.00MiB, used=3D944.00KiB
>> Metadata, RAID1: total=3D9.00GiB, used=3D7.56GiB
>> GlobalReserve, single: total=3D512.00MiB, used=3D0.00B
>=20
> RAID1 for both data and meta.
> So if nothing went wrong, it should be fixed.
>=20
> And IIRC RAID1 repair is already tested and checked, so it should not
> has such problem.
>=20
>>
>> dmesg
>> =3D=3D=3D=3D=3D
>>
>> [    0.000000] microcode: microcode updated early to revision 0xba, da=
te =3D 2017-04-09
>> [    0.000000] random: get_random_bytes called from start_kernel+0x42/=
0x4b7 with crng_init=3D0
>> [    0.000000] Linux version 4.13.8-1-ARCH (builduser@tobias) (gcc ver=
sion 7.2.0 (GCC)) #1 SMP PREEMPT Wed Oct 18 11:49:44 CEST 2017
>=20
> Arch user here too.
>=20
>> [    0.000000] Command line: BOOT_IMAGE=3D/boot/vmlinuz-linux root=3DU=
UID=3Ddb7e86f5-649d-44ce-9514-53c7ee0fbe09 rw cryptdevice=3DUUID=3Deb4011=
d2-38cd-467d-b515-7acf3ef68f01:storage1:allow-discards cryptkey=3Drootfs:=
/boot/crypto_keyfile.bin cryptdevice2=3DUUID=3Ddd0821ae-8fc4-41d2-aab8-f3=
13e2f6d0e8:storage2:allow-discards cryptkey2=3Drootfs:/boot/crypto_keyfil=
e2.bin root=3D/dev/mapper/storage1-root
> [snip]
>> [ 5499.268721] lxc_bridge: port 3(vethRUY5VX) entered blocking state
>> [ 5499.268729] lxc_bridge: port 3(vethRUY5VX) entered disabled state
>> [ 5499.268759] device vethRUY5VX entered promiscuous mode
>> [ 5499.268863] IPv6: ADDRCONF(NETDEV_UP): vethRUY5VX: link is not read=
y
>> [ 5499.296331] eth0: renamed from vethTO2H20
>> [ 5499.321534] IPv6: ADDRCONF(NETDEV_CHANGE): vethRUY5VX: link becomes=
 ready
>> [ 5499.321603] lxc_bridge: port 3(vethRUY5VX) entered blocking state
>> [ 5499.321608] lxc_bridge: port 3(vethRUY5VX) entered forwarding state=

>> [22671.887860] perf: interrupt took too long (2508 > 2500), lowering k=
ernel.perf_event_max_sample_rate to 79500
>> [24159.239247] perf: interrupt took too long (3154 > 3135), lowering k=
ernel.perf_event_max_sample_rate to 63300
>> [27240.680874] perf: interrupt took too long (3952 > 3942), lowering k=
ernel.perf_event_max_sample_rate to 50400
>> [30658.875802] BTRFS warning (device dm-12): checksum error at logical=
 37889245122560 on dev /dev/mapper/data7, sector 2743145096, root 23674, =
inode 206751, offset 762638336, length 4096, links 1 (path: =E3=82=A2=E3=83=
=8B=E3=83=A1/!waiting_for_better_quality/Gate: Jieitai Kanochi nite, Kaku=
 Tatakaeri/GATE Jieitai Kanochi nite, Kaku Tatakaeri 05v2.mp4)
>=20
> Well, it's several seasons ago, and I think there are better BDrip raws=
 now.
> (Yeah, I'm also an Otaku)
>=20
> Despite that, it's better to hide such personal info though.
>=20
> And, did you tried to scrub the corrupted device other than the whole f=
s?
> Btrfs default scrub will start threads to scrub all devices at the same=

> time, maybe some concurrency caused the false alert.
>=20
>=20
> Also, it could be possible to check/repair it by using btrfs-progs.
> Although it's still out-of-tree.
>=20
> Could you please try the following branch and use "btrfs scrub start
> --offline /dev/mapper/data7" to check if it reports the corruption is
> fixable?
> https://github.com/gujx2017/btrfs-progs/tree/offline_scrub
>=20
> Offline scrub gives us a quite good reference on whether it's fixable,
> without the possible hassle in kernel.
> So it's worth trying.
>=20
> (But hey, there is better better BDrip raws already, so I don't think
> you're really interested in fixing the corruption)
>=20
> Thanks,
> Qu
>> [30658.875806] BTRFS error (device dm-12): bdev /dev/mapper/data7 errs=
: wr 0, rd 0, flush 0, corrupt 1, gen 0
>> [30658.900322] BTRFS error (device dm-12): fixed up error at logical 3=
7889245122560 on dev /dev/mapper/data7
>> [30658.902461] BTRFS warning (device dm-12): checksum error at logical=
 37889245126656 on dev /dev/mapper/data7, sector 2743145104, root 23674, =
inode 206751, offset 762642432, length 4096, links 1 (path: =E3=82=A2=E3=83=
=8B=E3=83=A1/!waiting_for_better_quality/Gate: Jieitai Kanochi nite, Kaku=
 Tatakaeri/GATE Jieitai Kanochi nite, Kaku Tatakaeri 05v2.mp4)
>> [30658.902471] BTRFS error (device dm-12): bdev /dev/mapper/data7 errs=
: wr 0, rd 0, flush 0, corrupt 2, gen 0
>> [30658.904943] BTRFS error (device dm-12): fixed up error at logical 3=
7889245126656 on dev /dev/mapper/data7
>> [30658.905427] BTRFS warning (device dm-12): checksum error at logical=
 37889245130752 on dev /dev/mapper/data7, sector 2743145112, root 23674, =
inode 206751, offset 762646528, length 4096, links 1 (path: =E3=82=A2=E3=83=
=8B=E3=83=A1/!waiting_for_better_quality/Gate: Jieitai Kanochi nite, Kaku=
 Tatakaeri/GATE Jieitai Kanochi nite, Kaku Tatakaeri 05v2.mp4)
>> [30658.905435] BTRFS error (device dm-12): bdev /dev/mapper/data7 errs=
: wr 0, rd 0, flush 0, corrupt 3, gen 0
>> [30658.908247] BTRFS error (device dm-12): fixed up error at logical 3=
7889245130752 on dev /dev/mapper/data7
>> [30658.912217] BTRFS warning (device dm-12): checksum error at logical=
 37889245134848 on dev /dev/mapper/data7, sector 2743145120, root 23674, =
inode 206751, offset 762650624, length 4096, links 1 (path: =E3=82=A2=E3=83=
=8B=E3=83=A1/!waiting_for_better_quality/Gate: Jieitai Kanochi nite, Kaku=
 Tatakaeri/GATE Jieitai Kanochi nite, Kaku Tatakaeri 05v2.mp4)
>> [30658.912226] BTRFS error (device dm-12): bdev /dev/mapper/data7 errs=
: wr 0, rd 0, flush 0, corrupt 4, gen 0
>> [30658.922809] BTRFS error (device dm-12): fixed up error at logical 3=
7889245134848 on dev /dev/mapper/data7
>> [30658.924887] BTRFS warning (device dm-12): checksum error at logical=
 37889245138944 on dev /dev/mapper/data7, sector 2743145128, root 23674, =
inode 206751, offset 762654720, length 4096, links 1 (path: =E3=82=A2=E3=83=
=8B=E3=83=A1/!waiting_for_better_quality/Gate: Jieitai Kanochi nite, Kaku=
 Tatakaeri/GATE Jieitai Kanochi nite, Kaku Tatakaeri 05v2.mp4)
>> [30658.924894] BTRFS error (device dm-12): bdev /dev/mapper/data7 errs=
: wr 0, rd 0, flush 0, corrupt 5, gen 0
>> [30658.926522] BTRFS error (device dm-12): fixed up error at logical 3=
7889245138944 on dev /dev/mapper/data7
>> [33389.149353] perf: interrupt took too long (4945 > 4940), lowering k=
ernel.perf_event_max_sample_rate to 40200
>>

BTW, what the dmesg is presenting?
The first scrub or the 2nd scrub also included?

At least from the dmesg, it's just saying 5 different blocks (20K) get
corrupted and fixed.

Without the dmesg for 2nd scrub, I can't be sure if kernel is reporting
the corruption again.

Thanks,
Qu


--lf9xjeMbNtGukBKDcdiIbdJXQUIjSrwGb--

--qaoMScMLjdJtWATFlPIvLpil963HQAq5P
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlnttS4XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjrRwf7BBs9SyV90wpiNi8VIbRLWnjx
yJV9IKtm8g4IN3JOvd3yzfBrA5KRhRN4yUZK9J6OW8NTbEuk4DwQFS5jI+xbxewL
ZB87XsW2Zlqe2Oo1kqNzfJM+M3Fyq0xxkEreyoy5/GaBT3r9hqFzIhP6XTK4NYAE
mc5ZtoPinEqvspjvVUgVH9+PB9eZ6dHyQg6R5zclwxzijv+ZgqSTH1LbupMFvW3u
40iHyB4TuB9vP/FSEKEa0iBqxJO8z7Cj6qI4MMQVWzVjb9EeOUHKVjFmOpS0XvlV
QeZwFoSQ5dSuNnU79pLgDv3O38XEFSltdCFcDPm8IatPTxAavvB/FgIWo5f59A==
=+Ke6
-----END PGP SIGNATURE-----

--qaoMScMLjdJtWATFlPIvLpil963HQAq5P--
