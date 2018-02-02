Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53533 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752164AbeBBQ3I (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Feb 2018 11:29:08 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E3234AD6A
        for <linux-btrfs@vger.kernel.org>; Fri,  2 Feb 2018 16:29:06 +0000 (UTC)
Date: Fri, 2 Feb 2018 17:26:54 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: Remove btrfs_inode::delayed_iput_count
Message-ID: <20180202162654.GS18553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1516019494-24210-1-git-send-email-nborisov@suse.com>
 <1516087918-8617-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1516087918-8617-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 16, 2018 at 09:31:58AM +0200, Nikolay Borisov wrote:
> delayed_iput_count wa supposed to be used to implement, well, delayed
> iput. The idea is that we keep accumulating the number of iputs we do
> until eventually the inode is deleted. Turns out we never really
> switched the delayed_iput_count from 0 to 1, hence all conditional
> code relying on the value of that member being different than 0 was
> never executed. This, as it turns out, didn't cause any problem due
> to the simple fact that the generic inode's i_count member was always
> used to count the number of iputs. So let's just remove the unused
> member and all unused code. This patch essentially provides no
> functional changes. While at it, also add proper documentation for 
> btrfs_add_delayed_iput 
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
