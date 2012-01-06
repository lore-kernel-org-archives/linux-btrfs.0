From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: btrfs truncate() does not change inode times
Date: Fri, 06 Jan 2012 11:32:13 +0800
Message-ID: <4F066B3D.6000402@cn.fujitsu.com>
References: <4F05A821.8090202@tonian.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
To: idank <idank@tonian.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4F05A821.8090202@tonian.com>
List-ID: <linux-btrfs.vger.kernel.org>

idank wrote:
> Hi all,
> I was running fstest (http://www.tuxera.com/community/posix-test-suit=
e/) on btrfs. Only one test failed, and I believe it to be a bug in btr=
fs. The scenario is as follows:
> * crate a file.
> * note its times with stat.
> * sleep a few seconds
> * call truncate() on the file (not ftruncate(). ftruncate() works).
> * sync
> * note the file's times again with stat.
> expected result: ctime and mtime are greater.
> actual result: ctime and mtime remain unchanged.
>=20
> Example:

I followed your example, but got the expected result:

[root@lizf pjd-fstest-20090130-RC]# stat ctime_test=20
  File: "ctime_test"
  Size: 0               Blocks: 0          IO Block: 4096   =E6=99=AE=E9=
=80=9A=E7=A9=BA=E6=96=87=E4=BB=B6
Device: 1bh/27d Inode: 1589980     Links: 1
Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root=
)
Access: 2012-01-06 10:27:53.900570365 +0800
Modify: 2012-01-06 10:27:53.900570365 +0800
Change: 2012-01-06 10:27:53.900570365 +0800
[root@lizf pjd-fstest-20090130-RC]# ./fstest truncate ctime_test 200
0
[root@lizf pjd-fstest-20090130-RC]# sleep 2
[root@lizf pjd-fstest-20090130-RC]# stat ctime_test=20
  File: "ctime_test"
  Size: 200             Blocks: 0          IO Block: 4096   =E6=99=AE=E9=
=80=9A=E6=96=87=E4=BB=B6
Device: 1bh/27d Inode: 1589980     Links: 1
Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root=
)
Access: 2012-01-06 10:27:53.900570365 +0800
Modify: 2012-01-06 10:28:12.238569720 +0800
Change: 2012-01-06 10:28:12.238569720 +0800
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
