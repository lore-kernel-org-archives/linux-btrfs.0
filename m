Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35355 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030632Ab3HIOq3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 Aug 2013 10:46:29 -0400
Date: Fri, 9 Aug 2013 16:46:26 +0200
From: David Sterba <dsterba@suse.cz>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Filipe David Borba Manana <fdmanana@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: set default max_inline to 8KiB instead of 8MiB
Message-ID: <20130809144626.GL5284@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1375998348-20639-1-git-send-email-fdmanana@gmail.com>
 <5204826C.3060902@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5204826C.3060902@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 09, 2013 at 01:47:24PM +0800, Miao Xie wrote:
> On thu, 8 Aug 2013 22:45:48 +0100, Filipe David Borba Manana wrote:
> > 8MiB is way too large and likely set by mistake. This is not
> > a significant issue as in practice the max amount of data
> > added to an inline extent is also limited by the page cache
> > and btree leaf sizes.
> 
> I don't think 8KB is a reasonable value of the default max inline size
> because it makes no sense on the machine whose page size is 4KB.

Page size limit is artificial implied by the implementation and on a 4k
page machine max_inline does not take place. Even if it's 4k, it does
not apply because the leaf space is smaller.

> I think 4KB is a reasonable value, because we may mount the fs on
> the machines with the different page size in the future, in order to
> avoid the compatible problem, we should use the min page size as
> the max inline size.

If there's support for mounting a fs with sectorsize != pagesize, this
will work automatically. Currently such filesystem fails to mount, as we
know.

Whether it's 4k or 8k could be decided by the performance impact, but I
have no numbers to vote for either.

david
