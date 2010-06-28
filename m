From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] Btrfs-progs: Handle bad extent type case
Date: Mon, 28 Jun 2010 18:55:16 +0200
Message-ID: <1277744116-7805-2-git-send-regression-fweisbec@gmail.com>
References: <1277744116-7805-1-git-send-regression-fweisbec@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: The development of BTRFS <linux-btrfs@vger.kernel.org>,
	Frederic Weisbecker <fweisbec@gmail.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1277744116-7805-1-git-send-regression-fweisbec@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

If we meet a bad extent type, find_updated_files is going
to print random things. Better warn the user about what
happens.

This fixes:

btrfs-list.c: Dans la fonction =C2=ABfind_updated_files=C2=BB :
btrfs-list.c:668: attention : =C2=ABdisk_offset=C2=BB may be used unini=
tialized in this function
btrfs-list.c:668: note: =C2=ABdisk_offset=C2=BB was declared here
btrfs-list.c:667: attention : =C2=ABdisk_start=C2=BB may be used uninit=
ialized in this function
btrfs-list.c:667: note: =C2=ABdisk_start=C2=BB was declared here
btrfs-list.c:666: attention : =C2=ABlen=C2=BB may be used uninitialized=
 in this function
btrfs-list.c:666: note: =C2=ABlen=C2=BB was declared here
make: *** [btrfs-list.o] Erreur 1

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 btrfs-list.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 9dedb5d..c90a1e6 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -698,6 +698,15 @@ static int print_one_extent(int fd, struct btrfs_i=
octl_search_header *sh,
 		disk_start =3D 0;
 		disk_offset =3D 0;
 		len =3D btrfs_stack_file_extent_ram_bytes(item);
+	} else {
+		printf("unhandled extent type %d for inode %llu "
+		       "file offset %llu gen %llu\n",
+			type,
+			(unsigned long long)sh->objectid,
+			(unsigned long long)sh->offset,
+			(unsigned long long)found_gen);
+
+		return -EIO;
 	}
 	printf("inode %llu file offset %llu len %llu disk start %llu "
 	       "offset %llu gen %llu flags ",
--=20
1.5.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
