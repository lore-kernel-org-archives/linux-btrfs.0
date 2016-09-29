Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47068 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752132AbcI2L7N (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Sep 2016 07:59:13 -0400
Date: Thu, 29 Sep 2016 13:59:11 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v3] btrfs-progs: Return more meaningful value for
 btrfs_read_deve_super
Message-ID: <20160929115911.GB5531@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160926045426.14340-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160926045426.14340-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 26, 2016 at 12:54:26PM +0800, Qu Wenruo wrote:
> btrfs_read_dev_super() only returns 0 or -1, which doesn't really help,
> caller won't know if it's caused by bad superblock or superblock out of
> range.
> 
> Return -errno if pread64() return -1, and return -EOF if none or part of
> the super is read out, and return what check_super() returned.
> 
> So caller can get -EIO to catch real corrupted super blocks.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Applied, thanks.
