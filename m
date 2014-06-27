Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33524 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751755AbaF0QK1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Jun 2014 12:10:27 -0400
Date: Fri, 27 Jun 2014 18:10:26 +0200
From: David Sterba <dsterba@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: add supported attr flags to btrfs(5)
Message-ID: <20140627161025.GG1553@suse.cz>
Reply-To: dsterba@suse.cz
References: <53AC84C9.2080106@redhat.com>
 <20140627134257.GE1553@twin.jikos.cz>
 <53AD860A.8090804@redhat.com>
 <20140627153017.GF1553@suse.cz>
 <53AD8F96.4060401@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53AD8F96.4060401@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 27, 2014 at 10:36:54AM -0500, Eric Sandeen wrote:
> >> #define FS_NOCOMP_FL                    0x00000400 /* Don't compress */
> > 
> > Passing this bit directly via ioctl works as expected, but to my
> > knowledge there is no chattr letter allocated for it.
> 
> it's in the manpage, but as a read-only attribute, i.e. lsattr only.

Oh right, sorry.

> >> and btrfs_ioctl_setflags claims to handle it:
> >>
> >>         if (flags & FS_NOCOMP_FL) {
> >>                 ip->flags &= ~BTRFS_INODE_COMPRESS;
> >>                 ip->flags |= BTRFS_INODE_NOCOMPRESS;
> >> 		...
> >>
> >> so hopefully you can understand my confusion? ;)
> > 
> > Oh I do now, but it's ext2 fault :)
> 
> Ok but btrfs setflags tries to handle "FS_NOCOMP_FL" - how is that ever set?

It handles the bit, but there's no friendly userspace tool for that,
just the ioctl.

> > AFAICS 'X' is not listed among the standard chattr options and chattr.c
> > in e2fsprogs has no support for that.
> > 
> > There is
> > 
> > lib/e2p/pf.c:   { EXT2_NOCOMPR_FL, "X", "Compression_Raw_Access" },
> > 
> > but this is used only locally by print_flags.
> 
> Right, it's a "read-only" flag for lsattr.

Got it.

> > I hope this answers your questions, 'X' has no meaning for btrfs now.
> 
> The only remaining question is, why does the btrfs setflags interface
> try to parse it, if nothing sends it?

It's allowed operation to manipulate the bit, I don't have anything
better to say.

> Or if something does send it, what?

Lack of tool support, only via ioctl.

> And where is this all documented? ;)

Eww, sources? :)

> btrfs tries to handle a flag value which is identical to the
> 'X' flag value, which lsattr/chattr says is readonly...

I'm looking at it from the kernel side, ie what's its meaning of the
flag. The chattr tool still lives under the hood of e2fsprogs, but
the ioctl interface is inherited to other filesystems (stating the
obvious). e2fsprogs/chattr can decide to implement other meaning or new
bits more or less freely (eg. there's the new 'N' flag for inlined files
that I discovered just today while exploring the 'X' flag).

There was a discussion at fsdevel about extending the interface or
reworking it completely, I don't know if there's an outcome.

>From the btrfs side, we have the object properties that make a nice
interface for accessing the file attributes in parallel with the chattr
tool. The interface is currently underused so it's not possible to
manipulate the flags yet.

I'd rather move the efforts to finalize this interface than adding
single bits of the SETFLAGS ioctl and further extensions of the
chattr/lsattr tools.
