From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH 2/4] Btrfs: don't look at the extent buffer level 3
	times in a row
Date: Thu, 12 May 2011 15:36:02 -0400
Message-ID: <20110512193602.GE19041@dhcp231-156.rdu.redhat.com>
References: <1305149755-4413-1-git-send-email-josef@redhat.com> <1305149755-4413-2-git-send-email-josef@redhat.com> <20110512154247.GQ12709@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110512154247.GQ12709@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 12, 2011 at 05:42:47PM +0200, David Sterba wrote:
> Hi,
> 
> On Wed, May 11, 2011 at 05:35:53PM -0400, Josef Bacik wrote:
> > We have a bit of debugging in btrfs_search_slot to make sure the level of the
> > cow block is the same as the original block we were cow'ing.  I don't think I've
> > ever seen this tripped, so kill it.  This saves us 2 kmap's per level in our
> > search.  Thanks,
> 
> I think it may be worth to add a CONFIG_BTRFS_DEBUG to switch on some
> (even expensive) checks, eg. like this one, rather than deleting them.
> 

I had thought about that, but then decided to be lazy.  Thanks,

Josef
