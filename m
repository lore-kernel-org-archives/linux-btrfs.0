Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34672 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751014AbcIJAXB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 9 Sep 2016 20:23:01 -0400
Date: Fri, 9 Sep 2016 17:22:59 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v13 00/15] Btrfs In-band De-duplication
Message-ID: <20160910002259.GR5316@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <20160908071304.25616-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160908071304.25616-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 08, 2016 at 03:12:49PM +0800, Qu Wenruo wrote:
> This patchset can be fetched from github:
> https://github.com/adam900710/linux.git wang_dedupe_20160907
> 
> This version is just another small update, rebased to David's
> for-next-20160906 branch.
> 
> This updates only includes one small fix, which is exposed by recent
> commits which checks space_info->bytes_may_use at umount time.
> Caused by that we only free quota reserved space at hash hit, but doesn't
> free space_info->bytes_may_use.
> 
> Other rebase changes are all related to recent infrastructure change,
> like io_tree and quota flags change.
> 
> We ran xfstests with dedupe enabled.

Is there an xfstests patch for this I can look at? We want to be able to run
and reproduce the same tests as you.

Also where are the disk portion patches or did I miss them somehow?
	--Mark

--
Mark Fasheh
