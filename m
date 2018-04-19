Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55536 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750732AbeDSIJL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Apr 2018 04:09:11 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 71F14AE9F
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Apr 2018 08:09:10 +0000 (UTC)
Subject: Re: [PATCH 1/3] btrfs: Drop add_delayed_ref_head fs_info parameter
References: <1524125199-5435-1-git-send-email-nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <57e93081-1dee-fa3f-20e3-7653315395c0@suse.com>
Date: Thu, 19 Apr 2018 11:09:09 +0300
MIME-Version: 1.0
In-Reply-To: <1524125199-5435-1-git-send-email-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 19.04.2018 11:06, Nikolay Borisov wrote:
> It's provided by the transaction handle
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

David,

You said that while merging the deleayed refs cleanup/streamlining
series there were some conflicts. It turns out they are due to these 3
patches missing. I'm sending them as a separate set or I can also send
them as part of the v2 for the delayed refs cleanup. The only thing
that's left for that series is to rebase ontop of the delayed refs race
fix. What will be the best way to handle this ?
