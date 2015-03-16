Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56984 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754445AbbCPRek (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Mar 2015 13:34:40 -0400
Date: Mon, 16 Mar 2015 18:34:39 +0100
From: David Sterba <dsterba@suse.cz>
To: Sebastian Thorarensen <sebth@naju.se>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: btrfs-convert: Allow setting nodesize
Message-ID: <20150316173439.GQ20767@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <2f1ccb99432d65ebd1500f685e53ec98bdc259e7.1425382454.git.sebth@naju.se>
 <alpine.DEB.2.02.1503031249060.3687@miria.naju.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <alpine.DEB.2.02.1503031249060.3687@miria.naju.se>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 03, 2015 at 12:57:36PM +0100, Sebastian Thorarensen wrote:
> This patch passes `make test', and I have also tested the patched
> btrfs-convert on populated ext4 filesystems and reverting back again,
> without errors; but note that I have very little experience with ext2/3/4
> and btrfs, so there is a large possibility that I have missed something.
> I'm also a bit unsure if my implementation of `ext2_alloc_block_range' is
> the best way to find continuous blocks.

I think it's right, however I'm not sure if there are any guarantees
about the range alignment. Btrfs should be fine with 4k (ie. sectorsize
which is PAGE_SIZE) alignment for a node, but this could lead to some
pathological layout and I'm not 100% sure the exact nodesize alignment
is not required somewhere.
