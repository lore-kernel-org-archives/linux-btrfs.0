From: =?iso-8859-1?Q?J=F6rg?= Sommer <joerg@alea.gnuu.de>
Subject: btrfs reads only 4k blocks -- how to improve?
Date: Thu, 16 Dec 2010 13:31:16 +0100
Message-ID: <20101216123116.GA5073@alea.gnuu.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3MwIy2ne0vdjdPXF"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I have a btrfs that conains many hardlinks. I'm using rsync to create
backups. It creates the backup of a day by (hard=E2=80=90)linking the files
(inodes) they haven't changed with the files from a former day.

% find 2010-12-1[10]-00 -maxdepth 1
2010-12-10-00
2010-12-10-00/etc
2010-12-10-00/home
2010-12-10-00/root
2010-12-10-00/srv
2010-12-10-00/usr
2010-12-10-00/var
2010-12-11-00
2010-12-11-00/etc
2010-12-11-00/home
2010-12-11-00/root
2010-12-11-00/srv
2010-12-11-00/usr
2010-12-11-00/var
% stat 2010-12-1[01]-00/etc/services
  File: =E2=80=9E2010-12-10-00/etc/services=E2=80=9C
  Size: 18480           Blocks: 40         IO Block: 4096   regul=C3=A4re D=
atei
Device: 15h/21d Inode: 7945534     Links: 7
Access: (0644/-rw-r--r--)  Uid: ( 1000/ateo-service)   Gid: (   34/  backup)
Access: 2010-11-19 02:26:01.000000000 +0100
Modify: 2008-08-28 04:00:12.000000000 +0200
Change: 2010-12-14 07:56:19.999523630 +0100
  File: =E2=80=9E2010-12-11-00/etc/services=E2=80=9C
  Size: 18480           Blocks: 40         IO Block: 4096   regul=C3=A4re D=
atei
Device: 15h/21d Inode: 7945534     Links: 7
Access: (0644/-rw-r--r--)  Uid: ( 1000/ateo-service)   Gid: (   34/  backup)
Access: 2010-11-19 02:26:01.000000000 +0100
Modify: 2008-08-28 04:00:12.000000000 +0200
Change: 2010-12-14 07:56:19.999523630 +0100

When running rm -r to remove an old backup or running rsync I see the
average size of a read or a write request ist 4k. This leads to a very
bad throughput of fewer than 2MByte/s. I'm using atop to watch these
numbers.

rsync is mostly doing this:

02:54:30.027895 link("../2010-12-14-00/home/peter/dump_070903", "home/peter=
/dump_070903") =3D 0
02:54:30.028398 lstat("home/peter/dump_070904", 0x7fffd17410c0) =3D -1 ENOE=
NT (No such file or directory)
02:54:30.028475 lstat("../2010-12-14-00/home/peter/dump_070904", {st_dev=3D=
makedev(0, 21), st_ino=3D9813608, st_mode=3DS_IFREG|0644, st_nlink=3D7, st_=
uid=3D1000, st_gid=3D34, st_blksize=3D4096, st_blocks=3D6, st_size=3D3244, =
st_atime=3D2010/11/20-08:25:40, st_mtime=3D2007/09/05-01:13:00, st_ctime=3D=
2010/12/14-08:08:31}) =3D 0
02:54:30.028598 lgetxattr("../2010-12-14-00/home/peter/dump_070904", "user.=
rsync.%stat", "100644 0,0 1001:1000", 255) =3D 20
02:54:30.028679 lgetxattr("../2010-12-14-00/home/peter/dump_070904", "user.=
rsync.%aacl", 0x0, 0) =3D -1 ENODATA (No data available)
02:54:30.028734 llistxattr("../2010-12-14-00/home/peter/dump_070904", 0x161=
2800, 1024) =3D 17
02:54:30.028783 link("../2010-12-14-00/home/peter/dump_070904", "home/peter=
/dump_070904") =3D 0
02:54:30.029078 lstat("home/peter/dump_070905", 0x7fffd17410c0) =3D -1 ENOE=
NT (No such file or directory)
02:54:30.029127 lstat("../2010-12-14-00/home/peter/dump_070905", {st_dev=3D=
makedev(0, 21), st_ino=3D9813609, st_mode=3DS_IFREG|0644, st_nlink=3D7, st_=
uid=3D1000, st_gid=3D34, st_blksize=3D4096, st_blocks=3D6, st_size=3D3251, =
st_atime=3D2010/11/20-08:25:40, st_mtime=3D2007/09/06-01:13:00, st_ctime=3D=
2010/12/14-08:08:31}) =3D 0
02:54:30.029226 lgetxattr("../2010-12-14-00/home/peter/dump_070905", "user.=
rsync.%stat", "100644 0,0 1001:1000", 255) =3D 20
02:54:30.029290 lgetxattr("../2010-12-14-00/home/peter/dump_070905", "user.=
rsync.%aacl", 0x0, 0) =3D -1 ENODATA (No data available)
02:54:30.029343 llistxattr("../2010-12-14-00/home/peter/dump_070905", 0x161=
2800, 1024) =3D 17
02:54:30.029389 link("../2010-12-14-00/home/peter/dump_070905", "home/peter=
/dump_070905") =3D 0
02:54:30.029564 lstat("home/peter/dump_070906", 0x7fffd17410c0) =3D -1 ENOE=
NT (No such file or directory)
02:54:30.029612 lstat("../2010-12-14-00/home/peter/dump_070906", {st_dev=3D=
makedev(0, 21), st_ino=3D9813610, st_mode=3DS_IFREG|0644, st_nlink=3D7, st_=
uid=3D1000, st_gid=3D34, st_blksize=3D4096, st_blocks=3D6, st_size=3D3183, =
st_atime=3D2010/11/20-08:25:40, st_mtime=3D2007/09/07-01:13:00, st_ctime=3D=
2010/12/14-08:08:31}) =3D 0
02:54:30.029704 lgetxattr("../2010-12-14-00/home/peter/dump_070906", "user.=
rsync.%stat", "100644 0,0 1001:1000", 255) =3D 20
02:54:30.029767 lgetxattr("../2010-12-14-00/home/peter/dump_070906", "user.=
rsync.%aacl", 0x0, 0) =3D -1 ENODATA (No data available)
02:54:30.029819 llistxattr("../2010-12-14-00/home/peter/dump_070906", 0x161=
2800, 1024) =3D 17
02:54:30.029865 link("../2010-12-14-00/home/peter/dump_070906", "home/peter=
/dump_070906") =3D 0
02:54:30.030097 lstat("home/peter/dump_070907", 0x7fffd17410c0) =3D -1 ENOE=
NT (No such file or directory)
02:54:30.030145 lstat("../2010-12-14-00/home/peter/dump_070907", {st_dev=3D=
makedev(0, 21), st_ino=3D9813611, st_mode=3DS_IFREG|0644, st_nlink=3D7, st_=
uid=3D1000, st_gid=3D34, st_blksize=3D4096, st_blocks=3D6, st_size=3D3239, =
st_atime=3D2010/11/20-08:25:40, st_mtime=3D2007/09/08-01:13:00, st_ctime=3D=
2010/12/14-08:08:31}) =3D 0
02:54:30.030240 lgetxattr("../2010-12-14-00/home/peter/dump_070907", "user.=
rsync.%stat", "100644 0,0 1001:1000", 255) =3D 20
02:54:30.030601 lgetxattr("../2010-12-14-00/home/peter/dump_070907", "user.=
rsync.%aacl", 0x0, 0) =3D -1 ENODATA (No data available)
02:54:30.030658 llistxattr("../2010-12-14-00/home/peter/dump_070907", 0x161=
2800, 1024) =3D 17
02:54:30.030707 link("../2010-12-14-00/home/peter/dump_070907", "home/peter=
/dump_070907") =3D 0
02:54:30.030913 lstat("home/peter/dump_070908", 0x7fffd17410c0) =3D -1 ENOE=
NT (No such file or directory)
02:54:30.030964 lstat("../2010-12-14-00/home/peter/dump_070908", {st_dev=3D=
makedev(0, 21), st_ino=3D9813612, st_mode=3DS_IFREG|0644, st_nlink=3D7, st_=
uid=3D1000, st_gid=3D34, st_blksize=3D4096, st_blocks=3D5, st_size=3D2802, =
st_atime=3D2010/11/20-08:25:40, st_mtime=3D2007/09/09-01:13:00, st_ctime=3D=
2010/12/14-08:08:31}) =3D 0
02:54:30.031061 lgetxattr("../2010-12-14-00/home/peter/dump_070908", "user.=
rsync.%stat", "100644 0,0 1001:1000", 255) =3D 20
02:54:30.032196 lgetxattr("../2010-12-14-00/home/peter/dump_070908", "user.=
rsync.%aacl", 0x0, 0) =3D -1 ENODATA (No data available)
02:54:30.032272 llistxattr("../2010-12-14-00/home/peter/dump_070908", 0x161=
2800, 1024) =3D 17
02:54:30.032320 link("../2010-12-14-00/home/peter/dump_070908", "home/peter=
/dump_070908") =3D 0
02:54:30.032576 lstat("home/peter/dump_070909", 0x7fffd17410c0) =3D -1 ENOE=
NT (No such file or directory)
02:54:30.032628 lstat("../2010-12-14-00/home/peter/dump_070909", {st_dev=3D=
makedev(0, 21), st_ino=3D9813613, st_mode=3DS_IFREG|0644, st_nlink=3D7, st_=
uid=3D1000, st_gid=3D34, st_blksize=3D4096, st_blocks=3D5, st_size=3D2672, =
st_atime=3D2010/11/20-08:25:40, st_mtime=3D2007/09/10-01:13:00, st_ctime=3D=
2010/12/14-08:08:31}) =3D 0
02:54:30.032728 lgetxattr("../2010-12-14-00/home/peter/dump_070909", "user.=
rsync.%stat", "100644 0,0 1001:1000", 255) =3D 20
02:54:30.032793 lgetxattr("../2010-12-14-00/home/peter/dump_070909", "user.=
rsync.%aacl", 0x0, 0) =3D -1 ENODATA (No data available)
02:54:30.032846 llistxattr("../2010-12-14-00/home/peter/dump_070909", 0x161=
2800, 1024) =3D 17
02:54:30.032893 link("../2010-12-14-00/home/peter/dump_070909", "home/peter=
/dump_070909") =3D 0
02:54:30.033094 lstat("home/peter/dump_070910", 0x7fffd17410c0) =3D -1 ENOE=
NT (No such file or directory)
02:54:30.033142 lstat("../2010-12-14-00/home/peter/dump_070910", {st_dev=3D=
makedev(0, 21), st_ino=3D9813614, st_mode=3DS_IFREG|0644, st_nlink=3D7, st_=
uid=3D1000, st_gid=3D34, st_blksize=3D4096, st_blocks=3D6, st_size=3D3393, =
st_atime=3D2010/11/20-08:25:40, st_mtime=3D2007/09/11-01:13:00, st_ctime=3D=
2010/12/14-08:08:31}) =3D 0
02:54:30.033237 lgetxattr("../2010-12-14-00/home/peter/dump_070910", "user.=
rsync.%stat", "100644 0,0 1001:1000", 255) =3D 20
02:54:30.033902 lgetxattr("../2010-12-14-00/home/peter/dump_070910", "user.=
rsync.%aacl", 0x0, 0) =3D -1 ENODATA (No data available)
02:54:30.033960 llistxattr("../2010-12-14-00/home/peter/dump_070910", 0x161=
2800, 1024) =3D 17
02:54:30.034018 link("../2010-12-14-00/home/peter/dump_070910", "home/peter=
/dump_070910") =3D 0
02:54:30.034123 lstat("home/peter/dump_070911", 0x7fffd17410c0) =3D -1 ENOE=
NT (No such file or directory)
02:54:30.034171 lstat("../2010-12-14-00/home/peter/dump_070911", {st_dev=3D=
makedev(0, 21), st_ino=3D9813615, st_mode=3DS_IFREG|0644, st_nlink=3D7, st_=
uid=3D1000, st_gid=3D34, st_blksize=3D4096, st_blocks=3D6, st_size=3D3340, =
st_atime=3D2010/11/20-08:25:40, st_mtime=3D2007/09/12-01:13:00, st_ctime=3D=
2010/12/14-08:08:32}) =3D 0
02:54:30.034264 lgetxattr("../2010-12-14-00/home/peter/dump_070911", "user.=
rsync.%stat", "100644 0,0 1001:1000", 255) =3D 20
02:54:30.034324 lgetxattr("../2010-12-14-00/home/peter/dump_070911", "user.=
rsync.%aacl", 0x0, 0) =3D -1 ENODATA (No data available)
02:54:30.034376 llistxattr("../2010-12-14-00/home/peter/dump_070911", 0x161=
2800, 1024) =3D 17
02:54:30.036405 link("../2010-12-14-00/home/peter/dump_070911", "home/peter=
/dump_070911") =3D 0
02:54:30.036986 lstat("home/peter/dump_070912", 0x7fffd17410c0) =3D -1 ENOE=
NT (No such file or directory)
02:54:30.037045 lstat("../2010-12-14-00/home/peter/dump_070912", {st_dev=3D=
makedev(0, 21), st_ino=3D9813616, st_mode=3DS_IFREG|0644, st_nlink=3D7, st_=
uid=3D1000, st_gid=3D34, st_blksize=3D4096, st_blocks=3D6, st_size=3D3407, =
st_atime=3D2010/11/20-08:25:40, st_mtime=3D2007/09/13-01:13:00, st_ctime=3D=
2010/12/14-08:08:32}) =3D 0
02:54:30.037155 lgetxattr("../2010-12-14-00/home/peter/dump_070912", "user.=
rsync.%stat", "100644 0,0 1001:1000", 255) =3D 20
02:54:30.057221 lgetxattr("../2010-12-14-00/home/peter/dump_070912", "user.=
rsync.%aacl", 0x0, 0) =3D -1 ENODATA (No data available)
02:54:30.057279 llistxattr("../2010-12-14-00/home/peter/dump_070912", 0x161=
2800, 1024) =3D 17
02:54:30.057347 link("../2010-12-14-00/home/peter/dump_070912", "home/peter=
/dump_070912") =3D 0
02:54:30.057574 lstat("home/peter/dump_070913", 0x7fffd17410c0) =3D -1 ENOE=
NT (No such file or directory)
02:54:30.057625 lstat("../2010-12-14-00/home/peter/dump_070913", {st_dev=3D=
makedev(0, 21), st_ino=3D9813617, st_mode=3DS_IFREG|0644, st_nlink=3D7, st_=
uid=3D1000, st_gid=3D34, st_blksize=3D4096, st_blocks=3D6, st_size=3D3335, =
st_atime=3D2010/11/20-08:25:40, st_mtime=3D2007/09/14-01:13:00, st_ctime=3D=
2010/12/14-08:08:32}) =3D 0
02:54:30.057724 lgetxattr("../2010-12-14-00/home/peter/dump_070913", "user.=
rsync.%stat", "100644 0,0 1001:1000", 255) =3D 20
02:54:30.057788 lgetxattr("../2010-12-14-00/home/peter/dump_070913", "user.=
rsync.%aacl", 0x0, 0) =3D -1 ENODATA (No data available)
02:54:30.057841 llistxattr("../2010-12-14-00/home/peter/dump_070913", 0x161=
2800, 1024) =3D 17
02:54:30.057889 link("../2010-12-14-00/home/peter/dump_070913", "home/peter=
/dump_070913") =3D 0
02:54:30.058126 lstat("home/peter/dump_070914", 0x7fffd17410c0) =3D -1 ENOE=
NT (No such file or directory)
02:54:30.058175 lstat("../2010-12-14-00/home/peter/dump_070914", {st_dev=3D=
makedev(0, 21), st_ino=3D9813618, st_mode=3DS_IFREG|0644, st_nlink=3D7, st_=
uid=3D1000, st_gid=3D34, st_blksize=3D4096, st_blocks=3D6, st_size=3D3166, =
st_atime=3D2010/11/20-08:25:40, st_mtime=3D2007/09/15-01:13:00, st_ctime=3D=
2010/12/14-08:08:32}) =3D 0
02:54:30.058269 lgetxattr("../2010-12-14-00/home/peter/dump_070914", "user.=
rsync.%stat", "100644 0,0 1001:1000", 255) =3D 20
02:54:30.058332 lgetxattr("../2010-12-14-00/home/peter/dump_070914", "user.=
rsync.%aacl", 0x0, 0) =3D -1 ENODATA (No data available)
02:54:30.058385 llistxattr("../2010-12-14-00/home/peter/dump_070914", 0x161=
2800, 1024) =3D 17
02:54:30.058432 link("../2010-12-14-00/home/peter/dump_070914", "home/peter=
/dump_070914") =3D 0
02:54:30.058674 lstat("home/peter/dump_070915", 0x7fffd17410c0) =3D -1 ENOE=
NT (No such file or directory)
02:54:30.058722 lstat("../2010-12-14-00/home/peter/dump_070915", {st_dev=3D=
makedev(0, 21), st_ino=3D9813619, st_mode=3DS_IFREG|0644, st_nlink=3D7, st_=
uid=3D1000, st_gid=3D34, st_blksize=3D4096, st_blocks=3D5, st_size=3D3056, =
st_atime=3D2010/11/20-08:25:40, st_mtime=3D2007/09/16-01:13:00, st_ctime=3D=
2010/12/14-08:08:32}) =3D 0
02:54:30.059068 lgetxattr("../2010-12-14-00/home/peter/dump_070915", "user.=
rsync.%stat", "100644 0,0 1001:1000", 255) =3D 20
02:54:30.059139 lgetxattr("../2010-12-14-00/home/peter/dump_070915", "user.=
rsync.%aacl", 0x0, 0) =3D -1 ENODATA (No data available)
02:54:30.059192 llistxattr("../2010-12-14-00/home/peter/dump_070915", 0x161=
2800, 1024) =3D 17
02:54:30.059241 link("../2010-12-14-00/home/peter/dump_070915", "home/peter=
/dump_070915") =3D 0
02:54:30.059513 lstat("home/peter/dump_070916", 0x7fffd17410c0) =3D -1 ENOE=
NT (No such file or directory)
02:54:30.059568 lstat("../2010-12-14-00/home/peter/dump_070916", {st_dev=3D=
makedev(0, 21), st_ino=3D9813620, st_mode=3DS_IFREG|0644, st_nlink=3D7, st_=
uid=3D1000, st_gid=3D34, st_blksize=3D4096, st_blocks=3D5, st_size=3D2864, =
st_atime=3D2010/11/20-08:25:40, st_mtime=3D2007/09/17-01:13:00, st_ctime=3D=
2010/12/14-08:08:33}) =3D 0
02:54:30.100912 lgetxattr("../2010-12-14-00/home/peter/dump_070916", "user.=
rsync.%stat", "100644 0,0 1001:1000", 255) =3D 20
02:54:30.100986 lgetxattr("../2010-12-14-00/home/peter/dump_070916", "user.=
rsync.%aacl", 0x0, 0) =3D -1 ENODATA (No data available)
02:54:30.101042 llistxattr("../2010-12-14-00/home/peter/dump_070916", 0x161=
2800, 1024) =3D 17
02:54:30.101091 link("../2010-12-14-00/home/peter/dump_070916", "home/peter=
/dump_070916") =3D 0
02:54:30.101488 lstat("home/peter/dump_070917", 0x7fffd17410c0) =3D -1 ENOE=
NT (No such file or directory)
02:54:30.101543 lstat("../2010-12-14-00/home/peter/dump_070917", {st_dev=3D=
makedev(0, 21), st_ino=3D9813621, st_mode=3DS_IFREG|0644, st_nlink=3D7, st_=
uid=3D1000, st_gid=3D34, st_blksize=3D4096, st_blocks=3D6, st_size=3D3220, =
st_atime=3D2010/11/20-08:25:40, st_mtime=3D2007/09/18-01:13:00, st_ctime=3D=
2010/12/14-08:08:33}) =3D 0
02:54:30.101646 lgetxattr("../2010-12-14-00/home/peter/dump_070917", "user.=
rsync.%stat", "100644 0,0 1001:1000", 255) =3D 20
02:54:30.101714 lgetxattr("../2010-12-14-00/home/peter/dump_070917", "user.=
rsync.%aacl", 0x0, 0) =3D -1 ENODATA (No data available)
02:54:30.101769 llistxattr("../2010-12-14-00/home/peter/dump_070917", 0x161=
2800, 1024) =3D 17
02:54:30.101819 link("../2010-12-14-00/home/peter/dump_070917", "home/peter=
/dump_070917") =3D 0
02:54:30.102024 lstat("home/peter/dump_070918", 0x7fffd17410c0) =3D -1 ENOE=
NT (No such file or directory)
02:54:30.102075 lstat("../2010-12-14-00/home/peter/dump_070918", {st_dev=3D=
makedev(0, 21), st_ino=3D9813622, st_mode=3DS_IFREG|0644, st_nlink=3D7, st_=
uid=3D1000, st_gid=3D34, st_blksize=3D4096, st_blocks=3D6, st_size=3D3184, =
st_atime=3D2010/11/20-08:25:40, st_mtime=3D2007/09/19-01:13:00, st_ctime=3D=
2010/12/14-08:08:33}) =3D 0
02:54:30.102172 lgetxattr("../2010-12-14-00/home/peter/dump_070918", "user.=
rsync.%stat", "100644 0,0 1001:1000", 255) =3D 20
02:54:30.102237 lgetxattr("../2010-12-14-00/home/peter/dump_070918", "user.=
rsync.%aacl", 0x0, 0) =3D -1 ENODATA (No data available)
02:54:30.102291 llistxattr("../2010-12-14-00/home/peter/dump_070918", 0x161=
2800, 1024) =3D 17
02:54:30.102339 link("../2010-12-14-00/home/peter/dump_070918", "home/peter=
/dump_070918") =3D 0
02:54:30.102559 lstat("home/peter/dump_070919", 0x7fffd17410c0) =3D -1 ENOE=
NT (No such file or directory)
02:54:30.102609 lstat("../2010-12-14-00/home/peter/dump_070919", {st_dev=3D=
makedev(0, 21), st_ino=3D9813623, st_mode=3DS_IFREG|0644, st_nlink=3D7, st_=
uid=3D1000, st_gid=3D34, st_blksize=3D4096, st_blocks=3D6, st_size=3D3275, =
st_atime=3D2010/11/20-08:25:40, st_mtime=3D2007/09/20-01:13:00, st_ctime=3D=
2010/12/14-08:08:33}) =3D 0
02:54:30.942826 lgetxattr("../2010-12-14-00/home/peter/dump_070919", "user.=
rsync.%stat", "100644 0,0 1001:1000", 255) =3D 20
02:54:30.942916 lgetxattr("../2010-12-14-00/home/peter/dump_070919", "user.=
rsync.%aacl", 0x0, 0) =3D -1 ENODATA (No data available)
02:54:30.942977 llistxattr("../2010-12-14-00/home/peter/dump_070919", 0x161=
2800, 1024) =3D 17
02:54:30.943029 link("../2010-12-14-00/home/peter/dump_070919", "home/peter=
/dump_070919") =3D 0
02:54:30.945281 lstat("home/peter/dump_070920", 0x7fffd17410c0) =3D -1 ENOE=
NT (No such file or directory)
02:54:30.945375 lstat("../2010-12-14-00/home/peter/dump_070920", {st_dev=3D=
makedev(0, 21), st_ino=3D9813624, st_mode=3DS_IFREG|0644, st_nlink=3D7, st_=
uid=3D1000, st_gid=3D34, st_blksize=3D4096, st_blocks=3D5, st_size=3D3006, =
st_atime=3D2010/11/20-08:25:40, st_mtime=3D2007/09/21-01:13:00, st_ctime=3D=
2010/12/14-08:08:33}) =3D 0
02:54:30.945500 lgetxattr("../2010-12-14-00/home/peter/dump_070920", "user.=
rsync.%stat", "100644 0,0 1001:1000", 255) =3D 20
02:54:30.945582 lgetxattr("../2010-12-14-00/home/peter/dump_070920", "user.=
rsync.%aacl", 0x0, 0) =3D -1 ENODATA (No data available)
02:54:30.945639 llistxattr("../2010-12-14-00/home/peter/dump_070920", 0x161=
2800, 1024) =3D 17
02:54:30.945691 link("../2010-12-14-00/home/peter/dump_070920", "home/peter=
/dump_070920") =3D 0

and rm is mostly doing that:

unlinkat(8, "TERASSE_01.jpg", 0)        =3D 0
unlinkat(8, "TERASSE_02-600x470.jpg", 0) =3D 0
unlinkat(8, "TERASSE_02.jpg", 0)        =3D 0
unlinkat(8, "TERASSE_03-600x463.jpg", 0) =3D 0
unlinkat(8, "TERASSE_03.jpg", 0)        =3D 0
unlinkat(8, "TERASSE_04-600x466.jpg", 0) =3D 0
unlinkat(8, "TERASSE_04.jpg", 0)        =3D 0
close(8)                                =3D 0
unlinkat(6, "pic", AT_REMOVEDIR)        =3D 0
close(6)                                =3D 0
unlinkat(4, "fuerte", AT_REMOVEDIR)     =3D 0
newfstatat(4, "fuerteventura_elba_sara", {st_mode=3DS_IFDIR|0777, st_size=
=3D448, ...}, AT_SYMLINK_NOFOLLOW) =3D 0
openat(4, "fuerteventura_elba_sara", O_RDONLY|O_NOCTTY|O_NONBLOCK|O_DIRECTO=
RY) =3D 3
fcntl(3, F_GETFD)                       =3D 0
fcntl(3, F_SETFD, FD_CLOEXEC)           =3D 0
fstat(3, {st_mode=3DS_IFDIR|0777, st_size=3D448, ...}) =3D 0
fcntl(3, F_GETFL)                       =3D 0x18800 (flags O_RDONLY|O_NONBL=
OCK|O_LARGEFILE|O_DIRECTORY)
fcntl(3, F_SETFD, FD_CLOEXEC)           =3D 0
fcntl(3, F_DUPFD, 3)                    =3D 6
fcntl(6, F_GETFD)                       =3D 0
fcntl(6, F_SETFD, FD_CLOEXEC)           =3D 0
getdents(3, /* 15 entries */, 32768)    =3D 568
getdents(3, /* 0 entries */, 32768)     =3D 0
close(3)                                =3D 0
unlinkat(6, "beschreibung.php3", 0)     =3D 0
unlinkat(6, "buchungsanfrage.php3", 0)  =3D 0
unlinkat(6, "buchungsanfrage_danke.php3", 0) =3D 0
unlinkat(6, "buchungsanfrage_formular.php3", 0) =3D 0
unlinkat(6, "buchungsanfragenavi.php3", 0) =3D 0
unlinkat(6, "email_gen.php3", 0)        =3D 0
unlinkat(6, "fotos.php3", 0)            =3D 0

Now, the question is, what can I do to increase the throughput? Can I
make btrfs caches more aggressively?

% free -m
             total       used       free     shared    buffers     cached
Mem:          3006       2696        310          0          5       2098
-/+ buffers/cache:        591       2414
Swap:            0          0          0

# smartctl -i /dev/sdb
smartctl 5.40 2010-07-12 r3124 [x86_64-unknown-linux-gnu] (local build)
Copyright (C) 2002-10 by Bruce Allen, http://smartmontools.sourceforge.net

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Western Digital Caviar Green (Adv. Format) family
Device Model:     WDC WD15EARS-00MVWB0
Serial Number:    WD-WCAZA1548514
Firmware Version: 51.0AB51
User Capacity:    1.500.301.910.016 bytes
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Thu Dec 16 13:28:50 2010 CET
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

Should I provide more informations?

Bye, J=C3=B6rg.

PS: Please, Cc me. I'm not subscribed the list.
--=20
Perfection is reached, not when there is no longer anything that can be
added, but when there is no longer anything to take away.
                                        (Antoine de Saint=E2=80=90Exupery)

--3MwIy2ne0vdjdPXF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature http://en.wikipedia.org/wiki/OpenPGP
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk0KBpQACgkQwe0mZwH1VICeKACfYoZMtF9sZyK4H6mpGnZ3A4LW
Q+kAoKDvxsKrY1pK0poc1bjXKK7xuZ4R
=r6ON
-----END PGP SIGNATURE-----

--3MwIy2ne0vdjdPXF--
