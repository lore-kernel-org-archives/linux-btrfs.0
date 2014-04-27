Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cc-smtpout3.netcologne.de ([89.1.8.213]:39128 "EHLO
	cc-smtpout3.netcologne.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbaD0Ph3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Apr 2014 11:37:29 -0400
Received: from cc-smtpin2.netcologne.de (cc-smtpin2.netcologne.de [89.1.8.202])
	by cc-smtpout3.netcologne.de (Postfix) with ESMTP id E6CE012234
	for <linux-btrfs@vger.kernel.org>; Sun, 27 Apr 2014 17:37:26 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by cc-smtpin2.netcologne.de (Postfix) with ESMTP id E0FDF11D75
	for <linux-btrfs@vger.kernel.org>; Sun, 27 Apr 2014 17:37:26 +0200 (CEST)
Received: from [87.78.231.95] (helo=cc-smtpin2.netcologne.de)
	by localhost with ESMTP (eXpurgate 4.0.2)
	(envelope-from <s.schumacher@netcologne.de>)
	id 535d2436-0b79-7f0000012729-7f000001e99b-1
	for <linux-btrfs@vger.kernel.org>; Sun, 27 Apr 2014 17:37:26 +0200
Received: from mars.solar.net (xdsl-87-78-231-95.netcologne.de [87.78.231.95])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by cc-smtpin2.netcologne.de (Postfix) with ESMTPSA
	for <linux-btrfs@vger.kernel.org>; Sun, 27 Apr 2014 17:37:26 +0200 (CEST)
Date: Sun, 27 Apr 2014 17:37:26 +0200
From: Stefan Malte Schumacher <s.schumacher@netcologne.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Confusing output of btrfs fi df
Message-ID: <20140427153726.GA20596@mars>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello

Chris and Duncan: I tried both your suggestions but unfortunately
without success. Here is the output:

mars:~ # btrfs balance start -susage=0 -f -v /mnt/btrfs/
Dumping filters: flags 0xa, state 0x0, force is on
  SYSTEM (flags 0x2): balancing, usage=0
  Done, had to relocate 0 out of 2708 chunks
  
mars:~ # btrfs fi df /mnt/btrfs/
  Data, RAID1: total=2.64TiB, used=2.22TiB
  System, RAID1: total=8.00MiB, used=380.00KiB
  System, single: total=4.00MiB, used=0.00
  Metadata, RAID1: total=4.00GiB, used=2.94GiB
--------------------------------------------

mars:~ # btrfs balance start -sconvert=raid1,soft -f -v /mnt/btrfs/
Dumping filters: flags 0xa, state 0x0, force is on
  SYSTEM (flags 0x300): converting, target=16, soft is on
  Done, had to relocate 0 out of 2708 chunks

mars:~ # btrfs fi df /mnt/btrfs/
  Data, RAID1: total=2.64TiB, used=2.22TiB
  System, RAID1: total=8.00MiB, used=380.00KiB
  System, single: total=4.00MiB, used=0.00
  Metadata, RAID1: total=4.00GiB, used=2.94GiB

Yours sincerely
Stefan
