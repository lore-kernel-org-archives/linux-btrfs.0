Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.crc.id.au ([203.56.246.92]:34196 "EHLO mail.crc.id.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787AbcFXRFT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jun 2016 13:05:19 -0400
Received: from [IPv6:2407:e400:b000:201:c8d9:fa83:ce8e:757d] (unknown [IPv6:2407:e400:b000:201:c8d9:fa83:ce8e:757d])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.crc.id.au (Postfix) with ESMTPSA id 298283A005C
	for <linux-btrfs@vger.kernel.org>; Sat, 25 Jun 2016 03:05:15 +1000 (AEST)
Subject: Re: Trying to rescue my data :(
To: linux-btrfs@vger.kernel.org
References: <15415597-7f29-396e-8425-8cbbeb32e897@crc.id.au>
 <4e1bff4c-3cfc-4391-d093-8293bf29e795@crc.id.au>
 <CAN05THTxMBrP-JV7atjdskfDYybwmEAV61EDkWRW_Yk70Cfdjg@mail.gmail.com>
From: Steven Haigh <netwiz@crc.id.au>
Message-ID: <dd7fd123-c3a2-7ad0-bf22-a67a1b1a97d7@crc.id.au>
Date: Sat, 25 Jun 2016 03:05:12 +1000
MIME-Version: 1.0
In-Reply-To: <CAN05THTxMBrP-JV7atjdskfDYybwmEAV61EDkWRW_Yk70Cfdjg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="KDiVEcDR6BV0SCGWbU03E663WdfTX6AAb"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--KDiVEcDR6BV0SCGWbU03E663WdfTX6AAb
Content-Type: multipart/mixed; boundary="jg9N03UG3uWH0MMxTuqs0oHBm0rsanNg6"
From: Steven Haigh <netwiz@crc.id.au>
To: linux-btrfs@vger.kernel.org
Message-ID: <dd7fd123-c3a2-7ad0-bf22-a67a1b1a97d7@crc.id.au>
Subject: Re: Trying to rescue my data :(
References: <15415597-7f29-396e-8425-8cbbeb32e897@crc.id.au>
 <4e1bff4c-3cfc-4391-d093-8293bf29e795@crc.id.au>
 <CAN05THTxMBrP-JV7atjdskfDYybwmEAV61EDkWRW_Yk70Cfdjg@mail.gmail.com>
In-Reply-To: <CAN05THTxMBrP-JV7atjdskfDYybwmEAV61EDkWRW_Yk70Cfdjg@mail.gmail.com>

--jg9N03UG3uWH0MMxTuqs0oHBm0rsanNg6
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 25/06/16 02:59, ronnie sahlberg wrote:
> What I would do in this situation :
>=20
> 1, Immediately stop writing to these disks/filesystem. ONLY access it
> in read-only mode until you have salvaged what can be salvaged.

That's ok - I can't even mount it in RW mode :)

> 2, get a new 5T UDB drive (they are cheap) and copy file by file off th=
e array.

I've actually got enough combined space to store stuff places in the
mean time...

> 3, when you hit files that cause panics, make a node of the inode and
> avoid touching that file again.

What I have in mind here is that a file seems to get CREATED when I copy
the file that crashes the system in the target directory. I'm thinking
if I 'cp -an source/ target/' that it will make this somewhat easier (it
won't overwrite the zero byte file).

> Will likely take a lot of work and time since I suspect it is a
> largely manual process. But if the data is important ...

Yeah - there's only about 80Gb on the array that I *really* care about -
the rest is just a bonus if its there - not rage-worthy :P

> Once you have all salvageable data copied to the new drive you can
> decide on how to proceed.
> I.e. if you want to try to repair the filesystem (I have low
> confidence in this for parity raid case) or if you will simply rebuild
> a new fs from scratch.

I honestly think it'll be scorched earth and start again with a new FS.
I'm thinking of going back to mdadm for the RAID (which has worked
perfectly for years) and using maybe a vanilla BTRFS on top of that
block device.

Anything else seems like too much work for too little reward - and lack
of confidence.

> On Fri, Jun 24, 2016 at 9:26 AM, Steven Haigh <netwiz@crc.id.au> wrote:=

>> On 25/06/16 00:52, Steven Haigh wrote:
>>> Ok, so I figured that despite what the BTRFS wiki seems to imply, the=

>>> 'multi parity' support just isn't stable enough to be used. So, I'm
>>> trying to revert to what I had before.
>>>
>>> My setup consist of:
>>>       * 2 x 3Tb drives +
>>>       * 3 x 2Tb drives.
>>>
>>> I've got (had?) about 4.9Tb of data.
>>>
>>> My idea was to convert the existing setup using a balance to a 'singl=
e'
>>> setup, delete the 3 x 2Tb drives from the BTRFS system, then create a=

>>> new mdadm based RAID6 (5 drives degraded to 3), create a new filesyst=
em
>>> on that, then copy the data across.
>>>
>>> So, great - first the balance:
>>> $ btrfs balance start -dconvert=3Dsingle -mconvert=3Dsingle -f (yes, =
I know
>>> it'll reduce the metadata redundancy).
>>>
>>> This promptly was followed by a system crash.
>>>
>>> After a reboot, I can no longer mount the BTRFS in read-write:
>>> [  134.768908] BTRFS info (device xvdd): disk space caching is enable=
d
>>> [  134.769032] BTRFS: has skinny extents
>>> [  134.769856] BTRFS: failed to read the system array on xvdd
>>> [  134.776055] BTRFS: open_ctree failed
>>> [  143.900055] BTRFS info (device xvdd): allowing degraded mounts
>>> [  143.900152] BTRFS info (device xvdd): not using ssd allocation sch=
eme
>>> [  143.900243] BTRFS info (device xvdd): disk space caching is enable=
d
>>> [  143.900330] BTRFS: has skinny extents
>>> [  143.901860] BTRFS warning (device xvdd): devid 4 uuid
>>> 61ccce61-9787-453e-b793-1b86f8015ee1 is missing
>>> [  146.539467] BTRFS: missing devices(1) exceeds the limit(0), writea=
ble
>>> mount is not allowed
>>> [  146.552051] BTRFS: open_ctree failed
>>>
>>> I can mount it read only - but then I also get crashes when it seems =
to
>>> hit a read error:
>>> BTRFS info (device xvdc): csum failed ino 42179 extent 8690008064
>>> csum 3245290974 wanted 982056704 mirror 0
>>> BTRFS info (device xvdc): csum failed ino 42179 extent 8690008064 csu=
m
>>> 390821102 wanted 982056704 mirror 1
>>> BTRFS info (device xvdc): csum failed ino 42179 extent 8690008064 csu=
m
>>> 550556475 wanted 982056704 mirror 1
>>> BTRFS info (device xvdc): csum failed ino 42179 extent 8690008064 csu=
m
>>> 1279883714 wanted 982056704 mirror 1
>>> BTRFS info (device xvdc): csum failed ino 42179 extent 8690008064 csu=
m
>>> 2566472073 wanted 982056704 mirror 1
>>> BTRFS info (device xvdc): csum failed ino 42179 extent 8690008064 csu=
m
>>> 1876236691 wanted 982056704 mirror 1
>>> BTRFS info (device xvdc): csum failed ino 42179 extent 8690008064 csu=
m
>>> 3350537857 wanted 982056704 mirror 1
>>> BTRFS info (device xvdc): csum failed ino 42179 extent 8690008064 csu=
m
>>> 3319706190 wanted 982056704 mirror 1
>>> BTRFS info (device xvdc): csum failed ino 42179 extent 8690008064 csu=
m
>>> 2377458007 wanted 982056704 mirror 1
>>> BTRFS info (device xvdc): csum failed ino 42179 extent 8690008064 csu=
m
>>> 2066127208 wanted 982056704 mirror 1
>>> BTRFS info (device xvdc): csum failed ino 42179 extent 8690008064 csu=
m
>>> 657140479 wanted 982056704 mirror 1
>>> BTRFS info (device xvdc): csum failed ino 42179 extent 8690008064 csu=
m
>>> 1239359620 wanted 982056704 mirror 1
>>> BTRFS info (device xvdc): csum failed ino 42179 extent 8690008064 csu=
m
>>> 1598877324 wanted 982056704 mirror 1
>>> BTRFS info (device xvdc): csum failed ino 42179 extent 8690008064 csu=
m
>>> 1082738394 wanted 982056704 mirror 1
>>> BTRFS info (device xvdc): csum failed ino 42179 extent 8690008064 csu=
m
>>> 371906697 wanted 982056704 mirror 1
>>> BTRFS info (device xvdc): csum failed ino 42179 extent 8690008064 csu=
m
>>> 2156787247 wanted 982056704 mirror 1
>>> BTRFS info (device xvdc): csum failed ino 42179 extent 8690008064 csu=
m
>>> 3777709399 wanted 982056704 mirror 1
>>> BTRFS info (device xvdc): csum failed ino 42179 extent 8690008064 csu=
m
>>> 180814340 wanted 982056704 mirror 1
>>> ------------[ cut here ]------------
>>> kernel BUG at fs/btrfs/extent_io.c:2401!
>>> invalid opcode: 0000 [#1] SMP
>>> Modules linked in: btrfs x86_pkg_temp_thermal coretemp crct10dif_pclm=
ul
>>> xor aesni_intel aes_x86_64 lrw gf128mul glue_helper pcspkr raid6_pq
>>> ablk_helper cryptd nfsd auth_rpcgss nfs_acl lockd grace sunrpc ip_tab=
les
>>> xen_netfront crc32c_intel xen_gntalloc xen_evtchn ipv6 autofs4
>>> BTRFS info (device xvdc): csum failed ino 42179 extent 8690008064 csu=
m
>>> 2610978113 wanted 982056704 mirror 1
>>> BTRFS info (device xvdc): csum failed ino 42179 extent 8690008064 csu=
m
>>> 59610051 wanted 982056704 mirror 1
>>> CPU: 1 PID: 1273 Comm: kworker/u4:4 Not tainted 4.4.13-1.el7xen.x86_6=
4 #1
>>> Workqueue: btrfs-endio btrfs_endio_helper [btrfs]
>>> task: ffff880079ce12c0 ti: ffff880078788000 task.ti: ffff880078788000=

>>> RIP: e030:[<ffffffffa039e0e0>]  [<ffffffffa039e0e0>]
>>> btrfs_check_repairable+0x100/0x110 [btrfs]
>>> RSP: e02b:ffff88007878bcc8  EFLAGS: 00010297
>>> RAX: 0000000000000001 RBX: ffff880079db2080 RCX: 0000000000000003
>>> RDX: 0000000000000003 RSI: 000004db13730000 RDI: ffff88007889ef38
>>> RBP: ffff88007878bce0 R08: 000004db01c00000 R09: 000004dbc1c00000
>>> R10: ffff88006bb0c1b8 R11: 0000000000000000 R12: 0000000000000000
>>> R13: ffff88007b213ea8 R14: 0000000000001000 R15: 0000000000000000
>>> FS:  00007fbf2fdc0880(0000) GS:ffff88007f500000(0000) knlGS:000000000=
0000000
>>> CS:  e033 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> CR2: 00007fbf2d96702b CR3: 000000007969f000 CR4: 0000000000042660
>>> Stack:
>>>  ffffea00019db180 0000000000010000 ffff88007b213f30 ffff88007878bd88
>>>  ffffffffa03a0808 ffff880002d15500 ffff88007878bd18 ffff880079ce12c0
>>>  ffff88007b213e40 000000000000001f ffff880000000000 ffff88006bb0c048
>>> Call Trace:
>>>  [<ffffffffa03a0808>] end_bio_extent_readpage+0x428/0x560 [btrfs]
>>>  [<ffffffff812f40c0>] bio_endio+0x40/0x60
>>>  [<ffffffffa0375a6c>] end_workqueue_fn+0x3c/0x40 [btrfs]
>>>  [<ffffffffa03af3f1>] normal_work_helper+0xc1/0x300 [btrfs]
>>>  [<ffffffff810a1352>] ? finish_task_switch+0x82/0x280
>>>  [<ffffffffa03af702>] btrfs_endio_helper+0x12/0x20 [btrfs]
>>>  [<ffffffff81093844>] process_one_work+0x154/0x400
>>>  [<ffffffff8109438a>] worker_thread+0x11a/0x460
>>>  [<ffffffff8165a24f>] ? __schedule+0x2bf/0x880
>>>  [<ffffffff81094270>] ? rescuer_thread+0x2f0/0x2f0
>>>  [<ffffffff810993f9>] kthread+0xc9/0xe0
>>>  [<ffffffff81099330>] ? kthread_park+0x60/0x60
>>>  [<ffffffff8165e14f>] ret_from_fork+0x3f/0x70
>>>  [<ffffffff81099330>] ? kthread_park+0x60/0x60
>>> Code: 00 31 c0 eb d5 8d 48 02 eb d9 31 c0 45 89 e0 48 c7 c6 a0 f8 3f =
a0
>>> 48 c7 c7 00 05 41 a0 e8 c9 f2 fa e0 31 c0 e9 70 ff ff ff 0f 0b <0f> 0=
b
>>> 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90
>>> RIP  [<ffffffffa039e0e0>] btrfs_check_repairable+0x100/0x110 [btrfs]
>>>  RSP <ffff88007878bcc8>
>>> ------------[ cut here ]------------
>>> <more crashes until the system hangs>
>>>
>>> So, where to from here? Sadly, I feel there is data loss in my future=
,
>>> but not sure how to minimise this :\
>>>
>>
>> The more I look at this, the more I'm wondering if this is a total
>> corruption scenario:
>>
>> $ btrfs restore -D -l /dev/xvdc
>> warning, device 4 is missing
>> checksum verify failed on 11224137433088 found EF5DE164 wanted 62BE232=
2
>> bytenr mismatch, want=3D11224137433088, have=3D11224137564160
>> Couldn't read chunk tree
>> Could not open root, trying backup super
>> warning, device 2 is missing
>> warning, device 4 is missing
>> warning, device 5 is missing
>> warning, device 3 is missing
>> checksum verify failed on 11224137433088 found EF5DE164 wanted 62BE232=
2
>> checksum verify failed on 11224137433088 found EF5DE164 wanted 62BE232=
2
>> bytenr mismatch, want=3D11224137433088, have=3D59973363410688
>> Couldn't read chunk tree
>> Could not open root, trying backup super
>> warning, device 2 is missing
>> warning, device 4 is missing
>> warning, device 5 is missing
>> warning, device 3 is missing
>> checksum verify failed on 11224137433088 found EF5DE164 wanted 62BE232=
2
>> checksum verify failed on 11224137433088 found EF5DE164 wanted 62BE232=
2
>> bytenr mismatch, want=3D11224137433088, have=3D59973363410688
>> Couldn't read chunk tree
>> Could not open root, trying backup super
>>
>> $ btrfs restore -D -l /dev/xvdd
>> warning, device 4 is missing
>> checksum verify failed on 11224137433088 found EF5DE164 wanted 62BE232=
2
>> bytenr mismatch, want=3D11224137433088, have=3D11224137564160
>> Couldn't read chunk tree
>> Could not open root, trying backup super
>> warning, device 1 is missing
>> warning, device 4 is missing
>> warning, device 5 is missing
>> warning, device 3 is missing
>> bytenr mismatch, want=3D11224137170944, have=3D0
>> ERROR: cannot read chunk root
>> Could not open root, trying backup super
>> warning, device 1 is missing
>> warning, device 4 is missing
>> warning, device 5 is missing
>> warning, device 3 is missing
>> bytenr mismatch, want=3D11224137170944, have=3D0
>> ERROR: cannot read chunk root
>> Could not open root, trying backup super
>>
>> $ btrfs restore -D -l /dev/xvde
>> warning, device 4 is missing
>> checksum verify failed on 11224137433088 found EF5DE164 wanted 62BE232=
2
>> bytenr mismatch, want=3D11224137433088, have=3D11224137564160
>> Couldn't read chunk tree
>> Could not open root, trying backup super
>> warning, device 1 is missing
>> warning, device 2 is missing
>> warning, device 4 is missing
>> warning, device 5 is missing
>> checksum verify failed on 11224137170944 found C9115A93 wanted 14526E2=
8
>> checksum verify failed on 11224137170944 found C9115A93 wanted 14526E2=
8
>> bytenr mismatch, want=3D11224137170944, have=3D59973365311232
>> ERROR: cannot read chunk root
>> Could not open root, trying backup super
>> warning, device 1 is missing
>> warning, device 2 is missing
>> warning, device 4 is missing
>> warning, device 5 is missing
>> checksum verify failed on 11224137170944 found C9115A93 wanted 14526E2=
8
>> checksum verify failed on 11224137170944 found C9115A93 wanted 14526E2=
8
>> bytenr mismatch, want=3D11224137170944, have=3D59973365311232
>> ERROR: cannot read chunk root
>> Could not open root, trying backup super
>>
>> $ btrfs restore -D -l /dev/xvdf
>> warning, device 4 is missing
>> checksum verify failed on 11224137433088 found EF5DE164 wanted 62BE232=
2
>> bytenr mismatch, want=3D11224137433088, have=3D11224137564160
>> Couldn't read chunk tree
>> Could not open root, trying backup super
>> warning, device 1 is missing
>> warning, device 2 is missing
>> warning, device 4 is missing
>> warning, device 5 is missing
>> warning, device 3 is missing
>> bytenr mismatch, want=3D11224137170944, have=3D0
>> ERROR: cannot read chunk root
>> Could not open root, trying backup super
>> warning, device 1 is missing
>> warning, device 2 is missing
>> warning, device 4 is missing
>> warning, device 5 is missing
>> warning, device 3 is missing
>> bytenr mismatch, want=3D11224137170944, have=3D0
>> ERROR: cannot read chunk root
>> Could not open root, trying backup super
>>
>> $ btrfs restore -D -l /dev/xvdg
>> warning, device 4 is missing
>> checksum verify failed on 11224137433088 found EF5DE164 wanted 62BE232=
2
>> bytenr mismatch, want=3D11224137433088, have=3D11224137564160
>> Couldn't read chunk tree
>> Could not open root, trying backup super
>> warning, device 1 is missing
>> warning, device 2 is missing
>> warning, device 4 is missing
>> warning, device 3 is missing
>> bytenr mismatch, want=3D11224137170944, have=3D11224137105408
>> ERROR: cannot read chunk root
>> Could not open root, trying backup super
>> warning, device 1 is missing
>> warning, device 2 is missing
>> warning, device 4 is missing
>> warning, device 3 is missing
>> bytenr mismatch, want=3D11224137170944, have=3D11224137105408
>> ERROR: cannot read chunk root
>> Could not open root, trying backup super
>>
>> If I mount it read only:
>> $ mount -o nossd,degraded,ro /dev/xvdc /mnt/fileshare/
>>
>> $ btrfs device usage /mnt/fileshare/
>>
>> /dev/xvdc, ID: 1
>>    Device size:             2.73TiB
>>    Device slack:              0.00B
>>    Data,single:             5.00GiB
>>    Data,RAID6:              1.60TiB
>>    Data,RAID6:              2.75GiB
>>    Data,RAID6:              1.00GiB
>>    Metadata,RAID6:          2.06GiB
>>    System,RAID6:           32.00MiB
>>    Unallocated:             1.12TiB
>>
>> /dev/xvdd, ID: 2
>>    Device size:             2.73TiB
>>    Device slack:              0.00B
>>    Data,single:             1.00GiB
>>    Data,RAID6:              1.60TiB
>>    Data,RAID6:              7.07GiB
>>    Data,RAID6:              1.00GiB
>>    Metadata,RAID6:          2.06GiB
>>    System,RAID6:           32.00MiB
>>    Unallocated:             1.12TiB
>>
>> /dev/xvde, ID: 3
>>    Device size:             1.82TiB
>>    Device slack:              0.00B
>>    Data,RAID6:              1.60TiB
>>    Data,RAID6:              7.07GiB
>>    Metadata,RAID6:          2.06GiB
>>    System,RAID6:           32.00MiB
>>    Unallocated:           213.23GiB
>>
>> /dev/xvdf, ID: 6
>>    Device size:             1.82TiB
>>    Device slack:              0.00B
>>    Data,RAID6:            882.62GiB
>>    Data,RAID6:              1.00GiB
>>    Metadata,RAID6:          2.06GiB
>>    Unallocated:           977.33GiB
>>
>> /dev/xvdg, ID: 5
>>    Device size:             1.82TiB
>>    Device slack:              0.00B
>>    Data,RAID6:              1.60TiB
>>    Data,RAID6:              7.07GiB
>>    Metadata,RAID6:          2.06GiB
>>    System,RAID6:           32.00MiB
>>    Unallocated:           213.23GiB
>>
>> missing, ID: 4
>>    Device size:               0.00B
>>    Device slack:           16.00EiB
>>    Data,RAID6:            758.00GiB
>>    Data,RAID6:              4.31GiB
>>    System,RAID6:           32.00MiB
>>    Unallocated:             1.07TiB
>>
>> Hoping this isn't a total loss ;)
>>
>> --
>> Steven Haigh
>>
>> Email: netwiz@crc.id.au
>> Web: https://www.crc.id.au
>> Phone: (03) 9001 6090 - 0412 935 897
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--=20
Steven Haigh

Email: netwiz@crc.id.au
Web: https://www.crc.id.au
Phone: (03) 9001 6090 - 0412 935 897


--jg9N03UG3uWH0MMxTuqs0oHBm0rsanNg6--

--KDiVEcDR6BV0SCGWbU03E663WdfTX6AAb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXbWhIAAoJEEGvNdV6fTHch+wP/09oA414p22dH/pY6lS1zGWb
bwf2CmIinPeLvnKbZDEH2poKa+1vZ3TXWyjLvrtPhbYwr6mWmhDZ1UdhsFkAv1Zy
2axDkH3u2466IhCYJWY2K0T+mfCBlky4Owj1ZpHtDxkQYspaqUJbJ4eVB6EtfhZs
mddRVqV8Sj7VnvCl/l4whbY5IRWf9v6u6J41DF9rLC9O0uI9RS3YraJMXsA2FTGH
7QL2AcnzZjARLJ1VG56bUhKROxLVMVHJToHq/a9OwtQKWsXMqHRcqZmDlkE0CXut
sK1Fh48Lyr3HmqyVrf5SxxjGbinLiPNZYZ1k2/sHYTh8iOSv32QImmEkx9/nXEnf
nCQfWySYIcmdBwSkQyc0+lR4MAe44dBNzJTZm2TLRAR+K3j93mRQGU9MpABiBu+3
qodBYON1JE6cKo5Up30x55auSeWElL3pPWmLtIDlkglLLD6MfaW7zkKA7nLxoMXY
fWz1QdUdXUgIv+gPpo6wHjVFUCJNxJ2zIC3IetFI3pO+Jbvo6evEAlM/ZT/gjCu0
Yqo/FIL1nq9IeDSpr2y3bVrdCbvZJfcTAf2ZqOI8qBiO24XVC2xokENHpk9QeMAQ
gpMr+cGAG4U8XyKXYvMR6QzApc6RlwnDuqfIj+6GPrVKaIVrXW328TLmSecSmmZ3
AJ+5YpdHYPsCXohMYq6Z
=ELQX
-----END PGP SIGNATURE-----

--KDiVEcDR6BV0SCGWbU03E663WdfTX6AAb--
