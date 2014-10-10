Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56961 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324AbaJJIUY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Oct 2014 04:20:24 -0400
Date: Fri, 10 Oct 2014 10:20:23 +0200
From: David Sterba <dsterba@suse.cz>
To: Eryu Guan <guaneryu@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs-progs: don't report internal dev replace
 result if ioctl failed
Message-ID: <20141010082023.GF22943@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1412761349-32721-1-git-send-email-guaneryu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1412761349-32721-1-git-send-email-guaneryu@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 08, 2014 at 05:42:28PM +0800, Eryu Guan wrote:
> If BTRFS_IOC_DEV_REPLACE ioctl failed, there's no result returned to
> fill args.result, it doesn't make sense to report this internal result
> to user.
> 
> And the arg has been initialized with 0, the result is always 0, which
> is BTRFS_IOCTL_DEV_REPLACE_REPLACE_NO_ERROR, and the resulting error
> message looks confusing too:
> 
> ERROR: ioctl(DEV_REPLACE_START) failed on "/mnt/btrfs": No such file or directory, no error
> 
> So just skip the internal dev replace result if the whole ioctl failed.

The 'no error' is confusing there, but I'm afraid we're losing some
information if the secondary result is completely dropped. How about
intializing the replace result with, eg., -1 and then print an empty
string from replace_dev_result2string instead?
