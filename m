Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33439 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933291AbaDIReZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Apr 2014 13:34:25 -0400
From: David Disseldorp <ddiss@suse.de>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix a crash of clone with inline extents's split
Date: Wed,  9 Apr 2014 19:42:50 +0200
Message-Id: <1397065371-22085-1-git-send-email-ddiss@suse.de>
In-Reply-To: <1394448967-14128-1-git-send-email-bo.li.liu@oracle.com>
References: <1394448967-14128-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for the BUG_ON() fix here.
Strangely, I'm now seeing EIO returned for reads following the second
clone-range.

Please see the subsequent xfstests patch.

Cheers, David
