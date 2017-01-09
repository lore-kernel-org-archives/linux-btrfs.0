Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38850 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752709AbdAIJbv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Jan 2017 04:31:51 -0500
Date: Mon, 9 Jan 2017 01:31:48 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>, linux-btrfs@vger.kernel.org,
        Jeff Mahoney <jeffm@suse.com>, David Sterba <dsterba@suse.com>
Subject: Re: [RFC] Converging userspace and kernel code
Message-ID: <20170109093148.GA7341@infradead.org>
References: <512c15bf-3c4b-3b88-1106-a7d43386400f@suse.de>
 <65341974-d15f-408c-abad-98c2a5bb8743@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <65341974-d15f-408c-abad-98c2a5bb8743@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 09, 2017 at 10:11:29AM +0800, Qu Wenruo wrote:
> (I'm already trying to re-implement btrfs_map_block() in btrfs-progs with a
> better interface in out-of-tree offline scrub patchset)

How about doing the right thing in the kernel as well?  While looking
at the btrfs abuse of the block REQ_* flag I had to read and understand
__btrfs_map_block and agree it's ripe for refactoring.
