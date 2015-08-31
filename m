Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56268 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753735AbbHaSLc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 31 Aug 2015 14:11:32 -0400
Date: Mon, 31 Aug 2015 14:11:27 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, chandan@mykolab.com
Subject: Re: [PATCH] generic/224: Increase filesystem instance size to 1.5 GiB
Message-ID: <20150831181127.GB7642@thunk.org>
References: <1440945981-323-1-git-send-email-chandan@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1440945981-323-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Aug 30, 2015 at 08:16:21PM +0530, Chandan Rajendra wrote:
> For small filesystem instances (i.e. size <= 1 GiB), mkfs.btrfs fails when
> "data block size" does not match with the "metadata block size" specified on
> the mkfs.btrfs command line. This commit increases the size of filesystem
> instance created so that the test can be executed on subpagesize-blocksize
> Btrfs instances which have different values for data and metadata blocksizes.

Stupid question --- why isn't this considered a bug in mkfs.btrfs?
Does btrfs simply not support file systems <= 1 GB?  So if someone has
a 1GB USB disk or SD card, what's the official advice from the btrfs
developers?  Use xfs or ext4?

							- Ted
