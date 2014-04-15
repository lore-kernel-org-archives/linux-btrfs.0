Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59009 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210AbaDOQ01 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Apr 2014 12:26:27 -0400
Date: Tue, 15 Apr 2014 18:26:25 +0200
From: David Sterba <dsterba@suse.cz>
To: Alex <alex@bpmit.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: What does scrub do?
Message-ID: <20140415162625.GW29256@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <loom.20140411T105444-935@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <loom.20140411T105444-935@post.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 11, 2014 at 11:23:31AM +0000, Alex wrote:
> People: for auto snapshots use Snapper (a la SUSE) which is now in Debian et
> al. Only peculiarity is that clear-down of daily snapshots only happens in
> the night so you don't need to put many/any hourly snapshots in.

Can be fixed by copying

/etc/cron.daily/suse.de-snapper -> ../cron.hourly

though this would increase the device load, there will be always a
snapshot to clean.

Or you can run the script any time you want to start the cleanup.
