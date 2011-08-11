From: Jeff Mahoney <jeffm@suse.de>
Subject: Re: [patch 3/9] btrfs: Push up set_extent_bit errors to callers
Date: Wed, 10 Aug 2011 20:08:31 -0400
Message-ID: <4E431D7F.9060801@suse.de>
References: <20110810232027.129702612@suse.com> <20110810232122.682680870@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110810232122.682680870@suse.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 08/10/2011 07:20 PM, Jeff Mahoney wrote:
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c

[...]

Oops. This is missing one more case. I'll re-send this one as part
of a general post-review re-send.

@@ -3292,8 +3316,10 @@ int set_extent_buffer_uptodate(struct ex
 	num_pages = num_extent_pages(eb->start, eb->len);
 
 	if (eb_straddles_pages(eb)) {
-		set_extent_uptodate(tree, eb->start, eb->start + eb->len - 1,
-				    NULL, GFP_NOFS);
+		int ret = set_extent_uptodate(tree, eb->start,
+					      eb->start + eb->len - 1,
+					      NULL, GFP_NOFS);
+		BUG_ON(ret < 0);
 	}
 	for (i = 0; i < num_pages; i++) {
 		page = extent_buffer_page(eb, i);

-Jeff

-- 
Jeff Mahoney
SUSE Labs
