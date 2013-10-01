Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58619 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561Ab3JAOu4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 1 Oct 2013 10:50:56 -0400
Date: Tue, 1 Oct 2013 16:50:50 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 0/9] btrfs: Replace the btrfs_workers with kernel
 workqueue
Message-ID: <20131001145050.GJ18291@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1378973304-11693-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20130912173718.GE6810@twin.jikos.cz>
 <523BE774.4070808@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <523BE774.4070808@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 20, 2013 at 02:13:08PM +0800, Qu Wenruo wrote:
> >* WQ_MEM_RECLAIM for the scrub thread does not seem right
> I think scrub_workers,scrub_wr_completion_workers still need WQ_MEM_RECLAIM.
> However scrub_nocow_workers does not need WQ_MEM_RECLAIM flags.
> 
> Did you mean this?
> 
> If you didn't mean this, would you please tell me why the WQ_MEM_RECLAIM is
> not
> needed?

Documentation says that threads that might be used in the memory reclaim
path must use this flag, but I don't see how this applies to scrub
threads. They're not writing out dirty data, though they may issue a
write, but that's not their main purpose.
