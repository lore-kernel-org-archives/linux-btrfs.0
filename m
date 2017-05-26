Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:40915 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757658AbdEZFSU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 May 2017 01:18:20 -0400
Date: Fri, 26 May 2017 07:18:18 +0200
From: Christoph Hellwig <hch@lst.de>
To: Martin Wilck <mwilck@suse.com>
Cc: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 08/15] dm mpath: merge do_end_io_bio into
        multipath_end_io_bio
Message-ID: <20170526051818.GB17709@lst.de>
References: <20170518131812.22956-1-hch@lst.de> <20170518131812.22956-9-hch@lst.de> <1495479080.28992.23.camel@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1495479080.28992.23.camel@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 22, 2017 at 08:51:20PM +0200, Martin Wilck wrote:
> >  
> > -	if (!error)
> > -		return 0;	/* I/O complete */
> > +	BUG_ON(!mpio);
> 
> You dereferenced mpio already above.

Indeed.  I removed the BUG_ON for the next version.
