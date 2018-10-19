Return-Path: <SRS0=U11f=M7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6826ECDE3D
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Oct 2018 10:06:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9CBB221479
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Oct 2018 10:06:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9CBB221479
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbeJSSJv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 19 Oct 2018 14:09:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:51028 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726664AbeJSSJu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Oct 2018 14:09:50 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 10660AE11;
        Fri, 19 Oct 2018 10:04:26 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id DE285DA6F5; Fri, 19 Oct 2018 12:04:19 +0200 (CEST)
Date:   Fri, 19 Oct 2018 12:04:19 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.de>
Cc:     dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/6] btrfs: qgroup: Introduce per-root swapped blocks
 infrastructure
Message-ID: <20181019100419.GC16290@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.de>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181018111729.11128-1-wqu@suse.com>
 <20181018111729.11128-5-wqu@suse.com>
 <20181018162059.GJ29418@twin.jikos.cz>
 <dfa39127-3cdc-b98d-b0a0-eed82ba984a5@gmx.com>
 <20181019091516.GB16290@twin.jikos.cz>
 <63697e20-9c39-da22-437d-b43612f25d3c@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63697e20-9c39-da22-437d-b43612f25d3c@suse.de>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Oct 19, 2018 at 05:46:28PM +0800, Qu Wenruo wrote:
> Did you mean some like this is possible?
> 
> rbtree_postorder_for_each_entry_safe() {
> 	kfree(entry);
> }
> 
> If so, I still don't really believe it's OK.
> 
> For the following tree:
>                           4
>                        /     \
>                       2       6
>                     /  \     / \
>                    1    3   5   7
> 
> If current entry is 2, next is 3.
> And 2 get freed.
> Then we go 3, to reach next we need to go back to access 2, which is
> already freed, we will trigger use-after-free.
> 
> So the only correct way to free the whole rbtree is still that tried and
> true while(rb_first()) loop.
> 
> Or did I miss something?

It's postorder traversal so the node is ready for processing after all
it's children are processed. In the above example, it will result in the
followin sequence: 1 3 2 5 7 6 4 .

The iterator is safe in the sense that there's enough information saved
before going to the node so it's not needed to be accessed later, eg.
after it's freed.

prelim_release uses the same postorder/kfree pattern.
