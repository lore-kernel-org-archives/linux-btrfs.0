Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36768 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752310AbaI2Pzw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Sep 2014 11:55:52 -0400
Date: Mon, 29 Sep 2014 17:55:50 +0200
From: David Sterba <dsterba@suse.cz>
To: Chris Mason <clm@fb.com>
Cc: rongqing.li@windriver.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix a overflowing boundary writing in
 csum_tree_block
Message-ID: <20140929155550.GB11436@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1410254376-6357-1-git-send-email-rongqing.li@windriver.com>
 <5411AB68.7020506@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5411AB68.7020506@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 11, 2014 at 10:02:16AM -0400, Chris Mason wrote:
> On 09/09/2014 05:19 AM, rongqing.li@windriver.com wrote:
> > From: Li RongQing <roy.qing.li@gmail.com>
> > 
> > It is impossible that csum_size is larger than sizeof(long), but the codes
> > still add the handler for this condition, like allocate new memory, for
> > extension. If it becomes true someday, copying csum_size size memory to local
> > 32bit variable found and val will overflow these two variables.
> > 
> > Fix it by returning the max 4 byte checksum.
> 
> Thanks for the patch.  I'd rather not silently truncate the copy down
> though.  How about a one time check at mount to make sure the value in
> the super is reasonable?

The check is already there, see btrfs_check_super_csum(), it validates
the csum_type that's later used to find the checksum size.
