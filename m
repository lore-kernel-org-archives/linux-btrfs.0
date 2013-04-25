Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34566 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757313Ab3DYN1J (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Apr 2013 09:27:09 -0400
Date: Thu, 25 Apr 2013 15:27:05 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fusionio.com>
Cc: Liu Bo <bo.li.liu@oracle.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: only exclude supers in the range of our block
 group V2
Message-ID: <20130425132705.GJ16427@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1366742934-4214-1-git-send-email-jbacik@fusionio.com>
 <20130424085739.GG19283@liubo.jp.oracle.com>
 <20130424130016.GE2631@localhost.localdomain>
 <20130424144321.GI19283@liubo.jp.oracle.com>
 <20130424144809.GI2631@localhost.localdomain>
 <20130425034826.GA24053@liubo>
 <20130425130413.GJ2631@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130425130413.GJ2631@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 25, 2013 at 09:04:13AM -0400, Josef Bacik wrote:
> > Sorry, I still didn't get how this happens...
> > 
> > I'll try to create new btrfs with raid0, raid1, raid10, raid5, raid6...
> > 
> > Could you please show me the testcase or something so that I can persuade
> > myself?
> > 
> 
> Ok I see what happened, I was using an old btrfs-image which makes one big chunk
> to cover the entire file system, so that is how I was getting logical values
> higher than the cache.  So not a normal case for sure, but since it is possible
> for it to happen in a bad file system situation we should still leave it.

I agree, various versions of btrfs-progs are scattered among distros,
kernel would be more robust when mounting a fs image created by an
unknown btrfs-image versoin.

david
