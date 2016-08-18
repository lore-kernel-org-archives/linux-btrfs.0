Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39791 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753890AbcHRN2U (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Aug 2016 09:28:20 -0400
Date: Thu, 18 Aug 2016 15:26:58 +0200
From: David Sterba <dsterba@suse.cz>
To: Sanidhya Solanki <lkml.page@gmail.com>
Cc: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Change RAID stripesize to a user-configurable
 option
Message-ID: <20160818132658.GE16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1469194967-27734-1-git-send-email-lkml.page@gmail.com>
 <20160728113227.GS30795@twin.jikos.cz>
 <20160728114255.0e7559ef@ad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160728114255.0e7559ef@ad>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 28, 2016 at 11:42:55AM -0400, Sanidhya Solanki wrote:
> > I'll comment on the overall approach and skip code-specific comments.
> > 
> > The changelog does not explain why there's a need for a new blockgroup
> > type and what's the relation to the existing types. It seems that it
> > extends the data/metadata/system group, but I think this is totally
> > wrong.
> 
> I agree in principle, but I did not want to modify the existing balance
> targets, but, instead, piggyback on the existing balance implementation
> to re-balance the data.

But this is not about balance. The stripe size is more like node size,
ie. something that gets set at the mkfs time and stays for the
filesystem lifetime. Multiple stripesize values would be hard to
implement at least, not something that we'd do for the first
implementation.

> This approach was recommended to be by an experienced BTrFS developer
> on the IRC as the right way to implement the change.

I want his name. I remember talking to you about that patch but
dismissed the 'another raid group' approach.
