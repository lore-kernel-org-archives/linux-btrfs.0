Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:58795 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbaBNByZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Feb 2014 20:54:25 -0500
Date: Thu, 13 Feb 2014 17:54:26 -0800
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Cc: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: How to recover from failing btrffs send | btrfs receive?
Message-ID: <20140214015426.GH27097@merlins.org>
References: <20140212142207.GX27097@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140212142207.GX27097@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ok, let me try something else :)

Of those who are using btrfs send/receive, has anyone gotten in a state
where incrementals will not apply anymore?

Thanks,
Marc

On Wed, Feb 12, 2014 at 06:22:07AM -0800, Marc MERLIN wrote:
> So, I've veen running this for a few weeks, and soon should have
> something half decent to share for others to use.
> 
> Unfortunately, one of my backups is now failing like so:
> 
> btrfs send -p "$src_snap" "$src_newsnap" | btrfs receive "$dest_pool/"
> + btrfs send -p /mnt/btrfs_pool1/home_ro.20140209_12:00:01 home_ro.20140212_05:37:49
> + btrfs receive /mnt/btrfs_pool2//
> At subvol home_ro.20140212_05:37:49
> At snapshot home_ro.20140212_05:37:49
> ERROR: rmdir o1845158-142-0 failed. No such file or directory
> 
> This looks like it got in an unfinished state it can't recover from.
> 
> This was with kernel 3.12.7.
> 
> Can I self fix this somehow, I know I can use rsync to make both sides
> the sames, but incremental send/receive will not work anymore after
> that, correct?
> 
> Except, not really. Now I'm confused.
> legolas:/mnt/btrfs_pool1# rsync -avSH --delete --dry-run  /mnt/btrfs_pool1/home_ro.20140209_12:00:01/. /mnt/btrfs_pool2/home_ro.20140209_12\:00\:01/.
> sending incremental file list
> ./
> 
> sent 116867233 bytes  received 265427 bytes  92194.14 bytes/sec
> total size is 129135042766  speedup is 1102.47 (DRY RUN)
> legolas:/mnt/btrfs_pool1# 
> 
> (I know I start the entire backup over from scratch, but for obvious
> reasons, restarting an entire backup from scratch each time I get an
> error isn't great since it could take hours or days to backup that much
> data)
> 
> Suggestions welcome :)
> 
> Thanks,
> Marc
> -- 
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> Microsoft is to operating systems ....
>                                       .... what McDonalds is to gourmet cooking
> Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
