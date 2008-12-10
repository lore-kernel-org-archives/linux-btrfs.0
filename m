From: Oliver Mattos <oliver.mattos08@imperial.ac.uk>
Subject: Re: Data De-duplication
Date: Wed, 10 Dec 2008 21:10:37 +0000
Message-ID: <1228943437.7571.1.camel@mattos-laptop>
References: <1228862899.8130.1.camel@mattos-laptop>
	 <1228915802.11900.8.camel@think.oraclecorp.com>
	 <32809.2001:470:e828:1::2:2.1228939660.squirrel@avalon.arbitraryconstant.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Chris Mason <chris.mason@oracle.com>, <linux-btrfs@vger.kernel.org>
To: <btrfs-devel@arbitraryconstant.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <32809.2001:470:e828:1::2:2.1228939660.squirrel@avalon.arbitraryconstant.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2008-12-10 at 13:07 -0700, Anthony Roberts wrote:
> > When the a direct read
> > comparison is required before sharing blocks, it is probably best done
> > by a stand alone utility, since we don't want wait for a read of a full
> > extent every time we want to write on.
> 
> Can a stand-alone utility do this without a race? Eg, if a portion of one
> of the files has already been read by the util, but is changed before the
> util has a chance to actually do the ioctl to duplicate the range.
> 
> If we assume someone is keeping a hash table of "likely" matches, might it
> make sense to have a verify-and-dup ioctl that does this safely?
> 

This sounds good because then a standard user could safely do this to
any file as long as he had read access to both files, but wouldn't need
write access (since the operation doesn't actually modify the file
data).

