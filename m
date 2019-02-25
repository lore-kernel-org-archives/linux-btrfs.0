Return-Path: <SRS0=5Bfi=RA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7829BC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Feb 2019 12:25:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 42FDA20842
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Feb 2019 12:25:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbfBYMZi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Feb 2019 07:25:38 -0500
Received: from mx2.suse.de ([195.135.220.15]:53332 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726906AbfBYMZh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Feb 2019 07:25:37 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C961EACCD;
        Mon, 25 Feb 2019 12:25:36 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 6FE85DAA70; Mon, 25 Feb 2019 13:26:57 +0100 (CET)
Date:   Mon, 25 Feb 2019 13:26:57 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, josef@toxicpanda.com
Subject: Re: [PATCH] btrfs: Use struct inode* to replace
 extent_io_tree::private_data
Message-ID: <20190225122657.GP9874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        josef@toxicpanda.com
References: <20190225055043.1621-1-wqu@suse.com>
 <20190225121540.GN9874@twin.jikos.cz>
 <7a8afd82-7acf-e2cc-deff-38ccf702ef2d@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7a8afd82-7acf-e2cc-deff-38ccf702ef2d@gmx.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Feb 25, 2019 at 08:17:52PM +0800, Qu Wenruo wrote:
> 
> 
> On 2019/2/25 下午8:15, David Sterba wrote:
> > On Mon, Feb 25, 2019 at 01:50:43PM +0800, Qu Wenruo wrote:
> >> All users of extent_io_tree::private_data are expecting struct inode*.
> >> So just use struct inode* to replace extent_io_tree::private_data, and
> >> this should provide better type check.
> >>
> >> Signed-off-by: Qu Wenruo <wqu@suse.com>
> >>  struct extent_io_tree {
> >>  	struct rb_root state;
> >> -	void *private_data;
> >> +	struct inode *inode;
> >>  	u64 dirty_bytes;
> >>  	int track_uptodate;
> >>  	spinlock_t lock;
> > 
> > So this is effectively reverting c6100a4b4e3d1650deafd ("Btrfs: replace
> > tree->mapping with tree->private_data"),
> 
> That commit message doesn't explain why this is needed for btree_inode
> removal.
> 
> Any idea what the extra type would be used in that case?

I don't know, Josef in CC to answer that.
