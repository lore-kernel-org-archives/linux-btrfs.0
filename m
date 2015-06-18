Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42308 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939AbbFRVKK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Jun 2015 17:10:10 -0400
From: Mark Fasheh <mfasheh@suse.de>
To: Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs: two more dedupe fixes
Date: Thu, 18 Jun 2015 14:10:01 -0700
Message-Id: <1434661803-31188-1-git-send-email-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

   The following fixes are based on top of my patch titled "btrfs:
Handle unaligned length in extent_same" which you have in your
'integration-4.2' branch:

https://git.kernel.org/cgit/linux/kernel/git/mason/linux-btrfs.git/commit/?id=e1d227a42ea2b4664f94212bd1106b9a3413ffb8

The first patch in the series fixes a bug where we were sometimes
passing the aligned length to our comparison function. We actually can
stop at the user passed length for this as we don't need to compare
data past i_size (and we only align if the extents go out to i_size).

The 2nd patch fixes a deadlock between btrfs readpage and
btrfs_extent_same. This was reported on the list some months ago -
basically we had the page and extent locking reversed. My patch fixes
up the locking to be in the right order.

Thanks,
   --Mark
