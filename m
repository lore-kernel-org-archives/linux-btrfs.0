Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57992 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726603AbeIJWnA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Sep 2018 18:43:00 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 67F87AF65
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Sep 2018 17:47:46 +0000 (UTC)
Date: Mon, 10 Sep 2018 19:47:29 +0200
From: David Sterba <dsterba@suse.cz>
To: jeffm@suse.com
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix error handling in btrfs_dev_replace_start
Message-ID: <20180910174729.GU24025@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180906195217.12163-1-jeffm@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180906195217.12163-1-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 06, 2018 at 03:52:17PM -0400, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
> When we fail to start a transaction in btrfs_dev_replace_start,
> we leave dev_replace->replace_start set to STARTED but clear
> ->srcdev and ->tgtdev.  Later, that can result in an Oops in
> btrfs_dev_replace_progress when having state set to STARTED or
> SUSPENDED implies that ->srcdev is valid.
> 
> Also fix error handling when the state is already STARTED or
> SUSPENDED while starting.  That, too, will clear ->srcdev and ->tgtdev
> even though it doesn't own them.  This should be an impossible case to
> hit since we should be protected by the BTRFS_FS_EXCL_OP bit being set.
> Let's add an ASSERT there while we're at it.
> 
> Fixes: e93c89c1aaaaa (Btrfs: add new sources for device replace code)
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  fs/btrfs/dev-replace.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
> index e2ba0419297a..0581c8570a05 100644
> --- a/fs/btrfs/dev-replace.c
> +++ b/fs/btrfs/dev-replace.c
> @@ -445,6 +445,7 @@ int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
>  		break;
>  	case BTRFS_IOCTL_DEV_REPLACE_STATE_STARTED:
>  	case BTRFS_IOCTL_DEV_REPLACE_STATE_SUSPENDED:
> +		ASSERT(0);

I don't like it fixed that way. The asserts get compiled in
conditionally, so the behaviour might be differend dending on the
config. If the cases are unreachable, then the two cases can be replaced
by a default: and return EINVAL.

Otherwise ok.
