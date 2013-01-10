Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36825 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754379Ab3AJMEv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Jan 2013 07:04:51 -0500
Date: Thu, 10 Jan 2013 13:04:49 +0100
From: David Sterba <dsterba@suse.cz>
To: Russell Coker <russell+btrfs@coker.com.au>
Cc: "linux-btrfs@vger.kernel.org list" <linux-btrfs@vger.kernel.org>
Subject: Re: 2 errors on scrub
Message-ID: <20130110120446.GD20089@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <201301101138.45428.russell+btrfs@coker.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201301101138.45428.russell+btrfs@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 10, 2013 at 11:38:45AM +1100, Russell Coker wrote:
> The below is from a system running the Debian kernel 3.2.0-4-amd64 on a 120G 
> Intel SSD.  What would these 2 errors be?
> 
> scrub device /dev/disk/by-uuid/7939c405-c656-4e85-a6a0-29f17be09585 (id 1) 
> done
>         scrub started at Thu Jan 10 06:00:02 2013 and finished after 295 
> seconds
>         total bytes scrubbed: 25.42GB with 2 errors
>         error details: super=2

The superblock errors are detected but not corrected right away, because
next transaction commit will overvrite it.

Does scub report the errors repeatedly?

There are no other scrub errors reported, I guess there are also no
relevant messages in syslog. During transaction commit scrub is paused,
so it's not possible to verify a half-made superblock.

>         corrected errors: 0, uncorrectable errors: 0, unverified errors: 0

david
