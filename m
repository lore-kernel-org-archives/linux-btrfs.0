From: Ilya Dryomov <idryomov@gmail.com>
Subject: Re: [patch 07/66] btrfs: clear_extent_bit error push-up
Date: Mon, 31 Oct 2011 14:30:42 +0200
Message-ID: <20111031123041.GA26393@zambezi.lan>
References: <20111025010236.322699279@suse.com>
 <20111025010851.368992601@suse.com>
 <20111026151024.GB5914@twin.jikos.cz>
 <4EA824D2.6070801@suse.com>
 <20111026160919.GC5914@twin.jikos.cz>
 <4EA831BA.4060103@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeff Mahoney <jeffm@suse.com>,
	Chris Mason <chris.mason@oracle.com>,
	David Sterba <dsterba@suse.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Jeff Mahoney <jeffm@suse.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EA831BA.4060103@suse.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 26, 2011 at 12:13:46PM -0400, Jeff Mahoney wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 10/26/2011 12:09 PM, David Sterba wrote:
> > On Wed, Oct 26, 2011 at 11:18:42AM -0400, Jeff Mahoney wrote:
> >>>> extent_io_tree *tree, u64 start, u64 end, -		       gfp_t
> >>>> mask); +		       gfp_t mask) __must_check;
> >>> ^^^^^^^^^^^^ shouldn't this be placed at the beginning of the 
> >>> prototype?
> >> 
> >> I don't see why that would need to be the case. It needs to be at
> >> the beginning of the prototype if it's the actual function
> >> definition but not when it's a prototype.
> > 
> > I'm not aware of a general recommendation, but the __must_check is 
> > related to return value and makes sense to place it there. There is
> > no other instance of __must_check placed at the end of 
> > declaratin/definition so I'm applying the "be consistent with 
> > surrounding code" rule.
> 
> Putting it at the beginning means indenting the entire prototype,
> which I'm not a fan of.
> 
> - -Jeff

I think it would be much better to put it at the beginning.  For one
it's conventional and the rest of the kernel puts it at the beginning.
The other, and much more important, thing is that it greatly confuses C
indexing tools like cscope.  Now you could argue that those tools' regexes
should be tweaked but since it's just a matter of taste why don't put it
at the beginning ?

Thanks,

		Ilya
