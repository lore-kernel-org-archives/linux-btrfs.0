Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:41900 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754644Ab3KESqe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Nov 2013 13:46:34 -0500
Date: Wed, 6 Nov 2013 03:46:22 +0900
From: Tomasz Chmielewski <tch@virtall.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        jgoerzen@complete.org
Subject: Re: umount waiting for 12 hours and still running
Message-ID: <20131106034622.5209f127@virtall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> More than 12 hours ago, I tried to umount a btrfs filesystem.
> Something involving btrfs-cleaner and btrfs-transacti is still
> running, but I don't know what.

Does "iostat -x 1" or "iostat -k 1" show any disk activity?

Anything interesting in dmesg?


-- 
Tomasz Chmielewski
http://wpkg.org
