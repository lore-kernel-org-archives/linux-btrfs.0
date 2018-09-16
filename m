Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:60919 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726852AbeIPUON (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 16 Sep 2018 16:14:13 -0400
Subject: Re: btrfs problems
To: Adrian Bastholm <adrian@javaguru.org>, linux-btrfs@vger.kernel.org
References: <CAMrg+aRfS0NymyKo2Wwk75+TVBBbGPshnG_Yku403CwnhsimxQ@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <cbb66b3b-1b21-cb3c-c446-c44e861f36bc@gmx.com>
Date: Sun, 16 Sep 2018 22:50:42 +0800
MIME-Version: 1.0
In-Reply-To: <CAMrg+aRfS0NymyKo2Wwk75+TVBBbGPshnG_Yku403CwnhsimxQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="7UdTwdhq9vtiEc0qNGdSfb7acF8JWTXl6"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7UdTwdhq9vtiEc0qNGdSfb7acF8JWTXl6
Content-Type: multipart/mixed; boundary="PrkXtFcF4LOk81wvVbXLbGkCqLeyg12lx";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Adrian Bastholm <adrian@javaguru.org>, linux-btrfs@vger.kernel.org
Message-ID: <cbb66b3b-1b21-cb3c-c446-c44e861f36bc@gmx.com>
Subject: Re: btrfs problems
References: <CAMrg+aRfS0NymyKo2Wwk75+TVBBbGPshnG_Yku403CwnhsimxQ@mail.gmail.com>
In-Reply-To: <CAMrg+aRfS0NymyKo2Wwk75+TVBBbGPshnG_Yku403CwnhsimxQ@mail.gmail.com>

--PrkXtFcF4LOk81wvVbXLbGkCqLeyg12lx
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/9/16 =E4=B8=8B=E5=8D=889:58, Adrian Bastholm wrote:
> Hello all
> Actually I'm not trying to get any help any more, I gave up BTRFS on
> the desktop, but I'd like to share my efforts of trying to fix my
> problems, in hope I can help some poor noob like me.
>=20
> I decided to use BTRFS after reading the ArsTechnica article about the
> next-gen filesystems, and BTRFS seemed like the natural choice, open
> source, built into linux, etc. I even bought a HP microserver to have
> everything on because none of the commercial NAS-es supported BTRFS.
> What a mistake, I wasted weeks in total managing something that could
> have taken a day to set up, and I'd have MUCH more functionality now
> (if I wasn't hit by some ransomware, that is).
>=20
> I had three 1TB drives, chose to use raid, and all was good for a
> while, until started fiddling with Motion, the image capturing
> software. When you kill that process (my take on it) a file can be
> written but it ends up with question marks instead of attributes, and
> it's impossible to remove.

At this timing, your fs is already corrupted.
I'm not sure about the reason, it can be a failed CoW combined with
powerloss, or corrupted free space cache, or some old kernel bugs.

Anyway, the metadata itself is already corrupted, and I believe it
happens even before you noticed.

> BTRFS check --repair is not recommended, it
> crashes , doesn't fix all problems, and I later found out that my
> lost+found dir had about 39G of lost files and dirs.

lost+found is completely created by btrfs check --repair.

> I spent about two days trying to fix everything, removing a disk,
> adding it again, checking , you name it. I ended up removing one disk,
> reformatting it, and moving the data there.

Well, I would recommend to submit such problem to the mail list *BEFORE*
doing any write operation to the fs (including btrfs check --repair).
As it would help us to analyse the failure pattern to further enhance btr=
fs.

> Now I removed BTRFS
> entirely and replaced it with a OpenZFS mirror array, to which I'll
> add the third disk later when I transferred everything over.

Understandable, it's really annoying a fs just get itself corrupted, and
without much btrfs specified knowledge it would just be a hell to try
any method to fix it (even a lot of them would just make the case worse).=


>=20
> Please have a look at the console logs. I've been running linux on the
> desktop for the past 15 years, so I'm not a noob, but for running
> BTRFS you better be involved in the development of it.

I'd say, yes.
For any btrfs unexpected behavior, don't use btrfs check --repair unless
you're a developer or some developer asked to do.

Any btrfs unexpected behavior, from strange ls output to aborted
transaction, please consult with the mail list first.
(Of course, with kernel version and btrfs-progs version, which is
missing in your console log though)

In fact, in recent (IIRC starting from v4.15) kernel releases, btrfs is
already doing much better error detection thus it would detect such
problem early on and protect the fs from being further modified.

(This further shows that the importance of using the latest mainline
kernel other than some old kernel provided by stable distribution).

Thanks,
Qu

> In my humble
> opinion, it's not for us "users" just yet. Not even for power users.
>=20
> For those of you considering building a NAS without special purposes,
> don't. Buy a synology, pop in a couple of drives, and enjoy the ride.
>=20
>=20
> ------------
>  root =EE=82=B0 /home/storage/motion/2017-05-24 =EE=82=B0 1 =EE=82=B0 l=
s -al
> ls: cannot access '36-20170524201346-02.jpg': No such file or directory=

> ls: cannot access '36-20170524201346-02.jpg': No such file or directory=

> total 4
> drwxrwxrwx 1 motion   motion   114 Sep 14 12:48 .
> drwxrwxr-x 1 motion   adyhasch  60 Sep 14 09:42 ..
> -????????? ? ?        ?          ?            ? 36-20170524201346-02.jp=
g
> -????????? ? ?        ?          ?            ? 36-20170524201346-02.jp=
g
> -rwxr-xr-x 1 adyhasch adyhasch  62 Sep 14 12:43 remove.py
> root =EE=82=B0 /home/storage/motion/2017-05-24 =EE=82=B0 1 =EE=82=B0 to=
uch test.raw
>  root =EE=82=B0 /home/storage/motion/2017-05-24 =EE=82=B0 cat /dev/rand=
om > test.raw
> ^C
> root =EE=82=B0 /home/storage/motion/2017-05-24 =EE=82=B0 ls -al
> ls: cannot access '36-20170524201346-02.jpg': No such file or directory=

> ls: cannot access '36-20170524201346-02.jpg': No such file or directory=

> total 8
> drwxrwxrwx 1 motion   motion   130 Sep 14 13:12 .
> drwxrwxr-x 1 motion   adyhasch  60 Sep 14 09:42 ..
> -????????? ? ?        ?          ?            ? 36-20170524201346-02.jp=
g
> -????????? ? ?        ?          ?            ? 36-20170524201346-02.jp=
g
> -rwxr-xr-x 1 adyhasch adyhasch  62 Sep 14 12:43 remove.py
> -rwxrwxrwx 1 root     root     338 Sep 14 13:12 test.raw
>  root =EE=82=B0 /home/storage/motion/2017-05-24 =EE=82=B0 1 =EE=82=B0 c=
p test.raw
> 36-20170524201346-02.jpg
> 'test.raw' -> '36-20170524201346-02.jpg'
>=20
>  root =EE=82=B0 /home/storage/motion/2017-05-24 =EE=82=B0 ls -al
> total 20
> drwxrwxrwx 1 motion   motion   178 Sep 14 13:13 .
> drwxrwxr-x 1 motion   adyhasch  60 Sep 14 09:42 ..
> -rwxr-xr-x 1 root     root     338 Sep 14 13:13 36-20170524201346-02.jp=
g
> -rwxr-xr-x 1 root     root     338 Sep 14 13:13 36-20170524201346-02.jp=
g
> -rwxr-xr-x 1 root     root     338 Sep 14 13:13 36-20170524201346-02.jp=
g
> -rwxr-xr-x 1 adyhasch adyhasch  62 Sep 14 12:43 remove.py
> -rwxrwxrwx 1 root     root     338 Sep 14 13:12 test.raw
>=20
>  root =EE=82=B0 /home/storage/motion/2017-05-24 =EE=82=B0 chmod 777 36-=
20170524201346-02.jpg
>=20
>  root =EE=82=B0 /home/storage/motion/2017-05-24 =EE=82=B0 ls -al
> total 20
> drwxrwxrwx 1 motion   motion   178 Sep 14 13:13 .
> drwxrwxr-x 1 motion   adyhasch  60 Sep 14 09:42 ..
> -rwxrwxrwx 1 root     root     338 Sep 14 13:13 36-20170524201346-02.jp=
g
> -rwxrwxrwx 1 root     root     338 Sep 14 13:13 36-20170524201346-02.jp=
g
> -rwxrwxrwx 1 root     root     338 Sep 14 13:13 36-20170524201346-02.jp=
g
> -rwxr-xr-x 1 adyhasch adyhasch  62 Sep 14 12:43 remove.py
> -rwxrwxrwx 1 root     root     338 Sep 14 13:12 test.raw
>  root =EE=82=B0 /home/storage/motion/2017-05-24 =EE=82=B0 unlink 36-201=
70524201346-02.jpg
> unlink: cannot unlink '36-20170524201346-02.jpg': No such file or direc=
tory
>=20
>  root =EE=82=B0 /home/storage/motion/2017-05-24 =EE=82=B0 1 =EE=82=B0 l=
s -al
> total 20
> drwxrwxrwx 1 motion   motion   178 Sep 14 13:13 .
> drwxrwxr-x 1 motion   adyhasch  60 Sep 14 09:42 ..
> -rwxrwxrwx 1 root     root     338 Sep 14 13:13 36-20170524201346-02.jp=
g
> -rwxrwxrwx 1 root     root     338 Sep 14 13:13 36-20170524201346-02.jp=
g
> -rwxrwxrwx 1 root     root     338 Sep 14 13:13 36-20170524201346-02.jp=
g
> -rwxr-xr-x 1 adyhasch adyhasch  62 Sep 14 12:43 remove.py
> -rwxrwxrwx 1 root     root     338 Sep 14 13:12 test.raw
>=20
>  root =EE=82=B0 /home/storage/motion/2017-05-24 =EE=82=B0 journalctl -k=
 | grep BTRFS
> Sep 14 09:41:58 jenna kernel: BTRFS: device label BTRFS Redundant
> storage devid 4 transid 348450 /dev/sdd
> Sep 14 09:41:58 jenna kernel: BTRFS: device label BTRFS Redundant
> storage devid 2 transid 348450 /dev/sdb
> Sep 14 09:41:58 jenna kernel: BTRFS: device label BTRFS Redundant
> storage devid 3 transid 348450 /dev/sdc
> Sep 14 09:41:58 jenna kernel: BTRFS info (device sdc): enabling auto de=
frag
> Sep 14 09:41:58 jenna kernel: BTRFS info (device sdc): disabling disk
> space caching
> Sep 14 12:52:36 jenna kernel: BTRFS: Transaction aborted (error -2)
> Sep 14 12:52:36 jenna kernel: BTRFS: error (device sdc) in
> btrfs_rename:9943: errno=3D-2 No such entry
> Sep 14 12:52:36 jenna kernel: BTRFS info (device sdc): forced readonly
> Sep 14 13:02:26 jenna kernel: BTRFS error (device sdc): cleaner
> transaction attach returned -30
> Sep 14 13:03:41 jenna kernel: BTRFS info (device sdc): disk space
> caching is enabled
>  root =EE=82=B0 /home/storage/motion/2017-05-24 =EE=82=B0
>=20
>  root =EE=82=B0 ~ =EE=82=B0 btrfs scrub status /home/storage/
> scrub status for 72ea6622-5098-4a0f-bea1-9a5e5a325735
>         scrub started at Fri Sep 14 13:06:46 2018 and finished after 00=
:56:35
>         total bytes scrubbed: 1.16TiB with 0 errors
>=20
>  root =EE=82=B0 /home/storage/motion/2017-05-24 =EE=82=B0 stat 36-20170=
524201346-02.jpg
>   File: 36-20170524201346-02.jpg
>   Size: 338             Blocks: 8          IO Block: 4096   regular fil=
e
> Device: 29h/41d Inode: 12616879    Links: 1
> Access: (0777/-rwxrwxrwx)  Uid: (    0/    root)   Gid: (    0/    root=
)
> Access: 2018-09-14 13:13:35.477264025 +0200
> Modify: 2018-09-14 13:13:35.477264025 +0200
> Change: 2018-09-14 13:14:02.025170343 +0200
>  Birth: -
>=20
>  root =EE=82=B0 /home/storage/motion/2017-05-24 =EE=82=B0 1 =EE=82=B0 f=
ind . -inum 12616879
> -exec rm -i {} \;
> rm: remove regular file './36-20170524201346-02.jpg'? y
> rm: cannot remove './36-20170524201346-02.jpg': No such file or directo=
ry
>=20
> root =EE=82=B0 /home/storage/motion/2017-05-24 =EE=82=B0 rm -f 36-20170=
524201346-02.jpg
>  root =EE=82=B0 /home/storage/motion/2017-05-24 =EE=82=B0 ls -al
> total 20
> drwxrwxrwx 1 motion   motion   178 Sep 14 13:13 .
> drwxrwxr-x 1 motion   adyhasch  60 Sep 14 09:42 ..
> -rwxrwxrwx 1 root     root     338 Sep 14 13:13 36-20170524201346-02.jp=
g
> -rwxrwxrwx 1 root     root     338 Sep 14 13:13 36-20170524201346-02.jp=
g
> -rwxrwxrwx 1 root     root     338 Sep 14 13:13 36-20170524201346-02.jp=
g
> -rwxr-xr-x 1 adyhasch adyhasch  62 Sep 14 12:43 remove.py
> -rwxrwxrwx 1 root     root     338 Sep 14 13:12 test.raw
>  root =EE=82=B0 /home/storage/motion/2017-05-24 =EE=82=B0 rm 36-2017052=
4201346-02.jpg
> rm: cannot remove '36-20170524201346-02.jpg': No such file or directory=

>=20
>  root =EE=82=B0 /home/storage/motion/2017-05-24 =EE=82=B0 rm -f 36-2017=
0524201346-02.jpg
>  root =EE=82=B0 /home/storage/motion/2017-05-24 =EE=82=B0 rm -f 36-2017=
0524201346-02.jpg
>  root =EE=82=B0 /home/storage/motion/2017-05-24 =EE=82=B0 rm -f 36-2017=
0524201346-02.jpg
>  root =EE=82=B0 /home/storage/motion/2017-05-24 =EE=82=B0 rm -f 36-2017=
0524201346-02.jpg
>  root =EE=82=B0 /home/storage/motion/2017-05-24 =EE=82=B0 rm -f 36-2017=
0524201346-02.jpg
>  root =EE=82=B0 /home/storage/motion/2017-05-24 =EE=82=B0 rm -f 36-2017=
0524201346-02.jpg
>  root =EE=82=B0 /home/storage/motion/2017-05-24 =EE=82=B0 rm -f 36-2017=
0524201346-02.jpg
>  root =EE=82=B0 /home/storage/motion/2017-05-24 =EE=82=B0 rm -f 36-2017=
0524201346-02.jpg
>  root =EE=82=B0 /home/storage/motion/2017-05-24 =EE=82=B0
> ... more of the same
>  root =EE=82=B0 /home/storage/motion =EE=82=B0 rm -rf 2017-05-24/
> rm: cannot remove '2017-05-24/': Directory not empty
>  root =EE=82=B0 /home/storage/motion =EE=82=B0 1 =EE=82=B0 ls -al 2017-=
05-24/
> ls: cannot access '2017-05-24/36-20170524201346-02.jpg': No such file
> or directory
> ls: cannot access '2017-05-24/36-20170524201346-02.jpg': No such file
> or directory
> ls: cannot access '2017-05-24/36-20170524201346-02.jpg': No such file
> or directory
> total 0
> drwxrwxrwx 1 motion motion   144 Sep 14 14:25 .
> drwxrwxr-x 1 motion adyhasch  60 Sep 14 09:42 ..
> -????????? ? ?      ?          ?            ? 36-20170524201346-02.jpg
> -????????? ? ?      ?          ?            ? 36-20170524201346-02.jpg
> -????????? ? ?      ?          ?            ? 36-20170524201346-02.jpg
>=20
>  root =EE=82=B0 ~ =EE=82=B0 btrfs check /dev/sdb
> warning, device 3 is missing
> warning, device 3 is missing
> Checking filesystem on /dev/sdb
> UUID: 72ea6622-5098-4a0f-bea1-9a5e5a325735
> checking extents
> checking free space cache
> failed to load free space cache for block group 9998483259392
> failed to load free space cache for block group 10388251541504
> failed to load free space cache for block group 10483848118272
> checking fs roots
> root 5 inode 11189411 errors 200, dir isize wrong
>         unresolved ref dir 11189411 index 0 namelen 0 name  filetype 0
> errors 6, no dir index, no inode ref
>         unresolved ref dir 11189411 index 9477 namelen 24 name
> 36-20170524201346-02.jpg filetype 1 errors 1, no dir item
> root 5 inode 12616877 errors 2000, link count wrong
>         unresolved ref dir 11189411 index 9482 namelen 24 name
> 36-20170524201346-02.jpg filetype 1 errors 1, no dir item
> root 5 inode 12616879 errors 2000, link count wrong
>         unresolved ref dir 11189411 index 9484 namelen 24 name
> 36-20170524201346-02.jpg filetype 1 errors 1, no dir item
> found 639613362176 bytes used err is 1
> total csum bytes: 605048928
> total tree bytes: 828735488
> total fs tree bytes: 182419456
> total extent tree bytes: 18399232
> btree space waste bytes: 47806043
> file data blocks allocated: 969656111104
>  referenced 634590535680
>=20
>=20
>   root =EE=82=B0 ~ =EE=82=B0 1 =EE=82=B0 btrfs check --repair /dev/sdb
> enabling repair mode
> warning, device 3 is missing
> warning, device 3 is missing
> Checking filesystem on /dev/sdb
> UUID: 72ea6622-5098-4a0f-bea1-9a5e5a325735
> checking extents
> Unable to find block group for 0
> extent-tree.c:289: find_search_start: Assertion `1` failed.
> btrfs[0x43e418]
> btrfs(btrfs_reserve_extent+0x5c9)[0x4425df]
> btrfs(btrfs_alloc_free_block+0x63)[0x44297c]
> btrfs(__btrfs_cow_block+0xfc)[0x436636]
> btrfs(btrfs_cow_block+0x8b)[0x436bd8]
> btrfs[0x43ad82]
> btrfs(btrfs_commit_transaction+0xb8)[0x43c5dc]
> btrfs[0x4268b4]
> btrfs(cmd_check+0x1111)[0x427d6d]
> btrfs(main+0x12f)[0x40a341]
> /lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf1)[0x7fd7a78002e1]=

> btrfs(_start+0x2a)[0x40a37a]
>=20
>=20
>  root =EE=82=B0 ~ =EE=82=B0 1 =EE=82=B0 btrfs check --repair /dev/sdc
> enabling repair mode
> warning, device 2 is missing
> Checking filesystem on /dev/sdc
> UUID: 72ea6622-5098-4a0f-bea1-9a5e5a325735
> checking extents
> Fixed 0 roots.
> checking free space cache
> cache and super generation don't match, space cache will be invalidated=

> checking fs roots
> reset isize for dir 11189411 root 5
>         unresolved ref dir 11189411 index 0 namelen 0 name  filetype 0
> errors 6, no dir index, no inode ref
>         unresolved ref dir 11189411 index 9477 namelen 24 name
> 36-20170524201346-02.jpg filetype 1 errors 1, no dir item
> invalid dir item size
> Moving file '36-20170524201346-02.jpg' to 'lost+found' dir since it
> has no valid backref
> Fixed the nlink of inode 12616877
> invalid dir item size
> Moving file '36-20170524201346-02.jpg.12616879' to 'lost+found' dir
> since it has no valid backref
> Fixed the nlink of inode 12616879
>         unresolved ref dir 11189411 index 0 namelen 0 name  filetype 0
> errors 6, no dir index, no inode ref
>         unresolved ref dir 11189411 index 9477 namelen 24 name
> 36-20170524201346-02.jpg filetype 1 errors 1, no dir item
> checking csums
> checking root refs
> found 639613362176 bytes used err is 0
> total csum bytes: 605048928
> total tree bytes: 828735488
> total fs tree bytes: 182419456
> total extent tree bytes: 18399232
> btree space waste bytes: 47806043
> file data blocks allocated: 969656111104
>  referenced 634590535680
>=20
>=20
>   root =EE=82=B0 ~ =EE=82=B0 251 =EE=82=B0 btrfs check  /dev/sdb
> warning, device 3 is missing
> warning, device 3 is missing
> parent transid verify failed on 9998522662912 wanted 348736 found 34874=
1
> parent transid verify failed on 9998522662912 wanted 348736 found 34874=
1
> Ignoring transid failure
> Couldn't setup extent tree
> Couldn't open file system
>=20
>  root =EE=82=B0 ~ =EE=82=B0 251 =EE=82=B0 mount /home/storage/
>  root =EE=82=B0 ~ =EE=82=B0 watch btrfs scrub status /home/storage/
>  root =EE=82=B0 ~ =EE=82=B0 ls /home/storage/motion/2017-05-24/
> ls: cannot access
> '/home/storage/motion/2017-05-24/36-20170524201346-02.jpg': No such
> file or directory
> 36-20170524201346-02.jpg
> total 0
> drwxrwxrwx 1 motion motion   24 Sep 14 14:25 .
> drwxrwxr-x 1 motion adyhasch 60 Sep 14 09:42 ..
> -????????? ? ?      ?         ?            ? 36-20170524201346-02.jpg
>=20
> Back to square one
>=20
> [12031.946724] BTRFS error (device sdc): cleaner transaction attach ret=
urned -30
> [19272.100407] BTRFS error (device sdc): bdev /dev/sdb errs: wr 0, rd
> 0, flush 0, corrupt 0, gen 1
> [19272.104100] BTRFS error (device sdc): bdev /dev/sdb errs: wr 0, rd
> 0, flush 0, corrupt 0, gen 2
> [19272.120344] BTRFS error (device sdc): bdev /dev/sdb errs: wr 0, rd
> 0, flush 0, corrupt 0, gen 3
>=20


--PrkXtFcF4LOk81wvVbXLbGkCqLeyg12lx--

--7UdTwdhq9vtiEc0qNGdSfb7acF8JWTXl6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAluebcIACgkQwj2R86El
/qiNSwf+I4IijA2ZKpSM/Sr1t+bindthvNk8jolKVq2oUF2jX3v5r6GmT0IQCpil
HceKvB773REOL63f3NjwEGC9neULP2j6EXeGjCbG6XzjhL9DTOPy7o/nDhz95sY5
5y1+s6Yuuuzl00xWq3nXvyYyXYyBD4nI8QyhIqQQC8AuisWwczfGj6tGVlxCyH5D
h3pned5wSRaj7zabtFMz7BVzA6MCTEFGAGXZqlITRq1DT8aDBZw0i+ccVjKuWlQU
gqMDjGXWVrJ0ngWm7kbJxH1CM2pWdPa7kNi2pI891+YAcDiSLzxfAcOirpp9qpPG
lK2U37mJaF1HUtMnMc9s3AJ9i1Mxyw==
=ErxO
-----END PGP SIGNATURE-----

--7UdTwdhq9vtiEc0qNGdSfb7acF8JWTXl6--
