Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60441 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719AbbFRRdf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Jun 2015 13:33:35 -0400
Date: Thu, 18 Jun 2015 19:33:32 +0200
From: David Sterba <dsterba@suse.cz>
To: Mike Fleetwood <mike.fleetwood@googlemail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs-progs 4.1-rc1: btrfstune -u reporting incorrect current
 fsid?
Message-ID: <20150618173332.GJ6761@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAMU1PDjKbbXPrr5uPgPUEzfN+RWxi9McvRLS02N7N9JJ39q2ug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAMU1PDjKbbXPrr5uPgPUEzfN+RWxi9McvRLS02N7N9JJ39q2ug@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 17, 2015 at 10:21:45PM +0100, Mike Fleetwood wrote:
> It also upper cases the UUID where as btrfs fi sh and blkid don't.

Ok, I'll switch that to lowercase so it's consistent with the rest.

> I've done a quick test on changing the UUID of a btrfs.  It worked, but
> btrfstune -u didn't print the same current uuid that btrfs fi sh does.

Seems that the reporting is broken in the btrfstune side. I've
reproduced it here. I've used btrfs-show-super in the tests and did not
notice that the 'current fsid' is wrong. Thanks.
