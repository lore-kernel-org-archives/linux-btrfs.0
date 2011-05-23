From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 1/9] Btrfs: introduce sub transaction stuff
Date: Mon, 23 May 2011 10:40:41 -0400
Message-ID: <1306161195-sup-8189@shiny>
References: <1305792692-10635-1-git-send-email-liubo2009@cn.fujitsu.com> <1305792692-10635-2-git-send-email-liubo2009@cn.fujitsu.com> <1305850961-sup-454@shiny>
Content-Type: text/plain; charset=UTF-8
Cc: Liu Bo <liubo2009@cn.fujitsu.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	josef <josef@redhat.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <1305850961-sup-454@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Chris Mason's message of 2011-05-19 20:23:29 -0400:
> Excerpts from Liu Bo's message of 2011-05-19 04:11:24 -0400:
> > Introduce a new concept "sub transaction",
> > the relation between transaction and sub transaction is
> > 
> > transaction A       ---> transid = x
> >    sub trans a(1)   ---> sub_transid = x+1
> >    sub trans a(2)   ---> sub_transid = x+2
> >      ... ...
> >    sub trans a(n-1) ---> sub_transid = x+n-1
> >    sub trans a(n)   ---> sub_transid = x+n
> > transaction B       ---> transid = x+n+1
> >      ... ...
> > 
> > And the most important is
> > a) a trans handler's transid now gets value from sub transid instead of transid.
> > b) when a transaction commits, transid may not added by 1, but depend on the
> >    biggest sub_transaction of the last neighbour transaction,
> >    i.e.
> >         B->transid = a(n)->transid + 1,
> >         (B->transid - A->transid) >= 1
> > c) we start a new sub transaction after a fsync.
> > 
> > We also ship some 'trans->transid' to 'trans->transaction->transid' to
> > ensure btrfs works well and to get rid of WARNings.
> > 
> > These are used for the new log code.
> 
> This is exactly what I had in mind.  I need to read it harder and make
> sure it interacts well with the directory logging code, but I love it.

Ok, I hit a few problems with this, and since the transids are used
everywhere for various reasons, I think we need to wait until 2.6.41.
This code is really very close to right, but we have the delayed inode
work, scrub, and the new inode number allocator all at once.  I'd like
to limit the size of the changes.

The problems I hit:

When an inode is dropped from cache (just via iput) and then read in
again, the BTRFS_I(inode)->logged_trans goes back to zero.  When this
happens the logging code assumes the inode isn't in the log and hits
-EEXIST if it finds inode items.

I patched it to just delete away all the logged items if the logged
transid wasn't set, which is probably safest given that we can now reuse
inode numbers.

Second, we use the generation number of the super to read in the log
tree root after a crash.  This doesn't always match the sub trans id and
so it doesn't always match the transid stored in the btree blocks.

There are a few solutions to this, we can use some of the reserved
fields in the super for the generation numbers of the roots the super
points to, and use whichever one is bigger when we read things in.

Liubo, since we'll leave this one for .41, I'll take your smaller patch
that just skips the csum items.

-chris
