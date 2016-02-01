Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:37834 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556AbcBATpU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Feb 2016 14:45:20 -0500
Received: by mail-ig0-f180.google.com with SMTP id 5so19718920igt.0
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Feb 2016 11:45:20 -0800 (PST)
Received: from [127.0.0.1] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id o62sm2507939ioo.14.2016.02.01.11.45.18
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Mon, 01 Feb 2016 11:45:18 -0800 (PST)
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Subject: Question about a specific error.
Message-ID: <56AFB598.2020307@gmail.com>
Date: Mon, 1 Feb 2016 14:44:24 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In the process of trying to debug issues I'm having on one of my
systems with a new kernel version, I decided to do a dry run check on
the root filesystem.  'btrfs check' returned a bunch of lines like:

root 257 inode XXXXXX errors 2000, link count wrong
        unresolved ref dir YYYYY index 53 namelen 3 name LOG filetype 0 errors 3, no dir item, no dir index

I got about 20 messages like this with varying values for everything
except the filetype and error counts.  Based on what I can tell, these
look like orphaned inodex, but I'm not certain.
Is it safe to tell BTRFS to try and fix these errors?

I'm running btrfs-progs 4.3.1 on kernel 4.3.3 (at least, that's the version that
works right now, I see the same errors on 4.4.1, but I have other issues
there that are (hopefully) unrelated to BtRFS).
