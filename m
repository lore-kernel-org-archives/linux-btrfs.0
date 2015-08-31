Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56636 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752033AbbHaVJf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 31 Aug 2015 17:09:35 -0400
Date: Mon, 31 Aug 2015 17:09:27 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, fstests@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        chandan@mykolab.com
Subject: Re: [PATCH] generic/224: Increase filesystem instance size to 1.5 GiB
Message-ID: <20150831210927.GD27040@thunk.org>
References: <1440945981-323-1-git-send-email-chandan@linux.vnet.ibm.com>
 <20150831181127.GB7642@thunk.org>
 <55E4A8BA.2050908@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55E4A8BA.2050908@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 31, 2015 at 03:19:22PM -0400, Austin S Hemmelgarn wrote:
> AFAIK, it shouldn't be failing that way, and should automatically switch to
> mixed mode allocation.  A 1G filesystem should work fine for BTRFS, but
> smaller ones will have higher chances of ENOSPC issues (inversely
> proportional to the size of the FS).  I would advise against using BTRFS on
> such a small disk (I avoid using it on anything smaller than 4G personally),
> but I'm not one of the developers, and the fact that I feel it isn't a good
> idea doesn't mean it shouldn't work.

Instead of modifying generic/224, maybe it would be better to have a
way to specify a minimum file system size on a per-file system basis.
That way, if some file system does have a minimum size of say, 1G or
4G, it can be configured in one place, instead of needing to modify
every test that uses a small file system size, or forcing all file
systems to use a larger file systems just for the benefit of a single
file system?

Or maybe just fix mkfs.btrfs?

						- Ted
