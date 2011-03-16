From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Btrfs: check items for correctness as we search
Date: Wed, 16 Mar 2011 14:54:11 -0400
Message-ID: <20110316185411.GC2510@localhost.localdomain>
References: <1300297492-5375-1-git-send-email-josef@redhat.com> <AANLkTikTnYr8hPWCQpVFBzHyA9gSPijiiRv5LBXXpeti@mail.gmail.com> <20110316182913.GB2510@localhost.localdomain> <AANLkTi=CAuTL-wH-KmnqhoJH1hHhucFOzSukE5rJ2PUf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=CAuTL-wH-KmnqhoJH1hHhucFOzSukE5rJ2PUf@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 16, 2011 at 09:34:29PM +0300, Andrey Kuzmin wrote:
> On Wed, Mar 16, 2011 at 9:29 PM, Josef Bacik <josef@redhat.com> wrote:
> 
> > On Wed, Mar 16, 2011 at 09:23:58PM +0300, Andrey Kuzmin wrote:
> > > On Wed, Mar 16, 2011 at 8:44 PM, Josef Bacik <josef@redhat.com> wrote:
> > >
> > > > Currently if we have corrupted items things will blow up in spectacular
> > > > ways.
> > > > So as we search check the item that we are pointing at currently to
> > make
> > > > sure it
> > > >
> > >
> > > Will these checks run multiple times on the same slot? If yes, why not
> > have
> > > an in-memory bit 'checked' and skip checks of already checked items? Or
> > > simply check once when loading from disk?
> > >
> >
> > I thought about this but I have some reservations.  In order to make sure
> > the
> > block is actually right we'd have to check the entire thing when it's read
> > from
> > disk, which isn't too bad, but what happens when only one item in the block
> > is
> > corrupt?
> 
> For example if just the xattr item for an inode is corrupt, this
> > method would keep you from reading the inode item in the same block which
> > could
> > be just fine.
> 
> 
> I've lost you here. If you check once on load, you can just reread and
> that's it.
> 

Hrm I'll be a little clearer.  If in one block we have 4 valid items and one
bogus one, with my current patch we'd only fail if we tried to use the bogus
one, the valid items would work fine.

However if we check on read, we have to verify the _entire_ block, so if 1 item
is broken the entire block is thrown out, and if there were valid items in that
block we won't be able to read those items either.

It seemed to me a better choice to let the user limp along if at all possible,
but I'm not convinced that I'm right, so I could be persuaded to do it on read.
I'll see what other people think.  Thanks,

Josef
