From: Sergei Trofimovich <slyich@gmail.com>
Subject: [PATCH v4] btrfs: properly handle overlapping areas in memmove_extent_buffer
Date: Tue, 12 Apr 2011 00:52:52 +0300
Message-ID: <1302558772-7823-1-git-send-email-slyfox@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: chris.mason@oracle.com, Sergei Trofimovich <slyfox@gentoo.org>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

=46ix data corruption caused by memcpy() usage on overlapping data.
I've observed it first when found out usermode linux crash on btrfs.

=D0=A1all chain is the following:
------------[ cut here ]------------
WARNING: at /home/slyfox/linux-2.6/fs/btrfs/extent_io.c:3900 memcpy_ext=
ent_buffer+0x1a5/0x219()
Call Trace:
6fa39a58:  [<601b495e>] _raw_spin_unlock_irqrestore+0x18/0x1c
6fa39a68:  [<60029ad9>] warn_slowpath_common+0x59/0x70
6fa39aa8:  [<60029b05>] warn_slowpath_null+0x15/0x17
6fa39ab8:  [<600efc97>] memcpy_extent_buffer+0x1a5/0x219
6fa39b48:  [<600efd9f>] memmove_extent_buffer+0x94/0x208
6fa39bc8:  [<600becbf>] btrfs_del_items+0x214/0x473
6fa39c78:  [<600ce1b0>] btrfs_delete_one_dir_name+0x7c/0xda
6fa39cc8:  [<600dad6b>] __btrfs_unlink_inode+0xad/0x25d
6fa39d08:  [<600d7864>] btrfs_start_transaction+0xe/0x10
6fa39d48:  [<600dc9ff>] btrfs_unlink_inode+0x1b/0x3b
6fa39d78:  [<600e04bc>] btrfs_unlink+0x70/0xef
6fa39dc8:  [<6007f0d0>] vfs_unlink+0x58/0xa3
6fa39df8:  [<60080278>] do_unlinkat+0xd4/0x162
6fa39e48:  [<600517db>] call_rcu_sched+0xe/0x10
6fa39e58:  [<600452a8>] __put_cred+0x58/0x5a
6fa39e78:  [<6007446c>] sys_faccessat+0x154/0x166
6fa39ed8:  [<60080317>] sys_unlink+0x11/0x13
6fa39ee8:  [<60016b80>] handle_syscall+0x58/0x70
6fa39f08:  [<60021377>] userspace+0x2d4/0x381
6fa39fc8:  [<60014507>] fork_handler+0x62/0x69
---[ end trace 70b0ca2ef0266b93 ]---

http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg09302.html

Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
Reviewed-by: Josef Bacik <josef@redhat.com>
---
Changes since v3:
- Added Josef's Reviewed-by

Changes since v2:
- Code style cleanup
- 2 versions of patch: BUG_ON and WARN_ON variants,
   _but_ see below why I prefer BUG_ON

Changes since v1:
=20
   else
   src_kaddr =3D dst_kaddr;

 +BUG_ON(abs(src_off - dst_off)<  len);
   memcpy(dst_kaddr + dst_off, src_kaddr + src_off, len); =20

Too eager BUG_ON. Now used only for src_page =3D=3D dst_page.
=20
 -if (dst_offset<  src_offset) {
 +if (abs(dst_offset - src_offset)>=3D len) { =20

abs() is not a good thing to use un unsigned values. aded helper overla=
pping_areas.

 fs/btrfs/extent_io.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 20ddb28..10db989 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3885,6 +3885,12 @@ static void move_pages(struct page *dst_page, st=
ruct page *src_page,
 	kunmap_atomic(dst_kaddr, KM_USER0);
 }
=20
+static inline bool areas_overlap(unsigned long src, unsigned long dst,=
 unsigned long len)
+{
+	unsigned long distance =3D (src > dst) ? src - dst : dst - src;
+	return distance < len;
+}
+
 static void copy_pages(struct page *dst_page, struct page *src_page,
 		       unsigned long dst_off, unsigned long src_off,
 		       unsigned long len)
@@ -3892,10 +3898,12 @@ static void copy_pages(struct page *dst_page, s=
truct page *src_page,
 	char *dst_kaddr =3D kmap_atomic(dst_page, KM_USER0);
 	char *src_kaddr;
=20
-	if (dst_page !=3D src_page)
+	if (dst_page !=3D src_page) {
 		src_kaddr =3D kmap_atomic(src_page, KM_USER1);
-	else
+	} else {
 		src_kaddr =3D dst_kaddr;
+		BUG_ON(areas_overlap(src_off, dst_off, len));
+	}
=20
 	memcpy(dst_kaddr + dst_off, src_kaddr + src_off, len);
 	kunmap_atomic(dst_kaddr, KM_USER0);
@@ -3970,7 +3978,7 @@ void memmove_extent_buffer(struct extent_buffer *=
dst, unsigned long dst_offset,
 		       "len %lu len %lu\n", dst_offset, len, dst->len);
 		BUG_ON(1);
 	}
-	if (dst_offset < src_offset) {
+	if (!areas_overlap(src_offset, dst_offset, len)) {
 		memcpy_extent_buffer(dst, dst_offset, src_offset, len);
 		return;
 	}
--=20
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
