Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33009 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751416AbeCULJs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Mar 2018 07:09:48 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 93D75AECC
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Mar 2018 11:09:47 +0000 (UTC)
Date: Wed, 21 Mar 2018 12:07:23 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: WenRuo Qu <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Remove obsolete function declaration
Message-ID: <20180321110723.GS6955@suse.cz>
Reply-To: dsterba@suse.cz
References: <1521615821-17703-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1521615821-17703-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 21, 2018 at 09:03:41AM +0200, Nikolay Borisov wrote:
> This function was removed in 24bc2843edd5 ("btrfs:
> Refactor __get_raid_index() to btrfs_bg_flags_to_raid_index()") what
> remains is a defunct declaration. Remove it.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
> David, 
> 
> This is a fixlet to the aforementioned patch which is only in your misc-next, 
> I'd suggest just squash this fixlet into the original one. 

Yes, makes sense. Done.

If that happens in the future again, sending a separate mail (not
necessarily a full blown patch with changelog etc) works fine, namely
for patches that are deep in the devel queue like that one. So, thanks.
