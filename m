Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49654 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751637AbeFEONj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Jun 2018 10:13:39 -0400
Date: Tue, 5 Jun 2018 16:10:53 +0200
From: David Sterba <dsterba@suse.cz>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] btrfs: Check error of btrfs_iget() in
 btrfs_search_path_in_tree_user()
Message-ID: <20180605141052.GC3539@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1528076364.git.misono.tomohiro@jp.fujitsu.com>
 <c88f81e3-1dff-35a8-89ce-d9d3050be101@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <c88f81e3-1dff-35a8-89ce-d9d3050be101@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 04, 2018 at 04:41:07PM +0900, Misono Tomohiro wrote:
> Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
> ---
> 
> Hi david,
> 
> It seems that v8 patch I sent last week is missed and commit in misc-next
> tree is also a bit updated from v7, so I resend the fix as a separate patch.
> 
> Please fold this patch to current misc-next (head is the commit to be fixed:
> "btrfs: Add unprivileged version of ino_lookup ioctl").

Somehow it got lost on the way to the pull request branch, there were
several other things to fix in the patch so I forgot that one. This also
means I cannot fold it so it needs to be separate, based on this patch.
Thanks.
