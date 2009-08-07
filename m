From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: RAID[56] status
Date: Fri, 07 Aug 2009 16:22:34 +0100
Message-ID: <1249658554.568.214.camel@macbook.infradead.org>
References: <1249553833.568.23.camel@macbook.infradead.org>
	 <774E55AE-1639-4537-B001-E8F96311F4CD@karlsbakk.net>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <774E55AE-1639-4537-B001-E8F96311F4CD@karlsbakk.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2009-08-07 at 11:43 +0200, Roy Sigurd Karlsbakk wrote:
> This is great. How does the current code handle corruption on a drive,
> or two drives with RAID-6 in a stripe? Is the checksumming done per  
> drive or for the whole stripe?

http://git.infradead.org/users/dwmw2/btrfs-raid56.git

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

