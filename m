Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp52.i.mail.ru ([94.100.177.112]:60357 "EHLO smtp52.i.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753376AbcFTQeA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Jun 2016 12:34:00 -0400
Received: from 82-169-65-155.ip.telfort.nl ([82.169.65.155]:56842 helo=centurion.home)
	by smtp52.i.mail.ru with esmtpa (envelope-from <dma_k@mail.ru>)
	id 1bF297-0006Z5-7s
	for linux-btrfs@vger.kernel.org; Mon, 20 Jun 2016 19:33:57 +0300
Received: from www.centurion.link (localhost [IPv6:::1])
	by centurion.home (Postfix) with ESMTP id CE6641D5B15
	for <linux-btrfs@vger.kernel.org>; Mon, 20 Jun 2016 18:33:54 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Mon, 20 Jun 2016 18:33:54 +0200
From: Dmitry Katsubo <dma_k@mail.ru>
To: linux-btrfs@vger.kernel.org
Subject: Is "btrfs balance start" truly asynchronous?
Message-ID: <f68639e5a41343c04fa4d76f3fb14370@www.centurion.link>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear btfs community,

I have added a drive to existing raid1 btrfs volume and decided to 
perform balancing so that data distributes "fairly" among drives. I have 
started "btrfs balance start", but it stalled for about 5-10 minutes 
intensively doing the work. After that time it has printed something 
like "had to relocate 50 chunks" and exited. According to drive I/O, 
"btrfs balance" did most (if not all) of the work, so after it has 
exited the job was done.

Shouldn't "btrfs balance start" do the operation in the background?

Thanks for any information.

-- 
With best regards,
Dmitry
