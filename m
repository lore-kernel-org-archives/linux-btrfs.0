Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51683 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754520AbbICNSC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 3 Sep 2015 09:18:02 -0400
Date: Thu, 3 Sep 2015 15:17:20 +0200
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: scrub: set error stats when tree block spanning
 stripes
Message-ID: <20150903131719.GR11834@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <981687019fcca4b4f7455b7a755e48888cbd24ff.1440510311.git.zhaolei@cn.fujitsu.com>
 <20150826171949.GA11834@twin.jikos.cz>
 <03b601d0e069$ddd50ee0$997f2ca0$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <03b601d0e069$ddd50ee0$997f2ca0$@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 27, 2015 at 09:44:05AM +0800, Zhao Lei wrote:
[...]

Thanks for the links and summary!

> But it is still uncorrectable because neither kernel nor btrfsck can fix
> it(only can report).

I'm curious if it' is possible to write code that would fix the problem,
eg. te relocate or shift the blocks. The 'btrfs rescue' command group is
meant for this type of targeted fixes, unless it's easy to integrate it
to the check & repair itself.

> In short, it is caused by old version of btrfs-convert, and already fixed,
> and this patch is used to make scrub report it in output.

I assume there are people affected by this problem so it would be good
to have a repair tool.
