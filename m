Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40179 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752248AbdLGTY1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 7 Dec 2017 14:24:27 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 9B059AE46
        for <linux-btrfs@vger.kernel.org>; Thu,  7 Dec 2017 19:24:26 +0000 (UTC)
Date: Thu, 7 Dec 2017 20:22:27 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 1/2] btrfs-progs: convert: Fix a bug in rollback check
 which overwrite return value
Message-ID: <20171207192227.GI3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171129134806.32324-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171129134806.32324-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 29, 2017 at 09:48:05PM +0800, Qu Wenruo wrote:
> Commit 1170ac307900 ("btrfs-progs: convert: Introduce function to check if
> convert image is able to be rolled back") reworked rollback check
> condition, by checking 1:1 mapping of each file extent.
> 
> The idea itself has nothing wrong, but error handler is not implemented
> correctly, which over writes the return value and always try to rollback
> the fs even it fails to pass the check.
> 
> Fix it by correctly return the error before rollback the fs.
> 
> Fixes: 1170ac307900 ("btrfs-progs: convert: Introduce function to check if convert image is able to be rolled back")
> Reported-by: Jeff Mahoney <jeffm@suse.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>

1-2 applied, thanks.
