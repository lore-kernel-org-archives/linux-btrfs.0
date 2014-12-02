Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f169.google.com ([209.85.223.169]:57234 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbaLBMXL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Dec 2014 07:23:11 -0500
Received: by mail-ie0-f169.google.com with SMTP id y20so11617818ier.28
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Dec 2014 04:23:10 -0800 (PST)
Message-ID: <547DAF2A.7020902@gmail.com>
Date: Tue, 02 Dec 2014 07:23:06 -0500
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Anand Jain <Anand.Jain@oracle.com>, kreijack@inwind.it,
        MegaBrutal <megabrutal@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
CC: Robert White <rwhite@pobox.com>, Chris Mason <clm@fb.com>
Subject: Re: PROBLEM: #89121 BTRFS mixes up mounted devices with their snapshots
References: <CAE8gLhm8Oma6kWdeJtdc1-U2e4+TJDzhmw2Vfr=CYwvJ78GRJQ@mail.gmail.com>	<547CA4E7.8060209@pobox.com>	<CAE8gLhmbws6E7YQVBLHfaUXF6Jz1qob9iOFiAEW7pRTq65YCyw@mail.gmail.com>	<547CF8B1.4000303@pobox.com>	<CAE8gLhkxgi8nTab0rzmLNzhsek_v2zs6RxPDL9GU_EAen9+kvA@mail.gmail.com>	<547D6F42.9000009@inwind.it> <CAE8gLhmVqPTArDKxBenbRasUwifGOEoy+askejqneEA9WH-iOQ@mail.gmail.com> <547D9F18.3030400@inwind.it> <547DA86C.4050100@oracle.com>
In-Reply-To: <547DA86C.4050100@oracle.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms090907040805020607020005"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms090907040805020607020005
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2014-12-02 06:54, Anand Jain wrote:
>
>
>
> On 02/12/2014 19:14, Goffredo Baroncelli wrote:
>> I further investigate this issue.
>>
>> MegaBrutal, reported the following issue: doing a lvm snapshot of the
>> device of a
>> mounted btrfs fs, the new snapshot device name replaces the name of
>> the original
>> device in the output of /proc/mounts. This confused tools like
>> grub-probe which
>> report a wrong root device.
>
> very good test case indeed thanks.
>
> Actual IO would still go to the original device, until FS is remounted.=

>
>
>> It has to be pointed out that instead the link under
>> /sys/fs/btrfs/<fsid>/devices is
>> correct.
>
> In this context the above sysfs path will be out of sync with the
> reality, its just stale sysfs entry.
>
>>
>> What happens is that *even if the filesystem is mounted*, doing a
>> "btrfs dev scan" of a snapshot (of the real volume), the device name
>> of the
>> filesystem is replaced with the snapshot one.
>
> we have some fundamentally wrong stuff. My original patch tried
> to fix it. But later discovered that some external entities like
> systmed and boot process is using that bug as a feature and we had
> to revert the patch.
>
> Fundamentally scsi inquiry serial number is only number which is unique=

> to the device (including the virtual device, but there could be some
> legacy virtual device which didn't follow that strictly, Anyway those
> I deem to be device side issue.) Btrfs depends on the combination of
> fsid, uuid and devid (and generation number) to identify the unique
> device volume, which is weak and easy to go wrong.
>
>
>> Anand, with b96de000b, tried to fix it; however further regression
>> appeared
>> and Chris reverted this commit (see below).
>>
>> BR
>> G.Baroncelli
>>
>> commit b96de000bc8bc9688b3a2abea4332bd57648a49f
>> Author: Anand Jain <anand.jain@oracle.com>
>> Date:   Thu Jul 3 18:22:05 2014 +0800
>>
>>      Btrfs: device_list_add() should not update list when mounted
>> [...]
>>
>>
>> commit 0f23ae74f589304bf33233f85737f4fd368549eb
>> Author: Chris Mason <clm@fb.com>
>> Date:   Thu Sep 18 07:49:05 2014 -0700
>>
>>      Revert "Btrfs: device_list_add() should not update list when
>> mounted"
>>
>>      This reverts commit b96de000bc8bc9688b3a2abea4332bd57648a49f.
>>
>>      This commit is triggering failures to mount by subvolume id in so=
me
>>      configurations.  The main problem is how many different ways this=

>>      scanning function is used, both for scanning while mounted and
>>      unmounted.  A proper cleanup is too big for late rcs.
>>
>> [...]
>>
>> On 12/02/2014 09:28 AM, MegaBrutal wrote:
>>> 2014-12-02 8:50 GMT+01:00 Goffredo Baroncelli <kreijack@inwind.it>:
>>>> On 12/02/2014 01:15 AM, MegaBrutal wrote:
>>>>> 2014-12-02 0:24 GMT+01:00 Robert White <rwhite@pobox.com>:
>>>>>> On 12/01/2014 02:10 PM, MegaBrutal wrote:
>>>>>>>
>>>>>>> Since having duplicate UUIDs on devices is not a problem for me
>>>>>>> since
>>>>>>> I can tell them apart by LVM names, the discussion is of little
>>>>>>> relevance to my use case. Of course it's interesting and I like t=
o
>>>>>>> read it along, it is not about the actual problem at hand.
>>>>>>>
>>>>>>
>>>>>> Which is why you use the device=3D mount option, which would take
>>>>>> LVM names
>>>>>> and which was repeatedly discussed as solving this very problem.
>>>>>>
>>>>>> Once you decide to duplicate the UUIDs with LVM snapshots you take=

>>>>>> up the
>>>>>> burden of disambiguating your storage.
>>>>>>
>>>>>> Which is part of why re-reading was suggested as this was covered
>>>>>> in some
>>>>>> depth and _is_ _exactly_ about the problem at hand.
>>>>>
>>>>> Nope.
>>>>>
>>>>> root@reproduce-1391429:~# cat /proc/cmdline
>>>>> BOOT_IMAGE=3D/vmlinuz-3.18.0-031800rc5-generic
>>>>> root=3D/dev/mapper/vg-rootlv ro
>>>>> rootflags=3Ddevice=3D/dev/mapper/vg-rootlv,subvol=3D@
>>>>>
>>>>> Observe, device=3D mount option is added.
>>>>
>>>> device=3D options is needed only in a btrfs multi-volume scenario.
>>>> If you have only one disk, this is not needed
>>>>
>>>
>>> I know. I only did this as a demonstration for Robert. He insisted it=

>>> will certainly solve the problem. Well, it doesn't.
>>>
>>>
>>>>>
>>>>> root@reproduce-1391429:~# ./reproduce-1391429.sh
>>>>> #!/bin/sh -v
>>>>> lvs
>>>>>    LV     VG   Attr      LSize   Pool Origin Data%  Move Log Copy%
>>>>> Convert
>>>>>    rootlv vg   -wi-ao---   1.00g
>>>>>    swap0  vg   -wi-ao--- 256.00m
>>>>>
>>>>> grub-probe --target=3Ddevice /
>>>>> /dev/mapper/vg-rootlv
>>>>>
>>>>> grep " / " /proc/mounts
>>>>> rootfs / rootfs rw 0 0
>>>>> /dev/dm-1 / btrfs rw,relatime,space_cache 0 0
>>>>>
>>>>> lvcreate --snapshot --size=3D128M --name z vg/rootlv
>>>>>    Logical volume "z" created
>>>>>
>>>>> lvs
>>>>>    LV     VG   Attr      LSize   Pool Origin Data%  Move Log Copy%
>>>>> Convert
>>>>>    rootlv vg   owi-aos--   1.00g
>>>>>    swap0  vg   -wi-ao--- 256.00m
>>>>>    z      vg   swi-a-s-- 128.00m      rootlv   0.11
>>>>>
>>>>> ls -l /dev/vg/
>>>>> total 0
>>>>> lrwxrwxrwx 1 root root 7 Dec  2 00:12 rootlv -> ../dm-1
>>>>> lrwxrwxrwx 1 root root 7 Dec  2 00:12 swap0 -> ../dm-0
>>>>> lrwxrwxrwx 1 root root 7 Dec  2 00:12 z -> ../dm-2
>>>>>
>>>>> grub-probe --target=3Ddevice /
>>>>> /dev/mapper/vg-z
>>>>>
>>>>> grep " / " /proc/mounts
>>>>> rootfs / rootfs rw 0 0
>>>>> /dev/dm-2 / btrfs rw,relatime,space_cache 0 0
>>>>
>>>> What /proc/self/mountinfo contains ?
>>>
>>> Before creating snapshot:
>>>
>>> 15 20 0:15 / /sys rw,nosuid,nodev,noexec,relatime - sysfs sysfs rw
>>> 16 20 0:3 / /proc rw,nosuid,nodev,noexec,relatime - proc proc rw
>>> 17 20 0:5 / /dev rw,relatime - devtmpfs udev
>>> rw,size=3D241692k,nr_inodes=3D60423,mode=3D755
>>> 18 17 0:12 / /dev/pts rw,nosuid,noexec,relatime - devpts devpts
>>> rw,gid=3D5,mode=3D620,ptmxmode=3D000
>>> 19 20 0:16 / /run rw,nosuid,noexec,relatime - tmpfs tmpfs
>>> rw,size=3D50084k,mode=3D755
>>> 20 0 0:17 /@ / rw,relatime - btrfs /dev/dm-1 rw,space_cache
>>> <----- THIS!
>>> 21 15 0:20 / /sys/fs/cgroup rw,relatime - tmpfs none rw,size=3D4k,mod=
e=3D755
>>> 22 15 0:21 / /sys/fs/fuse/connections rw,relatime - fusectl none rw
>>> 23 15 0:6 / /sys/kernel/debug rw,relatime - debugfs none rw
>>> 24 15 0:10 / /sys/kernel/security rw,relatime - securityfs none rw
>>> 25 19 0:22 / /run/lock rw,nosuid,nodev,noexec,relatime - tmpfs none
>>> rw,size=3D5120k
>>> 26 19 0:23 / /run/shm rw,nosuid,nodev,relatime - tmpfs none rw
>>> 27 19 0:24 / /run/user rw,nosuid,nodev,noexec,relatime - tmpfs none
>>> rw,size=3D102400k,mode=3D755
>>> 28 15 0:25 / /sys/fs/pstore rw,relatime - pstore none rw
>>> 29 20 253:1 / /boot rw,relatime - ext2 /dev/vda1 rw
>>>
>>>
>>> After creating snapshot:
>>>
>>> 15 20 0:15 / /sys rw,nosuid,nodev,noexec,relatime - sysfs sysfs rw
>>> 16 20 0:3 / /proc rw,nosuid,nodev,noexec,relatime - proc proc rw
>>> 17 20 0:5 / /dev rw,relatime - devtmpfs udev
>>> rw,size=3D241692k,nr_inodes=3D60423,mode=3D755
>>> 18 17 0:12 / /dev/pts rw,nosuid,noexec,relatime - devpts devpts
>>> rw,gid=3D5,mode=3D620,ptmxmode=3D000
>>> 19 20 0:16 / /run rw,nosuid,noexec,relatime - tmpfs tmpfs
>>> rw,size=3D50084k,mode=3D755
>>> 20 0 0:17 /@ / rw,relatime - btrfs /dev/dm-2 rw,space_cache
>>> <----- WTF?!
>>> 21 15 0:20 / /sys/fs/cgroup rw,relatime - tmpfs none rw,size=3D4k,mod=
e=3D755
>>> 22 15 0:21 / /sys/fs/fuse/connections rw,relatime - fusectl none rw
>>> 23 15 0:6 / /sys/kernel/debug rw,relatime - debugfs none rw
>>> 24 15 0:10 / /sys/kernel/security rw,relatime - securityfs none rw
>>> 25 19 0:22 / /run/lock rw,nosuid,nodev,noexec,relatime - tmpfs none
>>> rw,size=3D5120k
>>> 26 19 0:23 / /run/shm rw,nosuid,nodev,relatime - tmpfs none rw
>>> 27 19 0:24 / /run/user rw,nosuid,nodev,noexec,relatime - tmpfs none
>>> rw,size=3D102400k,mode=3D755
>>> 28 15 0:25 / /sys/fs/pstore rw,relatime - pstore none rw
>>> 29 20 253:1 / /boot rw,relatime - ext2 /dev/vda1 rw
>>>
>>>
>>> So it's consistent with what /proc/mounts reports.
>>>
>>>
>>>>
>>>> And more important question: it is only the value
>>>> returned by /proc/mount wrongly or also the filesystem
>>>> content is affected ?
>>>>
>>>
>>> I quote my bug report on this:
>>>
>>> "The information reported in /proc/mounts is certainly bogus, since
>>> still the origin device is being written, the kernel does not actuall=
y
>>> mix up the devices for write operations, and such, the phenomenon doe=
s
>>> not cause data corruption. (I did an entire distro release upgrade
>>> while the conditions were present, and I centainly would have suffere=
d
>>> severe data corruption otherwise. Fortunately, the origin device had
>>> the new distro, and the snapshot device had the old one, so besides
>>> the mixup in /proc/mounts, no actual damage happened.)"
Stupid thought, why don't we just add blacklisting based on device path=20
like LVM has for pvscan?



--------------ms090907040805020607020005
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIFuDCC
BbQwggOcoAMCAQICAw9gVDANBgkqhkiG9w0BAQ0FADB5MRAwDgYDVQQKEwdSb290IENBMR4w
HAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmlu
ZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZzAeFw0xNDA4
MDgxMTMwNDRaFw0xNTAyMDQxMTMwNDRaMGMxGDAWBgNVBAMTD0NBY2VydCBXb1QgVXNlcjEj
MCEGCSqGSIb3DQEJARYUYWhmZXJyb2luN0BnbWFpbC5jb20xIjAgBgkqhkiG9w0BCQEWE2Fo
ZW1tZWxnQG9oaW9ndC5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDdmm8R
BM5D6fGiB6rpogPZbLYu6CkU6834rcJepfmxKnLarYUYM593/VGygfaaHAyuc8qLaRA3u1M0
Qp29flqmhv1VDTBZ+zFu6JgHjTDniBii1KOZRo0qV3jC5NvaS8KUM67+eQBjm29LhBWVi3+e
a8jLxmogFXV0NGej+GHIr5zA9qKz2WJOEoGh0EfqZ2MQTmozcGI43/oqIYhRj8fRMkWXLUAF
WsLzPQMpK19hD8fqwlxQWhBV8gsGRG54K5pyaQsjne7m89SF5M8JkNJPH39tHEvfv2Vhf7EM
Y4WGyhLAULSlym1AI1uUHR1FfJaj3AChaEJZli/AdajYsqc7AgMBAAGjggFZMIIBVTAMBgNV
HRMBAf8EAjAAMFYGCWCGSAGG+EIBDQRJFkdUbyBnZXQgeW91ciBvd24gY2VydGlmaWNhdGUg
Zm9yIEZSRUUgaGVhZCBvdmVyIHRvIGh0dHA6Ly93d3cuQ0FjZXJ0Lm9yZzAOBgNVHQ8BAf8E
BAMCA6gwQAYDVR0lBDkwNwYIKwYBBQUHAwQGCCsGAQUFBwMCBgorBgEEAYI3CgMEBgorBgEE
AYI3CgMDBglghkgBhvhCBAEwMgYIKwYBBQUHAQEEJjAkMCIGCCsGAQUFBzABhhZodHRwOi8v
b2NzcC5jYWNlcnQub3JnMDEGA1UdHwQqMCgwJqAkoCKGIGh0dHA6Ly9jcmwuY2FjZXJ0Lm9y
Zy9yZXZva2UuY3JsMDQGA1UdEQQtMCuBFGFoZmVycm9pbjdAZ21haWwuY29tgRNhaGVtbWVs
Z0BvaGlvZ3QuY29tMA0GCSqGSIb3DQEBDQUAA4ICAQCr4klxcZU/PDRBpUtlb+d6JXl2dfto
OUP/6g19dpx6Ekt2pV1eujpIj5whh5KlCSPUgtHZI7BcksLSczQbxNDvRu6LNKqGJGvcp99k
cWL1Z6BsgtvxWKkOmy1vB+2aPfDiQQiMCCLAqXwHiNDZhSkwmGsJ7KHMWgF/dRVDnsl6aOQZ
jAcBMpUZxzA/bv4nY2PylVdqJWp9N7x86TF9sda1zRZiyUwy83eFTDNzefYPtc4MLppcaD4g
Wt8U6T2ffQfCWVzDirhg4WmDH3MybDItjkSB2/+pgGOS4lgtEBMHzAGQqQ+5PojTHRyqu9Jc
O59oIGrTaOtKV9nDeDtzNaQZgygJItJi9GoAl68AmIHxpS1rZUNV6X8ydFrEweFdRTVWhUEL
70Cnx84YBojXv01LYBSZaq18K8cERPLaIrUD2go+2ffjdE9ejvYDhNBllY+ufvRizIjQA1uC
OdktVAN6auQob94kOOsWpoMSrzHHvOvVW/kbokmKzaLtcs9+nJoL+vPi2AyzbaoQASVZYOGW
pE3daA0F5FJfcPZKCwd5wdnmT3dU1IRUxa5vMmgjP20lkfP8tCPtvZv2mmI2Nw5SaXNY4gVu
WQrvkV2in+TnGqgEIwUrLVbx9G6PSYZZs07czhO+Q1iVuKdAwjL/AYK0Us9v50acIzbl5CWw
ZGj3wjGCA6EwggOdAgEBMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6
Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEh
MB8GCSqGSIb3DQEJARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwCQYFKw4DAhoFAKCCAfUw
GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTQxMjAyMTIyMzA2
WjAjBgkqhkiG9w0BCQQxFgQUfvrT5mPMkwUa47yHgtIi4RvNezMwbAYJKoZIhvcNAQkPMV8w
XTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIA
gDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBkQYJKwYBBAGCNxAE
MYGDMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0
Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJ
ARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwgZMGCyqGSIb3DQEJEAILMYGDoIGAMHkxEDAO
BgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UE
AxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJARYSc3VwcG9ydEBj
YWNlcnQub3JnAgMPYFQwDQYJKoZIhvcNAQEBBQAEggEAzjKgpISjE/ppngsCeQvlrhywrgN2
F1iQXzhIGdklYUFlXWVW+hVQwCouXpb9zVZV7D/82UtQ+hfu5a34igyOgLozUmJVIM/sskXl
qBD8PtSstT4OP/j2phqnBMGjpzZkCbrbyq1i/Q/MaqE8J3wRxcJlTKmROtlkzxx+8b+0MO9R
+5MWftIhlDHqwPC0IfIhxNi+TR8f9l1An+3eQv+ELZ57yd/VkFiWbVSPluHuMgcF0HtDGaJD
PfbSCD3NZyka/8C5mqmUwTb9s1Xi76aN4WcnZlMrfB/F00yigzTyR/7qoCoeRcidAjfT9fTj
hY3oq4B7pDRrGNvsPAPXwoTsLwAAAAAAAA==
--------------ms090907040805020607020005--
