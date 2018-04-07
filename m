Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f180.google.com ([209.85.128.180]:36587 "EHLO
        mail-wr0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752156AbeDGXab (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 7 Apr 2018 19:30:31 -0400
Received: by mail-wr0-f180.google.com with SMTP id y55so4714795wry.3
        for <linux-btrfs@vger.kernel.org>; Sat, 07 Apr 2018 16:30:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <40ef1367-45f3-6c61-af68-0a6c13af6aac@gmx.com>
References: <CAAGPGf9+y_BXj=jQ1aY3xSPzMTjOTWPPO2avBODSYem5pyRXGQ@mail.gmail.com>
 <20180406170329.GH8557@twin.jikos.cz> <1401c2e5-d0e9-ac9e-178f-776cb9847ffb@gmx.com>
 <CAAGPGf8m-8qQ-tsW6ZxtEktm1DbP4FfrU6FZr+tX3vb_Cq+9_g@mail.gmail.com>
 <17a45d05-1dc9-4b1b-5786-c4bf8ae8a5eb@gmx.com> <CAAGPGf8JXhrCDmGPGi90bJhD_HY=mYEZJUdJ1mvx5+MRLsb_Og@mail.gmail.com>
 <40ef1367-45f3-6c61-af68-0a6c13af6aac@gmx.com>
From: Ben Parsons <9parsonsb@gmail.com>
Date: Sun, 8 Apr 2018 09:29:48 +1000
Message-ID: <CAAGPGf8R1Q05BnxDyOWZ00Li+ocm+S46iNdxz2K2075Y35AJvg@mail.gmail.com>
Subject: Re: Bad magic on superblock on /dev/sda at 65536
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Content-Type: multipart/mixed; boundary="f403045ea0a0e8929f05694a8e04"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--f403045ea0a0e8929f05694a8e04
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On 7 April 2018 at 22:09, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
> On 2018=E5=B9=B404=E6=9C=8807=E6=97=A5 10:31, Ben Parsons wrote:
> [snip]
>>> Pretty common hard power reset.
>>>
>>>> looking at journalctl, there is a large stacktrace from kernel: amdgpu
>>>> (see attached).
>>>> then when I booted back up the pool (2 disks, 1TB + 2TB) wouldn't moun=
t.
>>>
>>> I'd say such corruption is pretty serious.
>>>
>>> And what's the profile of the btrfs? If metadata is raid1, we could at
>>> least try to recovery the superblock from the remaining disk.
>>
>> I am not sure what the metadata was but the two disks had no parity
>> and just appeared as a single disk with total space of the two disks
>
> Strangely, for the 2nd disk, it's sdc1, which means it has partition tabl=
e.
> While for the 1st disk, it's sda, without partition table at all.
> Is there any possibility that you just took run partition?
> (Or did some program uses it incorrectly?)
>

I dont quite understand what you are asking.
I was always under the impression I could run mount on either
partition and it would mount the pool

>>
>> how would i got about recovering the 2nd disk? attached is
>
> The 2nd disk looks good, however it's csum_type is wrong.
> 41700 looks like garbage.
>
> Despite that, incompact_flags also has garbage.
>
> The good news is, the system (and metadata) profile is RAID1, so it's
> highly possible for us to salvage (to be more accurate, rebuild) the
> superblock for the 1st device.
>
> Please dump the superblock of the 2nd device (sdc1) by the following
> command:
>
> # dd if=3D/dev/sdc1 of=3Dsuper_dump.sdc1 bs=3D1 count=3D4096 skip=3D64k
>

See attached.

>
> Unfortunately, btrfs-sb-mod tool added recently doesn't have all needed
> fields, so I'm afraid I need to manually modify it.
>
> And just in case, please paste the following output to help us verify if
> it's really sda without offset:
>
> # lsblk /dev/sda
> # grep -obUaP "\x5F\x42\x48\x52\x66\x53\x5F\x4D"
>

dd if=3D/dev/sdb of=3DtoGrep.sdb bs=3D1 count=3D128M status=3Dprogress
cat toGrep.sdb | grep -obUaP "\x5F\x42\x48\x52\x66\x53\x5F\x4D"

65600:_BHRfS_M
67108928:_BHRfS_M

>
> Above grep could be very slow since it will try to iterate the whole
> disk. It's recommended to dump the first 128M of the disk and then grep
> on that 128M image.
>
>
> BTW, with superblock of sdc1 patched, you should be able to mount the fs
> with -o ro,degraded, and salvage some data.
>
> Thanks,
> Qu

Thank you so much!

I am better off copying the data to another disk and then rebuilding the po=
ol?
or can I just run a scrub after the super block is fixed?

For reference here is lsblk:

sda      8:0    0 465.8G  0 disk
=E2=94=9C=E2=94=80sda1   8:1    0   512M  0 part /boot
=E2=94=9C=E2=94=80sda2   8:2    0 455.3G  0 part /
=E2=94=94=E2=94=80sda3   8:3    0    10G  0 part [SWAP]

sdb      8:16   0 931.5G  0 disk
-- first disk

sdc      8:32   0   1.8T  0 disk
=E2=94=94=E2=94=80sdc1   8:33   0   1.8T  0 part
-- 2nd disk

>>
>> btrfs inspect dump-super -Ffa
>>
>> for the second disk
>>
>>> And is there special mount options used here like discard?
>>
>> compress=3Dlzo, noauto
>>
>>> Thanks,
>>> Qu
>>>
>>
>> Thank you for all your help so far.
>> Does this mean that the first disk is definatly gone? is there any way
>> to recover?
>>
>>
>> Thank,
>> Ben
>>
>>>>
>>>> Thanks,
>>>> Ben
>>>>
>>>> On 7 April 2018 at 09:44, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>>>>
>>>>>
>>>>> On 2018=E5=B9=B404=E6=9C=8807=E6=97=A5 01:03, David Sterba wrote:
>>>>>> On Fri, Apr 06, 2018 at 11:32:34PM +1000, Ben Parsons wrote:
>>>>>>> Hi,
>>>>>>>
>>>>>>> I just had an unexpected restart and now my btrfs pool wont mount.
>>>>>>> The error on mount is:
>>>>>>>
>>>>>>>     "ERROR: unsupported checksum algorithm 41700"
>>>>>>>
>>>>>>> and when running
>>>>>>>
>>>>>>>     btrfs inspect-internal dump-super /dev/sda
>>>>>>>     ERROR: bad magic on superblock on /dev/sda at 65536
>>>>>>>
>>>>>>> I saw a thread in the mailing list about it:
>>>>>>> https://www.spinics.net/lists/linux-btrfs/msg75326.html
>>>>>>> However I am told on IRC that Qu fixed it using magic.
>>>>>>>
>>>>>>> Any help would be much appreciated.
>>>>>>
>>>>>> In the previous report, there were 2 isolated areas of superblock
>>>>>> damaged. Please post output of
>>>>>>
>>>>>>       btrfs inspect dump-super /path
>>>>>
>>>>> And don't forget -Ffa option.
>>>>> -F to force btrfs-progs to recognize it as btrfs no matter what the m=
agic is
>>>>> -f shows all data so we could find all corruption and fix them if pos=
sible
>>>>> -a shows all backup superblocks, and if some backup is good, "btrfs
>>>>> rescue super-recovery" mentioned by Nikolay would be the best solutio=
n.
>>>>>
>>>>> Despite that, any extra info on how this happened is also appreciated=
,
>>>>> as similar problem happened twice, which means we need to pay attenti=
on
>>>>> on this.
>>>>>
>>>>> Thanks,
>>>>> Qu
>>>>>
>>>>> Thanks,
>>>>> Qu
>>>>>
>>>>>>
>>>>>> so we can see if it's a similar issue.
>>>>>>
>>>>>> In case it is, there's a tool in the btrfs-progs repo that can fix t=
he
>>>>>> individual values.
>>>>>> --
>>>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrf=
s" in
>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>>

--f403045ea0a0e8929f05694a8e04
Content-Type: application/octet-stream; name="super_dump.sdc1"
Content-Disposition: attachment; filename="super_dump.sdc1"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_jfq09kdo0

OyUtOgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAI5Rx2AGhFurrInB9XNj7GAAABAAAAAAAB
AAAAAAAAAF9CSFJmU19N55wTAAAAAAAAwJT75QUAAABAq+IEBQAAAAAAAAAAAAAAAAAAAAAAAABg
26G1AgAAAHCr9agCAAAGAAAAAAAAAAIAAAAAAAAAABAAAABAAAAAQAAAABAAAIEAAABFbxMAAAAA
AAAAAAAAAAAAAAAAAAAAAABpAQAAAEAiW+SiAQEAAQAAAAAAAAAAAADBzAEAAAAA8MDMAQAAABAA
AAAQAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAmkSJzVruQemSXnyMNU3VPwjl
HHYAaEW6usicH1c2PsYAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA55wTAAAAAADnnBMAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAABAAAAAAAA5AAAq+IEBQAAAAAAAgAAAAACAAAAAAAAAAAAAQAAAAAAEgAA
AAAAAAAAAAEAAAABAAAQAAACAAEAAQAAAAAAAAAAAEBC7AAAAJpEic1a7kHpkl58jDVN1T8CAAAA
AAAAAAAAEIIBAAAApAmq4/r9SdW1idVO7cpijwABAAAAAAAA5AAAKyXjBQAAAAAAAgAAAAACAAAA
AAAAAAAAAQAAAAAAEgAAAAAAAAAAAAEAAAABAAAQAAACAAEAAgAAAAAAAAAAABCC4QAAAKQJquP6
/UnVtYnVTu3KYo8BAAAAAAAAAAAAQMLFAQAAmkSJzVruQemSXnyMNU3VPwAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAMCU++UFAADnnBMAAAAAAABAq+IEBQAARW8TAAAAAAAAAJT75QUAAOecEwAAAAAA
AACT++UFAADnnBMAAAAAAAAAf2wvBAAApowTAAAAAAAAAJb75QUAAOecEwAAAAAAAGDbobUCAAAA
cKv1qAIAAAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAQICAQMAAAAA
AAAAAAAAAEB2++UFAADknBMAAAAAAABAq+IEBQAARW8TAAAAAAAAAHX75QUAAOScEwAAAAAAAEBz
++UFAADknBMAAAAAAAAAf2wvBAAApowTAAAAAAAAAHT75QUAAOScEwAAAAAAAGDbobUCAAAAcKv1
qAIAAAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAQICAQMAAAAAAAAA
AAAAAIB9++UFAADlnBMAAAAAAABAq+IEBQAARW8TAAAAAAAAQHz75QUAAOWcEwAAAAAAAIB7++UF
AADlnBMAAAAAAAAAf2wvBAAApowTAAAAAAAAAH/75QUAAOWcEwAAAAAAAGDbobUCAAAAcKv1qAIA
AAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAQICAQMAAAAAAAAAAAAA
AECM++UFAADmnBMAAAAAAABAq+IEBQAARW8TAAAAAAAAgIr75QUAAOacEwAAAAAAAACE++UFAADm
nBMAAAAAAAAAf2wvBAAApowTAAAAAAAAQI775QUAAOacEwAAAAAAAGDbobUCAAAAcKv1qAIAAAIA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAQICAQMAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
--f403045ea0a0e8929f05694a8e04--
