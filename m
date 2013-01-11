Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44221 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753999Ab3AKRtM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Jan 2013 12:49:12 -0500
Date: Fri, 11 Jan 2013 18:49:09 +0100
From: David Sterba <dsterba@suse.cz>
To: David Sterba <dsterba@suse.cz>
Cc: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix off-by-one in lseek
Message-ID: <20130111174909.GN20089@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20130107162050.GJ20089@twin.jikos.cz>
 <20130108024637.GA1916@liubo>
 <20130108083053.GD3763@twin.jikos.cz>
 <20130108172627.GP20089@twin.jikos.cz>
 <20130109043443.GA4527@liubo>
 <20130109115025.GQ20089@twin.jikos.cz>
 <20130110021747.GB4456@liubo>
 <20130110110458.GA20089@twin.jikos.cz>
 <20130110133436.GB3616@liubo>
 <20130111152516.GK20089@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130111152516.GK20089@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 11, 2013 at 04:25:16PM +0100, David Sterba wrote:
> On Thu, Jan 10, 2013 at 09:34:37PM +0800, Liu Bo wrote:
> > On Thu, Jan 10, 2013 at 12:04:58PM +0100, David Sterba wrote:
> > > This strongly suggests that the warning is connected to the fixes.
> > 
> > Seems that I'm not able to reproduce the warning in running 013,
> > maybe you can revert the two fixes and see if it still warns?
> 
> I'm not running just 013, but the full xfstests repeatedly with varying
> options, so this should be taken into account.
> 
> > I don't think the fixes has anything done with the warning...
> 
> The warning does not show during other tests where the fixes are not
> applied (currently btrfs-next reproducing the csum problems).

Now the warning appeared (btrfs-next on top of 3.8-rc2) at the end of
test 076. Testsuite is cycling over 1-91 without an intermediate mkfs.

david
