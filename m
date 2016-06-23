Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60178 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751485AbcFWJJ2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jun 2016 05:09:28 -0400
Date: Thu, 23 Jun 2016 11:09:52 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix BUG_ON in btrfs_submit_compressed_write
Message-ID: <20160623090952.GV4915@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1466645526-27128-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1466645526-27128-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 22, 2016 at 06:32:06PM -0700, Liu Bo wrote:
> This is similar to btrfs_submit_compressed_read(), if we fail after
> bio is allocated, then we can use bio_endio() and errors are saved
>  in bio->bi_error.  But please note that we don't return errors to
> its caller because the caller assumes it won't call endio to cleanup
> on error.

This sounds strange, where do we notice that some of the bios failed?
