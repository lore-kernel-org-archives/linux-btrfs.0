Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp206.alice.it ([82.57.200.102]:60987 "EHLO smtp206.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789Ab2GaVQ7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 Jul 2012 17:16:59 -0400
Message-ID: <50184B40.8010508@libero.it>
Date: Tue, 31 Jul 2012 23:16:48 +0200
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Liu Bo <liubo2009@cn.fujitsu.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] Btrfs-progs: list snapshots by generation
References: <1343713776-14232-1-git-send-email-liubo2009@cn.fujitsu.com> <1343713776-14232-3-git-send-email-liubo2009@cn.fujitsu.com>
In-Reply-To: <1343713776-14232-3-git-send-email-liubo2009@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Bo,

On 07/31/2012 07:49 AM, Liu Bo wrote:
> The idea is that we usually use snapshot to backup/restore our data, and the
> common way can be a cron script which makes lots of snapshots, so we can end
> up with spending some time to find the latest snapshot to restore.
> 
> This adds a feature for 'btrfs subvolume list' to let it list snapshots by their
> _created_ generation.
> 
> What we need to do is just to list them in descending order and get the latest
> snapshot.  What's more, we can find the oldest snapshot as well by listing
> snapshots in ascending order.
> 
> Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
> ---
>  btrfs-list.c     |  176 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
>  cmds-subvolume.c |   19 +++++-
>  2 files changed, 185 insertions(+), 10 deletions(-)
> 
[....]
>  
>  static const char * const cmd_subvol_list_usage[] = {
> -	"btrfs subvolume list [-p] <path>",
> +	"btrfs subvolume list [-ps] <path>",
>  	"List subvolumes (and snapshots)",
>  	"",
> -	"-p     print parent ID",
> +	"-p           print parent ID",
> +	"-s value     list snapshots with generation in ascending/descending order",
> +	"             (1: ascending, 0: descending)",

Please change the user interface. I suggest something like:

-s|-S		list snapshots with generation in ascending|descending
		order	

Or better

-s		sort by generation
-P		sort by path
-r		reverse the sort order


Anyway, whichever your choice will be, please remember to update the man
page too.

>  	NULL
>  };

[...]

