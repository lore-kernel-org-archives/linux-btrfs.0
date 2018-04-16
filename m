Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45582 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753126AbeDPSZb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Apr 2018 14:25:31 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 940CCAEF5
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Apr 2018 18:25:30 +0000 (UTC)
Date: Mon, 16 Apr 2018 20:23:00 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/4] btrfs: Consolidate error checking for
 btrfs_alloc_chunk
Message-ID: <20180416182259.GV21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1523434880-7799-1-git-send-email-nborisov@suse.com>
 <1523434880-7799-4-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1523434880-7799-4-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 11, 2018 at 11:21:19AM +0300, Nikolay Borisov wrote:
> The second if is really a subcase of ret being less than 0. So
> introduce a generic if (ret < 0) check, and inside have another if
> which explicitly handles the -ENOSPC and any other errors. No
> functional changes.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
