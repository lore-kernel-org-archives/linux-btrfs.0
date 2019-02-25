Return-Path: <SRS0=5Bfi=RA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1265EC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Feb 2019 12:14:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD3F520842
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Feb 2019 12:14:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbfBYMOT (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Feb 2019 07:14:19 -0500
Received: from mx2.suse.de ([195.135.220.15]:48502 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726811AbfBYMOT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Feb 2019 07:14:19 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 758E7ADE2;
        Mon, 25 Feb 2019 12:14:18 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 20DB5DAA70; Mon, 25 Feb 2019 13:15:40 +0100 (CET)
Date:   Mon, 25 Feb 2019 13:15:40 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, josef@toxicpanda.com
Subject: Re: [PATCH] btrfs: Use struct inode* to replace
 extent_io_tree::private_data
Message-ID: <20190225121540.GN9874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, josef@toxicpanda.com
References: <20190225055043.1621-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190225055043.1621-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Feb 25, 2019 at 01:50:43PM +0800, Qu Wenruo wrote:
> All users of extent_io_tree::private_data are expecting struct inode*.
> So just use struct inode* to replace extent_io_tree::private_data, and
> this should provide better type check.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
>  struct extent_io_tree {
>  	struct rb_root state;
> -	void *private_data;
> +	struct inode *inode;
>  	u64 dirty_bytes;
>  	int track_uptodate;
>  	spinlock_t lock;

So this is effectively reverting c6100a4b4e3d1650deafd ("Btrfs: replace
tree->mapping with tree->private_data"), that seems to be preparatory
work for btree_inode removal. I haven't heared any news about that work
for a long time though, so if this is going to land any time soon then
we can keep it there. Otherwise, well, ack for the patch.
