Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45692 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754348AbaKOAJC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Nov 2014 19:09:02 -0500
Date: Sat, 15 Nov 2014 01:09:00 +0100
From: David Sterba <dsterba@suse.cz>
To: Silvio Fricke <silvio.fricke@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/2] add progress indicator to btrfs-convert
Message-ID: <20141115000900.GE8614@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1415549388.git.silvio.fricke@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cover.1415549388.git.silvio.fricke@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Nov 09, 2014 at 11:16:54PM +0100, Silvio Fricke wrote:
> I have tried a ext4->btrfs conversation of a 1TB (90%full) and have seen that
> btrfs has no progressbar or something like that. Furthermore I have found [1] a
> project idea for this.
> 
> I have tried a generic tasklet-based solution to print the status of the
> convert-process. Maybe it looks good to you than please add this to your repo.

Added to integration for now to give it some more testing. There are
potential users for the 'progress' feature (scrub, balance, replace) so
we may build it on top of your patches though I haven't looked closer.
