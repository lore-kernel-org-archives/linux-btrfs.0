From: Andi Kleen <andi@firstfloor.org>
Subject: Re: New feature Idea
Date: Wed, 13 Aug 2008 22:00:13 +0200
Message-ID: <87y730znw2.fsf@basil.nowhere.org>
References: <48A320A0.80609@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Morey Roof <moreyroof@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <48A320A0.80609@gmail.com> (Morey Roof's message of "Wed, 13 Aug 2008 11:57:53 -0600")
List-ID: <linux-btrfs.vger.kernel.org>

Morey Roof <moreyroof@gmail.com> writes:

> I have been thinking about a new feature to start work on that I am
> interested in and I was hoping people could give me some feedback and
> ideas of how to tackle it.  Anyways, I want to create a data
> deduplication system that can work in two different modes.  One mode
> is that when the system is idle or not beyond a set load point a
> background process would scan the volume for duplicate blocks.  The
> other mode would be used for systems that are nearline or backup
> systems that don't really care about the performance and it would do
> the deduplication during block allocation.

Seems like a special case of compression? Perhaps compression would help
more?

> One of the ways I was thinking of to find the duplicate blocks would
> be to use the checksums as a quick compare.  If the checksums match
> then do a complete compare before adjusting the nodes on the files.
> However, I believe that I will need to create a tree based on the
> checksum values.

If you really want to do deduplication: It might be advantageous to do 
this on larger units.

If you assume that data is usually shared between similar files (which
is a reasonable assumption) and do the deduplication on whole files
you can also use the size as an index and avoid checksumming all files
with a unique size.  I wrote a user level duplicated file checker some
time ago that used this trick successfully.

-Andi
