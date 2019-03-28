Return-Path: <SRS0=ig1K=R7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4997C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 14:24:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B6B620823
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 14:24:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726098AbfC1OYe (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Mar 2019 10:24:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:56930 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725875AbfC1OYe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Mar 2019 10:24:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 81EADBA07;
        Thu, 28 Mar 2019 14:24:32 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 9C889DA8D8; Thu, 28 Mar 2019 15:25:44 +0100 (CET)
Date:   Thu, 28 Mar 2019 15:25:44 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     dsterba@suse.cz, Qu Wenruo <wqu@suse.de>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: Re: [PATCh v2 8/9] btrfs: tree-checker: Verify inode item
Message-ID: <20190328142544.GJ29086@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Qu Wenruo <wqu@suse.de>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
References: <20190320063717.31770-1-wqu@suse.com>
 <20190320063717.31770-9-wqu@suse.com>
 <20190328133806.GD29086@twin.jikos.cz>
 <ae0fe6da-a329-ceea-cac5-085595965511@suse.de>
 <20190328135714.GF29086@twin.jikos.cz>
 <70209af7-5948-4bfc-a3a0-06a258ad8ed9@suse.de>
 <20190328140747.GH29086@twin.jikos.cz>
 <e5de25af-6cec-fcaf-d3a6-5445ec0f45a5@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e5de25af-6cec-fcaf-d3a6-5445ec0f45a5@gmx.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Mar 28, 2019 at 10:13:19PM +0800, Qu Wenruo wrote:
> >>>> That means we have hard link for directories.
> >>>
> >>> Yes, hard links of directories are forbidden by VFS but that's not the
> >>> point here:
> >>>
> >>> https://btrfs.wiki.kernel.org/index.php/Project_ideas#Track_link_count_for_directories
> >>>
> >>> "The link count for directories is traditionally used to count the number
> >>> of subdirectores iff the link count is >= 2."
> >>
> >> Oh, got it.
> >>
> >> But for that case, it would be much better to go for things like nbytes
> >> or size, as by all means, those two members are less meaningful than
> >> nlinks for directory.
> >
> > size of a directory is currently 2 * sum of all names in the directory,
> > ie. both files and directories.
> 
> In fact that's not always the case for older kernels/progs.
> 
> IIRC it's in recent years that we enhanced btrfs-progs to detect and fix
> that.
> 
> > The nlink is used as an optimization
> > during traversal by existing tools (find), we can't simply change that
> > but would still like to update btrfs to provide support for that.
> 
> But current nlinks is persistent against all inodes. It's always the the
> number of INODE_REF the inode has.
> 
> While for size/nbytes, it doesn't make anything for directory inode at all.
> Kernel doesn't care, it's mostly btrfs-check check and fix.
> 
> Furthermore, only size is fixed to 2 * num_children.
> nbytes is only instructive and at least in lowmem mode, nbytes is only
> checked for alignment, even it's unaligned, lowmem check outputs warning
> only, doesn't count as an error.
> 
> So at least to me, directory nbytes is a better alternative, and it's
> back compatible.

The point here is to use nlinks of directories for the directory
traversal, the size/nbytes is not relevant here for the reasons you
state above.

I don't see how you think the proposed nbytes alternative would be used,
eg. by find.
