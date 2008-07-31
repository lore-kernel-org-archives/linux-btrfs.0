From: "Yan Zheng" <zheng.yan@oracle.com>
Subject: Re: [PATCH] implement memory reclaim for leaf reference cache
Date: Thu, 31 Jul 2008 19:46:27 +0800
Message-ID: <3d0408630807310446t5c45a1fdj81cb2b90e49419a7@mail.gmail.com>
References: <3d0408630807300852q28b12252g3230cc136c075ce3@mail.gmail.com>
	 <1217441674.20239.16.camel@think.oraclecorp.com>
	 <1217450892.20239.34.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: "Chris Mason" <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1217450892.20239.34.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

2008/7/31 Chris Mason <chris.mason@oracle.com>:
> On Wed, 2008-07-30 at 14:14 -0400, Chris Mason wrote:
>> On Wed, 2008-07-30 at 23:52 +0800, Yan Zheng wrote:
>> > Hello,
>> >
>> > The memory reclaiming issue happens when snapshot exists. In that
>> > case, some cache entries may not be used during old snapshot dropping,
>> > so they will remain in the cache until umount. The patch adds a field
>> > to struct btrfs_leaf_ref to record create time. Besides, the patch
>> > makes all dead roots of a given snapshot linked together in order of
>> > create time. After a old snapshot was completely dropped, we check the
>> > dead root list and remove all cache entries created before the oldest
>> > dead root in the list.
>> >
>>
>> Hi Yan,
>>
>> I think this is missing some hunks, it isn't compiling quite right:
>>
>
> Well, outside of these errors the code looks right.  I'll push it out,
> just send along an incremental if it is needed.
>

Sorry, I missed all hunks for extent-tree.c. Here is the incremental.

Regards
YZ
---
diff -r ac9bcbf9edab extent-tree.c
--- a/extent-tree.c	Wed Jul 30 16:54:26 2008 -0400
+++ b/extent-tree.c	Thu Jul 31 19:23:56 2008 +0800
@@ -1054,6 +1054,7 @@ int btrfs_inc_ref(struct btrfs_trans_han
 			goto out;
 		}

+		ref->root_gen = root->root_key.offset;
 		ref->bytenr = buf->start;
 		ref->owner = btrfs_header_owner(buf);
 		ref->generation = btrfs_header_generation(buf);
