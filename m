Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtprelay04.ispgateway.de ([80.67.31.31]:51348 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbcGOS3k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jul 2016 14:29:40 -0400
Received: from p4fce2793.dip0.t-ipconnect.de ([79.206.39.147] helo=[127.0.0.1])
	by smtprelay04.ispgateway.de with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
	(Exim 4.84)
	(envelope-from <hendrik@friedels.name>)
	id 1bO7rl-0005Um-7h
	for linux-btrfs@vger.kernel.org; Fri, 15 Jul 2016 20:29:37 +0200
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Hendrik Friedel <hendrik@friedels.name>
Subject: Status of SMR with BTRFS
Message-ID: <b2b863cf-214a-6774-27a4-c41208a578ff@friedels.name>
Date: Fri, 15 Jul 2016 20:29:28 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I have a 5TB Seagate drive that uses SMR.

I was wondering, if BTRFS is usable with this Harddrive technology. So, 
first I searched the BTRFS wiki -nothing. Then google.

* I found this: https://bbs.archlinux.org/viewtopic.php?id=203696
But this turned out to be an issue not related to BTRFS.

* Then this: 
http://www.snia.org/sites/default/files/SDC15_presentations/smr/ 
HannesReinecke_Strategies_for_running_unmodified_FS_SMR.pdf
   " BTRFS operation matches SMR parameters very closely [...]

      High number of misaligned write accesses ; points to an issue with 
btrfs itself


* Then this: 
http://superuser.com/questions/962257/fastest-linux-filesystem-on-shingled-disks
The BTRFS performance seemed good.


* Finally this: http://www.spinics.net/lists/linux-btrfs/msg48072.html
"So you can get mixed results when trying to use the SMR devices but I'd 
say it will mostly not work.
But, btrfs has all the fundamental features in place, we'd have to make
adjustments to follow the SMR constraints:"
[...]
I have some notes at
https://github.com/kdave/drafts/blob/master/btrfs/smr-mode.txt"


So, now I am wondering, what the state is today. "We" (I am happy to do 
that; but not sure of access rights) should also summarize this in the wiki.
My use-case by the way are back-ups. I am thinking of using some of the 
interesting BTRFS features for this (send/receive, deduplication)

Greetings,
Hendrik


---
Diese E-Mail wurde von Avast Antivirus-Software auf Viren geprüft.
https://www.avast.com/antivirus

