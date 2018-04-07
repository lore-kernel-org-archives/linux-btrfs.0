Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f179.google.com ([209.85.128.179]:37461 "EHLO
        mail-wr0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751367AbeDGCcK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Apr 2018 22:32:10 -0400
Received: by mail-wr0-f179.google.com with SMTP id l49so3281217wrl.4
        for <linux-btrfs@vger.kernel.org>; Fri, 06 Apr 2018 19:32:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <17a45d05-1dc9-4b1b-5786-c4bf8ae8a5eb@gmx.com>
References: <CAAGPGf9+y_BXj=jQ1aY3xSPzMTjOTWPPO2avBODSYem5pyRXGQ@mail.gmail.com>
 <20180406170329.GH8557@twin.jikos.cz> <1401c2e5-d0e9-ac9e-178f-776cb9847ffb@gmx.com>
 <CAAGPGf8m-8qQ-tsW6ZxtEktm1DbP4FfrU6FZr+tX3vb_Cq+9_g@mail.gmail.com> <17a45d05-1dc9-4b1b-5786-c4bf8ae8a5eb@gmx.com>
From: Ben Parsons <9parsonsb@gmail.com>
Date: Sat, 7 Apr 2018 12:31:27 +1000
Message-ID: <CAAGPGf8JXhrCDmGPGi90bJhD_HY=mYEZJUdJ1mvx5+MRLsb_Og@mail.gmail.com>
Subject: Re: Bad magic on superblock on /dev/sda at 65536
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Content-Type: multipart/mixed; boundary="883d24f10970b378b3056938faf2"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--883d24f10970b378b3056938faf2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On 7 April 2018 at 10:56, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
> On 2018=E5=B9=B404=E6=9C=8807=E6=97=A5 08:35, Ben Parsons wrote:
>>> btrfs inspect-internal dump-super -Ffa /path
>>
>> superblock: bytenr=3D65536, device=3D/dev/sda
>> ---------------------------------------------------------
>> csum_type        0 (crc32c)
>> csum_size        4
>> csum            0x00000000 [DON'T MATCH]
>> bytenr            0
>> flags            0x0
>> magic            ........ [DON'T MATCH]
>> fsid            00000000-0000-0000-0000-000000000000
>
> First super block is completely gone.
>
>> label
>> generation        0
>> root            0
>> sys_array_size        0
>> chunk_root_generation    0
>> root_level        0
>> chunk_root        0
>> chunk_root_level    0
>> log_root        0
>> log_root_transid    0
>> log_root_level        0
>> total_bytes        0
>> bytes_used        0
>> sectorsize        0
>> nodesize        0
>> leafsize (deprecated)        0
>> stripesize        0
>> root_dir        0
>> num_devices        0
>> compat_flags        0x0
>> compat_ro_flags        0x0
>> incompat_flags        0x0
>> cache_generation    0
>> uuid_tree_generation    0
>> dev_item.uuid        00000000-0000-0000-0000-000000000000
>> dev_item.fsid        00000000-0000-0000-0000-000000000000 [match]
>> dev_item.type        0
>> dev_item.total_bytes    0
>> dev_item.bytes_used    0
>> dev_item.io_align    0
>> dev_item.io_width    0
>> dev_item.sector_size    0
>> dev_item.devid        0
>> dev_item.dev_group    0
>> dev_item.seek_speed    0
>> dev_item.bandwidth    0
>> dev_item.generation    0
>> sys_chunk_array[2048]:
>> backup_roots[4]:
>>
>> superblock: bytenr=3D67108864, device=3D/dev/sda
>> ---------------------------------------------------------
>> csum_type        65178 (INVALID)
>> csum_size        32
>> csum
>> 0x24f2057c939118ef8cf9c276a05ff294223c99ec79e0b5cfe8ed795fe0a96715
>> [DON'T MATCH]
>> bytenr            6481065229944367737
>
> Neither this backup superblock is valid.
>
>> flags            0x527ffc9117fc11
>>             ( WRITTEN |
>>               CHANGING_FSID |
>>               METADUMP_V2 |
>>               unknown flag: 0x527ff09117fc10 )
>> magic            ...;)... [DON'T MATCH]
>> fsid            7011f2d5-0afe-5dc6-fce2-70e04b80939d
>> label
>> ;.."`....8..8.x.?.N../....z....F..H.......|h].i.C........)........j....<=
?P..&.......4.(.}'.)....n...9....G..D..^....g.X....g)....L..G...z.|R.V.0...=
K.~..!..~..C................pO..........@U.>....).......4....d_..5.../.....=
..1.?.r....r5.E..
>> generation        7112314448606197494
> [snip]
>>
>>
>> superblock: bytenr=3D274877906944, device=3D/dev/sda
>> ---------------------------------------------------------
>> csum_type        63651 (INVALID)
>> csum_size        32
>> csum
>> 0x39db30683b693c000000004ff05c0073a1fa00db390c32963bae3c0000000037
>> [DON'T MATCH]
>> bytenr            6341162744368070656
>
> 2nd backup is also gone.
>
>> flags            0x9731d639d900f69a
>>             ( RELOC |
>>               CHANGING_FSID |
>>               SEEDING |
>>               unknown flag: 0x9731d630d900f698 )
>> magic            ;.<..... [DON'T MATCH]
>> fsid            e25b006e-a0f9-00df-390a-32923bae3c00
>> label            .9~2.;.<
>> generation        15852938566880484858
>> root            17063576824041017
>> sys_array_size        2956094009
>> chunk_root_generation    9223372036858758203
>> root_level        0
>> chunk_root        2305935309654720512
>> chunk_root_level    212
>> log_root        12624074888383091845
>> log_root_transid    9583660007048386619
>> log_root_level        57
>> total_bytes        14916195329329095163
>> bytes_used        17051482582002489
> [snip]
>
> unfortunately, the filesystem seems to be totally corrupted.
>
>>
>>> Despite that, any extra info on how this happened is also appreciated,
>>> as similar problem happened twice, which means we need to pay attention
>>> on this.
>>
>> I dont know exactly what happened but here is some background:
>>
>> i am running Arch Linux on mainline kernel (4.16.0-1) and mesa-git
>> (101352.498d9d0f4d-1) as I have a rx vega 64
>
> Vega is nice, however I would wait until mesa in extra/ repo get updated.
>
>> over the past few months I have been getting hard locks when opening
>> certain programs (usually due to a bad versions of mesa-git /
>> llvm-git, etc).
>>
>> i was at the time trying to open the program "cheese" and when I did,
>> my machine hard locked and only alt+shift+sysrq+b got my screen to go
>> black - and then did nothing else, so I held the power button for 3
>> seconds and then my machine rebooted.
>
> Pretty common hard power reset.
>
>> looking at journalctl, there is a large stacktrace from kernel: amdgpu
>> (see attached).
>> then when I booted back up the pool (2 disks, 1TB + 2TB) wouldn't mount.
>
> I'd say such corruption is pretty serious.
>
> And what's the profile of the btrfs? If metadata is raid1, we could at
> least try to recovery the superblock from the remaining disk.

I am not sure what the metadata was but the two disks had no parity
and just appeared as a single disk with total space of the two disks

how would i got about recovering the 2nd disk? attached is

btrfs inspect dump-super -Ffa

for the second disk

> And is there special mount options used here like discard?

compress=3Dlzo, noauto

> Thanks,
> Qu
>

Thank you for all your help so far.
Does this mean that the first disk is definatly gone? is there any way
to recover?


Thank,
Ben

>>
>> Thanks,
>> Ben
>>
>> On 7 April 2018 at 09:44, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>>
>>>
>>> On 2018=E5=B9=B404=E6=9C=8807=E6=97=A5 01:03, David Sterba wrote:
>>>> On Fri, Apr 06, 2018 at 11:32:34PM +1000, Ben Parsons wrote:
>>>>> Hi,
>>>>>
>>>>> I just had an unexpected restart and now my btrfs pool wont mount.
>>>>> The error on mount is:
>>>>>
>>>>>     "ERROR: unsupported checksum algorithm 41700"
>>>>>
>>>>> and when running
>>>>>
>>>>>     btrfs inspect-internal dump-super /dev/sda
>>>>>     ERROR: bad magic on superblock on /dev/sda at 65536
>>>>>
>>>>> I saw a thread in the mailing list about it:
>>>>> https://www.spinics.net/lists/linux-btrfs/msg75326.html
>>>>> However I am told on IRC that Qu fixed it using magic.
>>>>>
>>>>> Any help would be much appreciated.
>>>>
>>>> In the previous report, there were 2 isolated areas of superblock
>>>> damaged. Please post output of
>>>>
>>>>       btrfs inspect dump-super /path
>>>
>>> And don't forget -Ffa option.
>>> -F to force btrfs-progs to recognize it as btrfs no matter what the mag=
ic is
>>> -f shows all data so we could find all corruption and fix them if possi=
ble
>>> -a shows all backup superblocks, and if some backup is good, "btrfs
>>> rescue super-recovery" mentioned by Nikolay would be the best solution.
>>>
>>> Despite that, any extra info on how this happened is also appreciated,
>>> as similar problem happened twice, which means we need to pay attention
>>> on this.
>>>
>>> Thanks,
>>> Qu
>>>
>>> Thanks,
>>> Qu
>>>
>>>>
>>>> so we can see if it's a similar issue.
>>>>
>>>> In case it is, there's a tool in the btrfs-progs repo that can fix the
>>>> individual values.
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs"=
 in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>

--883d24f10970b378b3056938faf2
Content-Type: text/plain; charset="US-ASCII"; name="2nd disk inspect dump-super Ffa.txt"
Content-Disposition: attachment;
	filename="2nd disk inspect dump-super Ffa.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_jforgode0

c3VwZXJibG9jazogYnl0ZW5yPTY1NTM2LCBkZXZpY2U9L2Rldi9zZGMxCi0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQpjc3VtX3R5cGUJCTQx
NzAwIChJTlZBTElEKQpjc3VtX3NpemUJCTMyCmNzdW0JCQkweDNiMjUyZDNhMDAwMDAwMDAwMDAw
MDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAgW21hdGNoXQpieXRl
bnIJCQk2NTUzNgpmbGFncwkJCTB4MQoJCQkoIFdSSVRURU4gKQptYWdpYwkJCV9CSFJmU19NIFtt
YXRjaF0KZnNpZAkJCTA4ZTUxYzc2LTAwNjgtNDViYS1iYWM4LTljMWY1NzM2M2VjNgpsYWJlbAkJ
CQpnZW5lcmF0aW9uCQkxMjg1MzUxCnJvb3QJCQk2NDg1MzI2NDc5MzYwCnN5c19hcnJheV9zaXpl
CQkxMjkKY2h1bmtfcm9vdF9nZW5lcmF0aW9uCTEyNzM2NjkKcm9vdF9sZXZlbAkJMQpjaHVua19y
b290CQk1NTE4NTQwODgxOTIwCmNodW5rX3Jvb3RfbGV2ZWwJMQpsb2dfcm9vdAkJMApsb2dfcm9v
dF90cmFuc2lkCTAKbG9nX3Jvb3RfbGV2ZWwJCTAKdG90YWxfYnl0ZXMJCTI5NzkxMjc4NDQ4NjQK
Ynl0ZXNfdXNlZAkJMjkyNDY5OTQxNDUyOApzZWN0b3JzaXplCQk0MDk2Cm5vZGVzaXplCQkxNjM4
NApsZWFmc2l6ZSAoZGVwcmVjYXRlZCkJCTE2Mzg0CnN0cmlwZXNpemUJCTQwOTYKcm9vdF9kaXIJ
CTYKbnVtX2RldmljZXMJCTIKY29tcGF0X2ZsYWdzCQkweDAKY29tcGF0X3JvX2ZsYWdzCQkweDAK
aW5jb21wYXRfZmxhZ3MJCTB4NWIyMjQwMDAwMDAwMDE2OQoJCQkoIE1JWEVEX0JBQ0tSRUYgfAoJ
CQkgIENPTVBSRVNTX0xaTyB8CgkJCSAgQklHX01FVEFEQVRBIHwKCQkJICBFWFRFTkRFRF9JUkVG
IHwKCQkJICBTS0lOTllfTUVUQURBVEEgfAoJCQkgIHVua25vd24gZmxhZzogMHg1YjIyNDAwMDAw
MDAwMDAwICkKY2FjaGVfZ2VuZXJhdGlvbgkxMjg1MzUxCnV1aWRfdHJlZV9nZW5lcmF0aW9uCTEy
ODUzNTEKZGV2X2l0ZW0udXVpZAkJOWE0NDg5Y2QtNWFlZS00MWU5LTkyNWUtN2M4YzM1NGRkNTNm
CmRldl9pdGVtLmZzaWQJCTA4ZTUxYzc2LTAwNjgtNDViYS1iYWM4LTljMWY1NzM2M2VjNiBbbWF0
Y2hdCmRldl9pdGVtLnR5cGUJCTAKZGV2X2l0ZW0udG90YWxfYnl0ZXMJMTk3ODkyMjk1ODg0OApk
ZXZfaXRlbS5ieXRlc191c2VkCTE5Nzg5MjE5MTAyNzIKZGV2X2l0ZW0uaW9fYWxpZ24JNDA5Ngpk
ZXZfaXRlbS5pb193aWR0aAk0MDk2CmRldl9pdGVtLnNlY3Rvcl9zaXplCTQwOTYKZGV2X2l0ZW0u
ZGV2aWQJCTEKZGV2X2l0ZW0uZGV2X2dyb3VwCTAKZGV2X2l0ZW0uc2Vla19zcGVlZAkwCmRldl9p
dGVtLmJhbmR3aWR0aAkwCmRldl9pdGVtLmdlbmVyYXRpb24JMApzeXNfY2h1bmtfYXJyYXlbMjA0
OF06CglpdGVtIDAga2V5IChGSVJTVF9DSFVOS19UUkVFIENIVU5LX0lURU0gNTUxODU0MDg2NTUz
NikKCQlsZW5ndGggMzM1NTQ0MzIgb3duZXIgMiBzdHJpcGVfbGVuIDY1NTM2IHR5cGUgU1lTVEVN
fFJBSUQxCgkJaW9fYWxpZ24gNjU1MzYgaW9fd2lkdGggNjU1MzYgc2VjdG9yX3NpemUgNDA5NgoJ
CW51bV9zdHJpcGVzIDIgc3ViX3N0cmlwZXMgMQoJCQlzdHJpcGUgMCBkZXZpZCAxIG9mZnNldCAx
MDE0NzIzNzcyNDE2CgkJCWRldl91dWlkIDlhNDQ4OWNkLTVhZWUtNDFlOS05MjVlLTdjOGMzNTRk
ZDUzZgoJCQlzdHJpcGUgMSBkZXZpZCAyIG9mZnNldCA2NDc3MDUzOTUyCgkJCWRldl91dWlkIGE0
MDlhYWUzLWZhZmQtNDlkNS1iNTg5LWQ1NGVlZGNhNjI4ZgpiYWNrdXBfcm9vdHNbNF06CgliYWNr
dXAgMDoKCQliYWNrdXBfdHJlZV9yb290Ogk2NDg1MzI2NDc5MzYwCWdlbjogMTI4NTM1MQlsZXZl
bDogMQoJCWJhY2t1cF9jaHVua19yb290Ogk1NTE4NTQwODgxOTIwCWdlbjogMTI3MzY2OQlsZXZl
bDogMQoJCWJhY2t1cF9leHRlbnRfcm9vdDoJNjQ4NTMyNjQzMDIwOAlnZW46IDEyODUzNTEJbGV2
ZWw6IDIKCQliYWNrdXBfZnNfcm9vdDoJCTY0ODUzMjYzNjQ2NzIJZ2VuOiAxMjg1MzUxCWxldmVs
OiAyCgkJYmFja3VwX2Rldl9yb290Ogk0NjAxNzMwMjM2NDE2CWdlbjogMTI4MTE5MAlsZXZlbDog
MQoJCWJhY2t1cF9jc3VtX3Jvb3Q6CTY0ODUzMjY1NjEyODAJZ2VuOiAxMjg1MzUxCWxldmVsOiAz
CgkJYmFja3VwX3RvdGFsX2J5dGVzOgkyOTc5MTI3ODQ0ODY0CgkJYmFja3VwX2J5dGVzX3VzZWQ6
CTI5MjQ2OTk0MTQ1MjgKCQliYWNrdXBfbnVtX2RldmljZXM6CTIKCgliYWNrdXAgMToKCQliYWNr
dXBfdHJlZV9yb290Ogk2NDg1MzI0NDgwNTEyCWdlbjogMTI4NTM0OAlsZXZlbDogMQoJCWJhY2t1
cF9jaHVua19yb290Ogk1NTE4NTQwODgxOTIwCWdlbjogMTI3MzY2OQlsZXZlbDogMQoJCWJhY2t1
cF9leHRlbnRfcm9vdDoJNjQ4NTMyNDM5ODU5MglnZW46IDEyODUzNDgJbGV2ZWw6IDIKCQliYWNr
dXBfZnNfcm9vdDoJCTY0ODUzMjQyODM5MDQJZ2VuOiAxMjg1MzQ4CWxldmVsOiAyCgkJYmFja3Vw
X2Rldl9yb290Ogk0NjAxNzMwMjM2NDE2CWdlbjogMTI4MTE5MAlsZXZlbDogMQoJCWJhY2t1cF9j
c3VtX3Jvb3Q6CTY0ODUzMjQzMzMwNTYJZ2VuOiAxMjg1MzQ4CWxldmVsOiAzCgkJYmFja3VwX3Rv
dGFsX2J5dGVzOgkyOTc5MTI3ODQ0ODY0CgkJYmFja3VwX2J5dGVzX3VzZWQ6CTI5MjQ2OTk0MTQ1
MjgKCQliYWNrdXBfbnVtX2RldmljZXM6CTIKCgliYWNrdXAgMjoKCQliYWNrdXBfdHJlZV9yb290
Ogk2NDg1MzI0OTU1NjQ4CWdlbjogMTI4NTM0OQlsZXZlbDogMQoJCWJhY2t1cF9jaHVua19yb290
Ogk1NTE4NTQwODgxOTIwCWdlbjogMTI3MzY2OQlsZXZlbDogMQoJCWJhY2t1cF9leHRlbnRfcm9v
dDoJNjQ4NTMyNDg3MzcyOAlnZW46IDEyODUzNDkJbGV2ZWw6IDIKCQliYWNrdXBfZnNfcm9vdDoJ
CTY0ODUzMjQ4MjQ1NzYJZ2VuOiAxMjg1MzQ5CWxldmVsOiAyCgkJYmFja3VwX2Rldl9yb290Ogk0
NjAxNzMwMjM2NDE2CWdlbjogMTI4MTE5MAlsZXZlbDogMQoJCWJhY2t1cF9jc3VtX3Jvb3Q6CTY0
ODUzMjUwNTM5NTIJZ2VuOiAxMjg1MzQ5CWxldmVsOiAzCgkJYmFja3VwX3RvdGFsX2J5dGVzOgky
OTc5MTI3ODQ0ODY0CgkJYmFja3VwX2J5dGVzX3VzZWQ6CTI5MjQ2OTk0MTQ1MjgKCQliYWNrdXBf
bnVtX2RldmljZXM6CTIKCgliYWNrdXAgMzoKCQliYWNrdXBfdHJlZV9yb290Ogk2NDg1MzI1OTIy
MzA0CWdlbjogMTI4NTM1MAlsZXZlbDogMQoJCWJhY2t1cF9jaHVua19yb290Ogk1NTE4NTQwODgx
OTIwCWdlbjogMTI3MzY2OQlsZXZlbDogMQoJCWJhY2t1cF9leHRlbnRfcm9vdDoJNjQ4NTMyNTgw
NzYxNglnZW46IDEyODUzNTAJbGV2ZWw6IDIKCQliYWNrdXBfZnNfcm9vdDoJCTY0ODUzMjUzODE2
MzIJZ2VuOiAxMjg1MzUwCWxldmVsOiAyCgkJYmFja3VwX2Rldl9yb290Ogk0NjAxNzMwMjM2NDE2
CWdlbjogMTI4MTE5MAlsZXZlbDogMQoJCWJhY2t1cF9jc3VtX3Jvb3Q6CTY0ODUzMjYwNTMzNzYJ
Z2VuOiAxMjg1MzUwCWxldmVsOiAzCgkJYmFja3VwX3RvdGFsX2J5dGVzOgkyOTc5MTI3ODQ0ODY0
CgkJYmFja3VwX2J5dGVzX3VzZWQ6CTI5MjQ2OTk0MTQ1MjgKCQliYWNrdXBfbnVtX2RldmljZXM6
CTIKCgpzdXBlcmJsb2NrOiBieXRlbnI9NjcxMDg4NjQsIGRldmljZT0vZGV2L3NkYzEKLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCmNzdW1f
dHlwZQkJNDE3MDAgKElOVkFMSUQpCmNzdW1fc2l6ZQkJMzIKY3N1bQkJCTB4OWI0NDA1ZjQwMDAw
MDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMCBbRE9O
J1QgTUFUQ0hdCmJ5dGVucgkJCTY3MTA4ODY0CmZsYWdzCQkJMHgxCgkJCSggV1JJVFRFTiApCm1h
Z2ljCQkJX0JIUmZTX00gW21hdGNoXQpmc2lkCQkJMDhlNTFjNzYtMDA2OC00NWJhLWJhYzgtOWMx
ZjU3MzYzZWM2CmxhYmVsCQkJCmdlbmVyYXRpb24JCTEyODUzNTEKcm9vdAkJCTY0ODUzMjY0Nzkz
NjAKc3lzX2FycmF5X3NpemUJCTEyOQpjaHVua19yb290X2dlbmVyYXRpb24JMTI3MzY2OQpyb290
X2xldmVsCQkxCmNodW5rX3Jvb3QJCTU1MTg1NDA4ODE5MjAKY2h1bmtfcm9vdF9sZXZlbAkxCmxv
Z19yb290CQkwCmxvZ19yb290X3RyYW5zaWQJMApsb2dfcm9vdF9sZXZlbAkJMAp0b3RhbF9ieXRl
cwkJMjk3OTEyNzg0NDg2NApieXRlc191c2VkCQkyOTI0Njk5NDE0NTI4CnNlY3RvcnNpemUJCTQw
OTYKbm9kZXNpemUJCTE2Mzg0CmxlYWZzaXplIChkZXByZWNhdGVkKQkJMTYzODQKc3RyaXBlc2l6
ZQkJNDA5Ngpyb290X2RpcgkJNgpudW1fZGV2aWNlcwkJMgpjb21wYXRfZmxhZ3MJCTB4MApjb21w
YXRfcm9fZmxhZ3MJCTB4MAppbmNvbXBhdF9mbGFncwkJMHg1YjIyNDAwMDAwMDAwMTY5CgkJCSgg
TUlYRURfQkFDS1JFRiB8CgkJCSAgQ09NUFJFU1NfTFpPIHwKCQkJICBCSUdfTUVUQURBVEEgfAoJ
CQkgIEVYVEVOREVEX0lSRUYgfAoJCQkgIFNLSU5OWV9NRVRBREFUQSB8CgkJCSAgdW5rbm93biBm
bGFnOiAweDViMjI0MDAwMDAwMDAwMDAgKQpjYWNoZV9nZW5lcmF0aW9uCTEyODUzNTEKdXVpZF90
cmVlX2dlbmVyYXRpb24JMTI4NTM1MQpkZXZfaXRlbS51dWlkCQk5YTQ0ODljZC01YWVlLTQxZTkt
OTI1ZS03YzhjMzU0ZGQ1M2YKZGV2X2l0ZW0uZnNpZAkJMDhlNTFjNzYtMDA2OC00NWJhLWJhYzgt
OWMxZjU3MzYzZWM2IFttYXRjaF0KZGV2X2l0ZW0udHlwZQkJMApkZXZfaXRlbS50b3RhbF9ieXRl
cwkxOTc4OTIyOTU4ODQ4CmRldl9pdGVtLmJ5dGVzX3VzZWQJMTk3ODkyMTkxMDI3MgpkZXZfaXRl
bS5pb19hbGlnbgk0MDk2CmRldl9pdGVtLmlvX3dpZHRoCTQwOTYKZGV2X2l0ZW0uc2VjdG9yX3Np
emUJNDA5NgpkZXZfaXRlbS5kZXZpZAkJMQpkZXZfaXRlbS5kZXZfZ3JvdXAJMApkZXZfaXRlbS5z
ZWVrX3NwZWVkCTAKZGV2X2l0ZW0uYmFuZHdpZHRoCTAKZGV2X2l0ZW0uZ2VuZXJhdGlvbgkwCnN5
c19jaHVua19hcnJheVsyMDQ4XToKCWl0ZW0gMCBrZXkgKEZJUlNUX0NIVU5LX1RSRUUgQ0hVTktf
SVRFTSA1NTE4NTQwODY1NTM2KQoJCWxlbmd0aCAzMzU1NDQzMiBvd25lciAyIHN0cmlwZV9sZW4g
NjU1MzYgdHlwZSBTWVNURU18UkFJRDEKCQlpb19hbGlnbiA2NTUzNiBpb193aWR0aCA2NTUzNiBz
ZWN0b3Jfc2l6ZSA0MDk2CgkJbnVtX3N0cmlwZXMgMiBzdWJfc3RyaXBlcyAxCgkJCXN0cmlwZSAw
IGRldmlkIDEgb2Zmc2V0IDEwMTQ3MjM3NzI0MTYKCQkJZGV2X3V1aWQgOWE0NDg5Y2QtNWFlZS00
MWU5LTkyNWUtN2M4YzM1NGRkNTNmCgkJCXN0cmlwZSAxIGRldmlkIDIgb2Zmc2V0IDY0NzcwNTM5
NTIKCQkJZGV2X3V1aWQgYTQwOWFhZTMtZmFmZC00OWQ1LWI1ODktZDU0ZWVkY2E2MjhmCmJhY2t1
cF9yb290c1s0XToKCWJhY2t1cCAwOgoJCWJhY2t1cF90cmVlX3Jvb3Q6CTY0ODUzMjY0NzkzNjAJ
Z2VuOiAxMjg1MzUxCWxldmVsOiAxCgkJYmFja3VwX2NodW5rX3Jvb3Q6CTU1MTg1NDA4ODE5MjAJ
Z2VuOiAxMjczNjY5CWxldmVsOiAxCgkJYmFja3VwX2V4dGVudF9yb290Ogk2NDg1MzI2NDMwMjA4
CWdlbjogMTI4NTM1MQlsZXZlbDogMgoJCWJhY2t1cF9mc19yb290OgkJNjQ4NTMyNjM2NDY3Mgln
ZW46IDEyODUzNTEJbGV2ZWw6IDIKCQliYWNrdXBfZGV2X3Jvb3Q6CTQ2MDE3MzAyMzY0MTYJZ2Vu
OiAxMjgxMTkwCWxldmVsOiAxCgkJYmFja3VwX2NzdW1fcm9vdDoJNjQ4NTMyNjU2MTI4MAlnZW46
IDEyODUzNTEJbGV2ZWw6IDMKCQliYWNrdXBfdG90YWxfYnl0ZXM6CTI5NzkxMjc4NDQ4NjQKCQli
YWNrdXBfYnl0ZXNfdXNlZDoJMjkyNDY5OTQxNDUyOAoJCWJhY2t1cF9udW1fZGV2aWNlczoJMgoK
CWJhY2t1cCAxOgoJCWJhY2t1cF90cmVlX3Jvb3Q6CTY0ODUzMjQ0ODA1MTIJZ2VuOiAxMjg1MzQ4
CWxldmVsOiAxCgkJYmFja3VwX2NodW5rX3Jvb3Q6CTU1MTg1NDA4ODE5MjAJZ2VuOiAxMjczNjY5
CWxldmVsOiAxCgkJYmFja3VwX2V4dGVudF9yb290Ogk2NDg1MzI0Mzk4NTkyCWdlbjogMTI4NTM0
OAlsZXZlbDogMgoJCWJhY2t1cF9mc19yb290OgkJNjQ4NTMyNDI4MzkwNAlnZW46IDEyODUzNDgJ
bGV2ZWw6IDIKCQliYWNrdXBfZGV2X3Jvb3Q6CTQ2MDE3MzAyMzY0MTYJZ2VuOiAxMjgxMTkwCWxl
dmVsOiAxCgkJYmFja3VwX2NzdW1fcm9vdDoJNjQ4NTMyNDMzMzA1NglnZW46IDEyODUzNDgJbGV2
ZWw6IDMKCQliYWNrdXBfdG90YWxfYnl0ZXM6CTI5NzkxMjc4NDQ4NjQKCQliYWNrdXBfYnl0ZXNf
dXNlZDoJMjkyNDY5OTQxNDUyOAoJCWJhY2t1cF9udW1fZGV2aWNlczoJMgoKCWJhY2t1cCAyOgoJ
CWJhY2t1cF90cmVlX3Jvb3Q6CTY0ODUzMjQ5NTU2NDgJZ2VuOiAxMjg1MzQ5CWxldmVsOiAxCgkJ
YmFja3VwX2NodW5rX3Jvb3Q6CTU1MTg1NDA4ODE5MjAJZ2VuOiAxMjczNjY5CWxldmVsOiAxCgkJ
YmFja3VwX2V4dGVudF9yb290Ogk2NDg1MzI0ODczNzI4CWdlbjogMTI4NTM0OQlsZXZlbDogMgoJ
CWJhY2t1cF9mc19yb290OgkJNjQ4NTMyNDgyNDU3NglnZW46IDEyODUzNDkJbGV2ZWw6IDIKCQli
YWNrdXBfZGV2X3Jvb3Q6CTQ2MDE3MzAyMzY0MTYJZ2VuOiAxMjgxMTkwCWxldmVsOiAxCgkJYmFj
a3VwX2NzdW1fcm9vdDoJNjQ4NTMyNTA1Mzk1MglnZW46IDEyODUzNDkJbGV2ZWw6IDMKCQliYWNr
dXBfdG90YWxfYnl0ZXM6CTI5NzkxMjc4NDQ4NjQKCQliYWNrdXBfYnl0ZXNfdXNlZDoJMjkyNDY5
OTQxNDUyOAoJCWJhY2t1cF9udW1fZGV2aWNlczoJMgoKCWJhY2t1cCAzOgoJCWJhY2t1cF90cmVl
X3Jvb3Q6CTY0ODUzMjU5MjIzMDQJZ2VuOiAxMjg1MzUwCWxldmVsOiAxCgkJYmFja3VwX2NodW5r
X3Jvb3Q6CTU1MTg1NDA4ODE5MjAJZ2VuOiAxMjczNjY5CWxldmVsOiAxCgkJYmFja3VwX2V4dGVu
dF9yb290Ogk2NDg1MzI1ODA3NjE2CWdlbjogMTI4NTM1MAlsZXZlbDogMgoJCWJhY2t1cF9mc19y
b290OgkJNjQ4NTMyNTM4MTYzMglnZW46IDEyODUzNTAJbGV2ZWw6IDIKCQliYWNrdXBfZGV2X3Jv
b3Q6CTQ2MDE3MzAyMzY0MTYJZ2VuOiAxMjgxMTkwCWxldmVsOiAxCgkJYmFja3VwX2NzdW1fcm9v
dDoJNjQ4NTMyNjA1MzM3NglnZW46IDEyODUzNTAJbGV2ZWw6IDMKCQliYWNrdXBfdG90YWxfYnl0
ZXM6CTI5NzkxMjc4NDQ4NjQKCQliYWNrdXBfYnl0ZXNfdXNlZDoJMjkyNDY5OTQxNDUyOAoJCWJh
Y2t1cF9udW1fZGV2aWNlczoJMgoKCnN1cGVyYmxvY2s6IGJ5dGVucj0yNzQ4Nzc5MDY5NDQsIGRl
dmljZT0vZGV2L3NkYzEKLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tCmNzdW1fdHlwZQkJNDE3MDAgKElOVkFMSUQpCmNzdW1fc2l6ZQkJMzIK
Y3N1bQkJCTB4NjZjMzUzYzUwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAw
MDAwMDAwMDAwMDAwMDAwMCBbRE9OJ1QgTUFUQ0hdCmJ5dGVucgkJCTI3NDg3NzkwNjk0NApmbGFn
cwkJCTB4MQoJCQkoIFdSSVRURU4gKQptYWdpYwkJCV9CSFJmU19NIFttYXRjaF0KZnNpZAkJCTA4
ZTUxYzc2LTAwNjgtNDViYS1iYWM4LTljMWY1NzM2M2VjNgpsYWJlbAkJCQpnZW5lcmF0aW9uCQkx
Mjg1MzUxCnJvb3QJCQk2NDg1MzI2NDc5MzYwCnN5c19hcnJheV9zaXplCQkxMjkKY2h1bmtfcm9v
dF9nZW5lcmF0aW9uCTEyNzM2NjkKcm9vdF9sZXZlbAkJMQpjaHVua19yb290CQk1NTE4NTQwODgx
OTIwCmNodW5rX3Jvb3RfbGV2ZWwJMQpsb2dfcm9vdAkJMApsb2dfcm9vdF90cmFuc2lkCTAKbG9n
X3Jvb3RfbGV2ZWwJCTAKdG90YWxfYnl0ZXMJCTI5NzkxMjc4NDQ4NjQKYnl0ZXNfdXNlZAkJMjky
NDY5OTQxNDUyOApzZWN0b3JzaXplCQk0MDk2Cm5vZGVzaXplCQkxNjM4NApsZWFmc2l6ZSAoZGVw
cmVjYXRlZCkJCTE2Mzg0CnN0cmlwZXNpemUJCTQwOTYKcm9vdF9kaXIJCTYKbnVtX2RldmljZXMJ
CTIKY29tcGF0X2ZsYWdzCQkweDAKY29tcGF0X3JvX2ZsYWdzCQkweDAKaW5jb21wYXRfZmxhZ3MJ
CTB4NWIyMjQwMDAwMDAwMDE2OQoJCQkoIE1JWEVEX0JBQ0tSRUYgfAoJCQkgIENPTVBSRVNTX0xa
TyB8CgkJCSAgQklHX01FVEFEQVRBIHwKCQkJICBFWFRFTkRFRF9JUkVGIHwKCQkJICBTS0lOTllf
TUVUQURBVEEgfAoJCQkgIHVua25vd24gZmxhZzogMHg1YjIyNDAwMDAwMDAwMDAwICkKY2FjaGVf
Z2VuZXJhdGlvbgkxMjg1MzUxCnV1aWRfdHJlZV9nZW5lcmF0aW9uCTEyODUzNTEKZGV2X2l0ZW0u
dXVpZAkJOWE0NDg5Y2QtNWFlZS00MWU5LTkyNWUtN2M4YzM1NGRkNTNmCmRldl9pdGVtLmZzaWQJ
CTA4ZTUxYzc2LTAwNjgtNDViYS1iYWM4LTljMWY1NzM2M2VjNiBbbWF0Y2hdCmRldl9pdGVtLnR5
cGUJCTAKZGV2X2l0ZW0udG90YWxfYnl0ZXMJMTk3ODkyMjk1ODg0OApkZXZfaXRlbS5ieXRlc191
c2VkCTE5Nzg5MjE5MTAyNzIKZGV2X2l0ZW0uaW9fYWxpZ24JNDA5NgpkZXZfaXRlbS5pb193aWR0
aAk0MDk2CmRldl9pdGVtLnNlY3Rvcl9zaXplCTQwOTYKZGV2X2l0ZW0uZGV2aWQJCTEKZGV2X2l0
ZW0uZGV2X2dyb3VwCTAKZGV2X2l0ZW0uc2Vla19zcGVlZAkwCmRldl9pdGVtLmJhbmR3aWR0aAkw
CmRldl9pdGVtLmdlbmVyYXRpb24JMApzeXNfY2h1bmtfYXJyYXlbMjA0OF06CglpdGVtIDAga2V5
IChGSVJTVF9DSFVOS19UUkVFIENIVU5LX0lURU0gNTUxODU0MDg2NTUzNikKCQlsZW5ndGggMzM1
NTQ0MzIgb3duZXIgMiBzdHJpcGVfbGVuIDY1NTM2IHR5cGUgU1lTVEVNfFJBSUQxCgkJaW9fYWxp
Z24gNjU1MzYgaW9fd2lkdGggNjU1MzYgc2VjdG9yX3NpemUgNDA5NgoJCW51bV9zdHJpcGVzIDIg
c3ViX3N0cmlwZXMgMQoJCQlzdHJpcGUgMCBkZXZpZCAxIG9mZnNldCAxMDE0NzIzNzcyNDE2CgkJ
CWRldl91dWlkIDlhNDQ4OWNkLTVhZWUtNDFlOS05MjVlLTdjOGMzNTRkZDUzZgoJCQlzdHJpcGUg
MSBkZXZpZCAyIG9mZnNldCA2NDc3MDUzOTUyCgkJCWRldl91dWlkIGE0MDlhYWUzLWZhZmQtNDlk
NS1iNTg5LWQ1NGVlZGNhNjI4ZgpiYWNrdXBfcm9vdHNbNF06CgliYWNrdXAgMDoKCQliYWNrdXBf
dHJlZV9yb290Ogk2NDg1MzI2NDc5MzYwCWdlbjogMTI4NTM1MQlsZXZlbDogMQoJCWJhY2t1cF9j
aHVua19yb290Ogk1NTE4NTQwODgxOTIwCWdlbjogMTI3MzY2OQlsZXZlbDogMQoJCWJhY2t1cF9l
eHRlbnRfcm9vdDoJNjQ4NTMyNjQzMDIwOAlnZW46IDEyODUzNTEJbGV2ZWw6IDIKCQliYWNrdXBf
ZnNfcm9vdDoJCTY0ODUzMjYzNjQ2NzIJZ2VuOiAxMjg1MzUxCWxldmVsOiAyCgkJYmFja3VwX2Rl
dl9yb290Ogk0NjAxNzMwMjM2NDE2CWdlbjogMTI4MTE5MAlsZXZlbDogMQoJCWJhY2t1cF9jc3Vt
X3Jvb3Q6CTY0ODUzMjY1NjEyODAJZ2VuOiAxMjg1MzUxCWxldmVsOiAzCgkJYmFja3VwX3RvdGFs
X2J5dGVzOgkyOTc5MTI3ODQ0ODY0CgkJYmFja3VwX2J5dGVzX3VzZWQ6CTI5MjQ2OTk0MTQ1MjgK
CQliYWNrdXBfbnVtX2RldmljZXM6CTIKCgliYWNrdXAgMToKCQliYWNrdXBfdHJlZV9yb290Ogk2
NDg1MzI0NDgwNTEyCWdlbjogMTI4NTM0OAlsZXZlbDogMQoJCWJhY2t1cF9jaHVua19yb290Ogk1
NTE4NTQwODgxOTIwCWdlbjogMTI3MzY2OQlsZXZlbDogMQoJCWJhY2t1cF9leHRlbnRfcm9vdDoJ
NjQ4NTMyNDM5ODU5MglnZW46IDEyODUzNDgJbGV2ZWw6IDIKCQliYWNrdXBfZnNfcm9vdDoJCTY0
ODUzMjQyODM5MDQJZ2VuOiAxMjg1MzQ4CWxldmVsOiAyCgkJYmFja3VwX2Rldl9yb290Ogk0NjAx
NzMwMjM2NDE2CWdlbjogMTI4MTE5MAlsZXZlbDogMQoJCWJhY2t1cF9jc3VtX3Jvb3Q6CTY0ODUz
MjQzMzMwNTYJZ2VuOiAxMjg1MzQ4CWxldmVsOiAzCgkJYmFja3VwX3RvdGFsX2J5dGVzOgkyOTc5
MTI3ODQ0ODY0CgkJYmFja3VwX2J5dGVzX3VzZWQ6CTI5MjQ2OTk0MTQ1MjgKCQliYWNrdXBfbnVt
X2RldmljZXM6CTIKCgliYWNrdXAgMjoKCQliYWNrdXBfdHJlZV9yb290Ogk2NDg1MzI0OTU1NjQ4
CWdlbjogMTI4NTM0OQlsZXZlbDogMQoJCWJhY2t1cF9jaHVua19yb290Ogk1NTE4NTQwODgxOTIw
CWdlbjogMTI3MzY2OQlsZXZlbDogMQoJCWJhY2t1cF9leHRlbnRfcm9vdDoJNjQ4NTMyNDg3Mzcy
OAlnZW46IDEyODUzNDkJbGV2ZWw6IDIKCQliYWNrdXBfZnNfcm9vdDoJCTY0ODUzMjQ4MjQ1NzYJ
Z2VuOiAxMjg1MzQ5CWxldmVsOiAyCgkJYmFja3VwX2Rldl9yb290Ogk0NjAxNzMwMjM2NDE2CWdl
bjogMTI4MTE5MAlsZXZlbDogMQoJCWJhY2t1cF9jc3VtX3Jvb3Q6CTY0ODUzMjUwNTM5NTIJZ2Vu
OiAxMjg1MzQ5CWxldmVsOiAzCgkJYmFja3VwX3RvdGFsX2J5dGVzOgkyOTc5MTI3ODQ0ODY0CgkJ
YmFja3VwX2J5dGVzX3VzZWQ6CTI5MjQ2OTk0MTQ1MjgKCQliYWNrdXBfbnVtX2RldmljZXM6CTIK
CgliYWNrdXAgMzoKCQliYWNrdXBfdHJlZV9yb290Ogk2NDg1MzI1OTIyMzA0CWdlbjogMTI4NTM1
MAlsZXZlbDogMQoJCWJhY2t1cF9jaHVua19yb290Ogk1NTE4NTQwODgxOTIwCWdlbjogMTI3MzY2
OQlsZXZlbDogMQoJCWJhY2t1cF9leHRlbnRfcm9vdDoJNjQ4NTMyNTgwNzYxNglnZW46IDEyODUz
NTAJbGV2ZWw6IDIKCQliYWNrdXBfZnNfcm9vdDoJCTY0ODUzMjUzODE2MzIJZ2VuOiAxMjg1MzUw
CWxldmVsOiAyCgkJYmFja3VwX2Rldl9yb290Ogk0NjAxNzMwMjM2NDE2CWdlbjogMTI4MTE5MAls
ZXZlbDogMQoJCWJhY2t1cF9jc3VtX3Jvb3Q6CTY0ODUzMjYwNTMzNzYJZ2VuOiAxMjg1MzUwCWxl
dmVsOiAzCgkJYmFja3VwX3RvdGFsX2J5dGVzOgkyOTc5MTI3ODQ0ODY0CgkJYmFja3VwX2J5dGVz
X3VzZWQ6CTI5MjQ2OTk0MTQ1MjgKCQliYWNrdXBfbnVtX2RldmljZXM6CTIKCgo=
--883d24f10970b378b3056938faf2--
