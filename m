Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35355 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877AbcBAXoA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Feb 2016 18:44:00 -0500
Date: Tue, 2 Feb 2016 00:43:45 +0100
From: David Sterba <dsterba@suse.cz>
To: Mark Fasheh <mfasheh@suse.de>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>,
        Chris Mason <clm@fb.com>
Subject: Re: [PATCH] btrfs-progs: add 'du' command
Message-ID: <20160201234345.GJ31992@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1453326567-20454-1-git-send-email-mfasheh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1453326567-20454-1-git-send-email-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Wed, Jan 20, 2016 at 01:49:24PM -0800, Mark Fasheh wrote:
> A git tree of the patches can be found here:
> 
> https://github.com/markfasheh/btrfs-progs-patches/tree/du

what changed since the previous posting?

Otherwise code looks ok, I saw use of uint64_t, the units help can be
extended to the full units set, and maybe other minor things that would
be good to fix. I'll do a more fine grained review when applying the
patches.
