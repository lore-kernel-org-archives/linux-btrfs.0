Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from static.3.12.4.46.clients.your-server.de ([46.4.12.3]:46178 "EHLO
	mx.mokrynskyi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752012AbcCOArb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Mar 2016 20:47:31 -0400
Received: from localhost (localhost [127.0.0.1])
	by mx.mokrynskyi.com (Postfix) with ESMTP id 841F41322E
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Mar 2016 00:47:28 +0000 (UTC)
Received: from mx.mokrynskyi.com ([127.0.0.1])
	by localhost (mx.mokrynskyi.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5C3ljMR00cgn for <linux-btrfs@vger.kernel.org>;
	Tue, 15 Mar 2016 00:47:28 +0000 (UTC)
Received: from [192.168.1.167] (unknown [37.57.231.109])
	by mx.mokrynskyi.com (Postfix) with ESMTPSA id C9CDF1000E
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Mar 2016 00:47:26 +0000 (UTC)
Subject: Re: Major HDD performance degradation on btrfs receive
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <a55e81de-412b-c269-775d-3f8e0d96d7a9@mokrynskyi.com>
 <72cb240a-fdb2-c38b-adb1-2b72847ab29a@mokrynskyi.com>
 <CAPmG0jZvioaxdr4FNHRQJTDZwuxq5EwUTay+VB=c+hKAzdDGYg@mail.gmail.com>
 <ce805cd7-422c-ab6a-fbf8-18a304aa640d@mokrynskyi.com>
 <CAPmG0jbRmWeHvL4cUzhPBAfA=_Ue03uC-pLE4O-u5bzFF_kzEQ@mail.gmail.com>
From: Nazar Mokrynskyi <nazar@mokrynskyi.com>
Message-ID: <5240211f-27b7-2c87-41e7-c10953374921@mokrynskyi.com>
Date: Tue, 15 Mar 2016 02:47:25 +0200
MIME-Version: 1.0
In-Reply-To: <CAPmG0jbRmWeHvL4cUzhPBAfA=_Ue03uC-pLE4O-u5bzFF_kzEQ@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms020507080302000206090504"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms020507080302000206090504
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

Some update since last time (few weeks ago).

All filesystems are mounted with noatime, I've also added mounting=20
optimization - so there is no problem with remounting filesystem every=20
time, it is done only once.

Remounting optimization helped by reducing 1 complete snapshot +=20
send/receive cycle by some seconds, but otherwise it is still very slow=20
when `btrfs receive` is active.

I'm not considering bcache + btrfs as potential setup because I do not=20
currently have free SSD for it and basically spending SSD besides HDD=20
for backup partition feels like a bit of overkill (especially for=20
desktop use).

My current kernel is 4.5.0 stable, btrfs-tools still 4.4-1 from Ubuntu=20
16.04 repository as of today.

As I'm reading mailing list there are other folks having similar=20
performance issues. So can we debug things to find the root cause and=20
fix it at some point?

My C/C++/Kernel/BTRFS knowledges are scarce, which is why some=20
assistance here is needed from someone more experienced.

Sincerely, Nazar Mokrynskyi
github.com/nazar-pc
Skype: nazar-pc
Diaspora: nazarpc@diaspora.mokrynskyi.com
Tox: A9D95C9AA5F7A3ED75D83D0292E22ACE84BA40E912185939414475AF28FD2B2A5C8E=
F5261249

On 25.02.16 03:04, Henk Slager wrote:
> On Wed, Feb 24, 2016 at 11:45 PM, Nazar Mokrynskyi <nazar@mokrynskyi.co=
m> wrote:
>> Here is btrfs-show-super output:
>>
>>> nazar-pc@nazar-pc ~> sudo btrfs-show-super /dev/sda1
>>> superblock: bytenr=3D65536, device=3D/dev/sda1
>>> ---------------------------------------------------------
>>> csum            0x1e3c6fb8 [match]
>>> bytenr            65536
>>> flags            0x1
>>>              ( WRITTEN )
>>> magic            _BHRfS_M [match]
>>> fsid            40b8240a-a0a2-4034-ae55-f8558c0343a8
>>> label            Backup
>>> generation        165491
>>> root            143985360896
>>> sys_array_size        226
>>> chunk_root_generation    162837
>>> root_level        1
>>> chunk_root        247023583232
>>> chunk_root_level    1
>>> log_root        0
>>> log_root_transid    0
>>> log_root_level        0
>>> total_bytes        858993459200
>>> bytes_used        276512202752
>>> sectorsize        4096
>>> nodesize        16384
>>> leafsize        16384
>>> stripesize        4096
>>> root_dir        6
>>> num_devices        1
>>> compat_flags        0x0
>>> compat_ro_flags        0x0
>>> incompat_flags        0x169
>>>              ( MIXED_BACKREF |
>>>                COMPRESS_LZO |
>>>                BIG_METADATA |
>>>                EXTENDED_IREF |
>>>                SKINNY_METADATA )
>>> csum_type        0
>>> csum_size        4
>>> cache_generation    165491
>>> uuid_tree_generation    165491
>>> dev_item.uuid        81eee7a6-774e-4bb5-8b72-cebb85a2f2ce
>>> dev_item.fsid        40b8240a-a0a2-4034-ae55-f8558c0343a8 [match]
>>> dev_item.type        0
>>> dev_item.total_bytes    858993459200
>>> dev_item.bytes_used    291072114688
>>> dev_item.io_align    4096
>>> dev_item.io_width    4096
>>> dev_item.sector_size    4096
>>> dev_item.devid        1
>>> dev_item.dev_group    0
>>> dev_item.seek_speed    0
>>> dev_item.bandwidth    0
>>> dev_item.generation    0
>> It is sad that skinny metadata will only affect new data, probably, I'=
ll end
>> up re-creating it:(
>>
>> Can I rebalance it or something simple for this purpose?
> A balance won't help for that and also your metadata does look quite
> compact already. But I think you should not expect so much of this
> skinny metadata on a PC with 16G RAM
>
>>> Those are quite typical values for an already heavily used btrfs on a=
 HDD.
>>
>> Bad news, since I'm doing mounting/unmounting few times during snapsho=
ts
>> creation because of how BTRFS works (source code:
>> https://github.com/nazar-pc/just-backup-btrfs/blob/master/just-backup-=
btrfs.php#L148)
>>
>> So if 10+20 seconds is typical, then in my case HDD can be very busy d=
uring
>> a minute or sometimes more, this is not good and basically part or eve=
n real
>> reason of initial question.
> Yes indeed! This mount/unmount every 15 minutes (or more times per 15
> minutes) is killing for performance IMO. At the moment I don't fully
> understand why you are bothered by the limitation you mention in the
> php source comments. I think it's definitely worth to change paths
> and/or your requirements in such a way that you can avoid the
> umount/mount.
>
> As a workaround, bcache with its cache device nicely filled over time,
> will absolutely speedup the mount. But as you had some troubles with
> btrfs in the past and also you use ext4 on the same disk because it is
> a more mature filesystem, you might not want bache+btrfs for backup
> storage, it is up to you.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--------------ms020507080302000206090504
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
CQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xNjAzMTUwMDQ3MjVaMC8GCSqGSIb3
DQEJBDEiBCDd9JIGe7QtE1qG7D22a0TJCgapJqugBz1BLrqu4QTrEDBsBgkqhkiG9w0BCQ8x
XzBdMAsGCWCGSAFlAwQBKjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwIC
AgCAMA0GCCqGSIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGaBgkrBgEEAYI3
EAQxgYwwgYkwdTELMAkGA1UEBhMCSUwxFjAUBgNVBAoTDVN0YXJ0Q29tIEx0ZC4xKTAnBgNV
BAsTIFN0YXJ0Q29tIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MSMwIQYDVQQDExpTdGFydENv
bSBDbGFzcyAxIENsaWVudCBDQQIQZOr+k1bYeoai8pecbBX/jTCBnAYLKoZIhvcNAQkQAgsx
gYyggYkwdTELMAkGA1UEBhMCSUwxFjAUBgNVBAoTDVN0YXJ0Q29tIEx0ZC4xKTAnBgNVBAsT
IFN0YXJ0Q29tIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MSMwIQYDVQQDExpTdGFydENvbSBD
bGFzcyAxIENsaWVudCBDQQIQZOr+k1bYeoai8pecbBX/jTANBgkqhkiG9w0BAQEFAASCAQCt
rBC2oFDSdFI67WlWr1KVa+cgJ1nHSqDYWpaGG46s396V1QZaab+clojdERRjDt6pSC7uMrfs
B3uqxX6z2wEmspuMT/Af9rJgM8IxW0bwbeqK0DcdyiOq8g6hhJK8vIqQ7b11HdccyIin+Sl/
hLllford+KRkUXoalNHrsSbWRCJQRiOVNMzmLPMfTSZ0eV5iLUpGtVKrgCSkirBdsxQ9yzMG
7KwkFL2nte0NeqaFxI4290ZVs5eKv2lD5BTP6/i2G7OrZUtiuO+kKmFJIXbv3xmrsoeJdGLE
MjqyAwlqXsoCdrksqZBCWiWzMDj+thwEo6hO2hmii2pdyXavEoeKAAAAAAAA
--------------ms020507080302000206090504--
