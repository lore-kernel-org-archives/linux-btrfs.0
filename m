Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50689 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576Ab3APNMD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Jan 2013 08:12:03 -0500
Date: Wed, 16 Jan 2013 14:12:00 +0100
From: David Sterba <dsterba@suse.cz>
To: Hugo Mills <hugo@carfax.org.uk>, Chris Murphy <lists@colorremedies.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: partition question
Message-ID: <20130116131200.GT20089@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <50F06639.6030409@home.nl>
 <818D716E-CEFF-4170-B470-574D6E98375E@colorremedies.com>
 <20130111223845.GV19051@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130111223845.GV19051@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 11, 2013 at 10:38:45PM +0000, Hugo Mills wrote:
> On Fri, Jan 11, 2013 at 03:34:25PM -0700, Chris Murphy wrote:
> > Swap still needs to be on a separate partition, as I don't think
> > Btrfs is supporting swapfiles yet still, but maybe someone else can
> > comment on the status of that.
> 
>    I don't know this area of the code at all well, but as I understand
> it, there's been some work in the kernel (swap over NFS) which lays
> down some of the underlying infrastructure we'd need to support
> swapfiles on btrfs, but we don't have anything beyond that. I don't
> know of anyone working on it, either.

Nobody up to my knowledge.

david
