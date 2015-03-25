Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55370 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752915AbbCYNyu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Mar 2015 09:54:50 -0400
Date: Wed, 25 Mar 2015 14:54:48 +0100
From: David Sterba <dsterba@suse.cz>
To: Filipe Manana <fdmanana@suse.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] fstests: test for btrfs incremental send/receive
Message-ID: <20150325135448.GG20767@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1425837090-27069-1-git-send-email-fdmanana@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1425837090-27069-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 08, 2015 at 05:51:30PM +0000, Filipe Manana wrote:
> Test for incremental send where the difference between the parent and
> send snapshots is that for a subtree with the same path in both snapshots
> (p1/p2), the root directories were swapped.
> 
> This issue was fixed by the following linux kernel btrfs patch:
> 
>   Btrfs: incremental send, clear name from cache after orphanization
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: David Sterba <dsterba@suse.cz>

Tested with 4.0-rc5, the kernel fix is not merged yet so the test fails
for now.
