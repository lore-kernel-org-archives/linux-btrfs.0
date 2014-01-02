Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44501 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751372AbaABPlF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Jan 2014 10:41:05 -0500
Date: Thu, 2 Jan 2014 16:41:03 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Add "barrier" option to support "-o
 remount,barrier"
Message-ID: <20140102154103.GL6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1388040310-25092-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1388040310-25092-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 26, 2013 at 02:45:10PM +0800, Qu Wenruo wrote:
> Btrfs can be remounted without barrier, but there is no "barrier" option
> so nobody can remount btrfs back with barrier on. Only umount and
> mount again can re-enable barrier.(Quite awkward)

Ok for adding the mount option.

> Reported-by: Daniel Blueman <daniel@quora.org>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  Documentation/filesystems/btrfs.txt | 6 ++++++
>  fs/btrfs/super.c                    | 8 +++++++-
>  2 files changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/filesystems/btrfs.txt b/Documentation/filesystems/btrfs.txt
> index 5dd282d..f6f71d6 100644
> --- a/Documentation/filesystems/btrfs.txt
> +++ b/Documentation/filesystems/btrfs.txt
> @@ -51,6 +51,12 @@ Unless otherwise specified, all options default to off.
>  	defrag process.  Works best for small files; Not well suited for
>  	large database workloads.
>  
> +  barrier
> +	Enable the use of block layer write barriers.  Write barriers ensure
> +	that certain IOs make it through the device cache and are on persistent
> +	storage.
> +	Barriers are enabled by default.

There's the 'nobarrier' option already, I think it's better to keep the
pairing option documentation at one place and mark the default one with (*).

Related to that, there should imho be a pairing option for every mount
option where it makes sense, so all the combinations work through
remount.

The defaults do not need to be listed via btrfs_show_options, ie. keep
the output same as it is now.


david
