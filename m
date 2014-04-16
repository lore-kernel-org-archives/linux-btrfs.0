Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51625 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752134AbaDPRMV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Apr 2014 13:12:21 -0400
Date: Wed, 16 Apr 2014 19:12:19 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: [PATCH 00/27] Replace the old man page with asciidoc and man
 page for each btrfs subcommand.
Message-ID: <20140416171219.GC29256@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 02, 2014 at 04:29:11PM +0800, Qu Wenruo wrote:
> Convert the old btrfs man pages to new asciidoc and split the huge
> btrfs man page into subcommand man page.

I'm merging this patchset into the base series of integration because
several patches need to update the docs and it's no longer feasible to
keep it in a separate branch from the patches.

>   btrfs-progs: Convert man page for btrfs-dedup.

As dedup is not yet merged in kernel, the docs will not be part of the
branch (but will be otherwise present in the integration).

>   btrfs-progs: Convert man page for btrfsck

I've skipped the patch adding btrfsck and linked to 'btrfs-check'
instead, patch will follow.
