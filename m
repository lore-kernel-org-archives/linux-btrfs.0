Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45898 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751157AbbIGMi3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Sep 2015 08:38:29 -0400
Date: Mon, 7 Sep 2015 14:37:44 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Zhao Lei <zhaolei@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: scrub: set error stats when tree block spanning
 stripes
Message-ID: <20150907123744.GU11834@suse.cz>
Reply-To: dsterba@suse.cz
References: <981687019fcca4b4f7455b7a755e48888cbd24ff.1440510311.git.zhaolei@cn.fujitsu.com>
 <20150826171949.GA11834@twin.jikos.cz>
 <03b601d0e069$ddd50ee0$997f2ca0$@cn.fujitsu.com>
 <20150903131719.GR11834@twin.jikos.cz>
 <55E90E21.9020004@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55E90E21.9020004@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 04, 2015 at 11:21:05AM +0800, Qu Wenruo wrote:
> I'm happy and willing to add the relocating ability for btrfs-progs.
> As that will provide a lot of flexibility, while the code should be 
> quite easy if I do it in a NOCOW method.
> (Find a extent, copy it to other place, follow backref and modify)
> 
> The only concern is, does it mean that we need to implement all the 
> features of btrfs kernel in user space tool?

I don't think we need a 1:1 feature parity. We might end up doing a one
chunk relocation, but relocating an extent would be enough for a start.

Doing the operations in userspace is easier in some respects as the data
are not live, we can do different trade-offs, utilize readahead etc.
Some operations might end up significantly faster and might be used as
one-time actions eg. when converting multi-terabyte filesystem to
another raid type. But this is a long-term goal.

> And will it make the codes duplicated between kernel and progs?

At this moment the code is not unified and we have to copy the code from
kernel where needed. But as far as the code does not diverge, it'll be
easier to use exact kernel sources in progs. Current versions of the
common sources are not close enough, so we'd have to unify them first.
