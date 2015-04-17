Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60834 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933782AbbDQR3a (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Apr 2015 13:29:30 -0400
Date: Fri, 17 Apr 2015 19:29:28 +0200
From: David Sterba <dsterba@suse.cz>
To: Hugo Mills <hugo@carfax.org.uk>, sri <toyours_sridhar@yahoo.co.in>,
        linux-btrfs@vger.kernel.org
Subject: Re: how many chunk trees and extent trees present
Message-ID: <20150417172928.GT25622@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <loom.20150417T081705-332@post.gmane.org>
 <20150417091911.GK22084@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150417091911.GK22084@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 17, 2015 at 09:19:11AM +0000, Hugo Mills wrote:
> > In, some article i read that future there will be more chunk tree/ extent 
> > tree for single btrfs. Is this true.
> 
>    I recall, many moons ago, Chris saying that there probably wouldn't
> be.

More extent trees tied to a set of fs trees/subvolumes would be very
useful for certain usecases *cough*encryption*cough*.
