Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:41267 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755615Ab2LMUwK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Dec 2012 15:52:10 -0500
Date: Thu, 13 Dec 2012 15:52:08 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Pascal Junod <pascal@junod.info>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [btrfs] is vulnerable to a hash-DoS attack
Message-ID: <20121213205208.GA27308@shiny>
References: <50C9D085.3020305@junod.info>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <50C9D085.3020305@junod.info>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[ adding linux-btrfs ]

On Thu, Dec 13, 2012 at 05:56:37AM -0700, Pascal Junod wrote:
> Hello folk,
> 
> The btrfs file system, part of the linux kernel, is vulnerable to a
> trivial hash-DoS attack. More details can be found here:
> 
> http://crypto.junod.info/2012/12/13/hash-dos-and-btrfs/

Hi Pascal,

Thanks for taking the time to write this up.  As far as I can tell, the
looping was actually fixed in an older kernel and I just misread our
version string in your original email.

I'll track down the commit that fixed things and send it off to the
stable series.  SuSE and Fujitsu have done a number of error handling
cleanups, it should be one of those.

-chris

