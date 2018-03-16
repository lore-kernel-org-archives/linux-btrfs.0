Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46783 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932349AbeCPP6K (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Mar 2018 11:58:10 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 596C8AF74
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Mar 2018 15:58:09 +0000 (UTC)
Date: Fri, 16 Mar 2018 16:55:46 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/4] btrfs: drop fs_info parameter from
 btrfs_run_delayed_refs
Message-ID: <20180316155546.GB16736@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1521122427-25062-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1521122427-25062-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 15, 2018 at 04:00:24PM +0200, Nikolay Borisov wrote:
> It's provided by the trans handle
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
> 
> As discussed here https://www.spinics.net/lists/linux-btrfs/msg74775.html
> those were the last 3 remaining function called from btrfs_commit_transaction
> which were needlessly taking fs_info as an argument. 

1-4 applied, thanks.
