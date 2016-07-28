Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44095 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756885AbcG1Lcq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Jul 2016 07:32:46 -0400
Date: Thu, 28 Jul 2016 13:32:27 +0200
From: David Sterba <dsterba@suse.cz>
To: Sanidhya Solanki <lkml.page@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Change RAID stripesize to a user-configurable
 option
Message-ID: <20160728113227.GS30795@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1469194967-27734-1-git-send-email-lkml.page@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1469194967-27734-1-git-send-email-lkml.page@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'll comment on the overall approach and skip code-specific comments.

The changelog does not explain why there's a need for a new blockgroup
type and what's the relation to the existing types. It seems that it
extends the data/metadata/system group, but I think this is totally
wrong.

The proposed changes modify part of the on-disk format, that would
require a incompat bit and brings the usual load of unpleasant issues
with backward compatibility. The current data structures should be
enough for configurable stripe size.  If you want to make stripe size
configurable, then replace all hardcoded values of BTRFS_STRIPE_LEN.

On Fri, Jul 22, 2016 at 09:42:47AM -0400, Sanidhya Solanki wrote:
> --- a/include/trace/events/btrfs.h
> +++ b/include/trace/events/btrfs.h

> +	{ BTRFS_BLOCK_GROUP_RAID,	"RAID"},	\

>  #define BTRFS_BALANCE_TYPE_MASK		(BTRFS_BALANCE_DATA |	    \
> +					 BTRFS_BALANCE_RAID |	    \
>  					 BTRFS_BALANCE_SYSTEM |	    \
>  					 BTRFS_BALANCE_METADATA)
