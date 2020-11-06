Return-Path: <SRS0=mxMs=EM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73D85C2D0A3
	for <linux-btrfs@archiver.kernel.org>; Fri,  6 Nov 2020 19:21:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1EF12206FA
	for <linux-btrfs@archiver.kernel.org>; Fri,  6 Nov 2020 19:21:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727828AbgKFTVq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 6 Nov 2020 14:21:46 -0500
Received: from mx2.suse.de ([195.135.220.15]:58442 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726880AbgKFTVp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 6 Nov 2020 14:21:45 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9B206AF2C;
        Fri,  6 Nov 2020 19:21:44 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 35A10DA6E3; Fri,  6 Nov 2020 20:20:05 +0100 (CET)
Date:   Fri, 6 Nov 2020 20:20:05 +0100
From:   David Sterba <dsterba@suse.cz>
To:     dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: Re: [PATCH 14/32] btrfs: inode: make btrfs_readpage_end_io_hook()
 follow sector size
Message-ID: <20201106192005.GV6756@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
References: <20201103133108.148112-1-wqu@suse.com>
 <20201103133108.148112-15-wqu@suse.com>
 <ec23422d-e7d9-2886-6c12-8582fa05d968@suse.com>
 <20201106191608.GU6756@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201106191608.GU6756@twin.jikos.cz>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Nov 06, 2020 at 08:16:08PM +0100, David Sterba wrote:
> On Thu, Nov 05, 2020 at 04:28:12PM +0200, Nikolay Borisov wrote:
> > On 3.11.20 г. 15:30 ч., Qu Wenruo wrote:
> > > --- a/fs/btrfs/inode.c
> > > +++ b/fs/btrfs/inode.c
> > > @@ -2888,9 +2888,11 @@ int btrfs_verify_data_csum(struct btrfs_io_bio *io_bio, u64 phy_offset,
> > >  			   struct page *page, u64 start, u64 end, int mirror)
> > >  {
> > >  	size_t offset = start - page_offset(page);
> > > +	size_t pg_off;
> > 
> > nit: For offsets we should be using a more self-descriptive type such as
> > loff_t
> 
> loff_t is meant for file offsets and is an overkill when it's used for
> offset in page that's fine with an u32.

Ok, so page_offset also uses loff_t but there are now mixed loff_t,
size_t and u64 in the function so I'd rather make it all u64.
