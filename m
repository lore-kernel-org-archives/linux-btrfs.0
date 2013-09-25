Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52149 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754886Ab3IYOqp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Sep 2013 10:46:45 -0400
Date: Wed, 25 Sep 2013 16:46:41 +0200
From: David Sterba <dsterba@suse.cz>
To: Guenther Starnberger <linux-btrfs@gst.priv.at>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: kernel BUG at fs/btrfs/relocation.c:1060 during rebalancing
Message-ID: <20130925144641.GW6810@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20130925065647.GC13842@gst.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130925065647.GC13842@gst.name>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 25, 2013 at 08:56:47AM +0200, Guenther Starnberger wrote:
> On one of my btrfs filesystems I'm encountering a reproducable kernel bug
> during rebalancing. This issue originally appeared on Linux 3.11.1, but I am
> also able to reproduce it in a VM using btrfs-next (c024ca6) and Linux
> 3.12-rc2 (4a10c2a).

3.12-rc really? I'd like to see the stacktrace then.

> kernel BUG at fs/btrfs/relocation.c:1060!
> RIP: 0010:[<ffffffffa04f5d3a>]  [<ffffffffa04f5d3a>] build_backref_tree+0x112a/0x11d0 [btrfs]

This matches the known bug in 3.11, fix was submitted to 3.11.x stable.


thanks,
david
