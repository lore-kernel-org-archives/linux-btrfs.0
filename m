From: Chris Mason <chris.mason@oracle.com>
Subject: Re: New feature Idea
Date: Thu, 14 Aug 2008 13:12:17 -0400
Message-ID: <1218733937.15342.378.camel@think.oraclecorp.com>
References: <48A320A0.80609@gmail.com>  <48A32DDE.8070203@hp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Morey Roof <moreyroof@gmail.com>, linux-btrfs@vger.kernel.org
To: jim owens <jowens@hp.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <48A32DDE.8070203@hp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2008-08-13 at 14:54 -0400, jim owens wrote:
> Morey Roof wrote:
> > I have been thinking about a new feature to start work on that I am 
> > interested in and I was hoping people could give me some feedback and 
> > ideas of how to tackle it.  Anyways, I want to create a data 
> > deduplication system that can work in two different modes.  One mode is 
> > that when the system is idle or not beyond a set load point a background 
> > process would scan the volume for duplicate blocks.  The other mode 
> > would be used for systems that are nearline or backup systems that don't 
> > really care about the performance and it would do the deduplication 
> > during block allocation.
> > 
> > One of the ways I was thinking of to find the duplicate blocks would be 
> > to use the checksums as a quick compare.  If the checksums match then do 
> > a complete compare before adjusting the nodes on the files.  However, I 
> > believe that I will need to create a tree based on the checksum values.
> > 
> > So any other ideas and thoughts about this?
> 
> Don't do it!!!
> 
> OK, I know Chris has described some block sharing.  But I hate it.
> 
> If I copy "resume" to "resume.save", it is because I want 2 copies
> for safety.  I don't want the fs to reduce it to 1 copy.  And
> reducing the duplicates is exactly opposite to Chris's paranoid
> make-multiple-copies-by-default.
> 
> Now feel free to tell me I'm an idiot (other people do) :)

Grin, the C in cow does stand for something after all.  It is pretty
darn hard to overwrite existing bytes in a file in btrfs without mount
-o nodatacow.

There isn't any difference between dedup and a snapshot from a data
protection point of view.

With that in said, maintaining all the machinery for dedup is definitely
non-trivial, and I haven't yet convinced myself it wouldn't be better
done at higher layers.  We already have the cow-single-file ioctl, why
not have a userland process go around and create cow links between
identical files.

File granularity is not well suited to dedup when files differ by only a
few blocks, but I'd want to see some numbers on how often that happens
before carrying around the disk format needed to do block level dedup.

-chris


