Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:33774 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754461Ab2FNK3R (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jun 2012 06:29:17 -0400
Date: Thu, 14 Jun 2012 12:28:35 +0200
From: David Sterba <dave@jikos.cz>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-btrfs@vger.kernel.org,
        ?????????????? ???????????? <gpall@ccf.auth.gr>,
        663067@bugs.debian.org, miaox@cn.fujitsu.com
Subject: Re: btrfs: filenames collide with snapshot/subvolume names
Message-ID: <20120614102835.GP32402@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1339648469.4942.71.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1339648469.4942.71.camel@deadeye.wl.decadent.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 14, 2012 at 05:34:29AM +0100, Ben Hutchings wrote:
> ?????????????? (Giorgos?) reports:
> > Namely, being inside a snapshot directory, I can't create a file/directory
> > with the name of the snapshot directory.
> > 
> > For example, inside /mnt/aSnap, I can't create a file named 'aSnap', so I'm
> > filling this bug report.
> 
> It seems that the snapshot directory is partially created before the
> snapshot is taken, so that the snapshot directory half-exists (can be
> looked up, but doesn't appear in listings) inside the snapshot itself.

I think it's this one, not merged so far (author CCed)
http://www.spinics.net/lists/linux-btrfs/msg15195.html


david
