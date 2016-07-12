Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43522 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717AbcGLNUf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Jul 2016 09:20:35 -0400
Date: Tue, 12 Jul 2016 15:20:44 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <kernel@kyup.com>
Cc: jbacik@fb.com, clm@fb.com, operations@siteground.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Add ratelimiting to printing facility
Message-ID: <20160712132044.GC10595@suse.cz>
Reply-To: dsterba@suse.cz
References: <1468326012-15910-1-git-send-email-kernel@kyup.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1468326012-15910-1-git-send-email-kernel@kyup.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 12, 2016 at 03:20:12PM +0300, Nikolay Borisov wrote:
> Currently the btrfs printk infrastructure doesn't implement any
> kind of ratelimiting.

If you count the whole infrastructure, it does. See ctree.h and macros
ending with _rl (btrfs_err_rl), and should be used where the messages
are likely to flood. Otherwise I think "more is better" regarding
messages as this is helpful when debugging issues.

> Recently I came accross a case where due to
> FS corruption an excessive amount of printk caused the softlockup
> detector to trigger and reset the server. This patch aims to avoid
> two types of issue: 
>  * I want to avoid different levels of messages interefere with the
>  ratelimiting of oneanother so as to avoid a situation where a 
>  flood of INFO messages causes the ratelimit to trigger, 
>  potentially leading to supression of more important messages. 

Yeah, that's my concern as well. What if there's a burst of several
error messages that do not fit to the limit and some of them get
dropped.

>  * Avoid a flood of any type of messages rendering the machine 
>  unusable

While I'd rather set a per-message ratelimiting, it's possible that an
unexpected error will start flooding. So some sort of per-level limiting
could be implemented, as you propose, but I'd suggest to set the numbers
higher. That way it would still flood up to certain level but should
avoid the lockups.
