Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:53201 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750938AbeD3DCY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 29 Apr 2018 23:02:24 -0400
Subject: Re: BTRFS RAID filesystem unmountable
To: Michael Wade <spikewade@gmail.com>
Cc: linux-btrfs@vger.kernel.org
References: <CAB+znrFyimDnOZt46CqterRJ6MvwD4TSWagQvv-oQxjPvG-m2w@mail.gmail.com>
 <54d2f70a-adae-98cc-581f-2e4786783b26@gmx.com>
 <CAB+znrHYrhBB4cstUaS3KcOfEHhOTPUsfAJKj3Cj62HJ-05FrQ@mail.gmail.com>
 <d32f3fdc-5ba0-2b62-ce79-5e5665d4c960@gmx.com>
 <CAB+znrF_d+Hg_A9AMvWEB=S5eVAtYrvr2jUPcvR4FfB4hnCMWA@mail.gmail.com>
 <bff1c7b3-5bac-9806-a376-3612057865cf@gmx.com>
 <CAB+znrHPF7963-MAXtgu8s3+vLEA7ENE0=uCCJ6sWCF6KUWToQ@mail.gmail.com>
 <bb0df6b1-3780-8ea5-b48e-e82f65a68f60@gmx.com>
 <CAB+znrEcW3+++ZBrB_ZGRFncssO-zffbJ6ug8_z0DJOhbp+vGA@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <f9694e69-ca47-57cd-3afb-2279bb79467a@gmx.com>
Date: Mon, 30 Apr 2018 11:02:17 +0800
MIME-Version: 1.0
In-Reply-To: <CAB+znrEcW3+++ZBrB_ZGRFncssO-zffbJ6ug8_z0DJOhbp+vGA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="2x3x3E2TwY2e5XAy9PJA80R0xPTkAiWCe"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2x3x3E2TwY2e5XAy9PJA80R0xPTkAiWCe
Content-Type: multipart/mixed; boundary="C1eI1Xc5ENdUY0JG4ufy4iReEYDDJh1RA";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Michael Wade <spikewade@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <f9694e69-ca47-57cd-3afb-2279bb79467a@gmx.com>
Subject: Re: BTRFS RAID filesystem unmountable
References: <CAB+znrFyimDnOZt46CqterRJ6MvwD4TSWagQvv-oQxjPvG-m2w@mail.gmail.com>
 <54d2f70a-adae-98cc-581f-2e4786783b26@gmx.com>
 <CAB+znrHYrhBB4cstUaS3KcOfEHhOTPUsfAJKj3Cj62HJ-05FrQ@mail.gmail.com>
 <d32f3fdc-5ba0-2b62-ce79-5e5665d4c960@gmx.com>
 <CAB+znrF_d+Hg_A9AMvWEB=S5eVAtYrvr2jUPcvR4FfB4hnCMWA@mail.gmail.com>
 <bff1c7b3-5bac-9806-a376-3612057865cf@gmx.com>
 <CAB+znrHPF7963-MAXtgu8s3+vLEA7ENE0=uCCJ6sWCF6KUWToQ@mail.gmail.com>
 <bb0df6b1-3780-8ea5-b48e-e82f65a68f60@gmx.com>
 <CAB+znrEcW3+++ZBrB_ZGRFncssO-zffbJ6ug8_z0DJOhbp+vGA@mail.gmail.com>
In-Reply-To: <CAB+znrEcW3+++ZBrB_ZGRFncssO-zffbJ6ug8_z0DJOhbp+vGA@mail.gmail.com>

--C1eI1Xc5ENdUY0JG4ufy4iReEYDDJh1RA
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B404=E6=9C=8829=E6=97=A5 22:08, Michael Wade wrote:
> Hi Qu,
>=20
> Got this error message:
>=20
> ./btrfs inspect dump-tree -b 20800943685632 /dev/md127
> btrfs-progs v4.16.1
> bytenr mismatch, want=3D20800943685632, have=3D3118598835113619663
> ERROR: cannot read chunk root
> ERROR: unable to open /dev/md127
>=20
> I have attached the dumps for:
>=20
> dd if=3D/dev/md127 of=3D/tmp/chunk_root.copy1 bs=3D1 count=3D32K skip=3D=
266325721088
> dd if=3D/dev/md127 of=3D/tmp/chunk_root.copy2 bs=3D1 count=3D32K skip=3D=
266359275520

Unfortunately, both dumps are corrupted and contain mostly garbage.
I think it's the underlying stack (mdraid) has something wrong or failed
to recover its data.

This means your last chance will be btrfs-find-root.

Please try:
# btrfs-find-root -o 3 <device>

And provide all the output.

But please keep in mind, chunk root is a critical tree, and so far it's
already heavily damaged.
Although I could still continue try to recover, there is pretty low
chance now.

Thanks,
Qu
>=20
> Kind regards
> Michael
>=20
>=20
> On 29 April 2018 at 10:33, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>
>>
>> On 2018=E5=B9=B404=E6=9C=8829=E6=97=A5 16:59, Michael Wade wrote:
>>> Ok, will it be possible for me to install the new version of the tool=
s
>>> on my current kernel without overriding the existing install? Hesitan=
t
>>> to update kernel/btrfs as it might break the ReadyNAS interface /
>>> future firmware upgrades.
>>>
>>> Perhaps I could grab this:
>>> https://github.com/kdave/btrfs-progs/releases/tag/v4.16.1 and
>>> hopefully build from source and then run the binaries directly?
>>
>> Of course, that's how most of us test btrfs-progs builds.
>>
>> Thanks,
>> Qu
>>
>>>
>>> Kind regards
>>>
>>> On 29 April 2018 at 09:33, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>>>
>>>>
>>>> On 2018=E5=B9=B404=E6=9C=8829=E6=97=A5 16:11, Michael Wade wrote:
>>>>> Thanks Qu,
>>>>>
>>>>> Please find attached the log file for the chunk recover command.
>>>>
>>>> Strangely, btrfs chunk recovery found no extra chunk beyond current
>>>> system chunk range.
>>>>
>>>> Which means, it's chunk tree corrupted.
>>>>
>>>> Please dump the chunk tree with latest btrfs-progs (which provides t=
he
>>>> new --follow option).
>>>>
>>>> # btrfs inspect dump-tree -b 20800943685632 <device>
>>>>
>>>> If it doesn't work, please provide the following binary dump:
>>>>
>>>> # dd if=3D<dev> of=3D/tmp/chunk_root.copy1 bs=3D1 count=3D32K skip=3D=
266325721088
>>>> # dd if=3D<dev> of=3D/tmp/chunk_root.copy2 bs=3D1 count=3D32K skip=3D=
266359275520
>>>> (And will need to repeat similar dump for several times according to=

>>>> above dump)
>>>>
>>>> Thanks,
>>>> Qu
>>>>
>>>>
>>>>>
>>>>> Kind regards
>>>>> Michael
>>>>>
>>>>> On 28 April 2018 at 12:38, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote=
:
>>>>>>
>>>>>>
>>>>>> On 2018=E5=B9=B404=E6=9C=8828=E6=97=A5 17:37, Michael Wade wrote:
>>>>>>> Hi Qu,
>>>>>>>
>>>>>>> Thanks for your reply. I will investigate upgrading the kernel,
>>>>>>> however I worry that future ReadyNAS firmware upgrades would fail=
 on a
>>>>>>> newer kernel version (I don't have much linux experience so maybe=
 my
>>>>>>> concerns are unfounded!?).
>>>>>>>
>>>>>>> I have attached the output of the dump super command.
>>>>>>>
>>>>>>> I did actually run chunk recover before, without the verbose opti=
on,
>>>>>>> it took around 24 hours to finish but did not resolve my issue. H=
appy
>>>>>>> to start that again if you need its output.
>>>>>>
>>>>>> The system chunk only contains the following chunks:
>>>>>> [0, 4194304]:           Initial temporary chunk, not used at all
>>>>>> [20971520, 29360128]:   System chunk created by mkfs, should be fu=
ll
>>>>>>                         used up
>>>>>> [20800943685632, 20800977240064]:
>>>>>>                         The newly created large system chunk.
>>>>>>
>>>>>> The chunk root is still in 2nd chunk thus valid, but some of its l=
eaf is
>>>>>> out of the range.
>>>>>>
>>>>>> If you can't wait 24h for chunk recovery to run, my advice would b=
e move
>>>>>> the disk to some other computer, and use latest btrfs-progs to exe=
cute
>>>>>> the following command:
>>>>>>
>>>>>> # btrfs inpsect dump-tree -b 20800943685632 --follow
>>>>>>
>>>>>> If we're lucky enough, we may read out the tree leaf containing th=
e new
>>>>>> system chunk and save a day.
>>>>>>
>>>>>> Thanks,
>>>>>> Qu
>>>>>>
>>>>>>>
>>>>>>> Thanks so much for your help.
>>>>>>>
>>>>>>> Kind regards
>>>>>>> Michael
>>>>>>>
>>>>>>> On 28 April 2018 at 09:45, Qu Wenruo <quwenruo.btrfs@gmx.com> wro=
te:
>>>>>>>>
>>>>>>>>
>>>>>>>> On 2018=E5=B9=B404=E6=9C=8828=E6=97=A5 16:30, Michael Wade wrote=
:
>>>>>>>>> Hi all,
>>>>>>>>>
>>>>>>>>> I was hoping that someone would be able to help me resolve the =
issues
>>>>>>>>> I am having with my ReadyNAS BTRFS volume. Basically my trouble=

>>>>>>>>> started after a power cut, subsequently the volume would not mo=
unt.
>>>>>>>>> Here are the details of my setup as it is at the moment:
>>>>>>>>>
>>>>>>>>> uname -a
>>>>>>>>> Linux QAI 4.4.116.alpine.1 #1 SMP Mon Feb 19 21:58:38 PST 2018 =
armv7l GNU/Linux
>>>>>>>>
>>>>>>>> The kernel is pretty old for btrfs.
>>>>>>>> Strongly recommended to upgrade.
>>>>>>>>
>>>>>>>>>
>>>>>>>>> btrfs --version
>>>>>>>>> btrfs-progs v4.12
>>>>>>>>
>>>>>>>> So is the user tools.
>>>>>>>>
>>>>>>>> Although I think it won't be a big problem, as needed tool shoul=
d be there.
>>>>>>>>
>>>>>>>>>
>>>>>>>>> btrfs fi show
>>>>>>>>> Label: '11baed92:data'  uuid: 20628cda-d98f-4f85-955c-932a367f8=
821
>>>>>>>>> Total devices 1 FS bytes used 5.12TiB
>>>>>>>>> devid    1 size 7.27TiB used 6.24TiB path /dev/md127
>>>>>>>>
>>>>>>>> So, it's btrfs on mdraid.
>>>>>>>> It would normally make things harder to debug, so I could only p=
rovide
>>>>>>>> advice from the respect of btrfs.
>>>>>>>> For mdraid part, I can't ensure anything.
>>>>>>>>
>>>>>>>>>
>>>>>>>>> Here are the relevant dmesg logs for the current state of the d=
evice:
>>>>>>>>>
>>>>>>>>> [   19.119391] md: md127 stopped.
>>>>>>>>> [   19.120841] md: bind<sdb3>
>>>>>>>>> [   19.121120] md: bind<sdc3>
>>>>>>>>> [   19.121380] md: bind<sda3>
>>>>>>>>> [   19.125535] md/raid:md127: device sda3 operational as raid d=
isk 0
>>>>>>>>> [   19.125547] md/raid:md127: device sdc3 operational as raid d=
isk 2
>>>>>>>>> [   19.125554] md/raid:md127: device sdb3 operational as raid d=
isk 1
>>>>>>>>> [   19.126712] md/raid:md127: allocated 3240kB
>>>>>>>>> [   19.126778] md/raid:md127: raid level 5 active with 3 out of=
 3
>>>>>>>>> devices, algorithm 2
>>>>>>>>> [   19.126784] RAID conf printout:
>>>>>>>>> [   19.126789]  --- level:5 rd:3 wd:3
>>>>>>>>> [   19.126794]  disk 0, o:1, dev:sda3
>>>>>>>>> [   19.126799]  disk 1, o:1, dev:sdb3
>>>>>>>>> [   19.126804]  disk 2, o:1, dev:sdc3
>>>>>>>>> [   19.128118] md127: detected capacity change from 0 to 799163=
7573632
>>>>>>>>> [   19.395112] Adding 523708k swap on /dev/md1.  Priority:-1 ex=
tents:1
>>>>>>>>> across:523708k
>>>>>>>>> [   19.434956] BTRFS: device label 11baed92:data devid 1 transi=
d
>>>>>>>>> 151800 /dev/md127
>>>>>>>>> [   19.739276] BTRFS info (device md127): setting nodatasum
>>>>>>>>> [   19.740440] BTRFS critical (device md127): unable to find lo=
gical
>>>>>>>>> 3208757641216 len 4096
>>>>>>>>> [   19.740450] BTRFS critical (device md127): unable to find lo=
gical
>>>>>>>>> 3208757641216 len 4096
>>>>>>>>> [   19.740498] BTRFS critical (device md127): unable to find lo=
gical
>>>>>>>>> 3208757641216 len 4096
>>>>>>>>> [   19.740512] BTRFS critical (device md127): unable to find lo=
gical
>>>>>>>>> 3208757641216 len 4096
>>>>>>>>> [   19.740552] BTRFS critical (device md127): unable to find lo=
gical
>>>>>>>>> 3208757641216 len 4096
>>>>>>>>> [   19.740560] BTRFS critical (device md127): unable to find lo=
gical
>>>>>>>>> 3208757641216 len 4096
>>>>>>>>> [   19.740576] BTRFS error (device md127): failed to read chunk=
 root
>>>>>>>>
>>>>>>>> This shows it pretty clear, btrfs fails to read chunk root.
>>>>>>>> And according your above "len 4096" it's pretty old fs, as it's =
still
>>>>>>>> using 4K nodesize other than 16K nodesize.
>>>>>>>>
>>>>>>>> According to above output, it means your superblock by somehow l=
acks the
>>>>>>>> needed system chunk mapping, which is used to initialize chunk m=
apping.
>>>>>>>>
>>>>>>>> Please provide the following command output:
>>>>>>>>
>>>>>>>> # btrfs inspect dump-super -fFa /dev/md127
>>>>>>>>
>>>>>>>> Also, please consider run the following command and dump all its=
 output:
>>>>>>>>
>>>>>>>> # btrfs rescue chunk-recover -v /dev/md127.
>>>>>>>>
>>>>>>>> Please note that, above command can take a long time to finish, =
and if
>>>>>>>> it works without problem, it may solve your problem.
>>>>>>>> But if it doesn't work, the output could help me to manually cra=
ft a fix
>>>>>>>> to your super block.
>>>>>>>>
>>>>>>>> Thanks,
>>>>>>>> Qu
>>>>>>>>
>>>>>>>>
>>>>>>>>> [   19.783975] BTRFS error (device md127): open_ctree failed
>>>>>>>>>
>>>>>>>>> In an attempt to recover the volume myself I run a few BTRFS co=
mmands
>>>>>>>>> mostly using advice from here:
>>>>>>>>> https://lists.opensuse.org/opensuse/2017-02/msg00930.html. Howe=
ver
>>>>>>>>> that actually seems to have made things worse as I can no longe=
r mount
>>>>>>>>> the file system, not even in readonly mode.
>>>>>>>>>
>>>>>>>>> So starting from the beginning here is a list of things I have =
done so
>>>>>>>>> far (hopefully I remembered the order in which I ran them!)
>>>>>>>>>
>>>>>>>>> 1. Noticed that my backups to the NAS were not running (didn't =
get
>>>>>>>>> notified that the volume had basically "died")
>>>>>>>>> 2. ReadyNAS UI indicated that the volume was inactive.
>>>>>>>>> 3. SSHed onto the box and found that the first drive was not ma=
rked as
>>>>>>>>> operational (log showed I/O errors / UNKOWN (0x2003))  so I rep=
laced
>>>>>>>>> the disk and let the array resync.
>>>>>>>>> 4. After resync the volume still was unaccessible so I looked a=
t the
>>>>>>>>> logs once more and saw something like the following which seeme=
d to
>>>>>>>>> indicate that the replay log had been corrupted when the power =
went
>>>>>>>>> out:
>>>>>>>>>
>>>>>>>>> BTRFS critical (device md127): corrupt leaf, non-root leaf's nr=
items
>>>>>>>>> is 0: block=3D232292352, root=3D7, slot=3D0
>>>>>>>>> BTRFS critical (device md127): corrupt leaf, non-root leaf's nr=
items
>>>>>>>>> is 0: block=3D232292352, root=3D7, slot=3D0
>>>>>>>>> BTRFS: error (device md127) in btrfs_replay_log:2524: errno=3D-=
5 IO
>>>>>>>>> failure (Failed to recover log tree)
>>>>>>>>> BTRFS error (device md127): pending csums is 155648
>>>>>>>>> BTRFS error (device md127): cleaner transaction attach returned=
 -30
>>>>>>>>> BTRFS critical (device md127): corrupt leaf, non-root leaf's nr=
items
>>>>>>>>> is 0: block=3D232292352, root=3D7, slot=3D0
>>>>>>>>>
>>>>>>>>> 5. Then:
>>>>>>>>>
>>>>>>>>> btrfs rescue zero-log
>>>>>>>>>
>>>>>>>>> 6. Was then able to mount the volume in readonly mode.
>>>>>>>>>
>>>>>>>>> btrfs scrub start
>>>>>>>>>
>>>>>>>>> Which fixed some errors but not all:
>>>>>>>>>
>>>>>>>>> scrub status for 20628cda-d98f-4f85-955c-932a367f8821
>>>>>>>>>
>>>>>>>>> scrub started at Tue Apr 24 17:27:44 2018, running for 04:00:34=

>>>>>>>>> total bytes scrubbed: 224.26GiB with 6 errors
>>>>>>>>> error details: csum=3D6
>>>>>>>>> corrected errors: 0, uncorrectable errors: 6, unverified errors=
: 0
>>>>>>>>>
>>>>>>>>> scrub status for 20628cda-d98f-4f85-955c-932a367f8821
>>>>>>>>> scrub started at Tue Apr 24 17:27:44 2018, running for 04:34:43=

>>>>>>>>> total bytes scrubbed: 224.26GiB with 6 errors
>>>>>>>>> error details: csum=3D6
>>>>>>>>> corrected errors: 0, uncorrectable errors: 6, unverified errors=
: 0
>>>>>>>>>
>>>>>>>>> 6. Seeing this hanging I rebooted the NAS
>>>>>>>>> 7. Think this is when the volume would not mount at all.
>>>>>>>>> 8. Seeing log entries like these:
>>>>>>>>>
>>>>>>>>> BTRFS warning (device md127): checksum error at logical 2080094=
3685632
>>>>>>>>> on dev /dev/md127, sector 520167424: metadata node (level 1) in=
 tree 3
>>>>>>>>>
>>>>>>>>> I ran
>>>>>>>>>
>>>>>>>>> btrfs check --fix-crc
>>>>>>>>>
>>>>>>>>> And that brings us to where I am now: Some seemly corrupted BTR=
FS
>>>>>>>>> metadata and unable to mount the drive even with the recovery o=
ption.
>>>>>>>>>
>>>>>>>>> Any help you can give is much appreciated!
>>>>>>>>>
>>>>>>>>> Kind regards
>>>>>>>>> Michael
>>>>>>>>> --
>>>>>>>>> To unsubscribe from this list: send the line "unsubscribe linux=
-btrfs" in
>>>>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.h=
tml
>>>>>>>>>
>>>>>>>>
>>>>>>
>>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>


--C1eI1Xc5ENdUY0JG4ufy4iReEYDDJh1RA--

--2x3x3E2TwY2e5XAy9PJA80R0xPTkAiWCe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlrmhzkACgkQwj2R86El
/qhcxAgAmEEMfMUzT9s/yXM0sfZl6MkWrlxvO6202stqYwOeYdSvOJH+vL6XPi2C
2bf0PeL4IHrsOWQPMid2LXW+e2/QdOYFhg6EvJEjZhoG6MHnFkEAYFgpyoTvJ2Lp
nTNitSjeMJNTCXEPC5dnjGdr+ASOLf25yeHuz61yTgrALELBinpRwEQ79LEoaldK
4BZMP2cdkT+xeDnkE2FUXOrL3HQwMg17tZ5BmcTfm1nFHXm9j2nIu5yu0KVM8oUK
O5P8heH9UQjDWzSTP9HaOuPovWQi8BiSEv/UPo5Bw1NC8BTzc7T7uUoqGap7NemM
12bntHGVJZA9FYmymgCW++uxLWDH6w==
=4+HZ
-----END PGP SIGNATURE-----

--2x3x3E2TwY2e5XAy9PJA80R0xPTkAiWCe--
