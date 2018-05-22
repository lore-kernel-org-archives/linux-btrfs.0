Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50691 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751416AbeEVPZv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 May 2018 11:25:51 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 14E73AB35
        for <linux-btrfs@vger.kernel.org>; Tue, 22 May 2018 15:25:50 +0000 (UTC)
Date: Tue, 22 May 2018 17:23:08 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/4] btrfs: Streamline shared ref check in
 alloc_reserved_tree_block
Message-ID: <20180522152308.GR6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1526894843-8732-1-git-send-email-nborisov@suse.com>
 <1526894843-8732-5-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1526894843-8732-5-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 21, 2018 at 12:27:23PM +0300, Nikolay Borisov wrote:
> Instead of setting "parent" to ref->parent only when dealing with
> a shared ref and subsequently performing another check to see
> if (parent > 0), check the "node->type" directly and act accordingly.
> This makes the code more streamline. No functional changes.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
