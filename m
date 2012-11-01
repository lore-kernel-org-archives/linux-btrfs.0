Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [37.247.8.11] ([37.247.8.11]:50223 "EHLO mail.southpole.se"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755379Ab2KANf2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 Nov 2012 09:35:28 -0400
Received: from [128.224.92.193] (assp.southpole.se [37.247.8.10])
	by mail.southpole.se (Postfix) with ESMTPSA id E7C2248019B
	for <linux-btrfs@vger.kernel.org>; Thu,  1 Nov 2012 14:35:26 +0100 (CET)
Message-ID: <50927A9E.70106@southpole.se>
Date: Thu, 01 Nov 2012 14:35:26 +0100
From: Kenneth Johansson <kenneth@southpole.se>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: no space left on device.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So I have ended up in a state where I can't delete files with rm.

the error I get is no space on device. however I'm not even close to empty.
/dev/sdb1 38G 27G 9.5G 75%
there is about 800k files/dirs in this filesystem

extra strange is that I can in another directory create and delete files.

So I tried pretty much all I could google my way to but problem 
persisted. So I decided to do a backup and a format. But when the backup 
was done I tried one more time and now it was possible to delete the 
directory and all content?

using the 3.5 kernel in ubuntu 12.10. Is this a known issue ? is it 
fixed in later kernels?

fsck /btrfs scrub and kernel log. nothing indicate any problem of any kind.

