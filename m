Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from postfix.iai.uni-bonn.de ([131.220.8.4]:54359 "EHLO
	postfix.iai.uni-bonn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252AbaGOVZT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Jul 2014 17:25:19 -0400
Received: from [192.168.0.62] (p5B0A154B.dip0.t-ipconnect.de [91.10.21.75])
	by postfix.iai.uni-bonn.de (Postfix) with ESMTP id 530605C44E
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Jul 2014 23:17:27 +0200 (MEST)
	(envelope-from ochmann@informatik.uni-bonn.de)
	(envelope-to linux-btrfs@vger.kernel.org) (1)
	(internal use: ta=1, tu=1, te=1, am=P, au=ochmann)
Message-ID: <53C59A66.7010107@informatik.uni-bonn.de>
Date: Tue, 15 Jul 2014 23:17:26 +0200
From: Sebastian Ochmann <ochmann@informatik.uni-bonn.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Why does btrfs defrag work worse than making a copy of a file?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I have a VirtualBox hard drive image which is quite fragmented even 
after very light use; it is 1.6 GB in size and has around 5000 fragments 
(I'm using "filefrag" to determine the number of fragments). Doing a 
"btrfs fi defrag -f image.vdi" reduced the number of fragments to 3749. 
Even doing a "btrfs fi defrag -f -t 1 image.vdi" which should make sure 
every extent is rewritten (according to the btrfs-progs 3.14.2 manpage) 
does not yield any better result and seems to return immediately. 
Copying the file, however, yields a copy which has only 5 fragments 
(simply doing a cp image.vdi image2.vdi; sync; filefrag image2.vdi).

What do I have to do to defrag the file to the minimal number of 
fragments possible? Am I missing something?

Kernel version 3.15.5, btrfs progs 3.14.2, Arch Linux.

Best regards,
Sebastian
