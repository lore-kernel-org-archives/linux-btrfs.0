Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35138 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628Ab3AJNhg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Jan 2013 08:37:36 -0500
Date: Thu, 10 Jan 2013 21:34:37 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix off-by-one in lseek
Message-ID: <20130110133436.GB3616@liubo>
Reply-To: bo.li.liu@oracle.com
References: <1357530788-5790-1-git-send-email-bo.li.liu@oracle.com>
 <20130107162050.GJ20089@twin.jikos.cz>
 <20130108024637.GA1916@liubo>
 <20130108083053.GD3763@twin.jikos.cz>
 <20130108172627.GP20089@twin.jikos.cz>
 <20130109043443.GA4527@liubo>
 <20130109115025.GQ20089@twin.jikos.cz>
 <20130110021747.GB4456@liubo>
 <20130110110458.GA20089@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130110110458.GA20089@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 10, 2013 at 12:04:58PM +0100, David Sterba wrote:
> On Thu, Jan 10, 2013 at 10:17:49AM +0800, Liu Bo wrote:
> > Thanks for the report, could you please show me what options you're
> > using?
> 
> Default mkfs, mount options 'space_cache,noatime', 40G test partition,
> 10G scratch partition (ie. the same seatup as usual).
> 
> I see the free_fs_root warning only 3 times in the whole serial console
> log, the first matches the first run and report, the two other are from
> a repeated run of xfstests (I don't know which options were on during
> the third, but can let it run again if needed).
> 
> This strongly suggests that the warning is connected to the fixes.

Seems that I'm not able to reproduce the warning in running 013,
maybe you can revert the two fixes and see if it still warns?

I don't think the fixes has anything done with the warning...

thanks,
liubo
