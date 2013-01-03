Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tetsuo.zabbo.net ([50.193.208.193]:34921 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753777Ab3ACTH6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 3 Jan 2013 14:07:58 -0500
Date: Thu, 3 Jan 2013 11:07:57 -0800
From: Zach Brown <zab@zabbo.net>
To: Hugo Mills <hugo@carfax.org.uk>, Gene Czarcinski <gene@czarc.net>,
        linux-btrfs@vger.kernel.org
Subject: Re: fsck.btrfs
Message-ID: <20130103190757.GK9195@lenny.home.zabbo.net>
References: <50D5B92D.105@czarc.net>
 <20121222142733.GR19051@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20121222142733.GR19051@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> > 1. Would btrfsck be the appropriate program to run at bootup?  If it
> > is, with what parameters?
> 
>    No, it's not necessary to run an fs checker on every boot. You can
> either turn off the checks in fstab, or symlink /sbin/fsck.btrfs to
> /bin/true.

For what it's worth, I gather that the XFS guys used to do the latter
and that it broke something.  Somewhere.  I have no idea what.

Hence fsck.xfs(8) which has perhaps the greatest description in its man
page. 

- z
