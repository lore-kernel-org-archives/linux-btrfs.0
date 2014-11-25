Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:40074 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbaKYLZY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Nov 2014 06:25:24 -0500
Received: from babycakes.localnet (localhost [127.0.0.1])
	by smtp.sws.net.au (Postfix) with ESMTP id 7498920964
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Nov 2014 22:25:21 +1100 (EST)
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: linux-btrfs@vger.kernel.org
Subject: strange device stats message
Date: Tue, 25 Nov 2014 22:25:19 +1100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201411252225.19548.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I am in the middle of replacing /dev/sdb (which is 3TB SATA disk that gives a 
few read errors on every scrub) with /dev/sdc2 (a partition on a new 4TB SATA 
disk).  I am running btrfs-tools version 3.17-1.1 from Debian/Unstable and 
Debian kernel 3.16.0-4-amd64.  I get the following, the last section of which 
seems wrong.  Would this be a bug in the kernel or btrfs-tools?

# btrfs device stats /big
[/dev/sdc2].write_io_errs   0
[/dev/sdc2].read_io_errs    0
[/dev/sdc2].flush_io_errs   0
[/dev/sdc2].corruption_errs 0
[/dev/sdc2].generation_errs 0
[/dev/sdb].write_io_errs   0
[/dev/sdb].read_io_errs    16
[/dev/sdb].flush_io_errs   0
[/dev/sdb].corruption_errs 0
[/dev/sdb].generation_errs 0
[/dev/sdd].write_io_errs   0
[/dev/sdd].read_io_errs    0
[/dev/sdd].flush_io_errs   0
[/dev/sdd].corruption_errs 0
[/dev/sdd].generation_errs 0
[].write_io_errs   0
[].read_io_errs    0
[].flush_io_errs   0
[].corruption_errs 0
[].generation_errs 0

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
