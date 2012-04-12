From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 0/3] btrfs: extended inode refs
Date: Thu, 12 Apr 2012 12:11:13 -0400
Message-ID: <20120412161113.GM29506@shiny>
References: <1333656543-4843-1-git-send-email-mfasheh@suse.de>
 <4F7E0AF9.7070305@suse.de>
 <4F858312.6090905@jan-o-sch.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeff Mahoney <jeffm@suse.de>, Mark Fasheh <mfasheh@suse.de>,
	linux-btrfs@vger.kernel.org, Josef Bacik <josef@redhat.com>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F858312.6090905@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 11, 2012 at 03:11:46PM +0200, Jan Schmidt wrote:
> Hi Jeff,
> > 
> >> An alternative solution to dealing with collisions could be to
> >> emulate the dir-item insertion code - specifically something like
> >> insert_with_overflow() which will stuff multiple items under one
> >> key. I tend to prefer the idea of
> > 
> > I vote for this option.

[ Big patch series, thanks Mark! ]

I prefer the insert_with_overflow because it makes the deletion case
less complex.  If we handle collisions with bits in the offset, we have
to search around in the tree to find the key that was actually used to
insert the item.

The insert_with_overflow code uses just one key, at the cost of having
to search around inside the item.

-chris

