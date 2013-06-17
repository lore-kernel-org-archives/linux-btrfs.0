Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 110-174-82-20.static.tpgi.com.au ([110.174.82.20]:40033 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750959Ab3FQBHk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Jun 2013 21:07:40 -0400
Received: from athena.localnet (unknown [10.10.10.1])
	by smtp.sws.net.au (Postfix) with ESMTP id 1A1A3C1739
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Jun 2013 11:07:37 +1000 (EST)
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: linux-btrfs@vger.kernel.org
Subject: is this scrub error a concern?
Date: Mon, 17 Jun 2013 11:07:33 +1000
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201306171107.33983.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

scrub device /dev/sda3 (id 1) done
        scrub started at Mon Jun 17 06:00:01 2013 and finished after 781 
seconds
        total bytes scrubbed: 76.31GB with 2 errors
        error details: super=2
        corrected errors: 0, uncorrectable errors: 0, unverified errors: 0

It's on an Intel 120G SSD running the Debian 3.8-trunk-amd64 kernel.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
