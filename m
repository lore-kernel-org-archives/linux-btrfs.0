Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:53490 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746Ab3DMO37 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Apr 2013 10:29:59 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 52CF09A036D
	for <linux-btrfs@vger.kernel.org>; Sat, 13 Apr 2013 08:29:59 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
From: Chris Mason <clmason@fusionio.com>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <1365859195-8620-1-git-send-email-list.btrfs@jan-o-sch.net>
In-Reply-To: <1365859195-8620-1-git-send-email-list.btrfs@jan-o-sch.net>
Message-ID: <20130413142957.12886.54006@localhost.localdomain>
Subject: Re: [PATCH 0/3] Btrfs: patches for tree mod log for next rc
Date: Sat, 13 Apr 2013 10:29:57 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Jan Schmidt (2013-04-13 09:19:52)
> These three fixes for the tree mod log should go into the next rc pull
> request to mainline. I suggest adding them to stable as well, as we did
> with the previous tree mod log patch.

This is pretty big, since the next rc (or final) could be any hour now.
But I'll pull these in locally and bang on them.  If Linus does one more
rc, I'll get it into -final.

Thanks for tracking this down.

-chris
