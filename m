Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36352 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727141AbeHOOk1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Aug 2018 10:40:27 -0400
Date: Wed, 15 Aug 2018 13:48:27 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: remove duplicated btrfs_release_path in
 btrfs_unlink_subvol
Message-ID: <20180815114827.GI24025@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1534214829-26202-1-git-send-email-bo.liu@linux.alibaba.com>
 <20180814104600.GE24025@twin.jikos.cz>
 <20180815025256.6fftocnncloellm3@rsjd01523.et2sqa>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180815025256.6fftocnncloellm3@rsjd01523.et2sqa>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 15, 2018 at 10:52:56AM +0800, Liu Bo wrote:
> On Tue, Aug 14, 2018 at 12:46:00PM +0200, David Sterba wrote:
> > On Tue, Aug 14, 2018 at 10:47:09AM +0800, Liu Bo wrote:
> > > The btrfs_release_path() is just useless as path is only used in error handling.
> > 
> > Where is it duplicated? And I don't think it's useless, while the
> > changelog does not explain why and it's not obvious from the context. If
> > the path is locked, then releasing it right after it's not needed makes
> > sense.  There are several potentially heavyweight operations between the
> > release and final free.
> 
> I see, the diff context is a little bit misleading, the logic in
> btrfs_unlink_subvol() is like,

Well, you based you patch on old code, the duplicate btrfs_release_path
has been removed in 5b7d687ad5913a56b6a8788435d7a53990b4176d and was
in the devel branches since like 2 weeks.

The patch removes the first release while it would could have been the
other one to save some cycles when the branch with
btrfs_search_dir_index_item is not taken.
