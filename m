Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:58366 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755328Ab3H2TBp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Aug 2013 15:01:45 -0400
Received: from mail.virtall.com (localhost [127.0.0.1])
	by mail.virtall.com (Postfix) with ESMTP id EF211389B5D
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Aug 2013 21:01:41 +0200 (CEST)
Received: from localhost (srv1.virtall.com [78.46.87.16])
	by mail.virtall.com (Postfix) with ESMTPSA id AC19D389A62
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Aug 2013 21:01:40 +0200 (CEST)
Date: Fri, 30 Aug 2013 03:01:32 +0800
From: Tomasz Chmielewski <tch@virtall.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: "btrfs device delete missing" - why does it write on healthy
 device?
Message-ID: <20130830030132.0cfafc94@virtall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So I've removed a missing device, which took some time:

# time btrfs device delete missing /home

real    1512m33.763s
user    0m0.000s
sys     121m37.740s

OK, it needs time, fine.


And shifted quite large amounts of data:

Device:            tps    MB_read/s    MB_wrtn/s    MB_read    MB_wrtn
sda             347.00         0.37        16.24      34050    1512249
sdb             910.89        13.46        18.77    1252768    1747442


New device was sda - so it's expected it wrote quite a lot of data
there.

But why did it write so much on sdb (even more than on sda)? With
software RAID-1, when replacing a failed device, the amount of reads
from one drive is equal to the writes on the other drive; there is no
writing on the healthy drive.


# btrfs filesystem show
Label: 'test-btrfs'  uuid: 60f1759c-45f6-4484-9f60-66a4e9bbf2b6
        Total devices 2 FS bytes used 1.19TB
        devid    3 size 2.56TB used 1.19TB path /dev/sdb4
        devid    4 size 2.56TB used 1.19TB path /dev/sda4

Btrfs v0.20-rc1-324-g650e656



-- 
Tomasz Chmielewski
http://wpkg.org
