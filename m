Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44041 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755387Ab3FEQYr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 5 Jun 2013 12:24:47 -0400
Date: Wed, 5 Jun 2013 18:24:43 +0200
From: David Sterba <dsterba@suse.cz>
To: Hugo Mills <hugo@carfax.org.uk>, Martin <m_btrfs@ml1.co.uk>,
        linux-btrfs@vger.kernel.org
Subject: Re: btrfs raid1 on 16TB goes read-only after "btrfs: block rsv
 returned -28"
Message-ID: <20130605162443.GE18160@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <konjl0$r06$1@ger.gmane.org>
 <20130605150549.GP20133@carfax.org.uk>
 <konler$h9p$1@ger.gmane.org>
 <20130605154329.GQ20133@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130605154329.GQ20133@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 05, 2013 at 04:43:29PM +0100, Hugo Mills wrote:
>    OK, so you've got plenty of space to allocate. There were some
> issues in this area (block reserves and ENOSPC, and I think
> specifically addressing the issue of ENOSPC when there's space
> available to allocate) that were fixed between 3.8 and 3.9 (and
> probably some between 3.9 and 3.10-rc as well), so upgrading your
> kernel _may_ help here.

This is supposed to be fixed by
https://patchwork-mail2.kernel.org/patch/2558911/

that went ti 3.10-rc with some followup patches, so it might not be
enough as a standalone fix.

Unless you really need 'inode_cache', remove it from the mount options.


david
