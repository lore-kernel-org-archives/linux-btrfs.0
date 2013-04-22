Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60371 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752307Ab3DVO0S (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Apr 2013 10:26:18 -0400
Date: Mon, 22 Apr 2013 16:26:16 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: deal with bad mappings in btrfs_map_block
Message-ID: <20130422142616.GO16427@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1366636451-2151-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1366636451-2151-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 22, 2013 at 09:14:11AM -0400, Josef Bacik wrote:
> Martin Steigerwald reported a BUG_ON() in btrfs_map_block where we didn't find
> a chunk for a particular block we were trying to map.  This happened because the
> block was bogus.  We shouldn't be BUG_ON()'ing in this case, just print a
> message and return an error.  This came from reada_add_block and it appears to
> deal with an error fine so we should be good there.  Thanks,

There are various call paths that lead to __btrfs_map_block, via
btrfs_map_block (and btrfs_map_bio).

Lots of the retval checks are still marked with /* ENOMEM */ so it does
not seem that all the paths were verified to be safe wrt EIO. After a
quick skim I think that most of the callsites are doing proper error
handling (and some of them continue to BUG_ON(ret < 0)) namely after the
btrfs_map_bio handling that Stefan did. Remains to make sure that
btrfs_map_block are also ok, sofar I don't see major problems right now.

As you're extending the set of return values please remove all the
ENOMEM comments like

btrfs_map_bio():

5278         ret = __btrfs_map_block(root->fs_info, rw, logical, &map_length, &bbio,
5279                               mirror_num, &raid_map);
5280         if (ret) /* -ENOMEM */

so comments and code match.


david
