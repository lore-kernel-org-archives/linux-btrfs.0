Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45046 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795AbaL0PgX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Dec 2014 10:36:23 -0500
Date: Sat, 27 Dec 2014 16:36:21 +0100
From: Petr Janecek <janecek@ucw.cz>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: russell@coker.com.au, linux-btrfs@vger.kernel.org,
        Timofey Titovets <nefelim4ag@gmail.com>
Subject: Re: Debian/Jessie 3.16.7-ckt2-1 kernel error
Message-ID: <20141227153621.GB19957@atrey.karlin.mff.cuni.cz>
References: <201412241202.59568.russell@coker.com.au>
 <549A8B9B.5000005@jp.fujitsu.com>
 <549B5D4C.1070804@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <549B5D4C.1070804@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Satoru and all,

  that Oct. report was the only time I've experienced the error, so I
don't have much to add. I can try to answer your questions:

> >Here are my questions.
> >
> >1. Is your system "btrfs scrub" clean?

  yes,

> >2. Is this message shown every boot time?

  no, I have seen them only during one boot

> >3. Is this message shown only in boot?

  As in my Oct. email
http://permalink.gmane.org/gmane.comp.file-systems.btrfs/39721
I've seen a similar one after creating a subvolume on a new fs.
But it was during the same boot.

> >4. When this message is started to be shown?
> >5. Do you have any trouble, change your operation or configuration
> >    just before the answer of Q4 ?

  a disk was added to the fs and balance has been run. The balance
crashed, as in https://bugzilla.kernel.org/show_bug.cgi?id=64961
(probably unrelated).  After reboot, I've seen the messages.
 
> Additional questions.
> Q5. Could you give me your kernel configuration?
>     At least, could you tell me whether your kernel
>     enabled CONFIG_PREEMPT or not?

  CONFIG_PREEMPT_VOLUNTARY=y
 
> Q6. If the answer of Q1 is correct, please give me the
>     file system image which can be captured by the following command.

  Sorry, the fs's are long gone. I continued to run similar workloads on
that test box, but these errors never appeared again.


Regards,

Petr
