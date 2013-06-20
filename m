Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43353 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754535Ab3FTKmK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Jun 2013 06:42:10 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UpcJd-0004Lw-DR
	for linux-btrfs@vger.kernel.org; Thu, 20 Jun 2013 12:42:09 +0200
Received: from pro75-5-88-162-203-35.fbx.proxad.net ([88.162.203.35])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Jun 2013 12:42:09 +0200
Received: from g2p.code by pro75-5-88-162-203-35.fbx.proxad.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Jun 2013 12:42:09 +0200
To: linux-btrfs@vger.kernel.org
From: Gabriel de Perthuis <g2p.code@gmail.com>
Subject: Re: Two identical copies of an image mounted result in changes to
 both images if only one is modified
Date: Thu, 20 Jun 2013 10:41:53 +0000 (UTC)
Message-ID: <kpum9h$ei7$2@ger.gmane.org>
References: <CAFvQSYRgvsqMxk_yZf6cPyoECJsUzn2g+cW-j7ktrWnhRL+0jA@mail.gmail.com>
	<20130620091622.GL11290@carfax.org.uk> <kpul4f$ei7$1@ger.gmane.org>
	<20130620103404.GN11290@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> Instead of redirecting to a different block device, Btrfs could and
>> should refuse to mount an already-mounted superblock when the block
>> device doesn't match, somewhere in or below btrfs_mount.  Registering
>> extra, distinct superblocks for an already mounted raid is a different
>> matter, but that isn't done through the mount syscall anyway.
> 
>    The problem here is that you could quite legitimately mount
> /dev/sda (with UUID=AA1234) on, say, /mnt/fs-a, and /dev/sdb (with
> UUID=AA1234) on /mnt/fs-b -- _provided_ that /dev/sda and /dev/sdb are
> both part of the same filesystem. So you can't simply prevent mounting
> based on the device that the mount's being done with.

Okay.  The check should rely on a list of known block devices
for a given filesystem uuid.


