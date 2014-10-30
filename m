Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 17.mo1.mail-out.ovh.net ([87.98.179.142]:60644 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760856AbaJ3SrR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Oct 2014 14:47:17 -0400
Received: from mail636.ha.ovh.net (b6.ovh.net [213.186.33.56])
	by mo1.mail-out.ovh.net (Postfix) with SMTP id 792E0FF98F9
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Oct 2014 19:37:34 +0100 (CET)
From: Cyril Scetbon <cyril.scetbon@free.fr>
Content-Type: text/plain; charset=us-ascii
Subject: Quota question
Message-Id: <23550138-C487-44E1-AA4A-B3B951D778D1@free.fr>
Date: Thu, 30 Oct 2014 19:37:32 +0100
To: linux-btrfs@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 8.0 \(1990.1\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

At https://btrfs.wiki.kernel.org/index.php/Quota_support it's said that "Using btrfs subvolume delete will break qgroup unshared space usage". Does it mean that if the qgroup associated with the subvolume is attached to another qgroup, this other qgroup won't be able to correctly apply its quota ? If yes, is there a workaround for that ?

Thanks
-- 
Cyril SCETBON

