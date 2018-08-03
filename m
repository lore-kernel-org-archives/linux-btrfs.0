Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51260 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732279AbeHCQzP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 3 Aug 2018 12:55:15 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4AB91AE85
        for <linux-btrfs@vger.kernel.org>; Fri,  3 Aug 2018 14:58:32 +0000 (UTC)
Date: Fri, 3 Aug 2018 16:58:28 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/2] btrfs-progs: Fix qgroup false alerts on
 uninitialized rescan
Message-ID: <20180803145828.GZ3218@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180726063901.1252-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180726063901.1252-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 26, 2018 at 02:38:59PM +0800, Qu Wenruo wrote:
> This patches can be fetched from github:
> https://github.com/adam900710/btrfs-progs/tree/qgroup_report
> 
> It's possible that certain timed power loss could lead to initialized quota
> tree without rescan kicked in.
> Can be reproduced in btrfs/166 with low possibility.
> 
> In that case, since default flags for QUOTA_STATUS is ON|INCONSISTENT,
> btrfs check will still check qgroups and report difference as error.
> 
> However rescan progress of QUOTA_STATUS is still 0, means qgroup rescan
> hasn't been kicked in, and all quota numbers are 0, difference is
> expected.
> 
> In this case, make btrfs check don't report such uninitialized rescan as
> error.
> 
> Qu Wenruo (2):
>   btrfs-progs: qgroup-verify: Don't treat qgroup difference as error if
>     the fs hasn't initialized a rescan
>   btrfs-progs: fsck-tests: Add test image to check if btrfs check
>     reports uninitialized rescan as error

Applied, thanks.
