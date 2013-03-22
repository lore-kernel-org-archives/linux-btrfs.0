Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46634 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754545Ab3CVLXF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Mar 2013 07:23:05 -0400
Date: Fri, 22 Mar 2013 12:23:03 +0100
From: David Sterba <dsterba@suse.cz>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz,
        Arne Jansen <sensille@gmx.net>
Subject: Re: Integration branch of btrfs-progs 2013-03-20
Message-ID: <20130322112303.GM31559@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20130318173326.GO7229@twin.jikos.cz>
 <20130320174118.GC31559@twin.jikos.cz>
 <201303202108.50024.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201303202108.50024.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 20, 2013 at 09:08:49PM +0100, Martin Steigerwald wrote:
> The fragmentation visuation tool works nicely. Tried it on about 200 GiB
> /home, almost no fragmentation, some 3-4%, but mostly 0.something%,
> and on about 20 GiB root, were some chunks were fragmented upto 30-40%.
> 
> What kind of fragmentation does the tool count? From what I understand
> by looking at the source, extent fragmentation?

It's a high-level view of the 1GB chunk fragmentation, reflecting the
contiguous allocated vs free space.

A partition with frequent rewrites is likely to contain more fragmented
chunks as you observe for your / .

david
