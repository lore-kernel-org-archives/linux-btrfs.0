Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:41037 "EHLO mail.ewheeler.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751234AbcGOXVe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jul 2016 19:21:34 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.ewheeler.net (Postfix) with ESMTP id BFCB2A0C3F
	for <linux-btrfs@vger.kernel.org>; Fri, 15 Jul 2016 16:21:33 -0700 (PDT)
Received: from mail.ewheeler.net ([127.0.0.1])
	by localhost (mail.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id VJaUBSTNSRIh for <linux-btrfs@vger.kernel.org>;
	Fri, 15 Jul 2016 16:21:33 -0700 (PDT)
Received: from mx.ewheeler.net (mx.ewheeler.net [66.155.3.69])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.ewheeler.net (Postfix) with ESMTPSA id 5C2FDA0C3E
	for <linux-btrfs@vger.kernel.org>; Fri, 15 Jul 2016 16:21:33 -0700 (PDT)
Date: Fri, 15 Jul 2016 16:21:31 -0700 (PDT)
From: Eric Wheeler <btrfs@lists.ewheeler.net>
To: linux-btrfs@vger.kernel.org
Subject: How can I get blockdev offsets of btrfs chunks for a file?
Message-ID: <alpine.LRH.2.11.1607151621220.20548@mail.ewheeler.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello all,

We do btrfs subvolume snapshots over time for backups.  I would like to 
traverse the files in the subvolumes and find the total unique chunk count 
to calculate total space for a set of subvolumes.

This sounds kind of like the beginning of what a deduplicator would do, 
but I just want to count the blocks, so no submission for deduplication.  
I started looking at bedup and other deduplicator code, but the answer to 
this question wasn't obvious (to me, anyway).

Questions:

Is there an ioctl (or some other way) to get the block device offset for a 
file (or file offset) so I can count the unique occurances?

What API documentation should I review?

Can you point me at the ioctl(s) that would handle this?


Thank you for your help!


--
Eric Wheeler
