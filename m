Return-Path: <SRS0=VtQK=PK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A337AC43387
	for <linux-btrfs@archiver.kernel.org>; Wed,  2 Jan 2019 16:21:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7479F20643
	for <linux-btrfs@archiver.kernel.org>; Wed,  2 Jan 2019 16:21:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729471AbfABQVo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 2 Jan 2019 11:21:44 -0500
Received: from mx2.suse.de ([195.135.220.15]:36598 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726934AbfABQVo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 2 Jan 2019 11:21:44 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 433A9ACD2;
        Wed,  2 Jan 2019 16:21:42 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 9F552DA781; Wed,  2 Jan 2019 17:21:13 +0100 (CET)
Date:   Wed, 2 Jan 2019 17:21:13 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFC 0/2] Use new incompat feature BG_TREE to hugely
 reduce mount time
Message-ID: <20190102162113.GX23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181228083745.3134-1-wqu@suse.com>
 <38520a81-e5b0-35b5-bf81-966ea6ef2c45@suse.com>
 <d4ee763f-19b4-e50f-1746-d2ca4152a3c5@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d4ee763f-19b4-e50f-1746-d2ca4152a3c5@gmx.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Dec 28, 2018 at 05:28:13PM +0800, Qu Wenruo wrote:
> On 2018/12/28 下午5:15, Nikolay Borisov wrote:
> > On 28.12.18 г. 10:37 ч., Qu Wenruo wrote:
> >> This patchset can be fetched from:
> >> https://github.com/adam900710/linux/tree/bg_tree
> >> Which is based on v4.20-rc1 tag.
> >>
> >> This patchset will hugely reduce mount time of large fs by putting all
> >> block group items into its own tree.
> >>
> >> The old behavior will try to read out all block group items at mount
> >> time, however due to the key of block group items are scattered across
> >> tons of extent items, we must call btrfs_search_slot() for each block
> >> group.
> >>
> >> It works fine for small fs, but when number of block groups goes beyond
> >> 200, such tree search will become a random read, causing obvious slow
> >> down.
> >>
> >> On the other hand, btrfs_read_chunk_tree() is still very fast, since we
> >> put CHUNK_ITEMS into their own tree and package them next to each other.
> >>
> >>
> >> Following this idea, we could do the same thing for block group items,
> >> so instead of triggering btrfs_search_slot() for each block group, we
> >> just call btrfs_next_item() and under most case we could finish in
> >> memory, and hugely speed up mount (see BENCHMARK below).
> >>
> >> The only disadvantage is, this method introduce an incompatible feature,
> >> so existing fs can't use this feature directly.
> >> Either specify it at mkfs time, or use btrfs-progs offline convert tool
> >> (*).
> > 
> > What if we start recording block group items in the chunk tree?
> 
> Then chunk tree will be too hot.
> 
> Currently chunk tree is pretty stable, only get modified at bg
> creation/deletion time.
> 
> Considering how important chunk tree is, I prefer to make chunk root as
> cold as possible.
> 
> On the other hand, block group items are pretty hot (although less hot
> compared to old extent tree), so it still makes sense to put them into
> one tree, allow chunk tree to be as cold as ice, while keep block group
> items relatively safe compared to old extent tree.

A feature like this should come with an analysis of both approaches in
advance. Both have pros and cons that we need to weigh. Eg. I'm not more
for storing the items in an existing tree, possibly creating a new tree
item that would pack the bg items together at the beginning of the tree.

The update frequency of the tree is an aspect that I haven't considered
before but I think it's a good point.

The tree holding the bg items can be considered fundamental and requires
a backup pointer in the superblock. So this would need more work.
