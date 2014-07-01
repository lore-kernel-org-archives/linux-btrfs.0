Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40456 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755607AbaGARns (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 1 Jul 2014 13:43:48 -0400
Date: Tue, 1 Jul 2014 19:43:46 +0200
From: David Sterba <dsterba@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Cc: dsterba@suse.cz, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: add supported attr flags to btrfs(5)
Message-ID: <20140701174346.GP1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <53AC84C9.2080106@redhat.com>
 <20140627134257.GE1553@twin.jikos.cz>
 <53AD860A.8090804@redhat.com>
 <20140627153017.GF1553@suse.cz>
 <53AD8F96.4060401@redhat.com>
 <20140627161025.GG1553@suse.cz>
 <53AD9DF2.9030200@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53AD9DF2.9030200@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 27, 2014 at 11:38:10AM -0500, Eric Sandeen wrote:
> > From the btrfs side, we have the object properties that make a nice
> > interface for accessing the file attributes in parallel with the chattr
> > tool. The interface is currently underused so it's not possible to
> > manipulate the flags yet.
> 
> or test the code, despite it being merged.  \o/  oh well...

The core support for the properties was merged and one example added.
Implementing all properties was not required nor requested. There are
various types of the properties (simple state bits, bits with runtime
behaviour change or props affecting other state of the whole
filesystem). I want to implement the user-visible interface right from
the beginning, there's my proposal in the list, but I'm currently
working on other stuff so it's stalled. The file attributes is
independent of that.

> > I'd rather move the efforts to finalize this interface than adding
> > single bits of the SETFLAGS ioctl and further extensions of the
> > chattr/lsattr tools.
> 
> ok.  In any case, back to the original patch:  Your changes look fine.
> 'X' can't be set, so leave it out.  Sorry about the 'd' vs 'D' - and I
> like the new formatting.  Feel free to make those changes.

Good, thanks.

> (only nitpick: is 'X' ever reported by lsattr on btrfs?  If so,
> it could/should still be included)

I'll take a look and will keep 'X' if it's visible somewher.

> ((and a side note: I tried to change the text of the manpage to
> be "btrfs" not "btrfs-mount" but that somehow broke the build, and
> I didn't dig a lot further)) 

This is AFAIK requirement of the manpage style used, we can either drop
it or change the internal man page name after it's generated. No big
deal for now.
