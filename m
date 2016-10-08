Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from arcturus.aphlor.org ([188.246.204.175]:50220 "EHLO
        arcturus.aphlor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751888AbcJHXUP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 8 Oct 2016 19:20:15 -0400
Date: Sat, 8 Oct 2016 19:20:08 -0400
From: Dave Jones <davej@codemonkey.org.uk>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: btrfs_direct_IO oops
Message-ID: <20161008232008.nouzkd54kiquvpir@codemonkey.org.uk>
References: <20161008180806.fmpwtw4vcc7lzd36@codemonkey.org.uk>
 <20161008182903.GU19539@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161008182903.GU19539@ZenIV.linux.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Oct 08, 2016 at 07:29:03PM +0100, Al Viro wrote:
 > On Sat, Oct 08, 2016 at 02:08:06PM -0400, Dave Jones wrote:
 > > That code: matches this dissembly:
 > > 
 > >                 for (i = seg + 1; i < iter->nr_segs; i++) {
 > 
 > *whoa*
 > 
 > OK, that loop in check_direct_IO() should be done *ONLY* for
 > iovec iter - even for a bvec one it's completely bogus, and
 > for pipe ones it blows up immediately.
 > 
 > Sorry, I'd missed that bogosity - replace
 >         if (iov_iter_rw(iter) == WRITE)
 > 		return 0;
 > with
 > 	if (iov_iter_rw(iter) != READ || !iter_is_iovec(iter))
 > 		return 0;
 > in there; that should fix the damn thing.

Yep, seems to do the trick. Have been running the last six hours
without seeing it or anything similar since.

	Dave
