Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:33229 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751514AbeD2Jdw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 29 Apr 2018 05:33:52 -0400
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
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <bb0df6b1-3780-8ea5-b48e-e82f65a68f60@gmx.com>
Date: Sun, 29 Apr 2018 17:33:46 +0800
MIME-Version: 1.0
In-Reply-To: <CAB+znrHPF7963-MAXtgu8s3+vLEA7ENE0=uCCJ6sWCF6KUWToQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Y2uhbVjcVVkvaYCJUE7ZUBI8uesQYLYGG"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Y2uhbVjcVVkvaYCJUE7ZUBI8uesQYLYGG
Content-Type: multipart/mixed; boundary="o5zEB8qi1wx9DxTMzCRVpT1eeyFDrbECP";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Michael Wade <spikewade@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <bb0df6b1-3780-8ea5-b48e-e82f65a68f60@gmx.com>
Subject: Re: BTRFS RAID filesystem unmountable
References: <CAB+znrFyimDnOZt46CqterRJ6MvwD4TSWagQvv-oQxjPvG-m2w@mail.gmail.com>
 <54d2f70a-adae-98cc-581f-2e4786783b26@gmx.com>
 <CAB+znrHYrhBB4cstUaS3KcOfEHhOTPUsfAJKj3Cj62HJ-05FrQ@mail.gmail.com>
 <d32f3fdc-5ba0-2b62-ce79-5e5665d4c960@gmx.com>
 <CAB+znrF_d+Hg_A9AMvWEB=S5eVAtYrvr2jUPcvR4FfB4hnCMWA@mail.gmail.com>
 <bff1c7b3-5bac-9806-a376-3612057865cf@gmx.com>
 <CAB+znrHPF7963-MAXtgu8s3+vLEA7ENE0=uCCJ6sWCF6KUWToQ@mail.gmail.com>
In-Reply-To: <CAB+znrHPF7963-MAXtgu8s3+vLEA7ENE0=uCCJ6sWCF6KUWToQ@mail.gmail.com>

--o5zEB8qi1wx9DxTMzCRVpT1eeyFDrbECP
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B404=E6=9C=8829=E6=97=A5 16:59, Michael Wade wrote:
> Ok, will it be possible for me to install the new version of the tools
> on my current kernel without overriding the existing install? Hesitant
> to update kernel/btrfs as it might break the ReadyNAS interface /
> future firmware upgrades.
>=20
> Perhaps I could grab this:
> https://github.com/kdave/btrfs-progs/releases/tag/v4.16.1 and
> hopefully build from source and then run the binaries directly?

Of course, that's how most of us test btrfs-progs builds.

Thanks,
Qu

>=20
> Kind regards
>=20
> On 29 April 2018 at 09:33, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>
>>
>> On 2018=E5=B9=B404=E6=9C=8829=E6=97=A5 16:11, Michael Wade wrote:
>>> Thanks Qu,
>>>
>>> Please find attached the log file for the chunk recover command.
>>
>> Strangely, btrfs chunk recovery found no extra chunk beyond current
>> system chunk range.
>>
>> Which means, it's chunk tree corrupted.
>>
>> Please dump the chunk tree with latest btrfs-progs (which provides the=

>> new --follow option).
>>
>> # btrfs inspect dump-tree -b 20800943685632 <device>
>>
>> If it doesn't work, please provide the following binary dump:
>>
>> # dd if=3D<dev> of=3D/tmp/chunk_root.copy1 bs=3D1 count=3D32K skip=3D2=
66325721088
>> # dd if=3D<dev> of=3D/tmp/chunk_root.copy2 bs=3D1 count=3D32K skip=3D2=
66359275520
>> (And will need to repeat similar dump for several times according to
>> above dump)
>>
>> Thanks,
>> Qu
>>
>>
>>>
>>> Kind regards
>>> Michael
>>>
>>> On 28 April 2018 at 12:38, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>>>
>>>>
>>>> On 2018=E5=B9=B404=E6=9C=8828=E6=97=A5 17:37, Michael Wade wrote:
>>>>> Hi Qu,
>>>>>
>>>>> Thanks for your reply. I will investigate upgrading the kernel,
>>>>> however I worry that future ReadyNAS firmware upgrades would fail o=
n a
>>>>> newer kernel version (I don't have much linux experience so maybe m=
y
>>>>> concerns are unfounded!?).
>>>>>
>>>>> I have attached the output of the dump super command.
>>>>>
>>>>> I did actually run chunk recover before, without the verbose option=
,
>>>>> it took around 24 hours to finish but did not resolve my issue. Hap=
py
>>>>> to start that again if you need its output.
>>>>
>>>> The system chunk only contains the following chunks:
>>>> [0, 4194304]:           Initial temporary chunk, not used at all
>>>> [20971520, 29360128]:   System chunk created by mkfs, should be full=

>>>>                         used up
>>>> [20800943685632, 20800977240064]:
>>>>                         The newly created large system chunk.
>>>>
>>>> The chunk root is still in 2nd chunk thus valid, but some of its lea=
f is
>>>> out of the range.
>>>>
>>>> If you can't wait 24h for chunk recovery to run, my advice would be =
move
>>>> the disk to some other computer, and use latest btrfs-progs to execu=
te
>>>> the following command:
>>>>
>>>> # btrfs inpsect dump-tree -b 20800943685632 --follow
>>>>
>>>> If we're lucky enough, we may read out the tree leaf containing the =
new
>>>> system chunk and save a day.
>>>>
>>>> Thanks,
>>>> Qu
>>>>
>>>>>
>>>>> Thanks so much for your help.
>>>>>
>>>>> Kind regards
>>>>> Michael
>>>>>
>>>>> On 28 April 2018 at 09:45, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote=
:
>>>>>>
>>>>>>
>>>>>> On 2018=E5=B9=B404=E6=9C=8828=E6=97=A5 16:30, Michael Wade wrote:
>>>>>>> Hi all,
>>>>>>>
>>>>>>> I was hoping that someone would be able to help me resolve the is=
sues
>>>>>>> I am having with my ReadyNAS BTRFS volume. Basically my trouble
>>>>>>> started after a power cut, subsequently the volume would not moun=
t.
>>>>>>> Here are the details of my setup as it is at the moment:
>>>>>>>
>>>>>>> uname -a
>>>>>>> Linux QAI 4.4.116.alpine.1 #1 SMP Mon Feb 19 21:58:38 PST 2018 ar=
mv7l GNU/Linux
>>>>>>
>>>>>> The kernel is pretty old for btrfs.
>>>>>> Strongly recommended to upgrade.
>>>>>>
>>>>>>>
>>>>>>> btrfs --version
>>>>>>> btrfs-progs v4.12
>>>>>>
>>>>>> So is the user tools.
>>>>>>
>>>>>> Although I think it won't be a big problem, as needed tool should =
be there.
>>>>>>
>>>>>>>
>>>>>>> btrfs fi show
>>>>>>> Label: '11baed92:data'  uuid: 20628cda-d98f-4f85-955c-932a367f882=
1
>>>>>>> Total devices 1 FS bytes used 5.12TiB
>>>>>>> devid    1 size 7.27TiB used 6.24TiB path /dev/md127
>>>>>>
>>>>>> So, it's btrfs on mdraid.
>>>>>> It would normally make things harder to debug, so I could only pro=
vide
>>>>>> advice from the respect of btrfs.
>>>>>> For mdraid part, I can't ensure anything.
>>>>>>
>>>>>>>
>>>>>>> Here are the relevant dmesg logs for the current state of the dev=
ice:
>>>>>>>
>>>>>>> [   19.119391] md: md127 stopped.
>>>>>>> [   19.120841] md: bind<sdb3>
>>>>>>> [   19.121120] md: bind<sdc3>
>>>>>>> [   19.121380] md: bind<sda3>
>>>>>>> [   19.125535] md/raid:md127: device sda3 operational as raid dis=
k 0
>>>>>>> [   19.125547] md/raid:md127: device sdc3 operational as raid dis=
k 2
>>>>>>> [   19.125554] md/raid:md127: device sdb3 operational as raid dis=
k 1
>>>>>>> [   19.126712] md/raid:md127: allocated 3240kB
>>>>>>> [   19.126778] md/raid:md127: raid level 5 active with 3 out of 3=

>>>>>>> devices, algorithm 2
>>>>>>> [   19.126784] RAID conf printout:
>>>>>>> [   19.126789]  --- level:5 rd:3 wd:3
>>>>>>> [   19.126794]  disk 0, o:1, dev:sda3
>>>>>>> [   19.126799]  disk 1, o:1, dev:sdb3
>>>>>>> [   19.126804]  disk 2, o:1, dev:sdc3
>>>>>>> [   19.128118] md127: detected capacity change from 0 to 79916375=
73632
>>>>>>> [   19.395112] Adding 523708k swap on /dev/md1.  Priority:-1 exte=
nts:1
>>>>>>> across:523708k
>>>>>>> [   19.434956] BTRFS: device label 11baed92:data devid 1 transid
>>>>>>> 151800 /dev/md127
>>>>>>> [   19.739276] BTRFS info (device md127): setting nodatasum
>>>>>>> [   19.740440] BTRFS critical (device md127): unable to find logi=
cal
>>>>>>> 3208757641216 len 4096
>>>>>>> [   19.740450] BTRFS critical (device md127): unable to find logi=
cal
>>>>>>> 3208757641216 len 4096
>>>>>>> [   19.740498] BTRFS critical (device md127): unable to find logi=
cal
>>>>>>> 3208757641216 len 4096
>>>>>>> [   19.740512] BTRFS critical (device md127): unable to find logi=
cal
>>>>>>> 3208757641216 len 4096
>>>>>>> [   19.740552] BTRFS critical (device md127): unable to find logi=
cal
>>>>>>> 3208757641216 len 4096
>>>>>>> [   19.740560] BTRFS critical (device md127): unable to find logi=
cal
>>>>>>> 3208757641216 len 4096
>>>>>>> [   19.740576] BTRFS error (device md127): failed to read chunk r=
oot
>>>>>>
>>>>>> This shows it pretty clear, btrfs fails to read chunk root.
>>>>>> And according your above "len 4096" it's pretty old fs, as it's st=
ill
>>>>>> using 4K nodesize other than 16K nodesize.
>>>>>>
>>>>>> According to above output, it means your superblock by somehow lac=
ks the
>>>>>> needed system chunk mapping, which is used to initialize chunk map=
ping.
>>>>>>
>>>>>> Please provide the following command output:
>>>>>>
>>>>>> # btrfs inspect dump-super -fFa /dev/md127
>>>>>>
>>>>>> Also, please consider run the following command and dump all its o=
utput:
>>>>>>
>>>>>> # btrfs rescue chunk-recover -v /dev/md127.
>>>>>>
>>>>>> Please note that, above command can take a long time to finish, an=
d if
>>>>>> it works without problem, it may solve your problem.
>>>>>> But if it doesn't work, the output could help me to manually craft=
 a fix
>>>>>> to your super block.
>>>>>>
>>>>>> Thanks,
>>>>>> Qu
>>>>>>
>>>>>>
>>>>>>> [   19.783975] BTRFS error (device md127): open_ctree failed
>>>>>>>
>>>>>>> In an attempt to recover the volume myself I run a few BTRFS comm=
ands
>>>>>>> mostly using advice from here:
>>>>>>> https://lists.opensuse.org/opensuse/2017-02/msg00930.html. Howeve=
r
>>>>>>> that actually seems to have made things worse as I can no longer =
mount
>>>>>>> the file system, not even in readonly mode.
>>>>>>>
>>>>>>> So starting from the beginning here is a list of things I have do=
ne so
>>>>>>> far (hopefully I remembered the order in which I ran them!)
>>>>>>>
>>>>>>> 1. Noticed that my backups to the NAS were not running (didn't ge=
t
>>>>>>> notified that the volume had basically "died")
>>>>>>> 2. ReadyNAS UI indicated that the volume was inactive.
>>>>>>> 3. SSHed onto the box and found that the first drive was not mark=
ed as
>>>>>>> operational (log showed I/O errors / UNKOWN (0x2003))  so I repla=
ced
>>>>>>> the disk and let the array resync.
>>>>>>> 4. After resync the volume still was unaccessible so I looked at =
the
>>>>>>> logs once more and saw something like the following which seemed =
to
>>>>>>> indicate that the replay log had been corrupted when the power we=
nt
>>>>>>> out:
>>>>>>>
>>>>>>> BTRFS critical (device md127): corrupt leaf, non-root leaf's nrit=
ems
>>>>>>> is 0: block=3D232292352, root=3D7, slot=3D0
>>>>>>> BTRFS critical (device md127): corrupt leaf, non-root leaf's nrit=
ems
>>>>>>> is 0: block=3D232292352, root=3D7, slot=3D0
>>>>>>> BTRFS: error (device md127) in btrfs_replay_log:2524: errno=3D-5 =
IO
>>>>>>> failure (Failed to recover log tree)
>>>>>>> BTRFS error (device md127): pending csums is 155648
>>>>>>> BTRFS error (device md127): cleaner transaction attach returned -=
30
>>>>>>> BTRFS critical (device md127): corrupt leaf, non-root leaf's nrit=
ems
>>>>>>> is 0: block=3D232292352, root=3D7, slot=3D0
>>>>>>>
>>>>>>> 5. Then:
>>>>>>>
>>>>>>> btrfs rescue zero-log
>>>>>>>
>>>>>>> 6. Was then able to mount the volume in readonly mode.
>>>>>>>
>>>>>>> btrfs scrub start
>>>>>>>
>>>>>>> Which fixed some errors but not all:
>>>>>>>
>>>>>>> scrub status for 20628cda-d98f-4f85-955c-932a367f8821
>>>>>>>
>>>>>>> scrub started at Tue Apr 24 17:27:44 2018, running for 04:00:34
>>>>>>> total bytes scrubbed: 224.26GiB with 6 errors
>>>>>>> error details: csum=3D6
>>>>>>> corrected errors: 0, uncorrectable errors: 6, unverified errors: =
0
>>>>>>>
>>>>>>> scrub status for 20628cda-d98f-4f85-955c-932a367f8821
>>>>>>> scrub started at Tue Apr 24 17:27:44 2018, running for 04:34:43
>>>>>>> total bytes scrubbed: 224.26GiB with 6 errors
>>>>>>> error details: csum=3D6
>>>>>>> corrected errors: 0, uncorrectable errors: 6, unverified errors: =
0
>>>>>>>
>>>>>>> 6. Seeing this hanging I rebooted the NAS
>>>>>>> 7. Think this is when the volume would not mount at all.
>>>>>>> 8. Seeing log entries like these:
>>>>>>>
>>>>>>> BTRFS warning (device md127): checksum error at logical 208009436=
85632
>>>>>>> on dev /dev/md127, sector 520167424: metadata node (level 1) in t=
ree 3
>>>>>>>
>>>>>>> I ran
>>>>>>>
>>>>>>> btrfs check --fix-crc
>>>>>>>
>>>>>>> And that brings us to where I am now: Some seemly corrupted BTRFS=

>>>>>>> metadata and unable to mount the drive even with the recovery opt=
ion.
>>>>>>>
>>>>>>> Any help you can give is much appreciated!
>>>>>>>
>>>>>>> Kind regards
>>>>>>> Michael
>>>>>>> --
>>>>>>> To unsubscribe from this list: send the line "unsubscribe linux-b=
trfs" in
>>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.htm=
l
>>>>>>>
>>>>>>
>>>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--o5zEB8qi1wx9DxTMzCRVpT1eeyFDrbECP--

--Y2uhbVjcVVkvaYCJUE7ZUBI8uesQYLYGG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlrlkXoACgkQwj2R86El
/qjFeQf/Z1+3j/Ga6xdsX4QdF33B0UQrreWDadUEyq3Vq8JG9TyviOWp5HxuJ4lN
yJWDeiD9uBuOinf+W7QK+9s80kOIQyWBwAFuegO59jZhXdlT8JxMFOGMhRzWfvFq
GeMzeTonETJ0345IxhJ3lOfkC/nkc+Bh2cWSduhb8DCFJ12lEiRoVU7IA+nYT7nB
bbseYUOLXtKLr9cyl6fW+OEjJfMGUEbXtyurlNTwSV+5OokfYpVHmh8ysX4/gHeZ
IKH4uZg0mb16M/5NLWWmlFOTzdgwM1uEhzfgwwmaXxfVBcufCnxKdIhKeyBcyBUK
aTYrgWYAFSk0px9wjp9I5iW96Btp9A==
=Ryin
-----END PGP SIGNATURE-----

--Y2uhbVjcVVkvaYCJUE7ZUBI8uesQYLYGG--
