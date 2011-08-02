From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [RFC] btrfs send and receive
Date: Tue, 02 Aug 2011 11:21:06 -0400
Message-ID: <1312298057-sup-3959@shiny>
References: <4E369A80.9030307@jan-o-sch.net> <4E36F5B8.5090803@libero.it> <4E37C6CB.1030201@jan-o-sch.net>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	Goffredo Baroncelli <kreijack@libero.it>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4E37C6CB.1030201@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Jan Schmidt's message of 2011-08-02 05:43:39 -0400:
> 
> On 01.08.2011 20:51, Goffredo Baroncelli wrote:
> > On 08/01/2011 02:22 PM, Jan Schmidt wrote:
> > 
> >> I furthermore realized that the term "subvolume" is omitted in favor >
> > of the term "snapshot". This is because I tend to think of snapshots
> >> being read-only (though I very much appreciate they are not). Just
> >> replace the term wherever you feel appropriate.
> > 
> > I think that we have to cope to both the terms. A snapshot is a
> > subvolume with an ancestor. This is important if we want to be able to
> > "transfer" between two filesystem a snapshot as subvolume + delta.
> 
> To be precise, each snapshot is again a subvolume. On the other hand, we
> can call every subvolume but the root subvolume a (writable) snapshot.
> I'd like to continue discussing the real points now :-)

First: awesome!  I can't wait to have this feature.

I think you have a very sound list of requirements here, but I'll add
one more.  If there are metadata corruptions on the sender, we must not
transmit them over to the receiver.  In order for the send/receive
command to be a backup, it needs to have a first-do-no-harm rule to the
receiving end.

In terms of formats, I came to similar conclusions a while ago about
cpio, tar and dar.  I haven't looked in detail at pax but don't have any
strong feelings against it.

But, I'll toss in an alternative.  Adapt the git pack files a little and
use them as the format.  There are a few reasons for this:

Git has a very strong developer community and is already being
hammered into use as a backup application.  You'll find a lot of
interested people to help out.

Git separates the contents from the metadata (names).  This makes it
naturally suited to describing snapshots and other features.  The big
exception is in large file handling, but you could extend the format to
describe filename,offset,len->sha instead of just filename->sha.

This doesn't mean I'll reject a pax setup, it's just an alternative to
think about.  We should have the actual data transmission format pretty
well abstracted away so we can experiment with alternatives.

In terms of transmitting snapshot details, I always assumed we would
need a snapshot tool that added extra metadata about parent
relationships on the snapshots.  I didn't want to enforce this in the
metadata on disk, but I have no problems with saying the send/receive
tool requires extra metadata to tell us about parents.

-chris
