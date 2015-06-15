Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52614 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754218AbbFON3Q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Jun 2015 09:29:16 -0400
Date: Mon, 15 Jun 2015 15:29:15 +0200
From: David Sterba <dsterba@suse.cz>
To: Tovo Rabemanantsoa <tovo.rabemanantsoa@bordeaux.inra.fr>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Bad performance with near-full FS
Message-ID: <20150615132915.GM6761@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <557EC95C.8020902@bordeaux.inra.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <557EC95C.8020902@bordeaux.inra.fr>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 15, 2015 at 02:47:24PM +0200, Tovo Rabemanantsoa wrote:
> Hi all,
> By browsing this list's archive, I've found a thread initiated by
> Charles Cazabon entitled: "Oddly slow read performance with near-full
> largish FS."
> Actually, I'm living the same experience but with a not so large FS
> (256GB on a SSD). Indeed, when I have less than 1GB of free space, the
> applications (thunderbird, thunar ...) on the machine become awfully
> slow but remain normal if I make some cleaning.
> Is it due to the FS or because it's an SSD hard disk ?

1G of 256G is less than a percent. At this level of usage you can expect
slowdown on any filesystem.

This could be caused by free space fragmentation and even on a SSD, this
needs extra time to process.  Higher number of fragments needs more
structures to represent them and cost more CPU time, though this still
might not be the worst impact.

AFAIK btrfs space handling logic needs to do more flushes of unwritten
data when the accounted free space goes below some threshold (because
COW needs to write the data twice before it switches to the new "root"
pointer and can free the previous version).
