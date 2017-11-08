Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49920 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752491AbdKHPym (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 8 Nov 2017 10:54:42 -0500
Date: Wed, 8 Nov 2017 16:52:47 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: document rules about bio async submit
Message-ID: <20171108155247.GK27557@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171101231927.4399-1-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171101231927.4399-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 01, 2017 at 05:19:27PM -0600, Liu Bo wrote:
> These rules have been hidden in several if-else and are not
> straightforward to follow, for example, dio submit hook's nocsum case
> has a bug , i.e. doing async submit instead of sync submit, which has
> been fixed recently.
> 
> This is documenting the rules for reference.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Added to the queue, thanks.
