Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48388 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755197Ab3CLP2A (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Mar 2013 11:28:00 -0400
Date: Tue, 12 Mar 2013 16:27:59 +0100
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: alloc our super copy in btrfs-find-root
Message-ID: <20130312152759.GM7229@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1363097259-1860-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1363097259-1860-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 12, 2013 at 10:07:39AM -0400, Josef Bacik wrote:
> Dave fixed the fs_info to allocate the super copy instead of embedding it, but
> he failed to notice that I open code open_ctree in btrfs-find-root so we end up
> with a super that's not allocated, so we segfault whenever you try to run
> btrfs-find-root.  I've fixed this up and now we don't segfault anymore.  Thanks,

Sorry about that, patch queued.

david
