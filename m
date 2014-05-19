Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60358 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754568AbaESOB0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 May 2014 10:01:26 -0400
Date: Mon, 19 May 2014 16:01:23 +0200
From: David Sterba <dsterba@suse.cz>
To: Hugo Mills <hugo@carfax.org.uk>, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: [PATCH 00/27] Replace the old man page with asciidoc and man
 page for each btrfs subcommand.
Message-ID: <20140519140123.GG31608@suse.cz>
Reply-To: dsterba@suse.cz
References: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20140416171219.GC29256@twin.jikos.cz>
 <20140517174315.GC2537@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140517174315.GC2537@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, May 17, 2014 at 06:43:15PM +0100, Hugo Mills wrote:
>    I've just been poking around in the docs for a completely different
> reason, and I think there's a fairly serious problem (well, as serious
> as problems get with documentation).
> 
>    Take, for example, the format for btrfs fi resize:
> 
> 'resize' [devid:][+/-]<size>[gkm]|[devid:]max <path>::
> 
>    Now, this has just thrown away all of the useful markup which
> indicates the semantics of the command. The asciidoc renders all of
> that text literally and unformatted, making alphasymbolic(*) soup of
> the docs. Compare this to the old roff man page:
> 
> \fBbtrfs\fP \fBfilesystem resize\fP [\fIdevid\fP:][+/\-]\fI<size>\fP[gkm]|[\fIdevid\fP:]\fImax <path>\fP

I think we can restore the formatting with asciidoc.

The line above would become:

*btrfs* *filesystem resize* ['devid':][+/-]'size'[kgm]|[devid':]'max <path>'

or with bold max

*btrfs* *filesystem resize* ['devid':][+/-]'size'[kgm]|[devid':]*max* '<path>'

I was first worried that this will not be possible due to limitations of
asciidoc markup but as this turned out not be true, I'd rather spend the
boring time to keep the formatting as before.

My personal feeling about the enriched formatting is that the commands
stand out of the text and are easier to catch (as you've mentioned
somewhere in the thread).
