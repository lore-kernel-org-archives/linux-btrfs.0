Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tetsuo.zabbo.net ([50.193.208.193]:38017 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258Ab3A1Sw1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Jan 2013 13:52:27 -0500
Date: Mon, 28 Jan 2013 10:52:26 -0800
From: Zach Brown <zab@zabbo.net>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: do not merge logged extents if we've removed them
 from the tree
Message-ID: <20130128185226.GM14246@lenny.home.zabbo.net>
References: <1359384776-2107-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1359384776-2107-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> problem is we unconditionally try to merge it back into the em tree, but if
> we've removed it from the em tree that will cause problems.  So fix this by

What problems?  If I were staring at the symptoms of this bug how would
I find that this commit fixes it?

- z
