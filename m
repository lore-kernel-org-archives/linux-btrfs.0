From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: [RFC] btrfs send and receive
Date: Tue, 02 Aug 2011 18:01:52 +0200
Message-ID: <4E381F70.4080102@jan-o-sch.net>
References: <4E369A80.9030307@jan-o-sch.net> <4E36F5B8.5090803@libero.it> <4E37C6CB.1030201@jan-o-sch.net> <1312298057-sup-3959@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	Goffredo Baroncelli <kreijack@libero.it>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1312298057-sup-3959@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On 02.08.2011 17:21, Chris Mason wrote:
> First: awesome!  I can't wait to have this feature.
> 
> I think you have a very sound list of requirements here, but I'll add
> one more.  If there are metadata corruptions on the sender, we must not
> transmit them over to the receiver.  In order for the send/receive
> command to be a backup, it needs to have a first-do-no-harm rule to the
> receiving end.

Full ack. I'm planning to fetch as much information from user space as
possible. Anything that needs kernel support will have consistency
checks added. No guessing will be made. If it doesn't look safe and
sound, that file system will not be sendable.

Furthermore, receiving should not need kernel support at all (except for
an optional interface to create a file with a certain inode, we'll see).
Thus, replicating metadata corruptions should be very unlikely.

One more thing to add: We have to make sure our stream doesn't get
corrupted. So if the file format we're choosing does not include it, we
should keep in mind to add something ourselves.

> In terms of formats, I came to similar conclusions a while ago about
> cpio, tar and dar.  I haven't looked in detail at pax but don't have any
> strong feelings against it.
> 
> But, I'll toss in an alternative.  Adapt the git pack files a little and
> use them as the format.  There are a few reasons for this:
> 
> Git has a very strong developer community and is already being
> hammered into use as a backup application.  You'll find a lot of
> interested people to help out.
> 
> Git separates the contents from the metadata (names).  This makes it
> naturally suited to describing snapshots and other features.  The big
> exception is in large file handling, but you could extend the format to
> describe filename,offset,len->sha instead of just filename->sha.

That sounds interesting. I haven't thought of git until now. It will
lack the appealing feature to unpack without any special tools or a
modified git client, I think. But I believe there are things that would
get easier compared to pax.

I'll try to make a plan how it could be implemented with git, so that we
have something we can compare.

> This doesn't mean I'll reject a pax setup, it's just an alternative to
> think about.  We should have the actual data transmission format pretty
> well abstracted away so we can experiment with alternatives.

Yes, that would be nice. I'll keep that in mind. If both have their
advantages, we might end up having one format in the first
implementation and another one added later once the rest is working.

> In terms of transmitting snapshot details, I always assumed we would
> need a snapshot tool that added extra metadata about parent
> relationships on the snapshots.  I didn't want to enforce this in the
> metadata on disk, but I have no problems with saying the send/receive
> tool requires extra metadata to tell us about parents.

Oh, right. That's something that might not only need kernel support for
"send" to determine a parent, but also a new key representing a
snapshot's parent relationship information.

I'll think that over, currently I tend to adding these relationship keys
around btrfs_ioctl_snap_create soon, so we have at least some file
systems in the wild that are ready for send and receive once it's done.

Thanks,
-Jan
