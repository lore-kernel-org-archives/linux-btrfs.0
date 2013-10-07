Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:62299 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756516Ab3JGTDE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Oct 2013 15:03:04 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfsck --repair --init-extent-tree: segfault error 4
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <l2ui33$vjd$1@ger.gmane.org>
Date: Mon, 7 Oct 2013 13:03:01 -0600
Cc: linux-btrfs@vger.kernel.org
Message-Id: <D78E3D68-6547-4601-B90D-7B8F867782A6@colorremedies.com>
References: <l27agq$u5a$1@ger.gmane.org> <l27mn1$squ$1@ger.gmane.org> <l2826k$1uc$1@ger.gmane.org> <pan$69794$b0c00066$a4aa3035$c87a3c3d@cox.net> <l2a635$37m$1@ger.gmane.org> <l2ietn$jv1$1@ger.gmane.org> <l2k7kd$1dh$1@ger.gmane.org> <l2mnmf$us$1@ger.gmane.org> <l2otcg$mh$1@ger.gmane.org> <l2p3ja$v8r$1@ger.gmane.org> <l2ui33$vjd$1@ger.gmane.org>
To: Martin <m_btrfs@ml1.co.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 7, 2013, at 8:56 AM, Martin <m_btrfs@ml1.co.uk> wrote:

> 
> Or try "mount -o recovery,noatime" again?

Because of this: free space inode generation (0) did not match free space cache generation (1607)

Try mount option clear_cache. You could then use iotop to make sure the btrfs-freespace process becomes inactive before unmounting the file system; I don't think you need to wait in order to use the file system, nor do you need to unmount then remount without the option. But if it works, it should only be needed once, not as a persistent mount option.


> Or is it dead?
> 
> (The 1.5TB of backup data is replicated elsewhere but it would be good
> to rescue this version rather than completely redo from scratch.
> Especially so for the sake of just a few MBytes of one corrupt directory
> tree.)

Right. If you snapshot the subvolume containing the corrupt portion of the file system, the snapshot probably inherits that corruption. But if you write to only one of them, if those writes make the problem worse, should be isolated only to the one you write to. I might avoid writing to it, honestly. To save time, get increasingly aggressive to get data out of this directory and once you succeed, blow away the file system and start from scratch.

You could also then try kernel 3.12 rc4, as there are some btrfs bug fixes I'm seeing in there also, but I don't know if any of them will help your case. If you try it, mount normally, then try to get your data. If that doesn't work, try the recovery option. Maybe you'll get different results.

Chris Murphy