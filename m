Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:48536 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752798AbeFTO5B (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 10:57:01 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.22/8.16.0.22) with SMTP id w5KEqNrF004747
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Jun 2018 07:57:01 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2jq9w124rn-4
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Jun 2018 07:57:00 -0700
From: Chris Mason <clm@fb.com>
To: <dsterba@suse.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: [PATCH RFC 0/2] Btrfs: fix file data corruptions due to lost dirty bits
Date: Wed, 20 Jun 2018 07:56:10 -0700
Message-ID: <20180620145612.1644763-1-clm@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We've been hunting the root cause of data crc errors here at FB for a while.
We'd find one or two corrupted files, usually displaying crc errors without any
corresponding IO errors from the storage.  The bug was rare enough that we'd
need to watch a large number of machines for a few days just to catch it
happening.

We're still running these patches through testing, but the fixup worker bug
seems to account for the vast majority of crc errors we're seeing in the fleet.
It's cleaning pages that were dirty, and creating a window where they can be
reclaimed before we finish processing the page.

btrfs_file_write() has a similar bug when copy_from_user catches a page fault
and we're writing to a page that was already dirty when file_write started.
This one is much harder to trigger, and I haven't confirmed yet that we're
seeing it in the fleet.

