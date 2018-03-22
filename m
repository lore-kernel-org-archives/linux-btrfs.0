Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54076 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751714AbeCVQCM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Mar 2018 12:02:12 -0400
Date: Thu, 22 Mar 2018 16:59:46 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Omar Sandoval <osandov@osandov.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH] Btrfs: delete dead code in btrfs_orphan_add()
Message-ID: <20180322155946.GG6955@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <ddecfd9f65019017bba48685a86554cf21350ade.1516924547.git.osandov@fb.com>
 <e8357487-934e-846d-9063-6185759dd745@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <e8357487-934e-846d-9063-6185759dd745@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 26, 2018 at 12:54:38PM +0200, Nikolay Borisov wrote:
> 
> 
> On 26.01.2018 01:56, Omar Sandoval wrote:
> > From: Omar Sandoval <osandov@fb.com>
> > 
> > btrfs_orphan_add() has had this case commented out since it was first
> > introduced in commit d68fc57b7e32 ("Btrfs: Metadata reservation for
> > orphan inodes"). Most of the orphan cleanup code has been rewritten
> > since then, so it's safe to say that this code isn't needed.
> 
> I've tried removing this a couple of times but David objected due to
> missing historical context and whether we might need it. I'm totally
> fine with killing it.
> 
> Reviewed-by: Nikolay Borisov <nborisov@suse.com>

So be it. Added to next.
