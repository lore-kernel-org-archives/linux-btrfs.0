Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47939 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752601AbcDYOzo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Apr 2016 10:55:44 -0400
Date: Mon, 25 Apr 2016 16:55:32 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Restrict e2fsprogs version for new convert
Message-ID: <20160425145532.GA29353@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1460615074-2492-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20160415111726.GD28775@twin.jikos.cz>
 <57143652.20206@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <57143652.20206@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 18, 2016 at 09:20:18AM +0800, Qu Wenruo wrote:
> 
> 
> David Sterba wrote on 2016/04/15 13:17 +0200:
> > On Thu, Apr 14, 2016 at 02:24:34PM +0800, Qu Wenruo wrote:
> >> New btrfs-convert is using a lot of new macro in e2fsprogs 1.42.
> >> Unfortunately the new compatible layer for older e2fsprogs is still
> >> under development.
> >
> > It hasn't been released yet so it's not really a big problem, although
> > it makes testing on my side a bit harder. The configure-time check
> > should be 1.41 and until it's fixed we can print a warning.
> >
> >
> Did I missed something?
> 
> I checkout 1.41.14 and it shows no cluster support in ext2fs.h.
> 
> Also git describe shows it's v1.41.14-36-g1da5ef7, after the last v1.41 
> version.
> 
> So I think the check should be 1.42, just as the patch.

The idea is to keep lowest supported version 1.41, because this version
can be commonly found on enterprise distros. The lack of cluster is
expected and needs to be dealt with both build- and run-time.
