From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Btrfs: check items for correctness as we search
Date: Wed, 16 Mar 2011 14:29:13 -0400
Message-ID: <20110316182913.GB2510@localhost.localdomain>
References: <1300297492-5375-1-git-send-email-josef@redhat.com> <AANLkTikTnYr8hPWCQpVFBzHyA9gSPijiiRv5LBXXpeti@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTikTnYr8hPWCQpVFBzHyA9gSPijiiRv5LBXXpeti@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 16, 2011 at 09:23:58PM +0300, Andrey Kuzmin wrote:
> On Wed, Mar 16, 2011 at 8:44 PM, Josef Bacik <josef@redhat.com> wrote:
> 
> > Currently if we have corrupted items things will blow up in spectacular
> > ways.
> > So as we search check the item that we are pointing at currently to make
> > sure it
> >
> 
> Will these checks run multiple times on the same slot? If yes, why not have
> an in-memory bit 'checked' and skip checks of already checked items? Or
> simply check once when loading from disk?
> 

I thought about this but I have some reservations.  In order to make sure the
block is actually right we'd have to check the entire thing when it's read from
disk, which isn't too bad, but what happens when only one item in the block is
corrupt?  For example if just the xattr item for an inode is corrupt, this
method would keep you from reading the inode item in the same block which could
be just fine.  If this is acceptable for everybody then I don't mind doing it
this way, but the current implementation makes sure we only check what we are
actually interested in so we can have the best possible chance of limping along
if only part of the block is bogus.  Thanks,

Josef
