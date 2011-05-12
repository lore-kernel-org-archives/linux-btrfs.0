From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH 2/4] Btrfs: don't look at the extent buffer level 3 times
 in a row
Date: Thu, 12 May 2011 17:42:47 +0200
Message-ID: <20110512154247.GQ12709@twin.jikos.cz>
References: <1305149755-4413-1-git-send-email-josef@redhat.com>
 <1305149755-4413-2-git-send-email-josef@redhat.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1305149755-4413-2-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Wed, May 11, 2011 at 05:35:53PM -0400, Josef Bacik wrote:
> We have a bit of debugging in btrfs_search_slot to make sure the level of the
> cow block is the same as the original block we were cow'ing.  I don't think I've
> ever seen this tripped, so kill it.  This saves us 2 kmap's per level in our
> search.  Thanks,

I think it may be worth to add a CONFIG_BTRFS_DEBUG to switch on some
(even expensive) checks, eg. like this one, rather than deleting them.


david
