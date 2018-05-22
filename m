Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50633 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751272AbeEVPZB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 May 2018 11:25:01 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1F7EFAB35
        for <linux-btrfs@vger.kernel.org>; Tue, 22 May 2018 15:25:00 +0000 (UTC)
Date: Tue, 22 May 2018 17:22:18 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/4] btrfs: Remove fs_info argument from
 alloc_reserved_tree_block
Message-ID: <20180522152218.GO6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1526894843-8732-1-git-send-email-nborisov@suse.com>
 <1526894843-8732-2-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1526894843-8732-2-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 21, 2018 at 12:27:20PM +0300, Nikolay Borisov wrote:
> This function already takes a transaction handle which contains a
> reference to the fs_info. So use this and remove the extra argument.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
