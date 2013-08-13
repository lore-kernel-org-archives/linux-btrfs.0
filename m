Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36662 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758722Ab3HMTfQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Aug 2013 15:35:16 -0400
Date: Tue, 13 Aug 2013 12:35:15 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: dsterba@suse.cz, Gabriel de Perthuis <g2p.code@gmail.com>,
        Josef Bacik <jbacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PROGS PATCH] Import btrfs-extent-same
Message-ID: <20130813193515.GG31381@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <51CB6D5B.70302@gmail.com> <20130806153112.GL5284@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130806153112.GL5284@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey Dave,

On Tue, Aug 06, 2013 at 05:31:12PM +0200, David Sterba wrote:
> On Thu, Jun 27, 2013 at 12:38:19AM +0200, Gabriel de Perthuis wrote:
> > Originally from
> > https://github.com/markfasheh/duperemove/blob/master/btrfs-extent-same.c
> 
> Can you (or Mark) please turn it into a subcommand of dedup? The idea is
> to merge both in-bound and out-bound dedup into one command, eg.
> 
>  btrfs dedup files dir/*

I can handle this - it's pretty easy but we have to talk about what we're
expecting here.

Specifically, the btrfs-extent-same.c software is just a wrapper around the
ioctl. It never does actual reads of the files or data comparisons, etc. The
syntax you describe above seems like it wants an actual "scan these files
and dedupe them" which is a whole other ball game.

So I would suggest maybe something like the syhntax of btrfs-extent-same.c:

btrfs dedupe files len file1 loff1 file2 loff2 ...

Sound reasonable?
	--Mark

--
Mark Fasheh
