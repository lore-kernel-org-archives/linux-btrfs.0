Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55167 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410Ab3LQNJ4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Dec 2013 08:09:56 -0500
Date: Tue, 17 Dec 2013 14:09:55 +0100
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs: Check read-only status of roots during send
Message-ID: <20131217130955.GL6498@suse.cz>
Reply-To: dsterba@suse.cz
References: <cover.1387211245.git.dsterba@suse.cz>
 <c80eb84e6c8ab788de0f73e332755e27d518f7fd.1387211246.git.dsterba@suse.cz>
 <52B03C60.6060007@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52B03C60.6060007@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 17, 2013 at 07:58:24PM +0800, Wang Shilong wrote:
> Nice work, Before this patch for btrfs send.
> we have to join a transaction to avoid commit root changed.

That sounds like a good improvement.

> I send a plus patch that remove transaction protection from btrfs send.
> and  a little comment below.
> 
> [...]
> On 12/17/2013 12:34 AM, David Sterba wrote:
> >All the subvolues that are involved in send must be read-only during the
> >  s via SUBVOL_SETFLAGS
> >+	 */
> >+	int send_in_progress;
> 
> Why not use u32 here?

The int type should be enough to hold refs for all running sends, if
this is your concern.

I thought it's a refcount, it should not go below 0 but if it does, then
it should be caught. I'll update the patch to check if send_in_progress
is not negative after the decrements.

thanks,
david
