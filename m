Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57938 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752088Ab3K2SHq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Nov 2013 13:07:46 -0500
Date: Fri, 29 Nov 2013 19:07:45 +0100
From: David Sterba <dsterba@suse.cz>
To: kreijack@inwind.it
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] BTRFS-PROG: recursively subvolume snapshot and delete
Message-ID: <20131129180745.GQ25312@suse.cz>
Reply-To: dsterba@suse.cz
References: <1384621747-25441-1-git-send-email-kreijack@inwind.it>
 <20131128183122.GL25312@twin.jikos.cz>
 <52979821.60401@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52979821.60401@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 28, 2013 at 08:23:13PM +0100, Goffredo Baroncelli wrote:
> Definetely you are right. In fact this is true also for other tools like
> tar: they complaint if you remove/move/rename a file during the copy. We
> can work to increase the robustness of the process, to avoid strange
> behaviour when a subvolume is removed/moved/renamed.
> 
> Anyway I am more afraid that we can't mix recursive and readonly snapshot.

Agreed, this would eg. need to toggle RO/RW status when needed, but this
does not sound very clean.

> Implementing the atomic recursive snapshot in the kernel, is out of my
> possibility; anyway basically this means that the filesystem is frozen
> until all the snapshot are done, which requires a finite time. In case
> of a high number of subvolumes this could be a problem.

High number of subvolumes to snapshot atomically will always be
problematic and a lazy userspace-based recursive snapshot might be
actually better regarding the impact on the rest of the system, but
without guaranteed atomicity.

But, I don't want to kill the whole idea just because there's some
scenario that's possible but hard to handle.

david
