Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42239 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756028AbaEPOWi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 May 2014 10:22:38 -0400
Date: Fri, 16 May 2014 16:22:36 +0200
From: David Sterba <dsterba@suse.cz>
To: Hugo Mills <hugo@carfax.org.uk>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs check: Attempt to fix misordered keys with
 bitflips in them
Message-ID: <20140516142236.GW6917@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1399309671-9240-1-git-send-email-hugo@carfax.org.uk>
 <1399309671-9240-4-git-send-email-hugo@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1399309671-9240-4-git-send-email-hugo@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 05, 2014 at 06:07:51PM +0100, Hugo Mills wrote:
> If precisely one of those bitflips puts the broken key back into order
> relative to its two neighbours, we probably have a fix for the bitflip,
> and so we write it back to the FS.

This sounds safe enough to me.  I'll add the patch to integration but
before I push it further upstream I'd really like to see the bitflip fix
in action, so if you already have testing images, please let me know.
