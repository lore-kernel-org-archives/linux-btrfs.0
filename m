From: Josef Bacik <josef@redhat.com>
Subject: Re: Btrfs bug with g38867a2 and a question
Date: Thu, 22 Sep 2011 15:00:03 -0400
Message-ID: <4E7B85B3.6080106@redhat.com>
References: <20110921185350.GA6618@kashmir> <4E7A4695.9080106@redhat.com> <20110921231055.GN22205@twin.jikos.cz> <CALiWzOg8CQJF7OfMex1uJTa+doDZ8oufV1nAbos99Z4ev-+xKg@mail.gmail.com> <4E7B423C.2080007@redhat.com> <20110922182222.GA18449@kashmir>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: dave@jikos.cz, linux-btrfs@vger.kernel.org
To: Mathieu Chouquet-Stringer <mathieu@csetco.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110922182222.GA18449@kashmir>
List-ID: <linux-btrfs.vger.kernel.org>

On 09/22/2011 02:22 PM, Mathieu Chouquet-Stringer wrote:
> On Thu, Sep 22, 2011 at 10:12:12AM -0400, Josef Bacik wrote:
>> Well that is from the tree logging code, so give this a whirl.  It's
>> going to dump a lot of info so make sure you capture everything before
>> the --- cut here --- line.  Thanks,
> 
> Here's the output of this patch:
> 
> http://mathieu.csetco.com/btrfs/IMG_20110922_200713.jpg
> http://mathieu.csetco.com/btrfs/IMG_20110922_200817.jpg
> http://mathieu.csetco.com/btrfs/IMG_20110922_200829.jpg
> http://mathieu.csetco.com/btrfs/IMG_20110922_200841.jpg
> http://mathieu.csetco.com/btrfs/IMG_20110922_200849.jpg
> http://mathieu.csetco.com/btrfs/IMG_20110922_200900.jpg
> http://mathieu.csetco.com/btrfs/IMG_20110922_200909.jpg
> http://mathieu.csetco.com/btrfs/IMG_20110922_200922.jpg

Oh wow sorry I sent you the completely wrong patch, I wish I had caught
your reply earlier.  Can you run with this patch, which is the one I
meant to give you :).  Thanks,

Josef


diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 0a8ccdb..0739498 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1319,6 +1319,7 @@ static noinline int remove_from_bitmap(struct
btrfs_free_space_ctl *ctl,
 	u64 search_start, search_bytes;
 	int ret;

+	BUG_ON(!bitmap_info->bitmap);
 again:
 	end = bitmap_info->offset + (u64)(BITS_PER_BITMAP * ctl->unit) - 1;

@@ -1336,7 +1337,21 @@ again:
 	search_bytes = *bytes;
 	search_bytes = min(search_bytes, end - search_start + 1);
 	ret = search_bitmap(ctl, bitmap_info, &search_start, &search_bytes);
-	BUG_ON(ret < 0 || search_start != *offset);
+	if (ret < 0 || search_start != *offset) {
+		struct rb_node *n;
+		struct btrfs_free_space *entry;
+
+		printk(KERN_CRIT "Couldn't find in bitmap offset=%Lu, "
+		       "bytes=%Lu, search=%Lu, search_bytes=%Lu, ret=%d\n",
+		       *offset, *bytes, search_start, search_bytes, ret);
+		for (n = rb_first(&ctl->free_space_offset); n; n = rb_next(n)) {
+			entry = rb_entry(n, struct btrfs_free_space, offset_index);
+			printk(KERN_CRIT "entry offset=%Lu, bytes=%Lu, bitmap=%s\n",
+			       entry->offset, entry->bytes,
+			       entry->bitmap ? "yes" : "no");
+		}
+		BUG();
+	}

 	if (*offset > bitmap_info->offset && *offset + *bytes > end) {
 		bitmap_clear_bits(ctl, bitmap_info, *offset, end - *offset + 1);
