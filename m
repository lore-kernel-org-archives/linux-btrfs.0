Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:33251 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755539Ab2FNKEM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jun 2012 06:04:12 -0400
Date: Thu, 14 Jun 2012 12:03:56 +0200
From: David Sterba <dave@jikos.cz>
To: Liu Bo <liubo2009@cn.fujitsu.com>
Cc: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 01/10] Btrfs: remove unused FS_NOCOMP_FL check in
 setflags and getflags
Message-ID: <20120614100356.GM32402@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1339662206-5307-1-git-send-email-liubo2009@cn.fujitsu.com>
 <1339662206-5307-2-git-send-email-liubo2009@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1339662206-5307-2-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 14, 2012 at 04:23:17PM +0800, Liu Bo wrote:
> chattr only uses FS_COMPR_FL to switch on/off the compression flag,
> so we don't need these FS_NOCOMP_FL checks.

Please drop this patch. The FS_NOCOMP_FL has a different meaning, it
forces the filesystem to completely avoid compression of the file.

FS_COMPR_FL tells the fs to compress the file, even if the filesystem is
not mounted with compression.

And none of the two flags means 'let the fs pick according to current
defaults', ie when the fs is moutned with compression (or not).

As a user, I have a fine grained control over the per-file compression
status.

We need to chattr/lsattr to support the existing NOCOMP flag, I'd like
to see a letter 'Z' assigned for it, but it's currently occupied by

{ FS_DIRTY_FL, 'Z', "Compressed_Dirty_File" }

(though I'm not sure if the compression-related flags are actually used
at all around the extN filesystems). Maybe 'z' is a good choice here as
well, I don't mind.


david
