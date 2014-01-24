Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52799 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752477AbaAXPZM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jan 2014 10:25:12 -0500
Date: Fri, 24 Jan 2014 16:25:10 +0100
From: David Sterba <dsterba@suse.cz>
To: Mitchel Humpherys <mitch.special@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: add help switches where needed
Message-ID: <20140124152510.GT6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1389846390-17585-1-git-send-email-mitch.special@gmail.com>
 <1389846390-17585-2-git-send-email-mitch.special@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1389846390-17585-2-git-send-email-mitch.special@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 15, 2014 at 08:26:30PM -0800, Mitchel Humpherys wrote:
> Some of the btrfs programs don't support -h or --help. It's not really a
> problem since everyone seems to fall back to printing usage text when an
> option is not recognized, so passing -h or --help usually gets you the
> usage text. However, it also usually gets you a "invalid option -- 'h'".
> 
> Fix this minor annoyance by adding proper support for -h and --help
> where appropriate.

There was patch to add -h option, to fsck only as an example, and so far
I don't think we need it for any command, when there's --help available.

http://www.spinics.net/lists/linux-btrfs/msg29110.html

As you say, it's a minor annoyance, I'd prefer to not use the -h option.


david
