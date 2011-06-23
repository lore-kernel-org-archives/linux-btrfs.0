From: Daniel J Blueman <daniel.blueman@gmail.com>
Subject: [PATCH v2] btrfs: fix oops on failure path
Date: Thu, 23 Jun 2011 23:01:01 +0800
Message-ID: <BANLkTindeWYaCu3ppdHK9sgOMRcFoAU+sw@mail.gmail.com>
References: <BANLkTimrzmLdgg6NN_vU-Q6Euh1sE8SNNg@mail.gmail.com>
	<20110623103109.GN12709@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Linux BTRFS <linux-btrfs@vger.kernel.org>
To: dave@jikos.cz, Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110623103109.GN12709@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On 23 June 2011 18:31, David Sterba <dave@jikos.cz> wrote:
> Hi,
>
> On Sun, Jun 19, 2011 at 06:53:28PM +0800, Daniel J Blueman wrote:
>> I hit this BTRFS oops [1] in 3.0-rc3, clearly due to filesystem corruption.
>>
>> If lookup_extent_backref fails, path->nodes[0] reasonably could be
>> null, so look before leaping [2].

> I think the check should be placed into btrfs_print_leaf, this function
> is mostly called before a BUG after some error condition. The
> extent_buffer leaf argument could be NULL in more cases (i've seen at
> least another 2). Otherwise the if-NULL check would have to be placed
> before each call of btrfs_print_leaf.

The other cases where btrfs_print_leaf can be called with NULL are a
good reason. Updated patch:
(how does one follow up an email in git send-email with the message id?)

If lookup_extent_backref fails, path->nodes[0] reasonably could be
null along with other callers of btrfs_print_leaf, so ensure we have a
valid extent buffer before dereferencing.

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>

diff --git a/fs/btrfs/print-tree.c b/fs/btrfs/print-tree.c
index fb2605d..f38e452 100644
--- a/fs/btrfs/print-tree.c
+++ b/fs/btrfs/print-tree.c
@@ -158,8 +158,7 @@ static void print_extent_ref_v0(struct
extent_buffer *eb, int slot)
 void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 {
 	int i;
-	u32 type;
-	u32 nr = btrfs_header_nritems(l);
+	u32 type, nr;
 	struct btrfs_item *item;
 	struct btrfs_root_item *ri;
 	struct btrfs_dir_item *di;
@@ -172,6 +171,11 @@ void btrfs_print_leaf(struct btrfs_root *root,
struct extent_buffer *l)
 	struct btrfs_key key;
 	struct btrfs_key found_key;

+	if (!l)
+		return;
+
+	nr = btrfs_header_nritems(l);
+
 	printk(KERN_INFO "leaf %llu total ptrs %d free space %d\n",
 		(unsigned long long)btrfs_header_bytenr(l), nr,
 		btrfs_leaf_free_space(root, l));
-- 
Daniel J Blueman
