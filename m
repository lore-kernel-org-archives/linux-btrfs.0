Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03A04C07E9B
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Jul 2021 04:06:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDC406113B
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Jul 2021 04:06:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239019AbhGTDZb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 19 Jul 2021 23:25:31 -0400
Received: from james.kirk.hungrycats.org ([174.142.39.145]:45758 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233854AbhGTDZH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Jul 2021 23:25:07 -0400
Received: by james.kirk.hungrycats.org (Postfix, from userid 1002)
        id 80975AF1864; Tue, 20 Jul 2021 00:05:42 -0400 (EDT)
Date:   Tue, 20 Jul 2021 00:05:42 -0400
From:   Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/3] btrfs: allow BTRFS_IOC_SNAP_DESTROY_V2 to remove
 ghost subvolume
Message-ID: <20210720040542.GB10170@hungrycats.org>
References: <20210628101637.349718-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210628101637.349718-1-wqu@suse.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Jun 28, 2021 at 06:16:34PM +0800, Qu Wenruo wrote:
> Since we're busting ghost subvolumes, the branch is now called
> ghost_busters:
> https://github.com/adam900710/linux/tree/ghost_busters
> 
> The first two patches are just cleanup found during the development.
> 
> The first is a missing check for subvolid range, the missing check
> itself won't cause any harm, just returning -ENOENT from dentry lookup,
> other than the expected -EINVAL.
> 
> The 2nd is a super old dead comment from the early age of btrfs.
> 
> The final patch is the real work to allow patched "btrfs subvolume delete -i"
> to delete ghost subvolume.
> Tested with the image dump of previous submitted btrfs-progs patchset.
> 
> Qu Wenruo (3):
>   btrfs: return -EINVAL if some user wants to remove uuid/data_reloc
>     tree
>   btrfs: remove dead comment on btrfs_add_dead_root()
>   btrfs: allow BTRFS_IOC_SNAP_DESTROY_V2 to remove ghost subvolume

I hit this bug on several machines while they were running 5.11.  The
ghost subvols seem to occur naturally--I didn't change my usual workloads
to get them, they just showed up in fairly normal snapshot rotation.

They don't seem to occur on 5.10 (up to .46) or on 5.12 and later, but
once they are created, they don't go away without using this patch to
remove them.

This patch does get rid of the ghost subvols after the fact, quite nicely.

Some users on IRC have hit the same problem.  One was running Debian's
backported 5.10, which doesn't fit the pattern of kernel versions I've
observed, but maybe Debian backported something?

>  fs/btrfs/ioctl.c       | 81 +++++++++++++++++++++++++++++++++++++++++-
>  fs/btrfs/transaction.c |  7 ++--
>  2 files changed, 84 insertions(+), 4 deletions(-)
> 
> -- 
> 2.32.0
> 
