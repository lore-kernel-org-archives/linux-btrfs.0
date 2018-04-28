Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f53.google.com ([209.85.213.53]:36641 "EHLO
        mail-vk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759744AbeD1JhQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 28 Apr 2018 05:37:16 -0400
Received: by mail-vk0-f53.google.com with SMTP id k67-v6so2536873vkd.3
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Apr 2018 02:37:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <54d2f70a-adae-98cc-581f-2e4786783b26@gmx.com>
References: <CAB+znrFyimDnOZt46CqterRJ6MvwD4TSWagQvv-oQxjPvG-m2w@mail.gmail.com>
 <54d2f70a-adae-98cc-581f-2e4786783b26@gmx.com>
From: Michael Wade <spikewade@gmail.com>
Date: Sat, 28 Apr 2018 10:37:14 +0100
Message-ID: <CAB+znrHYrhBB4cstUaS3KcOfEHhOTPUsfAJKj3Cj62HJ-05FrQ@mail.gmail.com>
Subject: Re: BTRFS RAID filesystem unmountable
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: multipart/mixed; boundary="000000000000ae4c98056ae55dc0"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--000000000000ae4c98056ae55dc0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Qu,

Thanks for your reply. I will investigate upgrading the kernel,
however I worry that future ReadyNAS firmware upgrades would fail on a
newer kernel version (I don't have much linux experience so maybe my
concerns are unfounded!?).

I have attached the output of the dump super command.

I did actually run chunk recover before, without the verbose option,
it took around 24 hours to finish but did not resolve my issue. Happy
to start that again if you need its output.

Thanks so much for your help.

Kind regards
Michael

On 28 April 2018 at 09:45, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
> On 2018=E5=B9=B404=E6=9C=8828=E6=97=A5 16:30, Michael Wade wrote:
>> Hi all,
>>
>> I was hoping that someone would be able to help me resolve the issues
>> I am having with my ReadyNAS BTRFS volume. Basically my trouble
>> started after a power cut, subsequently the volume would not mount.
>> Here are the details of my setup as it is at the moment:
>>
>> uname -a
>> Linux QAI 4.4.116.alpine.1 #1 SMP Mon Feb 19 21:58:38 PST 2018 armv7l GN=
U/Linux
>
> The kernel is pretty old for btrfs.
> Strongly recommended to upgrade.
>
>>
>> btrfs --version
>> btrfs-progs v4.12
>
> So is the user tools.
>
> Although I think it won't be a big problem, as needed tool should be ther=
e.
>
>>
>> btrfs fi show
>> Label: '11baed92:data'  uuid: 20628cda-d98f-4f85-955c-932a367f8821
>> Total devices 1 FS bytes used 5.12TiB
>> devid    1 size 7.27TiB used 6.24TiB path /dev/md127
>
> So, it's btrfs on mdraid.
> It would normally make things harder to debug, so I could only provide
> advice from the respect of btrfs.
> For mdraid part, I can't ensure anything.
>
>>
>> Here are the relevant dmesg logs for the current state of the device:
>>
>> [   19.119391] md: md127 stopped.
>> [   19.120841] md: bind<sdb3>
>> [   19.121120] md: bind<sdc3>
>> [   19.121380] md: bind<sda3>
>> [   19.125535] md/raid:md127: device sda3 operational as raid disk 0
>> [   19.125547] md/raid:md127: device sdc3 operational as raid disk 2
>> [   19.125554] md/raid:md127: device sdb3 operational as raid disk 1
>> [   19.126712] md/raid:md127: allocated 3240kB
>> [   19.126778] md/raid:md127: raid level 5 active with 3 out of 3
>> devices, algorithm 2
>> [   19.126784] RAID conf printout:
>> [   19.126789]  --- level:5 rd:3 wd:3
>> [   19.126794]  disk 0, o:1, dev:sda3
>> [   19.126799]  disk 1, o:1, dev:sdb3
>> [   19.126804]  disk 2, o:1, dev:sdc3
>> [   19.128118] md127: detected capacity change from 0 to 7991637573632
>> [   19.395112] Adding 523708k swap on /dev/md1.  Priority:-1 extents:1
>> across:523708k
>> [   19.434956] BTRFS: device label 11baed92:data devid 1 transid
>> 151800 /dev/md127
>> [   19.739276] BTRFS info (device md127): setting nodatasum
>> [   19.740440] BTRFS critical (device md127): unable to find logical
>> 3208757641216 len 4096
>> [   19.740450] BTRFS critical (device md127): unable to find logical
>> 3208757641216 len 4096
>> [   19.740498] BTRFS critical (device md127): unable to find logical
>> 3208757641216 len 4096
>> [   19.740512] BTRFS critical (device md127): unable to find logical
>> 3208757641216 len 4096
>> [   19.740552] BTRFS critical (device md127): unable to find logical
>> 3208757641216 len 4096
>> [   19.740560] BTRFS critical (device md127): unable to find logical
>> 3208757641216 len 4096
>> [   19.740576] BTRFS error (device md127): failed to read chunk root
>
> This shows it pretty clear, btrfs fails to read chunk root.
> And according your above "len 4096" it's pretty old fs, as it's still
> using 4K nodesize other than 16K nodesize.
>
> According to above output, it means your superblock by somehow lacks the
> needed system chunk mapping, which is used to initialize chunk mapping.
>
> Please provide the following command output:
>
> # btrfs inspect dump-super -fFa /dev/md127
>
> Also, please consider run the following command and dump all its output:
>
> # btrfs rescue chunk-recover -v /dev/md127.
>
> Please note that, above command can take a long time to finish, and if
> it works without problem, it may solve your problem.
> But if it doesn't work, the output could help me to manually craft a fix
> to your super block.
>
> Thanks,
> Qu
>
>
>> [   19.783975] BTRFS error (device md127): open_ctree failed
>>
>> In an attempt to recover the volume myself I run a few BTRFS commands
>> mostly using advice from here:
>> https://lists.opensuse.org/opensuse/2017-02/msg00930.html. However
>> that actually seems to have made things worse as I can no longer mount
>> the file system, not even in readonly mode.
>>
>> So starting from the beginning here is a list of things I have done so
>> far (hopefully I remembered the order in which I ran them!)
>>
>> 1. Noticed that my backups to the NAS were not running (didn't get
>> notified that the volume had basically "died")
>> 2. ReadyNAS UI indicated that the volume was inactive.
>> 3. SSHed onto the box and found that the first drive was not marked as
>> operational (log showed I/O errors / UNKOWN (0x2003))  so I replaced
>> the disk and let the array resync.
>> 4. After resync the volume still was unaccessible so I looked at the
>> logs once more and saw something like the following which seemed to
>> indicate that the replay log had been corrupted when the power went
>> out:
>>
>> BTRFS critical (device md127): corrupt leaf, non-root leaf's nritems
>> is 0: block=3D232292352, root=3D7, slot=3D0
>> BTRFS critical (device md127): corrupt leaf, non-root leaf's nritems
>> is 0: block=3D232292352, root=3D7, slot=3D0
>> BTRFS: error (device md127) in btrfs_replay_log:2524: errno=3D-5 IO
>> failure (Failed to recover log tree)
>> BTRFS error (device md127): pending csums is 155648
>> BTRFS error (device md127): cleaner transaction attach returned -30
>> BTRFS critical (device md127): corrupt leaf, non-root leaf's nritems
>> is 0: block=3D232292352, root=3D7, slot=3D0
>>
>> 5. Then:
>>
>> btrfs rescue zero-log
>>
>> 6. Was then able to mount the volume in readonly mode.
>>
>> btrfs scrub start
>>
>> Which fixed some errors but not all:
>>
>> scrub status for 20628cda-d98f-4f85-955c-932a367f8821
>>
>> scrub started at Tue Apr 24 17:27:44 2018, running for 04:00:34
>> total bytes scrubbed: 224.26GiB with 6 errors
>> error details: csum=3D6
>> corrected errors: 0, uncorrectable errors: 6, unverified errors: 0
>>
>> scrub status for 20628cda-d98f-4f85-955c-932a367f8821
>> scrub started at Tue Apr 24 17:27:44 2018, running for 04:34:43
>> total bytes scrubbed: 224.26GiB with 6 errors
>> error details: csum=3D6
>> corrected errors: 0, uncorrectable errors: 6, unverified errors: 0
>>
>> 6. Seeing this hanging I rebooted the NAS
>> 7. Think this is when the volume would not mount at all.
>> 8. Seeing log entries like these:
>>
>> BTRFS warning (device md127): checksum error at logical 20800943685632
>> on dev /dev/md127, sector 520167424: metadata node (level 1) in tree 3
>>
>> I ran
>>
>> btrfs check --fix-crc
>>
>> And that brings us to where I am now: Some seemly corrupted BTRFS
>> metadata and unable to mount the drive even with the recovery option.
>>
>> Any help you can give is much appreciated!
>>
>> Kind regards
>> Michael
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" i=
n
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>

--000000000000ae4c98056ae55dc0
Content-Type: text/plain; charset="US-ASCII"; name="dumpsuper.txt"
Content-Disposition: attachment; filename="dumpsuper.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_jgj6pvkm1

YnRyZnMgaW5zcGVjdCBkdW1wLXN1cGVyIC1mRmEgL2Rldi9tZDEyNwpzdXBlcmJsb2NrOiBieXRl
bnI9NjU1MzYsIGRldmljZT0vZGV2L21kMTI3Ci0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQpjc3VtX3R5cGUJCTAgKGNyYzMyYykKY3N1bV9z
aXplCQk0CmNzdW0JCQkweGE1ZTdkYzc1IFttYXRjaF0KYnl0ZW5yCQkJNjU1MzYKZmxhZ3MJCQkw
eDEKCQkJKCBXUklUVEVOICkKbWFnaWMJCQlfQkhSZlNfTSBbbWF0Y2hdCmZzaWQJCQkyMDYyOGNk
YS1kOThmLTRmODUtOTU1Yy05MzJhMzY3Zjg4MjEKbGFiZWwJCQkxMWJhZWQ5MjpkYXRhCmdlbmVy
YXRpb24JCTE1MTgwMApyb290CQkJNDQ5NTc2OTYKc3lzX2FycmF5X3NpemUJCTM1NQpjaHVua19y
b290X2dlbmVyYXRpb24JMTUxNzc3CnJvb3RfbGV2ZWwJCTEKY2h1bmtfcm9vdAkJMjA4MDA5NDM2
ODU2MzIKY2h1bmtfcm9vdF9sZXZlbAkxCmxvZ19yb290CQkwCmxvZ19yb290X3RyYW5zaWQJMAps
b2dfcm9vdF9sZXZlbAkJMAp0b3RhbF9ieXRlcwkJNzk5MTYzNzU3MzYzMgpieXRlc191c2VkCQk1
NjMxOTkzNTA3ODQwCnNlY3RvcnNpemUJCTQwOTYKbm9kZXNpemUJCTMyNzY4CmxlYWZzaXplIChk
ZXByZWNhdGVkKQkJMzI3NjgKc3RyaXBlc2l6ZQkJNDA5Ngpyb290X2RpcgkJNgpudW1fZGV2aWNl
cwkJMQpjb21wYXRfZmxhZ3MJCTB4MApjb21wYXRfcm9fZmxhZ3MJCTB4MAppbmNvbXBhdF9mbGFn
cwkJMHgyMQoJCQkoIE1JWEVEX0JBQ0tSRUYgfAoJCQkgIEJJR19NRVRBREFUQSApCmNhY2hlX2dl
bmVyYXRpb24JMTg0NDY3NDQwNzM3MDk1NTE2MTUKdXVpZF90cmVlX2dlbmVyYXRpb24JMTUxODAw
CmRldl9pdGVtLnV1aWQJCTdjMjMyNGRjLTc5MDYtNDMwYS1iNDRmLWNiZmNlM2FjNWM1NgpkZXZf
aXRlbS5mc2lkCQkyMDYyOGNkYS1kOThmLTRmODUtOTU1Yy05MzJhMzY3Zjg4MjEgW21hdGNoXQpk
ZXZfaXRlbS50eXBlCQkyCmRldl9pdGVtLnRvdGFsX2J5dGVzCTc5OTE2Mzc1NzM2MzIKZGV2X2l0
ZW0uYnl0ZXNfdXNlZAk2ODYwMjQxMzcxMTM2CmRldl9pdGVtLmlvX2FsaWduCTQwOTYKZGV2X2l0
ZW0uaW9fd2lkdGgJNDA5NgpkZXZfaXRlbS5zZWN0b3Jfc2l6ZQk0MDk2CmRldl9pdGVtLmRldmlk
CQkxCmRldl9pdGVtLmRldl9ncm91cAkwCmRldl9pdGVtLnNlZWtfc3BlZWQJMApkZXZfaXRlbS5i
YW5kd2lkdGgJMApkZXZfaXRlbS5nZW5lcmF0aW9uCTAKc3lzX2NodW5rX2FycmF5WzIwNDhdOgoJ
aXRlbSAwIGtleSAoRklSU1RfQ0hVTktfVFJFRSBDSFVOS19JVEVNIDApCgkJbGVuZ3RoIDQxOTQz
MDQgb3duZXIgMiBzdHJpcGVfbGVuIDY1NTM2IHR5cGUgU1lTVEVNCgkJaW9fYWxpZ24gNDA5NiBp
b193aWR0aCA0MDk2IHNlY3Rvcl9zaXplIDQwOTYKCQludW1fc3RyaXBlcyAxIHN1Yl9zdHJpcGVz
IDAKCQkJc3RyaXBlIDAgZGV2aWQgMSBvZmZzZXQgMAoJCQlkZXZfdXVpZCA3YzIzMjRkYy03OTA2
LTQzMGEtYjQ0Zi1jYmZjZTNhYzVjNTYKCWl0ZW0gMSBrZXkgKEZJUlNUX0NIVU5LX1RSRUUgQ0hV
TktfSVRFTSAyMDk3MTUyMCkKCQlsZW5ndGggODM4ODYwOCBvd25lciAyIHN0cmlwZV9sZW4gNjU1
MzYgdHlwZSBTWVNURU18RFVQCgkJaW9fYWxpZ24gNjU1MzYgaW9fd2lkdGggNjU1MzYgc2VjdG9y
X3NpemUgNDA5NgoJCW51bV9zdHJpcGVzIDIgc3ViX3N0cmlwZXMgMAoJCQlzdHJpcGUgMCBkZXZp
ZCAxIG9mZnNldCAyMDk3MTUyMAoJCQlkZXZfdXVpZCA3YzIzMjRkYy03OTA2LTQzMGEtYjQ0Zi1j
YmZjZTNhYzVjNTYKCQkJc3RyaXBlIDEgZGV2aWQgMSBvZmZzZXQgMjkzNjAxMjgKCQkJZGV2X3V1
aWQgN2MyMzI0ZGMtNzkwNi00MzBhLWI0NGYtY2JmY2UzYWM1YzU2CglpdGVtIDIga2V5IChGSVJT
VF9DSFVOS19UUkVFIENIVU5LX0lURU0gMjA4MDA5NDM2ODU2MzIpCgkJbGVuZ3RoIDMzNTU0NDMy
IG93bmVyIDIgc3RyaXBlX2xlbiA2NTUzNiB0eXBlIFNZU1RFTXxEVVAKCQlpb19hbGlnbiA2NTUz
NiBpb193aWR0aCA2NTUzNiBzZWN0b3Jfc2l6ZSA0MDk2CgkJbnVtX3N0cmlwZXMgMiBzdWJfc3Ry
aXBlcyAxCgkJCXN0cmlwZSAwIGRldmlkIDEgb2Zmc2V0IDI2NjMyNTcyMTA4OAoJCQlkZXZfdXVp
ZCA3YzIzMjRkYy03OTA2LTQzMGEtYjQ0Zi1jYmZjZTNhYzVjNTYKCQkJc3RyaXBlIDEgZGV2aWQg
MSBvZmZzZXQgMjY2MzU5Mjc1NTIwCgkJCWRldl91dWlkIDdjMjMyNGRjLTc5MDYtNDMwYS1iNDRm
LWNiZmNlM2FjNWM1NgpiYWNrdXBfcm9vdHNbNF06CgliYWNrdXAgMDoKCQliYWNrdXBfdHJlZV9y
b290Ogk0NDIzNjgwMAlnZW46IDE1MTc5OAlsZXZlbDogMQoJCWJhY2t1cF9jaHVua19yb290Ogky
MDgwMDk0MzY4NTYzMglnZW46IDE1MTc3NwlsZXZlbDogMQoJCWJhY2t1cF9leHRlbnRfcm9vdDoJ
NDQzMDIzMzYJZ2VuOiAxNTE3OTgJbGV2ZWw6IDIKCQliYWNrdXBfZnNfcm9vdDoJCTE2NzM0NjE3
NglnZW46IDE1MDk3MglsZXZlbDogMAoJCWJhY2t1cF9kZXZfcm9vdDoJMjk1MjM5NjgJZ2VuOiAx
NTE3NzcJbGV2ZWw6IDEKCQliYWNrdXBfY3N1bV9yb290OgkzNzY1MDQzMglnZW46IDE1MTc3NQls
ZXZlbDogMAoJCWJhY2t1cF90b3RhbF9ieXRlczoJNzk5MTYzNzU3MzYzMgoJCWJhY2t1cF9ieXRl
c191c2VkOgk1NjMxOTkzNTA3ODQwCgkJYmFja3VwX251bV9kZXZpY2VzOgkxCgoJYmFja3VwIDE6
CgkJYmFja3VwX3RyZWVfcm9vdDoJNDQ1OTcyNDgJZ2VuOiAxNTE3OTkJbGV2ZWw6IDEKCQliYWNr
dXBfY2h1bmtfcm9vdDoJMjA4MDA5NDM2ODU2MzIJZ2VuOiAxNTE3NzcJbGV2ZWw6IDEKCQliYWNr
dXBfZXh0ZW50X3Jvb3Q6CTQ0NjMwMDE2CWdlbjogMTUxNzk5CWxldmVsOiAyCgkJYmFja3VwX2Zz
X3Jvb3Q6CQkxNjczNDYxNzYJZ2VuOiAxNTA5NzIJbGV2ZWw6IDAKCQliYWNrdXBfZGV2X3Jvb3Q6
CTI5NTIzOTY4CWdlbjogMTUxNzc3CWxldmVsOiAxCgkJYmFja3VwX2NzdW1fcm9vdDoJMzc2NTA0
MzIJZ2VuOiAxNTE3NzUJbGV2ZWw6IDAKCQliYWNrdXBfdG90YWxfYnl0ZXM6CTc5OTE2Mzc1NzM2
MzIKCQliYWNrdXBfYnl0ZXNfdXNlZDoJNTYzMTk5MzUwNzg0MAoJCWJhY2t1cF9udW1fZGV2aWNl
czoJMQoKCWJhY2t1cCAyOgoJCWJhY2t1cF90cmVlX3Jvb3Q6CTQ0OTU3Njk2CWdlbjogMTUxODAw
CWxldmVsOiAxCgkJYmFja3VwX2NodW5rX3Jvb3Q6CTIwODAwOTQzNjg1NjMyCWdlbjogMTUxNzc3
CWxldmVsOiAxCgkJYmFja3VwX2V4dGVudF9yb290Ogk0NTAyMzIzMglnZW46IDE1MTgwMAlsZXZl
bDogMgoJCWJhY2t1cF9mc19yb290OgkJMTY3MzQ2MTc2CWdlbjogMTUwOTcyCWxldmVsOiAwCgkJ
YmFja3VwX2Rldl9yb290OgkyOTUyMzk2OAlnZW46IDE1MTc3NwlsZXZlbDogMQoJCWJhY2t1cF9j
c3VtX3Jvb3Q6CTM3NjUwNDMyCWdlbjogMTUxNzc1CWxldmVsOiAwCgkJYmFja3VwX3RvdGFsX2J5
dGVzOgk3OTkxNjM3NTczNjMyCgkJYmFja3VwX2J5dGVzX3VzZWQ6CTU2MzE5OTM1MDc4NDAKCQli
YWNrdXBfbnVtX2RldmljZXM6CTEKCgliYWNrdXAgMzoKCQliYWNrdXBfdHJlZV9yb290Ogk0Mzg3
NjM1MglnZW46IDE1MTc5NwlsZXZlbDogMQoJCWJhY2t1cF9jaHVua19yb290OgkyMDgwMDk0MzY4
NTYzMglnZW46IDE1MTc3NwlsZXZlbDogMQoJCWJhY2t1cF9leHRlbnRfcm9vdDoJNDM5NDE4ODgJ
Z2VuOiAxNTE3OTcJbGV2ZWw6IDIKCQliYWNrdXBfZnNfcm9vdDoJCTE2NzM0NjE3NglnZW46IDE1
MDk3MglsZXZlbDogMAoJCWJhY2t1cF9kZXZfcm9vdDoJMjk1MjM5NjgJZ2VuOiAxNTE3NzcJbGV2
ZWw6IDEKCQliYWNrdXBfY3N1bV9yb290OgkzNzY1MDQzMglnZW46IDE1MTc3NQlsZXZlbDogMAoJ
CWJhY2t1cF90b3RhbF9ieXRlczoJNzk5MTYzNzU3MzYzMgoJCWJhY2t1cF9ieXRlc191c2VkOgk1
NjMxOTkzNTA3ODQwCgkJYmFja3VwX251bV9kZXZpY2VzOgkxCgoKc3VwZXJibG9jazogYnl0ZW5y
PTY3MTA4ODY0LCBkZXZpY2U9L2Rldi9tZDEyNwotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KY3N1bV90eXBlCQkwIChjcmMzMmMpCmNzdW1f
c2l6ZQkJNApjc3VtCQkJMHgwNTg2ZjRiYiBbbWF0Y2hdCmJ5dGVucgkJCTY3MTA4ODY0CmZsYWdz
CQkJMHgxCgkJCSggV1JJVFRFTiApCm1hZ2ljCQkJX0JIUmZTX00gW21hdGNoXQpmc2lkCQkJMjA2
MjhjZGEtZDk4Zi00Zjg1LTk1NWMtOTMyYTM2N2Y4ODIxCmxhYmVsCQkJMTFiYWVkOTI6ZGF0YQpn
ZW5lcmF0aW9uCQkxNTE4MDAKcm9vdAkJCTQ0OTU3Njk2CnN5c19hcnJheV9zaXplCQkzNTUKY2h1
bmtfcm9vdF9nZW5lcmF0aW9uCTE1MTc3Nwpyb290X2xldmVsCQkxCmNodW5rX3Jvb3QJCTIwODAw
OTQzNjg1NjMyCmNodW5rX3Jvb3RfbGV2ZWwJMQpsb2dfcm9vdAkJMApsb2dfcm9vdF90cmFuc2lk
CTAKbG9nX3Jvb3RfbGV2ZWwJCTAKdG90YWxfYnl0ZXMJCTc5OTE2Mzc1NzM2MzIKYnl0ZXNfdXNl
ZAkJNTYzMTk5MzUwNzg0MApzZWN0b3JzaXplCQk0MDk2Cm5vZGVzaXplCQkzMjc2OApsZWFmc2l6
ZSAoZGVwcmVjYXRlZCkJCTMyNzY4CnN0cmlwZXNpemUJCTQwOTYKcm9vdF9kaXIJCTYKbnVtX2Rl
dmljZXMJCTEKY29tcGF0X2ZsYWdzCQkweDAKY29tcGF0X3JvX2ZsYWdzCQkweDAKaW5jb21wYXRf
ZmxhZ3MJCTB4MjEKCQkJKCBNSVhFRF9CQUNLUkVGIHwKCQkJICBCSUdfTUVUQURBVEEgKQpjYWNo
ZV9nZW5lcmF0aW9uCTE4NDQ2NzQ0MDczNzA5NTUxNjE1CnV1aWRfdHJlZV9nZW5lcmF0aW9uCTE1
MTgwMApkZXZfaXRlbS51dWlkCQk3YzIzMjRkYy03OTA2LTQzMGEtYjQ0Zi1jYmZjZTNhYzVjNTYK
ZGV2X2l0ZW0uZnNpZAkJMjA2MjhjZGEtZDk4Zi00Zjg1LTk1NWMtOTMyYTM2N2Y4ODIxIFttYXRj
aF0KZGV2X2l0ZW0udHlwZQkJMgpkZXZfaXRlbS50b3RhbF9ieXRlcwk3OTkxNjM3NTczNjMyCmRl
dl9pdGVtLmJ5dGVzX3VzZWQJNjg2MDI0MTM3MTEzNgpkZXZfaXRlbS5pb19hbGlnbgk0MDk2CmRl
dl9pdGVtLmlvX3dpZHRoCTQwOTYKZGV2X2l0ZW0uc2VjdG9yX3NpemUJNDA5NgpkZXZfaXRlbS5k
ZXZpZAkJMQpkZXZfaXRlbS5kZXZfZ3JvdXAJMApkZXZfaXRlbS5zZWVrX3NwZWVkCTAKZGV2X2l0
ZW0uYmFuZHdpZHRoCTAKZGV2X2l0ZW0uZ2VuZXJhdGlvbgkwCnN5c19jaHVua19hcnJheVsyMDQ4
XToKCWl0ZW0gMCBrZXkgKEZJUlNUX0NIVU5LX1RSRUUgQ0hVTktfSVRFTSAwKQoJCWxlbmd0aCA0
MTk0MzA0IG93bmVyIDIgc3RyaXBlX2xlbiA2NTUzNiB0eXBlIFNZU1RFTQoJCWlvX2FsaWduIDQw
OTYgaW9fd2lkdGggNDA5NiBzZWN0b3Jfc2l6ZSA0MDk2CgkJbnVtX3N0cmlwZXMgMSBzdWJfc3Ry
aXBlcyAwCgkJCXN0cmlwZSAwIGRldmlkIDEgb2Zmc2V0IDAKCQkJZGV2X3V1aWQgN2MyMzI0ZGMt
NzkwNi00MzBhLWI0NGYtY2JmY2UzYWM1YzU2CglpdGVtIDEga2V5IChGSVJTVF9DSFVOS19UUkVF
IENIVU5LX0lURU0gMjA5NzE1MjApCgkJbGVuZ3RoIDgzODg2MDggb3duZXIgMiBzdHJpcGVfbGVu
IDY1NTM2IHR5cGUgU1lTVEVNfERVUAoJCWlvX2FsaWduIDY1NTM2IGlvX3dpZHRoIDY1NTM2IHNl
Y3Rvcl9zaXplIDQwOTYKCQludW1fc3RyaXBlcyAyIHN1Yl9zdHJpcGVzIDAKCQkJc3RyaXBlIDAg
ZGV2aWQgMSBvZmZzZXQgMjA5NzE1MjAKCQkJZGV2X3V1aWQgN2MyMzI0ZGMtNzkwNi00MzBhLWI0
NGYtY2JmY2UzYWM1YzU2CgkJCXN0cmlwZSAxIGRldmlkIDEgb2Zmc2V0IDI5MzYwMTI4CgkJCWRl
dl91dWlkIDdjMjMyNGRjLTc5MDYtNDMwYS1iNDRmLWNiZmNlM2FjNWM1NgoJaXRlbSAyIGtleSAo
RklSU1RfQ0hVTktfVFJFRSBDSFVOS19JVEVNIDIwODAwOTQzNjg1NjMyKQoJCWxlbmd0aCAzMzU1
NDQzMiBvd25lciAyIHN0cmlwZV9sZW4gNjU1MzYgdHlwZSBTWVNURU18RFVQCgkJaW9fYWxpZ24g
NjU1MzYgaW9fd2lkdGggNjU1MzYgc2VjdG9yX3NpemUgNDA5NgoJCW51bV9zdHJpcGVzIDIgc3Vi
X3N0cmlwZXMgMQoJCQlzdHJpcGUgMCBkZXZpZCAxIG9mZnNldCAyNjYzMjU3MjEwODgKCQkJZGV2
X3V1aWQgN2MyMzI0ZGMtNzkwNi00MzBhLWI0NGYtY2JmY2UzYWM1YzU2CgkJCXN0cmlwZSAxIGRl
dmlkIDEgb2Zmc2V0IDI2NjM1OTI3NTUyMAoJCQlkZXZfdXVpZCA3YzIzMjRkYy03OTA2LTQzMGEt
YjQ0Zi1jYmZjZTNhYzVjNTYKYmFja3VwX3Jvb3RzWzRdOgoJYmFja3VwIDA6CgkJYmFja3VwX3Ry
ZWVfcm9vdDoJNDQyMzY4MDAJZ2VuOiAxNTE3OTgJbGV2ZWw6IDEKCQliYWNrdXBfY2h1bmtfcm9v
dDoJMjA4MDA5NDM2ODU2MzIJZ2VuOiAxNTE3NzcJbGV2ZWw6IDEKCQliYWNrdXBfZXh0ZW50X3Jv
b3Q6CTQ0MzAyMzM2CWdlbjogMTUxNzk4CWxldmVsOiAyCgkJYmFja3VwX2ZzX3Jvb3Q6CQkxNjcz
NDYxNzYJZ2VuOiAxNTA5NzIJbGV2ZWw6IDAKCQliYWNrdXBfZGV2X3Jvb3Q6CTI5NTIzOTY4CWdl
bjogMTUxNzc3CWxldmVsOiAxCgkJYmFja3VwX2NzdW1fcm9vdDoJMzc2NTA0MzIJZ2VuOiAxNTE3
NzUJbGV2ZWw6IDAKCQliYWNrdXBfdG90YWxfYnl0ZXM6CTc5OTE2Mzc1NzM2MzIKCQliYWNrdXBf
Ynl0ZXNfdXNlZDoJNTYzMTk5MzUwNzg0MAoJCWJhY2t1cF9udW1fZGV2aWNlczoJMQoKCWJhY2t1
cCAxOgoJCWJhY2t1cF90cmVlX3Jvb3Q6CTQ0NTk3MjQ4CWdlbjogMTUxNzk5CWxldmVsOiAxCgkJ
YmFja3VwX2NodW5rX3Jvb3Q6CTIwODAwOTQzNjg1NjMyCWdlbjogMTUxNzc3CWxldmVsOiAxCgkJ
YmFja3VwX2V4dGVudF9yb290Ogk0NDYzMDAxNglnZW46IDE1MTc5OQlsZXZlbDogMgoJCWJhY2t1
cF9mc19yb290OgkJMTY3MzQ2MTc2CWdlbjogMTUwOTcyCWxldmVsOiAwCgkJYmFja3VwX2Rldl9y
b290OgkyOTUyMzk2OAlnZW46IDE1MTc3NwlsZXZlbDogMQoJCWJhY2t1cF9jc3VtX3Jvb3Q6CTM3
NjUwNDMyCWdlbjogMTUxNzc1CWxldmVsOiAwCgkJYmFja3VwX3RvdGFsX2J5dGVzOgk3OTkxNjM3
NTczNjMyCgkJYmFja3VwX2J5dGVzX3VzZWQ6CTU2MzE5OTM1MDc4NDAKCQliYWNrdXBfbnVtX2Rl
dmljZXM6CTEKCgliYWNrdXAgMjoKCQliYWNrdXBfdHJlZV9yb290Ogk0NDk1NzY5NglnZW46IDE1
MTgwMAlsZXZlbDogMQoJCWJhY2t1cF9jaHVua19yb290OgkyMDgwMDk0MzY4NTYzMglnZW46IDE1
MTc3NwlsZXZlbDogMQoJCWJhY2t1cF9leHRlbnRfcm9vdDoJNDUwMjMyMzIJZ2VuOiAxNTE4MDAJ
bGV2ZWw6IDIKCQliYWNrdXBfZnNfcm9vdDoJCTE2NzM0NjE3NglnZW46IDE1MDk3MglsZXZlbDog
MAoJCWJhY2t1cF9kZXZfcm9vdDoJMjk1MjM5NjgJZ2VuOiAxNTE3NzcJbGV2ZWw6IDEKCQliYWNr
dXBfY3N1bV9yb290OgkzNzY1MDQzMglnZW46IDE1MTc3NQlsZXZlbDogMAoJCWJhY2t1cF90b3Rh
bF9ieXRlczoJNzk5MTYzNzU3MzYzMgoJCWJhY2t1cF9ieXRlc191c2VkOgk1NjMxOTkzNTA3ODQw
CgkJYmFja3VwX251bV9kZXZpY2VzOgkxCgoJYmFja3VwIDM6CgkJYmFja3VwX3RyZWVfcm9vdDoJ
NDM4NzYzNTIJZ2VuOiAxNTE3OTcJbGV2ZWw6IDEKCQliYWNrdXBfY2h1bmtfcm9vdDoJMjA4MDA5
NDM2ODU2MzIJZ2VuOiAxNTE3NzcJbGV2ZWw6IDEKCQliYWNrdXBfZXh0ZW50X3Jvb3Q6CTQzOTQx
ODg4CWdlbjogMTUxNzk3CWxldmVsOiAyCgkJYmFja3VwX2ZzX3Jvb3Q6CQkxNjczNDYxNzYJZ2Vu
OiAxNTA5NzIJbGV2ZWw6IDAKCQliYWNrdXBfZGV2X3Jvb3Q6CTI5NTIzOTY4CWdlbjogMTUxNzc3
CWxldmVsOiAxCgkJYmFja3VwX2NzdW1fcm9vdDoJMzc2NTA0MzIJZ2VuOiAxNTE3NzUJbGV2ZWw6
IDAKCQliYWNrdXBfdG90YWxfYnl0ZXM6CTc5OTE2Mzc1NzM2MzIKCQliYWNrdXBfYnl0ZXNfdXNl
ZDoJNTYzMTk5MzUwNzg0MAoJCWJhY2t1cF9udW1fZGV2aWNlczoJMQoKCnN1cGVyYmxvY2s6IGJ5
dGVucj0yNzQ4Nzc5MDY5NDQsIGRldmljZT0vZGV2L21kMTI3Ci0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQpjc3VtX3R5cGUJCTAgKGNyYzMy
YykKY3N1bV9zaXplCQk0CmNzdW0JCQkweGY4MDFhMjhhIFttYXRjaF0KYnl0ZW5yCQkJMjc0ODc3
OTA2OTQ0CmZsYWdzCQkJMHgxCgkJCSggV1JJVFRFTiApCm1hZ2ljCQkJX0JIUmZTX00gW21hdGNo
XQpmc2lkCQkJMjA2MjhjZGEtZDk4Zi00Zjg1LTk1NWMtOTMyYTM2N2Y4ODIxCmxhYmVsCQkJMTFi
YWVkOTI6ZGF0YQpnZW5lcmF0aW9uCQkxNTE4MDAKcm9vdAkJCTQ0OTU3Njk2CnN5c19hcnJheV9z
aXplCQkzNTUKY2h1bmtfcm9vdF9nZW5lcmF0aW9uCTE1MTc3Nwpyb290X2xldmVsCQkxCmNodW5r
X3Jvb3QJCTIwODAwOTQzNjg1NjMyCmNodW5rX3Jvb3RfbGV2ZWwJMQpsb2dfcm9vdAkJMApsb2df
cm9vdF90cmFuc2lkCTAKbG9nX3Jvb3RfbGV2ZWwJCTAKdG90YWxfYnl0ZXMJCTc5OTE2Mzc1NzM2
MzIKYnl0ZXNfdXNlZAkJNTYzMTk5MzUwNzg0MApzZWN0b3JzaXplCQk0MDk2Cm5vZGVzaXplCQkz
Mjc2OApsZWFmc2l6ZSAoZGVwcmVjYXRlZCkJCTMyNzY4CnN0cmlwZXNpemUJCTQwOTYKcm9vdF9k
aXIJCTYKbnVtX2RldmljZXMJCTEKY29tcGF0X2ZsYWdzCQkweDAKY29tcGF0X3JvX2ZsYWdzCQkw
eDAKaW5jb21wYXRfZmxhZ3MJCTB4MjEKCQkJKCBNSVhFRF9CQUNLUkVGIHwKCQkJICBCSUdfTUVU
QURBVEEgKQpjYWNoZV9nZW5lcmF0aW9uCTE4NDQ2NzQ0MDczNzA5NTUxNjE1CnV1aWRfdHJlZV9n
ZW5lcmF0aW9uCTE1MTgwMApkZXZfaXRlbS51dWlkCQk3YzIzMjRkYy03OTA2LTQzMGEtYjQ0Zi1j
YmZjZTNhYzVjNTYKZGV2X2l0ZW0uZnNpZAkJMjA2MjhjZGEtZDk4Zi00Zjg1LTk1NWMtOTMyYTM2
N2Y4ODIxIFttYXRjaF0KZGV2X2l0ZW0udHlwZQkJMgpkZXZfaXRlbS50b3RhbF9ieXRlcwk3OTkx
NjM3NTczNjMyCmRldl9pdGVtLmJ5dGVzX3VzZWQJNjg2MDI0MTM3MTEzNgpkZXZfaXRlbS5pb19h
bGlnbgk0MDk2CmRldl9pdGVtLmlvX3dpZHRoCTQwOTYKZGV2X2l0ZW0uc2VjdG9yX3NpemUJNDA5
NgpkZXZfaXRlbS5kZXZpZAkJMQpkZXZfaXRlbS5kZXZfZ3JvdXAJMApkZXZfaXRlbS5zZWVrX3Nw
ZWVkCTAKZGV2X2l0ZW0uYmFuZHdpZHRoCTAKZGV2X2l0ZW0uZ2VuZXJhdGlvbgkwCnN5c19jaHVu
a19hcnJheVsyMDQ4XToKCWl0ZW0gMCBrZXkgKEZJUlNUX0NIVU5LX1RSRUUgQ0hVTktfSVRFTSAw
KQoJCWxlbmd0aCA0MTk0MzA0IG93bmVyIDIgc3RyaXBlX2xlbiA2NTUzNiB0eXBlIFNZU1RFTQoJ
CWlvX2FsaWduIDQwOTYgaW9fd2lkdGggNDA5NiBzZWN0b3Jfc2l6ZSA0MDk2CgkJbnVtX3N0cmlw
ZXMgMSBzdWJfc3RyaXBlcyAwCgkJCXN0cmlwZSAwIGRldmlkIDEgb2Zmc2V0IDAKCQkJZGV2X3V1
aWQgN2MyMzI0ZGMtNzkwNi00MzBhLWI0NGYtY2JmY2UzYWM1YzU2CglpdGVtIDEga2V5IChGSVJT
VF9DSFVOS19UUkVFIENIVU5LX0lURU0gMjA5NzE1MjApCgkJbGVuZ3RoIDgzODg2MDggb3duZXIg
MiBzdHJpcGVfbGVuIDY1NTM2IHR5cGUgU1lTVEVNfERVUAoJCWlvX2FsaWduIDY1NTM2IGlvX3dp
ZHRoIDY1NTM2IHNlY3Rvcl9zaXplIDQwOTYKCQludW1fc3RyaXBlcyAyIHN1Yl9zdHJpcGVzIDAK
CQkJc3RyaXBlIDAgZGV2aWQgMSBvZmZzZXQgMjA5NzE1MjAKCQkJZGV2X3V1aWQgN2MyMzI0ZGMt
NzkwNi00MzBhLWI0NGYtY2JmY2UzYWM1YzU2CgkJCXN0cmlwZSAxIGRldmlkIDEgb2Zmc2V0IDI5
MzYwMTI4CgkJCWRldl91dWlkIDdjMjMyNGRjLTc5MDYtNDMwYS1iNDRmLWNiZmNlM2FjNWM1NgoJ
aXRlbSAyIGtleSAoRklSU1RfQ0hVTktfVFJFRSBDSFVOS19JVEVNIDIwODAwOTQzNjg1NjMyKQoJ
CWxlbmd0aCAzMzU1NDQzMiBvd25lciAyIHN0cmlwZV9sZW4gNjU1MzYgdHlwZSBTWVNURU18RFVQ
CgkJaW9fYWxpZ24gNjU1MzYgaW9fd2lkdGggNjU1MzYgc2VjdG9yX3NpemUgNDA5NgoJCW51bV9z
dHJpcGVzIDIgc3ViX3N0cmlwZXMgMQoJCQlzdHJpcGUgMCBkZXZpZCAxIG9mZnNldCAyNjYzMjU3
MjEwODgKCQkJZGV2X3V1aWQgN2MyMzI0ZGMtNzkwNi00MzBhLWI0NGYtY2JmY2UzYWM1YzU2CgkJ
CXN0cmlwZSAxIGRldmlkIDEgb2Zmc2V0IDI2NjM1OTI3NTUyMAoJCQlkZXZfdXVpZCA3YzIzMjRk
Yy03OTA2LTQzMGEtYjQ0Zi1jYmZjZTNhYzVjNTYKYmFja3VwX3Jvb3RzWzRdOgoJYmFja3VwIDA6
CgkJYmFja3VwX3RyZWVfcm9vdDoJNDQyMzY4MDAJZ2VuOiAxNTE3OTgJbGV2ZWw6IDEKCQliYWNr
dXBfY2h1bmtfcm9vdDoJMjA4MDA5NDM2ODU2MzIJZ2VuOiAxNTE3NzcJbGV2ZWw6IDEKCQliYWNr
dXBfZXh0ZW50X3Jvb3Q6CTQ0MzAyMzM2CWdlbjogMTUxNzk4CWxldmVsOiAyCgkJYmFja3VwX2Zz
X3Jvb3Q6CQkxNjczNDYxNzYJZ2VuOiAxNTA5NzIJbGV2ZWw6IDAKCQliYWNrdXBfZGV2X3Jvb3Q6
CTI5NTIzOTY4CWdlbjogMTUxNzc3CWxldmVsOiAxCgkJYmFja3VwX2NzdW1fcm9vdDoJMzc2NTA0
MzIJZ2VuOiAxNTE3NzUJbGV2ZWw6IDAKCQliYWNrdXBfdG90YWxfYnl0ZXM6CTc5OTE2Mzc1NzM2
MzIKCQliYWNrdXBfYnl0ZXNfdXNlZDoJNTYzMTk5MzUwNzg0MAoJCWJhY2t1cF9udW1fZGV2aWNl
czoJMQoKCWJhY2t1cCAxOgoJCWJhY2t1cF90cmVlX3Jvb3Q6CTQ0NTk3MjQ4CWdlbjogMTUxNzk5
CWxldmVsOiAxCgkJYmFja3VwX2NodW5rX3Jvb3Q6CTIwODAwOTQzNjg1NjMyCWdlbjogMTUxNzc3
CWxldmVsOiAxCgkJYmFja3VwX2V4dGVudF9yb290Ogk0NDYzMDAxNglnZW46IDE1MTc5OQlsZXZl
bDogMgoJCWJhY2t1cF9mc19yb290OgkJMTY3MzQ2MTc2CWdlbjogMTUwOTcyCWxldmVsOiAwCgkJ
YmFja3VwX2Rldl9yb290OgkyOTUyMzk2OAlnZW46IDE1MTc3NwlsZXZlbDogMQoJCWJhY2t1cF9j
c3VtX3Jvb3Q6CTM3NjUwNDMyCWdlbjogMTUxNzc1CWxldmVsOiAwCgkJYmFja3VwX3RvdGFsX2J5
dGVzOgk3OTkxNjM3NTczNjMyCgkJYmFja3VwX2J5dGVzX3VzZWQ6CTU2MzE5OTM1MDc4NDAKCQli
YWNrdXBfbnVtX2RldmljZXM6CTEKCgliYWNrdXAgMjoKCQliYWNrdXBfdHJlZV9yb290Ogk0NDk1
NzY5NglnZW46IDE1MTgwMAlsZXZlbDogMQoJCWJhY2t1cF9jaHVua19yb290OgkyMDgwMDk0MzY4
NTYzMglnZW46IDE1MTc3NwlsZXZlbDogMQoJCWJhY2t1cF9leHRlbnRfcm9vdDoJNDUwMjMyMzIJ
Z2VuOiAxNTE4MDAJbGV2ZWw6IDIKCQliYWNrdXBfZnNfcm9vdDoJCTE2NzM0NjE3NglnZW46IDE1
MDk3MglsZXZlbDogMAoJCWJhY2t1cF9kZXZfcm9vdDoJMjk1MjM5NjgJZ2VuOiAxNTE3NzcJbGV2
ZWw6IDEKCQliYWNrdXBfY3N1bV9yb290OgkzNzY1MDQzMglnZW46IDE1MTc3NQlsZXZlbDogMAoJ
CWJhY2t1cF90b3RhbF9ieXRlczoJNzk5MTYzNzU3MzYzMgoJCWJhY2t1cF9ieXRlc191c2VkOgk1
NjMxOTkzNTA3ODQwCgkJYmFja3VwX251bV9kZXZpY2VzOgkxCgoJYmFja3VwIDM6CgkJYmFja3Vw
X3RyZWVfcm9vdDoJNDM4NzYzNTIJZ2VuOiAxNTE3OTcJbGV2ZWw6IDEKCQliYWNrdXBfY2h1bmtf
cm9vdDoJMjA4MDA5NDM2ODU2MzIJZ2VuOiAxNTE3NzcJbGV2ZWw6IDEKCQliYWNrdXBfZXh0ZW50
X3Jvb3Q6CTQzOTQxODg4CWdlbjogMTUxNzk3CWxldmVsOiAyCgkJYmFja3VwX2ZzX3Jvb3Q6CQkx
NjczNDYxNzYJZ2VuOiAxNTA5NzIJbGV2ZWw6IDAKCQliYWNrdXBfZGV2X3Jvb3Q6CTI5NTIzOTY4
CWdlbjogMTUxNzc3CWxldmVsOiAxCgkJYmFja3VwX2NzdW1fcm9vdDoJMzc2NTA0MzIJZ2VuOiAx
NTE3NzUJbGV2ZWw6IDAKCQliYWNrdXBfdG90YWxfYnl0ZXM6CTc5OTE2Mzc1NzM2MzIKCQliYWNr
dXBfYnl0ZXNfdXNlZDoJNTYzMTk5MzUwNzg0MAoJCWJhY2t1cF9udW1fZGV2aWNlczoJMQo=
--000000000000ae4c98056ae55dc0--
