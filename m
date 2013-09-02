Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59134 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756122Ab3IBQdh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 Sep 2013 12:33:37 -0400
Date: Mon, 2 Sep 2013 18:33:34 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs-progs: add dedup subcommand
Message-ID: <20130902163334.GD23113@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1375950946-5470-1-git-send-email-bo.li.liu@oracle.com>
 <1375950946-5470-7-git-send-email-bo.li.liu@oracle.com>
 <20130809125134.GJ5284@twin.jikos.cz>
 <20130812024554.GA19701@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130812024554.GA19701@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 12, 2013 at 10:45:55AM +0800, Liu Bo wrote:
> On Fri, Aug 09, 2013 at 02:51:35PM +0200, David Sterba wrote:
> > I'm not sure that calling it register/unregister is the right thing, IMO
> > it's more enable/disable as you write in the documentation under each
> > respective command.
> > 
> 
> Both of them are easy to be understood, but let's keep it consistent
> with the docs as you suggest :)

I'm now adding the dedup patch into integration so more people can play
with it (though the kernel part is not in btrfs-next yet). I've
committed a separate patch to do the rename, but feel free to fold it
into further revisions of your progs dedup patch, I'll drop mine then.

david
