Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60739 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753815AbeBBRlp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Feb 2018 12:41:45 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 57B65AE07
        for <linux-btrfs@vger.kernel.org>; Fri,  2 Feb 2018 17:41:44 +0000 (UTC)
Date: Fri, 2 Feb 2018 18:39:31 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RESEND 1/4] btrfs: Remove userspace transaction ioctls
Message-ID: <20180202173931.GV18553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1515590477-22878-1-git-send-email-nborisov@suse.com>
 <1515601933-27331-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1515601933-27331-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 10, 2018 at 06:32:10PM +0200, Nikolay Borisov wrote:
> Commit 3558d4f88ec8 ("btrfs: Deprecate userspace transaction ioctls")
> marked the beginning of the end of userspace transaction. This commit
> finishes the job!
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
