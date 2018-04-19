Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48475 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751882AbeDSPRC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Apr 2018 11:17:02 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id BE5E3AEA6
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Apr 2018 15:17:01 +0000 (UTC)
Date: Thu, 19 Apr 2018 17:14:30 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 1/3] btrfs: Drop add_delayed_ref_head fs_info parameter
Message-ID: <20180419151430.GH21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1524125199-5435-1-git-send-email-nborisov@suse.com>
 <57e93081-1dee-fa3f-20e3-7653315395c0@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <57e93081-1dee-fa3f-20e3-7653315395c0@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 19, 2018 at 11:09:09AM +0300, Nikolay Borisov wrote:
> You said that while merging the deleayed refs cleanup/streamlining
> series there were some conflicts. It turns out they are due to these 3
> patches missing. I'm sending them as a separate set or I can also send
> them as part of the v2 for the delayed refs cleanup. The only thing
> that's left for that series is to rebase ontop of the delayed refs race
> fix. What will be the best way to handle this ?

I've applied the 3 cleanup patches to misc-next, the conflict was simple
to resolve.

The conflict with the delayed refs cleanup series will be bigger, the
review is pending so I'll expect maybe one more iteration, so taking the
3 cleanup makes a bit more sense.
