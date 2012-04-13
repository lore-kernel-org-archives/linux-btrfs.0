From: Josef Bacik <josef@redhat.com>
Subject: Re: kernel BUG at fs/btrfs/extent_io.c:1890!
Date: Fri, 13 Apr 2012 10:45:30 -0400
Message-ID: <20120413144529.GC1923@localhost.localdomain>
References: <CACfQV3hb92zrYUJ8to1mq8s1wzfdEoMBDi9b5VmfZ0AZ=UBkFA@mail.gmail.com>
 <20120411150158.GA5820@localhost.localdomain>
 <CACfQV3j_WGTB-+booc1bDMvs1i_Kjr_WAAmLKgUb9sUWe-+wPg@mail.gmail.com>
 <20120412180836.GJ1924@localhost.localdomain>
 <20120412181525.GU29506@shiny>
 <20120412182049.GK1924@localhost.localdomain>
 <CACfQV3j1X_08UJ_o-09thSUM-8SpBse9zB5eWWbuFSz5=7mWPw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Josef Bacik <josef@redhat.com>, chris.mason@oracle.com,
	linux-btrfs@vger.kernel.org
To: Francesco Cepparo <francesco.cepparo@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CACfQV3j1X_08UJ_o-09thSUM-8SpBse9zB5eWWbuFSz5=7mWPw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 12, 2012 at 09:56:30PM +0000, Francesco Cepparo wrote:
> On Thu, Apr 12, 2012 at 6:20 PM, Josef Bacik <josef@redhat.com> wrote=
:
> > On Thu, Apr 12, 2012 at 02:15:25PM -0400, Chris Mason wrote:
> >> On Thu, Apr 12, 2012 at 02:08:37PM -0400, Josef Bacik wrote:
> >> > On Wed, Apr 11, 2012 at 11:59:43PM +0000, Francesco Cepparo wrot=
e:
> >> > > I tried your patch but unfortunately the kernel still gives me=
 the
> >> > > same error message :(
> >> >
> >> > Weird, will you apply this patch on top of the one I sent you an=
d send me the
> >> > dmesg when it panics again? =A0Thanks,
> >> >
> >> > Josef
> >> >
> >> > diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> >> > index 2a3ddd2..51efb58 100644
> >> > --- a/fs/btrfs/disk-io.c
> >> > +++ b/fs/btrfs/disk-io.c
> >> > @@ -652,6 +652,8 @@ static int btree_io_failed_hook(struct page =
*page, int failed_mirror)
> >> >
> >> > =A0 =A0 eb =3D (struct extent_buffer *)page->private;
> >> > =A0 =A0 set_bit(EXTENT_BUFFER_IOERR, &eb->bflags);
> >> > + =A0 WARN_ON(!failed_mirror);
> >> > + =A0 printk(KERN_ERR "io error, failed mirror %d\n");
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ^^^^^
> >>
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 , failed_mirror
> >>
> >
> > pfft compiling debug patches before sending them out is for losers,
> >
> > Josef
>=20
> I applied your second patch on top of the first one but the dmesg
> output stays the same.... before you ask, I'm sure I'm compiling the
> kernel correctly, as putting the WARN_ON(!failed_mirror) inside the i=
f
> (!failed_mirror) on line 391 correctly prints the warnings... I'm not
> sure whether the warnings generated in that place are of any interest
> but showing them anyway can't hurt:
>=20

Oh hah I see what's happening, unapply the last patch I sent you (leave=
 the
first one in place) and apply this one, it should fix the problem.  Tha=
nks,

Josef

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 2a3ddd2..dc52f3f 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -390,8 +390,7 @@ static int btree_read_extent_buffer_pages(struct bt=
rfs_root *root,
=20
 		if (!failed_mirror) {
 			failed =3D 1;
-			printk(KERN_ERR "failed mirror was %d\n", eb->failed_mirror);
-			failed_mirror =3D eb->failed_mirror;
+			failed_mirror =3D eb->read_mirror;
 		}
=20
 		mirror_num++;
@@ -564,7 +563,7 @@ struct extent_buffer *find_eb_for_page(struct exten=
t_io_tree *tree,
 }
=20
 static int btree_readpage_end_io_hook(struct page *page, u64 start, u6=
4 end,
-			       struct extent_state *state)
+			       struct extent_state *state, int mirror)
 {
 	struct extent_io_tree *tree;
 	u64 found_start;
@@ -589,6 +588,7 @@ static int btree_readpage_end_io_hook(struct page *=
page, u64 start, u64 end,
 	if (!reads_done)
 		goto err;
=20
+	eb->read_mirror =3D mirror;
 	if (test_bit(EXTENT_BUFFER_IOERR, &eb->bflags)) {
 		ret =3D -EIO;
 		goto err;
@@ -652,7 +652,6 @@ static int btree_io_failed_hook(struct page *page, =
int failed_mirror)
=20
 	eb =3D (struct extent_buffer *)page->private;
 	set_bit(EXTENT_BUFFER_IOERR, &eb->bflags);
-	eb->failed_mirror =3D failed_mirror;
 	if (test_and_clear_bit(EXTENT_BUFFER_READAHEAD, &eb->bflags))
 		btree_readahead_hook(root, eb, eb->start, -EIO);
 	return -EIO;	/* we fixed nothing */
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 0c3ec00..7c501d3 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2297,7 +2297,7 @@ static void end_bio_extent_readpage(struct bio *b=
io, int err)
 	u64 start;
 	u64 end;
 	int whole_page;
-	int failed_mirror;
+	int mirror;
 	int ret;
=20
 	if (err)
@@ -2336,20 +2336,18 @@ static void end_bio_extent_readpage(struct bio =
*bio, int err)
 		}
 		spin_unlock(&tree->lock);
=20
+		mirror =3D (int)(unsigned long)bio->bi_bdev;
 		if (uptodate && tree->ops && tree->ops->readpage_end_io_hook) {
 			ret =3D tree->ops->readpage_end_io_hook(page, start, end,
-							      state);
+							      state, mirror);
 			if (ret)
 				uptodate =3D 0;
 			else
 				clean_io_failure(start, page);
 		}
=20
-		if (!uptodate)
-			failed_mirror =3D (int)(unsigned long)bio->bi_bdev;
-
 		if (!uptodate && tree->ops && tree->ops->readpage_io_failed_hook) {
-			ret =3D tree->ops->readpage_io_failed_hook(page, failed_mirror);
+			ret =3D tree->ops->readpage_io_failed_hook(page, mirror);
 			if (!ret && !err &&
 			    test_bit(BIO_UPTODATE, &bio->bi_flags))
 				uptodate =3D 1;
@@ -2364,8 +2362,7 @@ static void end_bio_extent_readpage(struct bio *b=
io, int err)
 			 * can't handle the error it will return -EIO and we
 			 * remain responsible for that page.
 			 */
-			ret =3D bio_readpage_error(bio, page, start, end,
-							failed_mirror, NULL);
+			ret =3D bio_readpage_error(bio, page, start, end, mirror, NULL);
 			if (ret =3D=3D 0) {
 				uptodate =3D
 					test_bit(BIO_UPTODATE, &bio->bi_flags);
@@ -4458,7 +4455,7 @@ int read_extent_buffer_pages(struct extent_io_tre=
e *tree,
 	}
=20
 	clear_bit(EXTENT_BUFFER_IOERR, &eb->bflags);
-	eb->failed_mirror =3D 0;
+	eb->read_mirror =3D 0;
 	atomic_set(&eb->io_pages, num_reads);
 	for (i =3D start_i; i < num_pages; i++) {
 		page =3D extent_buffer_page(eb, i);
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index faf10eb..b516c3b 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -79,7 +79,7 @@ struct extent_io_ops {
 					u64 start, u64 end,
 				       struct extent_state *state);
 	int (*readpage_end_io_hook)(struct page *page, u64 start, u64 end,
-				    struct extent_state *state);
+				    struct extent_state *state, int mirror);
 	int (*writepage_end_io_hook)(struct page *page, u64 start, u64 end,
 				      struct extent_state *state, int uptodate);
 	void (*set_bit_hook)(struct inode *inode, struct extent_state *state,
@@ -135,7 +135,7 @@ struct extent_buffer {
 	spinlock_t refs_lock;
 	atomic_t refs;
 	atomic_t io_pages;
-	int failed_mirror;
+	int read_mirror;
 	struct list_head leak_list;
 	struct rcu_head rcu_head;
 	pid_t lock_owner;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 261021c..77c2b03 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1947,7 +1947,7 @@ static int btrfs_writepage_end_io_hook(struct pag=
e *page, u64 start, u64 end,
  * extent_io.c will try to find good copies for us.
  */
 static int btrfs_readpage_end_io_hook(struct page *page, u64 start, u6=
4 end,
-			       struct extent_state *state)
+			       struct extent_state *state, int mirror)
 {
 	size_t offset =3D start - ((u64)page->index << PAGE_CACHE_SHIFT);
 	struct inode *inode =3D page->mapping->host;
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
