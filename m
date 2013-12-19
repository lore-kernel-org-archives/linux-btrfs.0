Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60645 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755916Ab3LSQsl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Dec 2013 11:48:41 -0500
Date: Thu, 19 Dec 2013 17:48:39 +0100
From: David Sterba <dsterba@suse.cz>
To: Michael Welsh Duggan <mwd@cert.org>
Cc: dsterba@suse.cz, Wang Shilong <wangsl.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org, miaox@cn.fujitsu.com
Subject: Re: [PATCH] Btrfs-progs: receive: fix the case that we can not find
 subvolume
Message-ID: <20131219164839.GG6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1387271629-11315-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
 <20131217150919.GP6498@twin.jikos.cz>
 <tntbo0fcwp2.fsf@watermonitor.yellow.cert.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <tntbo0fcwp2.fsf@watermonitor.yellow.cert.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 17, 2013 at 10:40:41AM -0500, Michael Welsh Duggan wrote:
> David Sterba <dsterba@suse.cz> writes:
> 
> > On Tue, Dec 17, 2013 at 05:13:49PM +0800, Wang Shilong wrote:
> >> If we change our default subvolume, btrfs receive will fail to find
> >> subvolume. To fix this problem, i have two ideas.
> >> 
> >> 1.make btrfs snapshot ioctl support passing source subvolume's objectid
> >
> >> 2.when we want to using interval subvolume path, we mount it other place
> >> that use subvolume 5 as its default subvolume.
> >
> > 3. Tell the user to mount the toplevel subvol by himself and run receive
> >    again
> 
> Ugh.  I hope that would be considered a short-term hack waiting for a
> better solution, perhaps requiring a kernel upgrade.  From a user's
> perspective there is no reason this should be necessary, and requiring
> this would be extraordinarily surprising.  "Why is btrfs unable to find
> my snapshot?  It's right there!"  Moreover, this used to work just fine
> in previous versions of btrfs-progs.

It is a short-term fix, one that we can apply immediatelly without
breaking things. A long-term fix is #1, but this would need more work
and testing.

david
