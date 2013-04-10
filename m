Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59184 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752110Ab3DJPwy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Apr 2013 11:52:54 -0400
Date: Wed, 10 Apr 2013 17:52:50 +0200
From: David Sterba <dsterba@suse.cz>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: dsterba@suse.cz, Liu Bo <bo.li.liu@oracle.com>,
        linux-btrfs@vger.kernel.org, martin.krizek@gmail.com
Subject: Re: [PATCH 1/2] Btrfs: online data deduplication
Message-ID: <20130410155250.GQ18193@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1365340369-23537-1-git-send-email-bo.li.liu@oracle.com>
 <1365340369-23537-2-git-send-email-bo.li.liu@oracle.com>
 <20130408134726.GD18193@twin.jikos.cz>
 <5163746A.50902@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5163746A.50902@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 09, 2013 at 09:52:42AM +0800, Miao Xie wrote:
> On 	mon, 8 Apr 2013 15:47:27 +0200, David Sterba wrote:
> > This also depends on file data type and access patterns, fixing the dedup
> > basic chunk size to one block does not IMHO fit most usecases.
> 
> Maybe we can make btrfs(including dedup) support the bigalloc just like ext4.

dedup does not strictly need this, I agree it could make a few things
easier to implement. But I think it removes some flexibility once the
bigalloc cluster size is set, what if I want to change the dedup chunk
size because the structure of my data changed?

david
