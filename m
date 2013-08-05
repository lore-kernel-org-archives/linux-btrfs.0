Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35021 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752229Ab3HERgp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 5 Aug 2013 13:36:45 -0400
Date: Mon, 5 Aug 2013 19:36:43 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 00/11 v2 (resend)] btrfs-progs: coalesce of patches
Message-ID: <20130805173643.GF5284@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1373866257-10519-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1373866257-10519-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 15, 2013 at 01:30:46PM +0800, Anand Jain wrote:
> Anand Jain (11):
>   btrfs-progs: btrfs_scan_for_fsid doesn't need all the arguments
>   btrfs-progs: label option in btrfs filesystem show is not coded
>   btrfs-progs: update device scan usage
>   btrfs-progs: congregate dev scan
>   btrfs-progs: btrfs_scan_one_dir not to skip links when /dev/mapper is
>     provided
>   btrfs-progs: scan /dev/mapper in filesystem show and device scan
>   btrfs-progs: device delete to get errors from the kernel
>   btrfs-progs: get_label_mounted to return label instead of print
>   btrfs-progs: move out print in cmd_df to another function
>   btrfs-progs: get string for the group profile and type
>   btrfs-progs: introduce btrfs filesystem show --kernel

patches 1-4,7,8 added to integration, skipped 5,6 as they enhance dev
scan that'll need a rewrite anyway.

9-11 are sort of independent of the previous changes so I'd like to look
at them in context of all the other df/show patches.

david
