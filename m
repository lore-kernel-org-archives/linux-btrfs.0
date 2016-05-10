Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43459 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753108AbcEJBwO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 May 2016 21:52:14 -0400
Date: Mon, 9 May 2016 18:52:11 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: David Sterba <dsterba@suse.com>, btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Idea on compatibility for old distributions
Message-ID: <20160510015211.GC7633@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <d527a25c-c1f5-1329-1ed7-c84229a50251@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <d527a25c-c1f5-1329-1ed7-c84229a50251@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 10, 2016 at 09:16:04AM +0800, Qu Wenruo wrote:
> In the recent test for new btrfs-convert backward compatibility, I
> found that cmds-fi-du.c uses FIEMAP_EXTENT_SHARED bits, which is not
> present in kernel of old distributions like RHEL6 (Sorry, didn't
> test on openSUSE equivalent).
> 
> Unlike e2fsprogs, we can check its version with pkgconfig, any idea
> to avoid such compiling error?

#ifndef FIEMAP_EXTENT_SHARED
#define FIEMAP_EXTENT_SHARED           0x00002000
#endif

This is what I do in duperemove. Many distributions dind't update their
kernel header packages for that bit so even though it's in the kernel
userspace programs using it won't compile.


> And further more, without kernel support for FIEMAP_EXTENT_SHARED,
> will fi-du work anymore?

RHEL6 says they're using 2.6.32 which is just before the introduction of
SHARED. It couild be that they have it though considering there is an
immense number of backports done for distro kernels. I would honestly check
the source. What we're really looking to see is what version of btrfs they
have.

With the above patch we would compile and run everywhere. If someone runs an
obsolete version of btrfs then fi du won't report any shared extents. This
is unfortunate but so is running btrfs from 2.6.32.
	--Mark

--
Mark Fasheh
