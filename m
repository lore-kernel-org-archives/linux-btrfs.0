Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39576 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757228AbeFSNBs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Jun 2018 09:01:48 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B50CFADD3
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Jun 2018 13:01:46 +0000 (UTC)
Subject: Re: [PATCH 1/3] btrfs: Remove fs_info argument from
 __btrfs_inc_extent_ref
To: linux-btrfs@vger.kernel.org
References: <1529323166-29931-1-git-send-email-nborisov@suse.com>
 <1529323166-29931-2-git-send-email-nborisov@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <b2ed365d-6b40-b3aa-15ed-8078135171b4@suse.com>
Date: Tue, 19 Jun 2018 16:01:45 +0300
MIME-Version: 1.0
In-Reply-To: <1529323166-29931-2-git-send-email-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 18.06.2018 14:59, Nikolay Borisov wrote:
> This function already takes a transaction which holds a reference to
> the fs_info struct. Use that reference and remove the extra arg. No
> functional changes.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> --- 

Please ignore this patch, since I'm going to re-send it as apart of a
larger series dealing specifically with fs_info cleanup. The other 2 are
good.

<snip>
