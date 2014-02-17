Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46971 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753031AbaBQSlM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Feb 2014 13:41:12 -0500
Date: Mon, 17 Feb 2014 19:41:10 +0100
From: David Sterba <dsterba@suse.cz>
To: kreijack@inwind.it
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, Josef Bacik <jbacik@fb.com>,
        Hugo Mills <hugo@carfax.org.uk>,
        Kostia Khlebopros <kkhlebopros@netgear.com>
Subject: Re: [PATCH][BTRFS-PROGS][v4] Enhance btrfs fi df
Message-ID: <20140217184110.GN16073@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <52FD1A72.5060307@libero.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52FD1A72.5060307@libero.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 13, 2014 at 08:18:10PM +0100, Goffredo Baroncelli wrote:
> This is the 4th attempt of my patches related to show how the data
> are stored in a btrfs filesystem. I rebased all the patches on the v3.13
> btrfs-progs. 

FYI, I've added this series as-is into the -next part of the integration
branch so we have something to test, let the review and comments phase
continue.
