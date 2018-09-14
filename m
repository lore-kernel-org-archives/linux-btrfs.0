Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42438 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727623AbeINTKS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Sep 2018 15:10:18 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id F1CD2AE39
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Sep 2018 13:55:39 +0000 (UTC)
Date: Fri, 14 Sep 2018 15:55:39 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Remove logically dead code from
 btrfs_orphan_cleanup
Message-ID: <20180914135539.GE5847@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1536827700-20477-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1536827700-20477-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 13, 2018 at 11:35:00AM +0300, Nikolay Borisov wrote:
> In btrfs_orphan_cleanup the final 'if (ret) goto out' cannot ever be
> executed. This is due to the last assignment to 'ret' depending on
> the return value of btrfs_iget. If an error other than -ENOENT is
> returned then the loop is prematurely terminated by 'goto out'.
> On the other hand, if the error value is ENOENT then a subsequent
> if branch is executed that always re-assigns 'ret' and in case it's
> an error just terminates the loop. No functional changes.
> 
> CID: 1437392
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
