Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw-01.dd24.net ([193.46.215.41]:41717 "EHLO
        mailgw-01.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751184AbdAPWHc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Jan 2017 17:07:32 -0500
Message-ID: <1484604435.7086.22.camel@scientia.net>
Subject: Re: corruption: yet another one after deleting a ro snapshot
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Date: Mon, 16 Jan 2017 23:07:15 +0100
In-Reply-To: <a0aad88a-e19e-e013-7533-4a5bf0783763@cn.fujitsu.com>
References: <1484183243.10253.5.camel@scientia.net>
         <a7b82ec9-bd8d-d6bb-27e7-3732b466ca06@cn.fujitsu.com>
         <1484188092.29002.4.camel@scientia.net>
         <25993bdf-d1fe-30df-7236-b9d5d6e5cfb2@cn.fujitsu.com>
         <1484499869.17186.1.camel@scientia.net>
         <4d7e21ed-a8f6-6c75-4a14-ff43201bd27b@cn.fujitsu.com>
         <1484535383.7577.53.camel@scientia.net>
         <657ea421-0058-b641-ef31-c7d371fa58ca@cn.fujitsu.com>
         <1484542415.21166.1.camel@scientia.net>
         <a0aad88a-e19e-e013-7533-4a5bf0783763@cn.fujitsu.com>
Content-Type: multipart/signed; micalg="sha-512";
        protocol="application/x-pkcs7-signature";
        boundary="=-dj1gXQh2Fp+AEcVB5TtE"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--=-dj1gXQh2Fp+AEcVB5TtE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2017-01-16 at 13:47 +0800, Qu Wenruo wrote:
> > > And I highly suspect if the subvolume 6403 is the RO snapshot you
> > > just removed.
> >=20
> > I guess there is no way to find out whether it was that snapshot,
> > is
> > there?
>=20
> "btrfs subvolume list" could do it."
Well that was clear,... but I rather meant something that also shows me
the path of the deleted subvol.
Anyway:
# btrfs subvolume list /data/data-a/3/
ID 6029 gen 2528 top level 5 path data
ID 6031 gen 3208 top level 5 path backups
ID 7285 gen 3409 top level 5 path snapshots/_external-fs/data-a1/data/2017-=
01-11_1

So since I only had two further snapshots in snapshots/_external-
fs/data-a1/data/ it must be the deleted one.

btw: data is empty, and backup contains actually some files (~25k,
~360GB)... these are not created via send/receive, but either via cp or
rsync.
And they are always in the same subvol (i.e. the backups svol isn't
deleted like the snaphots are)


> Also checked the extent tree, the result is a little interesting:
> 1) Most tree backref are good.
> =C2=A0=C2=A0=C2=A0=C2=A0In fact, 3 of all the 4 errors reported are tree =
blocks shared by
> =C2=A0=C2=A0=C2=A0=C2=A0other subvolumes, like:
>=20
> item 77 key (51200000 METADATA_ITEM 1) itemoff 13070 itemsize 42
> 		extent refs 2 gen 11 flags TREE_BLOCK|FULL_BACKREF
> 		tree block skinny level 1
> 		tree block backref root 7285
> 		tree block backref root 6572
>=20
> This means the tree blocks are share by 2 other subvolumes,
> 7285 and 6572.
>=20
> 7285 subvolume is completely OK, while 6572 is also undergoing
> subvolume=C2=A0
> deletion(while real deletion doesn't start yet).
Well there were in total three snapshots, the still existing:
snapshots/_external-fs/data-a1/data/2017-01-11_1
and two earlier ones,
one from around 2016-09-16_1 (=3D probably ID=C2=A06572?), one even a bit
earlier from 2016-08-19_1 (probably ID=C2=A06403?).
Each one was created with
send -p | receive, using the respectively earlier one as parent.
So it's
quite reasonable that they share the extents and also that it'sby 2
subvols.



> And considering the generation, I assume 6403 is deleted before 6572.
Don't remember which one of the 2 subvols form 2016 I've deleted first,
the older or the more recent one... my bash history implies in this
order:
=C2=A04203=C2=A0=C2=A0btrfs subvolume delete 2016-08-19_1
=C2=A04204=C2=A0=C2=A0btrfs subvolume delete 2016-09-16_1


> So we're almost clear that, btrfs (maybe only btrfsck) doesn't handle
> it=C2=A0
> well if there are multiple subvolume undergoing deletion.
>=20
> This gives us enough info to try to build such image by ourselves
> now.
> (Although still quite hard to do though).
Well keep me informed if you actually find/fix something  :)


> And for the scary lowmem mode, it's false alert.
>=20
> I manually checked the used size of a block group and it's OK.
So you're going to fix this?


> BTW, most of your block groups are completely used, without any
> space.
> But interestingly, mostly data extent size are just 512K, larger than
> compressed extent upper limit, but still quite small.
Not sure if I understand this...


> In other words, your fs seems to be fragmented considering the upper=C2=
=A0
> limit of a data extent is 128M.
> (Or your case is quite common in common world?)
No, I don't think I understand what you mean :D


> So you are mostly OK to mount it rw any time you want, and I have=C2=A0
> already downloaded the raw data.
Okay, I've remounted it now RW, called btrfs filesystem sync, and
waited until the HDD became silent and showed no further activity.

(again 3.9)

# btrfs check /dev/nbd0 ; echo $?
Checking filesystem on /dev/nbd0
UUID: 326d292d-f97b-43ca-b1e8-c722d3474719
checking extents
checking free space cache
checking fs roots
checking csums
checking root refs
found 7469206884352 bytes used err is 0
total csum bytes: 7281779252
total tree bytes: 10837262336
total fs tree bytes: 2011906048
total extent tree bytes: 1015349248
btree space waste bytes: 922444044
file data blocks allocated: 7458369622016
=C2=A0referenced 7579485159424
0


=3D> as you can see, original mode pretends things would be fine now.


# btrfs check --mode=3Dlowmem /dev/nbd0 ; echo $?
Checking filesystem on /dev/nbd0
UUID: 326d292d-f97b-43ca-b1e8-c722d3474719
checking extents
ERROR: block group[74117545984 1073741824] used 1073741824 but extent items=
 used 0
ERROR: block group[239473786880 1073741824] used 1073741824 but extent item=
s used 1207959552
ERROR: block group[500393050112 1073741824] used 1073741824 but extent item=
s used 1207959552
ERROR: block group[581997428736 1073741824] used 1073741824 but extent item=
s used 0
ERROR: block group[626557714432 1073741824] used 1073741824 but extent item=
s used 0
ERROR: block group[668433645568 1073741824] used 1073741824 but extent item=
s used 0
ERROR: block group[948680261632 1073741824] used 1073741824 but extent item=
s used 0
ERROR: block group[982503129088 1073741824] used 1073741824 but extent item=
s used 0
ERROR: block group[1039411445760 1073741824] used 1073741824 but extent ite=
ms used 0
ERROR: block group[1054443831296 1073741824] used 1073741824 but extent ite=
ms used 1207959552
ERROR: block group[1190809042944 1073741824] used 1073741824 but extent ite=
ms used 0
ERROR: block group[1279392743424 1073741824] used 1073741824 but extent ite=
ms used 0
ERROR: block group[1481256206336 1073741824] used 1073741824 but extent ite=
ms used 0
ERROR: block group[1620842643456 1073741824] used 1073741824 but extent ite=
ms used 1207959552
ERROR: block group[1914511032320 1073741824] used 1073741824 but extent ite=
ms used 1207959552
ERROR: block group[3055361720320 1073741824] used 1073741824 but extent ite=
ms used 0
ERROR: block group[3216422993920 1073741824] used 1073741824 but extent ite=
ms used 0
ERROR: block group[3670615785472 1073741824] used 1073741824 but extent ite=
ms used 1207959552
ERROR: block group[3801612288000 1073741824] used 1073741824 but extent ite=
ms used 1207959552
ERROR: block group[3828455833600 1073741824] used 1073741824 but extent ite=
ms used 1207959552
ERROR: block group[4250973241344 1073741824] used 1073741824 but extent ite=
ms used 0
ERROR: block group[4261710659584 1073741824] used 1073741824 but extent ite=
ms used 1074266112
ERROR: block group[4392707162112 1073741824] used 1073741824 but extent ite=
ms used 0
ERROR: block group[4558063403008 1073741824] used 1073741824 but extent ite=
ms used 0
ERROR: block group[4607455526912 1073741824] used 1073741824 but extent ite=
ms used 0
ERROR: block group[4635372814336 1073741824] used 1073741824 but extent ite=
ms used 0
ERROR: block group[4640204652544 1073741824] used 1073741824 but extent ite=
ms used 0
ERROR: block group[4642352136192 1073741824] used 1073741824 but extent ite=
ms used 1207959552
ERROR: block group[4681006841856 1073741824] used 1073741824 but extent ite=
ms used 0
ERROR: block group[5063795802112 1073741824] used 1073741824 but extent ite=
ms used 0
ERROR: block group[5171169984512 1073741824] used 1073741824 but extent ite=
ms used 1207959552
ERROR: block group[5216267141120 1073741824] used 1073741824 but extent ite=
ms used 1207959552
ERROR: block group[5290355326976 1073741824] used 1073741824 but extent ite=
ms used 0
ERROR: block group[5445511020544 1073741824] used 1073741824 but extent ite=
ms used 1074266112
ERROR: block group[6084387405824 1073741824] used 1073741824 but extent ite=
ms used 0
ERROR: block group[6104788500480 1073741824] used 1073741824 but extent ite=
ms used 0
ERROR: block group[6878956355584 1073741824] used 1073741824 but extent ite=
ms used 0
ERROR: block group[6997067956224 1073741824] used 1073741824 but extent ite=
ms used 0
ERROR: block group[7702516334592 1073741824] used 1073741824 but extent ite=
ms used 0
ERROR: block group[8051482427392 1073741824] used 1073741824 but extent ite=
ms used 1084751872
ERROR: block group[8116980678656 1073741824] used 1073217536 but extent ite=
ms used 0
ERROR: errors found in extent allocation tree or chunk allocation
checking free space cache
checking fs roots
found 7469206884352 bytes used err is -5
total csum bytes: 7281779252
total tree bytes: 10837262336
total fs tree bytes: 2011906048
total extent tree bytes: 1015349248
btree space waste bytes: 922444044
file data blocks allocated: 7458369622016
=C2=A0referenced 7579485159424
1

=3D> but lomem mode finds quite some errors... actually it seems even
worse, normally (and before with 3.9 but without having it RW mounted
yet), the "checking fs roots" took ages (at least an hour or two... nbd
makes it even slower)... but this time, while checking extents too also
long, checking fs roots was extremely fast (possibly because of some
more grave error?), and checking csums didn't even occur.

What do you think... error in the fs or in fsck's lowmem mode?


> Hard part is remaining for us developers to build such small image
> to=C2=A0
> reproduce your situation then.
Well... that's the life of a btrfs-dev ;-P


Cheers,
Chris.
--=-dj1gXQh2Fp+AEcVB5TtE
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgMFADCABgkqhkiG9w0BBwEAAKCCEmow
ggXiMIIDyqADAgECAhBctkhuRwyYxn/2gNtkSuKNMA0GCSqGSIb3DQEBCwUAMH0xCzAJBgNVBAYT
AklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSswKQYDVQQLEyJTZWN1cmUgRGlnaXRhbCBDZXJ0
aWZpY2F0ZSBTaWduaW5nMSkwJwYDVQQDEyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0
eTAeFw0xNTEyMTYwMTAwMDVaFw0zMDEyMTYwMTAwMDVaMHUxCzAJBgNVBAYTAklMMRYwFAYDVQQK
Ew1TdGFydENvbSBMdGQuMSkwJwYDVQQLEyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0
eTEjMCEGA1UEAxMaU3RhcnRDb20gQ2xhc3MgMiBDbGllbnQgQ0EwggEiMA0GCSqGSIb3DQEBAQUA
A4IBDwAwggEKAoIBAQDuD1CMlQkjhKz1UGqP1jeiTiH9MgllRz6vOPrVG/eE0H/J4QQLV/PeL8RT
4xc44bEzsoJu0IhwnEchb+TxE/qw88w7hxODuw3N8Faxix6a1jp83+RWvZHZf78+O+3GYBpekZfT
Oe9A/FoTXbcgwZfLTMQodn+ckNnX31M/1M2f2/7VA7QBlvihontyHQOlIlryQXnGI0UMCD21oopK
tW48ckv0wUVg8irBKGMeD65gTON/Fsw/ZBbBqadoD1jt85FIM1ql24WUBEBwO1d0ykCKOIbgcqes
3fbcjQpruUNMBbIu1MMIRMqwjx/M7IvSKcS7VYRWl0/K2byzWvBAHh/1AgMBAAGjggFkMIIBYDAO
BgNVHQ8BAf8EBAMCAQYwHQYDVR0lBBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMEMBIGA1UdEwEB/wQI
MAYBAf8CAQAwMgYDVR0fBCswKTAnoCWgI4YhaHR0cDovL2NybC5zdGFydHNzbC5jb20vc2ZzY2Eu
Y3JsMGYGCCsGAQUFBwEBBFowWDAkBggrBgEFBQcwAYYYaHR0cDovL29jc3Auc3RhcnRzc2wuY29t
MDAGCCsGAQUFBzAChiRodHRwOi8vYWlhLnN0YXJ0c3NsLmNvbS9jZXJ0cy9jYS5jcnQwHQYDVR0O
BBYEFJmXqxg1OotZRUOYsnJxyPT7Cc8WMB8GA1UdIwQYMBaAFE4L7xqkQFulF2mHMMo0aEPQQa7y
MD8GA1UdIAQ4MDYwNAYEVR0gADAsMCoGCCsGAQUFBwIBFh5odHRwOi8vd3d3LnN0YXJ0c3NsLmNv
bS9wb2xpY3kwDQYJKoZIhvcNAQELBQADggIBAJlBQQTO9iT1TjA0eEO7V/1AbBvMAfibjAgofxmJ
01jBmHKg0pbTjWInTTYoxb3LBgz3mfjvvS1PjnIfb29MyVm0G/PSHjgq7Ews1dEJMPC9XTuxPf2c
+MWLkynBlotW542JprW+iTWfZafyUtzIKW1hk0YASJ8zSSj8D++9yR+0UhkbvlECJkdi1+et0EaI
7HIX6ccj1rfcFFflWX/fPT64dn9jpg9s0nuJug4WsVkEK236WndZoMHrZmgF7CIyZ3T0muqYwkAS
DDcRt9A21o/Mc+D8Q6GVmKRGB3gEKvOtsioHZEqJv6CdAm3a6gloo5pX3RL1eCzc8Lzfs4T0ISZj
r8xNMbTGlsuHaFH+stDewKsfnpo4N64OtAGrzmVfFFsMIRENRHsVlSEe/6LVpBpjn00+7bqEN3qe
qSxIOraYJ12mJ08G4YnP2U1fadHIaS50O5ZXqAivoBl9pi/6CBNc5wIMlkXMyFZ0sLsI+9ErFDu9
OJhX7iWCo69X0ydlzXj08+2K1PKyr+g6/vTPHur63JotNrhyoWEJyWEjBLA4QmJXfGpB5u+bCwNf
sFpcYAlkiFt1Rs2vemgSBy3q4DHDbPKvr1YImZNRSHP+TX9NP94JRkmqcyD/qaN7u2JV1pRAlwG0
npyrn6ZQM1QHV+iFbwQ4VqLMWk//QVo/rZy1MIIGPjCCBSagAwIBAgIQPZ6tDP/RHLwcz1F+2kRA
DzANBgkqhkiG9w0BAQsFADB1MQswCQYDVQQGEwJJTDEWMBQGA1UEChMNU3RhcnRDb20gTHRkLjEp
MCcGA1UECxMgU3RhcnRDb20gQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkxIzAhBgNVBAMTGlN0YXJ0
Q29tIENsYXNzIDIgQ2xpZW50IENBMB4XDTE2MDEwMjAyMDIzNloXDTE4MDEwMjAyMDIzNlowejEL
MAkGA1UEBhMCREUxDzANBgNVBAgMBkJheWVybjERMA8GA1UEBwwITcO8bmNoZW4xITAfBgNVBAMM
GENocmlzdG9waCBBbnRvbiBNaXR0ZXJlcjEkMCIGCSqGSIb3DQEJARYVY2FsZXN0eW9Ac2NpZW50
aWEubmV0MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAsoxs789VtR81tlqeP2vwE3Cp
YosZYRfrovj+Wb91paoV5OQcFuXA7yONnLsWxOnJ3AGgy1/wG79Ko+yHSmF2K88pEWjrFe0zmZWZ
0b2OtMoKLEjxz7Nz2N7/lmgss8XinJ083LwLKSe4f+JLjnF5hX/g6wG4NkFXVOIf2YFZ0+c1NYFQ
T6Vy42EWdk+JLDoXjyd2hEperLCz9rQr2k3wh0cn8R1FDUGerBGpMnvyKV6JXj5vZsqJnmiiId9e
0IdBj4Wcs3hT2usk6dJYwHrZ8b7Fkv6BRq90DUI7i8+ukTdp5hnAb8TPSbe1JS4h3Jc7r2NVLkpo
Gbuw98er9s2PEAvpECD3toO3ojBevL56vEDbGa5tXpvvcWCz6t3QyEKJ2E54hWw1fbUA0BtydQC0
mhKBtrENVnnCDrSgiyBMnd8y+kw6iPKeJEjNObGubc4BZp47zPn/ZiDBaHue6S0MXsoS7XEGOuCU
09S/8kD8wTecBg+KdlLSNkLm+xqx6Cy7zwcj3IuQv0PeWi4kfEkAJfl8IeAP/4049iA6a1rkhJl7
1rDjpEGBCG+i9BAgBeNdHLtQ7bugdvU+GfHjFXEU1emUk91E2liML8kpCvhUAXcLhhL8bxPJiX2/
VQ2esrpQVO56OzpivNauonLaWmHEKOSfPC3s5AKMytMTiUiszEUCAwEAAaOCAcMwggG/MAsGA1Ud
DwQEAwIEsDAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwQwCQYDVR0TBAIwADAdBgNVHQ4E
FgQUwRklxF1ZV2ooSMkFwLiK13apkK0wHwYDVR0jBBgwFoAUmZerGDU6i1lFQ5iycnHI9PsJzxYw
bwYIKwYBBQUHAQEEYzBhMCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5zdGFydHNzbC5jb20wOQYI
KwYBBQUHMAKGLWh0dHA6Ly9haWEuc3RhcnRzc2wuY29tL2NlcnRzL3NjYS5jbGllbnQyLmNydDA4
BgNVHR8EMTAvMC2gK6AphidodHRwOi8vY3JsLnN0YXJ0c3NsLmNvbS9zY2EtY2xpZW50Mi5jcmww
IAYDVR0RBBkwF4EVY2FsZXN0eW9Ac2NpZW50aWEubmV0MCMGA1UdEgQcMBqGGGh0dHA6Ly93d3cu
c3RhcnRzc2wuY29tLzBUBgNVHSAETTBLMAwGCisGAQQBgbU3BgEwOwYLKwYBBAGBtTcBAgQwLDAq
BggrBgEFBQcCARYeaHR0cDovL3d3dy5zdGFydHNzbC5jb20vcG9saWN5MA0GCSqGSIb3DQEBCwUA
A4IBAQBb8EIsoUN/tgUgQqrNXNtlksPep84kx5yRBgr71uf3ITLddGtzfDBj6KdZUoy7SG3MQkyO
kvYmXBClj23rv8Iol48/3oi9XWZw5EV3uHrRse1TzQgMPZE0hZsDgkqXVoxMQfk55ndjZIHMfSkn
hdnqSP5zZ4TCmDEKLppPMDcQSSrjilnbthpxlIJzeGeEFtrh6ssh/oF6mUaEGFcd8kx9RS51K1gt
H4J36y4E6pKB7EdxG2+0yVzAIta8dkD/BiMCKRWhp1EmzQ2uIh2nX5y8t4e2xHHuiy11Yeq6UTW/
JmfxF4xcbkNK/rv9ISBg9K+mZtg2QXr+P/CJBtej2RLUMIIGPjCCBSagAwIBAgIQPZ6tDP/RHLwc
z1F+2kRADzANBgkqhkiG9w0BAQsFADB1MQswCQYDVQQGEwJJTDEWMBQGA1UEChMNU3RhcnRDb20g
THRkLjEpMCcGA1UECxMgU3RhcnRDb20gQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkxIzAhBgNVBAMT
GlN0YXJ0Q29tIENsYXNzIDIgQ2xpZW50IENBMB4XDTE2MDEwMjAyMDIzNloXDTE4MDEwMjAyMDIz
NlowejELMAkGA1UEBhMCREUxDzANBgNVBAgMBkJheWVybjERMA8GA1UEBwwITcO8bmNoZW4xITAf
BgNVBAMMGENocmlzdG9waCBBbnRvbiBNaXR0ZXJlcjEkMCIGCSqGSIb3DQEJARYVY2FsZXN0eW9A
c2NpZW50aWEubmV0MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAsoxs789VtR81tlqe
P2vwE3CpYosZYRfrovj+Wb91paoV5OQcFuXA7yONnLsWxOnJ3AGgy1/wG79Ko+yHSmF2K88pEWjr
Fe0zmZWZ0b2OtMoKLEjxz7Nz2N7/lmgss8XinJ083LwLKSe4f+JLjnF5hX/g6wG4NkFXVOIf2YFZ
0+c1NYFQT6Vy42EWdk+JLDoXjyd2hEperLCz9rQr2k3wh0cn8R1FDUGerBGpMnvyKV6JXj5vZsqJ
nmiiId9e0IdBj4Wcs3hT2usk6dJYwHrZ8b7Fkv6BRq90DUI7i8+ukTdp5hnAb8TPSbe1JS4h3Jc7
r2NVLkpoGbuw98er9s2PEAvpECD3toO3ojBevL56vEDbGa5tXpvvcWCz6t3QyEKJ2E54hWw1fbUA
0BtydQC0mhKBtrENVnnCDrSgiyBMnd8y+kw6iPKeJEjNObGubc4BZp47zPn/ZiDBaHue6S0MXsoS
7XEGOuCU09S/8kD8wTecBg+KdlLSNkLm+xqx6Cy7zwcj3IuQv0PeWi4kfEkAJfl8IeAP/4049iA6
a1rkhJl71rDjpEGBCG+i9BAgBeNdHLtQ7bugdvU+GfHjFXEU1emUk91E2liML8kpCvhUAXcLhhL8
bxPJiX2/VQ2esrpQVO56OzpivNauonLaWmHEKOSfPC3s5AKMytMTiUiszEUCAwEAAaOCAcMwggG/
MAsGA1UdDwQEAwIEsDAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwQwCQYDVR0TBAIwADAd
BgNVHQ4EFgQUwRklxF1ZV2ooSMkFwLiK13apkK0wHwYDVR0jBBgwFoAUmZerGDU6i1lFQ5iycnHI
9PsJzxYwbwYIKwYBBQUHAQEEYzBhMCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5zdGFydHNzbC5j
b20wOQYIKwYBBQUHMAKGLWh0dHA6Ly9haWEuc3RhcnRzc2wuY29tL2NlcnRzL3NjYS5jbGllbnQy
LmNydDA4BgNVHR8EMTAvMC2gK6AphidodHRwOi8vY3JsLnN0YXJ0c3NsLmNvbS9zY2EtY2xpZW50
Mi5jcmwwIAYDVR0RBBkwF4EVY2FsZXN0eW9Ac2NpZW50aWEubmV0MCMGA1UdEgQcMBqGGGh0dHA6
Ly93d3cuc3RhcnRzc2wuY29tLzBUBgNVHSAETTBLMAwGCisGAQQBgbU3BgEwOwYLKwYBBAGBtTcB
AgQwLDAqBggrBgEFBQcCARYeaHR0cDovL3d3dy5zdGFydHNzbC5jb20vcG9saWN5MA0GCSqGSIb3
DQEBCwUAA4IBAQBb8EIsoUN/tgUgQqrNXNtlksPep84kx5yRBgr71uf3ITLddGtzfDBj6KdZUoy7
SG3MQkyOkvYmXBClj23rv8Iol48/3oi9XWZw5EV3uHrRse1TzQgMPZE0hZsDgkqXVoxMQfk55ndj
ZIHMfSknhdnqSP5zZ4TCmDEKLppPMDcQSSrjilnbthpxlIJzeGeEFtrh6ssh/oF6mUaEGFcd8kx9
RS51K1gtH4J36y4E6pKB7EdxG2+0yVzAIta8dkD/BiMCKRWhp1EmzQ2uIh2nX5y8t4e2xHHuiy11
Yeq6UTW/JmfxF4xcbkNK/rv9ISBg9K+mZtg2QXr+P/CJBtej2RLUMYIEfjCCBHoCAQEwgYkwdTEL
MAkGA1UEBhMCSUwxFjAUBgNVBAoTDVN0YXJ0Q29tIEx0ZC4xKTAnBgNVBAsTIFN0YXJ0Q29tIENl
cnRpZmljYXRpb24gQXV0aG9yaXR5MSMwIQYDVQQDExpTdGFydENvbSBDbGFzcyAyIENsaWVudCBD
QQIQPZ6tDP/RHLwcz1F+2kRADzANBglghkgBZQMEAgMFAKCCAcUwGAYJKoZIhvcNAQkDMQsGCSqG
SIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTcwMTE2MjIwNzE1WjBPBgkqhkiG9w0BCQQxQgRAo+yo
JlDxXG4v4ssvC+Aqchi3dTt7vzzfkyjIs7SpaPDj4mM4KralrwWdYtAAOeKTtMStOwIgwDu9QlF1
kOD4pDCBmgYJKwYBBAGCNxAEMYGMMIGJMHUxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENv
bSBMdGQuMSkwJwYDVQQLEyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEjMCEGA1UE
AxMaU3RhcnRDb20gQ2xhc3MgMiBDbGllbnQgQ0ECED2erQz/0Ry8HM9RftpEQA8wgZwGCyqGSIb3
DQEJEAILMYGMoIGJMHUxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSkwJwYD
VQQLEyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEjMCEGA1UEAxMaU3RhcnRDb20g
Q2xhc3MgMiBDbGllbnQgQ0ECED2erQz/0Ry8HM9RftpEQA8wDQYJKoZIhvcNAQEBBQAEggIAS3ae
CfSxQvf04bl7/IGFZS31RzY7Q9arjl4VO/SPA/AF4iApewnxZE8Fi7weN/jc3pUrnjpLgX7m7bAu
rVrowFF1yecUgth1FvRg3IPXp9WqPXzVVIQcOizfBQ4qUDGyGW0/jCNb4Dt6OMRtWEBho6QYTgB/
p2G/C2tUQ+rIQbwgQhZC6eGWAH3L7E8N/SzupAqcS09eqBjmPJR5jnOf4RYFS40KJy5hqQLePgZT
T+C2hoV9q/s6eaT9LC0cnO+z/6mHgIh3p/i3kUFbZQLekBK9YnOBRQ2fQ0DWN5a2muLkXghHkvKG
zoKYiQf7bGhadPTPcqRyCrkEi8EaJSqg5h+/njzhmbgcnHXo8GzPzafvFXSNfsyfHzEWk+ZVt/IT
kUjceota6hriNfSXV+bFtIAiUey18aTSTBMUO2HON7TUEySbnDvVATHgRevalwbl8OE/IMG4D4+A
udmn4zBQEJdzi9KszMAzWeFSRwA6w6RYIP8lLl0vaypp8koPejElAMFUZm86cGunYsJr+3otHUzs
zRXGFqHdmtAOgfOrNjGGQh9VPsy7SFrpVshVniQyBYskL5stG5LEKUqh4Cd47a1Ru9sHXxz4WOxH
VXAnZKgM5HFM6xyH15tzYLJIxIXSmmXJ9YQcMIc0e25AkOVV9rOfUXYNqIw1ESloX6eAymEAAAAA
AAA=


--=-dj1gXQh2Fp+AEcVB5TtE--

