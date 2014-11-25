Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48251 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935AbaKYRlz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Nov 2014 12:41:55 -0500
Date: Tue, 25 Nov 2014 18:41:54 +0100
From: David Sterba <dsterba@suse.cz>
To: kreijack@inwind.it
Cc: Martin Steigerwald <Martin@lichtvoll.de>, linux-btrfs@vger.kernel.org,
        David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 0/4] New 'btrfs chunk list' command
Message-ID: <20141125174154.GM26471@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1416931045-24259-1-git-send-email-kreijack@inwind.it>
 <1995604.saxct2VtQ4@merkaba>
 <5474B805.1090806@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5474B805.1090806@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 25, 2014 at 06:10:29PM +0100, Goffredo Baroncelli wrote:
> > Can the chunk list also display the usage inside the chunks?
> Unfortunately not. I don't know how it would be possible to get this info.

It takes some more parsing of the fs structures, doable via the
SEARCH_TREE ioctl. I have an unpolished patch to show the logical chunks
(though without actual chunk usage), similar can be done for per-device
chunks. The patch was a debugging helper so it hasn't been submitted yet
until it's more user friendly. I'll keep the per-device request in mind.
