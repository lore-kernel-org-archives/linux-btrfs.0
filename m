Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44393 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751709AbaI2Vt5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Sep 2014 17:49:57 -0400
Date: Mon, 29 Sep 2014 23:49:54 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: fix sparse address space warnings
Message-ID: <20140929214954.GG11436@suse.cz>
Reply-To: dsterba@suse.cz
References: <1411894092-28784-1-git-send-email-osandov@osandov.com>
 <1411894092-28784-2-git-send-email-osandov@osandov.com>
 <20140929160738.GC11436@twin.jikos.cz>
 <20140929194512.GA7038@mew.dhcp4.washington.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140929194512.GA7038@mew.dhcp4.washington.edu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 29, 2014 at 12:45:12PM -0700, Omar Sandoval wrote:
> > > @@ -639,8 +640,7 @@ static int send_header(struct send_ctx *sctx)
> > > -	return write_buf(sctx->send_filp, &hdr, sizeof(hdr),
> > > -					&sctx->send_off);
> > > +	return write_buf(sctx->send_filp, &hdr, sizeof(hdr), &sctx->send_off);
> > 
> > >  	ret = write_buf(sctx->send_filp, sctx->send_buf, sctx->send_size,
> > > -					&sctx->send_off);
> > > +			&sctx->send_off);
> > 
> > Please do not fold unrelated changes.
> 
> My metric for "related" here was that these were call sites of a function I
> directly modified.

The changes are only in the whitespace, that's not necessary. It's
usually ok to fix style issues in the code you modify directly.

> Is the preferred form to just split style fixes that we encounter into
> a separate patch in the series?

Well, I may only express my point of view. Yes, split the style-only
changes into another patch and don't send it :)

The problem with patches that do not effectively change anything is that
they pollute git history and just add extra step when one has to look
for a patch that broke something, or eg. change context of following
patches and make backporting a bit more tedious. Code cleanups are fine,
but there's usually a point of making the code more readable, compact,
etc.

The coding style should be perfect from the beginning. Nobody will
probably point out minor style violations during review, because it just
pointless for a patch that fixes a real bug.
