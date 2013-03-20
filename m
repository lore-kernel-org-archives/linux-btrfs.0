Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34246 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054Ab3CTX35 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Mar 2013 19:29:57 -0400
Date: Thu, 21 Mar 2013 00:29:56 +0100
From: David Sterba <dsterba@suse.cz>
To: Roger Pack <rogerpack2005@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Fwd: +1 for xz
Message-ID: <20130320232956.GD31559@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CADCGFBVwqqLc40TWn6cX_2y4bZGKMbW4hRAt6CmLTWfsxknPzg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CADCGFBVwqqLc40TWn6cX_2y4bZGKMbW4hRAt6CmLTWfsxknPzg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 20, 2013 at 01:27:11PM -0600, Roger Pack wrote:
> I see from https://btrfs.wiki.kernel.org/index.php/Compression#How_do_I_enable_compression.3F
> "LZ4" support is currently being added.  Here's my +1 for also adding
> something with "high" compression like xz or lzma, since they
> basically would offer the "high  compression" option (which sometimes
> users may want, like myself on a VPS with limited disk space, or users
> who have a backup disk they want to sync only every so often, not read
> from often, etc.)

Somebody asked on irc about adding it some time ago, I'm half way
through with lzma support. The compression infrastructure needs a few
updates first, the on-disk format of the compressed chunks has to be
extended to hold large contiguous chunks. (Other compressors would
benefit from the changes, so it's not just because of lzma.)

First tests showed that it was really slow for normal use, but for
backup purposes it might be not that bad.


david
