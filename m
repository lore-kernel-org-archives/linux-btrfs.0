Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail1.trendhosting.net ([195.8.117.5]:40610 "EHLO
        mail1.trendhosting.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751505AbdK0IOw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Nov 2017 03:14:52 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail1.trendhosting.net (Postfix) with ESMTP id 28B9D150B0
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Nov 2017 08:05:42 +0000 (GMT)
Received: from mail1.trendhosting.net ([127.0.0.1])
        by localhost (thp003.trendhosting.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id TCdOKReKgMc1 for <linux-btrfs@vger.kernel.org>;
        Mon, 27 Nov 2017 08:05:40 +0000 (GMT)
From: Daniel Pocock <daniel@pocock.pro>
Subject: FAQ / encryption / error handling?
To: linux-btrfs@vger.kernel.org
Message-ID: <fda951f3-0617-1ad9-8a23-0733628f0215@pocock.pro>
Date: Mon, 27 Nov 2017 09:06:12 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi all,

The FAQ has a couple of sections on encryption (general and dm-crypt)

One thing that isn't explained there: if you create multiple encrypted
volumes (e.g. using dm-crypt) and use Btrfs to combine them into RAID1,
how does error recovery work when a read operation returns corrupted data?

Without encryption, reading from one disk would give a checksum mismatch
and Btrfs would read from the other disk to (hopefully) get a good copy
of the data.

With this encryption scenario, the failure would potentially be detected
in the decryption layer code and instead of returning bad data to Btrfs,
it would return some error code.  In that case, will Btrfs attempt to
read from the other volume and allow the application to proceed as if
nothing was wrong?

Regards,

Daniel

