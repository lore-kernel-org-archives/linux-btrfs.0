Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37257 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753911Ab3KELaJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Nov 2013 06:30:09 -0500
Date: Tue, 5 Nov 2013 12:30:04 +0100
From: David Sterba <dsterba@suse.cz>
To: chris.mason@fusionio.com
Cc: Hans-Kristian Bakke <hkbakke@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: csum failure messages
Message-ID: <20131105113004.GE16662@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <201311051224.44255.russell@coker.com.au>
 <CAD_cGvE-FtFxZerOKN7T11-L=cEgh_8i-=YcgwG+g1aye6Zn6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAD_cGvE-FtFxZerOKN7T11-L=cEgh_8i-=YcgwG+g1aye6Zn6w@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 05, 2013 at 07:15:57AM +0100, Hans-Kristian Bakke wrote:
> As you were in the process of a rebalance these errors may actually be
> caused by this serious bug "Btrfs: relocate csums properly with
> prealloc extents".
> 
> I hit that myself with several preallocated files made by rtorrent
> during a rebalance and I lost several huge files as a consequence. The
> only way I could rebalance without large scale corruptions was to
> manually patch the 3.11.6 kernel with the small patch that fixes the
> issue.
> For some reason this patch is not pushed upstream yet. I think that is
> strange as it leads to corruption and actual data loss and it is 100%
> reproducible with preallocated files. Only systemd logs is mentioned
> in the bug reports, but in my case it was actually hitting several
> terabytes of files created by rtorrent.

Thanks for the summary. There's no doubt that this is serious.

Chris, please can you somehow get the patch into stable sooner than it
gets to the 3.13 queue? The merge window will start in 1 week and based
on previous pull request schedule, the patch will be merged in ~2 weeks
from now. That's kind of long time for for a unfixed corruption bug that
reportedly affects common installations (with systemd) or usecases
(torrent) in combination with balance.

david
