From: Mark Fasheh <mfasheh@suse.de>
Subject: Re: [PATCH 0/3] btrfs: extended inode refs
Date: Thu, 12 Apr 2012 09:19:03 -0700
Message-ID: <20120412161903.GP17950@wotan.suse.de>
References: <1333656543-4843-1-git-send-email-mfasheh@suse.de> <4F7E0AF9.7070305@suse.de> <4F858312.6090905@jan-o-sch.net> <20120412161113.GM29506@shiny>
Reply-To: Mark Fasheh <mfasheh@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Chris Mason <chris.mason@oracle.com>,
	Jan Schmidt <list.btrfs@jan-o-sch.net>,
	Jeff Mahoney <jeffm@suse.de>, linux-btrfs@vger.kernel.org,
	Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120412161113.GM29506@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 12, 2012 at 12:11:13PM -0400, Chris Mason wrote:
> On Wed, Apr 11, 2012 at 03:11:46PM +0200, Jan Schmidt wrote:
> > Hi Jeff,
> > > 
> > >> An alternative solution to dealing with collisions could be to
> > >> emulate the dir-item insertion code - specifically something like
> > >> insert_with_overflow() which will stuff multiple items under one
> > >> key. I tend to prefer the idea of
> > > 
> > > I vote for this option.
> 
> [ Big patch series, thanks Mark! ]
> 
> I prefer the insert_with_overflow because it makes the deletion case
> less complex.  If we handle collisions with bits in the offset, we have
> to search around in the tree to find the key that was actually used to
> insert the item.
> 
> The insert_with_overflow code uses just one key, at the cost of having
> to search around inside the item.

Yeah this actually turns out to be a bit easier to code as well. I'm taking
this approach.
	--Mark

--
Mark Fasheh
