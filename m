Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38334 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757837AbcBBUJX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Feb 2016 15:09:23 -0500
Date: Tue, 2 Feb 2016 12:09:21 -0800
From: Mark Fasheh <mfasheh@suse.de>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org,
        David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>
Subject: Re: [PATCH] btrfs-progs: add 'du' command
Message-ID: <20160202200921.GH24672@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <1453326567-20454-1-git-send-email-mfasheh@suse.de>
 <20160201234345.GJ31992@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160201234345.GJ31992@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 02, 2016 at 12:43:45AM +0100, David Sterba wrote:
> Hi,
> 
> On Wed, Jan 20, 2016 at 01:49:24PM -0800, Mark Fasheh wrote:
> > A git tree of the patches can be found here:
> > 
> > https://github.com/markfasheh/btrfs-progs-patches/tree/du
> 
> what changed since the previous posting?

Nothing major, I rebased it and cleaned up the patches to fit the general
style of btrfs-progs to make thing easier for you to merge.


> Otherwise code looks ok, I saw use of uint64_t, the units help can be
> extended to the full units set, and maybe other minor things that would
> be good to fix. I'll do a more fine grained review when applying the
> patches.

Awesome thanks for that, let me know if there's anything I can do to help
the process along.
	--Mark


--
Mark Fasheh
