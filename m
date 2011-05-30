From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Problem with latest for-linus branch
Date: Mon, 30 May 2011 09:35:21 -0400
Message-ID: <1306762449-sup-979@shiny>
References: <BANLkTikmYx+K9crXYFeBmsJm+qUq9_W+gQ@mail.gmail.com> <1306620858-sup-7865@shiny> <BANLkTi=FPw7RwkPW0zpD05YRtt19NrZ-5A@mail.gmail.com> <1306751696-sup-7618@shiny> <BANLkTimDsRC6yNJ0R5kbBdtTyBAmcf0FfA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	"Josef Bacik" <josef@redhat.com>
To: Andrea Gelmini <andrea.gelmini@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <BANLkTimDsRC6yNJ0R5kbBdtTyBAmcf0FfA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Andrea Gelmini's message of 2011-05-30 07:59:30 -0400:
> 2011/5/30 Chris Mason <chris.mason@oracle.com>:
> > These are perfect, thank you. =C2=A0We're failing to write out the =
inode
> > cache. =C2=A0Since you're on a 32 bit machine, I'm guessing that we=
 failed to
> > kmap something properly.
>=20
> Thanks a lot for detailed info.
> I recompiled, and get this:
> gelma@dell:~$ gdb /lib/modules/3.0.0-rc1/kernel/fs/btrfs/*
> GNU gdb (Ubuntu/Linaro 7.2-1ubuntu11) 7.2
> Copyright (C) 2010 Free Software Foundation, Inc.
> License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/g=
pl.html>
> This is free software: you are free to change and redistribute it.
> There is NO WARRANTY, to the extent permitted by law.  Type "show cop=
ying"
> and "show warranty" for details.
> This GDB was configured as "i686-linux-gnu".
> For bug reporting instructions, please see:
> <http://www.gnu.org/software/gdb/bugs/>...
> Reading symbols from /lib/modules/3.0.0-rc1/kernel/fs/btrfs/btrfs.ko.=
=2E.done.
> (gdb) list *__btrfs_write_out_cache+0x43a
> 0x5fada is in __btrfs_write_out_cache (fs/btrfs/free-space-cache.c:67=
6).
> 671                struct btrfs_free_space *e;
> 672   =20
> 673                e =3D rb_entry(node, struct btrfs_free_space, offs=
et_index);
> 674                entries++;
> 675   =20
> 676                entry->offset =3D cpu_to_le64(e->offset);
> 677                entry->bytes =3D cpu_to_le64(e->bytes);
> 678                if (e->bitmap) {
> 679                    entry->type =3D BTRFS_FREE_SPACE_BITMAP;
> 680                    list_add_tail(&e->list, &bitmap_list);
> (gdb)

Ok, so I think we're blowing past the end of the page we've kmap'd.  Bu=
t
I don't think that can happen without something like the patch below
triggering:

Josef, what do you think?

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 70d4579..a95b72e 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -596,6 +596,11 @@ int __btrfs_write_out_cache(struct btrfs_root *roo=
t, struct inode *inode,
 	 */
 	first_page_offset =3D (sizeof(u32) * num_pages) + sizeof(u64);
=20
+	if (first_page_offset + sizeof(struct btrfs_free_space_entry) >=3D PA=
GE_CACHE_SIZE) {
+		printk(KERN_CRIT "bad first page offset %lu\n", first_page_offset);
+		BUG();
+	}
+
 	/* Get the cluster for this block_group if it exists */
 	if (block_group && !list_empty(&block_group->cluster_list))
 		cluster =3D list_entry(block_group->cluster_list.next,
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
