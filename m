Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:34205 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190Ab2J3Xbv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Oct 2012 19:31:51 -0400
Date: Wed, 31 Oct 2012 00:31:46 +0100
From: David Sterba <dave@jikos.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] Btrfs: make snapshot-aware defrag as a mount option
Message-ID: <20121030233146.GB3102@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1351333721-3220-1-git-send-email-bo.li.liu@oracle.com>
 <1351333721-3220-2-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1351333721-3220-2-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Oct 27, 2012 at 06:28:41PM +0800, Liu Bo wrote:
> This feature works on our crucial write endio path, so if we've got
> lots of fragments to process, it will be kind of a disaster to the
> performance, so I make such a change.
> 
> One can benifit from it while mounting with '-o snap_aware_defrag'.

I vote for a more fine grained control over this feature, ie.  via
'btrfs fi defrag', off by default (current behaviour). The defrag ioctl
is the only place that actually calls set_extent_defrag, so this will
not affect normal operation and is fully in hands of the user who runs
defrag.

Do you have a usecase for setting it through the mount option?

thanks,
david
