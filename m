Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f42.google.com ([209.85.192.42]:34033 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755994AbbIWRlQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Sep 2015 13:41:16 -0400
Received: by qgez77 with SMTP id z77so25436475qge.1
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Sep 2015 10:41:15 -0700 (PDT)
Subject: Re: Btrfs check dont repair
To: =?UTF-8?B?VmFja8OhxZkgRnJhbnRpxaFlaw==?= <vackarf@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <CAMH1C+r4yYU8hYfcZpFRyN1UWY8OPTs5Md7MdE=bm2RW9udREQ@mail.gmail.com>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <5602E433.6070407@gmail.com>
Date: Wed, 23 Sep 2015 13:41:07 -0400
MIME-Version: 1.0
In-Reply-To: <CAMH1C+r4yYU8hYfcZpFRyN1UWY8OPTs5Md7MdE=bm2RW9udREQ@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms020500030704040004060601"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms020500030704040004060601
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-09-23 10:39, Vack=C3=A1=C5=99 Franti=C5=A1ek wrote:
> Hello,
>
> i have problem with my btrfs, can you help me, please? Its on my
> notebook. Sometimes it exhausted battery during sleep and died. But
> everytime FS was ok. But ones mount fail.
>
> Do you have any idea how repair it?
First off, the fact that you are on a relatively recent kernel and have=20
an up-to-date copy of btrfs-progs is a very good thing :).  Secondly,=20
I'm not certain if you did this or not, but always run btrfs check=20
without the --repair option first, it can't fix everything yet, and=20
there are still cases from time to time that it actually makes thing=20
worse when you use the --repair option.  As for the kernel messages,=20
those particular errors are not anything I've ever seen before.  Based=20
on my limited knowledge of the BTRFS internals, I would agree with Hugo=20
(and ironically, I got your response to his e-mail right as I finished=20
this one...).
>
> Sorry for my english. :)
Don't feel bad, it's one of the hardest to learn languages for=20
non-native speakers in the world (and even a lot of people who grew up=20
speaking it don't consistently use correct grammar).  If only Esperanto=20
or Interlingua had actually caught on...
>
> Frantisek Vackar
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [root@rak ~]# btrfs check --repair /dev/sdb2
> enabling repair mode
> Checking filesystem on /dev/sdb2
> UUID: 754a3186-c0ae-4680-ab28-864c8bdad8b5
> checking extents
> bad key ordering 0 1
> bad block 3242450944
> Errors found in extent allocation tree or chunk allocation
> Fixed 0 roots.
> checking free space cache
> cache and super generation don't match, space cache will be invalidated=

> checking fs roots
> bad key ordering 0 1
> Trying to rebuild inode:705555
> root 5 inode 705555 errors 2001, no inode item, link count wrong
>          unresolved ref dir 403566 index 0 namelen 10 name .directory
> filetype 1 errors 6, no dir index, no inode ref
> Trying to rebuild inode:705569
> root 5 inode 705569 errors 2001, no inode item, link count wrong
>          unresolved ref dir 339745 index 0 namelen 18 name
> 15-03-20-Botanicka filetype 2 errors 6, no dir index, no inode ref
> =3D=3D=3D=3D=3DMANY SIMILAR LINES=3D=3D=3D=3D=3D
> Trying to rebuild inode:718060
> root 5 inode 718060 errors 2001, no inode item, link count wrong
>          unresolved ref dir 430527 index 0 namelen 10 name Win 7.vbox
> filetype 1 errors 6, no dir index, no inode ref
> found 1350650234080 bytes used err is 1
> total csum bytes: 0
> total tree bytes: 466538496
> total fs tree bytes: 17154048
> total extent tree bytes: 448659456
> btree space waste bytes: 94077759
> file data blocks allocated: 3997077504
>   referenced 3996086272
> btrfs-progs v4.1.2
>
> [root@rak ~]# mount /mnt/hdd-root/
> mount: wrong fs type, bad option, bad superblock on /dev/sdb2,
>         missing codepage or helper program, or other error
>
>         In some cases useful info is found in syslog - try
>         dmesg | tail or so.
>
> [root@rak ~]# dmesg | tail
> [ 1434.004203] ath5k: ath5k_hw_get_isr: ISR: 0x00000080 IMR: 0x00000000=

> [ 1674.004209] ath5k: ath5k_hw_get_isr: ISR: 0x00000080 IMR: 0x00000000=

> [ 2154.007675] ath5k: ath5k_hw_get_isr: ISR: 0x00000080 IMR: 0x00000000=

> [ 4074.005033] ath5k: ath5k_hw_get_isr: ISR: 0x00000080 IMR: 0x00000000=

> [ 4096.970037] BTRFS info (device sdb2): disk space caching is enabled
> [ 4108.444472] BTRFS critical (device sdb2): corrupt leaf, bad key
> order: block=3D3242455040,root=3D1, slot=3D0
> [ 4108.444649] BTRFS critical (device sdb2): corrupt leaf, bad key
> order: block=3D3242455040,root=3D1, slot=3D0
> [ 4108.444681] BTRFS error (device sdb2): Error removing orphan entry,
> stopping orphan cleanup
> [ 4108.444684] BTRFS error (device sdb2): could not do orphan cleanup -=
22
> [ 4111.047323] BTRFS: open_ctree failed
>
> [root@rak ~]# uname -a
> Linux rak 4.1.2-2-ARCH #1 SMP PREEMPT Wed Jul 15 08:30:32 UTC 2015
> x86_64 GNU/Linux
>
> [root@rak ~]# btrfs fi show /dev/sdb2
> Label: 'data'  uuid: 754a3186-c0ae-4680-ab28-864c8bdad8b5
>          Total devices 1 FS bytes used 1.23TiB
>          devid    1 size 1.72TiB used 1.24TiB path /dev/sdb2
>
> btrfs-progs v4.2
>
> [root@rak ~]# btrfs --version
> btrfs-progs v4.2
>
> [root@rak ~]#   btrfs fi show
> Label: 'data'  uuid: 754a3186-c0ae-4680-ab28-864c8bdad8b5
>          Total devices 1 FS bytes used 1.23TiB
>          devid    1 size 1.72TiB used 1.24TiB path /dev/sdb2
>
> btrfs-progs v4.2
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



--------------ms020500030704040004060601
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwOTIzMTc0MTA3WjBPBgkq
hkiG9w0BCQQxQgRAxe5ws+j/TiPC2A91GkFOx8QVF+n2ZH2tvFuF/9pgO6kemG0csx3Yvkgi
HsSJXoZScZRZz2/jQjhKCOrg5mQfoDBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgAhaGvy1xP0aV2C5DLS4YF7bbotBjbFIfX61GMGeE2kN5bD/F4n
iY/TTEQ0lOWrMzGlytVx4SziJEGY4kOfXyqO8FVmmMTsQ++mFYh3dwQp7iM+0BkMJXGL6MnV
0SO+co3IpidBcHD5qe/PvHc4KfRNDnuv25aoXwvAloMLnpaMueUcNEKRezZQsRxlHcKN6CDC
4+fX7GDD2usevuVlL1nhtFNw99Ms7kjQu8dAtCqMRwP6O4xAfbJ0nxORm0KMHc+S8JsVEFrs
w5voQbm11FYT7oraGWujuC4XQqflEU4CHOlw8IbrmP78w2MppcAnWiNpqOgaM0ftsf842Mo4
d5vSm7JAXIGI23W9G/7EHIuIwqFngnPKJS5FNKfFlFUzEqIt5OHwz3LhIdC2G79uTdBTW1mp
md5mrxLLyVAEqIPaI2cJv5DT3moN4mn1ViqsDZNiXDt8Wgi6w72GnzT0MANRoj+3x6lplj4y
000iOPPg21ynTD3Wm8IQSNnKQGY9FOSr8ajEcLMeuJfk6YLuLsjsYQB/ydzEOSkVm4gwGrsT
0SUMJPLnozp2zcHB+EnANmHcCA+owlBxmNpO3U9AzzQ0vLCcsosXrVfbzEbs/3zzpXZkc57w
Khg7Jc1qUrDSUOjNIZ/KTRrPORwPlbtq/M2xfvZBN10+ch9zDNOL0t/9dwAAAAAAAA==
--------------ms020500030704040004060601--
