Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:34836 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964799AbcBQBmC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Feb 2016 20:42:02 -0500
Received: by mail-ig0-f172.google.com with SMTP id hb3so88613449igb.0
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Feb 2016 17:42:01 -0800 (PST)
Received: from gmail.com (blk-11-122-84.eastlink.ca. [76.11.122.84])
        by smtp.gmail.com with ESMTPSA id v68sm338857ioi.23.2016.02.16.17.42.00
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 16 Feb 2016 17:42:00 -0800 (PST)
Date: Tue, 16 Feb 2016 21:41:58 -0400
From: Kenny MacDermid <kenny.macdermid@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Send receive errors
Message-ID: <20160217014156.GA6892@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I use snapshots as backups, and send them to other locations with a
parent. It's very hit or miss if any one of them will actual work.

An example of the latest error:

ERROR: rmdir usr/lib/modules/4.3.3.201512282134-1-grsec/build/.tmp_versions failed: No such file or directory

Typically using an earlier snapshot as the parent will work.

Does anyone have any tips on how to make them more reliable?
