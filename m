Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:44259 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbcBZCF1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Feb 2016 21:05:27 -0500
Date: Fri, 26 Feb 2016 02:05:19 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Chris Mason <clm@fb.com>, Marc MERLIN <marc@merlins.org>,
        linux-btrfs@vger.kernel.org
Subject: Re: Can you help explain these OOM crashes?
Message-ID: <20160226020519.GZ17997@ZenIV.linux.org.uk>
References: <20160225192029.GF2290@merlins.org>
 <20160225194251.kidqfejwlsai6h5v@floor.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160225194251.kidqfejwlsai6h5v@floor.thefacebook.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 25, 2016 at 02:42:51PM -0500, Chris Mason wrote:
> Al, any ideas why get_anon_bdev is doing an atomic allocation here?
> 
> 	if (ida_pre_get(&unnamed_dev_ida, GFP_ATOMIC) == 0)

Because set() callback of sget() runs under sb_lock - it must be atomic
wrt scanning the list of superblock in search of match.  And get_anon_bdev()
is called from such callbacks...

In principle, we could change locking rules for case when test callback
is NULL, except that it's also called from ns_set_super(), which *does*
come along with non-NULL test() (see mount_ns()), so that really doesn't
help...
