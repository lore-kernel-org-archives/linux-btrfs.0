Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43958 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752233AbdKGUT5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 7 Nov 2017 15:19:57 -0500
Date: Tue, 7 Nov 2017 21:18:04 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org, josef@toxicpanda.com
Subject: Re: [PATCH] btrfs: Reduce scope of delayed_rsv->lock in
 may_commit_trans
Message-ID: <20171107201804.GD27557@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1510046574-15541-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1510046574-15541-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 07, 2017 at 11:22:54AM +0200, Nikolay Borisov wrote:
> After commit ('btrfs: change how we decide to commit transactions during

996478ca9c460886ac1

> flushing') there is no need to hold the delayed_rsv during the
> percpu_counter_compare call since we get the byte's snapshot earlier. So hold
> the lock only while reading delayed_rsv
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
