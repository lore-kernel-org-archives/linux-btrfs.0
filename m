Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41710 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933994AbcGKQlS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jul 2016 12:41:18 -0400
Date: Mon, 11 Jul 2016 18:41:29 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Re: [PATCH v12.1 01/15] btrfs: expand cow_file_range() to support
 in-band dedup and subpage-blocksize
Message-ID: <20160711164129.GA13336@suse.cz>
Reply-To: dsterba@suse.cz
References: <20160711030543.30115-1-quwenruo@cn.fujitsu.com>
 <20160711030543.30115-2-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160711030543.30115-2-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 11, 2016 at 11:05:29AM +0800, Qu Wenruo wrote:
> From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
> 
> Extract cow_file_range() new parameters for both in-band dedupe and
> subpage sector size patchset.
> 
> This should make conflict of both patchset to minimal, and reduce the
> effort needed to rebase them.

Great, thanks. I did a test merge, there are still conflicts but they
seem to be resolvable more easily, picking the changes from the right
patchset. I haven't tested it so there's more work, but the point was to
get the conflict surface down.

There's another candidate, btrfs_set_extent_delalloc as it adds a
parameter, can you please send a similar patch for that?
