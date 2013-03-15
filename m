Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56889 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753876Ab3COLW6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Mar 2013 07:22:58 -0400
Date: Fri, 15 Mar 2013 12:22:56 +0100
From: David Sterba <dsterba@suse.cz>
To: Chris Mason <chris.mason@fusionio.com>, David Sterba <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2] btrfs: enhance superblock checks
Message-ID: <20130315112256.GC7229@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1362585400-13379-1-git-send-email-dsterba@suse.cz>
 <1362748538-12873-1-git-send-email-dsterba@suse.cz>
 <20130313193119.GG15014@shiny.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130313193119.GG15014@shiny.masoncoding.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 13, 2013 at 03:31:19PM -0400, Chris Mason wrote:
> Thanks for finding this and writing up the patch.  Can we please change
> it to ignore the crc if the transid is from mkfs?

We can fix the mkfs part, but anything that goes through
commit_transaction (and write_all_supers) will fail to mount, and this
is pretty much everything in the tools (fsck, convert, select-super,
zero-log, tune, corrupt-block, offline set-label -- these I've checked).

> I'd prefer that we allow older progs for a while longer.  We can take
> this check out after a few releases.

With the impact mentioned above I'm afraid we can't put the check in
place as-is right now. A grace period and warning at mount time seems
acceptable.

david
