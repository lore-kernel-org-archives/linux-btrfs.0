Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34313 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753330AbbFWOpE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Jun 2015 10:45:04 -0400
Date: Tue, 23 Jun 2015 16:45:01 +0200
From: David Sterba <dsterba@suse.cz>
To: Sjoerd <sjoerd@sjomar.eu>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs progs release 4.1
Message-ID: <20150623144501.GE6761@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20150622150023.GX6761@twin.jikos.cz>
 <7324923.Sa0lmcTP0G@hoefnix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <7324923.Sa0lmcTP0G@hoefnix>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 23, 2015 at 11:03:47AM +0200, Sjoerd wrote:
> On Monday 22 June 2015 17:00:23 David Sterba wrote:
> > btrfs-progs 4.1 have been released (in time with kernel 4.1). Unusual load
> > of changes.
> 
> Would it be beneficial to update when using older kernels (3.19.x in my case)?
> I can't upgrade to kernel 4.1 since my nvidia (propriety) drivers won't 
> support it (yet) :(

The userspace tools do not depend on kernel and can be safely used with
older kernels, so I'd recommend to update.

https://btrfs.wiki.kernel.org/index.php/FAQ#Do_I_have_to_keep_my_btrfs-progs_at_the_same_version_as_my_kernel.3F
