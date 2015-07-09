Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:32809 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145AbbGIM04 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Jul 2015 08:26:56 -0400
Received: from merkaba.localnet (unknown [188.174.194.136])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 392CEF3
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Jul 2015 14:26:55 +0200 (CEST)
From: Martin Steigerwald <martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Anyone tried out btrbk yet?
Date: Thu, 09 Jul 2015 14:26:55 +0200
Message-ID: <11148188.L9vtSMaNHV@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

I see Alex, the developer of btrbk posted here once about btrfs send and 
receive, but well any other users of btrbk¹? What are your experiences?

I consider switching to it from my home grown rsync based backup script to 
it.

Well I may try it for one of my BTRFS volumes in addition to the rsync 
backup for now. I would like to give all options on command line, but well, 
maybe it can completely replace my current script if I put everything in its 
configuration.

Any other handy BTRFS backup solutions?

[1] http://www.digint.ch/btrbk/

Thanks,
-- 
Martin
