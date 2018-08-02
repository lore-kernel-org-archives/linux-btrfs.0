Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45384 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387503AbeHBQf3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 2 Aug 2018 12:35:29 -0400
Date: Thu, 2 Aug 2018 16:43:54 +0200
From: David Sterba <dsterba@suse.cz>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: Use wrapper macro for rcu string to remove
 duplicate code
Message-ID: <20180802144354.GO3218@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1533189995.git.misono.tomohiro@jp.fujitsu.com>
 <0181282c-c4e3-3193-8320-57b2ec3019dc@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0181282c-c4e3-3193-8320-57b2ec3019dc@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 02, 2018 at 04:19:07PM +0900, Misono Tomohiro wrote:
> Cleanup patch and no functional changes.
> 
> Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>

Nice. Added to misc-next, thanks.
