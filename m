Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f175.google.com ([209.85.220.175]:33931 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754663AbaG3DyV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jul 2014 23:54:21 -0400
MIME-Version: 1.0
Date: Tue, 29 Jul 2014 23:54:20 -0400
Message-ID: <CAPDOMVjJHbCwDVyKQ+Vuse7G76FLSLq69Ja4kmopDbjtEb_Zkw@mail.gmail.com>
Subject: Work Queue for btrfs compression writes
From: Nick Krause <xerofoify@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org SYSTEM list:BTRFS FILE"
	<linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey Guys ,
I am new to   reading  and writing  kernel code.I got interested in
writing code for btrfs as it seems to
need more work then other file systems and this seems other then
drivers, a good use of time on my part.
I interested in helping improving the compression of btrfs by using  a
set of threads using work queues like XFS
or reads and keeping the page cache after reading compressed blocks as
these seem to be a great way to improve
on  compression performance mostly with large partitions of compressed
data. I am not asking you to write the code
for me but as I am new a little guidance and help would be greatly
appreciated as this seems like too much work for just a newbie.
Thanks A lot,
Nick
