Return-Path: <SRS0=9t/X=63=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91516CA90AF
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 May 2020 13:52:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D71092054F
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 May 2020 13:52:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729345AbgEMNwp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 13 May 2020 09:52:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:53462 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728172AbgEMNwp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 May 2020 09:52:45 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1A2F5AFE8;
        Wed, 13 May 2020 13:52:47 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 1E28CDA70B; Wed, 13 May 2020 15:51:53 +0200 (CEST)
Date:   Wed, 13 May 2020 15:51:52 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs: Don't set SHAREABLE flag for data reloc tree
Message-ID: <20200513135152.GJ18421@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20200513061611.111807-1-wqu@suse.com>
 <20200513061611.111807-3-wqu@suse.com>
 <84d3fb22-3845-b952-88ca-c5ce31ab967f@suse.com>
 <2dc7bd7b-dc68-613e-f668-0462829f380f@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2dc7bd7b-dc68-613e-f668-0462829f380f@gmx.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, May 13, 2020 at 02:49:11PM +0800, Qu Wenruo wrote:
> >>  {
> >>  	struct inode *inode = NULL;
> >>  	struct btrfs_trans_handle *trans;
> >> -	struct btrfs_root *root;
> >> +	struct btrfs_root *root = fs_info->dreloc_root;
> >
> > So why haven't you added code in btrfs_get_fs_root to quickly return a
> > refcounted root and instead reference it without incrementing the refcount?
> 
> This is exactly the same as how we handle fs_root.
> And since the lifespan of data reloc root will be the same as the fs, I
> don't think there is any need for it to be grabbed each time we need it.

I'd vote for some consistency in the refcounting, ie. even if it's for
the same life span as the filesystem, set the reference.
