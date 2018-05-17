Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57449 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752238AbeEQRL7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 May 2018 13:11:59 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2F6A8ABF1
        for <linux-btrfs@vger.kernel.org>; Thu, 17 May 2018 17:11:58 +0000 (UTC)
Date: Thu, 17 May 2018 19:09:16 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Remove stale comment about select_delayed_ref
Message-ID: <20180517170916.GM6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1526555789-14161-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1526555789-14161-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 17, 2018 at 02:16:29PM +0300, Nikolay Borisov wrote:
> select_delayed_ref really just gets the next delayed ref which has to
> be processed - either an add ref or drop ref. We never go back for
> anything. So the comment is actually bogus, just remove it.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Added to misc-next, thanks.
