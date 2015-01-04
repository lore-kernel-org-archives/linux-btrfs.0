Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47950 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979AbbADKpF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 4 Jan 2015 05:45:05 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Y7igB-0007Hx-N9
	for linux-btrfs@vger.kernel.org; Sun, 04 Jan 2015 11:45:03 +0100
Received: from battery.modeemi.fi ([130.230.72.137])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 04 Jan 2015 11:45:03 +0100
Received: from flux-btrfs by battery.modeemi.fi with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 04 Jan 2015 11:45:03 +0100
To: linux-btrfs@vger.kernel.org
From: Erkki Seppala <flux-btrfs@inside.org>
Subject: Re: [PATCH 2/2] E2fsprogs: add compress and cow support in chattr, lsattr
Date: 04 Jan 2015 12:40:59 +0200
Message-ID: <m49d26u96bo.fsf@battery.modeemi.fi>
References: <4DA2A15C.1050501@cn.fujitsu.com> <4DA692C8.2080400@cn.fujitsu.com> <4DABEA3A.4070008@cn.fujitsu.com> <54A67152.4030404@5t9.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Lutz Vieweg <lvml@5t9.de> writes:

> Maybe "chattr +C" could print a warning if a file
> to change attributes for is > 0 bytes long?

This may only affect btrfs. The old ext2? ext3? compression patches
were able to compress pre-existing files. I don't know how other
filesystems behave in this regard.

-- 
  _____________________________________________________________________
     / __// /__ ____  __               http://www.modeemi.fi/~flux/\   \
    / /_ / // // /\ \/ /                                            \  /
   /_/  /_/ \___/ /_/\_\@modeemi.fi                                  \/

