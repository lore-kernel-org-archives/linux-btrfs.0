Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from brockman.in8.de ([85.214.220.56]:48435 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932350Ab2J3P6U (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Oct 2012 11:58:20 -0400
Message-ID: <508FF91B.3080000@jan-o-sch.net>
Date: Tue, 30 Oct 2012 16:58:19 +0100
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>,
        =?ISO-8859-1?Q?G=E1bor_Nyers?= <gnyers@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: How to find (out if) files sharing content?
References: <20121030162005.0308d5a2@lupus.demo.lan> <20121030153922.GA11422@carfax.org.uk>
In-Reply-To: <20121030153922.GA11422@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, October 30, 2012 at 16:39 (+0100), Hugo Mills wrote:
> It should be possible to walk through the
> extents of a given file, and (I think) follow back-refs from the
> extent back to the other files that share it.

You wish :-) Backrefs are not made to walk them while the file system is online.
However "btrfs inspect logical" manages quite well, at least I haven't heard
otherwise so far. You still need to get the logical block numbers, either by
TREE_SEARCH ioctl or by filefrag.

-Jan
