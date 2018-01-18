Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44772 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932124AbeARPTH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Jan 2018 10:19:07 -0500
Date: Thu, 18 Jan 2018 16:16:56 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: raid56: iterate raid56 internal bio with
 bio_for_each_segment_all
Message-ID: <20180118151656.GN13726@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180113010702.25612-1-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180113010702.25612-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 12, 2018 at 06:07:01PM -0700, Liu Bo wrote:
> Bio iterated by set_bio_pages_uptodate() is raid56 internal one, so it
> will never be a BIO_CLONED bio, and since this is called by end_io
> functions, bio->bi_iter.bi_size is zero, we mustn't use
> bio_for_each_segment() as that is a no-op if bi_size is zero.
> 
> Fixes: 6592e58c6b68e61f003a01ba29a3716e7e2e9484 ("Btrfs: fix write corruption due to bio cloning on raid5/6")
> Cc: <stable@vger.kernel.org> # v4.12-rc6+
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Tested and added to 4.16 queue, thanks.
