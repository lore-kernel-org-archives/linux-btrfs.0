Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:51823 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751212AbcC1OKU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Mar 2016 10:10:20 -0400
Date: Mon, 28 Mar 2016 10:09:52 -0400
From: Chris Mason <clm@fb.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
CC: Qu Wenruo <quwenruo@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>,
        Liu Bo <bo.li.liu@oracle.com>,
        Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: Re: [PATCH v8 10/27] btrfs: dedupe: Add basic tree structure for
 on-disk dedupe method
Message-ID: <20160328140952.xj63bgpizg2vfcex@floor.thefacebook.com>
References: <1458610552-9845-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1458610552-9845-11-git-send-email-quwenruo@cn.fujitsu.com>
 <20160324205807.ctxig7c2r4rfoowp@floor.thefacebook.com>
 <56F49B8B.4000701@cn.fujitsu.com>
 <20160325151124.hhzpyymor6varucx@floor.thefacebook.com>
 <56F68A99.8010308@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <56F68A99.8010308@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 26, 2016 at 09:11:53PM +0800, Qu Wenruo wrote:
> 
> 
> On 03/25/2016 11:11 PM, Chris Mason wrote:
> >On Fri, Mar 25, 2016 at 09:59:39AM +0800, Qu Wenruo wrote:
> >>
> >>
> >>Chris Mason wrote on 2016/03/24 16:58 -0400:
> >>>Are you storing the entire hash, or just the parts not represented in
> >>>the key?  I'd like to keep the on-disk part as compact as possible for
> >>>this part.
> >>
> >>Currently, it's entire hash.
> >>
> >>More detailed can be checked in another mail.
> >>
> >>Although it's OK to truncate the last duplicated 8 bytes(64bit) for me,
> >>I still quite like current implementation, as one memcpy() is simpler.
> >
> >[ sorry FB makes urls look ugly, so I delete them from replys ;) ]
> >
> >Right, I saw that but wanted to reply to the specific patch.  One of the
> >lessons learned from the extent allocation tree and file extent items is
> >they are just too big.  Lets save those bytes, it'll add up.
> 
> OK, I'll reduce the duplicated last 8 bytes.
> 
> And also, removing the "length" member, as it can be always fetched from
> dedupe_info->block_size.

This would mean dedup_info->block_size is a write once field.  I'm ok
with that (just like metadata blocksize) but we should make sure the
ioctls etc don't allow changing it.

> 
> The length itself is used to verify if we are at the transaction to a new
> dedupe size, but later we use full sync_fs(), such behavior is not needed
> any more.
> 
> 
> >
> >>
> >>>
> >>>>+
> >>>>+/*
> >>>>+ * Objectid: bytenr
> >>>>+ * Type: BTRFS_DEDUPE_BYTENR_ITEM_KEY
> >>>>+ * offset: Last 64 bit of the hash
> >>>>+ *
> >>>>+ * Used for bytenr <-> hash search (for free_extent)
> >>>>+ * all its content is hash.
> >>>>+ * So no special item struct is needed.
> >>>>+ */
> >>>>+
> >>>
> >>>Can we do this instead with a backref from the extent?  It'll save us a
> >>>huge amount of IO as we delete things.
> >>
> >>That's the original implementation from Liu Bo.
> >>
> >>The problem is, it changes the data backref rules(originally, only
> >>EXTENT_DATA item can cause data backref), and will make dedupe INCOMPACT
> >>other than current RO_COMPACT.
> >>So I really don't like to change the data backref rule.
> >
> >Let me reread this part, the cost of maintaining the second index is
> >dramatically higher than adding a backref.  I do agree that's its nice
> >to be able to delete the dedup trees without impacting the rest, but
> >over the long term I think we'll regret the added balances.
> 
> Thanks for pointing the problem. Yes, I didn't even consider this fact.
> 
> But, on the other hand. such remove only happens when we remove the *last*
> reference of the extent.
> So, for medium to high dedupe rate case, such routine is not that frequent,
> which will reduce the impact.
> (Which is quite different for non-dedupe case)

It's both addition and removal, and the efficiency hit does depend on
what level of sharing you're able to achieve.  But what we don't want is
for metadata usage to explode as people make small non-duplicate changes
to their FS.   If that happens, we'll only end up using dedup in back up
farms and other highly limited use cases.

I do agree that delayed refs are error prone, but that's a good reason
not fix delayed refs, not to recreate the backrefs of the extent
allocation tree in a new dedicated tree.

-chris

