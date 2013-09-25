Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37277 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755174Ab3IYKL1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Sep 2013 06:11:27 -0400
Date: Wed, 25 Sep 2013 12:11:24 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fusionio.com>
Cc: Tomasz Chmielewski <mangoo@wpkg.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs: qgroup scan failed with -12
Message-ID: <20130925101124.GT6810@suse.cz>
Reply-To: dsterba@suse.cz
References: <20130923074344.60f629d7@wpkg.org>
 <20130923171905.GR6810@twin.jikos.cz>
 <20130923174348.GC18681@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130923174348.GC18681@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 23, 2013 at 01:43:48PM -0400, Josef Bacik wrote:
> I've done that with a patch in bugzilla, hopefully that will fix it.  I've not
> had time to try and reproduce myself, but I assume if you do something like
> create a random file, then create 100000 snapshots and then defrag it will
> probably hit the same problem.  Thanks,

The patch looks ok.

I've tried to reproduce it with 100k subvolumes but was not lucky to hit
the allocation failure.


david
