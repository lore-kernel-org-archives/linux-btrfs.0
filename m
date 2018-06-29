Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:34431 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751750AbeF2HUt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Jun 2018 03:20:49 -0400
Subject: Re: So, does btrfs check lowmem take days? weeks?
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs@vger.kernel.org
References: <20180629042707.vrjwbytg6bxmrgjg@merlins.org>
 <6658a593-3b4a-f1ef-f550-2fb951b2517d@gmx.com>
 <20180629052825.tifg2aw7oy3qyyvw@merlins.org>
 <3b240898-a96d-77f6-efb9-f0af81ee0cd1@gmx.com>
 <20180629060657.qrtcxfcy22zkstfw@merlins.org>
 <e9264580-7853-fbfc-2c90-e28e8a45daf5@gmx.com>
 <20180629065903.xgwpvaa2vuiys75r@merlins.org>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <6a86d5d5-1d67-f34b-f809-b4e534485f3e@gmx.com>
Date: Fri, 29 Jun 2018 15:20:42 +0800
MIME-Version: 1.0
In-Reply-To: <20180629065903.xgwpvaa2vuiys75r@merlins.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="UnkxdleUsyzamd0xVQ2lqWsgHQ6PY7IQi"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--UnkxdleUsyzamd0xVQ2lqWsgHQ6PY7IQi
Content-Type: multipart/mixed; boundary="ERxTA9SiVTDkqnI1tSYVk1qXvmcH1WvqI";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <6a86d5d5-1d67-f34b-f809-b4e534485f3e@gmx.com>
Subject: Re: So, does btrfs check lowmem take days? weeks?
References: <20180629042707.vrjwbytg6bxmrgjg@merlins.org>
 <6658a593-3b4a-f1ef-f550-2fb951b2517d@gmx.com>
 <20180629052825.tifg2aw7oy3qyyvw@merlins.org>
 <3b240898-a96d-77f6-efb9-f0af81ee0cd1@gmx.com>
 <20180629060657.qrtcxfcy22zkstfw@merlins.org>
 <e9264580-7853-fbfc-2c90-e28e8a45daf5@gmx.com>
 <20180629065903.xgwpvaa2vuiys75r@merlins.org>
In-Reply-To: <20180629065903.xgwpvaa2vuiys75r@merlins.org>

--ERxTA9SiVTDkqnI1tSYVk1qXvmcH1WvqI
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B406=E6=9C=8829=E6=97=A5 14:59, Marc MERLIN wrote:
> On Fri, Jun 29, 2018 at 02:29:10PM +0800, Qu Wenruo wrote:
>>> If --repair doesn't work, check is useless to me sadly.
>>
>> Not exactly.
>> Although it's time consuming, I have manually patched several users fs=
,
>> which normally ends pretty well.
> =20
> Ok I understand now.
>=20
>>> Agreed, I doubt I have over or much over 100 snapshots though (but I
>>> can't check right now).
>>> Sadly I'm not allowed to mount even read only while check is running:=

>>> gargamel:~# mount -o ro /dev/mapper/dshelf2 /mnt/mnt2
>>> mount: /dev/mapper/dshelf2 already mounted or /mnt/mnt2 busy
>=20
> Ok, so I just checked now, 270 snapshots, but not because I'm crazy,
> because I use btrfs send a lot :)
>=20
>> This looks like super block corruption?
>>
>> What about "btrfs inspect dump-super -fFa /dev/mapper/dshelf2"?
>=20
> Sure, there you go: https://pastebin.com/uF1pHTsg
>=20
>> And what about "skip_balance" mount option?
> =20
> I have this in my fstab :)
>=20
>> Another problem is, with so many snapshots, balance is also hugely
>> slowed, thus I'm not 100% sure if it's really a hang.
>=20
> I sent another thread about this last week, balance got hung after 2
> days of doing nothing and just moving a single chunk.
>=20
> Ok, I was able to remount the filesystem read only. I was wrong, I have=

> 270 snapshots:
> gargamel:/mnt/mnt# btrfs subvolume list . | grep -c 'path backup/'
> 74
> gargamel:/mnt/mnt# btrfs subvolume list . | grep -c 'path backup-btrfss=
end/'
> 196
>=20
> It's a backup server, I use btrfs send for many machines and for each b=
trs
> send, I keep history, maybe 10 or so backups. So it adds up in the end.=

>=20
> Is btrfs unable to deal with this well enough?

It depends.
For certain and rare case, if the only operations to the filesystem are
non-btrfs specific operations (POSIX file operations), then you're fine.
(Maybe you can go thousands snapshots before any obvious performance
degrade)

If certain btrfs specific operations are involved, it's definitely not OK=
:
1) Balance
2) Quota
3) Btrfs check

>=20
>> If for that usage, btrfs-restore would fit your use case more,
>> Unfortunately it needs extra disk space and isn't good at restoring
>> subvolume/snapshots.
>> (Although it's much faster than repairing the possible corrupted exten=
t
>> tree)
>=20
> It's a backup server, it only contains data from other machines.
> If the filesystem cannot be recovered to a working state, I will need
> over a week to restart the many btrfs send commands from many servers.
> This is why anything other than --repair is useless ot me, I don't need=

> the data back, it's still on the original machines, I need the
> filesystem to work again so that I don't waste a week recreating the
> many btrfs send/receive relationships.

Now totally understand why you need to repair the fs.

>=20
>>> Is that possible at all?
>>
>> At least for file recovery (fs tree repair), we have such behavior.
>>
>> However, the problem you hit (and a lot of users hit) is all about
>> extent tree repair, which doesn't even goes to file recovery.
>>
>> All the hassle are in extent tree, and for extent tree, it's just good=

>> or bad. Any corruption in extent tree may lead to later bugs.
>> The only way to avoid extent tree problems is to mount the fs RO.
>>
>> So, I'm afraid it is at least impossible for recent years.
>=20
> Understood, thanks for answering.
>=20
> Does the pastebin help and is 270 snapshots ok enough?

The super dump doesn't show anything wrong.

So the problem may be in the super large extent tree.

In this case, plain check result with Su's patch would help more, other
than the not so interesting super dump.

Thanks,
Qu

>=20
> Thanks,
> Marc
>=20


--ERxTA9SiVTDkqnI1tSYVk1qXvmcH1WvqI--

--UnkxdleUsyzamd0xVQ2lqWsgHQ6PY7IQi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAls13coACgkQwj2R86El
/qhOqwgApm5p0qUAqwloToXfPhXLuhnW/LsEooDaz8n9aom5/VkfMgEg5XcN4/mH
l1uTJlKLRTqIzTCF/jPoYtqOlQ+OT8p+/SCpVxTeuyOsLbAZgMBi0mQdNMZu/w9S
QL3HmvjNTvPuGi9FP3qXdkhuNKD3mEkZyjJJU8BQJDsJ8cgdP5+luvJyhdaw+abm
m6tVFJzkBZ/bYJRmMbdkoSjHQlIZGnsM8p6eXlG4H68pFt/ZcNIsq0YvyOGteF+g
z7hNsNBwMEzjkmeJPn6wsVwNj/WXtLxqPxWb1yp3Z0UMo5zA8uwT0ZAwCJx+0wdr
nN+6tAoWjGdDe5ACks9LbDBJvL8Bqg==
=3d3B
-----END PGP SIGNATURE-----

--UnkxdleUsyzamd0xVQ2lqWsgHQ6PY7IQi--
