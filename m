Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39486 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752649AbdGXNZ6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Jul 2017 09:25:58 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 03D73ABD9
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Jul 2017 13:25:57 +0000 (UTC)
Date: Mon, 24 Jul 2017 15:24:41 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: dsterba@suse.cz, jeffm@suse.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: round down size diff when shrinking/growing device
Message-ID: <20170724132441.GU2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1500625704-29861-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1500625704-29861-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 21, 2017 at 11:28:24AM +0300, Nikolay Borisov wrote:
> Further testing showed that the fix introduced in 7dfb8be11b5d
> ("btrfs: Round down values which are written for total_bytes_size") was
> insufficient and it could still lead to discrepancies between the total_bytes in
> the super block and the device total bytes. So this patch also ensures that
> the difference between old/new sizes when shrinking/growing is also
> rounded down. This ensure that we won't be substracting/adding a non-sectorsize
> multiples to the superblock/device total sizees.
> 
> Fixes: 7dfb8be11b5d ("btrfs: Round down values which are written for total_bytes_size")
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
