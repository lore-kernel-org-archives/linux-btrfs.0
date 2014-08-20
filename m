Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46517 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbaHTNWn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Aug 2014 09:22:43 -0400
Date: Wed, 20 Aug 2014 15:22:42 +0200
From: David Sterba <dsterba@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/3] btrfs-progs: random fixes of btrfs-filesystem
 documentation
Message-ID: <20140820132242.GE1553@suse.cz>
Reply-To: dsterba@suse.cz
References: <53E888C3.70807@jp.fujitsu.com>
 <53E8F7F0.3060300@redhat.com>
 <20140819151005.GX1553@twin.jikos.cz>
 <53F36E58.1090108@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53F36E58.1090108@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 19, 2014 at 10:33:44AM -0500, Eric Sandeen wrote:
> Seems like using /proc/partitions would make more sense in that case
> than a recursive scan of every file under /dev, wouldn't it?
> Any details on those reports?

It does make sense.

> I'm just wondering when you might possibly have success looking deep
> into the /dev tree if you didn't have success in /proc/partitions.

I haven't figured out any advantage of /dev.

> It just seems a bit bizarre to have so many ways to get the same info.

I think keeping blkid as default and /proc/filesystems as fallback
should cover the usecases. This meanas that the option -d stays, and the
scanning method can be changed to BTRFS_SCAN_PROC (fi show and dev scan).
