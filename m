Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43952 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974AbcEJMox (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 May 2016 08:44:53 -0400
Date: Tue, 10 May 2016 14:44:29 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: jbacik@fb.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFC v2 00/16] Introduce low memory usage btrfsck mode
Message-ID: <20160510124429.GR29353@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1461914350-19875-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1461914350-19875-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 29, 2016 at 03:18:54PM +0800, Qu Wenruo wrote:
> The branch can be fetched from my github:
> https://github.com/adam900710/btrfs-progs.git low_mem_fsck_rebasing
...
> Changelog:
>   v1.1:
>     Fix a typo which makes keyed data backref check always fail
>   v2:
>     Don't return minus value with error bits. (Suggested by Josef)
>     Follow kernel code styling. (Suggested by Josef)
>     Enhance check on data backref count. (Slow down check speed though)

Is the branch low_mem_fsck_rebasing supposed to track the latest
version? I still see the negative values for error flags there.

I guess last thing you'd like to see commented in this patchset is
message formatting but it's consistently not matching the preferred
style everywhere, so please don't start the message with capitals, eg.:

	error("Block group[%llu %llu] relat..."

Testing the branch on the images in repository reported no problems
which is enough to add the branch to integration, but otherwise I'll
wait for Josef's review.
