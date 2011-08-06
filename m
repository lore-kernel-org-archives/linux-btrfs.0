From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Subject: help recover from unmountable btrfs
Date: Sat, 06 Aug 2011 12:27:56 -0300
Message-ID: <oripqad0g3.fsf@livre.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-btrfs@vger.kernel.org
To: mpiechotka <uzytkownik2@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

After running one too many times into =E2=80=9Cparent transid verify fa=
iled=E2=80=9D
that prevents a filesystem from being mounted, I found out how to adjus=
t
some system blocks so that the kernel could get past that check and
mount the filesystem.  In one case, I could get all the data I wanted
from the filesystem; in another, many checksums failed and I ended up
throwing it all away, so no guarrantees.  mpiechotka's running into the
problem and bringing it up on IRC prompted me to post for wider
consumption this patch for btrfsck, that will tell you what to do to
make the filesystem mountable again.

Add verbosity to btrfsck so that we can manually recover from a failure
to update the roots.

Signed-off-by: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
---
 disk-io.c |   41 +++++++++++++++++++++++++++++++++++++++++
 volumes.c |    3 +++
 2 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/disk-io.c b/disk-io.c
index a6e1000..6860c26 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -87,6 +87,22 @@ int csum_tree_block_size(struct extent_buffer *buf, =
u16 csum_size,
 			printk("checksum verify failed on %llu wanted %X "
 			       "found %X\n", (unsigned long long)buf->start,
 			       *((int *)result), *((char *)buf->data));
+			if (csum_size =3D=3D 4) {
+			  fprintf(stderr, "dd if=3D(fd %i) bs=3D1c skip=3D%llu count=3D4 | =
od -t x1:\n%02x %02x %02x %02x\n",
+				  buf->fd,
+				  (unsigned long long)buf->dev_bytenr,
+				  (__u8)buf->data[0],
+				  (__u8)buf->data[1],
+				  (__u8)buf->data[2],
+				  (__u8)buf->data[3]);
+			  fprintf(stderr, "printf \"\\x%02x\\x%02x\\x%02x\\x%02x\" | dd of=3D=
(fd %i) bs=3D1c seek=3D%llu conv=3Dnotrunc count=3D4\n",
+				  (__u8)result[0],
+				  (__u8)result[1],
+				  (__u8)result[2],
+				  (__u8)result[3],
+				  buf->fd,
+				  (unsigned long long)buf->dev_bytenr);
+			}
 			free(result);
 			return 1;
 		}
@@ -165,6 +181,31 @@ static int verify_parent_transid(struct extent_io_=
tree *io_tree,
 	       (unsigned long long)eb->start,
 	       (unsigned long long)parent_transid,
 	       (unsigned long long)btrfs_header_generation(eb));
+	fprintf(stderr, "dd if=3D(fd %i) bs=3D1c skip=3D%llu count=3D8 | od -=
t x1:\n%02x %02x %02x %02x %02x %02x %02x %02x\n",
+		eb->fd,
+		(unsigned long long)eb->dev_bytenr
+		+ offsetof (struct btrfs_header, generation),
+		(__u8)eb->data[offsetof (struct btrfs_header, generation)],
+		(__u8)eb->data[offsetof (struct btrfs_header, generation) + 1],
+		(__u8)eb->data[offsetof (struct btrfs_header, generation) + 2],
+		(__u8)eb->data[offsetof (struct btrfs_header, generation) + 3],
+		(__u8)eb->data[offsetof (struct btrfs_header, generation) + 4],
+		(__u8)eb->data[offsetof (struct btrfs_header, generation) + 5],
+		(__u8)eb->data[offsetof (struct btrfs_header, generation) + 6],
+		(__u8)eb->data[offsetof (struct btrfs_header, generation) + 7]);
+	btrfs_set_header_generation(eb, parent_transid);
+	fprintf(stderr, "printf \"\\x%02x\\x%02x\\x%02x\\x%02x\\x%02x\\x%02x\=
\x%02x\\x%02x\" | dd of=3D(fd %i) bs=3D1c seek=3D%llu conv=3Dnotrunc co=
unt=3D8\n",
+		(__u8)eb->data[offsetof (struct btrfs_header, generation)],
+		(__u8)eb->data[offsetof (struct btrfs_header, generation) + 1],
+		(__u8)eb->data[offsetof (struct btrfs_header, generation) + 2],
+		(__u8)eb->data[offsetof (struct btrfs_header, generation) + 3],
+		(__u8)eb->data[offsetof (struct btrfs_header, generation) + 4],
+		(__u8)eb->data[offsetof (struct btrfs_header, generation) + 5],
+		(__u8)eb->data[offsetof (struct btrfs_header, generation) + 6],
+		(__u8)eb->data[offsetof (struct btrfs_header, generation) + 7],
+		eb->fd,
+		(unsigned long long)eb->dev_bytenr
+		+ offsetof (struct btrfs_header, generation));
 	ret =3D 1;
 out:
 	clear_extent_buffer_uptodate(io_tree, eb);
diff --git a/volumes.c b/volumes.c
index 7671855..c30a3ba 100644
--- a/volumes.c
+++ b/volumes.c
@@ -188,6 +188,9 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_=
devices, int flags)
 		device->fd =3D fd;
 		if (flags =3D=3D O_RDWR)
 			device->writeable =3D 1;
+		fprintf(stderr, "Device %llu (%s) opened in fd %i\n",
+			(unsigned long long)device->devid,
+			device->name, device->fd);
 	}
 	return 0;
 fail:
--=20
1.7.4.4


--=20
Alexandre Oliva, freedom fighter    http://FSFLA.org/~lxoliva/
You must be the change you wish to see in the world. -- Gandhi
Be Free! -- http://FSFLA.org/   FSF Latin America board member
=46ree Software Evangelist      Red Hat Brazil Compiler Engineer
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
