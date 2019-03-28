Return-Path: <SRS0=ig1K=R7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E70FC43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 14:06:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6CA6D2075E
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 14:06:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbfC1OGh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Mar 2019 10:06:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:38750 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725849AbfC1OGg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Mar 2019 10:06:36 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DB147B63A;
        Thu, 28 Mar 2019 14:06:35 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 1C4A2DA8D8; Thu, 28 Mar 2019 15:07:48 +0100 (CET)
Date:   Thu, 28 Mar 2019 15:07:47 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.de>
Cc:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: Re: [PATCh v2 8/9] btrfs: tree-checker: Verify inode item
Message-ID: <20190328140747.GH29086@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.de>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        Nikolay Borisov <nborisov@suse.com>
References: <20190320063717.31770-1-wqu@suse.com>
 <20190320063717.31770-9-wqu@suse.com>
 <20190328133806.GD29086@twin.jikos.cz>
 <ae0fe6da-a329-ceea-cac5-085595965511@suse.de>
 <20190328135714.GF29086@twin.jikos.cz>
 <70209af7-5948-4bfc-a3a0-06a258ad8ed9@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <70209af7-5948-4bfc-a3a0-06a258ad8ed9@suse.de>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Mar 28, 2019 at 10:00:22PM +0800, Qu Wenruo wrote:
> 
> 
> On 2019/3/28 下午9:57, David Sterba wrote:
> > On Thu, Mar 28, 2019 at 09:42:59PM +0800, Qu Wenruo wrote:
> >>
> >>
> >> On 2019/3/28 下午9:38, David Sterba wrote:
> >>> On Wed, Mar 20, 2019 at 02:37:16PM +0800, Qu Wenruo wrote:
> >>>> +	if (S_ISDIR(mode) && btrfs_inode_nlink(leaf, iitem) > 1) {
> >>>> +		inode_item_err(fs_info, leaf, slot,
> >>>> +			       "invalid nlink: has %u expect no more than 1 for dir",
> >>>> +			btrfs_inode_nlink(leaf, iitem));
> >>>> +		goto error;
> >>>> +	}
> >>>
> >>> I'm not sure about this check, the number of links for a directory is 1,
> >>> but the exact count could be implemented (there's a project idea for
> >>> that). I don't know if this will require an incompat bit or not.
> >>
> >> That means we have hard link for directories.
> > 
> > Yes, hard links of directories are forbidden by VFS but that's not the
> > point here:
> > 
> > https://btrfs.wiki.kernel.org/index.php/Project_ideas#Track_link_count_for_directories
> > 
> > "The link count for directories is traditionally used to count the number
> > of subdirectores iff the link count is >= 2."
> 
> Oh, got it.
> 
> But for that case, it would be much better to go for things like nbytes
> or size, as by all means, those two members are less meaningful than
> nlinks for directory.

size of a directory is currently 2 * sum of all names in the directory,
ie. both files and directories. The nlink is used as an optimization
during traversal by existing tools (find), we can't simply change that
but would still like to update btrfs to provide support for that.

On the wiki there's note that it's backward compatible, I don't recall
the actual details why it's safe though.
