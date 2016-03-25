Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:42219 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752306AbcCYPLm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Mar 2016 11:11:42 -0400
Date: Fri, 25 Mar 2016 11:11:24 -0400
From: Chris Mason <clm@fb.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
CC: <linux-btrfs@vger.kernel.org>, Liu Bo <bo.li.liu@oracle.com>,
        Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: Re: [PATCH v8 10/27] btrfs: dedupe: Add basic tree structure for
 on-disk dedupe method
Message-ID: <20160325151124.hhzpyymor6varucx@floor.thefacebook.com>
References: <1458610552-9845-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1458610552-9845-11-git-send-email-quwenruo@cn.fujitsu.com>
 <20160324205807.ctxig7c2r4rfoowp@floor.thefacebook.com>
 <56F49B8B.4000701@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <56F49B8B.4000701@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 25, 2016 at 09:59:39AM +0800, Qu Wenruo wrote:
> 
> 
> Chris Mason wrote on 2016/03/24 16:58 -0400:
> >Are you storing the entire hash, or just the parts not represented in
> >the key?  I'd like to keep the on-disk part as compact as possible for
> >this part.
> 
> Currently, it's entire hash.
> 
> More detailed can be checked in another mail.
> 
> Although it's OK to truncate the last duplicated 8 bytes(64bit) for me,
> I still quite like current implementation, as one memcpy() is simpler.

[ sorry FB makes urls look ugly, so I delete them from replys ;) ]

Right, I saw that but wanted to reply to the specific patch.  One of the
lessons learned from the extent allocation tree and file extent items is
they are just too big.  Lets save those bytes, it'll add up.

> 
> >
> >>+
> >>+/*
> >>+ * Objectid: bytenr
> >>+ * Type: BTRFS_DEDUPE_BYTENR_ITEM_KEY
> >>+ * offset: Last 64 bit of the hash
> >>+ *
> >>+ * Used for bytenr <-> hash search (for free_extent)
> >>+ * all its content is hash.
> >>+ * So no special item struct is needed.
> >>+ */
> >>+
> >
> >Can we do this instead with a backref from the extent?  It'll save us a
> >huge amount of IO as we delete things.
> 
> That's the original implementation from Liu Bo.
> 
> The problem is, it changes the data backref rules(originally, only
> EXTENT_DATA item can cause data backref), and will make dedupe INCOMPACT
> other than current RO_COMPACT.
> So I really don't like to change the data backref rule.

Let me reread this part, the cost of maintaining the second index is
dramatically higher than adding a backref.  I do agree that's its nice
to be able to delete the dedup trees without impacting the rest, but
over the long term I think we'll regret the added balances.

> 
> If only want to reduce ondisk space, just trashing the hash and making
> DEDUPE_BYTENR_ITEM have no data would be good enough.
> 
> As (bytenr, DEDEUPE_BYTENR_ITEM) can locate the hash uniquely.

For the second index, the big problem is the cost of the btree
operations.  We're already pretty expensive in terms of the cost of
deleting an extent, with dedup its 2x higher, with dedup + extra index,
its 3x higher.

> 
> In fact no code really checked the hash for dedupe bytenr item, they all
> just swap objectid and offset, reset the type and do search for
> DEDUPE_HASH_ITEM.
> 
> So it's OK to emit the hash.

If we have to go with the second index, I do agree here.

-chris
