From: devzero@web.de
Subject: Re: btrfs filesystem freeze
Date: Tue, 23 Dec 2008 01:26:16 +0100
Message-ID: <552676848@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-btrfs@vger.kernel.org
To: Yan Zheng <zheng.yan@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

thanks,=20

i tried it and ran my tests for some hours now - looks really good. no =
crashes, no freezes.=20

anyway, some "minor" glitches remain.

i looked at some "ls -la /btrfs" output via "watch ls -la..", and by ch=
ance i saw this one for a moment.

dr-xr-xr-x  1 root root     126 Dec 22 22:19 snap96
dr-xr-xr-x  1 root root     126 Dec 22 22:19 snap97
dr-xr-xr-x  1 root root     126 Dec 22 22:19 snap98
dr-xr-xr-x  1 root root     110 Dec 22 22:19 snap99
-rw-r--r--  1 root root 1048576 Dec 22 22:49 test.dat
-?????????  ? ?    ?          ?            ? test.tmp
-rw-r--r--  1 root root 7020046 Dec 22 22:48 testfsx
-rw-r--r--  1 root root       0 Dec 22 22:23 testfsx.fsxgood
-rw-r--r--  1 root root       0 Dec 22 22:23 testfsx.fsxlog

that file test.tmp looks weird.=20
it`s constantly created by copying test.dat forth and back (i.e cp test=
=2Edat test.tmp, md5sum test.tmp;rm test.dat;mv test.tmp test.dat  in a=
 loop, to check file consistency)

should i worry here ?


furthermore, after several hours, i got this one (also once):

Tue Dec 23 00:40:33 CET 2008 59987747e2568fa81bb38603706eff07  test.tmp
Tue Dec 23 00:42:59 CET 2008 59987747e2568fa81bb38603706eff07  test.tmp
Tue Dec 23 00:43:17 CET 2008 59987747e2568fa81bb38603706eff07  test.tmp
Tue Dec 23 00:44:28 CET 2008 59987747e2568fa81bb38603706eff07  test.tmp
Tue Dec 23 00:49:43 CET 2008 59987747e2568fa81bb38603706eff07  test.tmp
Tue Dec 23 00:50:37 CET 2008 59987747e2568fa81bb38603706eff07  test.tmp
Tue Dec 23 00:50:57 CET 2008 59987747e2568fa81bb38603706eff07  test.tmp
Tue Dec 23 00:56:44 CET 2008 59987747e2568fa81bb38603706eff07  test.tmp
Tue Dec 23 00:59:33 CET 2008 59987747e2568fa81bb38603706eff07  test.tmp
Tue Dec 23 01:00:03 CET 2008 md5sum: test.tmp: Input/output error
cp: reading `test.dat': Input/output error
Tue Dec 23 01:01:44 CET 2008 ca6bbc6a8aa5ec080a2a10d727ecc563  test.tmp
Tue Dec 23 01:08:05 CET 2008 ca6bbc6a8aa5ec080a2a10d727ecc563  test.tmp

how can this happen?=20
"cp test.dat test.tmp" is _always_ something which happens after "mv te=
st.tmp test.dat", and there`s a "sync" in between

looks like a race condition !?
the mv command returned but btfs did not complete the file move and the=
 next command does not yet see the moved file !?


i don`t have timing information for dmesg and cannot tell, if there is =
any relation with those glitches, but here is some messages in dmesg :

device fsid 7c4ee06dc0149bc8-44e376a69f9aa08b devid 1 transid 9 /dev/sd=
b1
btrfs: use compression
btrfs: unlinked 1 orphans
btrfs: unlinked 1 orphans
btrfs: unlinked 1 orphans
btrfs: unlinked 1 orphans
btrfs: unlinked 1 orphans
btrfs: unlinked 1 orphans
btrfs: unlinked 1 orphans
btrfs: unlinked 1 orphans
btrfs: unlinked 1 orphans
btrfs csum failed ino 39502 off 524288 csum 1261748817 private 18134416=
08
btrfs csum failed ino 39502 off 524288 csum 1261748817 private 18134416=
08
btrfs csum failed ino 39502 off 524288 csum 1261748817 private 18134416=
08
btrfs csum failed ino 39502 off 524288 csum 1261748817 private 18134416=
08
btrfs csum failed ino 39502 off 524288 csum 1261748817 private 18134416=
08
btrfs csum failed ino 39502 off 524288 csum 1261748817 private 18134416=
08
btrfs csum failed ino 39502 off 524288 csum 1261748817 private 18134416=
08
btrfs csum failed ino 39502 off 524288 csum 1261748817 private 18134416=
08
btrfs: unlinked 1 orphans
btrfs: unlinked 1 orphans

so, apparently also some checksum was wrong !?


ah, and some more (please forgive - this is all for making btfs better!=
)

i ran some posix regression test suite (http://www.ntfs-3g.org/pjd-fste=
st.html) , which also reported some problems.=20

i`m not sure if this are false positives because the testsuite does not=
 officially support btrfs.=20

i`m posting it here for review.

linux-uqw0:/btrfs/pjd-fstest-20080917-RC # prove -r .
tests/chflags/00.....ok
tests/chflags/01.....ok
tests/chflags/02.....ok
tests/chflags/03.....ok
tests/chflags/04.....ok
tests/chflags/05.....ok
tests/chflags/06.....ok
tests/chflags/07.....ok
tests/chflags/08.....ok
tests/chflags/09.....ok
tests/chflags/10.....ok
tests/chflags/11.....ok
tests/chflags/12.....ok
tests/chflags/13.....ok
tests/chmod/00.......ok
tests/chmod/01.......ok
tests/chmod/02.......ok
tests/chmod/03.......ok
tests/chmod/04.......ok
tests/chmod/05.......ok
tests/chmod/06.......ok
tests/chmod/07.......ok
tests/chmod/08.......ok
tests/chmod/09.......ok
tests/chmod/10.......ok
tests/chmod/11.......ok
tests/chown/00.......ok
tests/chown/01.......ok
tests/chown/02.......ok
tests/chown/03.......ok
tests/chown/04.......ok
tests/chown/05.......ok
tests/chown/06.......ok
tests/chown/07.......ok
tests/chown/08.......ok
tests/chown/09.......ok
tests/chown/10.......ok
tests/link/00........FAILED tests 56, 63
        Failed 2/82 tests, 97.56% okay
tests/link/01........ok
tests/link/02........ok
tests/link/03........ok
tests/link/04........ok
tests/link/05........ok
tests/link/06........ok
tests/link/07........ok
tests/link/08........ok
tests/link/09........ok
tests/link/10........ok
tests/link/11........ok
tests/link/12........ok
tests/link/13........ok
tests/link/14........ok
tests/link/15........ok
tests/link/16........ok
tests/link/17........ok
tests/mkdir/00.......ok
tests/mkdir/01.......ok
tests/mkdir/02.......ok
tests/mkdir/03.......ok
tests/mkdir/04.......ok
tests/mkdir/05.......ok
tests/mkdir/06.......ok
tests/mkdir/07.......ok
tests/mkdir/08.......ok
tests/mkdir/09.......ok
tests/mkdir/10.......ok
tests/mkdir/11.......ok
tests/mkdir/12.......ok
tests/mkfifo/00......ok
tests/mkfifo/01......ok
tests/mkfifo/02......ok
tests/mkfifo/03......ok
tests/mkfifo/04......ok
tests/mkfifo/05......ok
tests/mkfifo/06......ok
tests/mkfifo/07......ok
tests/mkfifo/08......ok
tests/mkfifo/09......ok
tests/mkfifo/10......ok
tests/mkfifo/11......ok
tests/mkfifo/12......ok
tests/open/00........ok
tests/open/01........ok
tests/open/02........ok
tests/open/03........ok
tests/open/04........ok
tests/open/05........ok
tests/open/06........ok
tests/open/07........ok
tests/open/08........ok
tests/open/09........ok
tests/open/10........ok
tests/open/11........ok
tests/open/12........ok
tests/open/13........ok
tests/open/14........ok
tests/open/15........ok
tests/open/16........ok
tests/open/17........ok
tests/open/18........ok
tests/open/19........ok
tests/open/20........ok
tests/open/21........ok
tests/open/22........ok
tests/open/23........ok
tests/rename/00......ok
tests/rename/01......ok
tests/rename/02......ok
tests/rename/03......ok
tests/rename/04......ok
tests/rename/05......ok
tests/rename/06......ok
tests/rename/07......ok
tests/rename/08......ok
tests/rename/09......ok
tests/rename/10......ok
tests/rename/11......ok
tests/rename/12......ok
tests/rename/13......ok
tests/rename/14......ok
tests/rename/15......ok
tests/rename/16......ok
tests/rename/17......ok
tests/rename/18......ok
tests/rename/19......ok
tests/rename/20......ok
tests/rmdir/00.......ok
tests/rmdir/01.......ok
tests/rmdir/02.......ok
tests/rmdir/03.......ok
tests/rmdir/04.......ok
tests/rmdir/05.......ok
tests/rmdir/06.......ok
tests/rmdir/07.......ok
tests/rmdir/08.......ok
tests/rmdir/09.......ok
tests/rmdir/10.......ok
tests/rmdir/11.......ok
tests/rmdir/12.......ok
tests/rmdir/13.......ok
tests/rmdir/14.......ok
tests/rmdir/15.......ok
tests/symlink/00.....ok
tests/symlink/01.....ok
tests/symlink/02.....ok
tests/symlink/03.....ok
tests/symlink/04.....ok
tests/symlink/05.....ok
tests/symlink/06.....ok
tests/symlink/07.....ok
tests/symlink/08.....ok
tests/symlink/09.....ok
tests/symlink/10.....ok
tests/symlink/11.....ok
tests/symlink/12.....ok
tests/truncate/00....FAILED test 15
        Failed 1/21 tests, 95.24% okay
tests/truncate/01....ok
tests/truncate/02....ok
tests/truncate/03....ok
tests/truncate/04....ok
tests/truncate/05....ok
tests/truncate/06....ok
tests/truncate/07....ok
tests/truncate/08....ok
tests/truncate/09....ok
tests/truncate/10....ok
tests/truncate/11....ok
tests/truncate/12....ok
tests/truncate/13....ok
tests/truncate/14....ok
tests/unlink/00......ok
tests/unlink/01......ok
tests/unlink/02......ok
tests/unlink/03......ok
tests/unlink/04......ok
tests/unlink/05......ok
tests/unlink/06......ok
tests/unlink/07......ok
tests/unlink/08......ok
tests/unlink/09......ok
tests/unlink/10......ok
tests/unlink/11......ok
tests/unlink/12......ok
tests/unlink/13......ok
tests/xacl/00........FAILED test 2
        Failed 1/42 tests, 97.62% okay
tests/xacl/01........FAILED tests 2, 22
        Failed 2/32 tests, 93.75% okay
tests/xacl/02........FAILED tests 2, 41
        Failed 2/80 tests, 97.50% okay
tests/xacl/03........FAILED tests 2, 31, 35, 38, 43, 47
        Failed 6/57 tests, 89.47% okay
tests/xacl/04........FAILED tests 2, 52
        Failed 2/53 tests, 96.23% okay
tests/xacl/05........ok
tests/xacl/06........FAILED tests 16, 26-27, 30, 33-34, 36-38, 40-42
        Failed 12/42 tests, 71.43% okay
=46ailed Test         Stat Wstat Total Fail  List of Failed
-----------------------------------------------------------------------=
--------
tests/link/00.t                   82    2  56 63
tests/truncate/00.t               21    1  15
tests/xacl/00.t                   42    1  2
tests/xacl/01.t                   32    2  2 22
tests/xacl/02.t                   80    2  2 41
tests/xacl/03.t                   57    6  2 31 35 38 43 47
tests/xacl/04.t                   53    2  2 52
tests/xacl/06.t                   42   12  16 26-27 30 33-34 36-38 40-4=
2
=46ailed 8/191 test scripts. 28/2284 subtests failed.
=46iles=3D191, Tests=3D2284, 2762 wallclock secs (18.56 cusr + 179.63 c=
sys =3D 198.19 CPU)
=46ailed 8/191 test programs. 28/2284 subtests failed.



besides all that, i=B4m really impressed by btrfs and i think it`s at r=
eally good condition and quite stable.
i think i dare using it for a server to do some pre-production testing.=
=2E..

Keep up the good work!

regards
roland





> devzero@web.de wrote:
> > thank you.
> >=20
> > i tried your patch and did another test run.
> >=20
> > first, it looked better as i could do much more snapshots than befo=
re, but then it froze again.
> >=20
> > i don`t really have a clue if your patch enhanced anything, as my t=
est setup isn`t exactly  reproducable for now and i did not check for e=
xact "testing lab conditions".
> >=20
> > after /btrfs froze again, i tried to unmount by forcibly unloading =
btrfs module.=20
> >=20
> > after reloading the module and trying to mount again, it failed wit=
h the following  kernel message:
> >=20
> I hope the new patch can solve the problem.
>=20
> Yan Zheng=20
>=20
> ---
> diff -urp 1/fs/btrfs/inode.c 2/fs/btrfs/inode.c
> --- 1/fs/btrfs/inode.c	2008-12-18 08:09:16.062111805 +0800
> +++ 2/fs/btrfs/inode.c	2008-12-22 08:47:06.000000000 +0800
> @@ -2891,7 +2891,7 @@ void btrfs_delete_inode(struct inode *in
>  	btrfs_wait_ordered_range(inode, 0, (u64)-1);
> =20
>  	btrfs_i_size_write(inode, 0);
> -	trans =3D btrfs_start_transaction(root, 1);
> +	trans =3D btrfs_join_transaction(root, 1);
> =20
>  	btrfs_set_trans_block_group(trans, inode);
>  	ret =3D btrfs_truncate_inode_items(trans, root, inode, inode->i_siz=
e, 0);
> diff -urp 1/fs/btrfs/transaction.c 2/fs/btrfs/transaction.c
> --- 1/fs/btrfs/transaction.c	2008-12-13 12:35:29.487886730 +0800
> +++ 2/fs/btrfs/transaction.c	2008-12-21 19:09:09.000000000 +0800
> @@ -804,7 +804,7 @@ static noinline int finish_pending_snaps
> =20
>  	parent_inode =3D pending->dentry->d_parent->d_inode;
>  	parent_root =3D BTRFS_I(parent_inode)->root;
> -	trans =3D btrfs_start_transaction(parent_root, 1);
> +	trans =3D btrfs_join_transaction(parent_root, 1);
> =20
>  	/*
>  	 * insert the directory item
>=20


_______________________________________________________________________
T=E4glich 1.000.000 Euro gewinnen! Jetzt kostenlos WEB.DE MillionenKlic=
k=20
spielen! https://millionenklick.web.de/?mc=3Dmail@footer.mklick@home

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
