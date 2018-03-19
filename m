Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56266 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755194AbeCSNak (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Mar 2018 09:30:40 -0400
Date: Mon, 19 Mar 2018 14:28:14 +0100
From: David Sterba <dsterba@suse.cz>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: dsterba@suse.cz, Hugo Mills <hugo@carfax.org.uk>,
        "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: mkfs: add uuid and otime to ROOT_ITEM of
 FS_TREE
Message-ID: <20180319132814.GH6955@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <7ca269db-a724-5938-f4d8-b85e893fd558@jp.fujitsu.com>
 <20180319082010.GC17966@carfax.org.uk>
 <20180319130222.GE6955@twin.jikos.cz>
 <1521465998.3786.2.camel@scientia.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1521465998.3786.2.camel@scientia.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 19, 2018 at 02:26:38PM +0100, Christoph Anton Mitterer wrote:
> On Mon, 2018-03-19 at 14:02 +0100, David Sterba wrote:
> > We can do that by a special purpose tool.
> 
> No average user will ever run (even know) about that...
> 
> Could you perhaps either do it automatically in fsck (which is IMO als
> a bad idea as fsck should be read-only per default)... or at least add
> a warning to fsck, like a "Info: Please run tool foo to get bar done."?

Makes sense, check can warn and point to the command, in a similar way
we have the fix-device-count.
