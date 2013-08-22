Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:39058 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846Ab3HVT2K (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 Aug 2013 15:28:10 -0400
Received: by mail-we0-f174.google.com with SMTP id q54so2125201wes.33
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Aug 2013 12:28:09 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 22 Aug 2013 21:28:09 +0200
Message-ID: <CAJtBfr-ZncC9iOB=GegDXhOsayEXVk6gfu2P2X8PeeOQk3hZ3Q@mail.gmail.com>
Subject: Deduplication
From: Florian Lindner <mailinglists@xgm.de>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

some questions regarding btrfs deduplication.

- What is the state of it? Is it "safe" to use?
https://btrfs.wiki.kernel.org/index.php/Deduplication does not yield
much information.

- https://pypi.python.org/pypi/bedup says: "bedup looks for new and
changed files, making sure that multiple copies of identical files
share space on disk. It integrates deeply with btrfs so that scans are
incremental and low-impact."

Is is file-based deduplcation only or is there also a block-based
mode? Does not seem so according to the docs.

If so, what is the advantage to numerous other tools that replace
duplicates by hard links? Performance?

Thanks,

Florian
