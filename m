Return-Path: <SRS0=U11f=M7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 432D6ECDE3D
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Oct 2018 09:15:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E905420869
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Oct 2018 09:15:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E905420869
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbeJSRUk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 19 Oct 2018 13:20:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:44890 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726399AbeJSRUk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Oct 2018 13:20:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 93747AFA1;
        Fri, 19 Oct 2018 09:15:25 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id AD718DAEE6; Fri, 19 Oct 2018 11:15:17 +0200 (CEST)
Date:   Fri, 19 Oct 2018 11:15:17 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/6] btrfs: qgroup: Introduce per-root swapped blocks
 infrastructure
Message-ID: <20181019091516.GB16290@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20181018111729.11128-1-wqu@suse.com>
 <20181018111729.11128-5-wqu@suse.com>
 <20181018162059.GJ29418@twin.jikos.cz>
 <dfa39127-3cdc-b98d-b0a0-eed82ba984a5@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dfa39127-3cdc-b98d-b0a0-eed82ba984a5@gmx.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Oct 19, 2018 at 07:29:26AM +0800, Qu Wenruo wrote:
> 
> 
> On 2018/10/19 上午12:20, David Sterba wrote:
> > On Thu, Oct 18, 2018 at 07:17:27PM +0800, Qu Wenruo wrote:
> >> +void btrfs_qgroup_clean_swapped_blocks(struct btrfs_root *root)
> >> +{
> >> +	struct btrfs_qgroup_swapped_blocks *swapped_blocks;
> >> +	struct btrfs_qgroup_swapped_block *cur, *next;
> >> +	int i;
> >> +
> >> +	swapped_blocks = &root->swapped_blocks;
> >> +
> >> +	spin_lock(&swapped_blocks->lock);
> >> +	if (!swapped_blocks->swapped)
> >> +		goto out;
> >> +	for (i = 0; i < BTRFS_MAX_LEVEL; i++) {
> >> +		struct rb_root *cur_root = &swapped_blocks->blocks[i];
> >> +
> >> +		rbtree_postorder_for_each_entry_safe(cur, next, cur_root,
> >> +						     node) {
> >> +			rb_erase(&cur->node, cur_root);
> > 
> > https://elixir.bootlin.com/linux/latest/source/include/linux/rbtree.h#L141
> > 
> > rb_erase must not be used on the same pointer that
> > rbtree_postorder_for_each_entry_safe iterates, here it's cur.
> 
> Oh, thanks for pointing this out.
> 
> So we must go the old while(rb_first()) loop...

I just realized the postorder iterator can be used here. The forbidden
pattern is

rbtree_postorder_for_each_entry_safe() {
	rb_erase();
}

But you also do kfree right after the erase, and the iterator is fine
with that and rb_erase is pointless for an entry that's being freed
anyway.
