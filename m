Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51526 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751566AbdLLSyj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Dec 2017 13:54:39 -0500
Date: Tue, 12 Dec 2017 19:52:38 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Remove pair of bio_get/put in btrfs_schedule_bio
Message-ID: <20171212185238.GR3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1513003128-15489-1-git-send-email-nborisov@suse.com>
 <20171211225756.GA6827@lim.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171211225756.GA6827@lim.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 11, 2017 at 02:57:56PM -0800, Liu Bo wrote:
> On Mon, Dec 11, 2017 at 04:38:48PM +0200, Nikolay Borisov wrote:
> > This code was added in 492bb6deee34 ("Btrfs: Hold a reference on bios
> > during submit_bio, add some extra bio checks"). However, holding a
> > reference on a bio is necessary only if it's going to be referenced
> > after the submit_bio returns and the bio is completed. In this
> > particular instance this is not the case so there is no need to hold
> > an extra reference since we directly return.
> >
> 
> Looks good.  If possible, please also drop other unnecessary bio_get()
> in btrfs.

You mean everywhere with similar context like in this patch?

> Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Added to next, thanks.
