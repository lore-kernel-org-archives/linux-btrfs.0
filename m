Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:32909 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753265AbaESOdp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 May 2014 10:33:45 -0400
Date: Mon, 19 May 2014 16:33:43 +0200
From: David Sterba <dsterba@suse.cz>
To: Hugo Mills <hugo@carfax.org.uk>, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: [PATCH 00/27] Replace the old man page with asciidoc and man
 page for each btrfs subcommand.
Message-ID: <20140519143342.GH31608@suse.cz>
Reply-To: dsterba@suse.cz
References: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20140416171219.GC29256@twin.jikos.cz>
 <20140517174315.GC2537@carfax.org.uk>
 <20140519140123.GG31608@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140519140123.GG31608@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 19, 2014 at 04:01:23PM +0200, David Sterba wrote:
> On Sat, May 17, 2014 at 06:43:15PM +0100, Hugo Mills wrote:
> >    I've just been poking around in the docs for a completely different
> > reason, and I think there's a fairly serious problem (well, as serious
> > as problems get with documentation).
> > 
> >    Take, for example, the format for btrfs fi resize:
> > 
> > 'resize' [devid:][+/-]<size>[gkm]|[devid:]max <path>::
> > 
> >    Now, this has just thrown away all of the useful markup which
> > indicates the semantics of the command. The asciidoc renders all of
> > that text literally and unformatted, making alphasymbolic(*) soup of
> > the docs. Compare this to the old roff man page:
> > 
> > \fBbtrfs\fP \fBfilesystem resize\fP [\fIdevid\fP:][+/\-]\fI<size>\fP[gkm]|[\fIdevid\fP:]\fImax <path>\fP
> 
> I think we can restore the formatting with asciidoc.
> 
> The line above would become:
> 
> *btrfs* *filesystem resize* ['devid':][+/-]'size'[kgm]|[devid':]'max <path>'
> 
> or with bold max
> 
> *btrfs* *filesystem resize* ['devid':][+/-]'size'[kgm]|[devid':]*max* '<path>'

The correct base string should read

  btrfs filesystem resize [<devid>:][+/-]<size>[kgm]|[<devid>:]max <path>

ie. add <..> around devid and size. That way it's copy-paste-ready.
In this case the italic/underlined text does not IMO add much value.

> My personal feeling about the enriched formatting is that the commands
> stand out of the text and are easier to catch (as you've mentioned
> somewhere in the thread).

The bolded subcommand name seems to be sufficent.

The files are processed by XSL, I think it should be possible to apply
some transformation that would add '...' around <...> automatically
instead of making everybody write that.

Proposed changes:
- format all subcommands as bold instead of italic ('' -> **)
- add all missing <...>
- find a way how to add '...' around <...> (xsl or sed or whatever)

Does that work for you?
