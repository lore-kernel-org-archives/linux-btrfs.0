Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:36524 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923Ab2IBFZn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 2 Sep 2012 01:25:43 -0400
Date: Sun, 2 Sep 2012 07:25:37 +0200
From: David Sterba <dave@jikos.cz>
To: Ben Wreder <benwreder@hotmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Tail packing
Message-ID: <20120902052537.GF17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <DUB117-W3224DDE372041F789CA47FB5A60@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <DUB117-W3224DDE372041F789CA47FB5A60@phx.gbl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 31, 2012 at 04:40:36PM +0200, Ben Wreder wrote:
> The disk format description implies that btrfs should be able to
> support tail packing. I just did some experimentation, and while small
> files are packed, it seems that files occupying more than one block
> are not. For example, a lot of 32769-byte files will end up taking
> over 36KB on average (a small excess due to the metadata itself).
> 
> So just to confirm - btrfs does not currently support tail-packing, is that correct?

Currently it's not the reiserfs-style tail packing. The feature is
advertised as "Space-efficient packing of small files", as Josef
replied, if a file fits into a leaf block, it's stored into the metadata
blocks. The limit is 3916 bytes for 4k blocks, without compression. If
compression is on, the 'small file' size limit is even higher for
moderately compressible files. An example where this could apply is a
maildir, and IIRC this was why reiserfs was chosen on mail servers.

> If so, is it a planned feature?

Not that I'm aware of, everybody seems to be fine with the current
state. I think it is possible to implement the tail-packing in a
non-intrusive way, but I'm not sure if the data-space savings would balance
the additional metadata consumption plus the overhead for b-tree
access/COW/locking when using the inline data.


david
