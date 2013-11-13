Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:38985 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754386Ab3KMLdL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Nov 2013 06:33:11 -0500
Message-ID: <52836375.9050100@giantdisaster.de>
Date: Wed, 13 Nov 2013 12:33:09 +0100
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: try harder to make btrfs receive successfully
References: <1384334746-11503-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1384334746-11503-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 13 Nov 2013 17:25:46 +0800, Wang Shilong wrote:
> Steps to reproduce:
> 	# mkfs.btrfs -f <dev>
> 	# mount <dev> <mnt>
> 	# mkdir <mnt>/backup
> 	# btrfs sub create <mnt>/subv
> 	# btrfs sub snapshot -r <mnt>/subv <mnt>/snap1
> 	# btrfs sub snapshot -r <mnt>/subv <mnt>/snap2
> 	# btrfs send <mnt>/snap2 -p <mnt>/snap1 -f sent_file
> 	# btrfs receive -f sent_file <mnt>/backup

The use case is that you store btrfs send generated stream-files for a
backup. In the example above, if <mnt>/snap2 was deleted or lost between
the send and the receive, and <sent_file> was stored on some backup
storage as an incremental backup file, in this case, this patch makes
sense. Otherwise, the send and receive procedure could simply be
replaced by 'btrfs sub snapshot -r <mnt>/snap2 <mnt>/backup/snap2'.

Reviewed-by: Stefan Behrens <sbehrens@giantdisaster.de>

> 
> Above steps will make btrfs receive fails with "ERROR: can not find parent subvolume",
> this is because we try to find parent subvolume by RECEIVED_SUBVOL_KEY,and it
> will return ENOENT if parent snapshot has not been sent or it has been deleted.Actually,
> we can try harder to find whether parent subvolume exists by searching uuid key.
> 
> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
> ---
>  cmds-receive.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/cmds-receive.c b/cmds-receive.c
> index 2b880c0..95dc3ec 100644
> --- a/cmds-receive.c
> +++ b/cmds-receive.c
> @@ -234,6 +234,10 @@ static int process_snapshot(const char *path, const u8 *uuid, u64 ctransid,
>  	parent_subvol = subvol_uuid_search(&r->sus, 0, parent_uuid,
>  			parent_ctransid, NULL, subvol_search_by_received_uuid);
>  	if (!parent_subvol) {
> +		parent_subvol = subvol_uuid_search(&r->sus, 0, parent_uuid,
> +				parent_ctransid, NULL, subvol_search_by_uuid);
> +	}
> +	if (!parent_subvol) {
>  		ret = -ENOENT;
>  		fprintf(stderr, "ERROR: could not find parent subvolume\n");
>  		goto out;
> 


