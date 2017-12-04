Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35722 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752628AbdLDNrV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 4 Dec 2017 08:47:21 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3A008AAA3
        for <linux-btrfs@vger.kernel.org>; Mon,  4 Dec 2017 13:47:20 +0000 (UTC)
Date: Mon, 4 Dec 2017 14:45:21 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/5] btrfs: Remove dead code
Message-ID: <20171204134521.GV3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1512119984-12708-1-git-send-email-nborisov@suse.com>
 <1512119984-12708-2-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1512119984-12708-2-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 01, 2017 at 11:19:40AM +0200, Nikolay Borisov wrote:
> trans was statically assigned to NULL and this never changed over the course of
> btrfs_get_extent. So remove any code which checks whether trans != NULL and
> just hardcode the fact trans is always NULL. This fixes CID#112806
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Please find a better subject, at least mention the fuction name write
something more specific about the dead code that's being removed.
