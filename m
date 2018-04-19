Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46983 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753317AbeDSO5z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Apr 2018 10:57:55 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0F892ACC2
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Apr 2018 14:57:54 +0000 (UTC)
Date: Thu, 19 Apr 2018 16:55:22 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 6/6] btrfs: Remove btrfs_wait_and_free_delalloc_work
Message-ID: <20180419145522.GF21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1524123999-4220-1-git-send-email-nborisov@suse.com>
 <1524123999-4220-6-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1524123999-4220-6-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 19, 2018 at 10:46:39AM +0300, Nikolay Borisov wrote:
> This function is called from only 1 place and is effectively a wrapper
> over wait_completion/kfree. It doesn't really bring any value having
> those two calls in a separate function. Just open code it and remove it.
> No functional changes.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
