Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47525 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086Ab3KGNpw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Nov 2013 08:45:52 -0500
Date: Thu, 7 Nov 2013 21:45:25 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz, Stefan Behrens <sbehrens@giantdisaster.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH] Btrfs: change ioctl number of BTRFS_IOC_START_SYNC
 to 21
Message-ID: <20131107134524.GA9760@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1383728479-29037-1-git-send-email-bo.li.liu@oracle.com>
 <527A0F0B.7020009@giantdisaster.de>
 <20131106132425.GV16662@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20131106132425.GV16662@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 06, 2013 at 02:24:25PM +0100, David Sterba wrote:
> On Wed, Nov 06, 2013 at 10:42:35AM +0100, Stefan Behrens wrote:
> > Sharing the ioctl value seems to have happened by mistake and is
> > uncommon, but IMHO now it's too late to change this interface just for
> > esthetical reasons.
> 
> Agreed, it's part of ABI, ioctl.h is "append only".

Ok, I think that's why I tagged it as 'RFC' :-)

-liubo
