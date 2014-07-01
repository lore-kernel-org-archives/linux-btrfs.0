Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43531 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757248AbaGAWqL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 1 Jul 2014 18:46:11 -0400
Date: Wed, 2 Jul 2014 00:46:08 +0200
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix race between balance recovery and root
 deletion
Message-ID: <20140701224608.GS1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1403752096-4776-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1403752096-4776-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 26, 2014 at 11:08:16AM +0800, Wang Shilong wrote:
> Balance recovery is called when RW mounting or remounting from
> RO to RW, it is called to finish roots merging.
> 
> When doing balance recovery, relocation root's corresponding
> fs root(whose root refs is 0) might be destroyed by cleaner
> thread, this will make btrfs fail to mount.
> 
> Fix this problem by holding @cleaner_mutex when doing balance
> recovery.
> 
> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

I don't pretend to understand all the dark corners of relocation, but
this looks as a correct fix to me. Relocation and cleaner are mutually
exclusive in the normal case.

Reviewed-by: David Sterba <dsterba@suse.cz>
