Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36911 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752948AbaBCRyH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 3 Feb 2014 12:54:07 -0500
Date: Mon, 3 Feb 2014 18:54:05 +0100
From: David Sterba <dsterba@suse.cz>
To: Chris Mason <clm@fb.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [GIT PULL] Btrfs
Message-ID: <20140203175405.GL1364@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <52EAC9B6.7090603@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52EAC9B6.7090603@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 30, 2014 at 04:52:54PM -0500, Chris Mason wrote:
> Chris Mason (3) commits (+64/-32):
>     Btrfs: setup inode location during btrfs_init_inode_locked (+9/-9)
>     Btrfs: don't use ram_bytes for uncompressed inline items (+52/-22)

The patches are CC: stable, but haven't gone through the mailinglist.
Are they still going to be picked by stable?

The commit ids:
90d3e592e99b8e374ead2b45148abf506493a959
514ac8ad8793a097c0c9d89202c642479d6dfa34

but unfortunatelly neither applies directly to anything 3.10+


david
