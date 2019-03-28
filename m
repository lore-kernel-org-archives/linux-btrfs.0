Return-Path: <SRS0=ig1K=R7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C8C2C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 21:38:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 328092184C
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 21:38:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727565AbfC1Vi0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Mar 2019 17:38:26 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:22734 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726611AbfC1Vi0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Mar 2019 17:38:26 -0400
Received: from ppp59-167-129-252.static.internode.on.net (HELO dastard) ([59.167.129.252])
  by ipmail07.adl2.internode.on.net with ESMTP; 29 Mar 2019 08:08:24 +1030
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1h9cj9-0008CS-Cm; Fri, 29 Mar 2019 08:38:23 +1100
Date:   Fri, 29 Mar 2019 08:38:23 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     fdmanana@kernel.org
Cc:     fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH 1/7] fsstress: rename setxattr operation to chproj
Message-ID: <20190328213823.GL26298@dastard>
References: <20190328185352.28829-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190328185352.28829-1-fdmanana@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Mar 28, 2019 at 06:53:52PM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> The existing setxattr operation is used to change the project identifier
> attribute associated with an inode, and not about setting a xattr (the
> name and value pair) for a file/directory, which is confusing. So rename
> the operation to chproj, which is more descriptive about what it does
> and avoids any confusion.
> 
> Fsstress currently has no operations for setting and getting xattrs of a
> file (for any namespace), and this patch is a preparation for adding such
> operations in a subsequent patch.
> 
> This operation actually used to be named chproj until the following
> commit:
> 
>  commit 6449a993f2dfb3faaaa44e29d2f7d1bb7c5db9ba
>  Author: Nathan Scott <nathans@sgi.com>
>  Date:   Mon Dec 5 21:41:47 2005 +0000
> 
>      Switch to always using get/setxattr rather than a separate projid call on IRIX.
>      Merge of master-melb:xfs-cmds:24692a by kenmcd.
> 
> Which does not explain the rationale for the renaming at all.

Yes it does. The ioctls the function uses are called "get/setxattr",
not "chproj". i.e. FS_IOC_FS[GS]ETXATTR.

Yes, it currently changes the project ID, but that ioctl can change
a bunch more flag attributes on inodes. I'm guessing the intent was
to extend it to changing more than just the project ID. e.g setting
extent size hints.

The intent was most likely to extend it to testing other bits of
the FS_IOC_FS[GS]ETXATTR interface, so it's appropriately named. if
youare going to change it, then "fssetxattr" is probably the right
thing to change it to...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
