Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49183 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456AbcAEJY4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Jan 2016 04:24:56 -0500
Date: Tue, 5 Jan 2016 10:22:36 +0100
From: David Sterba <dsterba@suse.cz>
To: Sanidhya Solanki <jpage.lkml@gmail.com>
Cc: David Sterba <dsterba@suse.cz>, clm@fb.com, jbacik@fb.com,
        dsterba@suse.com, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] BTRFS: Runs the xor function if a Block has failed
Message-ID: <20160105092236.GO4227@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1451456916-16520-1-git-send-email-jpage.lkml@gmail.com>
 <20151230171826.GG4227@twin.jikos.cz>
 <20151230211544.32bc337e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20151230211544.32bc337e@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 30, 2015 at 09:15:44PM -0500, Sanidhya Solanki wrote:
> On Wed, 30 Dec 2015 18:18:26 +0100
> David Sterba <dsterba@suse.cz> wrote:
> 
> > That's just the comment copied, the changelog does not explain why
> > it's ok to do just the run_xor there. It does not seem trivial to me.
> > Please describe that the end result after the code change is expected.
> 
> In the RAID 6 case after a failure, we discover that the failure
> affected the entire P stripe, without any bad data occurring. Hence, we
> xor the previously stored parity data to return the data that was lost
> in the P stripe failure.
> 
> The xor-red data is from the parity blocks. Hence, we are left with 
> recovered data belonging to the P stripe.

If the data a rerecovered, why is -EIO still returned? Also, I see some
post-recovery steps eg. for the damaged P stripes (at label pstripes)
and I'd expect something similar for the case you're fixing.

I'm not familiar with the raid56 implementation but the fix looks
suspiciously trivial and I doubt that the xor was omitted out of
laziness.
