Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56873 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751825AbaJFRIZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 Oct 2014 13:08:25 -0400
Date: Mon, 6 Oct 2014 19:08:23 +0200
From: David Sterba <dsterba@suse.cz>
To: dsterba@suse.cz, Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: make free space cache less noisy
Message-ID: <20141006170823.GC11436@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1412172669-1975-1-git-send-email-jbacik@fb.com>
 <20141006164251.GB11436@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20141006164251.GB11436@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 06, 2014 at 06:42:51PM +0200, David Sterba wrote:
> On Wed, Oct 01, 2014 at 10:11:09AM -0400, Josef Bacik wrote:
> > Fsck only cares if the cache is really broken, so don't be noisy if the
> > generations don't match or other such errors.  Thanks,
> 
> Let's put the messages under a --verbose option if they're just noise.
> I'll send a followup patch.

The printf's are inside free-spache-cache.c so it would need to keep
some global state that is read in cmds-check.c and set from random other
files. This could be cleanly done by prefixing the printf messages the
same way the kernel printk works and then print only the messages below
the user-specified level. Also, using printk in sources that are (not
yet but will be) shared with kernel is IMHO a good practice.

As this is going to be a broader change, I'd like to think about it more
and for now will keep the patch out, I hope we can live with the noisy
messages.
