Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:38130 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225AbbKMP0b (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Nov 2015 10:26:31 -0500
Received: by igbxm8 with SMTP id xm8so16369954igb.1
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2015 07:26:31 -0800 (PST)
Subject: Re: [PATCH v2] btrfs-progs: mkfs: Enable -d dup for single device
To: Zhao Lei <zhaolei@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <b2688434550d5dd940594e9a61ab0660f69cbb26.1447423853.git.zhaolei@cn.fujitsu.com>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <5646011E.2080005@gmail.com>
Date: Fri, 13 Nov 2015 10:26:22 -0500
MIME-Version: 1.0
In-Reply-To: <b2688434550d5dd940594e9a61ab0660f69cbb26.1447423853.git.zhaolei@cn.fujitsu.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms010104010609030107030701"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms010104010609030107030701
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-11-13 09:11, Zhao Lei wrote:
> Current code don't support dup profile in single device, except it
> is in mixed mode, because following reason:
> 1: In some ssd with deduplication function, it have no effect.
> 2: For a physical device, it the entire disk broken, -d dup can
>     not help.
> 3: Half performance comparing with single profile.
> 4: We have a workaround: Create multi-partition in single device,
>     and btefs will treat them as multi device.
>
> Instead of refuse -d dup, we have a better choise:
> Give user a chance to select, and output a warning to notice above
> problem.
>
> Test:
> 1: Tested by xfstests
>     Run with modified xfstests, I add test items of -d dup in single
>     device into btrfs/* and common/rc, run tests of btrfs/*,
>     with all mount option, no regression diffed with v4.3.
> 2: Tested by btrfs-progs
>     Checked following commands in "-m dup -d dup" fs with memleck
>     checking, all passed:
>     mkfs.btrfs -f --data dup --metadata dup /dev/sda6
>     btrfs filesystem show /dev/sda6
>     btrfs filesystem label /dev/sda6 btrfs_label_test
>     btrfs filesystem label /dev/sda6
>     btrfs device scan --all-devices
>     btrfs device scan /dev/sda6
>     btrfs device scan /dev/sda6
>     btrfs device ready /dev/sda6
>     btrfs check /dev/sda6
>     btrfs check -s 1 /dev/sda6
>     btrfs check --repair /dev/sda6
>     btrfs check --init-csum-tree /dev/sda6
>     btrfs check --init-extent-tree /dev/sda6
>     btrfs check --check-data-csum /dev/sda6
>     btrfs check --qgroup-report /dev/sda6
>     btrfs rescue super-recover -y /dev/sda6
>     btrfs rescue zero-log /dev/sda6
>     btrfs restore -l /dev/sda6
>     btrfs restore /dev/sda6 /
>     btrfs restore -s /dev/sda6 /
>     btrfs restore -x /dev/sda6 /
>     btrfs restore -m /dev/sda6 /
>     btrfs restore -S /dev/sda6 /
>     btrfs restore -v /dev/sda6 /
>     btrfs restore -i /dev/sda6 /
>     btrfs restore -o /dev/sda6 /
>     btrfs restore -u0 /dev/sda6 /
>     btrfs restore -u1 /dev/sda6 /
>     btrfs restore -D /dev/sda6 /
>     btrfs property list /dev/sda6
>     btrfs property get /dev/sda6 label
>     btrfs property set /dev/sda6 label test
>     btrfs property set /dev/sda6 label btrfs_label_test
>     btrfs help
>     btrfs help --full
>     btrfs version
>     btrfsck /dev/sda6
>     btrfs-find-root /dev/sda6
>     btrfs-find-root -a /dev/sda6
>     btrfs-map-logical -l1 /dev/sda6
>     btrfs-map-logical -l1 -c1 /dev/sda6
>     btrfs-map-logical -l1 -o /tmp/btrfs-map-logic-out /dev/sda6
>     btrfs-map-logical -l1 -b1 /dev/sda6
>     btrfs-select-super -s 0 /dev/sda6
>     btrfs-select-super -s 1 /dev/sda6
>     btrfstune -S 1 /dev/sda6
>     btrfstune -f -S 0 /dev/sda6
>     btrfstune -r /dev/sda6
>     btrfstune -x /dev/sda6
>     btrfstune -n /dev/sda6
>     btrfstune -f -U 00000000-0000-0000-0000-000000000000 /dev/sda6
>     btrfstune -f -u /dev/sda6
>     btrfs-calc-size /dev/sda6
>     btrfs-calc-size -v /dev/sda6
>     btrfs-calc-size -b /dev/sda6
>     btrfs-debug-tree /dev/sda6
>     btrfs-debug-tree -e /dev/sda6
>     btrfs-debug-tree -d /dev/sda6
>     btrfs-debug-tree -r /dev/sda6
>     btrfs-debug-tree -R /dev/sda6
>     btrfs-debug-tree -u /dev/sda6
>     btrfs-debug-tree -b 0 /dev/sda6
>     btrfs-debug-tree -t 0 /dev/sda6
>     btrfs-debug-tree -t 2 /dev/sda6
>     btrfs-show-super /dev/sda6
>     btrfs-show-super -i 0 /dev/sda6
>     btrfs-show-super -i 1 /dev/sda6
>     btrfs-show-super -i 2 /dev/sda6
>     btrfs-show-super -a /dev/sda6
>     btrfs-show-super -f /dev/sda6
>     btrfs-show-super -F /dev/sda6
>     btrfs subvolume list /mnt/btrfs-progs-tests
>     btrfs subvolume create /mnt/btrfs-progs-tests/mysubvol
>     btrfs subvolume list /mnt/btrfs-progs-tests
>     btrfs subvolume get-default /mnt/btrfs-progs-tests
>     btrfs subvolume set-default 258 /mnt/btrfs-progs-tests
>     btrfs subvolume get-default /mnt/btrfs-progs-tests
>     btrfs subvolume set-default  /mnt/btrfs-progs-tests
>     btrfs subvolume snapshot /mnt/btrfs-progs-tests/mysubvol /mnt/btrfs=
-progs-tests/mysubvol_snap
>     btrfs subvolume list /mnt/btrfs-progs-tests
>     btrfs subvolume find-new /mnt/btrfs-progs-tests 0
>     btrfs subvolume find-new /mnt/btrfs-progs-tests 0
>     btrfs subvolume find-new /mnt/btrfs-progs-tests/mysubvol 0
>     btrfs subvolume find-new /mnt/btrfs-progs-tests/mysubvol 0
>     btrfs subvolume show /mnt/btrfs-progs-tests
>     btrfs subvolume show /mnt/btrfs-progs-tests/mysubvol
>     btrfs subvolume show /mnt/btrfs-progs-tests/mysubvol_snap
>     btrfs subvolume sync /mnt/btrfs-progs-tests
>     btrfs subvolume delete /mnt/btrfs-progs-tests/mysubvol_snap
>     btrfs subvolume delete /mnt/btrfs-progs-tests/mysubvol
>     btrfs subvolume sync /mnt/btrfs-progs-tests
>     btrfs filesystem df /mnt/btrfs-progs-tests
>     btrfs filesystem show /mnt/btrfs-progs-tests
>     btrfs filesystem sync /mnt/btrfs-progs-tests
>     btrfs filesystem label /mnt/btrfs-progs-tests btrfs_label_test
>     btrfs filesystem label /mnt/btrfs-progs-tests
>     btrfs filesystem usage /mnt/btrfs-progs-tests
>     btrfs filesystem defragment -s 1024 -l 2048 /mnt/btrfs-progs-tests/=
filesystem_test_dir/test_dir_0/test_file_0
>     btrfs filesystem defragment /mnt/btrfs-progs-tests/filesystem_test_=
dir/test_dir_0/test_file_1
>     btrfs filesystem defragment -f /mnt/btrfs-progs-tests/filesystem_te=
st_dir/test_dir_0/test_file_2
>     btrfs filesystem defragment -czlib /mnt/btrfs-progs-tests/filesyste=
m_test_dir/test_dir_0/test_file_3
>     btrfs filesystem defragment -clzo /mnt/btrfs-progs-tests/filesystem=
_test_dir/test_dir_0/test_file_4
>     btrfs filesystem defragment /mnt/btrfs-progs-tests/filesystem_test_=
dir
>     btrfs filesystem defragment -r /mnt/btrfs-progs-tests/filesystem_te=
st_dir
>     btrfs filesystem defragment /mnt/btrfs-progs-tests
>     btrfs filesystem resize 1:-10M /mnt/btrfs-progs-tests
>     btrfs filesystem resize 1:max /mnt/btrfs-progs-tests
>     btrfs balance start /mnt/btrfs-progs-tests
>     btrfs balance start -v /mnt/btrfs-progs-tests
>     btrfs balance start -f /mnt/btrfs-progs-tests
>     btrfs balance status -v /mnt/btrfs-progs-tests
>     btrfs balance pause /mnt/btrfs-progs-tests
>     btrfs balance status /mnt/btrfs-progs-tests
>     btrfs balance resume /mnt/btrfs-progs-tests
>     btrfs balance status -v /mnt/btrfs-progs-tests
>     btrfs balance cancel /mnt/btrfs-progs-tests
>     btrfs balance start -dprofiles=3Dsingle /mnt/btrfs-progs-tests
>     btrfs balance start -dconvert=3Dsingle /mnt/btrfs-progs-tests
>     btrfs balance start -ddevid=3D1 /mnt/btrfs-progs-tests
>     btrfs balance start -f -mprofiles=3Dsingle /mnt/btrfs-progs-tests
>     btrfs balance start -f -mconvert=3Dsingle /mnt/btrfs-progs-tests
>     btrfs balance start -f -mdevid=3D1 /mnt/btrfs-progs-tests
>     btrfs balance start -f -sprofiles=3Dsingle /mnt/btrfs-progs-tests
>     btrfs balance start -f -sconvert=3Dsingle /mnt/btrfs-progs-tests
>     btrfs balance start -f -sdevid=3D1 /mnt/btrfs-progs-tests
>     btrfs device add -f /dev/sda10 /mnt/btrfs-progs-tests
>     btrfs device del /dev/sda10 /mnt/btrfs-progs-tests
>     btrfs device stats /dev/sda6
>     btrfs device stats -z /dev/sda6
>     btrfs device stats /mnt/btrfs-progs-tests
>     btrfs device stats -z /mnt/btrfs-progs-tests
>     btrfs device usage /mnt/btrfs-progs-tests
>     btrfs scrub status /mnt/btrfs-progs-tests
>     btrfs scrub start -B /mnt/btrfs-progs-tests
>     btrfs scrub start -B -d /mnt/btrfs-progs-tests
>     btrfs scrub start -B -r /mnt/btrfs-progs-tests
>     btrfs scrub status /mnt/btrfs-progs-tests
>     btrfs scrub start /mnt/btrfs-progs-tests
>     btrfs scrub status /mnt/btrfs-progs-tests
>     btrfs scrub status /mnt/btrfs-progs-tests
>     btrfs scrub status -d /mnt/btrfs-progs-tests
>     btrfs scrub status -R /mnt/btrfs-progs-tests
>     btrfs scrub status /mnt/btrfs-progs-tests
>     btrfs scrub start /dev/sda6
>     btrfs scrub status /dev/sda6
>     btrfs scrub status /dev/sda6
>     btrfs scrub status -d /dev/sda6
>     btrfs scrub status -R /dev/sda6
>     btrfs scrub status /dev/sda6
>     btrfs subvolume snapshot -r /mnt/btrfs-progs-tests /mnt/btrfs-progs=
-tests/snap1
>     btrfs send -f /tmp/btrfs_snapshot_test /mnt/btrfs-progs-tests/snap1=

>     btrfs send -e -f /tmp/btrfs_snapshot_test /mnt/btrfs-progs-tests/sn=
ap1
>     btrfs send --no-data -f /tmp/btrfs_snapshot_test /mnt/btrfs-progs-t=
ests/snap1
>     btrfs quota enable /mnt/btrfs-progs-tests
>     btrfs quota rescan /mnt/btrfs-progs-tests
>     btrfs quota rescan -s /mnt/btrfs-progs-tests
>     btrfs quota rescan -w /mnt/btrfs-progs-tests
>     btrfs quota disable /mnt/btrfs-progs-tests
>     btrfs quota enable /mnt/btrfs-progs-tests
>     btrfs qgroup create 1/5 /mnt/btrfs-progs-tests
>     btrfs qgroup create 2/5 /mnt/btrfs-progs-tests
>     btrfs qgroup assign 1/5 2/5 /mnt/btrfs-progs-tests
>     btrfs qgroup limit 1G 1/5 /mnt/btrfs-progs-tests
>     btrfs qgroup show /mnt/btrfs-progs-tests
>     btrfs qgroup show -p -c -r -e -F -f /mnt/btrfs-progs-tests
>     btrfs qgroup remove 1/5 2/5 /mnt/btrfs-progs-tests
>     btrfs qgroup destroy 2/5 /mnt/btrfs-progs-tests
>     btrfs qgroup destroy 1/5 /mnt/btrfs-progs-tests
>     btrfs quota disable /mnt/btrfs-progs-tests
>     btrfs replace start -f -B /dev/sda6 /dev/sda10 /mnt/btrfs-progs-tes=
ts
>     btrfs replace status /mnt/btrfs-progs-tests
>     btrfs replace start -f -B /dev/sda10 /dev/sda6 /mnt/btrfs-progs-tes=
ts
>     btrfs-convert /dev/sda6
>     btrfs-convert -r /dev/sda6
>     btrfs-convert -d /dev/sda6
>     btrfs-convert -i /dev/sda6
>     btrfs-convert -n /dev/sda6
>     btrfs-convert -N 4096 /dev/sda6
>     btrfs-convert -l test /dev/sda6
>     btrfs-convert -L /dev/sda6
>     btrfs-convert --no-progress /dev/sda6
>     mkfs.btrfs -f /dev/sda6
>     btrfs-image /dev/sda6 /tmp/btrfs_image.img
>     btrfs-image -r /tmp/btrfs_image.img /dev/sda6
>     mkfs.btrfs -f /dev/sda6
>     btrfs-image -c 0 /dev/sda6 /tmp/btrfs_image.img
>     btrfs-image -r /tmp/btrfs_image.img /dev/sda6
>     mkfs.btrfs -f /dev/sda6
>     btrfs-image -c 9 /dev/sda6 /tmp/btrfs_image.img
>     btrfs-image -r /tmp/btrfs_image.img /dev/sda6
>     mkfs.btrfs -f /dev/sda6
>     btrfs-image -t 0 /dev/sda6 /tmp/btrfs_image.img
>     btrfs-image -r /tmp/btrfs_image.img /dev/sda6
>     mkfs.btrfs -f /dev/sda6
>     btrfs-image -t 1 /dev/sda6 /tmp/btrfs_image.img
>     btrfs-image -r /tmp/btrfs_image.img /dev/sda6
>     mkfs.btrfs -f /dev/sda6
>     btrfs-image -t 32 /dev/sda6 /tmp/btrfs_image.img
>     btrfs-image -r /tmp/btrfs_image.img /dev/sda6
>     mkfs.btrfs -f /dev/sda6
>     btrfs-image -w /dev/sda6 /tmp/btrfs_image.img
>     btrfs-image -r /tmp/btrfs_image.img /dev/sda6
>     mkfs.btrfs -f /dev/sda6
>     btrfs-image -w /dev/sda6 /tmp/btrfs_image.img
>     btrfs-image -r /tmp/btrfs_image.img /dev/sda6
>     btrfs-image -r -t 0 /tmp/btrfs_image.img /dev/sda6
>     btrfs-image -r -t 1 /tmp/btrfs_image.img /dev/sda6
>     btrfs-image -r -t 32 /tmp/btrfs_image.img /dev/sda6
>     btrfs-image -r -o /tmp/btrfs_image.img /dev/sda6
> 3: Manual check relation source by:
>     grep DUP *.c
>     Confirmed that all source are modified.
> 4: Use this raid type manually, do some operations in fs,
>     no error found in command and dmesg.
>
> Changelog v1->v2:
> Fix a bug in v1 which cause no dup chunk created, found by above
> check command.
>
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
I'm going to put this in the queue of things I'm running tests for this=20
weekend, expect something back from me on Monday about it (based on the=20
patch itself though, I expect that I won't find any issues on the=20
userspace side of things).


--------------ms010104010609030107030701
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMTEzMTUyNjIyWjBPBgkq
hkiG9w0BCQQxQgRAAWij81s6LTU98D2VW+MMKXPChQtH8NAeatl3/8hraoahVeoDwUPclUvj
ynqcuowT/aB8+//DTCKKBY/WOw83/DBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgAr5G6ac+C2YQV+3zhvbJlq7PDYYJg3HJ2pQZaKnjS9yci2vBBA
bUGvokFuxM6FHQ6UQ76Kv02MEGtWhqZEkq+KMCMfamZUDhcihGNXpGbl2ASs42tOjPt78I9d
WLpUIL7uDWiym/naD3M1Gcu70VIKMKB6211AGKML/knNmetUlSPdwSwmCwuBm4WgnkWG4yqZ
9/Z1SlaznDgrr4vV+f8jIq3mesQyCUqKV+42+SM9qiRfi30yFJZPvW5xJZx6Cmgn3W/qqy9f
eQh6G39GysDIlNcKZJbT8Qgzi4R/Q4TOPUOFF2bUVvBdF5j2onR+WgLHPR6nyH531LbFw0XQ
0E9UcqCF7aMeFkGFhLCXIuEoklC0ltqu3oXBuvcQ2PinabksUcpj0jxsLa6zKe3RbrLrnefL
E70W4bk1KOiZbBgrMNldkl5UGshcB9/MxYo6RJAoXbAT6Oms3Wlz1wR16E9f+A4HWq6j9WN1
koVzuFyvkyjcMJyolzL7Gx5P1RN6wVM0rlNt79UbMER84dSpfZCd72M1QX7ZG026I695FC10
voAT6UxWj36Ht9QYOfB67RajffNK2V0owtEv6MFKMEv1Wpt0Rox6GEYBc17Uvg+RsZpiU2oq
Gl/VOl+I/l5RUiIDUmlh/MwaB7SoTsp8rO7RAVTtxFeTSUQ3ChH8JwGCjAAAAAAAAA==
--------------ms010104010609030107030701--
