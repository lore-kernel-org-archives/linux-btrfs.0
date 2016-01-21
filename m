Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41054 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759617AbcAUSfh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jan 2016 13:35:37 -0500
Date: Thu, 21 Jan 2016 19:35:30 +0100
From: David Sterba <dsterba@suse.cz>
To: Mike Gilbert <floppym@gentoo.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Makefile.in: Simplify/correct install-static
Message-ID: <20160121183530.GP4227@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1453391972-25669-1-git-send-email-floppym@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1453391972-25669-1-git-send-email-floppym@gentoo.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 21, 2016 at 10:59:32AM -0500, Mike Gilbert wrote:
> install -D does not create the last component, so this failed if
> $(DESTDIR)$(bindir) did not already exist.
> 
> There's no need for a loop here since install accepts multiple source
> arguments.
> 
> Signed-off-by: Mike Gilbert <floppym@gentoo.org>

Applied, thanks.
