Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33101 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756542Ab3DWRZH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Apr 2013 13:25:07 -0400
Date: Tue, 23 Apr 2013 19:25:05 +0200
From: David Sterba <dsterba@suse.cz>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: add function to map subvol ID to path
Message-ID: <20130423172505.GY16427@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1366712335-13322-1-git-send-email-sbehrens@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1366712335-13322-1-git-send-email-sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 23, 2013 at 12:18:55PM +0200, Stefan Behrens wrote:
> Several tools like btrfs-send and btrfs-receive need to map a
> subvolume ID to a filesystem path. The so far existing methods
> in btrfs-list.c cause a horrible effort when performing this
> operation (and the effort is dependent on the number of
> existing subvolumes with quadratic effort). This commit adds a
> function that is able to map a subvolume ID to a filesystem path
> with an effort that is independent of the number of existing
> subvolumes.
> 
> In addition to this function, a command line frontend is added as well:
> btrfs inspect-internal subvolid-resolve <subvolid> <path>

Nice. The 'inspect' section is imo right for such simple lookup.

We could possibly extend it to print the path relative to the current
default or currently mounted subvol, or teach 'subvol show' to accept
subvol ids as well.

david
