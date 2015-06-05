Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53895 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062AbbFEN6K (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 5 Jun 2015 09:58:10 -0400
Date: Fri, 5 Jun 2015 15:58:08 +0200
From: David Sterba <dsterba@suse.cz>
To: Robbie Ko <robbieko@synology.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/5] Btrfs: incremental send, fix orphan_dir_info not
 completely cleared
Message-ID: <20150605135808.GR6761@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1433416690-19177-1-git-send-email-robbieko@synology.com>
 <1433416690-19177-4-git-send-email-robbieko@synology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1433416690-19177-4-git-send-email-robbieko@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 04, 2015 at 07:18:08PM +0800, Robbie Ko wrote:
> @@ -2913,6 +2912,12 @@ static int can_rmdir(struct send_ctx *sctx, u64 dir, u64 dir_gen,
>  		}
>  
>  		if (loc.objectid > send_progress) {
> +			struct orphan_dir_info *odi;
> +
> +			odi = get_orphan_dir_info(sctx, dir);
> +			if (odi) {
> +				free_orphan_dir_info(sctx, odi);
> +			}

As you're going to resend, please drop the { .. } around the call.
