From: devzero@web.de
Subject: Re: weird bash autocomplete issue
Date: Tue, 16 Dec 2008 21:46:22 +0100
Message-ID: <545246795@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-btrfs@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

> On Tue, Dec 16, 2008 at 20:37, Roland <devzero@web.de> wrote:
> > i have come across a weird autocomplete issue i assume it is relate=
d to
> > btrfs.
> >
> > let`s have some dirs:
> >
> > /non-btrfs-mount
> >   ./linux
> >   ./testdir
> >
> > /brtfs-mount
> >   ./linux
> >   ./testdir
> >
> > now, if i do "cd t<tab>" in /non-btrfs-mount, "t" autocompletes to =
"testdir"
> > same for l<tab>inux - bash autocompletes as expected.
> >
> > now, the weird thing is, that on /btrfs-mount this behaves differen=
t.
> >
> > autocompletion for testdir works, but not for linux dir. weird.
> >
> > can someone reproduce this ?
>=20
> Open another shell, find the bash process pid of the first shell with=
:
>   ps afx
> and do:
>   strace -p <pid>
> Go back to the first shell, hit <tab>, and the trace should show
> what's going on. You see a significant difference there?


ok, here we go (i hope i did not cut important parts).
i don`t see the real issue, but i did another interesting finding - see=
 below


bad (cd l<tab>):

open(".", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) =3D 3
fstat64(3, {st_dev=3Dmakedev(0, 19), st_ino=3D256, st_mode=3DS_IFDIR|05=
55, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_blocks=3D=
8, st_size=3D18, st_atime=3D2008/12/16-21:32:38, st_mtime=3D2008/12/16-=
21:32:37, st_ctime=3D2008/12/16-21:32:37}) =3D 0
getdents64(3, {{d_ino=3D256, d_off=3D2, d_type=3DDT_DIR, d_reclen=3D24,=
 d_name=3D"."} {d_ino=3D256, d_off=3D2, d_type=3DDT_DIR, d_reclen=3D24,=
 d_name=3D".."} {d_ino=3D257, d_off=3D3, d_type=3DDT_DIR, d_reclen=3D24=
, d_name=3D"test"} {d_ino=3D258, d_off=3D9223372036854775807, d_type=3D=
DT_DIR, d_reclen=3D32, d_name=3D"linux"}}, 4096) =3D 104
_llseek(3, 3, [3], SEEK_SET)            =3D 0
getdents64(3, {{d_ino=3D258, d_off=3D9223372036854775807, d_type=3DDT_D=
IR, d_reclen=3D32, d_name=3D"linux"}}, 4096) =3D 32
close(3)                                =3D 0
write(2, "\7", 1)                       =3D 1
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  =3D 0

good (cd t<tab>):

open(".", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) =3D 3
fstat64(3, {st_dev=3Dmakedev(0, 19), st_ino=3D256, st_mode=3DS_IFDIR|05=
55, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_blocks=3D=
8, st_size=3D18, st_atime=3D2008/12/16-21:38:13, st_mtime=3D2008/12/16-=
21:38:11, st_ctime=3D2008/12/16-21:38:11}) =3D 0
getdents64(3, {{d_ino=3D256, d_off=3D2, d_type=3DDT_DIR, d_reclen=3D24,=
 d_name=3D"."} {d_ino=3D256, d_off=3D2, d_type=3DDT_DIR, d_reclen=3D24,=
 d_name=3D".."} {d_ino=3D257, d_off=3D3, d_type=3DDT_DIR, d_reclen=3D24=
, d_name=3D"test"} {d_ino=3D258, d_off=3D9223372036854775807, d_type=3D=
DT_DIR, d_reclen=3D32, d_name=3D"linux"}}, 4096) =3D 104
_llseek(3, 3, [3], SEEK_SET)            =3D 0
getdents64(3, {{d_ino=3D258, d_off=3D9223372036854775807, d_type=3DDT_D=
IR, d_reclen=3D32, d_name=3D"linux"}}, 4096) =3D 32
close(3)                                =3D 0
stat64("test", {st_dev=3Dmakedev(0, 19), st_ino=3D257, st_mode=3DS_IFDI=
R|0755, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_blo=
cks=3D0, st_size=3D0, st_atime=3D2008/12/16-21:15:29, st_mtime=3D2008/1=
2/16-21:15:29, st_ctime=3D2008/12/16-21:15:29}) =3D 0
stat64("test", {st_dev=3Dmakedev(0, 19), st_ino=3D257, st_mode=3DS_IFDI=
R|0755, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_blo=
cks=3D0, st_size=3D0, st_atime=3D2008/12/16-21:15:29, st_mtime=3D2008/1=
2/16-21:15:29, st_ctime=3D2008/12/16-21:15:29}) =3D 0
write(2, "est/", 4)                     =3D 4
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  =3D 0


and now, after adding a file to that dir with "touch abcd", for my curi=
ousity this makes "cd l<tab>" work again.

open(".", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) =3D 3
fstat64(3, {st_dev=3Dmakedev(0, 19), st_ino=3D256, st_mode=3DS_IFDIR|05=
55, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_blocks=3D=
8, st_size=3D26, st_atime=3D2008/12/16-21:34:45, st_mtime=3D2008/12/16-=
21:34:44, st_ctime=3D2008/12/16-21:34:44}) =3D 0
getdents64(3, {{d_ino=3D256, d_off=3D2, d_type=3DDT_DIR, d_reclen=3D24,=
 d_name=3D"."} {d_ino=3D256, d_off=3D2, d_type=3DDT_DIR, d_reclen=3D24,=
 d_name=3D".."} {d_ino=3D257, d_off=3D3, d_type=3DDT_DIR, d_reclen=3D24=
, d_name=3D"test"} {d_ino=3D258, d_off=3D17, d_type=3DDT_DIR, d_reclen=3D=
32, d_name=3D"linux"} {d_ino=3D272, d_off=3D9223372036854775807, d_type=
=3DDT_REG, d_reclen=3D24, d_name=3D"abcd"}}, 4096) =3D 128
_llseek(3, 17, [17], SEEK_SET)          =3D 0
getdents64(3, {{d_ino=3D272, d_off=3D9223372036854775807, d_type=3DDT_R=
EG, d_reclen=3D24, d_name=3D"abcd"}}, 4096) =3D 24
close(3)                                =3D 0
stat64("linux", {st_dev=3Dmakedev(0, 19), st_ino=3D258, st_mode=3DS_IFD=
IR|0755, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_bl=
ocks=3D0, st_size=3D0, st_atime=3D2008/12/16-21:15:33, st_mtime=3D2008/=
12/16-21:15:33, st_ctime=3D2008/12/16-21:15:33}) =3D 0
stat64("linux", {st_dev=3Dmakedev(0, 19), st_ino=3D258, st_mode=3DS_IFD=
IR|0755, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blksize=3D4096, st_bl=
ocks=3D0, st_size=3D0, st_atime=3D2008/12/16-21:15:33, st_mtime=3D2008/=
12/16-21:15:33, st_ctime=3D2008/12/16-21:15:33}) =3D 0
write(2, "inux/", 5)                    =3D 5
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  =3D 0


regards
roland


_______________________________________________________________________
T=E4glich 1.000.000 Euro gewinnen! Jetzt kostenlos WEB.DE MillionenKlic=
k=20
spielen! https://millionenklick.web.de/?mc=3Dmail@footer.mklick@home

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
