Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:33398 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755584Ab2FNKNN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jun 2012 06:13:13 -0400
Date: Thu, 14 Jun 2012 12:12:55 +0200
From: David Sterba <dave@jikos.cz>
To: Liu Bo <liubo2009@cn.fujitsu.com>
Cc: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 02/10] Btrfs: fix missing inherited flag in rename
Message-ID: <20120614101255.GN32402@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1339662206-5307-1-git-send-email-liubo2009@cn.fujitsu.com>
 <1339662206-5307-3-git-send-email-liubo2009@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1339662206-5307-3-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 14, 2012 at 04:23:18PM +0800, Liu Bo wrote:
> When we move a file into a directory with compression flag, we need to
> inherite BTRFS_INODE_COMPRESS and clear BTRFS_INODE_NOCOMPRESS as well.

Right.

> But if we move a file into a directory without compression flag, we need
> to clear both of them.

Right. And now thinking about it, the _NOCOMPRESS should be honored as
well, not dropped.

The expected use here is to set a NOCOMP flag on the directory and let
it inherit for all newly created files/dirs

> It is the way how our setflags deals with compression flag, so keep
> the same behaviour here.

Yeah, keep it the same :)

Priority of all the compression flags may not be clear, the NOCOMPRESS
has precedence over COMPRESS, as it attempts to avoid pointless
file compression. Both per-file flags are preferred over compression
mount option.


david
