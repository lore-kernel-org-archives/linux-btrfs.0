Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34697 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752075AbdEQSmU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 14:42:20 -0400
Date: Wed, 17 May 2017 20:41:21 +0200
From: David Sterba <dsterba@suse.cz>
To: Sahil Kang <sahil.kang@asilaycomputing.com>
Cc: dsterba@suse.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/1] Remove unnecessary branching in free-space-tree.c
Message-ID: <20170517184121.GN4065@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1495017225-8268-1-git-send-email-sahil.kang@asilaycomputing.com>
 <1495017225-8268-2-git-send-email-sahil.kang@asilaycomputing.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1495017225-8268-2-git-send-email-sahil.kang@asilaycomputing.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 17, 2017 at 03:33:45AM -0700, Sahil Kang wrote:
> Both btrfs_create_free_space_tree and btrfs_clear_free_space_tree
> contain:
> 
>   if (ret)
>           return ret;
> 
>   return 0;
> 
> The if statement is only false when ret equals zero, and since we return
> zero in such cases, we can safely remove the branching.

Yeah the code looks better that way. Please don't forget to add the
'btrfs: ' prefix to the subject, I've fixed that now.
