Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:43027 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797Ab3JTO56 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Oct 2013 10:57:58 -0400
Date: Sun, 20 Oct 2013 23:51:18 +0900
From: Tomasz Chmielewski <tch@virtall.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        jgoerzen@complete.org
Subject: Re: Lots of trouble hanging when rm files with many extents
Message-ID: <20131020235118.3a918ba3@virtall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> but I am not sure if that was the right thing to do.  This is
> producing OOM issues and leading to system crashes (including
> eventual panics) with such alarming frequency that I wonder if
> perhaps there is something different about my setup than others.

FYI, I'm seeing similar / random hangs on systems with btrfs,
compress-force=zlib, qgroups enabled. The systems have 32 GB RAM.
Sometimes, I can review old logs (after force reboot) and see OOM,
allocation failures and such.

The scenario there are snapshots, rsync with --inplace flag, which can
fragment files a lot.

I'll do some more tests with lots of extents to see if it's
reproducible here as well.


-- 
Tomasz Chmielewski
http://wpkg.org
