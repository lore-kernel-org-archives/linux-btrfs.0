Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44863 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789AbaJPLwj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Oct 2014 07:52:39 -0400
Date: Thu, 16 Oct 2014 13:52:37 +0200
From: David Sterba <dsterba@suse.cz>
To: Calvin Walton <calvin.walton@kepstin.ca>
Cc: Bob Williams <linux@barrowhillfarm.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: Scrub already running
Message-ID: <20141016115237.GE22943@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <543D3EAA.4000706@barrowhillfarm.org.uk>
 <1413303927.1289.6.camel@kepstin.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1413303927.1289.6.camel@kepstin.ca>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 14, 2014 at 12:25:27PM -0400, Calvin Walton wrote:
> I'm not sure if this has been improved in newer versions of the btrfs-
> progs.

Will be fixed in 3.17, patch
https://patchwork.kernel.org/patch/5019841/
