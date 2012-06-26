Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:9655 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754988Ab2FZDsf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jun 2012 23:48:35 -0400
Message-ID: <4FE930D5.3050505@cn.fujitsu.com>
Date: Tue, 26 Jun 2012 11:47:33 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
MIME-Version: 1.0
To: David Sterba <dave@jikos.cz>
CC: Martin Steigerwald <Martin@lichtvoll.de>, linux-btrfs@vger.kernel.org,
        jbacik@fusionio.com
Subject: Re: 3.5-rc4: BTRFS unmountable after hard lockup
References: <201206252029.34545.Martin@lichtvoll.de> <20120625221826.GM28144@twin.jikos.cz>
In-Reply-To: <20120625221826.GM28144@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/26/2012 06:18 AM, David Sterba wrote:

> 3756         if (root->fs_info->log_root_recovering) {
> 3757                 BUG_ON(!test_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
> 3758                                  &BTRFS_I(inode)->runtime_flags));
> 3759                 goto no_delete;
> 3760         }
> 
> and it happened during log replay, as you found already, fixable by
> running the zero-log utility. Another way is to mount read-only, this
> skips log replay.
> 
> I think there could be a logic error, as this probably happens only
> during log replay when the orphan bit is not in sync with link count,
> but I saw that this should be handled in the fixup_inode_link_counts
> call path. CCing Josef, if he has an idea.
> 


It is a logic error, but mostly a finger wrong from Josef IMO... :)

I'll send a patch for it.

thanks,
liubo
