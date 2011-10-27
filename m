From: Josef Bacik <josef@redhat.com>
Subject: Re: ceph on btrfs [was Re: ceph on non-btrfs file systems]
Date: Thu, 27 Oct 2011 15:52:09 -0400
Message-ID: <20111027195209.GD2329@localhost.localdomain>
References: <Pine.LNX.4.64.1110231739380.25255@cobra.newdream.net>
 <CAO47_-9jp===DT=scpe=U8BnPnUCAVz7xUWVCC9AMVmx67CdaA@mail.gmail.com>
 <Pine.LNX.4.64.1110240941500.15349@cobra.newdream.net>
 <20111024195147.GB31264@dhcp231-156.rdu.redhat.com>
 <CAO47_-_=1uLV34WAAHFhv6z7fDmtY8L-+HUzfu=WcHNatbvxJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Josef Bacik <josef@redhat.com>, Sage Weil <sage@newdream.net>,
	ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Christian Brunner <chb@muc.de>
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <CAO47_-_=1uLV34WAAHFhv6z7fDmtY8L-+HUzfu=WcHNatbvxJQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 25, 2011 at 01:56:48PM +0200, Christian Brunner wrote:
> 2011/10/24 Josef Bacik <josef@redhat.com>:
> > On Mon, Oct 24, 2011 at 10:06:49AM -0700, Sage Weil wrote:
> >> [adding linux-btrfs to cc]
> >>
> >> Josef, Chris, any ideas on the below issues?
> >>
> >> On Mon, 24 Oct 2011, Christian Brunner wrote:
> >> >
> >> > - When I run ceph with btrfs snaps disabled, the situation is ge=
tting
> >> > slightly better. I can run an OSD for about 3 days without probl=
ems,
> >> > but then again the load increases. This time, I can see that the
> >> > ceph-osd (blkdev_issue_flush) and btrfs-endio-wri are doing more=
 work
> >> > than usual.
> >>
> >> FYI in this scenario you're exposed to the same journal replay iss=
ues that
> >> ext4 and XFS are. =A0The btrfs workload that ceph is generating wi=
ll also
> >> not be all that special, though, so this problem shouldn't be uniq=
ue to
> >> ceph.
> >>
> >
> > Can you get sysrq+w when this happens? =A0I'd like to see what btrf=
s-endio-write
> > is up to.
>=20
> Capturing this seems to be not easy. I have a few traces (see
> attachment), but with sysrq+w I do not get a stacktrace of
> btrfs-endio-write. What I have is a "latencytop -c" output which is
> interesting:
>=20
> In our Ceph-OSD server we have 4 disks with 4 btrfs filesystems. Ceph
> tries to balance the load over all OSDs, so all filesystems should ge=
t
> an nearly equal load. At the moment one filesystem seems to have a
> problem. When running with iostat I see the following
>=20
> Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s
> avgrq-sz avgqu-sz   await  svctm  %util
> sdd               0.00     0.00    0.00    4.33     0.00    53.33
> 12.31     0.08   19.38  12.23   5.30
> sdc               0.00     1.00    0.00  228.33     0.00  1957.33
> 8.57    74.33  380.76   2.74  62.57
> sdb               0.00     0.00    0.00    1.33     0.00    16.00
> 12.00     0.03   25.00  19.75   2.63
> sda               0.00     0.00    0.00    0.67     0.00     8.00
> 12.00     0.01   19.50  12.50   0.83
>=20
> The PID of the ceph-osd taht is running on sdc is 2053 and when I loo=
k
> with top I see this process and a btrfs-endio-writer (PID 5447):
>=20
>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
>  2053 root      20   0  537m 146m 2364 S 33.2  0.6  43:31.24 ceph-osd
>  5447 root      20   0     0    0    0 S 22.6  0.0  19:32.18 btrfs-en=
dio-wri
>=20
> In the latencytop output you can see that those processes have a much
> higher latency, than the other ceph-osd and btrfs-endio-writers.
>=20
> Regards,
> Christian

Ok just a shot in the dark, but could you give this a whirl and see if =
it helps
you?  Thanks

Josef


diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 125cf76..fbc196e 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -210,9 +210,9 @@ int btrfs_delayed_ref_lock(struct btrfs_trans_handl=
e *trans,
 }
=20
 int btrfs_find_ref_cluster(struct btrfs_trans_handle *trans,
-			   struct list_head *cluster, u64 start)
+			   struct list_head *cluster, u64 start, unsigned long max_count)
 {
-	int count =3D 0;
+	unsigned long count =3D 0;
 	struct btrfs_delayed_ref_root *delayed_refs;
 	struct rb_node *node;
 	struct btrfs_delayed_ref_node *ref;
@@ -242,7 +242,7 @@ int btrfs_find_ref_cluster(struct btrfs_trans_handl=
e *trans,
 			node =3D rb_first(&delayed_refs->root);
 	}
 again:
-	while (node && count < 32) {
+	while (node && count < max_count) {
 		ref =3D rb_entry(node, struct btrfs_delayed_ref_node, rb_node);
 		if (btrfs_delayed_ref_is_head(ref)) {
 			head =3D btrfs_delayed_node_to_head(ref);
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index e287e3b..b15a6ad 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -169,7 +169,8 @@ btrfs_find_delayed_ref_head(struct btrfs_trans_hand=
le *trans, u64 bytenr);
 int btrfs_delayed_ref_lock(struct btrfs_trans_handle *trans,
 			   struct btrfs_delayed_ref_head *head);
 int btrfs_find_ref_cluster(struct btrfs_trans_handle *trans,
-			   struct list_head *cluster, u64 search_start);
+			   struct list_head *cluster, u64 search_start,
+			   unsigned long max_count);
 /*
  * a node might live in a head or a regular ref, this lets you
  * test for the proper type to use.
diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index 31d84e7..c190282 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -81,6 +81,7 @@ int btrfs_insert_xattr_item(struct btrfs_trans_handle=
 *trans,
 	u32 data_size;
=20
 	BUG_ON(name_len + data_len > BTRFS_MAX_XATTR_SIZE(root));
+	WARN_ON(trans->endio);
=20
 	key.objectid =3D objectid;
 	btrfs_set_key_type(&key, BTRFS_XATTR_ITEM_KEY);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 4eb7d2b..0977a10 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2295,7 +2295,7 @@ again:
 		 * lock
 		 */
 		ret =3D btrfs_find_ref_cluster(trans, &cluster,
-					     delayed_refs->run_delayed_start);
+					     delayed_refs->run_delayed_start, count);
 		if (ret)
 			break;
=20
@@ -2338,7 +2338,8 @@ again:
 			node =3D rb_next(node);
 		}
 		spin_unlock(&delayed_refs->lock);
-		schedule_timeout(1);
+		if (need_resched())
+			schedule_timeout(1);
 		goto again;
 	}
 out:
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index f12747c..73a5e66 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1752,6 +1752,7 @@ static int btrfs_finish_ordered_io(struct inode *=
inode, u64 start, u64 end)
 	else
 		trans =3D btrfs_join_transaction(root);
 	BUG_ON(IS_ERR(trans));
+	trans->endio =3D 1;
 	trans->block_rsv =3D &root->fs_info->delalloc_block_rsv;
=20
 	if (test_bit(BTRFS_ORDERED_COMPRESSED, &ordered_extent->flags))
@@ -2057,8 +2058,11 @@ void btrfs_run_delayed_iputs(struct btrfs_root *=
root)
 	LIST_HEAD(list);
 	struct btrfs_fs_info *fs_info =3D root->fs_info;
 	struct delayed_iput *delayed;
+	struct btrfs_trans_handle *trans;
 	int empty;
=20
+	trans =3D current->journal_info;
+	WARN_ON(trans && trans->endio);
 	spin_lock(&fs_info->delayed_iput_lock);
 	empty =3D list_empty(&fs_info->delayed_iputs);
 	spin_unlock(&fs_info->delayed_iput_lock);
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index a1c9404..ab68cfa 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -527,12 +527,15 @@ int btrfs_wait_ordered_extents(struct btrfs_root =
*root,
  */
 int btrfs_run_ordered_operations(struct btrfs_root *root, int wait)
 {
+	struct btrfs_trans_handle *trans;
 	struct btrfs_inode *btrfs_inode;
 	struct inode *inode;
 	struct list_head splice;
=20
+	trans =3D (struct btrfs_trans_handle *)current->journal_info;
 	INIT_LIST_HEAD(&splice);
=20
+	WARN_ON(trans && trans->endio);
 	mutex_lock(&root->fs_info->ordered_operations_mutex);
 	spin_lock(&root->fs_info->ordered_extent_lock);
 again:
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 29bef63..009d2db 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -310,6 +310,7 @@ again:
 	h->use_count =3D 1;
 	h->block_rsv =3D NULL;
 	h->orig_rsv =3D NULL;
+	h->endio =3D 0;
=20
 	smp_mb();
 	if (cur_trans->blocked && may_wait_transaction(root, type)) {
@@ -467,20 +468,17 @@ static int __btrfs_end_transaction(struct btrfs_t=
rans_handle *trans,
 	while (count < 4) {
 		unsigned long cur =3D trans->delayed_ref_updates;
 		trans->delayed_ref_updates =3D 0;
-		if (cur &&
-		    trans->transaction->delayed_refs.num_heads_ready > 64) {
-			trans->delayed_ref_updates =3D 0;
-
-			/*
-			 * do a full flush if the transaction is trying
-			 * to close
-			 */
-			if (trans->transaction->delayed_refs.flushing)
-				cur =3D 0;
-			btrfs_run_delayed_refs(trans, root, cur);
-		} else {
+		if (!cur ||
+		    trans->transaction->delayed_refs.num_heads_ready <=3D 64)
 			break;
-		}
+
+		/*
+		 * do a full flush if the transaction is trying
+		 * to close
+		 */
+		if (trans->transaction->delayed_refs.flushing && throttle)
+			cur =3D 0;
+		btrfs_run_delayed_refs(trans, root, cur);
 		count++;
 	}
=20
@@ -498,6 +496,7 @@ static int __btrfs_end_transaction(struct btrfs_tra=
ns_handle *trans,
 			 * our use_count.
 			 */
 			trans->use_count++;
+			WARN_ON(trans->endio);
 			return btrfs_commit_transaction(trans, root);
 		} else {
 			wake_up_process(info->transaction_kthread);
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 02564e6..7eae404 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -55,6 +55,7 @@ struct btrfs_trans_handle {
 	struct btrfs_transaction *transaction;
 	struct btrfs_block_rsv *block_rsv;
 	struct btrfs_block_rsv *orig_rsv;
+	unsigned endio;
 };
=20
 struct btrfs_pending_snapshot {
--
To unsubscribe from this list: send the line "unsubscribe ceph-devel" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
