Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41755 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751961AbdJSRFC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Oct 2017 13:05:02 -0400
Date: Thu, 19 Oct 2017 19:03:14 +0200
From: David Sterba <dsterba@suse.cz>
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3] btrfs: add a flag to iterate_inodes_from_logical to
 find all extent refs for uncompressed extents
Message-ID: <20171019170314.GN3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170922175847.6071-1-ce3g8jdj@umail.furryterror.org>
 <20170922175847.6071-2-ce3g8jdj@umail.furryterror.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170922175847.6071-2-ce3g8jdj@umail.furryterror.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 22, 2017 at 01:58:45PM -0400, Zygo Blaxell wrote:
> The LOGICAL_INO ioctl provides a backward mapping from extent bytenr and
> offset (encoded as a single logical address) to a list of extent refs.
> LOGICAL_INO complements TREE_SEARCH, which provides the forward mapping
> (extent ref -> extent bytenr and offset, or logical address).  These are
> useful capabilities for programs that manipulate extents and extent
> references from userspace (e.g. dedup and defrag utilities).
> 
> When the extents are uncompressed (and not encrypted and not other),
> check_extent_in_eb performs filtering of the extent refs to remove any
> extent refs which do not contain the same extent offset as the 'logical'
> parameter's extent offset.  This prevents LOGICAL_INO from returning
> references to more than a single block.
> 
> To find the set of extent references to an uncompressed extent from [a,
> b), userspace has to run a loop like this pseudocode:
> 
> 	for (i = a; i < b; ++i)
> 		extent_ref_set += LOGICAL_INO(i);
> 
> At each iteration of the loop (up to 32768 iterations for a 128M extent),
> data we are interested in is collected in the kernel, then deleted by
> the filter in check_extent_in_eb.
> 
> When the extents are compressed (or encrypted or other), the 'logical'
> parameter must be an extent bytenr (the 'a' parameter in the loop).
> No filtering by extent offset is done (or possible?) so the result is
> the complete set of extent refs for the entire extent.  This removes
> the need for the loop, since we get all the extent refs in one call.
> 
> Add an 'ignore_offset' argument to iterate_inodes_from_logical,
> [...several levels of function call graph...], and check_extent_in_eb, so
> that we can disable the extent offset filtering for uncompressed extents.
> This flag can be set by an improved version of the LOGICAL_INO ioctl to
> get either behavior as desired.
> 
> There is no functional change in this patch.  The new flag is always
> false.
> 
> Signed-off-by: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>

Reviewed-by: David Sterba <dsterba@suse.com>
