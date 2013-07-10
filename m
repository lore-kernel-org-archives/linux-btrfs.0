Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from caibbdcaaaaf.dreamhost.com ([208.113.200.5]:48473 "EHLO
	homiemail-a93.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754066Ab3GJDki (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Jul 2013 23:40:38 -0400
Received: from homiemail-a93.g.dreamhost.com (localhost [127.0.0.1])
	by homiemail-a93.g.dreamhost.com (Postfix) with ESMTP id ABCB58406F
	for <linux-btrfs@vger.kernel.org>; Tue,  9 Jul 2013 20:40:37 -0700 (PDT)
Received: from bheem.localnet (unknown [49.248.64.26])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: ghodechhap@ghodechhap.net)
	by homiemail-a93.g.dreamhost.com (Postfix) with ESMTPSA id 4BFF58406C
	for <linux-btrfs@vger.kernel.org>; Tue,  9 Jul 2013 20:40:37 -0700 (PDT)
From: Shridhar Daithankar <ghodechhap@ghodechhap.net>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: space cache and unclean shutdown
Date: Wed, 10 Jul 2013 09:10:33 +0530
Message-ID: <1653853.IVjAPIlynG@bheem>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I am repeatedly running into problems with space cache and unclean shutdown. I 
am hitting the bug as reported/fixed at 
https://bugzilla.kernel.org/show_bug.cgi?id=57631

The solution works for me but it is a good 10-15 min ritual to clean all the 
partitions, discard cache, reboot, rebuild cache and reboot.

Are/is there any measures that will prevent this corruption from occurring to 
begin with?

In absence of that, any way I can un-stick space/inode cache?

and should I open a separate bug for this?

I am running kernel 3.9.9 on archlinux.

Thanks.
-- 
Regards
 Shridhar
