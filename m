Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35968 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753400AbeGEQIE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 5 Jul 2018 12:08:04 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3F18AAE5E
        for <linux-btrfs@vger.kernel.org>; Thu,  5 Jul 2018 16:08:03 +0000 (UTC)
Date: Thu, 5 Jul 2018 18:08:00 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: check: Fix wrong error message in case of
 corrupted extent
Message-ID: <20180705160800.GM3126@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1528198750-27840-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1528198750-27840-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 05, 2018 at 02:39:10PM +0300, Nikolay Borisov wrote:
> When btrfs check detects a freespace tree extent which ends beyond the
> blockgroup containing it a misleading error messages is printed. For
> example if we have the following extent in the freespace tree:
> 
>     item 5 key (30408704 FREE_SPACE_INFO 1073741824) itemoff 16259 itemsize 8
>             free space info extent count 3 flags 0
>     item 6 key (30425088 FREE_SPACE_EXTENT 49152) itemoff 16259 itemsize 0
>             free space extent
>     item 7 key (30507008 FREE_SPACE_EXTENT 65536) itemoff 16259 itemsize 0
>             free space extent
>     item 8 key (30654464 FREE_SPACE_EXTENT 14524648038063310901) itemoff 16259 itemsize 0
> 
> Clearly the last extent is corrupted so we should print something
> along the lines of:
> 
> free space extent ends at 14524648038063310901, beyond end of block group 30408704-1104150528
> 
> Instead currently this is printed:
> 
> free space extent ends at 30654464, beyond end of block group 30408704-1104150528
> 
> So instead of printing the actual erroneous end, we print the beginning
> of the extent. Fix this by printing the actual corrupted end.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Applied, thanks.
