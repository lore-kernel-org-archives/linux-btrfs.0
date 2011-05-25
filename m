From: liubo <liubo2009@cn.fujitsu.com>
Subject: Re: [PATCH 1/9] Btrfs: introduce sub transaction stuff
Date: Tue, 24 May 2011 23:56:56 -0400
Message-ID: <4DDC7E08.4020207@cn.fujitsu.com>
References: <1305792692-10635-1-git-send-email-liubo2009@cn.fujitsu.com> <1305792692-10635-2-git-send-email-liubo2009@cn.fujitsu.com> <1305850961-sup-454@shiny> <1306161195-sup-8189@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, josef <josef@redhat.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1306161195-sup-8189@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On 05/23/2011 10:40 AM, Chris Mason wrote:
> Excerpts from Chris Mason's message of 2011-05-19 20:23:29 -0400:
>> Excerpts from Liu Bo's message of 2011-05-19 04:11:24 -0400:
>>> Introduce a new concept "sub transaction",
>>> the relation between transaction and sub transaction is
>>>
>>> transaction A       ---> transid = x
>>>    sub trans a(1)   ---> sub_transid = x+1
>>>    sub trans a(2)   ---> sub_transid = x+2
>>>      ... ...
>>>    sub trans a(n-1) ---> sub_transid = x+n-1
>>>    sub trans a(n)   ---> sub_transid = x+n
>>> transaction B       ---> transid = x+n+1
>>>      ... ...
>>>
>>> And the most important is
>>> a) a trans handler's transid now gets value from sub transid instead of transid.
>>> b) when a transaction commits, transid may not added by 1, but depend on the
>>>    biggest sub_transaction of the last neighbour transaction,
>>>    i.e.
>>>         B->transid = a(n)->transid + 1,
>>>         (B->transid - A->transid) >= 1
>>> c) we start a new sub transaction after a fsync.
>>>
>>> We also ship some 'trans->transid' to 'trans->transaction->transid' to
>>> ensure btrfs works well and to get rid of WARNings.
>>>
>>> These are used for the new log code.
>> This is exactly what I had in mind.  I need to read it harder and make
>> sure it interacts well with the directory logging code, but I love it.
> 
> Ok, I hit a few problems with this, and since the transids are used
> everywhere for various reasons, I think we need to wait until 2.6.41.
> This code is really very close to right, but we have the delayed inode
> work, scrub, and the new inode number allocator all at once.  I'd like
> to limit the size of the changes.
> 

I agree with this, in fact, I'm a litter worried cause it is such an
important role that the transids are playing in btrfs, which means
to change it is dangerous, so it deserves more test.

> The problems I hit:
> 
> When an inode is dropped from cache (just via iput) and then read in
> again, the BTRFS_I(inode)->logged_trans goes back to zero.  When this
> happens the logging code assumes the inode isn't in the log and hits
> -EEXIST if it finds inode items.
> 

ok, I just find where the problem addresses.  This is because I've put
a check between logged_trans and transaction_id, which is inclined to
filter those that are first logged, and I'm sorry for not taking the
'iput' stuff into consideration.  And it's easy to fix this, as we
can just kick this check off and put another check while searching
'BTRFS_INODE_ITEM_KEY', since if we cannot find a inode item in a tree,
it proves that this inode is definitely not in the tree.

So I'd like to make some changes like this patch(_UNTEST_):

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 912397c..69ddbbd 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2569,10 +2569,6 @@ static int prepare_for_merge_items(struct btrfs_trans_handle *trans,
 	int i;
 	int ret;
 
-	/* There are no relative items of the inode in log. */
-	if (BTRFS_I(inode)->logged_trans < trans->transaction->transid)
-		return 0;
-
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
@@ -2622,6 +2618,11 @@ static int prepare_for_merge_items(struct btrfs_trans_handle *trans,
 
 		if (ret > 0) {
 			btrfs_release_path(log, path);
+
+			/* There are no relative items of the inode in log. */
+			if (key.type == BTRFS_INODE_ITEM_KEY)
+				break;
+
 			continue;
 		}


> I patched it to just delete away all the logged items if the logged
> transid wasn't set, which is probably safest given that we can now reuse
> inode numbers.
> 
> Second, we use the generation number of the super to read in the log
> tree root after a crash.  This doesn't always match the sub trans id and
> so it doesn't always match the transid stored in the btree blocks.
> 
> There are a few solutions to this, we can use some of the reserved
> fields in the super for the generation numbers of the roots the super
> points to, and use whichever one is bigger when we read things in.
> 

All right, I'm going to dig it more.

> Liubo, since we'll leave this one for .41, I'll take your smaller patch
> that just skips the csum items.
> 

ok, I see.  Thank a lot for the review. :)

thanks,
liubo

> -chris
> 

