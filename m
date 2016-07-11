Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from okda.pipebreaker.pl ([176.56.236.173]:39506 "EHLO
	okda.pipebreaker.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757969AbcGKH0T (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jul 2016 03:26:19 -0400
Received: from 185-6-29-55-rev.logitus.pl ([185.6.29.55] helo=mother.pipebreaker.pl)
	by okda.pipebreaker.pl with esmtps (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
	(Exim 4.87)
	(envelope-from <tomek@pipebreaker.pl>)
	id 1bMVbb-001v38-F7
	for linux-btrfs@vger.kernel.org; Mon, 11 Jul 2016 09:26:15 +0200
Date: Mon, 11 Jul 2016 09:26:12 +0200
From: Tomasz Torcz <tomek@pipebreaker.pl>
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: add option to run balance as daemon
Message-ID: <20160711072612.GA1417185@mother.pipebreaker.pl>
References: <20160621151659.32157-1-ahferroin7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160621151659.32157-1-ahferroin7@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 21, 2016 at 11:16:59AM -0400, Austin S. Hemmelgarn wrote:
> Currently, balance operations are run synchronously in the foreground.
> This is nice for interactive management, but is kind of crappy when you
> start looking at automation and similar things.
 
  It can be done with simplest systemd unit file:
btrfs-balance@.service:
---
[Unit]
Description=btrfs balance for %I

[Service]
ExecStart=/usr/bin/btrfs balance start %I
ExecStop=/usr/bin/btrfs balance cancel %I
---

  It automates quite nicely and needs no additional code.

-- 
Tomasz Torcz                "Funeral in the morning, IDE hacking
xmpp: zdzichubg@chrome.pl    in the afternoon and evening." - Alan Cox

