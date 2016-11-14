Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46297 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932305AbcKNMqe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Nov 2016 07:46:34 -0500
Date: Mon, 14 Nov 2016 13:46:30 +0100
From: David Sterba <dsterba@suse.cz>
To: Chris Mason <clm@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PULL] Btrfs fixes for 4.9-rc5
Message-ID: <20161114124630.GM12522@suse.cz>
Reply-To: dsterba@suse.cz
References: <cover.1478789584.git.dsterba@suse.com>
 <7efb4535-dbd8-1c7c-c6f0-0dda234077e2@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <7efb4535-dbd8-1c7c-c6f0-0dda234077e2@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 11, 2016 at 03:45:10PM -0500, Chris Mason wrote:
> On 11/10/2016 10:00 AM, David Sterba wrote:
> > Hi,
> >
> > two minor error handling fixes and one fix for balance sttus item that goes
> > back to 4.4.
> >
> > The branch continues from my last pull that went to Linus' tree, so it would
> > be a good idea to do the same as before. I've added a signed tag for branch.
> 
> Looking at this again before sending off:
> 
> btrfs: remove redundant check of btrfs_iget return value
> 
> Is really a cleanup and we should wait for the merge window.  Since this 
> means rebasing the pull, I'm happy to send the others on Monday.

Technically it is a cleanup, but I look at it more from the correctness
perspective and based of feelings that "this looks relvant for rc".
But postponing for 4.10 fine for me.
