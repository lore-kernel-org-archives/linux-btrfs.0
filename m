Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57741 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217AbcGMMPY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Jul 2016 08:15:24 -0400
Date: Wed, 13 Jul 2016 14:15:26 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <kernel@kyup.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Ratelimit message printing
Message-ID: <20160713121526.GJ10595@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160712160126.GD10595@suse.cz>
 <1468393536-25798-1-git-send-email-kernel@kyup.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1468393536-25798-1-git-send-email-kernel@kyup.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 13, 2016 at 10:05:36AM +0300, Nikolay Borisov wrote:
> Currently most of the messages btrfs produce are not rate limited.
> Recently I came accross a case where due to FS corruption an excessive
> amount of printk caused the softlockup detector to trigger and reset
> the server. This patch does the following changes:
> 
>  * The message which was printed is converted to use the ratelimited
>  version of btrfs_info function. This will prevent it from exploding
>  in the future.
> 
>  * In addition to the above change, also add a sort of a "safet net" to
>  all non-ratelimited prints by introducing separate ratelimiting for
>  every message class when the "naked" btrfs_info is called.
> 
> Signed-off-by: Nikolay Borisov <kernel@kyup.com>
> ---
> 
> Hello David, 
> 
> How about something like that?

Looks good, but please split the patch so one adds the ratelimiting to
the 'csum not found' message and another that introduces the global rate
limiting and add a comment to the printk_limits table, with the relevant
text from the changelog. Thanks.
