From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] NFS support for btrfs - v2
Date: Tue, 19 Aug 2008 22:34:43 +0100
Message-ID: <1219181683.2988.16.camel@pmac.infradead.org>
References: <200807210201.56690.balajirrao@gmail.com>
	 <200808171821.43874.balajirrao@gmail.com>
	 <1218977763.3184.288.camel@pmac.infradead.org>
	 <200808171854.14275.balajirrao@gmail.com>
	 <1218980439.3184.304.camel@pmac.infradead.org>
	 <1219087412.14063.22.camel@think.oraclecorp.com>
	 <1219088029.3184.413.camel@pmac.infradead.org>
	 <1219088859.14063.35.camel@think.oraclecorp.com>
	 <1219090839.3184.436.camel@pmac.infradead.org>
	 <1219091550.14063.44.camel@think.oraclecorp.com>
	 <1219096342.3184.453.camel@pmac.infradead.org>
	 <1219146885.14063.54.camel@think.oraclecorp.com>
	 <1219157352.3184.481.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Balaji Rao <balajirrao@gmail.com>, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1219157352.3184.481.camel@pmac.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2008-08-19 at 15:49 +0100, David Woodhouse wrote:
> On Tue, 2008-08-19 at 07:54 -0400, Chris Mason wrote:
> > 
> > > What if the parent inode actually _is_ inode #0xffffffffffffffff? Can
> > > that happen? In that case it would return zero, and I shouldn't subtract
> > > 1 from the slot number -- I've actually found what I'm looking for?
> > > 
> > 
> > The max inode will be 2^64 - 1
> 
> Which is what we're searching for -- so it's _possible_, albeit
> vanishingly unlikely, that btrfs_search_slot() will actually return
> zero, having found precisely what we wanted?
> 
> And in that case, path->slots[0] being zero is fine. And we shouldn't be
> subtracting one from it to find the slot we want?

Subject: [PATCH] Clean up btrfs_get_parent() a little more, fix a free-after-free bug

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---
 export.c |   33 +++++++++++++++++++--------------
 1 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/export.c b/export.c
index 36cbc68..5c75cbd 100644
--- a/export.c
+++ b/export.c
@@ -165,23 +165,32 @@ static struct dentry *btrfs_get_parent(struct dentry *child)
 	key.offset = (u64)-1;
 
 	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
-	leaf = path->nodes[0];
-	slot = path->slots[0];
-	if (ret < 0 || slot == 0) {
+	if (ret < 0) {
+		/* Error */
 		btrfs_free_path(path);
-		goto out;
+		return ERR_PTR(ret);
+	}
+	if (ret) {
+		leaf = path->nodes[0];
+		slot = path->slots[0];
+		/* btrfs_search_slot() returns the slot where we'd want to
+		   insert a backref for parent inode #0xFFFFFFFFFFFFFFFF.
+		   The _real_ backref, telling us what the parent inode
+		   _actually_ is, will be in the slot _before_ the one
+		   that btrfs_search_slot() returns. */
+		if (!slot) {
+			/* Unless there is _no_ key in the tree before... */
+			btrfs_free_path(path);
+			return ERR_PTR(-EIO);
+		}
+		slot--;
 	}
-	/* btrfs_search_slot() returns the slot where we'd want to insert
-	   an INODE_REF_KEY for parent inode #0xFFFFFFFFFFFFFFFF. The _real_
-	   one, telling us what the parent inode _actually_ is, will be in
-	   the slot _before_ the one that btrfs_search_slot() returns. */
-	slot--;
 
 	btrfs_item_key_to_cpu(leaf, &key, slot);
 	btrfs_free_path(path);
 
 	if (key.objectid != dir->i_ino || key.type != BTRFS_INODE_REF_KEY)
-		goto out;
+		return ERR_PTR(-EINVAL);
 
 	objectid = key.offset;
 
@@ -201,10 +210,6 @@ static struct dentry *btrfs_get_parent(struct dentry *child)
 		parent = ERR_PTR(-ENOMEM);
 
 	return parent;
-
-out:
-	btrfs_free_path(path);
-	return ERR_PTR(-EINVAL);
 }
 
 const struct export_operations btrfs_export_ops = {
-- 
1.5.5.1


-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



