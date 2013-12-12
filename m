Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51510 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617Ab3LLSHb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Dec 2013 13:07:31 -0500
Date: Thu, 12 Dec 2013 19:07:30 +0100
From: David Sterba <dsterba@suse.cz>
To: Chris Mason <clm@fb.com>
Cc: dsterba@suse.cz, Wang Shilong <wangsl.fnst@cn.fujitsu.com>,
        Roman Mamedov <rm@romanrm.net>, linux-btrfs@vger.kernel.org,
        Alex Lyakas <alex.btrfs@zadarastorage.com>
Subject: Re: [PATCH] btrfs-progs: add options to sync filesystem after subvol
 delete
Message-ID: <20131212180730.GS6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1385657947-26145-1-git-send-email-dsterba@suse.cz>
 <20131129013638.01ede78a@natsu>
 <5297F633.8090100@cn.fujitsu.com>
 <20131129173744.GP25312@suse.cz>
 <529C4CB9.8020403@cn.fujitsu.com>
 <20131209233245.GF10658@twin.jikos.cz>
 <20131210131707.16869.32138@ret>
 <20131210173628.GH10658@suse.cz>
 <20131210182412.23415.32744@ret>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20131210182412.23415.32744@ret>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 10, 2013 at 01:24:13PM -0500, Chris Mason wrote:
> > It is there, 'btrfs subvol list -d /path', but I'd rather not let
> > everybody parse output the output for a simple check.
> 
> Aha ;) Yeah, that's what I was thinking.  It's possible to find but hard
> enough that nobody would be happy using it.

Sorry I dont' udnerstand, you mean that the -d option is hard to find?

> > Yeah it's natural and I guess it'll be the most frequent type of use.
> > I've tried to think of the possible uses so we don't miss anything
> > during design phase.
> > 
> > Knowing the ID is necessary, the subvolume path is lost at deletion
> > time, but let's say that the ID is available somehow, eg from
> > application logs.
> > 
> > I have a prototype for that, there's a separate subcommand to do just
> > the waiting for a given subvolume list id to be cleaned up (but could
> > be merged to fi sync if desired). It's built around the SEARCH ioctl and
> > does not need kernel support.
> 
> So the part where I think we agree is I don't think the kernel subvol
> deletion ioctl should do the waiting.

Yes, I've abandoned the kernel approach, for several reasons.

> Exactly how the progs wait is a different question.

BTRFS_IOC_START_SYNC + BTRFS_IOC_WAIT_SYNC

I'll send out v2.
