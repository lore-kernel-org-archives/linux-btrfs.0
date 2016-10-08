Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:36472 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751297AbcJHSaP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 8 Oct 2016 14:30:15 -0400
Date: Sat, 8 Oct 2016 19:29:03 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Jones <davej@codemonkey.org.uk>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: btrfs_direct_IO oops
Message-ID: <20161008182903.GU19539@ZenIV.linux.org.uk>
References: <20161008180806.fmpwtw4vcc7lzd36@codemonkey.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161008180806.fmpwtw4vcc7lzd36@codemonkey.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Oct 08, 2016 at 02:08:06PM -0400, Dave Jones wrote:
> That code: matches this dissembly:
> 
>                 for (i = seg + 1; i < iter->nr_segs; i++) {

*whoa*

OK, that loop in check_direct_IO() should be done *ONLY* for
iovec iter - even for a bvec one it's completely bogus, and
for pipe ones it blows up immediately.

Sorry, I'd missed that bogosity - replace
        if (iov_iter_rw(iter) == WRITE)
		return 0;
with
	if (iov_iter_rw(iter) != READ || !iter_is_iovec(iter))
		return 0;
in there; that should fix the damn thing.
