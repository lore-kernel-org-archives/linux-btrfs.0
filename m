Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53660 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752574AbdATSTA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Jan 2017 13:19:00 -0500
Date: Fri, 20 Jan 2017 19:18:41 +0100
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        kernel-team@fb.com
Subject: Re: [PATCH] Btrfs: refactor btrfs_extent_same() slightly
Message-ID: <20170120181841.GE11951@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <0e35cf0b96176e03494585709f5170dff94e1e55.1484724993.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0e35cf0b96176e03494585709f5170dff94e1e55.1484724993.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 17, 2017 at 11:37:38PM -0800, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> This was originally a prep patch for changing the behavior on len=0, but
> we went another direction with that. This still makes the function
> slightly easier to follow.
> 
> Reviewed-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> Signed-off-by: Omar Sandoval <osandov@fb.com>
> ---
> Qu thought this would still be a worthwhile cleanup. I'm fine either
> way. Applies to Dave's for-next branch.

Reviewed-by: David Sterba <dsterba@suse.com>
