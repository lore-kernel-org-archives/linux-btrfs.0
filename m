Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37686 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964828AbcIWMjG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Sep 2016 08:39:06 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 17870AC71
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Sep 2016 12:39:05 +0000 (UTC)
Date: Fri, 23 Sep 2016 14:37:03 +0200
From: David Sterba <dsterba@suse.cz>
To: jeffm@suse.com
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>
Subject: Re: [PATCH 4/5] btrfs: convert pr_* to btrfs_* where possible
Message-ID: <20160923123703.GX16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1474380303-25995-1-git-send-email-jeffm@suse.com>
 <1474380303-25995-5-git-send-email-jeffm@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1474380303-25995-5-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 20, 2016 at 10:05:02AM -0400, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
> For many printks, we want to know which file system issued the message.
> 
> This patch converts most pr_* calls to use the btrfs_* versions instead.
> In some cases, this means adding plumbing to allow call sites access to
> an fs_info pointer.
> 
> fs/btrfs/check-integrity.c is left alone for another day.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

I've spotted some extra newline in one of the messages so I went through
the patch again and did some whitespace changes (shifting the strings
left where it exceeded 80 cols, though it hasn't helped too much).

Reviewed-by: David Sterba <dsterba@suse.com>

Otherwise I like this series, we'll get almost all messges prefixed.
