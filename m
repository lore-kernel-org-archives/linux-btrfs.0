Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f173.google.com ([209.85.223.173]:33891 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276AbbGULPw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Jul 2015 07:15:52 -0400
Received: by iebmu5 with SMTP id mu5so139057991ieb.1
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Jul 2015 04:15:51 -0700 (PDT)
Subject: Re: Can't mount btrfs volume on rbd
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, Steve Dainard <sdainard@spd1.com>
References: <CAEMJtDs=U5+YO9sbVvjxLthdxp6JvZO=07EMhcU5Smif_1m5QQ@mail.gmail.com>
 <557A890D.8080306@cn.fujitsu.com>
 <CAEMJtDu2zZJc-dg9opj0xHaKyeL78H0ppivb8mJFhChJ4J63uA@mail.gmail.com>
 <557E877E.2060704@cn.fujitsu.com>
 <CAEMJtDusywPEnDcNcMvvFKQsuZyTmSMXXgJT=eBZX1F+R8RM8w@mail.gmail.com>
 <557F7B82.2060203@cn.fujitsu.com>
 <CAEMJtDv1Tm7-O2mU03kZhPDkaSj7nVi+VAZVhPfh7BN8AuF2Bg@mail.gmail.com>
 <55A46473.8070106@cn.fujitsu.com> <55AE04EF.6040807@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <55AE29DA.4050201@gmail.com>
Date: Tue, 21 Jul 2015 07:15:38 -0400
MIME-Version: 1.0
In-Reply-To: <55AE04EF.6040807@cn.fujitsu.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms010205040200060306080701"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms010205040200060306080701
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-07-21 04:38, Qu Wenruo wrote:
> Hi Steve,
>
> I checked your binary dump.
>
> Previously I was too focused on the assert error, but ignored some even=

> larger bug...
>
> As for the btrfs-debug-tree output, subvol 257 and 5 are completely
> corrupted.
> Subvol 257 seems to contains a new tree root, and 5 seems to contains a=

> new device tree.
>
> ------
> fs tree key (FS_TREE ROOT_ITEM 0)
> leaf 29409280 items 8 free space 15707 generation 9 owner 4
> fs uuid 1bb22a03-bc25-466f-b078-c66c6f6a6d28
> chunk uuid 11cca6df-e850-45d7-a928-cdff82c5f295
>          item 0 key (0 DEV_STATS 1) itemoff 16243 itemsize 40
>                  device stats
>          item 1 key (1 DEV_EXTENT 0) itemoff 16195 itemsize 48
>                  dev extent chunk_tree 3
>                  chunk objectid 256 chunk offset 0 length 4194304
>          item 2 key (1 DEV_EXTENT 4194304) itemoff 16147 itemsize 48
>                  dev extent chunk_tree 3
>                  chunk objectid 256 chunk offset 4194304 length 8388608=

>          item 3 key (1 DEV_EXTENT 12582912) itemoff 16099 itemsize 48
>                  dev extent chunk_tree 3
> ......
> # DEV_EXTENT should never occur in fs tree. It should only occurs in
> # dev tree
>
> file tree key (257 ROOT_ITEM 0)
> leaf 29376512 items 13 free space 12844 generation 9 owner 1
> fs uuid 1bb22a03-bc25-466f-b078-c66c6f6a6d28
> chunk uuid 11cca6df-e850-45d7-a928-cdff82c5f295
>          item 0 key (EXTENT_TREE ROOT_ITEM 0) itemoff 15844 itemsize 43=
9
>                  root data bytenr 29392896 level 0 dirid 0 refs 1 gen 9=

>                  uuid 00000000-0000-0000-0000-000000000000
>          item 1 key (DEV_TREE ROOT_ITEM 0) itemoff 15405 itemsize 439
>                  root data bytenr 29409280 level 0 dirid 0 refs 1 gen 9=

>                  uuid 00000000-0000-0000-0000-000000000000
>          item 2 key (FS_TREE INODE_REF 6) itemoff 15388 itemsize 17
>                  inode ref index 0 namelen 7 name: default
>          item 3 key (FS_TREE ROOT_ITEM 0) itemoff 14949 itemsize 439
>                  root data bytenr 29360128 level 0 dirid 256 refs 1 gen=
 4
>                  uuid 00000000-0000-0000-0000-000000000000
>          item 4 key (ROOT_TREE_DIR INODE_ITEM 0) itemoff 14789 itemsize=
 160
>                  inode generation 3 transid 0 size 0 nbytes 16384
>                  block group 0 mode 40755 links 1 uid 0 gid 0
>                  rdev 0 flags 0x0
> # These things are only in tree root.
> ------
>
> So the problem is, the kernel you use has some bug (btrfs or rbd
> related), causing the btrfs write wrong tree blocks into existing tree
> blocks.
>
> For such case, btrfsck won't be able to fix the critical error.
> And I didn't even have an idea to fix the assert to change it into a
> normal error. As it's corrupting the whole structure of btrfs...
>
> I can't even recall such critical btrfs bug...
>
>
> Not familiar with rbd, but will it allow a block device to be mounted o=
n
> different systems?
>
> Like exporting a device A to system B and system C, and both system B
> and system C mounting device A at the same time as btrfs?
>
Yes, it's a distributed SAN type system built on top of Ceph.  It does=20
allow having multiple systems mount the device.

Ideally, we really should put in some kind of protection against=20
multiple mounts (this would be a significant selling point of BTRFS in=20
my opinion, as the only other Linux native FS that has this is ext4),=20
and make it _very_ obvious that mounting a BTRFS filesystem on multiple=20
nodes concurrently _WILL_ result in pretty much irreparable corruption.


--------------ms010205040200060306080701
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwNzIxMTExNTM4WjBPBgkq
hkiG9w0BCQQxQgRAnAbkMCNtby/LBdDz8N2LPw6LLRsS2o8pSecHI9QlaOypRpK8eTlZ+jEt
nuGRmGc+G9XXsqF7bggUhmZ5AbCoxDBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxBuVTCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTAN
BgkqhkiG9w0BAQEFAASCAgAgfuXP45kwJDjwzwRFkYJ2OhlwxwM8gImefEknRbhaF6vT/n/c
Tp9CeFV6fpd73HNyn87KP6WJE/a7XqbU6wHCGDvcCpwNyAweeLyYP9EsO+th++H0fZD1LkYA
UhOaAHyUIk7H3NidKtRgIG/wvGJig/bvs6g4F3St8gudbJSyxBxErq0rBI/Tw6lb553X3Z4h
obL6eD2BEbjJS5n5HEaZD2jKacRHf1j2dcuc9wN6glc6oTzWT67j8C43/QbXyO2b+QlfUQMB
D+dKo6WufeL67di/HPi10DwhEiyEZyif5VBgVy0j9veupdvn/k2/OcFxrHFwo4ut0RclEige
QUCN2AHPyNWxVOBvG/XaFt9pxAa1XgxAAYMe/WAshF1cwNlLxosAyvqIIW7K532s//dg79IN
FCliufiyULUH4WHMm/8oAHYA0vnDlcAXi+INDD44wkPTHqVAxMBwgf2YYmxdQMFgxPYRTwLV
kiOBxtI49F88Xt9knH8L1oSWurSwv0eWeCgPuIHweDO7nGA2gKneRdwOjgS5+0Z3j4DqWFer
hz+9sTfx0VXy5B0bvo0DKjrgMVdGoCXlKEaVGwG79HTEGOTWrKatsfD+KPUJw1JxrZWY8jCo
a0cI/yaAC+arPApMY5qQ9jESWQ7oS/rGnlo3rK3RjfEDKV2foSlDT0EIIwAAAAAAAA==
--------------ms010205040200060306080701--
