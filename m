Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37448 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753173AbdHNNHb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Aug 2017 09:07:31 -0400
Date: Mon, 14 Aug 2017 15:06:08 +0200
From: David Sterba <dsterba@suse.cz>
To: Hallo32 <Hallo32@gmx.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs-progs-v4.12: cross compiling
Message-ID: <20170814130608.GS2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <e8d480c6-758e-0e7d-a024-e9d12d7bf852@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <e8d480c6-758e-0e7d-a024-e9d12d7bf852@gmx.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 14, 2017 at 02:17:26PM +0200, Hallo32 wrote:
> Since versions 4.12 btrfs-progs is complicated to cross compile for 
> other systems.
> The problem is, that this version includes mktables, which needs to be 
> compiled for the host system and executed there for the creation of 
> tables.c.
> 
> Are there any changes planed for the next version of btrfs-progs to make 
> the cross compiling as simple as in the past? A included tables.c for 
> example?

Yes, keeping the generated tables.c around is fine. There's no reason it
needs to be generated each time during build. I'll fix that in 4.12.1.
Thanks for the report, cross-compilation should stay supported.
