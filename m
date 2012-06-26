Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:57325 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754634Ab2FZMtT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jun 2012 08:49:19 -0400
Date: Tue, 26 Jun 2012 08:49:16 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Liu Bo <liubo2009@cn.fujitsu.com>
CC: David Sterba <dave@jikos.cz>, Martin Steigerwald <Martin@lichtvoll.de>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Josef Bacik <JBacik@fusionio.com>
Subject: Re: 3.5-rc4: BTRFS unmountable after hard lockup
Message-ID: <20120626124915.GA2046@localhost.localdomain>
References: <201206252029.34545.Martin@lichtvoll.de>
 <20120625221826.GM28144@twin.jikos.cz>
 <4FE930D5.3050505@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4FE930D5.3050505@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 25, 2012 at 09:47:33PM -0600, Liu Bo wrote:
> On 06/26/2012 06:18 AM, David Sterba wrote:
> 
> > 3756         if (root->fs_info->log_root_recovering) {
> > 3757                 BUG_ON(!test_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
> > 3758                                  &BTRFS_I(inode)->runtime_flags));
> > 3759                 goto no_delete;
> > 3760         }
> > 
> > and it happened during log replay, as you found already, fixable by
> > running the zero-log utility. Another way is to mount read-only, this
> > skips log replay.
> > 
> > I think there could be a logic error, as this probably happens only
> > during log replay when the orphan bit is not in sync with link count,
> > but I saw that this should be handled in the fixup_inode_link_counts
> > call path. CCing Josef, if he has an idea.
> > 
> 
> 
> It is a logic error, but mostly a finger wrong from Josef IMO... :)
> 
> I'll send a patch for it.

Heh oops, sorry about that ;),

Josef
