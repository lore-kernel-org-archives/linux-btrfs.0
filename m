Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59551 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756557Ab3IBQoB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 Sep 2013 12:44:01 -0400
Date: Mon, 2 Sep 2013 18:43:58 +0200
From: David Sterba <dsterba@suse.cz>
To: Mark Fasheh <mfasheh@suse.de>
Cc: dsterba@suse.cz, Gabriel de Perthuis <g2p.code@gmail.com>,
        Josef Bacik <jbacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PROGS PATCH] Import btrfs-extent-same
Message-ID: <20130902164358.GE23113@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <51CB6D5B.70302@gmail.com>
 <20130806153112.GL5284@twin.jikos.cz>
 <20130813193515.GG31381@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130813193515.GG31381@wotan.suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 13, 2013 at 12:35:15PM -0700, Mark Fasheh wrote:
> > Can you (or Mark) please turn it into a subcommand of dedup? The idea is
> > to merge both in-bound and out-bound dedup into one command, eg.
> > 
> >  btrfs dedup files dir/*
> 
> I can handle this - it's pretty easy but we have to talk about what we're
> expecting here.

> Specifically, the btrfs-extent-same.c software is just a wrapper around the
> ioctl. It never does actual reads of the files or data comparisons, etc. The
> syntax you describe above seems like it wants an actual "scan these files
> and dedupe them" which is a whole other ball game.

Yes that's what I meant and that's what dupremove in your git tree does,
right?

Using the EXTENT_SAME ioctl without any checks is dangerous, and that's
what btrfs-extent-same.c does, so it's suitable for testing but not
about to be given to users as-is.

> So I would suggest maybe something like the syhntax of btrfs-extent-same.c:
> 
> btrfs dedupe files len file1 loff1 file2 loff2 ...

I'm not sure I see what 'len' means here, length of the dedup block?

david
