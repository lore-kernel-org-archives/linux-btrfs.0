Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:58248 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754447AbbFQOrE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jun 2015 10:47:04 -0400
Date: Wed, 17 Jun 2015 15:47:00 +0100
From: Luis Henriques <luis.henriques@canonical.com>
To: David Sterba <dsterba@suse.cz>
Cc: stable@vger.kernel.org, linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: Btrfs stable updates for 4.0
Message-ID: <20150617144700.GA1882@ares>
References: <cover.1434037853.git.dsterba@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <cover.1434037853.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 11, 2015 at 06:06:32PM +0200, David Sterba wrote:
> Hi,
> 
> please queue the following patches to 4.0 stable. There are fixes for user
> visible bugs and one usability regression with RAID1 -> single conversion
> during balance.
> 
> One of the patches does not apply cleanly to 4.0.5, there's a minor conflict in
> patch context (153c35b6cccc0c72de9fae06c8e2c8b2c47d79d4, the last one). A reply
> to this mail is the adapted version or you can pull/cherry-pick from
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-stable-4.0
> 
> Subjects:
> 	Btrfs: send, add missing check for dead clone root
> 	Btrfs: send, don't leave without decrementing clone root's send_progress
> 	btrfs: incorrect handling for fiemap_fill_next_extent return
> 	btrfs: cleanup orphans while looking up default subvolume
> 	Btrfs: fix range cloning when same inode used as source and destination
> 	Btrfs: fix uninit variable in clone ioctl
> 	Btrfs: fix regression in raid level conversion
> Commits:
> 	5cc2b17e80cf5770f2e585c2d90fd8af1b901258 # 3.14+
> 	2f1f465ae6da244099af55c066e5355abd8ff620 # 3.14+
> 	26e726afe01c1c82072cf23a5ed89ce25f39d9f2 # 3.10+
> 	727b9784b6085c99c2f836bf4fcc2848dc9cf904 # 3.14+

Thanks, I'm applying the above commits to 3.16 kernel as well.

Cheers,
--
Luís

> 	df858e76723ace61342b118aa4302bd09de4e386 # 4.0+
> 	de249e66a73d696666281cd812087979c6fae552 # 4.0+
> 	153c35b6cccc0c72de9fae06c8e2c8b2c47d79d4 # 4.0+
> 
> Thanks.
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
