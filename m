Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:51268 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbcBMD3H (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Feb 2016 22:29:07 -0500
Received: from merlin by mail1.merlins.org with local (Exim 4.80 #2)
	id 1aUQt4-000626-Bg by authid <merlin>
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Feb 2016 19:28:46 -0800
Date: Fri, 12 Feb 2016 19:28:46 -0800
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: Is there now a way to migrate FS without losing shared COW blocks between subvolumes?
Message-ID: <20160213032846.GB6717@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs send lets you keep COW blocks within a subvolume.
But if I have lots of backups where subvolumes have shared data, and I need
to migrate this to a new filesystem, is there a decent way?

I know I can btrfs device add new drive as raid1, but I'm trying to migrate
off an old filesystem that likely wasn't created well. Is there a way to do
that?
I guess ideally I'd need btrfs send on a volume level, not subvolume level.

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
