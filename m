Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:36280 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753091Ab3LRMhl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Dec 2013 07:37:41 -0500
Received: from mail.virtall.com (localhost [127.0.0.1])
	by mail.virtall.com (Postfix) with ESMTP id 2D8BB3A737F
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Dec 2013 13:37:37 +0100 (CET)
Received: from localhost (em1-115-194-166.pool.e-mobile.ne.jp [1.115.194.166])
	by mail.virtall.com (Postfix) with ESMTPSA id 7F36A3A7330
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Dec 2013 13:37:36 +0100 (CET)
Date: Wed, 18 Dec 2013 21:37:28 +0900
From: Tomasz Chmielewski <tch@virtall.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: no space left, metadata usage almost full?
Message-ID: <20131218213728.07d47dd5@virtall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have a btrfs filesystem which has plenty of free space left, yet it's
hitting out of space regularly.

Here is how it looks like:

# btrfs fi df /home
Data, RAID1: total=2.51TiB, used=1.58TiB
System, RAID1: total=32.00MiB, used=372.00KiB
Metadata, RAID1: total=48.00GiB, used=47.23GiB


What I read from it, is we're almost full on metadata usage, and that
might be causing out of space issues.

Reading past posts on this group, I can see it's recommended to run
this if I hit out of space and the fs is low on metadata space:

# btrfs fi balance start -dusage=5 /home

Is it really the only workaround? Shouldn't the filesystem be more
intelligent and be able to grab some more metadata space if it's
running low?

I'd appreciate some clarifications on this (FYI, it was running
3.11.4, upgraded to the latest rc now).


-- 
Tomasz Chmielewski
http://wpkg.org
