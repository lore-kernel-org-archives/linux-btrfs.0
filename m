Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40894 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754885Ab3KFRNu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Nov 2013 12:13:50 -0500
Date: Wed, 6 Nov 2013 14:24:25 +0100
From: David Sterba <dsterba@suse.cz>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH] Btrfs: change ioctl number of BTRFS_IOC_START_SYNC
 to 21
Message-ID: <20131106132425.GV16662@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1383728479-29037-1-git-send-email-bo.li.liu@oracle.com>
 <527A0F0B.7020009@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <527A0F0B.7020009@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 06, 2013 at 10:42:35AM +0100, Stefan Behrens wrote:
> Sharing the ioctl value seems to have happened by mistake and is
> uncommon, but IMHO now it's too late to change this interface just for
> esthetical reasons.

Agreed, it's part of ABI, ioctl.h is "append only".
