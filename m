Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56891 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752073Ab3B1MkL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Feb 2013 07:40:11 -0500
Date: Thu, 28 Feb 2013 13:40:08 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org, zab@redhat.com
Subject: Re: [PATCH] btrfs: cleanup for open-coded alignment
Message-ID: <20130228124008.GQ27541@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1361866222-5746-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20130227115944.GA27541@twin.jikos.cz>
 <512EA9DD.9010003@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <512EA9DD.9010003@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 28, 2013 at 08:50:37AM +0800, Qu Wenruo wrote:
> >I have covered all cases in my original patch with a coccinelle semantic
> >patch http://www.spinics.net/lists/linux-btrfs/msg12750.html and also
> >removed the useless stripe_align helper and updated it's callers (and it
> >still applies after merging the raid56 code that updated the function
> >with 2 unused arguments).
> Thanks for pointing out the original rules.
> The orginal rules is pretty good but can only
> deal with the open-coded alignment in one line.
> 
> If there is something using varient "mask",
> the rules seems no help like the following:
> ------
> 
>         u64 mask = ((u64)root->stripesize - 1);
>         u64 ret = (val + mask) & ~mask;

You're right, the semantic patch does not cover that, so you've found
more cases in the end, that's good.

> And sorry for the wrong signed-off, it seems that I'm using one of your
> deprecated mail address.

Still active, but I prefer to use the $job one.

david
