Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46526 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827AbbFHX62 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 8 Jun 2015 19:58:28 -0400
Date: Mon, 8 Jun 2015 16:58:26 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Cc: linux-btrfs@vger.kernel.org, Matt Robinson <git@nerdoftheherd.com>
Subject: Re: [PATCH] btrfs: Handle unaligned length in extent_same
Message-ID: <20150608235826.GM18148@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <20150608220525.GL18148@wotan.suse.de>
 <pan.2015.06.08.23.36.25@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <pan.2015.06.08.23.36.25@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 08, 2015 at 11:36:25PM +0000, Holger Hoffstätte wrote:
> On Mon, 08 Jun 2015 15:05:25 -0700, Mark Fasheh wrote:
> 
> > The extent-same code rejects requests with an unaligned length. This
> > poses a problem when we want to dedupe the tail extent of files as we
> > skip cloning the portion between i_size and the extent boundary.
> 
> This sounds familiar:
> http://thread.gmane.org/gmane.comp.file-systems.btrfs/42512
> 
> Same problem?

Yes! I CC'd Matt, I think either of the patches needs a review for
inclusion. I can help by reviewing his (at least a reviewed-by tag would
probably help).

Incidentally, I have a duperemove branch to take advantage of the better
behavior:

https://github.com/markfasheh/duperemove/tree/alignment_fix
	--Mark

--
Mark Fasheh
