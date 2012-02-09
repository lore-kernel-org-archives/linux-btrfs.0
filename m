From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: Re: Premature ENOSPC only with zlib Compression
Date: Thu, 09 Feb 2012 10:14:29 +0800
Message-ID: <4F332C05.1080808@cn.fujitsu.com>
References: <CAKcLGm--EKeAbw7JzBtv7snhXEJSzTMZjn9_QDT+jGRCWsjM2g@mail.gmail.com> <CAKcLGm-ps-B9jZ8Xyxy0BduDcgzEtwsy0FzFhmV1GWZ_MP8q2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAKcLGm-ps-B9jZ8Xyxy0BduDcgzEtwsy0FzFhmV1GWZ_MP8q2g@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 02/09/2012 05:01 AM, Mitch Harder wrote:
> On Wed, Jan 18, 2012 at 10:13 AM, Mitch Harder
> <mitch.harder@sabayonlinux.org> wrote:
>> I have a Btrfs partition that is reliably reproducing premature ENOSPC
>> when restoring the disk from a tar file, but it is only happening with
>> zlib compression (lzo or no compression proceeds normally).
>>
>> I've had the same issue at least back through the 3.1 kernel series,
>> and I've been having intermittent issues even further back.
>>
>> I am currently using a 3.2.1 kernel merged with Chris' latest
>> integration branch.
>>
>> I've performed about 12 trials trying to explore various combinations
>> of compress, compress-force, compress[-force]=[zlib,lzo] and
>> autodefrag.
>>
>> If I use no compression, or if I explicitly declare lzo compression, I
>> don't receive the premature ENOSPC when untarring my restoration
>> archive to the empty partition.
>>
>> If I don't specify compression (zlib is the default) or specify zlib,
>> I get consistent premature ENOSPC errors regardless of other
>> combinations.
>>
>> I apologize if this is already general knowledge, but I couldn't see
>> where this has been posted to the list before.
>>
>> As time allows, I will try to capture exactly where this ENOSPC is
>> being issued in btrfs by inserting WARN_ON's in my local version
>> where-ever ENOSPC is set.
> 
> Some follow-up...
> 
> I've injected some debugging code to isolate when the ENOSPC is being
> generated when using zlib compression.
> 
> When using zlib, I'm getting intermittent ENOSPC in the
> may_commit_transaction() function in extent-tree.c at this point:
> 
> 	if (delayed_rsv->size < bytes) {
> 		spin_unlock(&delayed_rsv->lock);
> 		return -ENOSPC;
> 	}
> 
> The typical values for (delayed_rsv->size < bytes) have been:
> delayed_rsv->size ( = 0x60000) < bytes ( = 0x78000)
> 
> This typically occurs when unzipping a section of my backup that
> contains lots of small files that are probably being mostly in-lined.
> 
> I don't see errors in this section when using lzo or no compression.

Hi Mitch,

Would you like to try this patch? 

thanks,
liubo

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 8603ee4..d83b15e 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3483,28 +3483,34 @@ static int may_commit_transaction(struct btrfs_root *root,
 	if (force)
 		goto commit;
 
-	/* See if there is enough pinned space to make this reservation */
-	spin_lock(&space_info->lock);
-	if (space_info->bytes_pinned >= bytes) {
+	if (space_info != delayed_rsv->space_info) {
+		/*
+		 * For DATA:
+		 * See if there is enough pinned space to make this reservation
+		 */
+		spin_lock(&space_info->lock);
+		if (space_info->bytes_pinned < bytes) {
+			spin_unlock(&space_info->lock);
+			return -ENOSPC;
+		}
 		spin_unlock(&space_info->lock);
-		goto commit;
-	}
-	spin_unlock(&space_info->lock);
-
-	/*
-	 * See if there is some space in the delayed insertion reservation for
-	 * this reservation.
-	 */
-	if (space_info != delayed_rsv->space_info)
-		return -ENOSPC;
-
-	spin_lock(&delayed_rsv->lock);
-	if (delayed_rsv->size < bytes) {
+	} else {
+		/*
+		 * For METADATA:
+		 * See if there is enough space(pinned and delayed insertion)
+		 * to make this reservation
+		 */
+		spin_lock(&space_info->lock);
+		spin_lock(&delayed_rsv->lock);
+		if (space_info->bytes_pinned + delayed_rsv->size < bytes) {
+			spin_unlock(&delayed_rsv->lock);
+			spin_unlock(&space_info->lock);
+			return -ENOSPC;
+		}
 		spin_unlock(&delayed_rsv->lock);
-		return -ENOSPC;
-	}
-	spin_unlock(&delayed_rsv->lock);
+		spin_unlock(&space_info->lock);
 
+	}
 commit:
 	trans = btrfs_join_transaction(root);
 	if (IS_ERR(trans))
-- 
1.6.5.2


> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

