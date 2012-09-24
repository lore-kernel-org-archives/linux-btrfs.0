Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:18371 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757890Ab2IXTnL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Sep 2012 15:43:11 -0400
Received: from 100.111.77.188.dynamic.jazztel.es ([188.77.111.100] helo=mail.viric.name)
	by mho-01-ewr.mailhop.org with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.72)
	(envelope-from <viric@viric.name>)
	id 1TGEYe-000H7u-78
	for linux-btrfs@vger.kernel.org; Mon, 24 Sep 2012 19:43:08 +0000
Date: Mon, 24 Sep 2012 21:43:03 +0200
From: =?iso-8859-1?Q?Llu=EDs?= Batlle i Rossell <viric@viric.name>
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: Resize, off by 1024 bytes
Message-ID: <20120924194303.GA1972@vicerveza.homeunix.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I wanted to resize my filesystem to 512MiB less. I had created the btrfs
after I had set the partitions some days ago, and it was like this:
# cat /sys/class/block/sda1/size
234436482

Getting in bytes:
234436482*512 = 120031478784

I run:
# btrfs fi resize -512m /

And I see in dmesg:
btrfs: new size for /dev/sda1 is 119494606848

But that's not the previous size - 512MiB. It is:
120031478784 - 119494606848 = 536871936 = 512*1024*1024 + 1024

So, there is an 'off by +1024'. I shrinked the partition to +1024 bytes bigger
than would be by subtracting 512MiB, just in case.

What is that off by 1024?

This is 3.5.4.

Regards,
Lluís.
