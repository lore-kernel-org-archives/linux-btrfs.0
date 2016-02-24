Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from static.3.12.4.46.clients.your-server.de ([46.4.12.3]:58160 "EHLO
	mx.mokrynskyi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750719AbcBXWqb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Feb 2016 17:46:31 -0500
Received: from localhost (localhost [127.0.0.1])
	by mx.mokrynskyi.com (Postfix) with ESMTP id 58315BF5C
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Feb 2016 22:46:29 +0000 (UTC)
Received: from mx.mokrynskyi.com ([127.0.0.1])
	by localhost (mx.mokrynskyi.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 98mN_n0TncSx for <linux-btrfs@vger.kernel.org>;
	Wed, 24 Feb 2016 22:46:29 +0000 (UTC)
Received: from [10.8.0.6] (unknown [91.234.34.231])
	by mx.mokrynskyi.com (Postfix) with ESMTPSA id 9D3A7CF8E
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Feb 2016 22:46:27 +0000 (UTC)
From: Nazar Mokrynskyi <nazar@mokrynskyi.com>
Subject: Re: Major HDD performance degradation on btrfs receive
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <a55e81de-412b-c269-775d-3f8e0d96d7a9@mokrynskyi.com>
 <72cb240a-fdb2-c38b-adb1-2b72847ab29a@mokrynskyi.com>
 <CAPmG0jZvioaxdr4FNHRQJTDZwuxq5EwUTay+VB=c+hKAzdDGYg@mail.gmail.com>
Message-ID: <95868ad3-0f2b-d615-466f-ee3c0182e64b@mokrynskyi.com>
Date: Wed, 24 Feb 2016 23:46:26 +0100
MIME-Version: 1.0
In-Reply-To: <CAPmG0jZvioaxdr4FNHRQJTDZwuxq5EwUTay+VB=c+hKAzdDGYg@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms020906080005000203070600"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms020906080005000203070600
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

Here is btrfs-show-super output:

> nazar-pc@nazar-pc ~> sudo btrfs-show-super /dev/sda1
> superblock: bytenr=3D65536, device=3D/dev/sda1
> ---------------------------------------------------------
> csum            0x1e3c6fb8 [match]
> bytenr            65536
> flags            0x1
>             ( WRITTEN )
> magic            _BHRfS_M [match]
> fsid            40b8240a-a0a2-4034-ae55-f8558c0343a8
> label            Backup
> generation        165491
> root            143985360896
> sys_array_size        226
> chunk_root_generation    162837
> root_level        1
> chunk_root        247023583232
> chunk_root_level    1
> log_root        0
> log_root_transid    0
> log_root_level        0
> total_bytes        858993459200
> bytes_used        276512202752
> sectorsize        4096
> nodesize        16384
> leafsize        16384
> stripesize        4096
> root_dir        6
> num_devices        1
> compat_flags        0x0
> compat_ro_flags        0x0
> incompat_flags        0x169
>             ( MIXED_BACKREF |
>               COMPRESS_LZO |
>               BIG_METADATA |
>               EXTENDED_IREF |
>               SKINNY_METADATA )
> csum_type        0
> csum_size        4
> cache_generation    165491
> uuid_tree_generation    165491
> dev_item.uuid        81eee7a6-774e-4bb5-8b72-cebb85a2f2ce
> dev_item.fsid        40b8240a-a0a2-4034-ae55-f8558c0343a8 [match]
> dev_item.type        0
> dev_item.total_bytes    858993459200
> dev_item.bytes_used    291072114688
> dev_item.io_align    4096
> dev_item.io_width    4096
> dev_item.sector_size    4096
> dev_item.devid        1
> dev_item.dev_group    0
> dev_item.seek_speed    0
> dev_item.bandwidth    0
> dev_item.generation    0
It is sad that skinny metadata will only affect new data, probably, I'll =

end up re-creating it:(

Can I rebalance it or something simple for this purpose?

> Those are quite typical values for an already heavily used btrfs on a H=
DD.

Bad news, since I'm doing mounting/unmounting few times during snapshots =

creation because of how BTRFS works (source code:=20
https://github.com/nazar-pc/just-backup-btrfs/blob/master/just-backup-btr=
fs.php#L148)

So if 10+20 seconds is typical, then in my case HDD can be very busy=20
during a minute or sometimes more, this is not good and basically part=20
or even real reason of initial question.

Sincerely, Nazar Mokrynskyi
github.com/nazar-pc
Skype: nazar-pc
Diaspora: nazarpc@diaspora.mokrynskyi.com
Tox:=20
A9D95C9AA5F7A3ED75D83D0292E22ACE84BA40E912185939414475AF28FD2B2A5C8EF5261=
249

On 24.02.16 23:32, Henk Slager wrote:
> On Tue, Feb 23, 2016 at 6:44 PM, Nazar Mokrynskyi <nazar@mokrynskyi.com=
> wrote:
>> Looks like btrfstune -x did nothing, probably, it was already used at
>> creation time, I'm using rcX versions of kernel all the time and rolli=
ng
>> version of Ubuntu, so this is very likely to be the case.
> The command    btrfs-show-super   shows the features of the
> filesystem. You have a 'dummy' single profiles on the HDD fs and that
> gives me a hint that you likely have used older tools to create the
> fs. The current kernel does not set this feature flag on disk. If the
> flag was already set, then no difference in performance.
>
> If it was not set, then from now on, new metadata extents should be
> skinny, which saves on total memory size and processing for (the
> larger) filesystems. But for your existing data (snapshot subvolumes
> in your  case) the metadata is then still non-skinny. So you won't
> notice an instant difference only after all exiting fileblocks are
> re-written or removed.
> You will probably have a measurable difference if you equally fill 2
> filesystems, one with and the other without the flag.
>
>> One thing I've noticed is much slower mount/umount on HDD than on SSD:=

>>
>>> nazar-pc@nazar-pc ~> time sudo umount /backup
>>> 0.00user 0.00system 0:00.01elapsed 36%CPU (0avgtext+0avgdata
>>> 7104maxresident)k
>>> 0inputs+0outputs (0major+784minor)pagefaults 0swaps
>>> nazar-pc@nazar-pc ~> time sudo mount /backup
>>> 0.00user 0.00system 0:00.03elapsed 23%CPU (0avgtext+0avgdata
>>> 7076maxresident)k
>>> 0inputs+0outputs (0major+803minor)pagefaults 0swaps
>>> nazar-pc@nazar-pc ~> time sudo umount /backup_hdd
>>> 0.00user 0.11system 0:01.04elapsed 11%CPU (0avgtext+0avgdata
>>> 7092maxresident)k
>>> 0inputs+15296outputs (0major+787minor)pagefaults 0swaps
>>> nazar-pc@nazar-pc ~> time sudo mount /backup_hdd
>>> 0.00user 0.02system 0:04.45elapsed 0%CPU (0avgtext+0avgdata
>>> 7140maxresident)k
>>> 14648inputs+0outputs (0major+795minor)pagefaults 0swaps
>> It is especially long (tenth of seconds with hight HDD load) when call=
ed
>> after some time, not consequently.
>>
>> Once it took something like 20 seconds to unmount filesystem and aroun=
d 10
>> seconds to mount it.
> Those are quite typical values for an already heavily used btrfs on a H=
DD.
>
>>> About memory - 16 GiB of RAM should be enough I guess:) Can I measure=

>>> somehow if seeking is a problem?
> I don't know a tool that can measure seek times and gather statistics
> over and extended period of time and relate that to filesystem
> internal actions. It would be best if all this were done by the HDD
> firmware (under command of the filesystem code). One can make a model
> of it I think, but the question is how good that is for modern drives.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html




--------------ms020906080005000203070600
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: ÐÑÑÐ¿ÑÐ¾Ð³ÑÐ°ÑÑÑÐ½Ð¸Ð¹ Ð¿ÑÐ´Ð¿Ð¸Ñ S/MIME

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCC
CuMwggT5MIID4aADAgECAhBk6v6TVth6hqLyl5xsFf+NMA0GCSqGSIb3DQEBCwUAMHUxCzAJ
BgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSkwJwYDVQQLEyBTdGFydENvbSBD
ZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEjMCEGA1UEAxMaU3RhcnRDb20gQ2xhc3MgMSBDbGll
bnQgQ0EwHhcNMTUxMjIyMDYwNTUxWhcNMTYxMjIyMDYwNTUxWjBEMR0wGwYDVQQDDBRuYXph
ckBtb2tyeW5za3lpLmNvbTEjMCEGCSqGSIb3DQEJARYUbmF6YXJAbW9rcnluc2t5aS5jb20w
ggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCugsLCcazI+Sjl29kaCHer/z6I0aPy
cKYqk4Bk0jUE6CcfQLX98E8b1sc2kbBjwd+jPPvWtqSGHzLUKLL1jfXJC6X5At+UHNdWiU6n
xaKnCiWiV0NZK6AVfrr+KdP+f1gYfMryPp/JkzcRDquML+YSz0BJ3ODaU538lDtC2sPeH7hY
nTiuMBfL6h2c680MF9UrIUqvqJ94QEillrDShGxaMHIWZepLxydmACnI9Sga8dZPjG84hV//
JKGRmdlQ1fA7g0LUE2hZcY/zdB6Qey87ctNkND/bQfghbArOdJZK2/cal0xJ6znrPAyqs7wj
2HVz8/coOlXPPsV4OkoA9X1PAgMBAAGjggG0MIIBsDALBgNVHQ8EBAMCBLAwHQYDVR0lBBYw
FAYIKwYBBQUHAwIGCCsGAQUFBwMEMAkGA1UdEwQCMAAwHQYDVR0OBBYEFCfmAiR7cI5aUj1L
5j5v0+wVzVy1MB8GA1UdIwQYMBaAFCSBbDlhvkkPj7cbRivJKLUnSG1oMG8GCCsGAQUFBwEB
BGMwYTAkBggrBgEFBQcwAYYYaHR0cDovL29jc3Auc3RhcnRzc2wuY29tMDkGCCsGAQUFBzAC
hi1odHRwOi8vYWlhLnN0YXJ0c3NsLmNvbS9jZXJ0cy9zY2EuY2xpZW50MS5jcnQwOAYDVR0f
BDEwLzAtoCugKYYnaHR0cDovL2NybC5zdGFydHNzbC5jb20vc2NhLWNsaWVudDEuY3JsMB8G
A1UdEQQYMBaBFG5hemFyQG1va3J5bnNreWkuY29tMCMGA1UdEgQcMBqGGGh0dHA6Ly93d3cu
c3RhcnRzc2wuY29tLzBGBgNVHSAEPzA9MDsGCysGAQQBgbU3AQIEMCwwKgYIKwYBBQUHAgEW
Hmh0dHA6Ly93d3cuc3RhcnRzc2wuY29tL3BvbGljeTANBgkqhkiG9w0BAQsFAAOCAQEAkIZk
GJPfY91CrJnZzsF0+qviIsqRCWqdT64E5ttyODEvfo9TVccBvwTgVZzKJY2e+ALaDNX0dBH+
9YXMUg5pNfXGHauhQjGan8bdKsaLhvqaq3g0CO1oZU38pqizWTzQYbzu62414VeIDauHMbFD
pdRD0Egx/iY8R7JAO9k+hciD0W/L7FPRU7UTtz1vPqrKO54mYNFMn6EUhR2poM1j0dmwZH4W
Cly6N88RT6zhncbgDnjKr6+IHCxSP0E75uf+6kgbYRtwHnLydUIZdkEESlHhKdgJJFoL7nHr
PU3kWyAMrRdf2YtCwDa5USI5mE9v6sf0ynMrThlXbkb12Dz9wzCCBeIwggPKoAMCAQICEGun
in0K14jWUQr5WeTntOEwDQYJKoZIhvcNAQELBQAwfTELMAkGA1UEBhMCSUwxFjAUBgNVBAoT
DVN0YXJ0Q29tIEx0ZC4xKzApBgNVBAsTIlNlY3VyZSBEaWdpdGFsIENlcnRpZmljYXRlIFNp
Z25pbmcxKTAnBgNVBAMTIFN0YXJ0Q29tIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MB4XDTE1
MTIxNjAxMDAwNVoXDTMwMTIxNjAxMDAwNVowdTELMAkGA1UEBhMCSUwxFjAUBgNVBAoTDVN0
YXJ0Q29tIEx0ZC4xKTAnBgNVBAsTIFN0YXJ0Q29tIENlcnRpZmljYXRpb24gQXV0aG9yaXR5
MSMwIQYDVQQDExpTdGFydENvbSBDbGFzcyAxIENsaWVudCBDQTCCASIwDQYJKoZIhvcNAQEB
BQADggEPADCCAQoCggEBAL192vfDon2D9luC/dtbX64eG3XAtRmvmCSsu1d52DXsCR58zJQb
CtB2/A5uFqNxWacpXGGtTCRk9dEDBlmixEd8QiLkUfvHpJX/xKnmVkS6Iye8wUbYzMsDzgnp
azlPg19dnSqfhM+Cevdfa89VLnUztRr2cgmCfyO9Otrh7LJDPG+4D8ZnAqDtVB8MKYJL6QgK
yVhhaBc4y3bGWxKyXEtx7QIZZGxPwSkzK3WIN+VKNdkiwTubW5PIdopmykwvIjLPqbJK7yPw
FZYekKE015OsW6FV+s4DIM8UlVS8pkIsoGGJtMuWjLL4tq2hYQuuN0jhrxK1ljz50hH23gA9
cbMCAwEAAaOCAWQwggFgMA4GA1UdDwEB/wQEAwIBBjAdBgNVHSUEFjAUBggrBgEFBQcDAgYI
KwYBBQUHAwQwEgYDVR0TAQH/BAgwBgEB/wIBADAyBgNVHR8EKzApMCegJaAjhiFodHRwOi8v
Y3JsLnN0YXJ0c3NsLmNvbS9zZnNjYS5jcmwwZgYIKwYBBQUHAQEEWjBYMCQGCCsGAQUFBzAB
hhhodHRwOi8vb2NzcC5zdGFydHNzbC5jb20wMAYIKwYBBQUHMAKGJGh0dHA6Ly9haWEuc3Rh
cnRzc2wuY29tL2NlcnRzL2NhLmNydDAdBgNVHQ4EFgQUJIFsOWG+SQ+PtxtGK8kotSdIbWgw
HwYDVR0jBBgwFoAUTgvvGqRAW6UXaYcwyjRoQ9BBrvIwPwYDVR0gBDgwNjA0BgRVHSAAMCww
KgYIKwYBBQUHAgEWHmh0dHA6Ly93d3cuc3RhcnRzc2wuY29tL3BvbGljeTANBgkqhkiG9w0B
AQsFAAOCAgEAi+P3h+wBi4StDwECW5zhIycjBL008HACblIf26HY0JdOruKbrWDsXUsiI0j/
7Crft9S5oxvPiDtVqspBOB/y5uzSns1lZwh7sG96bYBZpcGzGxpFNjDmQbcM3yl3WFIRS4Wh
NrsOY14V7y2IrUGsvetsD+bjyOngCIVeC/GmsmtbuLOzJ606tEc9uRbhjTu/b0x2Fo+/e7Uk
QvKzNeo7OMhijixaULyINBfCBJb+e29bLafgu6JqjOUJ9eXXj20p6q/CW+uVrZiSW57+q5an
2P2i7hP85jQJcy5j4HzA0rSiF3YPhKGAWUxKPMAVGgcYoXzWydOvZ3UDsTDTagXpRDIKQLZo
02wrlxY6iMFqvlzsemVf1odhQJmi7Eh5TbxI40kDGcBOBHhwnaOumZhLP+SWJQnjpLpSlUOj
95uf1zo9oz9e0NgIJoz/tdfrBzez76xtDsK0KfUDHt1/q59BvDI7RX6gVr0fQoCyMczNzCTc
RXYHY0tq2J0oT+bsb6sH2b4WVWAiJKnSYaWDjdA70qHX4mq9MIjO/ZskmSY8wtAk24orAc0v
wXgYanqNsBX5Yv4sN4Z9VyrwMdLcusP7HJgRdAGKpkR2I9U4zEsNJQJewM7S4Jalo1DyPrLp
L2nTET8ZrSl5Utp1UeGp/2deoprGevfnxWB+vHNQiu85o6MxggPMMIIDyAIBATCBiTB1MQsw
CQYDVQQGEwJJTDEWMBQGA1UEChMNU3RhcnRDb20gTHRkLjEpMCcGA1UECxMgU3RhcnRDb20g
Q2VydGlmaWNhdGlvbiBBdXRob3JpdHkxIzAhBgNVBAMTGlN0YXJ0Q29tIENsYXNzIDEgQ2xp
ZW50IENBAhBk6v6TVth6hqLyl5xsFf+NMA0GCWCGSAFlAwQCAQUAoIICEzAYBgkqhkiG9w0B
CQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xNjAyMjQyMjQ2MjZaMC8GCSqGSIb3
DQEJBDEiBCAPSGEtJcpKis484rYw4kWgWZ3Q0ZITB3An2rgbcA7elTBsBgkqhkiG9w0BCQ8x
XzBdMAsGCWCGSAFlAwQBKjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwIC
AgCAMA0GCCqGSIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGaBgkrBgEEAYI3
EAQxgYwwgYkwdTELMAkGA1UEBhMCSUwxFjAUBgNVBAoTDVN0YXJ0Q29tIEx0ZC4xKTAnBgNV
BAsTIFN0YXJ0Q29tIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MSMwIQYDVQQDExpTdGFydENv
bSBDbGFzcyAxIENsaWVudCBDQQIQZOr+k1bYeoai8pecbBX/jTCBnAYLKoZIhvcNAQkQAgsx
gYyggYkwdTELMAkGA1UEBhMCSUwxFjAUBgNVBAoTDVN0YXJ0Q29tIEx0ZC4xKTAnBgNVBAsT
IFN0YXJ0Q29tIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MSMwIQYDVQQDExpTdGFydENvbSBD
bGFzcyAxIENsaWVudCBDQQIQZOr+k1bYeoai8pecbBX/jTANBgkqhkiG9w0BAQEFAASCAQCM
koR0F4dC4/xPOyqdLs3RKbS6G0Qjl08hXqCOaNXB9yhX8XIFEcsvrlqfP7WDj6n+WC2mG2ks
pR2V6f5cyeBcHqKnucdmnNtKrUJfpG9zwHLopKmL3jLToJQhrCJObQQJW55jG6sm0VugRf+i
pXWEiT8mRzJZk4SsQeTIuF6RnCZMhqIT9YZBWUhq7Fq6GDwEngKuy2X3VhVDEFZzvM8zmKn8
FB5v9V+Hs616knrWpPc9PpndGrKAYI44ITeAP2r8CsHp25mqnjeaCZMM1zaEtB91DTjSVnLB
a2IvtOowNQob0YRv0Xqu5p4UBjQJtXVztdIOqPETRhCMx3ig71UzAAAAAAAA
--------------ms020906080005000203070600--
