Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:49971 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754596Ab3KUQxW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Nov 2013 11:53:22 -0500
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 57A6C9A06AE
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Nov 2013 09:53:22 -0700 (MST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: David Sterba <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
From: Chris Mason <chris.mason@fusionio.com>
In-Reply-To: <1385052483-30220-1-git-send-email-dsterba@suse.cz>
CC: David Sterba <dsterba@suse.cz>, <linux-doc@vger.kernel.org>
References: <1384956351-18832-1-git-send-email-dsterba@suse.cz>
 <1385052483-30220-1-git-send-email-dsterba@suse.cz>
Message-ID: <20131121165306.5312.230@localhost.localdomain>
Subject: Re: [PATCH 1/2 v2] Documentation: filesystems: add new btrfs mount options
Date: Thu, 21 Nov 2013 11:53:06 -0500
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting David Sterba (2013-11-21 11:48:03)
> Two new options were added in 3.12: commit and rescan_uuid_tree
> 
> CC: linux-doc@vger.kernel.org
> Signed-off-by: David Sterba <dsterba@suse.cz>
> ---
> v2: fix typo pointed out by Stefan

You just caught me before the pull request.  V1 was already in
for-linus, so I rebased this one in.

-chris
