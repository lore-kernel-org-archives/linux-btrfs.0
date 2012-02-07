From: Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: subvolume info in /proc/mounts
Date: Tue, 7 Feb 2012 20:05:54 +0100
Message-ID: <201202072005.54760.kreijack@inwind.it>
References: <13975aa6fbfab9c845a2582c043aa938.squirrel@webmail01.edunet.gr> <20120206115321.GB15350@twin.jikos.cz> <20120206121823.GA24922@infradead.org>
Reply-To: kreijack@inwind.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: Nikos Voutsinas <nvoutsin@noc.edunet.gr>, dave@jikos.cz,
	linux-btrfs@vger.kernel.org, kreijack@gmail.com,
	chris.mason@oracle.com, Al Viro <viro@linux.org.uk>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120206121823.GA24922@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Christoph

On Monday, 06 February, 2012 13:18:24 Christoph Hellwig wrote:
> On Mon, Feb 06, 2012 at 12:53:21PM +0100, David Sterba wrote:
> > On Sun, Feb 05, 2012 at 12:30:42PM +0200, Nikos Voutsinas wrote:
> > > It's quite old, but what was this about;
> > > 
> > > http://thread.gmane.org/gmane.comp.file-systems.btrfs/4487
> > 
> > Thanks, the patch looks ok and works as expected.
> > 
> > Goffredo, do you want to resend it? (The lock around the mnt_root is not
> > necessary.) I think it's a -rc material, more people came to ask about
> > this on irc channel lately, we don't need to wait a full release cycle
> > to merge this fix.
> 
> No, it doesn't look good.  Please do not introduce anything touching
> non-superblock fields in ->show_options, thanks.

could you elaborate your sentence ? What is the problem ? The subvolume name 
could be a very precious information.



> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
