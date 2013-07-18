Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44010 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759049Ab3GRRu1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Jul 2013 13:50:27 -0400
Date: Thu, 18 Jul 2013 19:50:25 +0200
From: David Sterba <dsterba@suse.cz>
To: chandan <chandan@linux.vnet.ibm.com>
Cc: Chris Mason <chris.mason@fusionio.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs_read_block_groups: Use enums to index
 btrfs_space_info->block_groups.
Message-ID: <20130718175024.GP24343@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1650034.SFcoKv6ShF@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1650034.SFcoKv6ShF@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 16, 2013 at 03:03:12PM +0530, chandan wrote:
> >From 33e376755b8a928610032a1cef024dcdd980aee3 Mon Sep 17 00:00:00 2001
> From: chandan <chandan@linux.vnet.ibm.com>
> Date: Tue, 16 Jul 2013 12:28:56 +0530
> Subject: [PATCH] btrfs_read_block_groups: Use enums to index
>  btrfs_space_info->block_groups.
> 
> The current code uses integer literals to index
> btrfs_space_info->block_groups[] array. Instead use corresponding
> enums from 'enum btrfs_raid_types'.
> 
> Signed-off-by: chandan <chandan@linux.vnet.ibm.com>

Reviewed-by: David Sterba <dsterba@suse.cz>
