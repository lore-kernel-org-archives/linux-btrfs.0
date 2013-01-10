Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34189 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753089Ab3AJLE7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Jan 2013 06:04:59 -0500
Date: Thu, 10 Jan 2013 12:04:58 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix off-by-one in lseek
Message-ID: <20130110110458.GA20089@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1357530788-5790-1-git-send-email-bo.li.liu@oracle.com>
 <20130107162050.GJ20089@twin.jikos.cz>
 <20130108024637.GA1916@liubo>
 <20130108083053.GD3763@twin.jikos.cz>
 <20130108172627.GP20089@twin.jikos.cz>
 <20130109043443.GA4527@liubo>
 <20130109115025.GQ20089@twin.jikos.cz>
 <20130110021747.GB4456@liubo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130110021747.GB4456@liubo>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 10, 2013 at 10:17:49AM +0800, Liu Bo wrote:
> Thanks for the report, could you please show me what options you're
> using?

Default mkfs, mount options 'space_cache,noatime', 40G test partition,
10G scratch partition (ie. the same seatup as usual).

I see the free_fs_root warning only 3 times in the whole serial console
log, the first matches the first run and report, the two other are from
a repeated run of xfstests (I don't know which options were on during
the third, but can let it run again if needed).

This strongly suggests that the warning is connected to the fixes.

david
