Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:47124 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754567AbaI2TpP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Sep 2014 15:45:15 -0400
Received: by mail-pa0-f52.google.com with SMTP id fb1so6482907pad.39
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Sep 2014 12:45:15 -0700 (PDT)
Date: Mon, 29 Sep 2014 12:45:12 -0700
From: Omar Sandoval <osandov@osandov.com>
To: David Sterba <dsterba@suse.cz>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: fix sparse address space warnings
Message-ID: <20140929194512.GA7038@mew.dhcp4.washington.edu>
References: <1411894092-28784-1-git-send-email-osandov@osandov.com>
 <1411894092-28784-2-git-send-email-osandov@osandov.com>
 <20140929160738.GC11436@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140929160738.GC11436@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 29, 2014 at 06:07:38PM +0200, David Sterba wrote:
> On Sun, Sep 28, 2014 at 01:48:11AM -0700, Omar Sandoval wrote:
> > The buffer passed to vfs_write in send and several casts of ioctl fields are
> > missing the __user annotation. Also fixes a couple of related trivial style
> > issues.
> > 
> > Signed-off-by: Omar Sandoval <osandov@osandov.com>
> 
> Reviewed-by: David Sterba <dsterba@suse.cz>

Thank you.

> > @@ -639,8 +640,7 @@ static int send_header(struct send_ctx *sctx)
> > -	return write_buf(sctx->send_filp, &hdr, sizeof(hdr),
> > -					&sctx->send_off);
> > +	return write_buf(sctx->send_filp, &hdr, sizeof(hdr), &sctx->send_off);
> 
> >  	ret = write_buf(sctx->send_filp, sctx->send_buf, sctx->send_size,
> > -					&sctx->send_off);
> > +			&sctx->send_off);
> 
> Please do not fold unrelated changes.

My metric for "related" here was that these were call sites of a function I
directly modified. Is the preferred form to just split style fixes that we
encounter into a separate patch in the series?

-- 
Omar
