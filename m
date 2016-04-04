Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42586 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754070AbcDDUUI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Apr 2016 16:20:08 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1anAyi-0006T4-1t
	for linux-btrfs@vger.kernel.org; Mon, 04 Apr 2016 22:20:04 +0200
Received: from ip5f5ae008.dynamic.kabel-deutschland.de ([95.90.224.8])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Apr 2016 22:20:04 +0200
Received: from hurikhan77 by ip5f5ae008.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Apr 2016 22:20:04 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: csum failed on innexistent inode
Date: Mon, 4 Apr 2016 22:17:32 +0200
Message-ID: <20160404221732.47372382@jupiter.sol.kaishome.de>
References: <CALJXSJrdkqau4xWax72xQGBcaONDxWBeDLOn4KD7vP8NKJikDw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Mon, 4 Apr 2016 03:50:54 -0400
schrieb Jérôme Poulin <jeromepoulin@gmail.com>:

> How is it possible to get rid of the referenced csum errors if they do
> not exist? Also, the expected checksum looks suspiciously the same for
> multiple errors. Could it be bad RAM in that case? Can I convince
> BTRFS to update the csum?
> 
> # btrfs inspect-internal logical-resolve -v 1809149952 /mnt/btrfs/
> ioctl ret=-1, error: No such file or directory
> # btrfs inspect-internal inode-resolve -v 296 /mnt/btrfs/
> ioctl ret=-1, error: No such file or directory

I fell into that pitfall, too. If you have multiple subvolumes, you
need to pass the correct subvolume path for the inode to properly
resolve.

Maybe that's the case for you?

First, take a look at what "btrfs subvol list /mnt/btrfs" shows you.

-- 
Regards,
Kai

Replies to list-only preferred.


