From: =?ISO-8859-1?Q?Bryan_=D8stergaard?= <bryan.ostergaard@gmail.com>
Subject: ctime not updated when creating hardlinks
Date: Tue, 25 Aug 2009 14:38:08 +0200
Message-ID: <73967b650908250538v14b8395akef815aae1f3ed74f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The ls-time test in coreutils-7.5 fails on btrfs filesystems. I've
tracked it down to ctime not being updated when adding hardlinks. The
following script (based on the coreutils test) shows the problem.

#!/bin/sh
touch a b

# Make sure ctime is at least one second apart
sleep 2
ln b c

# Now, C should have ctime more recent than A.
set `ls -ct a b`
if test "$*" =3D 'b a'; then
  : ok
else
  # In spite of documentation, (e.g., stat(2)), neither link nor chmod
  # update a file's st_ctime on SunOS4.1.4.
  cat >&2 << \EOF
failed ls ctime test -- this failure is expected at least for SunOS4.1.=
4
and for tmpfs file systems on Solaris 5.5.1.

In the output below, `b' should have had a ctime more recent than
that of `a', but does not.
EOF
  #'
  ls -ctl --full-time a b
fi


I'm not familiar with the btrfs code base at all but the following
patch fixes the problem and shouldn't introduce any regressions as far
as I can tell.

=46rom d66f0bcf30785e821973885f693cb285857055c4 Mon Sep 17 00:00:00 200=
1
=46rom: =3D?UTF-8?q?Bryan=3D20=3DC3=3D98stergaard?=3D <kloeri@exherbo.o=
rg>
Date: Tue, 25 Aug 2009 14:04:42 +0200
Subject: [PATCH] Fix ctime issue in btrfs

btrfs doesn't update ctime when creating new hardlinks as required by
stat(2).
---
 fs/btrfs/inode.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 59cba18..b045d42 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3879,6 +3879,7 @@ static int btrfs_link(struct dentry *old_dentry,
struct inode *dir,
 		drop_inode =3D 1;

 	btrfs_update_inode_block_group(trans, dir);
+        inode->i_ctime =3D CURRENT_TIME;
 	err =3D btrfs_update_inode(trans, root, inode);

 	if (err)
--=20
1.6.4.1


Regards,
Bryan =D8stergaard
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
