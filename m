Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from torres.zugschlus.de ([85.214.131.164]:57954 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbcCaGVO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Mar 2016 02:21:14 -0400
Received: from mh by torres.zugschlus.de with local (Exim 4.84_2)
	(envelope-from <mh+linux-btrfs@zugschlus.de>)
	id 1alVyi-0005f9-HB
	for linux-btrfs@vger.kernel.org; Thu, 31 Mar 2016 08:21:12 +0200
Date: Thu, 31 Mar 2016 08:21:12 +0200
From: Marc Haber <mh+linux-btrfs@zugschlus.de>
To: linux-btrfs@vger.kernel.org
Subject: How to cancel btrfs balance on unmounted filesystem
Message-ID: <20160331062112.GT9342@torres.zugschlus.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

one of my problem btrfs instances went into a hung process state
while blancing metadata. This process is recorded in the file system
somehow and the balance restarts immediately after mounting the
filesystem with no chance to issue a btrfs balance cancel command
before the system hangs again.

Is there any possiblity to cancel the pending balance without mounting
the fs first?

I have also filed https://bugzilla.kernel.org/show_bug.cgi?id=115581
to adress this in a more elegant way.

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
