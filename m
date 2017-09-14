Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59037 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751370AbdINR6j (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Sep 2017 13:58:39 -0400
Date: Thu, 14 Sep 2017 19:57:07 +0200
From: David Sterba <dsterba@suse.cz>
To: Jan Kara <jack@suse.cz>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk@kernel.org>, ceph-devel@vger.kernel.org,
        "Yan, Zheng" <zyan@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
        linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>
Subject: Re: [PATCH 02/15] btrfs: Use pagevec_lookup_range_tag()
Message-ID: <20170914175707.GX29043@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170914131819.26266-1-jack@suse.cz>
 <20170914131819.26266-3-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170914131819.26266-3-jack@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 14, 2017 at 03:18:06PM +0200, Jan Kara wrote:
> We want only pages from given range in btree_write_cache_pages() and
> extent_write_cache_pages(). Use pagevec_lookup_range_tag() instead of
> pagevec_lookup_tag() and remove unnecessary code.
> 
> CC: linux-btrfs@vger.kernel.org
> CC: David Sterba <dsterba@suse.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Reviewed-by: David Sterba <dsterba@suse.com>
