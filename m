Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from static.3.12.4.46.clients.your-server.de ([46.4.12.3]:44365 "EHLO
	mx.mokrynskyi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965719AbcCPDhH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Mar 2016 23:37:07 -0400
Received: from localhost (localhost [127.0.0.1])
	by mx.mokrynskyi.com (Postfix) with ESMTP id 3B41913422
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Mar 2016 03:37:05 +0000 (UTC)
Received: from mx.mokrynskyi.com ([127.0.0.1])
	by localhost (mx.mokrynskyi.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mWKHHXxFz3D8 for <linux-btrfs@vger.kernel.org>;
	Wed, 16 Mar 2016 03:37:04 +0000 (UTC)
Received: from [192.168.1.167] (unknown [37.57.231.109])
	by mx.mokrynskyi.com (Postfix) with ESMTPSA id 59E931317F
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Mar 2016 03:37:03 +0000 (UTC)
Subject: Re: Major HDD performance degradation on btrfs receive
References: <a55e81de-412b-c269-775d-3f8e0d96d7a9@mokrynskyi.com>
 <72cb240a-fdb2-c38b-adb1-2b72847ab29a@mokrynskyi.com>
 <CAPmG0jZvioaxdr4FNHRQJTDZwuxq5EwUTay+VB=c+hKAzdDGYg@mail.gmail.com>
 <ce805cd7-422c-ab6a-fbf8-18a304aa640d@mokrynskyi.com>
 <CAPmG0jbRmWeHvL4cUzhPBAfA=_Ue03uC-pLE4O-u5bzFF_kzEQ@mail.gmail.com>
 <5240211f-27b7-2c87-41e7-c10953374921@mokrynskyi.com>
 <CAPmG0jZwapQ1=V-dHMEEwMYQUjb4+1M102eo96XQeJQV1JoxeQ@mail.gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Nazar Mokrynskyi <nazar@mokrynskyi.com>
Message-ID: <1557fe0b-bbcc-c125-5220-46a56e936590@mokrynskyi.com>
Date: Wed, 16 Mar 2016 05:37:02 +0200
MIME-Version: 1.0
In-Reply-To: <CAPmG0jZwapQ1=V-dHMEEwMYQUjb4+1M102eo96XQeJQV1JoxeQ@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms020506020501020705020803"
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms020506020501020705020803
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

> It could also be that the disk is bit older and has or is starting to
> use its spare sectors.
I do not really think HDD is that old. I've got it brand new less than=20
year ago. Here is smartctl output:

> nazar-pc@nazar-pc ~> sudo smartctl -a /dev/sda
> smartctl 6.5 2016-01-24 r4214 [x86_64-linux-4.5.0-haswell] (local build=
)
> Copyright (C) 2002-16, Bruce Allen, Christian Franke,=20
> www.smartmontools.org
>
> =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
> Model Family:     Seagate Samsung SpinPoint M9T
> Device Model:     ST2000LM003 HN-M201RAD
> Serial Number:    S34RJ9CF727799
> LU WWN Device Id: 5 0004cf 20dbc7ec5
> Firmware Version: 2BC10004
> User Capacity:    2 000 398 934 016 bytes [2,00 TB]
> Sector Sizes:     512 bytes logical, 4096 bytes physical
> Rotation Rate:    5400 rpm
> Form Factor:      2.5 inches
> Device is:        In smartctl database [for details use: -P show]
> ATA Version is:   ATA8-ACS T13/1699-D revision 6
> SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
> Local Time is:    Wed Mar 16 01:25:17 2016 EET
> SMART support is: Available - device has SMART capability.
> SMART support is: Enabled
>
> =3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
> SMART overall-health self-assessment test result: PASSED
>
> General SMART Values:
> Offline data collection status:  (0x00)    Offline data collection=20
> activity
>                     was never started.
>                     Auto Offline Data Collection: Disabled.
> Self-test execution status:      (   0)    The previous self-test=20
> routine completed
>                     without error or no self-test has ever
>                     been run.
> Total time to complete Offline
> data collection:         (23760) seconds.
> Offline data collection
> capabilities:              (0x5b) SMART execute Offline immediate.
>                     Auto Offline data collection on/off support.
>                     Suspend Offline collection upon new
>                     command.
>                     Offline surface scan supported.
>                     Self-test supported.
>                     No Conveyance Self-test supported.
>                     Selective Self-test supported.
> SMART capabilities:            (0x0003)    Saves SMART data before=20
> entering
>                     power-saving mode.
>                     Supports SMART auto save timer.
> Error logging capability:        (0x01)    Error logging supported.
>                     General Purpose Logging supported.
> Short self-test routine
> recommended polling time:      (   1) minutes.
> Extended self-test routine
> recommended polling time:      ( 396) minutes.
> SCT capabilities:            (0x003f)    SCT Status supported.
>                     SCT Error Recovery Control supported.
>                     SCT Feature Control supported.
>                     SCT Data Table supported.
>
> SMART Attributes Data Structure revision number: 16
> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE     =20
> UPDATED  WHEN_FAILED RAW_VALUE
>   1 Raw_Read_Error_Rate     0x002f   100   100   051 Pre-fail =20
> Always       -       16
>   2 Throughput_Performance  0x0026   252   252   000 Old_age  =20
> Always       -       0
>   3 Spin_Up_Time            0x0023   088   086   025 Pre-fail =20
> Always       -       3760
>   4 Start_Stop_Count        0x0032   100   100   000 Old_age  =20
> Always       -       840
>   5 Reallocated_Sector_Ct   0x0033   252   252   010 Pre-fail =20
> Always       -       0
>   7 Seek_Error_Rate         0x002e   252   252   051 Old_age  =20
> Always       -       0
>   8 Seek_Time_Performance   0x0024   252   252   015 Old_age  =20
> Offline      -       0
>   9 Power_On_Hours          0x0032   100   100   000 Old_age  =20
> Always       -       6208
>  10 Spin_Retry_Count        0x0032   252   252   051 Old_age  =20
> Always       -       0
>  12 Power_Cycle_Count       0x0032   100   100   000 Old_age  =20
> Always       -       678
> 191 G-Sense_Error_Rate      0x0022   100   100   000 Old_age  =20
> Always       -       11
> 192 Power-Off_Retract_Count 0x0022   252   252   000 Old_age  =20
> Always       -       0
> 194 Temperature_Celsius     0x0002   053   044   000 Old_age  =20
> Always       -       47 (Min/Max 17/56)
> 195 Hardware_ECC_Recovered  0x003a   100   100   000 Old_age  =20
> Always       -       0
> 196 Reallocated_Event_Count 0x0032   252   252   000 Old_age  =20
> Always       -       0
> 197 Current_Pending_Sector  0x0032   252   252   000 Old_age  =20
> Always       -       0
> 198 Offline_Uncorrectable   0x0030   252   252   000 Old_age  =20
> Offline      -       0
> 199 UDMA_CRC_Error_Count    0x0036   200   200   000 Old_age  =20
> Always       -       0
> 200 Multi_Zone_Error_Rate   0x002a   100   100   000 Old_age  =20
> Always       -       20
> 223 Load_Retry_Count        0x0032   100   100   000 Old_age  =20
> Always       -       7
> 225 Load_Cycle_Count        0x0032   100   100   000 Old_age  =20
> Always       -       7035
>
> SMART Error Log Version: 1
> No Errors Logged
>
> SMART Self-test log structure revision number 1
> No self-tests have been logged.  [To run self-tests, use: smartctl -t]
>
> SMART Selective self-test log data structure revision number 0
> Note: revision number not 1 implies that no selective self-test has=20
> ever been run
>  SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
>     1        0        0  Completed [00% left] (0-65535)
>     2        0        0  Not_testing
>     3        0        0  Not_testing
>     4        0        0  Not_testing
>     5        0        0  Not_testing
> Selective self-test flags (0x0):
>   After scanning selected spans, do NOT read-scan remainder of disk.
> If Selective self-test is pending on power-up, resume after 0 minute=20
> delay.
gnome-disks says it worked 15 days and 8 minutes

> I also almost never look at the backups, and when I do, indeed scanning=

> through a 1000 snapshots fs on spinning disk takes time. If a script
> does that every 15mins, and the fs uses LZO compression and there is
> another active partition then you will have to deal with the slowness.
Well, it is not that bad and hard in reality. Every 15 minutes I'm=20
transfering 3 diffs. Right now HDD contains 453 subvolumes totally, 34%=20
of 359 GiB partition space used. After writing last message I've decided =

to collect diffs for further analysis.

So /home subvolume's diffs ranging from 6 to 270 MiB. Typically 30-40 MiB=
=2E

/root subvolume's diffs ranging from 10 KiB to 380 MiB (during software=20
updates). Typically 40-80 KiB.

/web (source code here) subvolume's diffs ranging from bytes to 1 MiB,=20
typically 150 KiB.

So generally when I'm watching movie or playing some game (not changing=20
source code, not updating software and not doing anything that might=20
cause significant changes in /home subvolume) I'll get about 30 MiB of=20
diff in total. This is not that much for SATA3 HDD, it shouldn't stuck=20
for some seconds when everything is so slow that video stops completely=20
for few seconds.

Maybe BTRFS construction requires this small diff to make a big party=20
all over HDD, I don't know, but there is some problem here for sure.

> You could adapt the script or backup method not to search every time,
> but to just write the next diff send|receive and only step back and
> search if this fails.
>
> Or keeping more 15min snapshots only on SSD and lower the rate of
> send|receive them to HDD
I'm not sure what you mean exactly by searching. My first SSD died=20
during waking up from suspend mode, it worked perfectly till last=20
moment. It was not used for critical data at that time, but now I=20
understand clearly that SSD failure can happen at any time. Having RAID0 =

of 2 SSDs it 2 times more risky, so I'm not ready to lose anything=20
beyond 15 minutes threshold. I'd rather end up having another HDD purely =

for backup purposes.


Interesting question: is there any tool to see the whole picture about=20
how btrfs partition is fragmented? I saw many tools for NTFS on Windows=20
that show nice picture, but not for Linux filesystems. Saw answer on=20
StackOverlow about fsck, but btrfsck doesn't provide similar output.

Also, I can't really run defragmentation anyway since all backups are=20
read-only.

Sincerely, Nazar Mokrynskyi
github.com/nazar-pc
Skype: nazar-pc
Diaspora: nazarpc@diaspora.mokrynskyi.com
Tox: A9D95C9AA5F7A3ED75D83D0292E22ACE84BA40E912185939414475AF28FD2B2A5C8E=
F5261249

On 16.03.16 01:11, Henk Slager wrote:
> On Tue, Mar 15, 2016 at 1:47 AM, Nazar Mokrynskyi <nazar@mokrynskyi.com=
> wrote:
>> Some update since last time (few weeks ago).
>>
>> All filesystems are mounted with noatime, I've also added mounting
>> optimization - so there is no problem with remounting filesystem every=
 time,
>> it is done only once.
>>
>> Remounting optimization helped by reducing 1 complete snapshot +
>> send/receive cycle by some seconds, but otherwise it is still very slo=
w when
>> `btrfs receive` is active.
> OK, great that the umount+mount is gone. I think most time is
> unfortunately spent in seeks; I think over time and due to various
> factors, both free space and files are highly fragmented on your disk.
> It could also be that the disk is bit older and has or is starting to
> use its spare sectors.
>
>> I'm not considering bcache + btrfs as potential setup because I do not=

>> currently have free SSD for it and basically spending SSD besides HDD =
for
>> backup partition feels like a bit of overkill (especially for desktop =
use).
> Yes I think so too; For backup, I am also a bit reluctant to use
> bcache. But the big difference is that you do a snapshot transfer
> every 15minute while I do that only every 24hour. So I almost dont
> care how long the send|receive takes in the middle of the night. I
> also almost never look at the backups, and when I do, indeed scanning
> through a 1000 snapshots fs on spinning disk takes time. If a script
> does that every 15mins, and the fs uses LZO compression and there is
> another active partition then you will have to deal with the slowness.
> And if the files are mostly small, like source-trees, it gets even
> worse. So it is about 100x more creates+deletes of subvolumes. To be
> honest, it is just requiring too much from a HDD I think, knowing that
> btrfs is CoW. On a fresh fs it might work OK in the beginning, but
> over time...
>
> You could adapt the script or backup method not to search every time,
> but to just write the next diff send|receive and only step back and
> search if this fails.
>
> Or keeping more 15min snapshots only on SSD and lower the rate of
> send|receive them to HDD
>
> Another thing you could do is skip the receive step; So just pipe the
> 15min snapshot diff to a stream file and just leave it on the backup
> HDD until you need files from the backup. Only then do a series of
> incremental receives of the streams. An every now and then a full
> (non-incremental) send.
>
>> My current kernel is 4.5.0 stable, btrfs-tools still 4.4-1 from Ubuntu=
 16.04
>> repository as of today.
>>
>> As I'm reading mailing list there are other folks having similar perfo=
rmance
>> issues. So can we debug things to find the root cause and fix it at so=
me
>> point?
> Indeed there are multiple reports with similar symptoms. I think it is
> not really that one should see it as an error or root cause or some
> fault. It is further optimization and then specifically for harddisks.
> Or implementing additional concepts just for harddisks. For (parity)
> RAID (by btrfs itself, not DM or MD etc), one can exploit parallelism,
> but it is not trivial to get that fully optimized for all device
> configurations and tasks.
>
>> My C/C++/Kernel/BTRFS knowledges are scarce, which is why some assista=
nce
>> here is needed from someone more experienced.
> It is all about HDD seek times in the first place. There are many
> thoughts, articles and benchmarks about this over the years on the
> internet, but I just found this one from last year about XFS:
> https://lkml.org/lkml/2015/4/29/776
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--------------ms020506020501020705020803
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
CQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xNjAzMTYwMzM3MDJaMC8GCSqGSIb3
DQEJBDEiBCCWut30uWxCsME4mjrVv26TULeAc3NCcoFNcduMt1QUnjBsBgkqhkiG9w0BCQ8x
XzBdMAsGCWCGSAFlAwQBKjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwIC
AgCAMA0GCCqGSIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGaBgkrBgEEAYI3
EAQxgYwwgYkwdTELMAkGA1UEBhMCSUwxFjAUBgNVBAoTDVN0YXJ0Q29tIEx0ZC4xKTAnBgNV
BAsTIFN0YXJ0Q29tIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MSMwIQYDVQQDExpTdGFydENv
bSBDbGFzcyAxIENsaWVudCBDQQIQZOr+k1bYeoai8pecbBX/jTCBnAYLKoZIhvcNAQkQAgsx
gYyggYkwdTELMAkGA1UEBhMCSUwxFjAUBgNVBAoTDVN0YXJ0Q29tIEx0ZC4xKTAnBgNVBAsT
IFN0YXJ0Q29tIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MSMwIQYDVQQDExpTdGFydENvbSBD
bGFzcyAxIENsaWVudCBDQQIQZOr+k1bYeoai8pecbBX/jTANBgkqhkiG9w0BAQEFAASCAQBw
7RjCEvRAKuBhY6VN6oKScWaSnSTn9N2FzP2Bq35iFKiVtkQcV60oQ2FBZwW02dxK4/uXosxs
bTpEmnQcNsdZdgjHPVuXH5YMi+W5XZqGe1VBzdl0EScFTV3lsa5hDNKQLLJm9w0/ZAoJTglM
32M8MW6VFl7aOTh+Si2bv+KpeB0UmrGfFllaS0JqzfhnahMBD6+uaHIdZbvfAwYP3N97bXhs
C/ZhwWwBpnM9JG839vQp7F00yQg1yskxpVspvPGda5NmKy2gjaulEnO0NpUH1g9JZNat1wXR
Ucge9PsmJHvf5jDLopm6PQpECEOKwJPpSLOEHq/F42bgNcO759KUAAAAAAAA
--------------ms020506020501020705020803--
