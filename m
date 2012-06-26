Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:42181 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756054Ab2FZM2t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jun 2012 08:28:49 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: Re: 3.5-rc4: BTRFS unmountable after hard lockup
Date: Tue, 26 Jun 2012 14:28:47 +0200
Cc: David Sterba <dave@jikos.cz>, linux-btrfs@vger.kernel.org,
        jbacik@fusionio.com
References: <201206252029.34545.Martin@lichtvoll.de> <20120625221826.GM28144@twin.jikos.cz> <4FE930D5.3050505@cn.fujitsu.com> (sfid-20120626_104254_916758_98D246E0)
In-Reply-To: <4FE930D5.3050505@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201206261428.48262.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Dienstag, 26. Juni 2012 schrieb Liu Bo:
> On 06/26/2012 06:18 AM, David Sterba wrote:
> > 3756         if (root->fs_info->log_root_recovering) {
> > 3757                 BUG_ON(!test_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
> > 3758                                 &BTRFS_I(inode)->runtime_flags)); 
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
> 
> It is a logic error, but mostly a finger wrong from Josef IMO... :)
> 
> I'll send a patch for it.

Thanks for looking into it. 

Since my BTRFS is up and running again I can´t test a patch easily however.
I´d have to unplug the disk or crash my laptop several times to trigger it
again I bet.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
