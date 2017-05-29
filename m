Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33820 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750987AbdE2Po3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 May 2017 11:44:29 -0400
Date: Mon, 29 May 2017 17:43:29 +0200
From: David Sterba <dsterba@suse.cz>
To: Su Yue <suy.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs: check namelen before read/memcmp_extent_buffer
Message-ID: <20170529154329.GO14523@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170525020908.25830-1-suy.fnst@cn.fujitsu.com>
 <20170525020908.25830-3-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170525020908.25830-3-suy.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch adds the name length verification to many places and in some
of them it looks unnecessary, as the directory item passes sanity checks
already. The verification should always happen when we read the input,
ie from disk, after search_slot etc. Then, it can be considered valid
and does not need the strict checks.

I haven't gone through all, one example is __add_inode_ref. The caller
add_inode_ref uses namelen before it reaches __add_inode_ref (and thus
the sanity checks).

As the checks add error hanlind branch, the entire callgraph of the
function should be verified, so I suggest to split the patch and group
only hunks that touch the same codepaths.
