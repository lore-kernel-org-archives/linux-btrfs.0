Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38275 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755393AbaFSN2s (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Jun 2014 09:28:48 -0400
Date: Thu, 19 Jun 2014 15:28:45 +0200
From: David Sterba <dsterba@suse.cz>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: Adam Buchbinder <abuchbinder@google.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Fix undefined behavior in radix-tree.c.
Message-ID: <20140619132845.GC1903@suse.cz>
Reply-To: dsterba@suse.cz
References: <1402694330-21211-1-git-send-email-abuchbinder@google.com>
 <53A12FAE.7060307@jp.fujitsu.com>
 <20140618144342.GV1903@twin.jikos.cz>
 <53A2389F.6050404@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53A2389F.6050404@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 19, 2014 at 10:10:55AM +0900, Satoru Takeuchi wrote:
> It's fixed at 430d275a399.
> 
> ===============================================================================
> commit 430d275a399175c7c0673459738979287ec1fd22
> Author: Peter Lund <firefly@vax64.dk>
> Date:   Tue Oct 16 23:29:35 2007 -0700
> 
>     avoid negative (and full-width) shifts in radix-tree.c
> ...
> ===============================================================================
> 
> Adam, David, how about import this patch from kernel, rather than
> writing btrfs-progs's own patch?

Well, I think there's non-trivial time spent by Adam on the patch so I'd
rather keep the credit, even if a patch that backports the fix from
kernel would look cleaner in git log. Such things happen, sometimes it
makes sense to replace patches or do changes inline.

The progs development is moving forward quickly, a clean patch history
is most useful when there is a separate stable branch that receives
bugfixes as it helps the backporters to identify complete fixes. Not the
case for progs right now.

> I consider It's better to regularly sync such utility code with
> the newest kernel code for the long term...

Yes. The radix- or rb- tree code does not change often though, we can do
a sync now and be fine for some time.
