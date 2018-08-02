Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46332 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728797AbeHBOIg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 2 Aug 2018 10:08:36 -0400
Date: Thu, 2 Aug 2018 14:17:36 +0200
From: David Sterba <dsterba@suse.cz>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Cc: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 11/15] btrfs-progs: Add delayed refs infrastructure
Message-ID: <20180802121735.GL3218@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1528462078-24490-1-git-send-email-nborisov@suse.com>
 <1528462078-24490-12-git-send-email-nborisov@suse.com>
 <7b355214-d883-c67d-a6a8-12e8aa32bc19@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <7b355214-d883-c67d-a6a8-12e8aa32bc19@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 30, 2018 at 05:34:54PM +0900, Misono Tomohiro wrote:
> to correctly count num_entries.
> (I noticed that num_entries went to negative value when I'm running gdb)
> 
> However, num_entries is actually not used in progs at all (it is used for
> throttling in kernel), so maybe we can just drop the variable from progs?

The long-term goal is to use the same source for kernel and progs where
possible and where it does not cause trouble. We can add stubs for
spinlocks, atomics etc and could live with a few variables that are not
used in progs.

Right now I'm ok with both ways, ie. when it's easier to take the kernel
code as-is and add stubs, or drop the unused bits now when porting to
progs.
