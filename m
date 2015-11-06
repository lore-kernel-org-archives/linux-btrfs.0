Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42995 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031997AbbKFKzZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 6 Nov 2015 05:55:25 -0500
Date: Fri, 6 Nov 2015 11:53:53 +0100
From: David Sterba <dsterba@suse.cz>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs progs pre-release 4.3-rc1
Message-ID: <20151106105353.GR13624@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20151102151453.GI13624@twin.jikos.cz>
 <pan$92b40$752beab9$f06026e1$b913018c@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$92b40$752beab9$f06026e1$b913018c@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 03, 2015 at 12:10:14AM +0000, Duncan wrote:
> David Sterba posted on Mon, 02 Nov 2015 16:14:53 +0100 as excerpted:
> 
> > the kernel 4.3 was released yesterday, the btrfs-progs will follow at
> > the end of this week. I've tagged an rc1 from current devel branch.
> > There are a lots of small invisible changes and one change in the
> > defaults:
> > 
> > * mkfs: mixed mode is not forced anymore for devices smaller than 1 GiB
> 
> It says one change in the /defaults/, but then it says mixed mode isn't 
> /forced/ anymore under a GiB.

Well, it may be a loose definition of 'default'. I meant a change in the
current behaviour without further tuning.

> Which is it, a change in the /defaults/, under a gig now defaults to 
> separate data/metadata, or same /defaults/, but now there's a way to 
> overrule them and do separate data/metadata under a gig, so while mixed 
> remains the default, it's no longer /forced/?
> 
> If the /defaults/ changed, is mixed mode still /recommended/ for small 
> filesystems?

Yes it is, where small remains < 1 GiB.
