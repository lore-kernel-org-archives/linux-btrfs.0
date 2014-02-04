Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48388 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752629AbaBDRTe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 4 Feb 2014 12:19:34 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WAjem-0002Ci-5q
	for linux-btrfs@vger.kernel.org; Tue, 04 Feb 2014 18:19:32 +0100
Received: from 78-32-127-104.static.enta.net ([78.32.127.104])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Feb 2014 18:19:32 +0100
Received: from alex by 78-32-127-104.static.enta.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Feb 2014 18:19:32 +0100
To: linux-btrfs@vger.kernel.org
From: Alex <alex@bpmit.com>
Subject: Re: Booting with syslinux not possible
Date: Tue, 4 Feb 2014 17:19:09 +0000 (UTC)
Message-ID: <loom.20140204T175441-117@post.gmane.org>
References: <52EBFD82.7080900@gmail.com> <loom.20140131T225403-745@post.gmane.org> <52F10CAC.5030306@laly.si>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Blaz Balon <blaz.balon <at> laly.si> writes:

> 
> I also had some problems with syslinux.
> 
> For me it only works if I put boot folder to root of btrfs.
> Didn't have a chance to do more test, but I copied /boot from default 
> subvolume to subvolume 0 and it boots OK.

Not sure I understand your /boot comment. I have some /boots on the main
btrfs partition and some mounted ext(x)s (can't remember, don't care).

I have quite an (overly) complicated setup. All major directories are
subvols eg. /etc /usr etc so that I can snapshot at almost every level. if
you create the subvol you want as a tree, debootstrap (Debian) and git clone
the stages (funtoo) are quite happy, but I guess you know that.

Transforming from standard directory to subvol is easy with any live distro
(sysrescuecd).





