Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58330 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757434Ab3CYPd7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Mar 2013 11:33:59 -0400
Date: Mon, 25 Mar 2013 16:33:55 +0100
From: David Sterba <dsterba@suse.cz>
To: Alexandre Oliva <oliva@gnu.org>
Cc: Chris Mason <clmason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Subject: Re: corruption of active mmapped files in btrfs snapshots
Message-ID: <20130325153355.GA12745@suse.cz>
Reply-To: dsterba@suse.cz
References: <or1ubaesrx.fsf@livre.home>
 <ord2utb4xx.fsf@livre.home>
 <20130321180614.30044.29961@localhost.localdomain>
 <20130321230621.30044.80640@localhost.localdomain>
 <orzjxw9f75.fsf@livre.home>
 <20130322120754.27874.14389@localhost.localdomain>
 <orobeba58l.fsf@livre.home>
 <20130322142659.27874.81283@localhost.localdomain>
 <20130322170859.GO31559@twin.jikos.cz>
 <or1ub6a1l5.fsf@livre.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <or1ub6a1l5.fsf@livre.home>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 23, 2013 at 06:48:38AM -0300, Alexandre Oliva wrote:
> On Mar 22, 2013, David Sterba <dsterba@suse.cz> wrote:
> 
> > I've reproduced this without compression, with autodefrag on.
> 
> I don't have autodefrag on, unless it's enabled by default on 3.8.3 or
> on the for-linus tree.

It's not on by default, but it seemed that I reproduced the same issue
without compression (and autodefrag was the difference).

david
