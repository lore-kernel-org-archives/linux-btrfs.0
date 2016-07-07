Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40184 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253AbcGGOHc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Jul 2016 10:07:32 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id EBC97ABA6
	for <linux-btrfs@vger.kernel.org>; Thu,  7 Jul 2016 14:07:30 +0000 (UTC)
Date: Thu, 7 Jul 2016 16:07:51 +0200
From: David Sterba <dsterba@suse.cz>
To: jeffm@suse.com
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/31] btrfs: simplify use of struct btrfs_root pointers
Message-ID: <20160707140751.GZ13336@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1466806524-27508-1-git-send-email-jeffm@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1466806524-27508-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 24, 2016 at 06:14:53PM -0400, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
> One of the common complaints I've heard from new and experienced
> developers alike about the btrfs code is the ubiquity of
> struct btrfs_root.  There is one for every tree on disk and it's not
> always obvious which root is needed in a particular call path.  It can
> be frustrating to spend time figuring out which root is required only
> to discover that it's not actually used for anything other than
> getting the fs-global struct btrfs_fs_info.
> 
> The patchset contains several sections.
[...]

The whole series looks very good. The patches are well split and
reviewable. I'll take the squashed series, but due to the merge
conflicts I'll  merge it last on top of other patches that have been
sent before.
