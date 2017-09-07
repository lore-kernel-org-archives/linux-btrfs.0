Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40210 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751884AbdIGTfL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 7 Sep 2017 15:35:11 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 137B2AE72
        for <linux-btrfs@vger.kernel.org>; Thu,  7 Sep 2017 19:35:10 +0000 (UTC)
Date: Thu, 7 Sep 2017 21:33:42 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 10/10] btrfs: Remove redundant argument of
 __link_block_group
Message-ID: <20170907193342.GK31874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1503308630-6652-1-git-send-email-nborisov@suse.com>
 <1503308630-6652-11-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1503308630-6652-11-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 21, 2017 at 12:43:50PM +0300, Nikolay Borisov wrote:
> __link_block_group is called from only 2 places and at each call site the
> space_info being passed is the same as the space info assigned to the passed
> cache struct. Let's remove the redundant argument and make the function
> reference the space_info from the passed block_group_cache. No functional
> changes
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

I took the cleanup a bit further and removed the double underscore from
the function name.

Reviewed-by: David Sterba <dsterba@suse.com>
