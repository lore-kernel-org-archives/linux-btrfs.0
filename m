Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:42731 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892AbbBTUAZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Feb 2015 15:00:25 -0500
Received: by lbiw7 with SMTP id w7so8411738lbi.9
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Feb 2015 12:00:22 -0800 (PST)
MIME-Version: 1.0
From: =?UTF-8?Q?Johan_Kr=C3=B6ckel?= <johan.kroeckel@gmail.com>
Date: Fri, 20 Feb 2015 20:59:42 +0100
Message-ID: <CABgvyo__OdS8N=Gwf-n58FTViyOi5ZWOcchud+Hmt1JfD8pNpw@mail.gmail.com>
Subject: scrub problem
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The scrub is neither cancelable not stoppable. What is the problem?

[root@host ]# btrfs scrub status ./
scrub status for XXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXX
scrub started at Thu Feb 19 12:41:22 2015, running for 16964 seconds
total bytes scrubbed: 1.56TiB with 0 errors
[root@host ]# btrfs scrub cancel ./
ERROR: scrub cancel failed on ./: not running
[root@host ]# btrfs scrub start ./
ERROR: scrub is already running.
To cancel use 'btrfs scrub cancel ./'.
To see the status use 'btrfs scrub status [-d] ./'.
