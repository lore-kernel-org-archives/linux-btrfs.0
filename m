Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58036 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754155AbbA1UOJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 Jan 2015 15:14:09 -0500
Date: Wed, 28 Jan 2015 14:35:15 +0100
From: David Sterba <dsterba@suse.cz>
To: Jeff Smith <jeff@unbiasedgeek.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Am I missing partiy/redundancy - WARNING: RAID56 detected, not
 implemented
Message-ID: <20150128133515.GF3641@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CABeopkFyVaSAxzgVjXZyqmWAWMG2+mnVXx34w9wEp9mWMjo9Gw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CABeopkFyVaSAxzgVjXZyqmWAWMG2+mnVXx34w9wEp9mWMjo9Gw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 27, 2015 at 02:21:24AM -0700, Jeff Smith wrote:
> I am just getting started with btrfs and wanted to test raid5.  I set
> it up and thought it was setup correctly but when I run " btrfs fi
> usage /mnt/btrdata"  I get the message "WARNING: RAID56 detected, not
> implemented".   Does this mean I have no redundancy?  I know it is
> experimental and I am not relying on it for production data (or data
> that cannot be replaced).  I don't think I do.  When I check the free
> space (3.7TB) it is the same as all the drive together (4x931MB).
> 
> 
> Any assistance in helping me understand would be appreciated greatly.
> 
> -----
> btrfs fi usage /mnt/btrdata
> WARNING: RAID56 detected, not implemented
> WARNING: RAID56 detected, not implemented
> WARNING: RAID56 detected, not implemented

The message is confusing, it means that space reporting for raid56 is
not implemted. I'll fix that, thanks for the report.
